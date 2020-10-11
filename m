Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E428A803
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 17:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgJKPpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 11:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgJKPpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 11:45:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72DEC22227;
        Sun, 11 Oct 2020 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602431100;
        bh=m9czVHQzjCUW/4Q7vExkMd3mGcT9XtV+6UaDcGwHc/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gLOkU640NA0v+QwgA13KItw6y3T4tiDj8DqPsTEDe1pIl5Lzap9IQLkREhdcGAyD2
         irmMPYq621e7bWpSZa6/WtBqcfhzhN2rmdWUlo7f8QMSqaLbmcRn1xGEE4lkbrbwwW
         z3Wl2bXudFcvosialI5/TRv/glvkRE4mDnRW0JWE=
Date:   Sun, 11 Oct 2020 08:44:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, mkl@pengutronix.de, davem@davemloft.net,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] can-isotp: implement cleanups /
 improvements from review
Message-ID: <20201011084458.065be222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011092408.1766-1-socketcan@hartkopp.net>
References: <20201011092408.1766-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 11:24:07 +0200 Oliver Hartkopp wrote:
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index e6ff032b5426..22187669c5c9 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -79,6 +79,8 @@ MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
>  MODULE_ALIAS("can-proto-6");
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

You need to move this before the includes:

net/can/isotp.c:82: warning: "pr_fmt" redefined
   82 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
      | 
In file included from ../include/linux/kernel.h:15,
                 from ../include/linux/list.h:9,
                 from ../include/linux/module.h:12,
                 from ../net/can/isotp.c:56:
include/linux/printk.h:297: note: this is the location of the previous definition
  297 | #define pr_fmt(fmt) fmt
      | 
net/can/isotp.c:82:9: warning: preprocessor token pr_fmt redefined
net/can/isotp.c: note: in included file (through ../include/linux/kernel.h, ../include/linux/list.h, ../include/linux/module.h):
include/linux/printk.h:297:9: this was the original definition
