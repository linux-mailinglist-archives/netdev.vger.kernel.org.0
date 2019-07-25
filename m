Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A9574E39
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 14:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388101AbfGYMhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 08:37:16 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:42093 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387879AbfGYMhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 08:37:16 -0400
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id 1C40E20189;
        Thu, 25 Jul 2019 14:37:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1564058230; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UVgDTgXpZftxZj5PSd3SJLn5lHcIib7UokaOjJyMv4=;
        b=LUbBKpuJB9AktmW/EtX8M5ugsbS3KVo9VZDilLOw7T9kaZ0clL7Hc8a7/cao7qNMG6XuiA
        FZSS6Da4ZHxZNLunYtOgBjPBKfYHpt0+e2xqCh8pkcgLcL5ydK3qjG4TXj3oCpQkDGv6Su
        pojtDT3Wh3064Ba7jy7/LkOJLfQYBCQtXG2IZuf7+2Ylfwc4dzHtOjCMvncvQDtW673pU1
        aqMcWH8BMpm3U8L+jemKezvs2cISdvOHTzRjMOLifxa0rqu585esoLVzPJOyLOX3Axaj7M
        oHi3WfVrxZmLhLHHi6+L77MEUHHCudVrJ0ayA5zIzKNr9Kdc4aYMhZoP+BNcTA==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id 57F4ABEEBD;
        Thu, 25 Jul 2019 14:37:09 +0200 (CEST)
Message-ID: <5D39A274.1000800@bfs.de>
Date:   Thu, 25 Jul 2019 14:37:08 +0200
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Colin King <colin.king@canonical.com>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] can: kvaser_pciefd: remove redundant negative check
 on trigger
References: <20190725112509.1075-1-colin.king@canonical.com>
In-Reply-To: <20190725112509.1075-1-colin.king@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.10
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-0.10 / 7.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         BAYES_HAM(-0.00)[44.90%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.999,0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_TLS_ALL(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 25.07.2019 13:25, schrieb Colin King:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check to see if trigger is less than zero is always false, trigger
> is always in the range 0..255.  Hence the check is redundant and can
> be removed.
> 
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/can/kvaser_pciefd.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
> index 3af747cbbde4..68e00aad0810 100644
> --- a/drivers/net/can/kvaser_pciefd.c
> +++ b/drivers/net/can/kvaser_pciefd.c
> @@ -652,9 +652,6 @@ static void kvaser_pciefd_pwm_stop(struct kvaser_pciefd_can *can)
>  	top = (pwm_ctrl >> KVASER_PCIEFD_KCAN_PWM_TOP_SHIFT) & 0xff;
>  
>  	trigger = (100 * top + 50) / 100;
> -	if (trigger < 0)
> -		trigger = 0;
> -
	to be fair i do not understand the calculation here here.
	(100*top+50)/100 = top+50/100

	but seems to be int so it should be =top

	did i missunderstand something here ?

	re,
	 wh


>  	pwm_ctrl = trigger & 0xff;
>  	pwm_ctrl |= (top & 0xff) << KVASER_PCIEFD_KCAN_PWM_TOP_SHIFT;
>  	iowrite32(pwm_ctrl, can->reg_base + KVASER_PCIEFD_KCAN_PWM_REG);
