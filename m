Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63516364A6E
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 21:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbhDSTUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 15:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241574AbhDSTUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 15:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9247661354;
        Mon, 19 Apr 2021 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618860009;
        bh=QDUwo8sOndYUnQLq0RjqCgvqoLRR5L/IEVGoyO+b1cI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HX8+vB159BjswIyfAGWUkb9ZGy/bUNXtp5GGMk6q10/SzjDJAJUTm06n95MF80IUG
         7NCIf7LgPTHmIdS2FqLwr52Am59daKy4bW3Vj1gjlMArn/coNKbE4efRrCAJboWmi0
         7JZv3v3RDYIwhdphf1z9Bc93lJKqRWOzt0/j0/qe8U5WIUOpMt0H2Un2SEEn18OW0b
         gqGX3dhxMHVop6Q3l6xUwz5F0mxBL2sNcMQT2ux6k8y37CATAtGOcNEGBQkHgB1Q42
         vR7Fcmaca9ImufyM4HqG/kn/3zJLe8YTD1KEwPz69tWOUzBTU4syaexOaThPi/ldRb
         Aj4fVA2rEWIPw==
Date:   Mon, 19 Apr 2021 12:20:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, idosch@nvidia.com,
        saeedm@nvidia.com, michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <20210419122007.33d7579b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210417201039.5ypk7efz7f57mowe@lion.mk-sys.cz>
References: <20210416192745.2851044-1-kuba@kernel.org>
        <20210416192745.2851044-4-kuba@kernel.org>
        <YHsXnzqVDjL9Q0Bz@shredder.lan>
        <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YHsutM6vesbQq+Ju@shredder.lan>
        <20210417121520.242b0c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210417121808.593e221d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210417201039.5ypk7efz7f57mowe@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 22:10:39 +0200 Michal Kubecek wrote:
> On Sat, Apr 17, 2021 at 12:18:08PM -0700, Jakub Kicinski wrote:
> > Heh, I misunderstood your question. You're asking if the strings can be
> > queried from the command line.
> > 
> > No, I don't think so. We could add some form of "porcelain" command if
> > needed.  
> 
> We don't have such command but I think it would be useful. After all, as
> you pointed out, the request is already implemented at UAPI level so all
> we need is to make it available to user.
> 
> The syntax will be a bit tricky as some string sets are global and some
> per device. Out of
> 
>     ethtool --show-strings [devname] <setname>
>     ethtool --show-strings [devname] set <setname>
>     ethtool --show-strings <setname> [dev <devname>]
> 
> the third seems nicest but also least consistent with the rest of
> ethtool command line syntax. So probably one of the first two.

Hm. Tricky. Option 4 would be to add a sub-command for low-level
requests, to break with standard requests clearly?

ethtool --internals get-strset set X [dev Y]

