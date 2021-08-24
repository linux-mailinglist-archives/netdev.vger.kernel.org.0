Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B803F68C8
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhHXSHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhHXSH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:07:28 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A448C061757;
        Tue, 24 Aug 2021 11:06:44 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so2880619wml.3;
        Tue, 24 Aug 2021 11:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T9QISP9Y4PT9a1jwV196EPnSVESk04DbpPCP+n6p4Hc=;
        b=HM5reH155XYRI4efGhCsAmloYaZzcfsAE+cjcIac4uw0cRpI2Cn+2SZ5OH+OMIU1fu
         +mkRfPnGU7HrLgr8IclCxbu1zUHopAYUEksZaSWMmJIaTsZZQLOtd3xR3p8wqYCrgW9I
         YDecM6HYsuKfXTeURuUzMowbjpg5MMdql5+lk/G2dwbVJ+GsYBvRPzL5iBktwwtKdcpo
         DBsOGBuvEL76bc5C2uIZyMxmgOzW6XHCA29833wNI3zh613cb6Q+WwiGPRsUUz5LarTO
         4u1feArkffXxSUiTULH+gBhRw43LQZ9Tcj9hQ86ilUoNMAqpJqmewFBkWllCR99PVyOB
         hkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T9QISP9Y4PT9a1jwV196EPnSVESk04DbpPCP+n6p4Hc=;
        b=sqvNBl7DCPdNbjboyzkfQwmVmjTpKqIQ1UZkWf5QCu1onIU8dqf6an/HCpHuJbWi2M
         MxjB2mq3/q+kHg8ATSESI11ibaGz5TzIKrWAevMg1q4OOuj/nwCTHnTbmj0TbeKbH6yG
         1EOcT4SnLXsaXfmjUNDc/mcmxd5r1qohgJGK1ogo84LRAvZIm16GzG8bjvBzv9eOBib2
         SxR0Okuo6jx7WAH64MvC9Ksp8vlSbYRYO1Xpiwa8lFZSGgJl9blTMx+DhReWAmUVJS8q
         DU2IktLdpSskFJktUjX503wcrX/AOu6CzfsXyeQbE2t/R7wTrT8q8Qp21F9UR6e+iJPN
         z0vg==
X-Gm-Message-State: AOAM532smd1gIMcZB56qCzlnnsd9sqqY3yrRBEtM9lsIU0ho7RF7kv+n
        7vYAoZpk+OjlZdFgM71ffdnbkPWtKlyMoQ==
X-Google-Smtp-Source: ABdhPJzMQIVSf5yyOvIpEFP0qW9f5iQU/wsZ+RXYEZjSLZrVaechztM+pOnmphOoQPwmgsGU1f4+Fg==
X-Received: by 2002:a1c:9a0e:: with SMTP id c14mr3403149wme.119.1629828401949;
        Tue, 24 Aug 2021 11:06:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:6d7d:72e5:938b:6820? (p200300ea8f0845006d7d72e5938b6820.dip0.t-ipconnect.de. [2003:ea:8f08:4500:6d7d:72e5:938b:6820])
        by smtp.googlemail.com with ESMTPSA id d7sm19190169wrs.39.2021.08.24.11.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 11:06:41 -0700 (PDT)
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210824170239.GA3477243@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 06/12] bnx2x: Search VPD with
 pci_vpd_find_ro_info_keyword()
Message-ID: <53d92923-fa8f-aa2c-ff14-340f380018b1@gmail.com>
Date:   Tue, 24 Aug 2021 20:01:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824170239.GA3477243@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2021 19:02, Bjorn Helgaas wrote:
> On Sun, Aug 22, 2021 at 03:54:23PM +0200, Heiner Kallweit wrote:
>> Use pci_vpd_find_ro_info_keyword() to search for keywords in VPD to
>> simplify the code.
>>
>> str_id_reg and str_id_cap hold the same string and are used in the same
>> comparison. This doesn't make sense, use one string str_id instead.
> 
> str_id_reg is printed with "%04x" (lower-case hex letters) and
> str_id_cap with "%04X" (upper-case hex letters), so the previous code
> would match either 0xabcd or 0xABCD.  After this patch, we'd match
> only the latter.
> 
Right, I missed this difference. strncasecmp() would be an easy solution.
Alternatively we could avoid this stringification and string comparison
by using kstrtouint_from_user():

