Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED1542CDFA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhJMWbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhJMWbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:31:15 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7848FC061771
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:29:07 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id 5so1478758iov.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=muoW85T90n0ZXCHUscPrXeK2w/2bo9B4NuyO7fpp38I=;
        b=PuG3kkddIrZTZBGbXRIKjqNEAmwIHiraBfzytUr/6JVcj4enfnOvpKD2Ys645GaheK
         qcqOmpmk2ICjwi+fXL0QVAY9hGf7YE8JNlIauEclMhDMx4Lg4NYAzKHNJsZolGPRXqdi
         JwWsbH/nwIvP7NTomVCKdbnSY/JBPtIklBQOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=muoW85T90n0ZXCHUscPrXeK2w/2bo9B4NuyO7fpp38I=;
        b=acl8tOgiUQ/B1bx07gYujWZKdX59uQ3g+4MIZK2HMLWNv/Be/9bNR7toyuV8Hkoo68
         d4Oq/w3w4YZloq1SIK7+El2lYsUYjesiTcrdN2N9sqTWE0kZU//lcqu6TSeydrTKe891
         sTQZRT0p4x5xkxZX+RgVaP/iiofyYoNBaRT8oUL4ixzGRwK7FRE1Po3dro0zQ5b3dwwa
         rUBn6HuZybO3EREfjSNlf95f/xIoi5a0D5Fv/IPZ5rAlEWPRdnRjGMA76f2uu7W/bUi/
         Pd6GkmCywYhzlvTwJ808U/2FrjM/2QEwU32WuKZevi9Wv6+qdX3c/XztbCEYVwglJttQ
         HzCg==
X-Gm-Message-State: AOAM531YM6yGpcEv/LWhdm/0mdPWbZx15RBksJwLaz1m7/fluleNMvW6
        6vDjCsiqd6p7W86dsfa8NDymRg==
X-Google-Smtp-Source: ABdhPJw4lwRGD9mFUzW4BOTBNZJ/oEeQbKTAxtCdYjr7O0QoT0XD3K4Ocn5SuVvKnQFezUDsDs8KKg==
X-Received: by 2002:a6b:cd87:: with SMTP id d129mr1490055iog.28.1634164146921;
        Wed, 13 Oct 2021 15:29:06 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id a8sm358444iok.36.2021.10.13.15.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:28:59 -0700 (PDT)
Subject: Re: [RFC PATCH 02/17] net: ipa: revert to IPA_TABLE_ENTRY_SIZE for
 32-bit IPA support
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-3-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <3d0d6d98-201f-496f-a479-9aeaf8b2e837@ieee.org>
Date:   Wed, 13 Oct 2021 17:28:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-3-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:07 PM, Sireesh Kodali wrote:
> From: Vladimir Lypak <vladimir.lypak@gmail.com>
> 
> IPA v2.x is 32 bit. Having an IPA_TABLE_ENTRY size makes it easier to
> deal with supporting both 32 bit and 64 bit IPA versions

This looks reasonable.  At this point filter/route tables aren't
really used, so this is a simple fix.  You use IPA_IS_64BIT()
here, but it isn't defined until patch 7, which I expect is a
build problem.

					-Alex

> Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>   drivers/net/ipa/ipa_qmi.c   | 10 ++++++----
>   drivers/net/ipa/ipa_table.c | 29 +++++++++++++----------------
>   drivers/net/ipa/ipa_table.h |  4 ++++
>   3 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
> index 90f3aec55b36..7e2fe701cc4d 100644
> --- a/drivers/net/ipa/ipa_qmi.c
> +++ b/drivers/net/ipa/ipa_qmi.c
> @@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
>   	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
>   	req.v4_route_tbl_info_valid = 1;
>   	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
> -	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
> +	req.v4_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
>   
>   	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
>   	req.v6_route_tbl_info_valid = 1;
>   	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
> -	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
> +	req.v6_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
>   
>   	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
>   	req.v4_filter_tbl_start_valid = 1;
> @@ -352,7 +352,8 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
>   		req.v4_hash_route_tbl_info_valid = 1;
>   		req.v4_hash_route_tbl_info.start =
>   				ipa->mem_offset + mem->offset;
> -		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
> +		req.v4_hash_route_tbl_info.count =
> +				mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
>   	}
>   
>   	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
> @@ -360,7 +361,8 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
>   		req.v6_hash_route_tbl_info_valid = 1;
>   		req.v6_hash_route_tbl_info.start =
>   			ipa->mem_offset + mem->offset;
> -		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
> +		req.v6_hash_route_tbl_info.count =
> +				mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
>   	}
>   
>   	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> index 1da334f54944..96c467c80a2e 100644
> --- a/drivers/net/ipa/ipa_table.c
> +++ b/drivers/net/ipa/ipa_table.c
> @@ -118,7 +118,8 @@
>    * 32-bit all-zero rule list terminator.  The "zero rule" is simply an
>    * all-zero rule followed by the list terminator.
>    */
> -#define IPA_ZERO_RULE_SIZE		(2 * sizeof(__le32))
> +#define IPA_ZERO_RULE_SIZE(version) \
> +	 (IPA_IS_64BIT(version) ? 2 * sizeof(__le32) : sizeof(__le32))
>   
>   /* Check things that can be validated at build time. */
>   static void ipa_table_validate_build(void)
> @@ -132,12 +133,6 @@ static void ipa_table_validate_build(void)
>   	 */
>   	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(__le64));
>   
> -	/* A "zero rule" is used to represent no filtering or no routing.
> -	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
> -	 * assumes that it can be written using a pointer to __le64.
> -	 */
> -	BUILD_BUG_ON(IPA_ZERO_RULE_SIZE != sizeof(__le64));
> -
>   	/* Impose a practical limit on the number of routes */
>   	BUILD_BUG_ON(IPA_ROUTE_COUNT_MAX > 32);
>   	/* The modem must be allotted at least one route table entry */
> @@ -236,7 +231,7 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
>   	/* Skip over the zero rule and possibly the filter mask */
>   	skip = filter_mask ? 1 : 2;
>   
> -	return ipa->table_addr + skip * sizeof(*ipa->table_virt);
> +	return ipa->table_addr + skip * IPA_TABLE_ENTRY_SIZE(ipa->version);
>   }
>   
>   static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
> @@ -255,8 +250,8 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
>   	if (filter)
>   		first++;	/* skip over bitmap */
>   
> -	offset = mem->offset + first * sizeof(__le64);
> -	size = count * sizeof(__le64);
> +	offset = mem->offset + first * IPA_TABLE_ENTRY_SIZE(ipa->version);
> +	size = count * IPA_TABLE_ENTRY_SIZE(ipa->version);
>   	addr = ipa_table_addr(ipa, false, count);
>   
>   	ipa_cmd_dma_shared_mem_add(trans, offset, size, addr, true);
> @@ -434,11 +429,11 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
>   		count = 1 + hweight32(ipa->filter_map);
>   		hash_count = hash_mem->size ? count : 0;
>   	} else {
> -		count = mem->size / sizeof(__le64);
> -		hash_count = hash_mem->size / sizeof(__le64);
> +		count = mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
> +		hash_count = hash_mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
>   	}
> -	size = count * sizeof(__le64);
> -	hash_size = hash_count * sizeof(__le64);
> +	size = count * IPA_TABLE_ENTRY_SIZE(ipa->version);
> +	hash_size = hash_count * IPA_TABLE_ENTRY_SIZE(ipa->version);
>   
>   	addr = ipa_table_addr(ipa, filter, count);
>   	hash_addr = ipa_table_addr(ipa, filter, hash_count);
> @@ -621,7 +616,8 @@ int ipa_table_init(struct ipa *ipa)
>   	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
>   	 * of pages, which satisfies the rule alignment requirement.
>   	 */
> -	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
> +	size = IPA_ZERO_RULE_SIZE(ipa->version) +
> +	       (1 + count) * IPA_TABLE_ENTRY_SIZE(ipa->version);
>   	virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
>   	if (!virt)
>   		return -ENOMEM;
> @@ -653,7 +649,8 @@ void ipa_table_exit(struct ipa *ipa)
>   	struct device *dev = &ipa->pdev->dev;
>   	size_t size;
>   
> -	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
> +	size = IPA_ZERO_RULE_SIZE(ipa->version) +
> +	       (1 + count) * IPA_TABLE_ENTRY_SIZE(ipa->version);
>   
>   	dma_free_coherent(dev, size, ipa->table_virt, ipa->table_addr);
>   	ipa->table_addr = 0;
> diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
> index b6a9a0d79d68..78a168ce6558 100644
> --- a/drivers/net/ipa/ipa_table.h
> +++ b/drivers/net/ipa/ipa_table.h
> @@ -10,6 +10,10 @@
>   
>   struct ipa;
>   
> +/* The size of a filter or route table entry */
> +#define IPA_TABLE_ENTRY_SIZE(version)	\
> +	(IPA_IS_64BIT(version) ? sizeof(__le64) : sizeof(__le32))
> +
>   /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
>   #define IPA_FILTER_COUNT_MAX	14
>   
> 

