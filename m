Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5393F28AD
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhHTIuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhHTIux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:50:53 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02976C061756
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 01:50:16 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id f7so5123290qvt.8
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 01:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SvhAeR492M8EeJTTsM7VxBsaJ8w8PTYW6CNfHJ9BY2c=;
        b=dKLqKUJhPoyCJWDUu8gJmjjE0Wc3rdqQkmBcmfkwom8eSKEyeb8rOpa4aupFDqivwV
         VRU0qIuQrbVN0Ha4h5IF4dJMIt7G6fy8Ip/cpeCDRQx2J/VqQW28GSLRSHv2Jt0Dbcg7
         gkECVHdOZbmswNg9/PsZhRkVS0bXWp/UZ0nL5ET9j5+/DoAWCrAjkD/sP1HCYsxemvX7
         x7whEy0Hs49bDP4HdIYRvYY8oDAAE5CuZhvjCCAtkyC6AyZG2H1J5CCgJN8WeJcoMDwo
         2vAJYsgWHNjAi+R1OjOm7ppdpCeL4TmH1ILRGmwSQCSdM1NZvTkEBLdUO4YpS9c0clBQ
         Noag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SvhAeR492M8EeJTTsM7VxBsaJ8w8PTYW6CNfHJ9BY2c=;
        b=r/Ga9oovUGbuWvILfFgmx0leemMg1Cs75kEtytjmH7y+dYFIWO/N9pnVvpiVmyw3E6
         zAz3+tS4/cAXuhmodUwUnqTCpb5eXa7Nt3SZD73Y2jiLPqvCpyo0qJuXdeTgc4IpQPew
         gFT1wem5TMV7EJa/brJbkoeyyq+gQumMZkxC0bcf146Nc6JWX3MoEu1WQ8k1HWRBsMzz
         Fo13mxpSYA2c7Dg+NO7ZEVTpx6STmT7cxvJUTNUb0ZOokIXKEynxHp1KDm0+fCc+yERZ
         u7vvOPDjwFNcpTzdhRrJMjg8562vPUEhioer06WO4LUR4NyLchraS6Modm0jrstSLo5/
         dk0A==
X-Gm-Message-State: AOAM530QOfiS0hgQAt2LIJ9kJAE6wek0OUgdPB+flAgxS9X1KjH+wpaB
        uy99BAZ+U8GX3pzS6BAd5A5HTbGPS7e31UUTxFaCdQ==
X-Google-Smtp-Source: ABdhPJy/QJn6fSqlmsALEyKeczIYJGYK90zosKS269iQJbHQVvas6xuChnmDApCtJxPNdNz0fntXs47ZI4/8W6cdsu4=
X-Received: by 2002:a05:6214:126:: with SMTP id w6mr18974742qvs.61.1629449415210;
 Fri, 20 Aug 2021 01:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
 <20210817005507.1507580-15-dmitry.baryshkov@linaro.org> <YR7s2vK7jdUssx+A@ripper>
In-Reply-To: <YR7s2vK7jdUssx+A@ripper>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Fri, 20 Aug 2021 11:50:04 +0300
Message-ID: <CAA8EJpptHqBR=deRaf72iGqXtWX5+3EgE4nKKGCPE7Cg9R0PBg@mail.gmail.com>
Subject: Re: [RFC PATCH 14/15] WIP: PCI: qcom: use pwrseq to power up bus devices
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "open list:DRM DRIVER FOR MSM ADRENO GPU" 
        <linux-arm-msm@vger.kernel.org>, linux-mmc@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 20 Aug 2021 at 02:43, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Mon 16 Aug 17:55 PDT 2021, Dmitry Baryshkov wrote:
>
> > Use bus-pwrseq device tree node to power up the devices on the bus. This
> > is to be rewritten with the proper code parsing the device tree and
> > powering up individual devices.
> >
>
> How about describing the PCI device in DT and having the PCIe controller
> dig it up up from there? Although we won't have a struct device until
> later, so perhaps we need the of-based pwrseq_get() for that.

Yes, this is the plan. Currently I just wanted to have a way to power
up the PCIe part of the chip and be able to test that.
In the previous attempts to provide qca6390 support, Rob has clearly
stated that we'd have to have the following device tree snippet:

pcie0 {
    bridge@0,0 {
        qca6390@1,0 {
            supplies-or-whatever = ....;
        };
    };
};

>
> Regards,
> Bjorn
>
> > Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > ---
> >  drivers/pci/controller/dwc/pcie-qcom.c | 13 +++++++++++++
> >  drivers/power/pwrseq/pwrseq_qca.c      |  1 +
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> > index 8a7a300163e5..a60d41fbcd6f 100644
> > --- a/drivers/pci/controller/dwc/pcie-qcom.c
> > +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/phy/phy.h>
> > +#include <linux/pwrseq/consumer.h>
> >  #include <linux/regulator/consumer.h>
> >  #include <linux/reset.h>
> >  #include <linux/slab.h>
> > @@ -1467,6 +1468,7 @@ static int qcom_pcie_probe(struct platform_device *pdev)
> >       struct pcie_port *pp;
> >       struct dw_pcie *pci;
> >       struct qcom_pcie *pcie;
> > +     struct pwrseq *pwrseq;
> >       int ret;
> >
> >       pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
> > @@ -1520,6 +1522,17 @@ static int qcom_pcie_probe(struct platform_device *pdev)
> >
> >       pp->ops = &qcom_pcie_dw_ops;
> >
> > +     pwrseq = devm_pwrseq_get_optional(dev, "bus");
> > +     if (IS_ERR(pwrseq)) {
> > +             ret = PTR_ERR(pwrseq);
> > +             goto err_pm_runtime_put;
> > +     }
> > +     if (pwrseq) {
> > +             ret = pwrseq_full_power_on(pwrseq);
> > +             if (ret)
> > +                     goto err_pm_runtime_put;
> > +     }
> > +
> >       ret = phy_init(pcie->phy);
> >       if (ret) {
> >               pm_runtime_disable(&pdev->dev);
> > diff --git a/drivers/power/pwrseq/pwrseq_qca.c b/drivers/power/pwrseq/pwrseq_qca.c
> > index 3421a4821126..4107f0a9c05d 100644
> > --- a/drivers/power/pwrseq/pwrseq_qca.c
> > +++ b/drivers/power/pwrseq/pwrseq_qca.c
> > @@ -1,3 +1,4 @@
> > +#define DEBUG
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  /*
> >   * Copyright (c) 2021, Linaro Ltd.
> > --
> > 2.30.2
> >



-- 
With best wishes
Dmitry
