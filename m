Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5622B6263BA
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiKKViU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKKViT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:38:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE4542F68
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:38:18 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u24so9292685edd.13
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0PY/hIrVyEXZoAed/OcZBz3yTo/Zs2xAryk0pt8P9cc=;
        b=ASRKttC/wra/RSMujkeNoO1QnZyAVyzlJsgLqpuItCZFkComYKMDo5ow2YH5CdZnff
         0JSWMlFio8Zvne7C0T6nom5tfD8D21Y6YUHIsXPPXZ6Vr3PF4irOhGvi6kYsdZp4s2E0
         zV85f7pL+jWWCye+HBvNe6RzSGSiOPvt5go629TAb4EonT2veb6kIpEDDJwx101mdRqT
         UFYaFa0lZV7m1fnYFzdYKEcdnR63NyWukSgdejKl/UDklmaTw+0a47BcDhi0vJ75PRKh
         2tI9zl4uBfVk3F4QmeofEthlsClHnBweZqDNw/C63izYN/LOoK7FhJApkn2BWXdG3Vwf
         MU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PY/hIrVyEXZoAed/OcZBz3yTo/Zs2xAryk0pt8P9cc=;
        b=OnoKFChyYT5FBVJwVXvSg4MywmIBLl3LmmI5YwW27h+dIAN0piCveTMtI1MMyMdNtw
         eBY3FKkmCjn65OdCWnud1IxOroxmMpSI8RKgdz5XdH8sSi3jGBPOIsNkg5lrcGwYofaa
         2l0JLaOakU9lD/ae2NRJq0+bAdlC8dB9V1nF0e7ZoDqTCIbj6240qfCB4hvdmOMwmKTg
         z/Od2AVp9pnEcTuO2wBpLYJ89WdyS1KV9SNhNpTQPYrmiVa1BbhMv4nuI/vLNKkqYo3T
         R5l2j/HaVnW6UoEDoL6B5XdVyDH7fUs0rEaFf4/AB6dakEchlwJkrsdSp5vkgETMttTJ
         kghQ==
X-Gm-Message-State: ANoB5pmM/5PuCvs7j1KRF27+e7LKVvnvmZ+Z+whuE0+CuKV6VLepvjnE
        kVcDL36E93cf995VJr4euUQ=
X-Google-Smtp-Source: AA0mqf4OLsqdYekJCuHXzG3dF0D2xg+t/o/nT+azfKDB3RI7dmM8gFLiHZmyxgcWDcWM8RcblSzZfQ==
X-Received: by 2002:a05:6402:378b:b0:459:9792:a3a9 with SMTP id et11-20020a056402378b00b004599792a3a9mr3144415edb.341.1668202696962;
        Fri, 11 Nov 2022 13:38:16 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id qq18-20020a17090720d200b0077205dd15basm1296312ejb.66.2022.11.11.13.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 13:38:16 -0800 (PST)
Date:   Fri, 11 Nov 2022 23:38:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Message-ID: <20221111213813.jfelkktkj5wk45qy@skbuf>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-4-lukma@denx.de>
 <20221108091220.zpxsduscpvgr3zna@skbuf>
 <Y2pbc90XD5IvZZC0@lunn.ch>
 <20221110180053.0cb8045d@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110180053.0cb8045d@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 06:00:53PM +0100, Lukasz Majewski wrote:
> Maybe in the generic case of PHY, yes (via Driver Model).
> 
> However, when you delve into the mv88e6xxx driver [1] - you would find
> that this is not supporting it yet ...
> 
> As fair as I know - for the driver [1] - there was no ongoing effort
> recently.
> 
> Links:
> [1] -
> https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/net/phy/mv88e61xx.c

U-Boot mailing list is moving a bit slower than netdev (and the patch
set is not yet applied despite being ready), but I was talking about
this:
https://patchwork.ozlabs.org/project/uboot/list/?series=324983

If you study DM_DSA, you'll see that only supporting PHY connection via
phy-handle (even if the PHY is internal) (or fixed-link, in lack of a
PHY) was an absolutely deliberate decision.
