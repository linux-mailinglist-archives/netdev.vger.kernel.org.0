Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA73F2394
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 01:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbhHSXSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 19:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhHSXSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 19:18:13 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA70C061757
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:17:37 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so10780055otf.6
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dqgoJAQz3Mv7B0ZEGRvtaCqkcK4kqu5N3VSB9Do7xY4=;
        b=BMf23iSlOWarU9fDcULweKVfxlosd41Wfztfxi8DOr0ErrJ2WhFuCCJdroa4O3U6Y4
         Ornh+yHcbZUTjYugKoCBoMvCuzIam6M+JCV2WGHWTCt5Q87DYpGvI7XiogoqjDWvdBJq
         ndpRW8alwfoz9eRtKWAiyOOYuHxpm070gdIkFjgkcZQRsAYJhwuC10wddFnkpuuDXvId
         SdgUNgerTBW5jnZEmujJEh18/L85559JS7Mgk3us3PqXvJEoQFq08GdIqS/f1/cl8knE
         ZpLOcgtVLfQjQa1B0gpCqgHYebtUQqbo4TIy1POmSREhzGqokLYnjGXFMZKWIgQ4FXh5
         C37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dqgoJAQz3Mv7B0ZEGRvtaCqkcK4kqu5N3VSB9Do7xY4=;
        b=M66hBud5YVi8oE5HWQvF+MAYD2jOeUB9u183+woNYImBkyM8aNOK8CGySxtoZR6Hgk
         4klmKzB98piZKSIlbA2GN5cv5pBbwWBBtgiDl+GnYJnz+h+cmqT9lQBf1MM9VSBkkK5a
         4PB6wv8j6cZ59hOuR80BLFRI3Hz23DS/sb5Z8ar6bcl2wN5eb9NNTL7VgwWhnoyiE/vr
         GABvD4eZ41SHmYBG0OKOkY1/Rz3+NyLXGeMfjvglIbGBrWyhJrnLX5SbgQwev5MdAkv5
         bYjPUogS7GLoVIY/jOdqHRur7E8aA4ZDBU7niMPD15xK5H6JvdrMpYpij3bd9R/QIOHY
         5Rqg==
X-Gm-Message-State: AOAM532g0HMpOLK0k95QVF40I8+GvfeGrqsSN10t3h8BbowT/Qp2tUXh
        XLQtJXpbhcFxi3P5RMrdQIRxdg==
X-Google-Smtp-Source: ABdhPJyW/PO0aRB2JhV3QSCv+CbV97dGiXbm6pwAyuaGcZ90eIfRAKlNSig9OcjkDtMHhlGDTPhK9g==
X-Received: by 2002:a9d:bec:: with SMTP id 99mr13825165oth.187.1629415056421;
        Thu, 19 Aug 2021 16:17:36 -0700 (PDT)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id z26sm971827oih.3.2021.08.19.16.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 16:17:36 -0700 (PDT)
Date:   Thu, 19 Aug 2021 16:18:59 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 10/15] pwrseq: add support for QCA BT+WiFi power
 sequencer
Message-ID: <YR7m43mURVJ8YufC@ripper>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
 <20210817005507.1507580-11-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817005507.1507580-11-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 16 Aug 17:55 PDT 2021, Dmitry Baryshkov wrote:
