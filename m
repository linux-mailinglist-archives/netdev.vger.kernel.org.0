Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E433F68CA
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhHXSHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhHXSHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:07:32 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6C7C061757;
        Tue, 24 Aug 2021 11:06:48 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q11so5627395wrr.9;
        Tue, 24 Aug 2021 11:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nXvsXISSw63LUGa7Bgo8rtlGjSjsjgtm/x18Ma0OOG8=;
        b=RLqCoA8krgQqWoS0yZidKUPoNfVAMVHZAKsSE8QXW+cD82dcujtcSQCWSW9dfDDovu
         WwsFv+qpn35wXYCIgcTmdC6UVnO/RdTwNK+9wtDUVAuNmpo5+zIC3feo+HCiCrlegRQN
         gLYIrCUaQR2DhescnlT/S60pA4w+DynG7hEFCKt7JfdYBHhQ+LBQ0SIMhXwhkr3xT3gY
         /8DAeujK2Zh/MTEF5iAaXCoNwmpCwwI3DajtihR7dfcTpMo8ZRn8lYD7564H4hVwpr/Q
         I9AWDYXgrCmXb7laY8ko2tfQA7lp4GC4retT0c+VkSI6O5Wm/U0hSKedrULI10lwusF7
         nsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nXvsXISSw63LUGa7Bgo8rtlGjSjsjgtm/x18Ma0OOG8=;
        b=SlMF3TRrSOpo3zaXfdQ1l/iQU6xh16exregXG7KlUmKaCYpLCMG7oJcz8/yih2EofL
         THDKM7OhGlvslI+JDff5LSpfjCFRL0NxPKDMGFSlScqDPMuo5M18pnTXC/qUWIe7SVMU
         fGoUZCbraSYFy0h1kxBpTH7WLwdw0TVFRyNnApcfz7aiq8ZNx4TGYcikVVbev+adlyl+
         9I8m4sqmRVX4QjPNdMTSiiVRgl/17OxJ4y2Vac5fLbjCKg5hfhBKdexmzsCvqhBAyS5R
         VQqC6hCY4a1UgeCy952rIg5YfK4xKjAZQjFvp5DwZ+xKgVwWEfUXn6aZNreXf9Ylv5WL
         AFgw==
X-Gm-Message-State: AOAM5307iiZHH5kxsTgR9G626pTXpSI6BO/Uim133GZnivhbak4j0tH5
        qpIUsxIvTwxeSY2SK0MlWH7vVO/5KZsIEA==
X-Google-Smtp-Source: ABdhPJzIqkHx9q/ewvHxC+ns6U6Jh779JRx6/ua44/pwLGUhSr8suvDpP95nplfNARgIAqgvkc93zA==
X-Received: by 2002:adf:ee48:: with SMTP id w8mr12627782wro.10.1629828406361;
        Tue, 24 Aug 2021 11:06:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:6d7d:72e5:938b:6820? (p200300ea8f0845006d7d72e5938b6820.dip0.t-ipconnect.de. [2003:ea:8f08:4500:6d7d:72e5:938b:6820])
        by smtp.googlemail.com with ESMTPSA id f2sm18435904wru.31.2021.08.24.11.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 11:06:45 -0700 (PDT)
