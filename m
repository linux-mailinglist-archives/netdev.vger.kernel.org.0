Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8806BFB39
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 16:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCRPbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 11:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCRPbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 11:31:22 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C4C22DF0;
        Sat, 18 Mar 2023 08:31:19 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id hf2so4557654qtb.3;
        Sat, 18 Mar 2023 08:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679153479;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i5es79Xa5TxkIltkq6/+wMX1BiR/O9o4ICrlsq6A4fc=;
        b=jMuXMbPMoKJEn+nJ2idp66XgphDTCXQcbcGPhPAxyHMaCtE2xXG42iAF/nEOXjgu/e
         n/4uqyrySDwRKo/EIOmgh2gVoVE1Bmk02ABd5j5JJenq+jwhfQi3kTJP0TpeonZw/boS
         YKs/oS9QghoXzfl8WIAGQsRl7/AhzFRpcajBwik9LE4dQGESsvQ5F1nW1x4enUA9OEh6
         4qg6+xQR3fb55agNZdMs+2Q/gpgXkaMpEeiTKntR2MURkcg5eG04w+/klElkZVXRrJO2
         NixCIY6yG+FX39Ne+KWLzj9S5qdUxYu1wKIg0Rl57p5lLVSE2l09beLR5OxzfUviioOf
         ehlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679153479;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5es79Xa5TxkIltkq6/+wMX1BiR/O9o4ICrlsq6A4fc=;
        b=ke+nMg3kWIlup7gFJuWZEhj+sSj4wTozQTDvotzS+euP32uUpNJByoao+tqJ9bAtiN
         73V8zNF0dsAzaAnE0j9+Ea353I29Iz0UMeQ1h9Opi/WBzB7AUhufrh2cRnyTknmUkKzw
         4TauxDMXWxDui2Obr2Kq0P9UipoL3J/JRC726E0pmXqFSaYxbGNj83FAlSgGLWy0BIDR
         KZjVkZHJt4RCUW2xzJjRzmf3/tlW4TtVBdoguCHXTN0j1OVWD34fizTkjBvu36dUutHc
         LyDervWQvDxqQ8xYRY4U4zWvNVJIxeGRlTq0YeEeOHSNIqoYzygc2v5YfDKLqJZntIXx
         Jycg==
X-Gm-Message-State: AO0yUKUm6+Dcl02yKvs9nfu20jUVPhyFu5bfMid6R7P4gQb7kEzZKJvD
        YpX0SeLc33e7vx3vJBK6LZw=
X-Google-Smtp-Source: AK7set9p30n2X7g1r6VLbB1+UZ5cEWGzD7dYQxIy/VgG56a7fnDFXe9L5/2kcfmOlHfkuKAXauvq5Q==
X-Received: by 2002:ac8:574d:0:b0:3d1:1b8e:62f2 with SMTP id 13-20020ac8574d000000b003d11b8e62f2mr18629711qtx.31.1679153478750;
        Sat, 18 Mar 2023 08:31:18 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id m17-20020ac84451000000b003c03b33e6f5sm3052796qtn.90.2023.03.18.08.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 08:31:18 -0700 (PDT)
Message-ID: <12926ee8-ee35-791f-d7a5-943cdf744d46@gmail.com>
Date:   Sat, 18 Mar 2023 11:31:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 6/9] net: sunhme: Consolidate mac address
 initialization
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-7-seanga2@gmail.com> <ZBV9M28EhKFYrHnc@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZBV9M28EhKFYrHnc@corigine.com>
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

On 3/18/23 04:58, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 08:36:10PM -0400, Sean Anderson wrote:
>> The mac address initialization is braodly the same between PCI and SBUS,
>> and one was clearly copied from the other. Consolidate them. We still have
>> to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
>> and idprom is only implemented for SPARC.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Hi Sean,
> 
> Nits aside, this looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index 3072578c334a..c2737f26afbe 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
> 
> ...
> 
>> +static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
>> +						unsigned char *dev_addr)
>> +{
>> +	size_t size;
>> +	void __iomem *p = pci_map_rom(pdev, &size);
> 
> nit: reverse xmas tree - longest line to shortest - would be nice here.
> 
> 	void __iomem *p;
> 	size_t size;
> 
> 	p = pci_map_rom(pdev, &size);
> 
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
> 
> nit: Maybe as a follow-up using eth_hw_addr_random() could be considered here.

Yes, I would like to come back to this later.

>> +}
>> +#endif /* !(CONFIG_SPARC) */
> 
> ...
> 
>>   static int happy_meal_pci_probe(struct pci_dev *pdev,
>>   				const struct pci_device_id *ent)
>>   {
>>   	struct quattro *qp = NULL;
>> -#ifdef CONFIG_SPARC
>> -	struct device_node *dp;
>> -#endif
>> +	struct device_node *dp = NULL;
> 
> nit: if dp was added above qp then then
>       things would move closer to reverse xmas tree.
> 
>>   	struct happy_meal *hp;
>>   	struct net_device *dev;
>>   	void __iomem *hpreg_base;
>>   	struct resource *hpreg_res;
>> -	int i, qfe_slot = -1;
>> +	int qfe_slot = -1;
> 
> nit: if qfe_slot was added below prom_name[64] then then
>       things would move closer to reverse xmas tree.

This is why I dislike this style...

>>   	char prom_name[64];
>> -	u8 addr[ETH_ALEN];
>>   	int err;
>>   
>>   	/* Now make sure pci_dev cookie is there. */
> 
> ...

