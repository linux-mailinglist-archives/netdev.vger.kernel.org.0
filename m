Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B38A4C510E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 22:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiBYVzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 16:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiBYVzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 16:55:41 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17AC218CDB
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:55:07 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id u17-20020a056830231100b005ad13358af9so4549621ote.11
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m/vqkWoLM2koeZAVeet1hIz9u/sHUyuW7PwgatN//uU=;
        b=gVA38gVk5Bz6qX9+3TKvQmTJbn8Non5K/l9Quge1etshRDJ5NyKr5KNQ8U+1h8IfzH
         te0ujsc4GV441ZVDNugdbECMhzVpS8mx3jIU9tT5Z0aYywFV0DWfAWzku/w59vX9vsWI
         YjoyBr2QqUPaYD50kNXo8xDwCG/IBTvYlvcPoYgZEmwleVuPFUiZv+snbsZKIa92KTMh
         eNMSlbjVwC+VRBj1w+mMmt3btdgNlXsGdQG3Rq3daIsOqbOFif3eS2JLlZ0n8foRDwki
         pdNAIjCVCf6NVrPnucizvMJt+/z9HybfdN3hlZxA4Vw/VGVdTxiOFRrd0mV3AZCWrRWi
         garw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m/vqkWoLM2koeZAVeet1hIz9u/sHUyuW7PwgatN//uU=;
        b=5yapJsKzorh5dH/ldwCI2ZEqFL1HRTknu9o0T54kD1A00V1BREk6tmPaxHbf5cSjcl
         hmQjr25KWCBHFHRIUPpBNiNGqGCvdCb5vNhRenMz4tpMjAKfkhwZ36watj1DV9wcZ4oD
         QeL9eHVdrx3SjHOklxaA37YXr60R6C+2f0UxQcVOLKfRtASEkc0AYZ0bEd+VODZRsCcY
         QrYULcExWvEoZOnNnQqoc/nwyPWW7/VtO2aRS27xOlkBYQYxz0nsR8VYfacGqOErTzz6
         V7x0QKPZg+SmP8p8IuXLS7a5xrP2VqaTOr/z3G3m6A4es72puFHv8rBNT4hN6GadSdLb
         LAaA==
X-Gm-Message-State: AOAM5324kCvBLjWnDcJQtqk2TtySdX5TLeyvjoqkvd4RFXUqlf33/nS0
        2KJVg+QviqmPHAuF0auyzLYluX4kaUYDMA==
X-Google-Smtp-Source: ABdhPJyWXfpVOjBQzPDsuZlQkeTho7DcqtU5U87DNz4IiNmLbE7u74pfulpklA/AtpE9EXIZhDTquw==
X-Received: by 2002:a9d:176:0:b0:5ae:ed94:f1c0 with SMTP id 109-20020a9d0176000000b005aeed94f1c0mr3838228otu.74.1645826107045;
        Fri, 25 Feb 2022 13:55:07 -0800 (PST)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id cz42-20020a05687064aa00b000d6c97027b7sm1705425oab.30.2022.02.25.13.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 13:55:06 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:57:03 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Luca Weiss <luca@z3ntu.xyz>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 0/5] Wifi & Bluetooth on LG G Watch R
Message-ID: <YhlQr17fGi+Q7KT8@ripper>
References: <20220216212433.1373903-1-luca@z3ntu.xyz>
 <YhcGSmd5M3W+fI6c@builder.lan>
 <4379033.LvFx2qVVIh@g550jk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4379033.LvFx2qVVIh@g550jk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 25 Feb 12:19 PST 2022, Luca Weiss wrote:

> Hi Bjorn
> 
> On Donnerstag, 24. Februar 2022 05:15:06 CET Bjorn Andersson wrote:
> > On Wed 16 Feb 15:24 CST 2022, Luca Weiss wrote:
> > > This series adds the BCM43430A0 chip providing Bluetooth & Wifi on the
> > > LG G Watch R.
> > 
> > I picked the dts changes, but would prefer that the other two changes
> > goes through the BT tree. I see that you haven't copied Marcel on the
> > dt-binding change though, so please resubmit those two patches together.
> 
> Thank you, will resubmit the first two!
> 
> Just to be clear, as far as I understand each patch gets sent based on its own 
> get_maintainer.pl, and the cover letter gets sent to the superset of all 
> individual patch recipients?

It's rather annoying to be maintainer and only get 1-2 patches out of a
larger series and having to browse lore.kernel.org to find the rest. So
based on that I tend to make sure that everyone is Cc'ed on all patches
in my series.

And then there's the general advice that if there isn't a strong
dependency between the patches, it might be better to just submit them
separately in the first place. Simply to make it easier for each
maintainer to merge your patches.

> I'm using this script that's largely based on something I found online a while 
> ago
> https://github.com/z3ntu/dotfiles/blob/master/scripts/usr/local/bin/cocci_cc
> 
> Also just checked and Marcel isn't listed as maintainer of the relevant dt 
> bindings in MAINTAINERS, maybe they should get added there?
> 

In general I think the DT bindings goes through the relevant subsystem
maintainer, so I would suggest that you post a patch. If for some reason
Marcel shouldn't merge BT related DT patches, then the discussion that
follows will make that clear and you could make sure that MAINTAINERS
reflects the outcome.

Regards,
Bjorn

> (also CCed Marcel on this email)
> 
> Regards
> Luca
> 
> > 
> > Thanks,
> > Bjorn
> > 
> > > Luca Weiss (5):
> > >   dt-bindings: bluetooth: broadcom: add BCM43430A0
> > >   Bluetooth: hci_bcm: add BCM43430A0
> > >   ARM: dts: qcom: msm8226: Add pinctrl for sdhci nodes
> > >   ARM: dts: qcom: apq8026-lg-lenok: Add Wifi
> > >   ARM: dts: qcom: apq8026-lg-lenok: Add Bluetooth
> > >  
> > >  .../bindings/net/broadcom-bluetooth.yaml      |  1 +
> > >  arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts   | 98 ++++++++++++++++---
> > >  arch/arm/boot/dts/qcom-msm8226.dtsi           | 57 +++++++++++
> > >  drivers/bluetooth/hci_bcm.c                   |  1 +
> > >  4 files changed, 144 insertions(+), 13 deletions(-)
> 
> 
> 
> 
