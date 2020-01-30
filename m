Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B071A14E508
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 22:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgA3Vpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 16:45:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43107 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgA3Vpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 16:45:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so5996094wre.10;
        Thu, 30 Jan 2020 13:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wHp3wY6EbskwLtVSraRT0zmeUswYzI0IaeiJ+sQlEAY=;
        b=UBsol0OI94UvcceGUkGGbg9BPk2SYryPULvUtgtT4LJCuK4zNC5sSNi6sKSGdrkZiE
         F1/tT9KaZ8qhWdKzt+292Vb2ml+Bp+TUyJ5wHx7YXTnjBTGUP7kbQn15vaZ9D5hqnWGM
         TIA4a/rT9KIoI+1OurqPl48V7XMRmS3MT+LLGbwplNUk+cKQnsJRdtxTEkXUNgTLKnW+
         0FgxgWfLutvvQPK51TTe7I1hqKwJ7mzK59Or65fdJm89QpG17aBl7ToFeX9+WZBwll/p
         cj16GjSv9ZZB8GgGKQfHoz/kF1+xgZgT2hm+MOERxI/DNTeDrSl5l1izCqNQtDbFAPB6
         mN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wHp3wY6EbskwLtVSraRT0zmeUswYzI0IaeiJ+sQlEAY=;
        b=nzI6iM4OhOdoHvr9g+MlnT2N4ylwAnyqNrnYNhKgPuJsQldfgN0+e7TSHRbdM8DrC4
         lGDmLmMiMR5tqj6YgR4knjS2r5+U3AshOoQ3LV0MMurZ6kkDfdN7xdi5IfGwA5pQWqQN
         tkzDt2fGsvGdRbZayVhhvHPMqBKIIo84fd+mP65+HgOlUAkWv/yPk/697pGJo7R6HO3j
         1ZWn0IRTQ5meJ6M4mtbFw4y3wKk1/gxiHVHROGKWjkgPc/NY2VofVagLydAucQNzRH6n
         VUcz8iOEXAlkQQcH1CHVxwAhI4DVna3Q/Jxc9zFXgtdkSYYB2fFU8YxCACcoGMGQvldV
         b0ow==
X-Gm-Message-State: APjAAAVSB1VGbOPcgeL9GUf4FdctIfftQnKpKMEvtXzHktL/DZxzWCQw
        JVWhwbdNx57d0n6b3ONioug=
X-Google-Smtp-Source: APXvYqzARgdfdA9GrP/iZ3VHGJvyoNKKns7gvUBGHXL/oYoPanZqPLggoX3TmU6Y86PDjyJuCy5AwA==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr8112298wrn.251.1580420745935;
        Thu, 30 Jan 2020 13:45:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:4039:5a2f:e01:48bf? (p200300EA8F29600040395A2F0E0148BF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:4039:5a2f:e01:48bf])
        by smtp.googlemail.com with ESMTPSA id d204sm7941097wmd.30.2020.01.30.13.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 13:45:45 -0800 (PST)
