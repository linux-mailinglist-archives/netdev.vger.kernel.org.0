Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914CF2256D4
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 06:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgGTE4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 00:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgGTE4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 00:56:32 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C620D20758;
        Mon, 20 Jul 2020 04:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595220991;
        bh=WpIzzTN6scE+2UyxOf2po3oTZMeSCPUMdXbQ6YleutA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ceHbdgk5deba4gxNstdXo0DOLPpRIEt5yb2TkzfUCzLpZcuJJi26TLNNeZ6O1+g7i
         SVybg+YC7wjkXApW0jXI/mVdHMUTNjj5XCAooiwVJDzIEFyx+jqZ1G4or2+4EzrOT5
         0bvkNyBGQhjqX7yfB3Km7pW2/V1DmlYJmw5jDBCI=
Date:   Mon, 20 Jul 2020 07:56:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
Message-ID: <20200720045626.GF127306@unreal>
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200719155845.59947-1-grandmaster@al2klimov.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 05:58:45PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
>
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
>
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
>
>  If there are any URLs to be removed completely
>  or at least not (just) HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
>
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
>
>  If you apply the patch, please let me know.
>
>  Sorry again to all maintainers who complained about subject lines.
>  Now I realized that you want an actually perfect prefixes,
>  not just subsystem ones.
>  I tried my best...
>  And yes, *I could* (at least half-)automate it.
>  Impossible is nothing! :)
>
>
>  Documentation/networking/rds.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Why can't it be done in one mega-patch?
It is insane to see patch for every file/link.

We have more than 4k files with http:// in it.

➜  kernel git:(m/hw-cleanup) git grep -c http: | tr -d ':[:digit:]' | sort | uniq |wc -l
4292


>
> diff --git a/Documentation/networking/rds.rst b/Documentation/networking/rds.rst
> index 44936c27ab3a..c80d832509e2 100644
> --- a/Documentation/networking/rds.rst
> +++ b/Documentation/networking/rds.rst
> @@ -11,7 +11,7 @@ This readme tries to provide some background on the hows and whys of RDS,
>  and will hopefully help you find your way around the code.
>
>  In addition, please see this email about RDS origins:
> -http://oss.oracle.com/pipermail/rds-devel/2007-November/000228.html
> +https://oss.oracle.com/pipermail/rds-devel/2007-November/000228.html
>
>  RDS Architecture
>  ================
> --
> 2.27.0
>
