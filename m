Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1526A2B67
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBYS7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 13:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYS7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 13:59:37 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2147DD530;
        Sat, 25 Feb 2023 10:59:36 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id ff4so1808336qvb.2;
        Sat, 25 Feb 2023 10:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rnqGVM0+Yl+LxrM8a64hnYzeIieuQSZyZkIUmez4wgc=;
        b=jtpYSG8UuCzs2lueJ+I4mt1hz3X/+UlQPMLFGYdDLk1ixDpOckeFMO1yZHSFNpwGyA
         AkldkQSHon2FgsWfs01yxN+clVsabwpEFTGTIuLp1vO0RuexziqNc9EMRCfKrFuaOnSb
         UZcyI41Vk3ef1AY07yHWn439YNCC0TzULYZwRjNDSxWjxROhI02OBHWX8YMOXkLz6Q0w
         BmaoqQZz5xPOS4taUocY4R2H6V3mZXNq3zukkSLPGn5Ljj+qtaSCzLfb2cmsmSlVHZ3P
         37nf48ckL/lgosRIo+HBrdEQuF/0uPcG8sbWqS/cXCzIdjYjI1o4+HOot9Ldizws8siQ
         mjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rnqGVM0+Yl+LxrM8a64hnYzeIieuQSZyZkIUmez4wgc=;
        b=r1JbeGTyZY1tTjpsQ+hnnmuBYsTTJHKewqqnbJomZoAGmEcw/ISsH4Laxlv9mS5/af
         jHLfdL6INQ91foV4Qv+tnBn2NZgDevlEIBBzdb18fOZNeop3q+Oisvh1JxkhlqB46ZZT
         dwPQGPNihUl3CzZ6BzZHeb1rOwUUSb9DqPdXGK7Ncqu+RRScYUTWJh4RtqHKrNrla8gX
         kifUiy/zwl7NDGCsYoon+B5lbw+zCKwLxMcCUsyJU7/4FZIYWHdfaLxkR2umZ4HJ14mh
         P/TaY9nb+uFP6F07XZ9PniQnhNwYdNfosczmDRFccE+6vYp4O/CttY+wLiPFL9tts9EA
         oNQQ==
X-Gm-Message-State: AO0yUKVBx/onThdaAT8bUgQzglk51yfSKcGG/dcqyKrM2pNsNjnC0N0P
        wSZW+qjk6Z1v6jm66QDvjeU=
X-Google-Smtp-Source: AK7set/A3VVFzyzUyqth9lpuuHI+GmZbtg9FQCX55/yzT6KGriXY/qrKxDKDXvC19iarDAdhc/Yu+w==
X-Received: by 2002:a05:6214:2505:b0:56e:f8db:aeb8 with SMTP id gf5-20020a056214250500b0056ef8dbaeb8mr44608482qvb.3.1677351575117;
        Sat, 25 Feb 2023 10:59:35 -0800 (PST)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id w1-20020a05620a0e8100b0073b7568d998sm1672922qkm.2.2023.02.25.10.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 10:59:34 -0800 (PST)
Message-ID: <0b105dca-c273-1fd2-339d-26e08b29c44c@gmail.com>
Date:   Sat, 25 Feb 2023 13:59:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 6/7] net: sunhme: Consolidate mac address
 initialization
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230222210355.2741485-1-seanga2@gmail.com>
 <20230222210355.2741485-7-seanga2@gmail.com> <Y/pV6KDgopeiPEPo@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y/pV6KDgopeiPEPo@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/23 13:39, Simon Horman wrote:
> On Wed, Feb 22, 2023 at 04:03:54PM -0500, Sean Anderson wrote:
>> The mac address initialization is braodly the same between PCI and SBUS,
>> and one was clearly copied from the other. Consolidate them. We still have
>> to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
>> and idprom is only implemented for SPARC.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Overall this looks to correctly move code around as suggest.
> Some minor nits and questions inline.
> 
>> ---
>>
>>   drivers/net/ethernet/sun/sunhme.c | 284 ++++++++++++++----------------
>>   1 file changed, 135 insertions(+), 149 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index 75993834729a..9b55adbe61df 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -34,6 +34,7 @@
>>   #include <linux/mm.h>
>>   #include <linux/module.h>
>>   #include <linux/netdevice.h>
>> +#include <linux/of.h>
>>   #include <linux/random.h>
>>   #include <linux/skbuff.h>
>>   #include <linux/slab.h>
>> @@ -47,7 +48,6 @@
>>   #include <asm/oplib.h>
>>   #include <asm/prom.h>
>>   #include <linux/of_device.h>
>> -#include <linux/of.h>
>>   #endif
>>   #include <linux/uaccess.h>
>>   
> 
> nit: The above hunks don't seem related to the rest of this patch.

