Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADFE673623
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjASKzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjASKzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:55:11 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E656FF9B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:55:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bk16so1431384wrb.11
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=W2iLqxzBf2lt/ncg4h7D713Xr/C62DP8hgV7AbUocoI=;
        b=P5LppqRYfNZ6ipt7+ZeQwYBdFqfSnUFgGDqlQvZ4vusjXWwLO9BYeS5+93bNYfRRmh
         qWajrm+xWAbEHdcQlzRE2FFz4nN4nVoMWfAYRfKyZWCOB7S7uTT3SsJKD/yS88bdZbom
         kXVs014BApTave9Lv2C7QjqXXZoNVvbE5BRUf43hOizXTkAElkuep4PNbXZKv/Y6iCKt
         wDb/QsJFjYQRj5xYFjIabG/FfeLBniAWjlxYCj3ASQVfoy4d31yHz4MPpWhiWqVaPS82
         Y73Sq/Gf5Fbg7LC7AlenM9EXejEZpPWaaLpvwSWTl8Ie9KkIHrGGQ3DdRsjCnUWuJ1E2
         38Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2iLqxzBf2lt/ncg4h7D713Xr/C62DP8hgV7AbUocoI=;
        b=FqrIM977aI5EXKPTZL9BCgfvYO2jAgjpEPAfHORy2WCo1brPWOPfvAzdJttSK1UUj8
         WUAWq+jI96a3368vgJLQPGuSdoZX/S+O4DZlhVNcGDN0adbHHxzcMhoNieCkB0XUD1hb
         FE4qoE/xM2aERLDZXv1wbPsQVjultin5JeILqrREWlUvRXD3pF1CPD58cZnU0XVKuR2U
         tY9q8+d7suuuIEN4blHh5l0gsbm5mU2RNCgpDRU/FVwHqQuDUEKgehkEi1BTfPdkG4l8
         pdvMH39JDoH4fkJPGemZswaIt0XayYWWqYudc+uh0TZHYtvbBdeLOIdF7owq3Kmi3m/s
         dN5Q==
X-Gm-Message-State: AFqh2kpk6ct4SuHufrxjlidOQi83ZuWTYf6KQbUF5ATUQtRHuaNLTSGQ
        IW08J6F6bchlLHMi7IKpR1c/Hg==
X-Google-Smtp-Source: AMrXdXtKFaRuKk7aQfl2q8ApDCvIPRIpAPBN2Nc4ZtdNxVZ0nz3wqSUr8VfedhOedhFNga6qKAibsw==
X-Received: by 2002:a5d:6545:0:b0:2bb:5d8c:9575 with SMTP id z5-20020a5d6545000000b002bb5d8c9575mr8403717wrv.12.1674125708342;
        Thu, 19 Jan 2023 02:55:08 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600003cd00b002be07cbefb2sm11691659wrg.18.2023.01.19.02.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 02:55:07 -0800 (PST)
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <Y8dimCI7ybeL09j0@lunn.ch>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mdio: add amlogic gxl mdio mux support
Date:   Thu, 19 Jan 2023 11:42:11 +0100
In-reply-to: <Y8dimCI7ybeL09j0@lunn.ch>
Message-ID: <1jr0vqyet1.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 18 Jan 2023 at 04:08, Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Jan 16, 2023 at 10:16:34AM +0100, Jerome Brunet wrote:
>> Add support for the MDIO multiplexer found in the Amlogic GXL SoC family.
>> This multiplexer allows to choose between the external (SoC pins) MDIO bus,
>> or the internal one leading to the integrated 10/100M PHY.
>> 
>> This multiplexer has been handled with the mdio-mux-mmioreg generic driver
>> so far. When it was added, it was thought the logic was handled by a
>> single register.
>> 
>> It turns out more than a single register need to be properly set.
>> As long as the device is using the Amlogic vendor bootloader, or upstream
>> u-boot with net support, it is working fine since the kernel is inheriting
>> the bootloader settings. Without net support in the bootloader, this glue
>> comes unset in the kernel and only the external path may operate properly.
>> 
>> With this driver (and the associated DT update), the kernel no longer relies
>> on the bootloader to set things up, fixing the problem.
>
> Ideally, you should also post an actual user of this driver, i.e. the
> DT updates.

I usually avoid doing this since the DT part is intended for another
maintainer. The idea is make life easy for them and let them pick the
entire series (or not). I don't mind sending the DT update along if it
is the perferred way with netdev.

FYI, the DT update would look like this :
https://gitlab.com/jbrunet/linux/-/commit/1d38ccf1b9f264111b1c56f18cfb4804227d3894.patch

>
>> This has been tested on the aml-s905x-cc (LePotato) for the internal path
>> and the aml-s912-pc (Tartiflette) for the external path.
>
> So these exist in mainline, which is enough for me.

Yes the boards exists in mainline, there are still using the mdio-mux-mmioreg driver
ATM

>
>    Andrew

