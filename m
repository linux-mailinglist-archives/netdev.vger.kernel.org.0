Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7512A968
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLZAeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 19:34:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfLZAeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 19:34:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AFFD15386613;
        Wed, 25 Dec 2019 16:34:12 -0800 (PST)
Date:   Wed, 25 Dec 2019 16:34:11 -0800 (PST)
Message-Id: <20191225.163411.1590483851343305623.davem@davemloft.net>
To:     AWilcox@Wilcox-Tech.com
Cc:     netdev@vger.kernel.org, linux-api@vger.kernel.org,
        musl@lists.openwall.com
Subject: Re: [PATCH] uapi: Prevent redefinition of struct iphdr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 16:34:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
Date: Sun, 22 Dec 2019 00:02:27 -0600

> @@ -83,6 +83,13 @@
>  
>  #define IPV4_BEET_PHMAXLEN 8
>  
> +/* Allow libcs to deactivate this - musl has its own copy in <netinet/ip.h> */
> +
> +#ifndef __UAPI_DEF_IPHDR
> +#define __UAPI_DEF_IPHDR	1
> +#endif

How is this a musl-only problem?  I see that glibc also defines struct iphdr
in netinet/ip.h, so why doesn't it also suffer from this?

I find it really strange that this, therefore, only happens for musl
and we haven't had thousands of reports of this conflict with glibc
over the years.

I want an explanation, and suitably appropriate adjustments to the commit
message and comments of this change.

Thank you.
