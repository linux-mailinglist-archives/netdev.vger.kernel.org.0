Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED14C3F2829
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhHTILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhHTILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:11:18 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E871C061756
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 01:10:41 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d5so6846638qtd.3
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 01:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5IS6e3Hnyb2jRAb6f1KMnSZamwQJcSDoTsblYNlRlY=;
        b=AZ9hPtV94XSFU7TEKvhcU+et+rJ+GpExWH9lrUhoqWoy0ewHu2M34a/uO6l9DjkV3W
         f0oJk7nxCalOBi4OJVItLOhpuaLrPNMPtOlhahFsCqEnDmrPKqvI4ExcusqN0kmf2dmm
         X6aVP3hh5uVmOusZVgIhxqBCEvpuDtGXIU0bCJxnBEYFye8qFaFZb0rRPDeTD4tGclZw
         r6C1JJE68Lj5FmT8KeHnhA7VE0yN5hMhHlb84zbNqFmbhPEbOEPv33O68IOJr/4+cmXs
         8UuTDZzFcGnR83wrcms+xf3UQTABzatiaTOhd2YkS23GfoR9Q7lX2ajxwnwJ0ubC8bl1
         XkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5IS6e3Hnyb2jRAb6f1KMnSZamwQJcSDoTsblYNlRlY=;
        b=ZYYG0cq2xoKRot14vx1e4l5aO7iHWMvq82BHsCw+q5aVQCG4bpNabbthCfNmVoWw7N
         FhUEYuOVh/W3J0guXfOkJ/N35iiwo3yfb1jAx2yRjQc/QhvuU7dhvmkigRu3ZIhpFUQq
         tuE4a5OHTLre53VRC2mkh6/118LQQUdaQQ+NAV/vbGQo1Wqr4AaMOpBXQhvDFRTSt1i+
         mw6tbioMfPcoV/gCMYjqpqjxVAWn8d343aTkO92Wg8eylP+Zn32pKZxnv20EF/g3uwQu
         AnuJKGlVFV+eRKDn86sUzD1Genx5L5VNKbwJm5AFN3FGvk2k7q1e8xinIsLCsWpNp+I5
         JAvw==
X-Gm-Message-State: AOAM533EJShnxeEnZ4sxlKmXiGFnQQWFrorgmfq6kTB0ds6+95mtt5Jd
        0kTSmVGb3bybCKWT1DZbymbs0h/mVYsB0J9REhXW1g==
X-Google-Smtp-Source: ABdhPJykvHLGPJLrte3XmQ+2fZnjn7MpEKijpvU45xzTfUuHaBNaF5vvWd95j2y77Xi7ngLBiT0SX8r507FJf1UymdA=
X-Received: by 2002:a05:622a:13c8:: with SMTP id p8mr16634457qtk.238.1629447040101;
 Fri, 20 Aug 2021 01:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
 <20210817005507.1507580-11-dmitry.baryshkov@linaro.org> <YR7m43mURVJ8YufC@ripper>
In-Reply-To: <YR7m43mURVJ8YufC@ripper>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Fri, 20 Aug 2021 11:10:29 +0300
Message-ID: <CAA8EJpr+=Yg2B_DzQWntW0GgvBfaSpAu0K+UD3NowdkusiYxrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 10/15] pwrseq: add support for QCA BT+WiFi power sequencer
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

