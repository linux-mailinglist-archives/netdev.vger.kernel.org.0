Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B62D1EDB
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbfJJDRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:17:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38977 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732616AbfJJDRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:17:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id e1so2721076pgj.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 20:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kY/bVM8NPPhWM5n5R/JBXuhfZP0mLRdPFxKvulfxjhE=;
        b=b/kwKX2g8z5tQN7+hqOe5cv2MC4W999X9JBTtnsuv3jUrBD2IgpLD44BkXwS89jJI2
         FLqDniJeEUDDc/zQfcWZFOmWgPu2g0VBMBrHzrQtMC/hm9g1fTaVq+3XqiMnj0fhaX2n
         Bz6uTXTvKzAnEU263FeXzVs68O3EDz85BnQCnXVLpdX7SaKjOQz6NOXArlqUivDzVkys
         4FsPNsGQRIb0i8W2oBiRKOXmiM89w72HUpALWggVVsQljAwfTm7h4sNXL6hQp7jEv/K5
         5zEfMleJLkwvM2vzTeChPQXF2fgTDmU8yaeNW5hS7Hxb9OphWsIQsmsxypmvgGbecXnj
         lInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kY/bVM8NPPhWM5n5R/JBXuhfZP0mLRdPFxKvulfxjhE=;
        b=O3FnEU3dMbE1IVPfk7p8NCOSy53qgsNBbK6kpSMt0J133UjShWh0FhVqTcREnG9TBR
         EsYwkWYOGmePI0ZLISh+81vQo2KquTfklDh14sAMXCtR8fkhpIip8Qg7kbjlueo+2WId
         gW8U/RhQ8IZeHjIUSKviw2F1Lq98YNtOAbOTFew8EgxBETd1MIVSt8rxmGnECdjf90gK
         HGVJMA505dSrYtkLMMqKrJ76qTUmD1qwoGBg4fpeIl68CZmiy3MPXA4Wc2L0zIT9M9qz
         iHeVj553RzPo3bJtsvsZY9ld1JilX9HExD+Y3UqpL2opoHZgC9zCQ6MNG1eMnG8/4XLK
         0HqA==
X-Gm-Message-State: APjAAAUaoR1kSNb0TzbdDLhOb+0sUBGygqIUAAHwJdphxI52JY7fv92C
        vWXroiwP2TJdJF6+lC1HibIxCQ==
X-Google-Smtp-Source: APXvYqxt0g28r+WeOzUj3UUiSa6duhn4yPHsl+IVBqo3qzlng2jdfRfrxmVchTG8XnNUuQvQ4Xh9nQ==
X-Received: by 2002:a17:90a:195d:: with SMTP id 29mr8564999pjh.130.1570677448982;
        Wed, 09 Oct 2019 20:17:28 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id s21sm3861589pgv.37.2019.10.09.20.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 20:17:28 -0700 (PDT)
Date:   Wed, 9 Oct 2019 20:17:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v8 3/5] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20191009201714.19296e3f@cakuba.netronome.com>
In-Reply-To: <20191009101713.12238-4-tbogendoerfer@suse.de>
References: <20191009101713.12238-1-tbogendoerfer@suse.de>
        <20191009101713.12238-4-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 12:17:10 +0200, Thomas Bogendoerfer wrote:
> SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> It also supports connecting a SuperIO chip for serial and parallel
> interfaces. IOC3 is used inside various SGI systemboards and add-on
> cards with different equipped external interfaces.
> 
> Support for ethernet and serial interfaces were implemented inside
> the network driver. This patchset moves out the not network related
> parts to a new MFD driver, which takes care of card detection,
> setup of platform devices and interrupt distribution for the subdevices.
> 
> Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

> +static int ip27_baseio6g_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 2);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_m48t35_setup(ipd);
> +	if (ret)
> +		return ret;
> +
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +static int ip27_mio_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +static int ip29_sysboard_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 1);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_m48t35_setup(ipd);
> +	if (ret)
> +		return ret;
> +
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +static int ioc3_menet_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 4);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +
> +	return ioc3_serial_setup(ipd);
> +}
> +
> +static int ioc3_menet4_setup(struct ioc3_priv_data *ipd)
> +{
> +	return ioc3_eth_setup(ipd, false);
> +}
> +
> +static int ioc3_cad_duo_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
> +	if (ret)
> +		return ret;
> +
> +	ret = ioc3_eth_setup(ipd, true);
> +	if (ret)
> +		return ret;
> +
> +	return ioc3_kbd_setup(ipd);
> +}

None of these setup calls have a "cleanup" or un-setup call. Is this
really okay? I know nothing about MFD, but does mfd_add_devices() not
require a remove for example?  Doesn't the IRQ handling need cleanup?

