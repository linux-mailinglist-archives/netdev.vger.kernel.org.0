Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9188034BA14
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 00:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhC0XE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 19:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhC0XEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 19:04:45 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C473DC0613B1;
        Sat, 27 Mar 2021 16:04:44 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo4775610wmq.4;
        Sat, 27 Mar 2021 16:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=snWyNPodbIR6HkxcIuXXV8OPNOrHvvdrfk+pXY31DcE=;
        b=CWIudhNyz/nl7iuDvxdeqM3vXbGlElZZyhTFM83hC1M4/Ip8FbhKdf3pj40ms5MKah
         qKp81YpbUS2Jsyon5Hf0rxWrPh4GRAfB8rOq7Zqntag9ydkAl+QJncA93yU3SZ9FHdjG
         QWs6b85mqteJd5VY+0Cygno+u/TALeCT8gAUA6Ba4fOxAFv3Xru5hUug4Wh7cxbeYTbp
         xTw5UhTsqG6dh+/dMvODH3Miq9dktWUrO9WpLH4tcznc9mT7jZqJ7/9dDs677RZbf4Tk
         ENm/P3MtyrfQh73mzpbpIUe5QWOxaFjcINoS30ekjMEvECUwFzTd2xYdB1cEuF7jMMXr
         eKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=snWyNPodbIR6HkxcIuXXV8OPNOrHvvdrfk+pXY31DcE=;
        b=F4e3MNr0ryAXBJy3chWxQDhnP9DMg6+1x84Dd+tgSu7dAhTZohz9w7Ru4kcfiAeJiO
         pzKwAmsKt4YSptbmd2DGloUTQepAVCTDRXFmco88RXKXg4NHIZM+rimuHi+tsmvBCLze
         cXau+DFwGx3uJLF0QihVUrRQ1FZnvz56hSLNqpE6TjhPBBpagT66AQZGT9Uu+t+GmERH
         mehT3XXshaRhPhG3IvYDWVPj5MDZlKKVA3UoIMN6/0RO0rpVW7aAUnY3caKSQm0zV1ih
         4zY97afwpvrdoN1/eKtACL27x2wlrp3JzUDOT5WlXdb0AWUtCeRFkG8WVUjGKGGtEhPb
         wXsg==
X-Gm-Message-State: AOAM532DN7h0NKWWI/vbO9yUr4Ep1rngom172IOtUCP40jWJvVw3JAWe
        Q8fEouxGq1TtjgeMLriAG1A=
X-Google-Smtp-Source: ABdhPJwRVnPYyXbX+KtiJLbDjS3+jA+2TDwRM5DHGuuG/KNu+EZcjuY9Ky7yF7QNN6HPhnZmgL+Z9w==
X-Received: by 2002:a05:600c:201:: with SMTP id 1mr18278261wmi.167.1616886283279;
        Sat, 27 Mar 2021 16:04:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:a4c4:1ceb:21bd:aae8? (p200300ea8f1fbb00a4c41ceb21bdaae8.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:a4c4:1ceb:21bd:aae8])
        by smtp.googlemail.com with ESMTPSA id c16sm24647160wrs.81.2021.03.27.16.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 16:04:42 -0700 (PDT)
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210326212655.GA912670@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
Message-ID: <5b59c7b3-6e41-b7cf-b77d-274a88f2c5e1@gmail.com>
Date:   Sun, 28 Mar 2021 00:04:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210326212655.GA912670@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.03.2021 22:26, Bjorn Helgaas wrote:
> [+cc Randy, Andrew (though I'm sure you have zero interest in this
> ancient question :))]
> 
> On Wed, Dec 09, 2020 at 09:31:21AM +0100, Heiner Kallweit wrote:
>> pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
>> former one is declared as __must_check. However also some callers of
>> pci_set_mwi() have a comment that it's an optional feature. I don't
>> think there's much sense in this separation and the use of
>> __must_check. Therefore remove pci_try_set_mwi() and remove the
>> __must_check attribute from pci_set_mwi().
>> I don't expect either function to be used in new code anyway.
> 
> There's not much I like better than removing things.  But some
> significant thought went into adding pci_try_set_mwi() in the first
> place, so I need a little more convincing about why it's safe to
> remove it.
> 

Thanks for the link to the 13 yrs old discussion. Unfortunately it
doesn't mention any real argument for the __must_check, just:

"And one of the reasons for adding the __must_check annotation is to
weed out design errors."
And the very next response in the discussion calls this a "non-argument".
Plus not mentioning what the other reasons could be.

