Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE3B65DAEC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbjADRFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbjADRFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:05:07 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D434186E3;
        Wed,  4 Jan 2023 09:05:06 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id y18-20020a0568301d9200b0067082cd4679so21117558oti.4;
        Wed, 04 Jan 2023 09:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfchq3z9RqrMHrMAPr0oOfboNargOdRcSf8XQTWDpFg=;
        b=aqAoCHfZVbCfPwNUxAOSiiAUaDbAKlvAy+hptOI8dUL4ZJkNVfDTTujvDQ5ClVtVc2
         PhAPMareQPJBuoLExdRAzYrWFZh4tR8c9YpSQnIOAnvL372EKcXMGZjJNW4csIoMK6d5
         52PyQ2Dinxhh1LSaMnqfNHikPn1qOz6tuWyNnHat68Cc3ABW5iL1wJ7RXFgQI5XTsOF5
         5QXfYyzLfnLoYcv/SgVyEQIVOWAeqsCYKFO5/Hy6WldWHkp599ivh8ZctxHRryl3tl8f
         aJ3Gdox5KGwVYbw2CBCGtKE0sOkGdPbHpvMTBrKEgSR0vKyH8K+tOAhr4VO+4HO6XMW5
         37kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zfchq3z9RqrMHrMAPr0oOfboNargOdRcSf8XQTWDpFg=;
        b=d1/3VJS3zKAmvAVrih/oDpZFM0Y5jsH1i9Gr+8KG9OLJkfnMIvtfNFoZ21Em/ytY1i
         AYk1sMH8yEFB37eXC2irJ0llLPH0EnIzJOFbrC2dDHILrZuFivDuvAwOfYUfdz44j1/N
         8rJ/a+8WHwgrjy5yThmZ930U47MAhJgYhoUzIQgR4KxYNu6eCBPmZu0Swi2MoWtAyEIp
         w934Tl24fptIp4+zaojLYAfCWTVOn6ZCyHJzxLaw3Xq2xqKSTp3PXDgnKuwAB40bIbFr
         LmJW/B5nXTJfhoW5GJ6ND0+KDHzKMR4+kiw2KorJvNpOE3j0f6EptdvwLHoWHbhZKKME
         Jl3w==
X-Gm-Message-State: AFqh2kp3cztQDelpepGmwcAixyhlZXz2SsvUBhfr+Ef/NV2p0Hy3rpjx
        2UjBBJg+i2x/0dTJnAnHXpJVwKJjToo=
X-Google-Smtp-Source: AMrXdXutUK/CGUtPMUYPBOpL8lgY0hDUYoKQ3k11Pv3IPl7yVFonRq+Ao9i+cRgPlXouTWnmtQlsoQ==
X-Received: by 2002:a9d:12e4:0:b0:66e:b906:c1b9 with SMTP id g91-20020a9d12e4000000b0066eb906c1b9mr28527675otg.8.1672851905073;
        Wed, 04 Jan 2023 09:05:05 -0800 (PST)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id k25-20020a056830151900b0066e873e4c2csm16693927otp.45.2023.01.04.09.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:05:04 -0800 (PST)
Message-ID: <63b5b1c0.050a0220.a0efc.de06@mx.google.com>
X-Google-Original-Message-ID: <Y7WxvXO+xAAzmsFX@neuromancer.>
Date:   Wed, 4 Jan 2023 11:05:01 -0600
From:   Chris Morgan <macroalpha82@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <CAFBinCDpMjHPZ4CA-YdyAu=k1F_7DxxYEMSjnBEX2aMWfSCCeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCDpMjHPZ4CA-YdyAu=k1F_7DxxYEMSjnBEX2aMWfSCCeA@mail.gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 04:40:51PM +0100, Martin Blumenstingl wrote:
> Hi Chris,
> 
> On Wed, Jan 4, 2023 at 12:01 AM Chris Morgan <macroalpha82@gmail.com> wrote:
> >
> > On Wed, Dec 28, 2022 at 12:30:20AM +0100, Martin Blumenstingl wrote:
> > > Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> > > well as the existing RTL8821C chipset code.
> > >
> >
> > Unfortunately, this doesn't work for me. I applied it on top of 6.2-rc2
> > master and I get errors during probe (it appears the firmware never
> > loads).
> That's unfortunate.
> 
> > Relevant dmesg logs are as follows:
> >
> > [    0.989545] mmc2: new high speed SDIO card at address 0001
> > [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
> > [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
> > [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
> > [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
> > [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
> > [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
> > [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
> > [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
> The error starts with a write to register 0x14 (REG_SDIO_HIMR), which
> happens right after configuring RX aggregation.
> Can you please try two modifications inside
> drivers/net/wireless/realtek/rtw88/sdio.c:
> 1. inside the rtw_sdio_start() function: change
> "rtw_sdio_rx_aggregation(rtwdev, false);" to
> "rtw_sdio_rx_aggregation(rtwdev, true);"

No change, still receive identical issue.

> 2. if 1) does not work: remove the call to rtw_sdio_rx_aggregation()
> from rtw_sdio_start()
> 

Same here, still receive identical issue.

> 
> Best regards,
> Martin
