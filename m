Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC616E25B8
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjDNO2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjDNO2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:28:42 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BF6CC32
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681481704; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=D0YEDiedR6keyvtyUfnGXXu/HY1VBup7X/a6Tslu9ZbXRL1xPighBqeBJ2zAMmVH+B
    +wrK4+ZMChlBHZ6ud5+5ISbpP+CPG/CZu0OmF31aGKTUZkPd47rj3fwObXA5ZPCJIkOp
    pbgk8VOnF4DUGdFAPovQazz/CvJyDG4NdZFL8Re3MlIqjjHmTjegQ1Jlc2mcgbmE87rA
    xSPwT1plnWXYYjOf98rQIRDUaupvZCFgynJdmM3fNuqgcu4n1+ByU2OCGu12d2lqNtZi
    UXTwP0yfL8Fc52nn5QyV8hc5HFflF1pYNZiuN1Nr4lJHcjZPWzCxS2kaLcvLDAK1HBwj
    iiBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681481704;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=U37axNZ2rkIrocKOnrqWmPEcas0XgRB0vLSxvdTbGXQ=;
    b=KWpdo25+B3ALheiRJBN2Jy2VA4zK/wmqUtBHyb22TFOzvZzFeSOGHdBBW2KC3LVVQB
    Lf5CXwJ2lEVv866RxxraxGJ1gaev5LA2cJ+xxpgVWHuYfYtYoEDgZYN5zxlkRuNAaz5M
    60fg6AZZKJ2lvOzhIXTlvemfHEtqbJswEvuS0S/xxm89zerQfwf9bI/ezU+HFlQeWsLt
    CQanUBE542wVlxuCOSXJZ2q/2Uk53VXgMcXTHL2CgbOzpArx/6dfVC+tQ8a3a57gHAQB
    HWhTVEMvrRVqZC2nWcYKlHJC3VK+HBVxkx9VAR6i46LzIL17nEL8w5UT0pRdj4WSJ/zS
    3Vhg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681481704;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=U37axNZ2rkIrocKOnrqWmPEcas0XgRB0vLSxvdTbGXQ=;
    b=RkfB2eOelQQeFe/CnoZwFgv50RinoHYl3uN/suMfh9iZGXOnlrec5Y6evDdwCcb+qu
    Cwgz/0zKf/uVRBzAkG6plPpUAPGu2We7U0q2vweofTVJnpZl0gnkrv53oTqvZxu7QIg8
    sKRu5GflwHc8VUmYrO4aQVbKUAVrcd5v9NmdnnBA5qOqJg5oHhaazt2OAzYlXx8o8zMW
    EkMZmkp51T6SVaqK9x6Dvascj5bmcOGU7kOs4AD5SnRm8UXQqO7loprYkGm4emBEFZRd
    +5zqjfw11CrAnwo3YzsYgVK6Dm6Jf+EURd8FffFapT8bn8De21Xh+liVudKKpkdVqxqx
    yKaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681481704;
    s=strato-dkim-0003; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=U37axNZ2rkIrocKOnrqWmPEcas0XgRB0vLSxvdTbGXQ=;
    b=df5qnkOYSbLPjU10RVfdWvQRdOHeATwa2EWyA63cVEMr67/TSM2RGXnHogWdENYFAQ
    iDPE59pMpYlLBKXVw8AA==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJD4paA8p+F1A=="
Received: from gerhold.net
    by smtp.strato.de (RZmta 49.4.0 DYNA|AUTH)
    with ESMTPSA id j6420az3EEF4X8l
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 14 Apr 2023 16:15:04 +0200 (CEST)
Date:   Fri, 14 Apr 2023 16:14:56 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     jbreva@nayarsystems.com
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wwan: Expose secondary AT port on DATA1
Message-ID: <ZDlf4Kutl511lIQ_@gerhold.net>
References: <20230414-rpmsg-wwan-secondary-at-port-v1-1-6d7307527911@nayarsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414-rpmsg-wwan-secondary-at-port-v1-1-6d7307527911@nayarsystems.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 01:07:40PM +0200, Jaime Breva via B4 Relay wrote:
> From: Jaime Breva <jbreva@nayarsystems.com>
> 
> Our use-case needs two AT ports available:
> One for running a ppp daemon, and another one for management
> 
> This patch enables a second AT port on DATA1
> 
> Signed-off-by: Jaime Breva <jbreva@nayarsystems.com>

Acked-by: Stephan Gerhold <stephan@gerhold.net>

Thanks,
Stephan

> ---
>  drivers/net/wwan/rpmsg_wwan_ctrl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
> index 31c24420ab2e..e964bdeea2b3 100644
> --- a/drivers/net/wwan/rpmsg_wwan_ctrl.c
> +++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
> @@ -149,6 +149,7 @@ static const struct rpmsg_device_id rpmsg_wwan_ctrl_id_table[] = {
>  	/* RPMSG channels for Qualcomm SoCs with integrated modem */
>  	{ .name = "DATA5_CNTL", .driver_data = WWAN_PORT_QMI },
>  	{ .name = "DATA4", .driver_data = WWAN_PORT_AT },
> +	{ .name = "DATA1", .driver_data = WWAN_PORT_AT },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(rpmsg, rpmsg_wwan_ctrl_id_table);
> 
> ---
> base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
> change-id: 20230414-rpmsg-wwan-secondary-at-port-db72a66ce74a
> 
> Best regards,
> -- 
> Jaime Breva <jbreva@nayarsystems.com>
> 
