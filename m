Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED0E11D777
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfLLTw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:52:27 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35753 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730654AbfLLTw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:52:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so1405681pfo.2
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 11:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=TYu3pDrovLqUSL2alwUx1VxouuEtcvTuDhh7F/MrhZk=;
        b=dTj4MQWgMxHS7gPK9HSYEbAd7r4JP+kNLxiqei+KnPQn2Fx2AXcSWrIcKUAU/fsB3s
         lnapf5JYbQ/Svxe60f90QTCYemjdAt56FSiYezEiAETKU4FgYSiVmF5i+IilRZ5m2jbc
         pJegcOR4SOpnX18qMlJrfCs3h//MBfIbsrUpBT647PmnLkVY7Hz9R9Xt3DYn+fM/cFDV
         kQbVmsjLDtgNK9rSQx+CijEtp7WcQXTrTLlIVizHiQ0TrKWqZy1XbqaehtNFp3MgGoKT
         H221BVgiJvW4gBNKFG/0PFr3MBKEys7EYEb6lkV3n2bb2PDfKaRarWwvE/vlKzd7QLZt
         rSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TYu3pDrovLqUSL2alwUx1VxouuEtcvTuDhh7F/MrhZk=;
        b=VP/y1wCLd2Fl0veU0sCGjBsJQ3W3XoYLmzYfJ04NflVT0XfUvV0W+ouUwihQ+f+Z97
         xqbDsWB5i8ZpQiTBfjV2SYC5tAhKUd8miPsW+kxvfO7oWprym/ZYCTOzK1NVSDw82DJi
         3PFZFI+IrKRcohMsXWUb4zoTdRBiqoPteKm+1xQsc2BjJbT9mTWDghCtDZTCYgvyBL62
         Ukbu7qG+XDgIyXsmL2S90jkOyj2jF+aMysxNGp3ceuzVP5XBylNA53yfk1HcCAJRAXQL
         Lmdgd5WTYpA/yF17EMjZqkLGDhwPgKCQA4fXH4rfiU1kwHQffi+3ADDdkd9R09Q4K/Px
         kWZw==
X-Gm-Message-State: APjAAAXsc62cl1eN73oIb9lZvUEClaYTsCixx9BXkVJw6LSJvKwJ3UY0
        B/BMo4WGNb8gUCImh+DJ7Z/E61vuBnA=
X-Google-Smtp-Source: APXvYqyGY4kbxHwwXafib5Ecz5umR5UEvoPcE6wNQzRAGHmrJj+MAy/O68UfYFpQv3WpBqB6zPZI4w==
X-Received: by 2002:a63:753:: with SMTP id 80mr11550500pgh.95.1576180345466;
        Thu, 12 Dec 2019 11:52:25 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id g7sm8246729pfq.33.2019.12.12.11.52.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 11:52:24 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20191212003344.5571-1-snelson@pensando.io>
 <20191212003344.5571-3-snelson@pensando.io>
 <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ef49a30a-d4c6-e308-d760-17d7e8dc0d7c@pensando.io>