kstrtouint_from_user(&vpd_data[rodi], kw_len, 16, &val)
if (val == PCI_VENDOR_ID_DELL)

But if there's no strong preference then I'd say we go the easy way.
Would you like me to re-send or are you going to adjust the patch?

> PCI_VENDOR_ID_DELL is 0x1028, so it shouldn't make any difference,
> which makes me wonder why somebody bothered with both.
> 
> But it does seem like a potential landmine to change the case
> sensitivity.  Maybe strncasecmp() instead?
> 
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 57 +++++--------------
>>  1 file changed, 15 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> index 0466adf8d..2c7bfc416 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> @@ -12189,11 +12189,10 @@ static int bnx2x_get_hwinfo(struct bnx2x *bp)
>>  
>>  static void bnx2x_read_fwinfo(struct bnx2x *bp)
>>  {
>> -	int i, block_end, rodi;
>> -	char str_id_reg[VENDOR_ID_LEN+1];
>> -	char str_id_cap[VENDOR_ID_LEN+1];
>> -	unsigned int vpd_len;
>> -	u8 *vpd_data, len;
>> +	char str_id[VENDOR_ID_LEN + 1];
>> +	unsigned int vpd_len, kw_len;
>> +	u8 *vpd_data;
>> +	int rodi;
>>  
>>  	memset(bp->fw_ver, 0, sizeof(bp->fw_ver));
>>  
>> @@ -12201,46 +12200,20 @@ static void bnx2x_read_fwinfo(struct bnx2x *bp)
>>  	if (IS_ERR(vpd_data))
>>  		return;
>>  
>> -	/* VPD RO tag should be first tag after identifier string, hence
>> -	 * we should be able to find it in first BNX2X_VPD_LEN chars
>> -	 */
>> -	i = pci_vpd_find_tag(vpd_data, vpd_len, PCI_VPD_LRDT_RO_DATA);
>> -	if (i < 0)
>> -		goto out_not_found;
>> -
>> -	block_end = i + PCI_VPD_LRDT_TAG_SIZE +
>> -		    pci_vpd_lrdt_size(&vpd_data[i]);
>> -	i += PCI_VPD_LRDT_TAG_SIZE;
>> -
>> -	rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
>> -				   PCI_VPD_RO_KEYWORD_MFR_ID);
>> -	if (rodi < 0)
>> -		goto out_not_found;
>> -
>> -	len = pci_vpd_info_field_size(&vpd_data[rodi]);
>> -
>> -	if (len != VENDOR_ID_LEN)
>> +	rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
>> +					    PCI_VPD_RO_KEYWORD_MFR_ID, &kw_len);
>> +	if (rodi < 0 || kw_len != VENDOR_ID_LEN)
>>  		goto out_not_found;
>>  
>> -	rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
>> -
>>  	/* vendor specific info */
>> -	snprintf(str_id_reg, VENDOR_ID_LEN + 1, "%04x", PCI_VENDOR_ID_DELL);
>> -	snprintf(str_id_cap, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
>> -	if (!strncmp(str_id_reg, &vpd_data[rodi], VENDOR_ID_LEN) ||
>> -	    !strncmp(str_id_cap, &vpd_data[rodi], VENDOR_ID_LEN)) {
>> -
>> -		rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
>> -						PCI_VPD_RO_KEYWORD_VENDOR0);
>> -		if (rodi >= 0) {
>> -			len = pci_vpd_info_field_size(&vpd_data[rodi]);
>> -
>> -			rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
>> -
>> -			if (len < 32 && (len + rodi) <= vpd_len) {
>> -				memcpy(bp->fw_ver, &vpd_data[rodi], len);
>> -				bp->fw_ver[len] = ' ';
>> -			}
>> +	snprintf(str_id, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
>> +	if (!strncmp(str_id, &vpd_data[rodi], VENDOR_ID_LEN)) {
>> +		rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
>> +						    PCI_VPD_RO_KEYWORD_VENDOR0,
>> +						    &kw_len);
>> +		if (rodi >= 0 && kw_len < sizeof(bp->fw_ver)) {
>> +			memcpy(bp->fw_ver, &vpd_data[rodi], kw_len);
>> +			bp->fw_ver[kw_len] = ' ';
>>  		}
>>  	}
>>  out_not_found:
>> -- 
>> 2.33.0
>>
>>