On Fri, 20 Aug 2021 at 02:17, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Mon 16 Aug 17:55 PDT 2021, Dmitry Baryshkov wrote:
> [..]
> > diff --git a/drivers/power/pwrseq/pwrseq_qca.c b/drivers/power/pwrseq/pwrseq_qca.c
> > new file mode 100644
> > index 000000000000..3421a4821126
> > --- /dev/null
> > +++ b/drivers/power/pwrseq/pwrseq_qca.c
> > @@ -0,0 +1,290 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (c) 2021, Linaro Ltd.
> > + *
> > + * Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > + *
> > + * Power Sequencer for Qualcomm WiFi + BT SoCs
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pwrseq/driver.h>
> > +#include <linux/regulator/consumer.h>
> > +
> > +/*
> > + * Voltage regulator information required for configuring the
> > + * QCA WiFi+Bluetooth chipset
> > + */
> > +struct qca_vreg {
> > +     const char *name;
> > +     unsigned int load_uA;
> > +};
> > +
> > +struct qca_device_data {
> > +     struct qca_vreg vddio;
>
> Any particular reason why this isn't just the first entry in vregs and
> operated as part of the bulk API?

Because VDDIO should be up before bringing the rest of the power
sources (at least for wcn39xx). This is usually the case since VDDIO
is S4A, but I'd still prefer to express this in the code.
And register_bulk_enable powers up all the supplies asynchronously,
thus it can not guarantee that the first entry would be powered up
first.

>
> > +     struct qca_vreg *vregs;
> > +     size_t num_vregs;
> > +     bool has_bt_en;
> > +     bool has_wifi_en;
> > +};
> > +
> > +struct pwrseq_qca;
> > +struct pwrseq_qca_one {
> > +     struct pwrseq_qca *common;
> > +     struct gpio_desc *enable;
> > +};
> > +
> > +#define PWRSEQ_QCA_WIFI 0
> > +#define PWRSEQ_QCA_BT 1
> > +
> > +#define PWRSEQ_QCA_MAX 2
> > +
> > +struct pwrseq_qca {
> > +     struct regulator *vddio;
> > +     struct gpio_desc *sw_ctrl;
> > +     struct pwrseq_qca_one pwrseq_qcas[PWRSEQ_QCA_MAX];
> > +     int num_vregs;
> > +     struct regulator_bulk_data vregs[];
> > +};
> > +
> > +static int pwrseq_qca_power_on(struct pwrseq *pwrseq)
> > +{
> > +     struct pwrseq_qca_one *qca_one = pwrseq_get_data(pwrseq);
> > +     int ret;
> > +
> > +     if (qca_one->common->vddio) {
>
> devm_regulator_get() doesn't return NULL, so this is always true.

This is more of the safety guard for the cases when the qca doesn't
have the special vddio supply.

>
> > +             ret = regulator_enable(qca_one->common->vddio);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     ret = regulator_bulk_enable(qca_one->common->num_vregs, qca_one->common->vregs);
> > +     if (ret)
> > +             goto vddio_off;
> > +
> > +     if (qca_one->enable) {
> > +             gpiod_set_value_cansleep(qca_one->enable, 0);
> > +             msleep(50);
> > +             gpiod_set_value_cansleep(qca_one->enable, 1);
> > +             msleep(150);
> > +     }
> > +
> > +     if (qca_one->common->sw_ctrl) {
> > +             bool sw_ctrl_state = gpiod_get_value_cansleep(qca_one->common->sw_ctrl);
> > +             dev_dbg(&pwrseq->dev, "SW_CTRL is %d", sw_ctrl_state);
> > +     }
> > +
> > +     return 0;
> > +
> > +vddio_off:
> > +     regulator_disable(qca_one->common->vddio);
> > +
> > +     return ret;
> > +}
> [..]
> > +static int pwrseq_qca_probe(struct platform_device *pdev)
> > +{
> > +     struct pwrseq_qca *pwrseq_qca;
> > +     struct pwrseq *pwrseq;
> > +     struct pwrseq_provider *provider;
> > +     struct device *dev = &pdev->dev;
> > +     struct pwrseq_onecell_data *onecell;
> > +     const struct qca_device_data *data;
> > +     int ret, i;
> > +
> > +     data = device_get_match_data(dev);
> > +     if (!data)
> > +             return -EINVAL;
> > +
> > +     pwrseq_qca = devm_kzalloc(dev, struct_size(pwrseq_qca, vregs, data->num_vregs), GFP_KERNEL);
> > +     if (!pwrseq_qca)
> > +             return -ENOMEM;
> > +
> > +     onecell = devm_kzalloc(dev, struct_size(onecell, pwrseqs, PWRSEQ_QCA_MAX), GFP_KERNEL);
> > +     if (!onecell)
> > +             return -ENOMEM;
> > +
> > +     ret = pwrseq_qca_regulators_init(dev, pwrseq_qca, data);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (data->has_wifi_en) {
> > +             pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable = devm_gpiod_get(dev, "wifi-enable", GPIOD_OUT_LOW);
> > +             if (IS_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable)) {
> > +                     return dev_err_probe(dev, PTR_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable),
> > +                                     "failed to acquire WIFI enable GPIO\n");
> > +             }
> > +     }
> > +
> > +     if (data->has_bt_en) {
> > +             pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable = devm_gpiod_get(dev, "bt-enable", GPIOD_OUT_LOW);
> > +             if (IS_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable)) {
> > +                     return dev_err_probe(dev, PTR_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable),
> > +                                     "failed to acquire BT enable GPIO\n");
> > +             }
> > +     }
> > +
> > +     pwrseq_qca->sw_ctrl = devm_gpiod_get_optional(dev, "swctrl", GPIOD_IN);
> > +     if (IS_ERR(pwrseq_qca->sw_ctrl)) {
> > +             return dev_err_probe(dev, PTR_ERR(pwrseq_qca->sw_ctrl),
> > +                             "failed to acquire SW_CTRL gpio\n");
> > +     } else if (!pwrseq_qca->sw_ctrl)
> > +             dev_info(dev, "No SW_CTRL gpio\n");
>
> Some {} around the else as well please.

ack

>
> Regards,
> Bjorn



-- 
With best wishes
Dmitry
