Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B0C218530
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgGHKnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgGHKnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 06:43:17 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089AC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 03:43:17 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so41261160edb.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 03:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=qQUw/m5dPWqaUtm1QGUmKPUd6rNgSK3c1WDMgadyuQU=;
        b=NWaxEzchKzL2dyCGJv3mBTmPqwKK3A/r8gcuZAvYNI+CNBOxlyEhWv0d56OBP61wKj
         FJwUjDEcolsFp6PxkFymeCoXzPhoaDum+rmLoQ/B//DPUKH29e0YjKCoD+63IB/Jusdy
         GUnUP2fpF4vVJ0Ab5u88g5Jtx0e3bEoJb0uOfPnG2+cMiYbkgHkbd74NbCxWBAuKNPr8
         4ul5rjsHNGr047LizKndHxju/mEJYzljDS5/sOuIYUenxR6qSo9RfTINtMOASZpgpdy1
         v7F4fiexnXwZs4zVhZgsPkpoCPnOR7tLULSbpmNgKtvtpjK6D9Fdr5h+H9IZ1XRky6yJ
         A8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=qQUw/m5dPWqaUtm1QGUmKPUd6rNgSK3c1WDMgadyuQU=;
        b=lBsI/+UIrRxQ8bdVXIZlji195a+7CqwC4lnpv25FCSoBi7GtQZ+wODO/EuKhOxEjdb
         WUa/S0SqQE3++NEvjuAc07QIO1yieQT/G14BPaDt3dfE2kaaQT7GfBRjDfsQksRynIQg
         7S+fvpDwDRNy5DJBFpHhekYe5Wzd7Az4dftRmFVc2P0knc1+iuAd9aBh8hfjEX0WodhB
         YDIQJB/9e8mNchOTh0fkGUs0/ZLPctT7uDLi/3SCEhj5zVNiKx3VOXBsSquv0LgvsAsi
         Y7uBpHNowl/qUO1hphtVuq+7kHy4GBp4Qttf3pMUxhnyixhDiTUL44ptRrIxYXrRD/6I
         gtng==
X-Gm-Message-State: AOAM533KzTrc8Mhei7tLtfILdErtxTFPK+HbIHxXWETthlGGBDVw+aLR
        RN7XwHcKIPY06Ki+64GT8En7y/mqB71aDIaH4MPZLQ==
X-Google-Smtp-Source: ABdhPJzEa9ajUiJz23roTV6kpHpX1754dz4EdyYOHi1EqT8HZ++9AzZ5w67qZnJM0hCUvBCyXyVsyOUl6/cpW7fdBW0=
X-Received: by 2002:aa7:d446:: with SMTP id q6mr66669945edr.218.1594204995887;
 Wed, 08 Jul 2020 03:43:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Wed, 8 Jul 2020 03:43:15 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <CAOJe8K0aYeba0fOpSz6dzgWUwAP8FTyOpQc8rckWO=RPTKiprw@mail.gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
 <20200701165057.667799-7-vaibhavgupta40@gmail.com> <CAOJe8K0aYeba0fOpSz6dzgWUwAP8FTyOpQc8rckWO=RPTKiprw@mail.gmail.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 8 Jul 2020 13:43:15 +0300
Message-ID: <CAOJe8K3j=FJ2-J+CqeG-hUXApi+UgqX83U20m-2YpgD+tEvgPg@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] sundance: use generic power management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/20, Denis Kirjanov <kda@linux-powerpc.org> wrote:
> On 7/1/20, Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:
>> With legacy PM, drivers themselves were responsible for managing the
>> device's power states and takes care of register states.
>>
>> After upgrading to the generic structure, PCI core will take care of
>> required tasks and drivers should do only device-specific operations.
>>
>> Thus, there is no need to call the PCI helper functions like
>> pci_enable/disable_device(), pci_save/restore_sate() and
>> pci_set_power_state().
>>
>> Compile-tested only.
>>
>> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
>
> Should be fine. I'll try to test it in the upcoming weekend

Unfortunately the suspend mode is broken on my test machine so I will
take some time :/

>
>> ---
>>  drivers/net/ethernet/dlink/sundance.c | 27 ++++++++-------------------
>>  1 file changed, 8 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/dlink/sundance.c
>> b/drivers/net/ethernet/dlink/sundance.c
>> index dc566fcc3ba9..ca97e321082d 100644
>> --- a/drivers/net/ethernet/dlink/sundance.c
>> +++ b/drivers/net/ethernet/dlink/sundance.c
>> @@ -1928,11 +1928,9 @@ static void sundance_remove1(struct pci_dev *pdev)
>>  	}
>>  }
>>
>> -#ifdef CONFIG_PM
>> -
>> -static int sundance_suspend(struct pci_dev *pci_dev, pm_message_t state)
>> +static int __maybe_unused sundance_suspend(struct device *dev_d)
>>  {
>> -	struct net_device *dev = pci_get_drvdata(pci_dev);
>> +	struct net_device *dev = dev_get_drvdata(dev_d);
>>  	struct netdev_private *np = netdev_priv(dev);
>>  	void __iomem *ioaddr = np->base;
>>
>> @@ -1942,30 +1940,24 @@ static int sundance_suspend(struct pci_dev
>> *pci_dev,
>> pm_message_t state)
>>  	netdev_close(dev);
>>  	netif_device_detach(dev);
>>
>> -	pci_save_state(pci_dev);
>>  	if (np->wol_enabled) {
>>  		iowrite8(AcceptBroadcast | AcceptMyPhys, ioaddr + RxMode);
>>  		iowrite16(RxEnable, ioaddr + MACCtrl1);
>>  	}
>> -	pci_enable_wake(pci_dev, pci_choose_state(pci_dev, state),
>> -			np->wol_enabled);
>> -	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
>> +
>> +	device_set_wakeup_enable(dev_d, np->wol_enabled);
>>
>>  	return 0;
>>  }
>>
>> -static int sundance_resume(struct pci_dev *pci_dev)
>> +static int __maybe_unused sundance_resume(struct device *dev_d)
>>  {
>> -	struct net_device *dev = pci_get_drvdata(pci_dev);
>> +	struct net_device *dev = dev_get_drvdata(dev_d);
>>  	int err = 0;
>>
>>  	if (!netif_running(dev))
>>  		return 0;
>>
>> -	pci_set_power_state(pci_dev, PCI_D0);
>> -	pci_restore_state(pci_dev);
>> -	pci_enable_wake(pci_dev, PCI_D0, 0);
>> -
>>  	err = netdev_open(dev);
>>  	if (err) {
>>  		printk(KERN_ERR "%s: Can't resume interface!\n",
>> @@ -1979,17 +1971,14 @@ static int sundance_resume(struct pci_dev
>> *pci_dev)
>>  	return err;
>>  }
>>
>> -#endif /* CONFIG_PM */
>> +static SIMPLE_DEV_PM_OPS(sundance_pm_ops, sundance_suspend,
>> sundance_resume);
>>
>>  static struct pci_driver sundance_driver = {
>>  	.name		= DRV_NAME,
>>  	.id_table	= sundance_pci_tbl,
>>  	.probe		= sundance_probe1,
>>  	.remove		= sundance_remove1,
>> -#ifdef CONFIG_PM
>> -	.suspend	= sundance_suspend,
>> -	.resume		= sundance_resume,
>> -#endif /* CONFIG_PM */
>> +	.driver.pm	= &sundance_pm_ops,
>>  };
>>
>>  static int __init sundance_init(void)
>> --
>> 2.27.0
>>
>>
>
