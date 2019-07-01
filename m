Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F495C28F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGASDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:03:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42259 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfGASDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:03:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so6942527pff.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 11:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=foyGFpgmMEIcv+DbiZO8K8RT2dnl14rC208y5vqzfRA=;
        b=T6vpqd0g7GQQbxh2uWn2+H+OzLyMsCtIk2fyvfUWY5bPbuqeT+5h+Bpq7Sii+gbJNF
         5ciGnKLIkiFe4Y0vVgGjNELwJaCTFqRDLxWJiU1sSSeVGNan4X5XiGD134XsoDa4LnmM
         mw4lTsk9bjp9i6Jd8GRYWJ/vxbsmbngSVLl7taDFHCiM0PacQ1fqTw8F7OHu6sDdpmL+
         VpTDoRCQINvdVvn0m5D2jYuLJQxOzUrAO2vp9XSlBHEsQTF4ac52QmIINhSunhsW7x67
         2aDpf3y4QrAayeq+TLhE/mOB1QiX5Bx7Xsn6//Yv7HFhkk8V0ehMk2cXVf/pt+MFGXTA
         ysZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=foyGFpgmMEIcv+DbiZO8K8RT2dnl14rC208y5vqzfRA=;
        b=QoUS65bh+S3G14f36TBJ9jp0QytJiDv6a7rsztz3ejP0hDcfcK7Y9aUjFkXgGCLikY
         Iq764VkJgsehQZyUlAXKhTC7CgWKhj5qXm2AuigC1GI8APyg+wwwIiUzHYElEpQyMFF8
         vDfJcod56SokYjneXCH+VgfvK2Jnm9qJ9jvf/F5U/O3SRlCYx609vugQa8zBILqjL98J
         nrNLINRbdtF8pZkMmsbcnZs+NXGelwziHtlMu7hwU/7nuh8cgZ5tHXB1aLybUZ74O7Zb
         DOJoO+wpp5Ra9h/m5pqZAvPfIsihLsMyST8AW1FoM9Ax7iOxhWTvt+dWzgzjxld31XDt
         7TdQ==
X-Gm-Message-State: APjAAAXXDOm5/IBMYbbaBwvqN0XBnyIkHnZdpdZJbi1bfWU8d28E1qZO
        Asv2G9GMAmMGyU2W76h771TccUhdw04=
X-Google-Smtp-Source: APXvYqzmr7jp4nkpAlS4uYRjk1T3Hc+1193Hf3Tyrt1uB+cCWhcx2N2oUG8ngzhnxh8u0ThP2uveAg==
X-Received: by 2002:a63:506:: with SMTP id 6mr13781851pgf.434.1562004214463;
        Mon, 01 Jul 2019 11:03:34 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id g1sm5207533pgg.27.2019.07.01.11.03.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:03:33 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 17/19] ionic: Add RSS support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190628213934.8810-1-snelson@pensando.io>
 <20190628213934.8810-18-snelson@pensando.io>
 <20190629114839.6cf1f048@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9f59aa58-42c1-9b79-ab0b-840004e5079a@pensando.io>
Date:   Mon, 1 Jul 2019 11:03:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190629114839.6cf1f048@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/19 11:48 AM, Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 14:39:32 -0700, Shannon Nelson wrote:
>> @@ -1260,10 +1266,24 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
>>   	if (err)
>>   		goto err_out_free_lif_info;
>>   
>> +	/* allocate rss indirection table */
>> +	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
>> +	lif->rss_ind_tbl_sz = sizeof(*lif->rss_ind_tbl) * tbl_sz;
>> +	lif->rss_ind_tbl = dma_alloc_coherent(dev, lif->rss_ind_tbl_sz,
>> +					      &lif->rss_ind_tbl_pa,
>> +					      GFP_KERNEL);
>> +
>> +	if (!lif->rss_ind_tbl) {
>> +		dev_err(dev, "Failed to allocate rss indirection table, aborting\n");
>> +		goto err_out_free_qcqs;
>> +	}
>> +
>>   	list_add_tail(&lif->list, &ionic->lifs);
>>   
>>   	return lif;
>>   
>> +err_out_free_qcqs:
>> +	ionic_qcqs_free(lif);
>>   err_out_free_lif_info:
>>   	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
>>   	lif->info = NULL;
>> @@ -1302,6 +1322,14 @@ static void ionic_lif_free(struct lif *lif)
>>   {
>>   	struct device *dev = lif->ionic->dev;
>>   
>> +	/* free rss indirection table */
>> +	if (lif->rss_ind_tbl) {
>> +		dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
>> +				  lif->rss_ind_tbl_pa);
> dma_free_coherent() should be able to deal with NULLs just fine.
> Besides you fail hard if the allocation failed, no?

I like checking my pointers, but sure, this can be simplified.
sln

>
>> +		lif->rss_ind_tbl = NULL;
>> +		lif->rss_ind_tbl_pa = 0;
>> +	}

