Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A6F1C3D7E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 16:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgEDOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 10:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgEDOtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 10:49:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4F1C061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 07:49:17 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fu13so3860698pjb.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 07:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5lmoQJYoeg3ybSPwplhMkrooqQOGOYA7nU2sY4Dq1pc=;
        b=R04Fjb4R2zQrBdDiS1rI1lH0gMnWxIPItV5U2BOiCIby5HxxzYV7c9vaEBIuSU6TKc
         N9yJAqZKcVjZS3dG2Rah6YyW6mKqK9XGAwKP4ZTnARpmIBVYbSR+v9/ffySNScve9KAS
         fFp6YUwxhiVFrKpnhfNdNztyuV6JtUulx7ImPpPksB5T3uIrbqLIc2QZ0DIaH7vmMYa/
         mlSuf4zp+Oh+k8sETM+eBqNyneLDT6QlrGT3CmLeedUqmbAq6giRJxV29uKfbeWsbvDB
         yM6pyiRw2db9pa0Tm3awQzKDxTdw3iafUgw096RzVZ2cKOSKyRo5hi5nclBmgK32UOHY
         x8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5lmoQJYoeg3ybSPwplhMkrooqQOGOYA7nU2sY4Dq1pc=;
        b=KnWQMyKvVmGYGJaFqLJbQAbenDiY6stPGtYPmFb/cO569kHI/FQ8KPdUt5YgzjJfqu
         H3r6vVfZptLXE9kZ6eNSyg/cDaWzrzqZSDkMHUJvteoWCBRNNMUdXhdwyt31FPhsrDfT
         0SpXLPinWYOOOimrPZn+v3i41xecRZb/14tXa5e7Rfv4ohH/s6g/gwytD35D+clN+h2O
         f8M8+CyxBiWHWq6nghKxgilGx7+G9/jXGKC9/IJDuKZozI2/R0+nqAaQj+gnVmeCeVTH
         JDJNevBf1Rhro8pzPJsssZxszvwYkQ+TlcsUyjvlcvdrU86E9bdcHbHqn6ArPUP0K13s
         jqeA==
X-Gm-Message-State: AGi0PuZTc3eD7c/84/+h2derPFXdALP2Z360xUKzcB5Dxuk3JmGBb6tJ
        s9T06vcPLtlFqpvm+8ceXTBn
X-Google-Smtp-Source: APiQypJjIapp5XKSell2YBv+inFoZ8mKXrHBT+VFs3IVljbQMp6IsqaBr1+529ONpM1jjcEHWag4sQ==
X-Received: by 2002:a17:902:fe8e:: with SMTP id x14mr18541862plm.128.1588603756751;
        Mon, 04 May 2020 07:49:16 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:41c:f7b5:bdcc:167e:2cd1:efea])
        by smtp.gmail.com with ESMTPSA id p66sm9009181pfb.65.2020.05.04.07.49.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 07:49:15 -0700 (PDT)
Date:   Mon, 4 May 2020 20:19:06 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net
Cc:     gregkh@linuxfoundation.org, smohanad@codeaurora.org,
        jhugo@codeaurora.org, kvalo@codeaurora.org,
        bjorn.andersson@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clew@codeaurora.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: qrtr: Add MHI transport layer
Message-ID: <20200504144906.GF3391@Mani-XPS-13-9360>
References: <20200427075829.9304-1-manivannan.sadhasivam@linaro.org>
 <20200427075829.9304-3-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427075829.9304-3-manivannan.sadhasivam@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On Mon, Apr 27, 2020 at 01:28:28PM +0530, Manivannan Sadhasivam wrote:
> MHI is the transport layer used for communicating to the external modems.
> Hence, this commit adds MHI transport layer support to QRTR for
> transferring the QMI messages over IPC Router.
> 

Can you please review this driver? It'd be great if this ends up in v5.8
along with all other MHI patches.