I think I originally included this because I referenced some of_ thing from non-sparc
code. But it seems like that got refactored out.

>> @@ -2313,6 +2313,133 @@ static const struct net_device_ops hme_netdev_ops = {
>>   	.ndo_validate_addr	= eth_validate_addr,
>>   };
>>   
>> +#ifdef CONFIG_PCI
>> +static int is_quattro_p(struct pci_dev *pdev)
> 
> nit: I know you are moving code around here,
>       and likewise for many of my other comments.
>       But I think bool would be a better return type for this function.

I agree. I will address these sorts of things in a separate patch.

>> +{
>> +	struct pci_dev *busdev = pdev->bus->self;
>> +	struct pci_dev *this_pdev;
>> +	int n_hmes;
>> +
>> +	if (!busdev || busdev->vendor != PCI_VENDOR_ID_DEC ||
>> +	    busdev->device != PCI_DEVICE_ID_DEC_21153)
>> +		return 0;
>> +
>> +	n_hmes = 0;
>> +	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
>> +		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
>> +		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
>> +			n_hmes++;
>> +	}
>> +
>> +	if (n_hmes != 4)
>> +		return 0;
>> +
>> +	return 1;
>> +}
>> +
>> +/* Fetch MAC address from vital product data of PCI ROM. */
>> +static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)
> 
> nit: At some point it might be better
>       to update this function to return 0 on success and
>       an error otherwise.
> 
>> +{
>> +	int this_offset;
>> +
>> +	for (this_offset = 0x20; this_offset < len; this_offset++) {
>> +		void __iomem *p = rom_base + this_offset;
>> +
>> +		if (readb(p + 0) != 0x90 ||
>> +		    readb(p + 1) != 0x00 ||
>> +		    readb(p + 2) != 0x09 ||
>> +		    readb(p + 3) != 0x4e ||
>> +		    readb(p + 4) != 0x41 ||
>> +		    readb(p + 5) != 0x06)
>> +			continue;
>> +
>> +		this_offset += 6;
>> +		p += 6;
>> +
>> +		if (index == 0) {
>> +			int i;
>> +
>> +			for (i = 0; i < 6; i++)
> 
> nit: This could be,
> 
> 			for (int i = 0; i < 6; i++)

That's kosher now?

>> +				dev_addr[i] = readb(p + i);
>> +			return 1;
>> +		}
>> +		index--;
>> +	}
> 
> nit: blank line

OK

>> +	return 0;
>> +}
>> +
>> +static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
>> +						unsigned char *dev_addr)
>> +{
>> +	size_t size;
>> +	void __iomem *p = pci_map_rom(pdev, &size);
> 
> nit: reverse xmas tree.

OK

>> +
>> +	if (p) {
>> +		int index = 0;
>> +		int found;
>> +
>> +		if (is_quattro_p(pdev))
>> +			index = PCI_SLOT(pdev->devfn);
>> +
>> +		found = readb(p) == 0x55 &&
>> +			readb(p + 1) == 0xaa &&
>> +			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
>> +		pci_unmap_rom(pdev, p);
>> +		if (found)
>> +			return;
>> +	}
>> +
>> +	/* Sun MAC prefix then 3 random bytes. */
>> +	dev_addr[0] = 0x08;
>> +	dev_addr[1] = 0x00;
>> +	dev_addr[2] = 0x20;
>> +	get_random_bytes(&dev_addr[3], 3);
>> +}
>> +#endif /* !(CONFIG_SPARC) */
> 
> Should this be CONFIG_PCI ?

No idea. I think I will just remove it...

