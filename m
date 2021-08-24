Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF03F606A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhHXOay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbhHXOax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:30:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C869C061757;
        Tue, 24 Aug 2021 07:30:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g135so3657550wme.5;
        Tue, 24 Aug 2021 07:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6VWuIwIwcpYdfjA18Qq200DieOxwStlLe0QaiP81WGA=;
        b=rOCP/eAAQyz79SCABH7YFJCOVAKCPO5BoqSR9gOD29W9p74EHJ/g/G12i92t8sE678
         HMsIj7ClqZ4CqGJ0u83S8zNNxQ7J+Umxv8gvSRt4qiRpK2koy6lgsmflfekLXL0taUKU
         1np+RuhJAXqBCHYmIMaK//x7yy+o3it5xBqjkkMWDi/GRIe0KYzz0A1pQHcZBfwduiWO
         MFGhP5lkBGcg/yuGHWT2ql0ad3ULGbeZv0w1Nbnv40DQ6QtRjnbRo3xHNsJhEekyk2v0
         PPC4mgac+bxnUWEK1kzvsXnjyeIv85OrmAW2RA32glfD68UihLEC3qG5e+yZJlO4ahJq
         6Ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6VWuIwIwcpYdfjA18Qq200DieOxwStlLe0QaiP81WGA=;
        b=Phg8fL532LU+n97nJlo7U0ji7sWCS8UcM9n/uX8PIggbjh9FFe3C3oXZZqvcU3VPue
         JfbUWfAwIYMOO0EbjSsCP4PrX4qHV3uNNHMm3XtLSTRMwkNMpXxH/ByWgsV2hHNSLBQF
         FXHCfQBPNW7apRU5yxDFtS30fIT0EqZA99bM1SSmEt7e40r1oV46guP67jepaOJNrZB9
         WdDgM9dt5YkMfgV7gRKz6k8FexWPns+xDG9BKsFY4S57/SuWdhEsZcAN0LtV87EKqZqw
         cusrSt4QGr4qJsENXjA4FfLdB8dlpT6g55yjthejAgYN6qqYnDeDWOGtOMzAku/wOmPf
         8QsA==
X-Gm-Message-State: AOAM532vg6gj48/s0z/u2t/ZayMJ7lLiczthE6QBJn0eoUTjeMEZgEeq
        dMGSmmGmmR2n3kUPTJA14mg=
X-Google-Smtp-Source: ABdhPJzjUbyTCvGUtKUETa8XpvctnrcR9LH5mO/76E/ZgXUsvP3kUMUfDzRyvybvXLDgN2Q6tgrXsg==
X-Received: by 2002:a7b:cb01:: with SMTP id u1mr4369544wmj.152.1629815407799;
        Tue, 24 Aug 2021 07:30:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:dd79:5520:8cb5:f752? (p200300ea8f084500dd7955208cb5f752.dip0.t-ipconnect.de. [2003:ea:8f08:4500:dd79:5520:8cb5:f752])
        by smtp.googlemail.com with ESMTPSA id z1sm18410969wrv.22.2021.08.24.07.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:30:07 -0700 (PDT)