Subject: Re: [PATCH 11/12] cxgb4: Search VPD with
 pci_vpd_find_ro_info_keyword()
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210824171142.GA3478603@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <affa0bd6-b67b-6065-34e3-98f1420f121c@gmail.com>
Date:   Tue, 24 Aug 2021 20:06:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824171142.GA3478603@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2021 19:11, Bjorn Helgaas wrote:
> On Sun, Aug 22, 2021 at 03:59:21PM +0200, Heiner Kallweit wrote:
>> Use pci_vpd_find_ro_info_keyword() to search for keywords in VPD to
>> simplify the code.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 67 +++++++++-------------
>>  1 file changed, 27 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> index 2aeb2f80f..5e8ac42ac 100644
>> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> @@ -2743,10 +2743,9 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
>>   */
>>  int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>>  {
>> -	int i, ret = 0, addr;
>> -	int sn, pn, na;
>> +	unsigned int id_len, pn_len, sn_len, na_len;
>> +	int sn, pn, na, addr, ret = 0;
>>  	u8 *vpd, base_val = 0;
>> -	unsigned int vpdr_len, kw_offset, id_len;
>>  
>>  	vpd = vmalloc(VPD_LEN);
>>  	if (!vpd)
>> @@ -2772,60 +2771,48 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>>  	}
>>  
>>  	id_len = pci_vpd_lrdt_size(vpd);
>> -	if (id_len > ID_LEN)
>> -		id_len = ID_LEN;
>>  
>> -	i = pci_vpd_find_tag(vpd, VPD_LEN, PCI_VPD_LRDT_RO_DATA);
>> -	if (i < 0) {
>> -		dev_err(adapter->pdev_dev, "missing VPD-R section\n");
>> +	ret = pci_vpd_check_csum(vpd, VPD_LEN);
>> +	if (ret) {
>> +		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
>>  		ret = -EINVAL;
>>  		goto out;
>>  	}
>>  
>> -	vpdr_len = pci_vpd_lrdt_size(&vpd[i]);
>> -	kw_offset = i + PCI_VPD_LRDT_TAG_SIZE;
>> -	if (vpdr_len + kw_offset > VPD_LEN) {
>> -		dev_err(adapter->pdev_dev, "bad VPD-R length %u\n", vpdr_len);
>> -		ret = -EINVAL;
>> +	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN,
>> +					   PCI_VPD_RO_KEYWORD_SERIALNO, &sn_len);
>> +	if (ret < 0)
>>  		goto out;
>> -	}
>> +	sn = ret;
>>  
>> -#define FIND_VPD_KW(var, name) do { \
>> -	var = pci_vpd_find_info_keyword(vpd, kw_offset, vpdr_len, name); \
>> -	if (var < 0) { \
>> -		dev_err(adapter->pdev_dev, "missing VPD keyword " name "\n"); \
> 
> Just for the record, I guess this patch gives up these error messages
> that mention the specific keyword that's missing?  Not really an issue
> for *me*, since the people generating the VPD content should be able to
> easily validate this and figure out any errors.  Just pointing it out
> in case the cxgb4 folks are attached to the messages.
> 
Right. My thought was: With userspace tools like "lspci -vv" or
"od <path>/vpd" it's easy to check the actual content of VPD and find
out which keyword is missing. Therefore the missing keyword doesn't
necessarily has to be referenced in an error message.

>> -		ret = -EINVAL; \
>> -		goto out; \
>> -	} \
>> -	var += PCI_VPD_INFO_FLD_HDR_SIZE; \
>> -} while (0)
>> -
>> -	ret = pci_vpd_check_csum(vpd, VPD_LEN);
>> -	if (ret) {
>> -		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
>> -		ret = -EINVAL;
>> +	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN,
>> +					   PCI_VPD_RO_KEYWORD_PARTNO, &pn_len);
>> +	if (ret < 0)
>>  		goto out;
>> -	}
>> +	pn = ret;
>>  
>> -	FIND_VPD_KW(sn, "SN");
>> -	FIND_VPD_KW(pn, "PN");
>> -	FIND_VPD_KW(na, "NA");
>> -#undef FIND_VPD_KW
>> +	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN, "NA", &na_len);
>> +	if (ret < 0)
>> +		goto out;
>> +	na = ret;
>>  
>> -	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, id_len);
>> +	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, min_t(int, id_len, ID_LEN));
>>  	strim(p->id);
>> -	i = pci_vpd_info_field_size(vpd + sn - PCI_VPD_INFO_FLD_HDR_SIZE);
>> -	memcpy(p->sn, vpd + sn, min(i, SERNUM_LEN));
>> +	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
>>  	strim(p->sn);
>> -	i = pci_vpd_info_field_size(vpd + pn - PCI_VPD_INFO_FLD_HDR_SIZE);
>> -	memcpy(p->pn, vpd + pn, min(i, PN_LEN));
>> +	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
>>  	strim(p->pn);
>> -	memcpy(p->na, vpd + na, min(i, MACADDR_LEN));
>> +	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
>>  	strim((char *)p->na);
>>  
>>  out:
>>  	vfree(vpd);
>> -	return ret < 0 ? ret : 0;
>> +	if (ret < 0) {
>> +		dev_err(adapter->pdev_dev, "error reading VPD\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>>  }
>>  
>>  /**
>> -- 
>> 2.33.0
>>
>>