Date:   Thu, 12 Dec 2019 11:52:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 10:53 PM, Parav Pandit wrote:
> On 12/11/2019 6:33 PM, Shannon Nelson wrote:
>> Add the netdev ops for managing VFs.  Since most of the
>> management work happens in the NIC firmware, the driver becomes
>> mostly a pass-through for the network stack commands that want
>> to control and configure the VFs.
>>
>> We also tweak ionic_station_set() a little to allow for
>> the VFs that start off with a zero'd mac address.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h   |  15 +-
>>   .../ethernet/pensando/ionic/ionic_bus_pci.c   |  85 ++++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 ++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 254 +++++++++++++++++-
>>   .../net/ethernet/pensando/ionic/ionic_lif.h   |   7 +
>>   .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
>>   7 files changed, 422 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index 98e102af7756..e5c9e4b0450b 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -12,7 +12,7 @@ struct ionic_lif;
>>   
>>   #define IONIC_DRV_NAME		"ionic"
>>   #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
>> -#define IONIC_DRV_VERSION	"0.18.0-k"
>> +#define IONIC_DRV_VERSION	"0.20.0-k"
>>   
>>   #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>>   
>> @@ -25,6 +25,18 @@ struct ionic_lif;
>>   
>>   #define DEVCMD_TIMEOUT  10
>>   
>> +struct ionic_vf {
>> +	u16	 index;
>> +	u8	 macaddr[6];
>> +	__le32	 maxrate;
>> +	__le16	 vlanid;
>> +	u8	 spoofchk;
>> +	u8	 trusted;
>> +	u8	 linkstate;
>> +	dma_addr_t       stats_pa;
>> +	struct ionic_lif_stats stats;
>> +};
>> +
>>   struct ionic {
>>   	struct pci_dev *pdev;
>>   	struct device *dev;
>> @@ -46,6 +58,7 @@ struct ionic {
>>   	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
>>   	struct work_struct nb_work;
>>   	struct notifier_block nb;
>> +	struct ionic_vf **vf;
>>   	struct timer_list watchdog_timer;
>>   	int watchdog_period;
>>   };
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> index 9a9ab8cb2cb3..057eb453dd11 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -250,6 +250,87 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   	return err;
>>   }
>>   
>> +static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
>> +{
>> +	struct ionic *ionic = pci_get_drvdata(pdev);
>> +	struct device *dev = ionic->dev;
>> +	int i, ret = 0;
>> +	int nvfs = 0;
>> +
>> +	if (test_and_set_bit(IONIC_LIF_VF_OP, ionic->master_lif->state)) {
> Nop. This is not correct.
> User space doesn't retry the command when you throw an error as EAGAIN.
> These are not file system calls.
> As I told in v1, you need rwsem here without below warning messages all
> over the ops.

Hmmm... I was following how i40e solved this a year ago, which seems 
valid enough, but I see how using an rwsem could be seen as more 
correct, and probably a lot kinder on reads with a device that can 
support a large number of VFs.  I'll take another run at this.

>
>> +		dev_warn(&pdev->dev, "Unable to configure VFs, other operation is pending.\n");
>> +		return -EAGAIN;
>> +	}
>> +
>> +	if (num_vfs > 0) {
>> +		ret = pci_enable_sriov(pdev, num_vfs);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "Cannot enable SRIOV: %d\n", ret);
>> +			goto out;
>> +		}
>> +
>> +		ionic->vf = kcalloc(num_vfs, sizeof(struct ionic_vf *),
>> +				    GFP_KERNEL);
>> +		if (!ionic->vf) {
>> +			pci_disable_sriov(pdev);
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +
>> +		for (i = 0; i < num_vfs; i++) {
>> +			struct ionic_vf *v;
>> +
>> +			v = kzalloc(sizeof(*v), GFP_KERNEL);
>> +			if (!v) {
>> +				ret = -ENOMEM;
>> +				num_vfs = 0;
>> +				goto remove_vfs;
>> +			}
>> +
>> +			v->stats_pa = dma_map_single(dev, &v->stats,
>> +						     sizeof(v->stats),
>> +						     DMA_FROM_DEVICE);
>> +			if (dma_mapping_error(dev, v->stats_pa)) {
>> +				ret = -ENODEV;
>> +				kfree(v);
>> +				ionic->vf[i] = NULL;
>> +				num_vfs = 0;
>> +				goto remove_vfs;
>> +			}
>> +
>> +			ionic->vf[i] = v;
>> +			nvfs++;
> No need for this extra nvfs. Run the loop from i to 0 in reverse order
> in error unwinding.

Sure

>
>> +		}
>> +
>> +		ret = num_vfs;
>> +		goto out;
>> +	}
>> +
>> +remove_vfs:
>> +	if (num_vfs == 0) {
>> +		if (ret)
>> +			dev_err(&pdev->dev, "SRIOV setup failed: %d\n", ret);
>> +
>> +		pci_disable_sriov(pdev);
>> +
>> +		if (!nvfs)
>> +			nvfs = pci_num_vf(pdev);
>> +		for (i = 0; i < nvfs; i++) {
> error unwinding should be reverse of setup. It should run from i to 0.

Yes, this follows if I ditch nvfs.

>
>> +			dma_unmap_single(dev, ionic->vf[i]->stats_pa,
>> +					 sizeof(struct ionic_lif_stats),
> Please be consistent with dma_map_single which uses sizeof(v->stats).

Yep

>
>> +					 DMA_FROM_DEVICE);
>> +			kfree(ionic->vf[i]);
>> +		}
>> +
>> +		kfree(ionic->vf);
>> +		ionic->vf = NULL;
>> +	}
>> +
>> +out:
>> +	clear_bit(IONIC_LIF_VF_OP, ionic->master_lif->state);
>> +	return ret;
>> +}
>> +
>>   static void ionic_remove(struct pci_dev *pdev)
>>   {
>>   	struct ionic *ionic = pci_get_drvdata(pdev);
>> @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
>>   	if (!ionic)
>>   		return;
>>   
>> +	if (pci_num_vf(pdev))
>> +		ionic_sriov_configure(pdev, 0);
>> +
> Usually sriov is left enabled while removing PF.
> It is not the role of the pci PF removal to disable it sriov.

Looks like I'll need to split out the vf[] allocation into a separate 
routine (and perhaps the teardown too) so I can do it from
probe.

Version three coming soon to a mailing list near you...

sln