Currently we have three ancient drivers that bail out if the call fails.
Most callers of pci_set_mwi() use the return code only to emit an
error message, but they proceed normally. Majority of users calls
pci_try_set_mwi(). And as stated in the commit message I don't expect
any new usage of pci_set_mwi().

> The argument should cite the discussion about adding it.  I think one
> of the earliest conversations is here:
> https://lore.kernel.org/linux-ide/20070404213704.224128ec.randy.dunlap@oracle.com/
> 
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> patch applies on top of pci/misc for v5.11
>> ---
>>  Documentation/PCI/pci.rst                     |  5 +----
>>  drivers/ata/pata_cs5530.c                     |  2 +-
>>  drivers/ata/sata_mv.c                         |  2 +-
>>  drivers/dma/dw/pci.c                          |  2 +-
>>  drivers/dma/hsu/pci.c                         |  2 +-
>>  drivers/ide/cs5530.c                          |  2 +-
>>  drivers/mfd/intel-lpss-pci.c                  |  2 +-
>>  drivers/net/ethernet/adaptec/starfire.c       |  2 +-
>>  drivers/net/ethernet/alacritech/slicoss.c     |  2 +-
>>  drivers/net/ethernet/dec/tulip/tulip_core.c   |  5 +----
>>  drivers/net/ethernet/sun/cassini.c            |  4 ++--
>>  drivers/net/wireless/intersil/p54/p54pci.c    |  2 +-
>>  .../intersil/prism54/islpci_hotplug.c         |  3 +--
>>  .../wireless/realtek/rtl818x/rtl8180/dev.c    |  2 +-
>>  drivers/pci/pci.c                             | 19 -------------------
>>  drivers/scsi/3w-9xxx.c                        |  4 ++--
>>  drivers/scsi/3w-sas.c                         |  4 ++--
>>  drivers/scsi/csiostor/csio_init.c             |  2 +-
>>  drivers/scsi/lpfc/lpfc_init.c                 |  2 +-
>>  drivers/scsi/qla2xxx/qla_init.c               |  8 ++++----
>>  drivers/scsi/qla2xxx/qla_mr.c                 |  2 +-
>>  drivers/tty/serial/8250/8250_lpss.c           |  2 +-
>>  drivers/usb/chipidea/ci_hdrc_pci.c            |  2 +-
>>  drivers/usb/gadget/udc/amd5536udc_pci.c       |  2 +-
>>  drivers/usb/gadget/udc/net2280.c              |  2 +-
>>  drivers/usb/gadget/udc/pch_udc.c              |  2 +-
>>  include/linux/pci.h                           |  5 ++---
>>  27 files changed, 33 insertions(+), 60 deletions(-)
>>
>> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
>> index 814b40f83..120362cc9 100644
>> --- a/Documentation/PCI/pci.rst
>> +++ b/Documentation/PCI/pci.rst
>> @@ -226,10 +226,7 @@ If the PCI device can use the PCI Memory-Write-Invalidate transaction,
>>  call pci_set_mwi().  This enables the PCI_COMMAND bit for Mem-Wr-Inval
>>  and also ensures that the cache line size register is set correctly.
>>  Check the return value of pci_set_mwi() as not all architectures
>> -or chip-sets may support Memory-Write-Invalidate.  Alternatively,
>> -if Mem-Wr-Inval would be nice to have but is not required, call
>> -pci_try_set_mwi() to have the system do its best effort at enabling
>> -Mem-Wr-Inval.
>> +or chip-sets may support Memory-Write-Invalidate.
>>  
>>  
>>  Request MMIO/IOP resources
>> diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
>> index ad75d02b6..8654b3ae1 100644
>> --- a/drivers/ata/pata_cs5530.c
>> +++ b/drivers/ata/pata_cs5530.c
>> @@ -214,7 +214,7 @@ static int cs5530_init_chip(void)
>>  	}
>>  
>>  	pci_set_master(cs5530_0);
>> -	pci_try_set_mwi(cs5530_0);
>> +	pci_set_mwi(cs5530_0);
>>  
>>  	/*
>>  	 * Set PCI CacheLineSize to 16-bytes:
>> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
>> index 664ef658a..ee37755ea 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -4432,7 +4432,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
>>  	mv_print_info(host);
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  	return ata_host_activate(host, pdev->irq, mv_interrupt, IRQF_SHARED,
>>  				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
>>  }
>> diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
>> index 1142aa6f8..1c20b7485 100644
>> --- a/drivers/dma/dw/pci.c
>> +++ b/drivers/dma/dw/pci.c
>> @@ -30,7 +30,7 @@ static int dw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>>  	if (ret)
>> diff --git a/drivers/dma/hsu/pci.c b/drivers/dma/hsu/pci.c
>> index 07cc7320a..420dd3706 100644
>> --- a/drivers/dma/hsu/pci.c
>> +++ b/drivers/dma/hsu/pci.c
>> @@ -73,7 +73,7 @@ static int hsu_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>>  	if (ret)
>> diff --git a/drivers/ide/cs5530.c b/drivers/ide/cs5530.c
>> index 5bb46e713..5d2c421ab 100644
>> --- a/drivers/ide/cs5530.c
>> +++ b/drivers/ide/cs5530.c
>> @@ -168,7 +168,7 @@ static int init_chipset_cs5530(struct pci_dev *dev)
>>  	 */
>>  
>>  	pci_set_master(cs5530_0);
>> -	pci_try_set_mwi(cs5530_0);
>> +	pci_set_mwi(cs5530_0);
>>  
>>  	/*
>>  	 * Set PCI CacheLineSize to 16-bytes:
>> diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
>> index 2d7c588ef..a0c3be750 100644
>> --- a/drivers/mfd/intel-lpss-pci.c
>> +++ b/drivers/mfd/intel-lpss-pci.c
>> @@ -39,7 +39,7 @@ static int intel_lpss_pci_probe(struct pci_dev *pdev,
>>  
>>  	/* Probably it is enough to set this for iDMA capable devices only */
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	ret = intel_lpss_probe(&pdev->dev, info);
>>  	if (ret)
>> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
>> index 555299737..1dbff34c4 100644
>> --- a/drivers/net/ethernet/adaptec/starfire.c
>> +++ b/drivers/net/ethernet/adaptec/starfire.c
>> @@ -679,7 +679,7 @@ static int starfire_init_one(struct pci_dev *pdev,
>>  	pci_set_master(pdev);
>>  
>>  	/* enable MWI -- it vastly improves Rx performance on sparc64 */
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  #ifdef ZEROCOPY
>>  	/* Starfire can do TCP/UDP checksumming */
>> diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
>> index 696517eae..544510f57 100644
>> --- a/drivers/net/ethernet/alacritech/slicoss.c
>> +++ b/drivers/net/ethernet/alacritech/slicoss.c
>> @@ -1749,7 +1749,7 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	slic_configure_pci(pdev);
>>  
>> diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
>> index c1dcd6ca1..4f6debb24 100644
>> --- a/drivers/net/ethernet/dec/tulip/tulip_core.c
>> +++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
>> @@ -1193,10 +1193,7 @@ static void tulip_mwi_config(struct pci_dev *pdev, struct net_device *dev)
>>  	/* if we have any cache line size at all, we can do MRM and MWI */
>>  	csr0 |= MRM | MWI;
>>  
>> -	/* Enable MWI in the standard PCI command bit.
>> -	 * Check for the case where MWI is desired but not available
>> -	 */
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* read result from hardware (in case bit refused to enable) */
>>  	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
>> diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
>> index 9ff894ba8..9a95ec989 100644
>> --- a/drivers/net/ethernet/sun/cassini.c
>> +++ b/drivers/net/ethernet/sun/cassini.c
>> @@ -4933,14 +4933,14 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  	pci_cmd &= ~PCI_COMMAND_SERR;
>>  	pci_cmd |= PCI_COMMAND_PARITY;
>>  	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
>> -	if (pci_try_set_mwi(pdev))
>> +	if (pci_set_mwi(pdev))
>>  		pr_warn("Could not enable MWI for %s\n", pci_name(pdev));
>>  
>>  	cas_program_bridge(pdev);
>>  
>>  	/*
>>  	 * On some architectures, the default cache line size set
>> -	 * by pci_try_set_mwi reduces perforamnce.  We have to increase
>> +	 * by pci_set_mwi reduces performance.  We have to increase
>>  	 * it for this case.  To start, we'll print some configuration
>>  	 * data.
>>  	 */
>> diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
>> index e97ee547b..c76326d1e 100644
>> --- a/drivers/net/wireless/intersil/p54/p54pci.c
>> +++ b/drivers/net/wireless/intersil/p54/p54pci.c
>> @@ -583,7 +583,7 @@ static int p54p_probe(struct pci_dev *pdev,
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	pci_write_config_byte(pdev, 0x40, 0);
>>  	pci_write_config_byte(pdev, 0x41, 0);
>> diff --git a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
>> index 31a1e6132..e8087d9a5 100644
>> --- a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
>> +++ b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
>> @@ -153,8 +153,7 @@ prism54_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  	DEBUG(SHOW_TRACING, "%s: pci_set_master(pdev)\n", DRV_NAME);
>>  	pci_set_master(pdev);
>>  
>> -	/* enable MWI */
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* setup the network device interface and its structure */
>>  	if (!(ndev = islpci_setup(pdev))) {
>> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
>> index 2477e18c7..b259b0b58 100644
>> --- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
>> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
>> @@ -1871,7 +1871,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
>>  
>>  	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
>>  		priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
>> -		pci_try_set_mwi(pdev);
>> +		pci_set_mwi(pdev);
>>  	}
>>  
>>  	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180)
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 9a5500287..f0ab432d2 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -4389,25 +4389,6 @@ int pcim_set_mwi(struct pci_dev *dev)
>>  }
>>  EXPORT_SYMBOL(pcim_set_mwi);
>>  
>> -/**
>> - * pci_try_set_mwi - enables memory-write-invalidate PCI transaction
>> - * @dev: the PCI device for which MWI is enabled
>> - *
>> - * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
>> - * Callers are not required to check the return value.
>> - *
>> - * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
>> - */
>> -int pci_try_set_mwi(struct pci_dev *dev)
>> -{
>> -#ifdef PCI_DISABLE_MWI
>> -	return 0;
>> -#else
>> -	return pci_set_mwi(dev);
>> -#endif
>> -}
>> -EXPORT_SYMBOL(pci_try_set_mwi);
>> -
>>  /**
>>   * pci_clear_mwi - disables Memory-Write-Invalidate for device dev
>>   * @dev: the PCI device to disable
>> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
>> index b4718a1b2..d869485e2 100644
>> --- a/drivers/scsi/3w-9xxx.c
>> +++ b/drivers/scsi/3w-9xxx.c
>> @@ -2018,7 +2018,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>>  	if (retval)
>> @@ -2227,7 +2227,7 @@ static int __maybe_unused twa_resume(struct device *dev)
>>  
>>  	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
>>  
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>>  	if (retval)
>> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
>> index b8f1848ec..49ca153b8 100644
>> --- a/drivers/scsi/3w-sas.c
>> +++ b/drivers/scsi/3w-sas.c
>> @@ -1571,7 +1571,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>>  	if (retval)
>> @@ -1790,7 +1790,7 @@ static int __maybe_unused twl_resume(struct device *dev)
>>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
>>  
>>  	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_no);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>>  	if (retval)
>> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
>> index 390b07bf9..c20bf44c6 100644
>> --- a/drivers/scsi/csiostor/csio_init.c
>> +++ b/drivers/scsi/csiostor/csio_init.c
>> @@ -201,7 +201,7 @@ csio_pci_init(struct pci_dev *pdev, int *bars)
>>  		goto err_disable_device;
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	rv = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>>  	if (rv)
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>> index ac67f420e..b4833c0f8 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -6119,7 +6119,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>  		goto out_disable_device;
>>  	/* Set up device as PCI master and save state for EEH */
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  	pci_save_state(pdev);
>>  
>>  	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
>> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
>> index 5626e9b69..76019dc2e 100644
>> --- a/drivers/scsi/qla2xxx/qla_init.c
>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>> @@ -2356,7 +2356,7 @@ qla2100_pci_config(scsi_qla_host_t *vha)
>>  	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
>>  
>>  	pci_set_master(ha->pdev);
>> -	pci_try_set_mwi(ha->pdev);
>> +	pci_set_mwi(ha->pdev);
>>  
>>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>>  	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
>> @@ -2388,7 +2388,7 @@ qla2300_pci_config(scsi_qla_host_t *vha)
>>  	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
>>  
>>  	pci_set_master(ha->pdev);
>> -	pci_try_set_mwi(ha->pdev);
>> +	pci_set_mwi(ha->pdev);
>>  
>>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>>  	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
>> @@ -2469,7 +2469,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
>>  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
>>  
>>  	pci_set_master(ha->pdev);
>> -	pci_try_set_mwi(ha->pdev);
>> +	pci_set_mwi(ha->pdev);
>>  
>>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>>  	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
>> @@ -2511,7 +2511,7 @@ qla25xx_pci_config(scsi_qla_host_t *vha)
>>  	struct qla_hw_data *ha = vha->hw;
>>  
>>  	pci_set_master(ha->pdev);
>> -	pci_try_set_mwi(ha->pdev);
>> +	pci_set_mwi(ha->pdev);
>>  
>>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>>  	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
>> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
>> index ca7306685..e9763d8e3 100644
>> --- a/drivers/scsi/qla2xxx/qla_mr.c
>> +++ b/drivers/scsi/qla2xxx/qla_mr.c
>> @@ -499,7 +499,7 @@ qlafx00_pci_config(scsi_qla_host_t *vha)
>>  	struct qla_hw_data *ha = vha->hw;
>>  
>>  	pci_set_master(ha->pdev);
>> -	pci_try_set_mwi(ha->pdev);
>> +	pci_set_mwi(ha->pdev);
>>  
>>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
>>  	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
>> diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
>> index 4dee8a9e0..8acc1e5c9 100644
>> --- a/drivers/tty/serial/8250/8250_lpss.c
>> +++ b/drivers/tty/serial/8250/8250_lpss.c
>> @@ -193,7 +193,7 @@ static void qrk_serial_setup_dma(struct lpss8250 *lpss, struct uart_port *port)
>>  	if (ret)
>>  		return;
>>  
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* Special DMA address for UART */
>>  	dma->rx_dma_addr = 0xfffff000;
>> diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
>> index d63479e1a..d412fa910 100644
>> --- a/drivers/usb/chipidea/ci_hdrc_pci.c
>> +++ b/drivers/usb/chipidea/ci_hdrc_pci.c
>> @@ -78,7 +78,7 @@ static int ci_hdrc_pci_probe(struct pci_dev *pdev,
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* register a nop PHY */
>>  	ci->phy = usb_phy_generic_register();
>> diff --git a/drivers/usb/gadget/udc/amd5536udc_pci.c b/drivers/usb/gadget/udc/amd5536udc_pci.c
>> index 8d387e0e4..9630ce8d3 100644
>> --- a/drivers/usb/gadget/udc/amd5536udc_pci.c
>> +++ b/drivers/usb/gadget/udc/amd5536udc_pci.c
>> @@ -151,7 +151,7 @@ static int udc_pci_probe(
>>  	dev->chiprev = pdev->revision;
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* init dma pools */
>>  	if (use_dma) {
>> diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
>> index fc9f99fe7..e15520698 100644
>> --- a/drivers/usb/gadget/udc/net2280.c
>> +++ b/drivers/usb/gadget/udc/net2280.c
>> @@ -3761,7 +3761,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  			&dev->pci->pcimstctl);
>>  	/* erratum 0115 shouldn't appear: Linux inits PCI_LATENCY_TIMER */
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* ... also flushes any posted pci writes */
>>  	dev->chiprev = get_idx_reg(dev->regs, REG_CHIPREV) & 0xffff;
>> diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
>> index a3c1fc924..4a0484a0c 100644
>> --- a/drivers/usb/gadget/udc/pch_udc.c
>> +++ b/drivers/usb/gadget/udc/pch_udc.c
>> @@ -3100,7 +3100,7 @@ static int pch_udc_probe(struct pci_dev *pdev,
>>  	}
>>  
>>  	pci_set_master(pdev);
>> -	pci_try_set_mwi(pdev);
>> +	pci_set_mwi(pdev);
>>  
>>  	/* device struct setup */
>>  	spin_lock_init(&dev->lock);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index de75f6a4d..c590f616d 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1191,9 +1191,8 @@ void pci_clear_master(struct pci_dev *dev);
>>  
>>  int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
>>  int pci_set_cacheline_size(struct pci_dev *dev);
>> -int __must_check pci_set_mwi(struct pci_dev *dev);
>> -int __must_check pcim_set_mwi(struct pci_dev *dev);
>> -int pci_try_set_mwi(struct pci_dev *dev);
>> +int pci_set_mwi(struct pci_dev *dev);
>> +int pcim_set_mwi(struct pci_dev *dev);
>>  void pci_clear_mwi(struct pci_dev *dev);
>>  void pci_intx(struct pci_dev *dev, int enable);
>>  bool pci_check_and_mask_intx(struct pci_dev *dev);
>> -- 
>> 2.29.2
>>