>> @@ -2346,34 +2472,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>>   		return -ENOMEM;
>>   	SET_NETDEV_DEV(dev, &op->dev);
>>   
>> -	/* If user did not specify a MAC address specifically, use
>> -	 * the Quattro local-mac-address property...
>> -	 */
>> -	for (i = 0; i < 6; i++) {
>> -		if (macaddr[i] != 0)
>> -			break;
>> -	}
>> -	if (i < 6) { /* a mac address was given */
>> -		for (i = 0; i < 6; i++)
>> -			addr[i] = macaddr[i];
>> -		eth_hw_addr_set(dev, addr);
>> -		macaddr[5]++;
>> -	} else {
>> -		const unsigned char *addr;
>> -		int len;
>> -
>> -		addr = of_get_property(dp, "local-mac-address", &len);
>> -
>> -		if (qfe_slot != -1 && addr && len == ETH_ALEN)
>> -			eth_hw_addr_set(dev, addr);
>> -		else
>> -			eth_hw_addr_set(dev, idprom->id_ethaddr);
>> -	}
>> -
>>   	hp = netdev_priv(dev);
>> -
>> +	hp->dev = dev;
> 
> I'm not clear how this change relates to the rest of the patch.

This mirrors the initialization on the PCI side. Makes their equivalence
more obvious.

>>   	hp->happy_dev = op;
>>   	hp->dma_dev = &op->dev;
>> +	happy_meal_addr_init(hp, dp, qfe_slot);
>>   
>>   	spin_lock_init(&hp->happy_lock);
>>   
>> @@ -2451,7 +2554,6 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>>   
>>   	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
>>   
>> -	hp->dev = dev;
>>   	dev->netdev_ops = &hme_netdev_ops;
>>   	dev->watchdog_timeo = 5*HZ;
>>   	dev->ethtool_ops = &hme_ethtool_ops;
> 
> ...
> 
>>   static int happy_meal_pci_probe(struct pci_dev *pdev,
>>   				const struct pci_device_id *ent)
>>   {
>>   	struct quattro *qp = NULL;
>> -#ifdef CONFIG_SPARC
>> -	struct device_node *dp;
> 
> Was dp not being initialised previously a bug?

No. All uses are protected by CONFIG_SPARC. But passing garbage to other
functions is bad form.

>> -#endif
>> +	struct device_node *dp = NULL;
> 
> nit: I think it would be good to move towards, rather than away from,
> reverse xmas tree here.

Which is why this line comes first ;)

But I am not a fan of introducing churn just to organize line lengths. So the
following will stay as-is until it needs to be reworked further.

>>   	struct happy_meal *hp;
>>   	struct net_device *dev;
>>   	void __iomem *hpreg_base;
>>   	struct resource *hpreg_res;
>> -	int i, qfe_slot = -1;
>> +	int qfe_slot = -1;
>>   	char prom_name[64];
>> -	u8 addr[ETH_ALEN];
>>   	int err;
>>   
>>   	/* Now make sure pci_dev cookie is there. */
> 
> ...
> 
>> @@ -2680,35 +2695,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>>   		goto err_out_clear_quattro;
>>   	}
>>   
>> -	for (i = 0; i < 6; i++) {
>> -		if (macaddr[i] != 0)
>> -			break;
>> -	}
>> -	if (i < 6) { /* a mac address was given */
>> -		for (i = 0; i < 6; i++)
>> -			addr[i] = macaddr[i];
>> -		eth_hw_addr_set(dev, addr);
>> -		macaddr[5]++;
>> -	} else {
>> -#ifdef CONFIG_SPARC
>> -		const unsigned char *addr;
>> -		int len;
>> -
>> -		if (qfe_slot != -1 &&
>> -		    (addr = of_get_property(dp, "local-mac-address", &len))
>> -			!= NULL &&
>> -		    len == 6) {
>> -			eth_hw_addr_set(dev, addr);
>> -		} else {
>> -			eth_hw_addr_set(dev, idprom->id_ethaddr);
>> -		}
>> -#else
>> -		u8 addr[ETH_ALEN];
>> -
>> -		get_hme_mac_nonsparc(pdev, addr);
>> -		eth_hw_addr_set(dev, addr);
>> -#endif
>> -	}
>> +	happy_meal_addr_init(hp, dp, qfe_slot);
>>   
>>   	/* Layout registers. */
>>   	hp->gregs      = (hpreg_base + 0x0000UL);
>> @@ -2757,7 +2744,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>>   	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
>>   
>>   	hp->irq = pdev->irq;
>> -	hp->dev = dev;
>>   	dev->netdev_ops = &hme_netdev_ops;
>>   	dev->watchdog_timeo = 5*HZ;
>>   	dev->ethtool_ops = &hme_ethtool_ops;
>> -- 
>> 2.37.1
>>

--Sean
