Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FFC178384
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbgCCT6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:58:52 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:19005 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgCCT6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:58:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583265527;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8Hy1XQLrJGsksa411iFwtMtrZlW3bx5jx6/bcEnxtb4=;
        b=sBcGbiT8AYYFcnVmC+hMtzuAg4bK/te2JNS9bVe4bYliNcrh+168VzQPkAN91UBosN
        RVWlRdNceAileGqFjXzk3h9vkVOkqgrmSzpL/ilhxT3O22bMxz8xMRLw2RxE7HylMZxZ
        qutdL/2TVvlXo/3a3rnjNKMJEWiEsl7nGJwzfl9IgYRVBR7BHPw+xDQtZ/tDPqqEt+iy
        mHebCfHl/eMUBwpHGTYvdEvvG7J+rFlv1Uz7ewQGjcw18HK6msa+79UZITD1vk1Ujvwg
        wl/4sF+CsXZYlmJlJgqoUIhW9hkejaMv1IyTql51DhYk2aiCm2bekiV5Bv67I1ZQvR8t
        7Z5g==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5lU8W"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id e0a4ffw23JwYE3G
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 3 Mar 2020 20:58:34 +0100 (CET)
Subject: Re: [PATCH net 06/16] can: add missing attribute validation for
 termination
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-7-kuba@kernel.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <c5842943-f11b-0d42-d03d-71930a7ecc3e@hartkopp.net>
Date:   Tue, 3 Mar 2020 20:58:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303050526.4088735-7-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/03/2020 06.05, Jakub Kicinski wrote:
> Add missing attribute validation for IFLA_CAN_TERMINATION
> to the netlink policy.
> 
> Fixes: 12a6075cabc0 ("can: dev: add CAN interface termination API")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Wolfgang Grandegger <wg@grandegger.com>
> CC: Marc Kleine-Budde <mkl@pengutronix.de>
> CC: Oliver Hartkopp <socketcan@hartkopp.net>
> CC: linux-can@vger.kernel.org
> ---
>   drivers/net/can/dev.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 6ee06a49fb4c..68834a2853c9 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -883,6 +883,7 @@ static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
>   				= { .len = sizeof(struct can_bittiming) },
>   	[IFLA_CAN_DATA_BITTIMING_CONST]
>   				= { .len = sizeof(struct can_bittiming_const) },
> +	[IFLA_CAN_TERMINATION]	= { .type = NLA_U16 },
>   };
>   
>   static int can_validate(struct nlattr *tb[], struct nlattr *data[],

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Jakub for catching all these missing defs!

Best regards,
Oliver
