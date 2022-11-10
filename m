Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C4E6242C7
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiKJNDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiKJNDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:03:32 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3041D5F;
        Thu, 10 Nov 2022 05:03:30 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id q9so4938134ejd.0;
        Thu, 10 Nov 2022 05:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uyUdvAvFfBedY8C4R1CoGalnnZqFS5BS9edNzqJV4LE=;
        b=awdpZzgHXvaGozAEQ7Mhh+xLeFZETbddCE0K8LRU2+3No7vqY150um9E3Wv9NcyQ7s
         nGL5IWErgErtYri2MC8wDzOo97mCzWnXKQMVZOAO3ANSJRNRptLrIMMMVt5h3dMmhosP
         lnCBTnpC1EXf5R37OWxCzm+/OdrFkPgnmBLVrCfukeQVDFhk6SUbMb8BQqgftzxVQ5aS
         q/WJZoX9lhFPZM33HVCqyZvBzUfTRizH/gyh5EsuPJXq0NKW1sxF4jS66WtXtFapcpce
         zHG0OXZxJe7S+gC6gBK8lGmtIKrlLbLyzUuFFHREPxRi6PH0bYPHDftG1pcf8HQGJQFf
         D1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uyUdvAvFfBedY8C4R1CoGalnnZqFS5BS9edNzqJV4LE=;
        b=PsI+2xCNUx6pKO7112l4GFsD6j8eXKLsgVUYSoKxCaqkbhmiYelk7i2cVIAY9w0Y78
         JehgATYFfNOnuv8nuotO/jiSCefQsW6G759ulqD+TZL+xaRfpj9FvvLM7gmeDdpdYQFb
         yO4OLKA4A4eeOZLek8WSpv2mTgbbCz66vd4YdhiV7pGnVvcoQPIbsfabeCbrNCkuKoRt
         zlRQa2KHQJW/LiYeexPOguLx2exEe1U0fE+T0H2PP7YMXbzk38MWOQrfIZwPBMtMC4xQ
         EKcdf0pCMMrNEoUGPSCS11ayLXdoXWs18xNy9QNeKramdIpUw4TeL6tox7hKZOiOeCB1
         3EOw==
X-Gm-Message-State: ACrzQf0w6016urg7W2/nIZn0gwofNiPD315CHYj3d1u0c/GMGAlfPFIw
        DQxFcL/YBfJ0/BF4WL32f8wY3jACXUWkjQ==
X-Google-Smtp-Source: AMsMyM7++wpVmQYXlt19QPfZpFWmMAEBnh2TTX2mVhSsGh06HveYGqp/+mmMQax4PgLmQurDWPpsgg==
X-Received: by 2002:a17:906:79c4:b0:782:7790:f132 with SMTP id m4-20020a17090679c400b007827790f132mr2747677ejo.649.1668085409325;
        Thu, 10 Nov 2022 05:03:29 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l26-20020aa7c3da000000b0045bccd8ab83sm8622082edr.1.2022.11.10.05.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:03:28 -0800 (PST)
Date:   Thu, 10 Nov 2022 15:03:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: dsa: microchip: ksz8: add MTU
 configuration support
Message-ID: <20221110130325.eklhybumv7naehxe@skbuf>
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110122225.1283326-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 01:22:25PM +0100, Oleksij Rempel wrote:
> Make MTU configurable on KSZ87xx and KSZ88xx series of switches.
> 
> Before this patch, pre-configured behavior was different on different
> switch series, due to opposite meaning of the same bit:
> - KSZ87xx: Reg 4, Bit 1 - if 1, max frame size is 1532; if 0 - 1514
> - KSZ88xx: Reg 4, Bit 1 - if 1, max frame size is 1514; if 0 - 1532
> 
> Since the code was telling "... SW_LEGAL_PACKET_DISABLE, true)", I
> assume, the idea was to set max frame size to 1532.
> 
> With this patch, by setting MTU size 1500, both switch series will be
> configured to the 1532 frame limit.
> 
> This patch was tested on KSZ8873.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

As an extension to this patch set, you might also want to set
ds->mtu_enforcement_ingress = true, to activate the bridge MTU
normalization logic, since you have one MTU global to the entire switch.
