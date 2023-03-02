Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39C46A8B75
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 23:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCBWGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 17:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjCBWGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 17:06:04 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE63C21
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 14:06:01 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id w23so929975qtn.6
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 14:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677794760;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gCHnTEeviL4NRXbneyLnnPfP5LV7/n3YU8jjRyLbZpQ=;
        b=ciX4qiqpAUIijDJugC6btyvH1Pva5DtSk4OggvowrWTyTltXSaIEQVp4gCslD/nf1t
         9YWODFh6/H1pOCqvTjmTm6DoMSEGGzPaZDvOcfL31AmomXWp+GjoFyDx3dma+wz2wGVC
         X5hZnptorlF33IDHGOcgOZE+9MoW63Lv1h8dRrTJIRPrCgBE1qpi4+vk0U5TBIQXhrdy
         ShgnYLWpyOINUvGq8dynXQ/iuI8wh9da1+UMpAnUJlNX0AP0jFNUSU/G88tboh1g/ocn
         vHv4baQRYwIhy3TsxCy7MrecBka1XUZIMFk0JsTqNjrxkfMB487mPw0EXQs4Mn6KJ4ol
         1dbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677794760;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCHnTEeviL4NRXbneyLnnPfP5LV7/n3YU8jjRyLbZpQ=;
        b=HW5uRafjvyt+sW04NKJzU3PTfQtjRUswd/W+95tng1SoubidGLTl6wubXF84dgtEY4
         kg1Vlt6I8zdal3JuwRct4ERd6O/CWoax1X2hYDi2SZXA9XcaxIUlWr4ziyyZ6wnNcaWv
         kxw92nH1whe6Jgw5A4XnNv1e5DLB9jr9J4IkHy7xtHA7nQqywWzsZi3ZyiK0pg9sxQzh
         /XIa+SNUn9HjQS6zipA/U2mb3T0xMBjbe3JF5hNZxVnhPmoOrBL4wVyVmht6WaYtTnfu
         8jBvl14zRADS2tMUrWknEnzz1S/S8p8WcmD/8vZuudTGHI3dxBZorDOMXU4k2BalL2Pq
         FhHg==
X-Gm-Message-State: AO0yUKVIr1j0sP0EbFP+cS7aKrkKccyXCZAlwsSJS7JAaqmUv07t/m5x
        FNgNBPjmW0aPpAdabdrbDzWL1Fjr/zM=
X-Google-Smtp-Source: AK7set/GTPSTpxvlmTeRSZZy266kc9RzHpzSPZYwrY1V1GBZ1N8knajnoNrUzX9zG43KXc3ukm5lKA==
X-Received: by 2002:a17:903:32c4:b0:19a:a2e7:64de with SMTP id i4-20020a17090332c400b0019aa2e764demr12685143plr.0.1677792950836;
        Thu, 02 Mar 2023 13:35:50 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b001992b8cf89bsm154094plk.16.2023.03.02.13.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 13:35:50 -0800 (PST)
Date:   Thu, 2 Mar 2023 13:35:47 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <ZAEWs041NRZkc4Xx@hoboy.vegasvil.org>
References: <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20230302113752.057a3213@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230302113752.057a3213@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 11:37:52AM +0100, Köry Maincent wrote:

> On my side with a zynqMP SOM (cadence MACB MAC) the synchronization of the PHY
> PTP clock is way better: +/-50ppb. Do you have an idea about the difference? 
> Which link partner were you using? stm32mp157 hardware PTP on my side.

The predecessor Zynq 7000 SoC had a PTP MAC that was unusable.  So
much so, that the vendor simply deleted the PTP chapters from the data
sheet without a word.  IIRC, the newer MP has a different implementation,
but maybe they also flubbed that one?

In any case, this is another example of how a good PHY implementation
covers for a poor MAC one.

Thanks,
Richard