[..]
> diff --git a/drivers/power/pwrseq/pwrseq_qca.c b/drivers/power/pwrseq/pwrseq_qca.c
> new file mode 100644
> index 000000000000..3421a4821126
> --- /dev/null
> +++ b/drivers/power/pwrseq/pwrseq_qca.c
> @@ -0,0 +1,290 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, Linaro Ltd.
> + *
> + * Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> + *
> + * Power Sequencer for Qualcomm WiFi + BT SoCs
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwrseq/driver.h>
> +#include <linux/regulator/consumer.h>
> +
> +/*
> + * Voltage regulator information required for configuring the
> + * QCA WiFi+Bluetooth chipset
> + */
> +struct qca_vreg {
> +	const char *name;
> +	unsigned int load_uA;
> +};
> +
> +struct qca_device_data {
> +	struct qca_vreg vddio;

Any particular reason why this isn't just the first entry in vregs and
operated as part of the bulk API?

> +	struct qca_vreg *vregs;
> +	size_t num_vregs;
> +	bool has_bt_en;
> +	bool has_wifi_en;
> +};
> +
> +struct pwrseq_qca;
> +struct pwrseq_qca_one {
> +	struct pwrseq_qca *common;
> +	struct gpio_desc *enable;
> +};
> +
> +#define PWRSEQ_QCA_WIFI 0
> +#define PWRSEQ_QCA_BT 1
> +
> +#define PWRSEQ_QCA_MAX 2
> +
> +struct pwrseq_qca {
> +	struct regulator *vddio;
> +	struct gpio_desc *sw_ctrl;
> +	struct pwrseq_qca_one pwrseq_qcas[PWRSEQ_QCA_MAX];
> +	int num_vregs;
> +	struct regulator_bulk_data vregs[];
> +};
> +
> +static int pwrseq_qca_power_on(struct pwrseq *pwrseq)
> +{
> +	struct pwrseq_qca_one *qca_one = pwrseq_get_data(pwrseq);
> +	int ret;
> +
> +	if (qca_one->common->vddio) {

devm_regulator_get() doesn't return NULL, so this is always true.

> +		ret = regulator_enable(qca_one->common->vddio);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = regulator_bulk_enable(qca_one->common->num_vregs, qca_one->common->vregs);
> +	if (ret)
> +		goto vddio_off;
> +
> +	if (qca_one->enable) {
> +		gpiod_set_value_cansleep(qca_one->enable, 0);
> +		msleep(50);
> +		gpiod_set_value_cansleep(qca_one->enable, 1);
> +		msleep(150);
> +	}
> +
> +	if (qca_one->common->sw_ctrl) {
> +		bool sw_ctrl_state = gpiod_get_value_cansleep(qca_one->common->sw_ctrl);
> +		dev_dbg(&pwrseq->dev, "SW_CTRL is %d", sw_ctrl_state);
> +	}
> +
> +	return 0;
> +
> +vddio_off:
> +	regulator_disable(qca_one->common->vddio);
> +
> +	return ret;
> +}
[..]
> +static int pwrseq_qca_probe(struct platform_device *pdev)
> +{
> +	struct pwrseq_qca *pwrseq_qca;
> +	struct pwrseq *pwrseq;
> +	struct pwrseq_provider *provider;
> +	struct device *dev = &pdev->dev;
> +	struct pwrseq_onecell_data *onecell;
> +	const struct qca_device_data *data;
> +	int ret, i;
> +
> +	data = device_get_match_data(dev);
> +	if (!data)
> +		return -EINVAL;
> +
> +	pwrseq_qca = devm_kzalloc(dev, struct_size(pwrseq_qca, vregs, data->num_vregs), GFP_KERNEL);
> +	if (!pwrseq_qca)
> +		return -ENOMEM;
> +
> +	onecell = devm_kzalloc(dev, struct_size(onecell, pwrseqs, PWRSEQ_QCA_MAX), GFP_KERNEL);
> +	if (!onecell)
> +		return -ENOMEM;
> +
> +	ret = pwrseq_qca_regulators_init(dev, pwrseq_qca, data);
> +	if (ret)
> +		return ret;
> +
> +	if (data->has_wifi_en) {
> +		pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable = devm_gpiod_get(dev, "wifi-enable", GPIOD_OUT_LOW);
> +		if (IS_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable)) {
> +			return dev_err_probe(dev, PTR_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable),
> +					"failed to acquire WIFI enable GPIO\n");
> +		}
> +	}
> +
> +	if (data->has_bt_en) {
> +		pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable = devm_gpiod_get(dev, "bt-enable", GPIOD_OUT_LOW);
> +		if (IS_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable)) {
> +			return dev_err_probe(dev, PTR_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable),
> +					"failed to acquire BT enable GPIO\n");
> +		}
> +	}
> +
> +	pwrseq_qca->sw_ctrl = devm_gpiod_get_optional(dev, "swctrl", GPIOD_IN);
> +	if (IS_ERR(pwrseq_qca->sw_ctrl)) {
> +		return dev_err_probe(dev, PTR_ERR(pwrseq_qca->sw_ctrl),
> +				"failed to acquire SW_CTRL gpio\n");
> +	} else if (!pwrseq_qca->sw_ctrl)
> +		dev_info(dev, "No SW_CTRL gpio\n");

Some {} around the else as well please.

Regards,
Bjorn