Subject: Re: [PATCH net] net: thunderx: workaround BGX TX Underflow issue
To:     Robert Jones <rjones@gateworks.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        David Miller <davem@davemloft.net>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
References: <20200129223609.9327-1-rjones@gateworks.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <dfb2fb4c-4147-dcd2-7c60-1c3653e1092f@gmail.com>
Date:   Thu, 30 Jan 2020 22:45:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200129223609.9327-1-rjones@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2020 23:36, Robert Jones wrote:
> From: Tim Harvey <tharvey@gateworks.com>
> 
> While it is not yet understood why a TX underflow can easily occur
> for SGMII interfaces resulting in a TX wedge. It has been found that
> disabling/re-enabling the LMAC resolves the issue.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> Reviewed-by: Robert Jones <rjones@gateworks.com>
> ---
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 54 +++++++++++++++++++++++
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.h |  9 ++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> index c4f6ec0..078ecea 100644
> --- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> +++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> @@ -74,6 +74,7 @@ struct bgx {
>  	struct pci_dev		*pdev;
>  	bool                    is_dlm;
>  	bool                    is_rgx;
> +	char			irq_name[7];

Why do you store the name? It's used in probe() only.

>  };
> 
>  static struct bgx *bgx_vnic[MAX_BGX_THUNDER];
> @@ -1535,6 +1536,53 @@ static int bgx_init_phy(struct bgx *bgx)
>  	return bgx_init_of_phy(bgx);
>  }
> 
> +static irqreturn_t bgx_intr_handler(int irq, void *data)
> +{
> +	struct bgx *bgx = (struct bgx *)data;
> +	struct device *dev = &bgx->pdev->dev;
> +	u64 status, val;
> +	int lmac;
> +
> +	for (lmac = 0; lmac < bgx->lmac_count; lmac++) {
> +		status = bgx_reg_read(bgx, lmac, BGX_GMP_GMI_TXX_INT);
> +		if (status & GMI_TXX_INT_UNDFLW) {
> +			dev_err(dev, "BGX%d lmac%d UNDFLW\n", bgx->bgx_id,

Using pci_err() would make your life a lttle easier.

> +				lmac);
> +			val = bgx_reg_read(bgx, lmac, BGX_CMRX_CFG);
> +			val &= ~CMR_EN;
> +			bgx_reg_write(bgx, lmac, BGX_CMRX_CFG, val);
> +			val |= CMR_EN;
> +			bgx_reg_write(bgx, lmac, BGX_CMRX_CFG, val);
> +		}
> +		/* clear interrupts */
> +		bgx_reg_write(bgx, lmac, BGX_GMP_GMI_TXX_INT, status);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int bgx_register_intr(struct pci_dev *pdev)
> +{
> +	struct bgx *bgx = pci_get_drvdata(pdev);
> +	struct device *dev = &pdev->dev;
> +	int num_vec, ret;
> +
> +	/* Enable MSI-X */
> +	num_vec = pci_msix_vec_count(pdev);
> +	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);

Why do you want to enforce using MSI-X? Any interrupt type should be
fine for you, so let the system decide and use PCI_IRQ_ALL_TYPES.
And why do you need more than one vector if all you're interested in
is tx underflow events?

> +	if (ret < 0) {
> +		dev_err(dev, "Req for #%d msix vectors failed\n", num_vec);
> +		return 1;
> +	}
> +	sprintf(bgx->irq_name, "BGX%d", bgx->bgx_id);
> +	ret = request_irq(pci_irq_vector(pdev, GMPX_GMI_TX_INT),
> +		bgx_intr_handler, 0, bgx->irq_name, bgx);

Here using pci_request_irq() would make your life easier.
This function also allows to dynamically create the irq name.

> +	if (ret)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	int err;
> @@ -1604,6 +1652,8 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> 
>  	bgx_init_hw(bgx);
> 
> +	bgx_register_intr(pdev);
> +
>  	/* Enable all LMACs */
>  	for (lmac = 0; lmac < bgx->lmac_count; lmac++) {
>  		err = bgx_lmac_enable(bgx, lmac);
> @@ -1614,6 +1664,10 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  				bgx_lmac_disable(bgx, --lmac);
>  			goto err_enable;
>  		}
> +
> +		/* enable TX FIFO Underflow interrupt */
> +		bgx_reg_modify(bgx, lmac, BGX_GMP_GMI_TXX_INT_ENA_W1S,
> +			       GMI_TXX_INT_UNDFLW);

If allocating an interrupt fails then you most likely don't want to do this.
And do you need this interrupt if the interface is down? If not then you
could think about moving this to the ndo_open() callback.
And the chip interrupt should be masked if not needed any longer.
Else you risk spurious interrupts e.g. after driver unload.

>  	}
> 
>  	return 0;
> diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.h b/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
> index 2588870..cdea493 100644
> --- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
> +++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
> @@ -180,6 +180,15 @@
>  #define BGX_GMP_GMI_TXX_BURST		0x38228
>  #define BGX_GMP_GMI_TXX_MIN_PKT		0x38240
>  #define BGX_GMP_GMI_TXX_SGMII_CTL	0x38300
> +#define BGX_GMP_GMI_TXX_INT		0x38500
> +#define BGX_GMP_GMI_TXX_INT_W1S		0x38508
> +#define BGX_GMP_GMI_TXX_INT_ENA_W1C	0x38510
> +#define BGX_GMP_GMI_TXX_INT_ENA_W1S	0x38518
> +#define  GMI_TXX_INT_PTP_LOST			BIT_ULL(4)
> +#define  GMI_TXX_INT_LATE_COL			BIT_ULL(3)
> +#define  GMI_TXX_INT_XSDEF			BIT_ULL(2)
> +#define  GMI_TXX_INT_XSCOL			BIT_ULL(1)
> +#define  GMI_TXX_INT_UNDFLW			BIT_ULL(0)
> 
>  #define BGX_MSIX_VEC_0_29_ADDR		0x400000 /* +(0..29) << 4 */
>  #define BGX_MSIX_VEC_0_29_CTL		0x400008
> --
> 2.9.2
> 

