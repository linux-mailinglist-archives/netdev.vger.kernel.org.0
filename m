Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD213BD5B9
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbhGFM1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242824AbhGFMDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 08:03:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DD1C0A8885
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 04:38:33 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m0jOz-0004xP-Sv; Tue, 06 Jul 2021 13:38:09 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m0jOw-0008Aw-5G; Tue, 06 Jul 2021 13:38:06 +0200
Date:   Tue, 6 Jul 2021 13:38:06 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer
 value between consecutive TP.DT to 750ms
Message-ID: <20210706113806.tgcijzi5z7kxhiw2@pengutronix.de>
References: <1625569210-47506-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1625569210-47506-1-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:35:02 up 216 days,  1:41, 45 users,  load average: 0.01, 0.04,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 07:00:08PM +0800, Zhang Changzhong wrote:
> For receive side, the max time interval between two consecutive TP.DT
> should be 750ms.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

ACK,
according to: SAE-J1939-21: T1 time is 750ms
according to: ISO 11783-3: T1 time is <=750ms

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index c3946c3..4113229 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1869,7 +1869,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>  		if (!session->transmission)
>  			j1939_tp_schedule_txtimer(session, 0);
>  	} else {
> -		j1939_tp_set_rxtimeout(session, 250);
> +		j1939_tp_set_rxtimeout(session, 750);
>  	}
>  	session->last_cmd = 0xff;
>  	consume_skb(se_skb);
> -- 
> 2.9.5
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
