Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76DB28AF5D
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgJLHlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:41:49 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:19479 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgJLHll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602488499;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2CQdP0Sf2MdF3PeDqGdq4RZG464P2CZWTKHkFJPpzPc=;
        b=lVUiShoTMJUa9as6qetTt0pbZsj6RYISyl9rG4upz2Mxp21SsFe7GTe/U4YnmYGOKq
        CN6gHZBx3T9i/vBc78HNMmePsf5l5I/2hJ7rfntNGcDsanq+9/4wU1wydXVVOO+O9Dk3
        HNr2okACGM1OgbbkqCRn/7QXIC58DEDKcf7mCgQ23r9n8pV9zmEU0SOuQljlxYFQZ9PA
        KN38Xm7ietpefTgxFzAOi2rkkxZ+NMoMVQ95W74XWIsCR6uJ2CcAUS3lnKJLcSJgptvw
        PUiK1okv1tc4YOQAXey15hbCBFnnvNyq6Cy5wblKiUu7gg+YOSSTttMClx92bax8PkE8
        pMLQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVxiOM9spw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9C7fMOKc
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 12 Oct 2020 09:41:22 +0200 (CEST)
Subject: Re: [PATCH net-next v2 1/2] can-isotp: implement cleanups /
 improvements from review
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mkl@pengutronix.de, davem@davemloft.net,
        linux-can@vger.kernel.org
References: <20201011092408.1766-1-socketcan@hartkopp.net>
 <20201011084458.065be222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <cc2250dd-5297-ee00-bbac-11e8865c600d@hartkopp.net>
Date:   Mon, 12 Oct 2020 09:41:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201011084458.065be222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11.10.20 17:44, Jakub Kicinski wrote:
> On Sun, 11 Oct 2020 11:24:07 +0200 Oliver Hartkopp wrote:
>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>> index e6ff032b5426..22187669c5c9 100644
>> --- a/net/can/isotp.c
>> +++ b/net/can/isotp.c
>> @@ -79,6 +79,8 @@ MODULE_LICENSE("Dual BSD/GPL");
>>   MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
>>   MODULE_ALIAS("can-proto-6");
>>   
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> You need to move this before the includes:
> 
> net/can/isotp.c:82: warning: "pr_fmt" redefined
>     82 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>        |
> In file included from ../include/linux/kernel.h:15,
>                   from ../include/linux/list.h:9,
>                   from ../include/linux/module.h:12,
>                   from ../net/can/isotp.c:56:
> include/linux/printk.h:297: note: this is the location of the previous definition
>    297 | #define pr_fmt(fmt) fmt
>        |
> net/can/isotp.c:82:9: warning: preprocessor token pr_fmt redefined
> net/can/isotp.c: note: in included file (through ../include/linux/kernel.h, ../include/linux/list.h, ../include/linux/module.h):
> include/linux/printk.h:297:9: this was the original definition
> 

Hm - don't know why my build process didn't complain about it. Or why I 
possibly overlooked it.

I'll do the cosmetic pr_fmt() improvements for the entire CAN network 
layer stuff later as it is not relevant for this net-next window.

The v3 patch will fix the GFP_ATOMIC too.

Thanks for your patience,
Oliver