Thanks,
Mani

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/Kconfig  |   7 +++
>  net/qrtr/Makefile |   2 +
>  net/qrtr/mhi.c    | 127 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 136 insertions(+)
>  create mode 100644 net/qrtr/mhi.c
> 
> diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
> index 63f89cc6e82c..8eb876471564 100644
> --- a/net/qrtr/Kconfig
> +++ b/net/qrtr/Kconfig
> @@ -29,4 +29,11 @@ config QRTR_TUN
>  	  implement endpoints of QRTR, for purpose of tunneling data to other
>  	  hosts or testing purposes.
>  
> +config QRTR_MHI
> +	tristate "MHI IPC Router channels"
> +	depends on MHI_BUS
> +	help
> +	  Say Y here to support MHI based ipcrouter channels. MHI is the
> +	  transport used for communicating to external modems.
> +
>  endif # QRTR
> diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
> index 32d4e923925d..1b1411d158a7 100644
> --- a/net/qrtr/Makefile
> +++ b/net/qrtr/Makefile
> @@ -5,3 +5,5 @@ obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
>  qrtr-smd-y	:= smd.o
>  obj-$(CONFIG_QRTR_TUN) += qrtr-tun.o
>  qrtr-tun-y	:= tun.o
> +obj-$(CONFIG_QRTR_MHI) += qrtr-mhi.o
> +qrtr-mhi-y	:= mhi.o
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> new file mode 100644
> index 000000000000..2a2abf5b070d
> --- /dev/null
> +++ b/net/qrtr/mhi.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
> + */
> +
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <net/sock.h>
> +
> +#include "qrtr.h"
> +
> +struct qrtr_mhi_dev {
> +	struct qrtr_endpoint ep;
> +	struct mhi_device *mhi_dev;
> +	struct device *dev;
> +};
> +
> +/* From MHI to QRTR */
> +static void qcom_mhi_qrtr_dl_callback(struct mhi_device *mhi_dev,
> +				      struct mhi_result *mhi_res)
> +{
> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> +	int rc;
> +
> +	if (!qdev || mhi_res->transaction_status)
> +		return;
> +
> +	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
> +				mhi_res->bytes_xferd);
> +	if (rc == -EINVAL)
> +		dev_err(qdev->dev, "invalid ipcrouter packet\n");
> +}
> +
> +/* From QRTR to MHI */
> +static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
> +				      struct mhi_result *mhi_res)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)mhi_res->buf_addr;
> +
> +	if (skb->sk)
> +		sock_put(skb->sk);
> +	consume_skb(skb);
> +}
> +
> +/* Send data over MHI */
> +static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
> +{
> +	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
> +	int rc;
> +
> +	rc = skb_linearize(skb);
> +	if (rc)
> +		goto free_skb;
> +
> +	rc = mhi_queue_skb(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
> +			   MHI_EOT);
> +	if (rc)
> +		goto free_skb;
> +
> +	if (skb->sk)
> +		sock_hold(skb->sk);
> +
> +	return rc;
> +
> +free_skb:
> +	kfree_skb(skb);
> +
> +	return rc;
> +}
> +
> +static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
> +			       const struct mhi_device_id *id)
> +{
> +	struct qrtr_mhi_dev *qdev;
> +	int rc;
> +
> +	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
> +	if (!qdev)
> +		return -ENOMEM;
> +
> +	qdev->mhi_dev = mhi_dev;
> +	qdev->dev = &mhi_dev->dev;
> +	qdev->ep.xmit = qcom_mhi_qrtr_send;
> +
> +	dev_set_drvdata(&mhi_dev->dev, qdev);
> +	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
> +	if (rc)
> +		return rc;
> +
> +	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
> +
> +	return 0;
> +}
> +
> +static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
> +{
> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> +
> +	qrtr_endpoint_unregister(&qdev->ep);
> +	dev_set_drvdata(&mhi_dev->dev, NULL);
> +}
> +
> +static const struct mhi_device_id qcom_mhi_qrtr_id_table[] = {
> +	{ .chan = "IPCR" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(mhi, qcom_mhi_qrtr_id_table);
> +
> +static struct mhi_driver qcom_mhi_qrtr_driver = {
> +	.probe = qcom_mhi_qrtr_probe,
> +	.remove = qcom_mhi_qrtr_remove,
> +	.dl_xfer_cb = qcom_mhi_qrtr_dl_callback,
> +	.ul_xfer_cb = qcom_mhi_qrtr_ul_callback,
> +	.id_table = qcom_mhi_qrtr_id_table,
> +	.driver = {
> +		.name = "qcom_mhi_qrtr",
> +	},
> +};
> +
> +module_mhi_driver(qcom_mhi_qrtr_driver);
> +
> +MODULE_AUTHOR("Chris Lew <clew@codeaurora.org>");
> +MODULE_AUTHOR("Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>");
> +MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
> +MODULE_LICENSE("GPL v2");
> -- 
> 2.17.1
> 