> +/* Helper macro for filling ioc3_info array */
> +#define IOC3_SID(_name, _sid, _setup) \
> +	{								   \
> +		.name = _name,						   \
> +		.sid = (PCI_VENDOR_ID_SGI << 16) | IOC3_SUBSYS_ ## _sid,   \
> +		.setup = _setup,					   \
> +	}
> +
> +static struct {
> +	const char *name;
> +	u32 sid;
> +	int (*setup)(struct ioc3_priv_data *ipd);
> +} ioc3_infos[] = {
> +	IOC3_SID("IP27 BaseIO6G", IP27_BASEIO6G, &ip27_baseio6g_setup),
> +	IOC3_SID("IP27 MIO", IP27_MIO, &ip27_mio_setup),
> +	IOC3_SID("IP27 BaseIO", IP27_BASEIO, &ip27_baseio_setup),
> +	IOC3_SID("IP29 System Board", IP29_SYSBOARD, &ip29_sysboard_setup),
> +	IOC3_SID("MENET", MENET, &ioc3_menet_setup),
> +	IOC3_SID("MENET4", MENET4, &ioc3_menet4_setup)
> +};
> +#undef IOC3_SID
> +
> +static int ioc3_setup(struct ioc3_priv_data *ipd)
> +{
> +	u32 sid;
> +	int i;
> +
> +	/* Clear IRQs */
> +	writel(~0, &ipd->regs->sio_iec);
> +	writel(~0, &ipd->regs->sio_ir);
> +	writel(0, &ipd->regs->eth.eier);
> +	writel(~0, &ipd->regs->eth.eisr);
> +
> +	/* Read subsystem vendor id and subsystem id */
> +	pci_read_config_dword(ipd->pdev, PCI_SUBSYSTEM_VENDOR_ID, &sid);
> +
> +	for (i = 0; i < ARRAY_SIZE(ioc3_infos); i++)
> +		if (sid == ioc3_infos[i].sid) {
> +			pr_info("ioc3: %s\n", ioc3_infos[i].name);
> +			return ioc3_infos[i].setup(ipd);
> +		}
> +
> +	/* Treat everything not identified by PCI subid as CAD DUO */
> +	pr_info("ioc3: CAD DUO\n");
> +	return ioc3_cad_duo_setup(ipd);
> +}
> +
> +static int ioc3_mfd_probe(struct pci_dev *pdev,
> +			  const struct pci_device_id *pci_id)
> +{
> +	struct ioc3_priv_data *ipd;
> +	struct ioc3 __iomem *regs;
> +	int ret;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, IOC3_LATENCY);
> +	pci_set_master(pdev);
> +
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_warn(&pdev->dev,
> +			 "Failed to set 64-bit DMA mask, trying 32-bit\n");
> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			dev_err(&pdev->dev, "Can't set DMA mask, aborting\n");
> +			return ret;

So failing here we don't care about disabling the pci deivce..

> +		}
> +	}
> +
> +	/* Set up per-IOC3 data */
> +	ipd = devm_kzalloc(&pdev->dev, sizeof(struct ioc3_priv_data),
> +			   GFP_KERNEL);
> +	if (!ipd) {
> +		ret = -ENOMEM;
> +		goto out_disable_device;

..but here we do?

> +	}
> +	ipd->pdev = pdev;
> +
> +	/*
> +	 * Map all IOC3 registers.  These are shared between subdevices
> +	 * so the main IOC3 module manages them.
> +	 */
> +	regs = pci_ioremap_bar(pdev, 0);

This doesn't seem unmapped on error paths, nor remove?

> +	if (!regs) {
> +		dev_warn(&pdev->dev, "ioc3: Unable to remap PCI BAR for %s.\n",
> +			 pci_name(pdev));
> +		ret = -ENOMEM;
> +		goto out_disable_device;
> +	}
> +	ipd->regs = regs;
> +
> +	/* Track PCI-device specific data */
> +	pci_set_drvdata(pdev, ipd);
> +
> +	ret = ioc3_setup(ipd);
> +	if (ret)
> +		goto out_disable_device;
> +
> +	return 0;
> +
> +out_disable_device:
> +	pci_disable_device(pdev);
> +	return ret;
> +}
> +
> +static void ioc3_mfd_remove(struct pci_dev *pdev)
> +{
> +	struct ioc3_priv_data *ipd;
> +
> +	ipd = pci_get_drvdata(pdev);
> +
> +	/* Clear and disable all IRQs */
> +	writel(~0, &ipd->regs->sio_iec);
> +	writel(~0, &ipd->regs->sio_ir);
> +
> +	/* Release resources */
> +	if (ipd->domain) {
> +		irq_domain_remove(ipd->domain);
> +		free_irq(ipd->domain_irq, (void *)ipd);
> +	}
> +	pci_disable_device(pdev);
> +}
> +
> +static struct pci_device_id ioc3_mfd_id_table[] = {
> +	{ PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC3, PCI_ANY_ID, PCI_ANY_ID },
> +	{ 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, ioc3_mfd_id_table);
> +
> +static struct pci_driver ioc3_mfd_driver = {
> +	.name = "IOC3",
> +	.id_table = ioc3_mfd_id_table,
> +	.probe = ioc3_mfd_probe,
> +	.remove = ioc3_mfd_remove,
> +};
> +
> +module_pci_driver(ioc3_mfd_driver);
> +
> +MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfer@suse.de>");
> +MODULE_DESCRIPTION("SGI IOC3 MFD driver");
> +MODULE_LICENSE("GPL v2");
