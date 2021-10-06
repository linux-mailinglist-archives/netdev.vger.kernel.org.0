Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BE842365D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJFDv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhJFDv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:51:27 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D507C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:49:21 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y23so4738923lfb.0
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6uSTYKI1iDVQ1/5MVV35eiuQr3oTGL96afJoVN7XpE=;
        b=XMP0oiRighob77xlb1PXIzbL2qu7sd7BzC0FticBn2Be9aA1nYfrnT70VCqohLdx3q
         vA8YhA0yyD5li8ZRYbhNQz+bdNWHdMYyMIk/y4Ha2x3vA3udI+GGWlrbxZsA8V1I10i1
         +QF/eMLISmlGltEdbr7NmJVTaVM6rHQWjAxJgTpetWPilWj8OFNsLi/Zcq240E8/V4Qh
         FRNjGIq5x8LN0FTLd2H8v1Q5jPAVjGnYoo+hpozvUPnpE50RwWjatQsa30Z7S5s2o/jI
         CNlW4Kha+zjkWTI/jp7b5/BBvFjjpVfJRGQ48r7KLmQhSADf9iuCcnB03Pjt5t5/Grtx
         a2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6uSTYKI1iDVQ1/5MVV35eiuQr3oTGL96afJoVN7XpE=;
        b=5v3N5e95Q5zUXITSxIsCWk9tAmoN1PXOeP7jKNFZ4dspS01wIyilbTJ0TZCzVQthZg
         PF+odUOyDF2stwwty+yceJTaVtFP1geUecM2qCtR39htY8a4PIaqDbpe8fZPR9A0MgxL
         vvUEXYLaPPWeoWCXep9v5ytCj2SAlfD9NneRbIAHQpS4wVx+xYw91eW0uLX7/png7joA
         KONN5M/dp2CT37tb20LRliMrHE4LXEDTQJihcXTfwIwjiZqT1EMRRgDFcSX3K2LpSV88
         x9rIytWXJpA6AXmALuf5EDhqRdmri9cDn37kN5ADoYbQcLsilaR44sPznW4wDhetBQVw
         jf0w==
X-Gm-Message-State: AOAM530kjeQoLuRHEJFVLgEw3uD36qGCJyHQT98ygKHB2sqtMuXx+SMh
        gPemIXSdQEyRSaISmZD5g16IgtLpVUcaA5puezcZqw==
X-Google-Smtp-Source: ABdhPJya/cHmu4jYQmBnP1nXJTIFK74KW21Myh3oIz3kpdEwg32cUPpqXnXVmYd4H6feMiKWwtLp8SDERd4E6oJYIJg=
X-Received: by 2002:a2e:5442:: with SMTP id y2mr26848306ljd.436.1633492159155;
 Tue, 05 Oct 2021 20:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210829131305.534417-1-dmitry.baryshkov@linaro.org> <4a508fc1-6253-9c11-67fb-f84f17fd2719@kali.org>
In-Reply-To: <4a508fc1-6253-9c11-67fb-f84f17fd2719@kali.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Wed, 6 Oct 2021 06:49:08 +0300
Message-ID: <CAA8EJprsfzFWP1KH61UEkjJmY8rDFTN5i_53Mc0e9n3oxJsBNA@mail.gmail.com>
Subject: Re: [RFC v2 00/13] create power sequencing subsystem
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "open list:DRM DRIVER FOR MSM ADRENO GPU" 
        <linux-arm-msm@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steev,

On Tue, 14 Sept 2021 at 02:39, Steev Klimaszewski <steev@kali.org> wrote:
>
>
> On 8/29/21 8:12 AM, Dmitry Baryshkov wrote:
> > This is the second RFC on the proposed power sequencer subsystem. This
> > is a generification of the MMC pwrseq code. The subsystem tries to
> > abstract the idea of complex power-up/power-down/reset of the devices.
> >
> > To ease migration to pwrseq and to provide compatibility with older
> > device trees, while keeping drivers simple, this iteration of RFC
> > introduces pwrseq fallback support: pwrseq driver can register fallback
> > providers. If another device driver requests pwrseq instance and none
> > was declared, the pwrseq fallback code would go through the list of
> > fallback providers and if the match is found, driver would return a
> > crafted pwrseq instance. For now this mechanism is limited to the OF
> > device matching, but it can be extended further to use any combination
> > of device IDs.
> >
> > The primary set of devices that promted me to create this patchset is
> > the Qualcomm BT+WiFi family of chips. They reside on serial+platform or
> > serial + SDIO interfaces (older generations) or on serial+PCIe (newer
> > generations).  They require a set of external voltage regulators to be
> > powered on and (some of them) have separate WiFi and Bluetooth enable
> > GPIOs.
> >
> > This patchset being an RFC tries to demonstrate the approach, design and
> > usage of the pwrseq subsystem. Following issues are present in the RFC
> > at this moment but will be fixed later if the overall approach would be
> > viewed as acceptable:
> >
> >  - No documentation
> >    While the code tries to be self-documenting proper documentation
> >    would be required.
> >
> >  - Minimal device tree bindings changes
> >    There are no proper updates for the DT bindings (thus neither Rob
> >    Herring nor devicetree are included in the To/Cc lists). The dt
> >    schema changes would be a part of v1.
> >
> >  - Lack of proper PCIe integration
> >    At this moment support for PCIe is hacked up to be able to test the
> >    PCIe part of qca6390. Proper PCIe support would require automatically
> >    powering up the devices before the bus scan depending on the proper
> >    device structure in the device tree.
> >
> > Changes since RFC v1:
> >  - Provider pwrseq fallback support
> >  - Implement fallback support in pwrseq_qca.
> >  - Mmove susclk handling to pwrseq_qca.
> >  - Significantly simplify hci_qca.c changes, by dropping all legacy
> >    code. Now hci_qca uses only pwrseq calls to power up/down bluetooth
> >    parts of the chip.
> >
> I tested this here, on the Lenovo Yoga C630, after creating a patch to
> do basically the same thing as the db845c does.  One thing I noticed, if
> PWRSEQ=y and the rest are =m, there is a build error.  I suppose once
> the full set is posted and not RFC, I can send the patch for that.

Please excuse me for the delay in the response. I was carried away by
other duties. Yes, could you please provide a fixup patch.
I'm going to send v1 now, containing mostly cosmetical and
documentation changes. I'll include your patch in v2.

> One question I have, if you don't mind, in patch 11, you add a second
> channel to qca power sequencer.  I've added that here, but in the c630's
> dts, "vreg_l23a_3p3: ldo23" is empty, so I added the same numbers in for
> the regulator, and I'm wondering how to test that it's actually working
> correctly?

That's a good question. I have not looked in the details in the ath10k
documentation. I'll try finding it.
Maybe Kalle Valo can answer your question. Could you please duplicate
your question on the ath10k mailing list?

-- 
With best wishes
Dmitry