Subject: Re: [PATCH 05/12] bnx2x: Read VPD with pci_vpd_alloc()
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shai Malin <smalin@marvell.com>
References: <DM5PR18MB22290BC6E0BB57B39A72E865B2C59@DM5PR18MB2229.namprd18.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3578363c-9cee-53d8-257c-c64cce97d95a@gmail.com>
Date:   Tue, 24 Aug 2021 16:30:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM5PR18MB22290BC6E0BB57B39A72E865B2C59@DM5PR18MB2229.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2021 16:20, Prabhakar Kushwaha wrote:
> Hi Heiner,
> 
>> -----Original Message-----
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: Sunday, August 22, 2021 7:23 PM
>> To: Bjorn Helgaas <bhelgaas@google.com>; Ariel Elior <aelior@marvell.com>;
>> Sudarsana Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2 <GR-
>> everest-linux-l2@marvell.com>; Jakub Kicinski <kuba@kernel.org>; David
>> Härdeman <david@hardeman.nu>
>> Cc: linux-pci@vger.kernel.org; netdev@vger.kernel.org
>> Subject: [PATCH 05/12] bnx2x: Read VPD with pci_vpd_alloc()
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>> Use pci_vpd_alloc() to dynamically allocate a properly sized buffer and
>> read the full VPD data into it.
>>
>> This simplifies the code, and we no longer have to make assumptions about
>> VPD size.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  1 -
>>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 44 +++++--------------
>>  2 files changed, 10 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> index d04994840..e789430f4 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> @@ -2407,7 +2407,6 @@ void bnx2x_igu_clear_sb_gen(struct bnx2x *bp, u8
>> func, u8 idu_sb_id,
>>  #define ETH_MAX_RX_CLIENTS_E2		ETH_MAX_RX_CLIENTS_E1H
>>  #endif
>>
>> -#define BNX2X_VPD_LEN			128
>>  #define VENDOR_ID_LEN			4
>>
>>  #define VF_ACQUIRE_THRESH		3
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> index 6d9813491..0466adf8d 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> @@ -12189,50 +12189,29 @@ static int bnx2x_get_hwinfo(struct bnx2x *bp)
>>
>>  static void bnx2x_read_fwinfo(struct bnx2x *bp)
>>  {
>> -	int cnt, i, block_end, rodi;
>> -	char vpd_start[BNX2X_VPD_LEN+1];
>> +	int i, block_end, rodi;
>>  	char str_id_reg[VENDOR_ID_LEN+1];
>>  	char str_id_cap[VENDOR_ID_LEN+1];
>> -	char *vpd_data;
>> -	char *vpd_extended_data = NULL;
>> -	u8 len;
>> +	unsigned int vpd_len;
>> +	u8 *vpd_data, len;
>>
>> -	cnt = pci_read_vpd(bp->pdev, 0, BNX2X_VPD_LEN, vpd_start);
>>  	memset(bp->fw_ver, 0, sizeof(bp->fw_ver));
>>
>> -	if (cnt < BNX2X_VPD_LEN)
>> -		goto out_not_found;
>> +	vpd_data = pci_vpd_alloc(bp->pdev, &vpd_len);
> 
> Definition of pci_vpd_alloc() is below as per repo "git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git" and   branch wip/heiner-vpd-api
> void *pci_vpd_alloc(struct pci_dev *dev, unsigned int *size)
> {
>         unsigned int len = dev->vpd.len;
>         void *buf;
> --
> --
>         if (size)
>                 *size = len;
> }
> Here is len is already part of pci_dev.  
> 
> So why cannot same be set in caller function i.e. vpd_len = pb->pdev->vpd.len
> 
Internals of struct pci_vpd shouldn't be referenced outside PCI core.
Also you can't use vpd.len w/o checking vpd.cap.
pci_vpd_alloc() encapsulates these internals.

> 
>> +	if (IS_ERR(vpd_data))
>> +		return;
>>
>>  	/* VPD RO tag should be first tag after identifier string, hence
>>  	 * we should be able to find it in first BNX2X_VPD_LEN chars
>>  	 */
>> -	i = pci_vpd_find_tag(vpd_start, BNX2X_VPD_LEN,
>> PCI_VPD_LRDT_RO_DATA);
>> +	i = pci_vpd_find_tag(vpd_data, vpd_len, PCI_VPD_LRDT_RO_DATA);
>>  	if (i < 0)
>>  		goto out_not_found;
>>
>>  	block_end = i + PCI_VPD_LRDT_TAG_SIZE +
>> -		    pci_vpd_lrdt_size(&vpd_start[i]);
>> -
>> +		    pci_vpd_lrdt_size(&vpd_data[i]);
>>  	i += PCI_VPD_LRDT_TAG_SIZE;
>>
>> -	if (block_end > BNX2X_VPD_LEN) {
>> -		vpd_extended_data = kmalloc(block_end, GFP_KERNEL);
>> -		if (vpd_extended_data  == NULL)
>> -			goto out_not_found;
>> -
>> -		/* read rest of vpd image into vpd_extended_data */
>> -		memcpy(vpd_extended_data, vpd_start, BNX2X_VPD_LEN);
>> -		cnt = pci_read_vpd(bp->pdev, BNX2X_VPD_LEN,
>> -				   block_end - BNX2X_VPD_LEN,
>> -				   vpd_extended_data + BNX2X_VPD_LEN);
>> -		if (cnt < (block_end - BNX2X_VPD_LEN))
>> -			goto out_not_found;
>> -		vpd_data = vpd_extended_data;
>> -	} else
>> -		vpd_data = vpd_start;
>> -
>> -	/* now vpd_data holds full vpd content in both cases */
>> -
>>  	rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
>>  				   PCI_VPD_RO_KEYWORD_MFR_ID);
>>  	if (rodi < 0)
>> @@ -12258,17 +12237,14 @@ static void bnx2x_read_fwinfo(struct bnx2x *bp)
>>
>>  			rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
>>
>> -			if (len < 32 && (len + rodi) <= BNX2X_VPD_LEN) {
>> +			if (len < 32 && (len + rodi) <= vpd_len) {
>>  				memcpy(bp->fw_ver, &vpd_data[rodi], len);
>>  				bp->fw_ver[len] = ' ';
>>  			}
>>  		}
>> -		kfree(vpd_extended_data);
>> -		return;
>>  	}
>>  out_not_found:
>> -	kfree(vpd_extended_data);
>> -	return;
>> +	kfree(vpd_data);
> 
> As vpd_data allocation done in PCI layer. 
> It will be logical to also free vpd_data in PCI layer.
> 
The idea is right, however a call like pci_vpd_free() would be a one-liner
calling kfree(), and I doubt it's really worth it.

> --pk
> 
Heiner
