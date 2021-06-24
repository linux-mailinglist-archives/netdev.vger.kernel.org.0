Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DE93B2E69
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFXMC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFXMCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:02:55 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08A9C061574;
        Thu, 24 Jun 2021 05:00:35 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m2so4526336pgk.7;
        Thu, 24 Jun 2021 05:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AIOGsHWLRny/cPcLESp662rsTaSLQc4NuErEHrE2mZs=;
        b=h2+QfjQyzHfvVgntvTZbXhaDnuTPh8GWLZuhDjHTvWWIdTAg966MGSSwhKbz+93L+X
         sdqbC27IL1Qa3v0uC/AM1A0cXhp2SVlgLMoCX4+9SxLXil3KgFr1qsRSpkGNUJN5LRU3
         Qa/PgGfanLESeHeCjKGdY7OVSlu+MlkbTHnzW4+/EdSNwNzbueEa3xnsOGbLEWVj7REo
         /KIgr2RnRKrmDQtdoXlW/3FfCgANIATswe8YduAL0Nbwmz6jJdQjIPT1HXLSRskONU05
         6EinNoy32Sq6xDfvp5CX4TRToTYNUHAC++qkc9TkfD5CDrcD8pVgKZjTCZmGDAqYOZQZ
         A5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AIOGsHWLRny/cPcLESp662rsTaSLQc4NuErEHrE2mZs=;
        b=r1VPhZRt/HFedvNyCiLaRcDTnFU2e5vktS/T/ACOwaN7gNr7b1y+aN6mPDGTejQQcI
         BH/vn50sxnC+qRs8zzkLSMs7puwBz00zapcpy1oj1ofVEWJwVnAyeTK96jRAbVhGo8kC
         0KCJb5cjs52+w9Ji4M/kIg1qJXxUARC6ioRt14ViBjQotzGXrvUyRNcLeADN/lJj2mVq
         Rh14VkCKEQ57PnxOS10pKrxUppJLPmxvi8WvQ8zw+Qa7I5NaVvfT+6esLW+nKBkUxp6a
         B9ltcEgadKVutNP0s1sDDYw6EDtwHWu8t3cdMJDr4smz2j3ZPQnNjqU9P1VPeNtW2Una
         aBtQ==
X-Gm-Message-State: AOAM533tKsUpXMARwR7iCmwJ72t0K1qg7ah/0Wra4Hkt/Pwx7NSjXS18
        few58X+D7tQD0EVVlGosDJY=
X-Google-Smtp-Source: ABdhPJzSlI8z9jpaMu8p5kCr79fbC+i63j1HqC/lmrRGUzV952gJivnulyalhSb5ZotCr/ggS9z2Zg==
X-Received: by 2002:a63:582:: with SMTP id 124mr4489536pgf.132.1624536035097;
        Thu, 24 Jun 2021 05:00:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9sm2965844pfh.217.2021.06.24.05.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 05:00:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 24 Jun 2021 19:55:36 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:CLANG/LLVM BUILD SUPPORT" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [RFC 17/19] staging: qlge: fix weird line wrapping
Message-ID: <20210624115536.5y4oqzrbms63rjcy@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-18-coiby.xu@gmail.com>
 <20210622084611.GM1861@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210622084611.GM1861@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 11:46:11AM +0300, Dan Carpenter wrote:
>On Mon, Jun 21, 2021 at 09:49:00PM +0800, Coiby Xu wrote:
>> @@ -524,8 +523,8 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
>>  		{
>>  			value = RT_IDX_DST_DFLT_Q | /* dest */
>>  				RT_IDX_TYPE_NICQ | /* type */
>> -				(RT_IDX_IP_CSUM_ERR_SLOT <<
>> -				RT_IDX_IDX_SHIFT); /* index */
>> +			(RT_IDX_IP_CSUM_ERR_SLOT
>> +			 << RT_IDX_IDX_SHIFT); /* index */
>
>The original is not great but the new indenting is definitely worse.
>It might look nicer with the comments moved in the front?  Why does
>RT_IDX_IDX_SHIFT have two IDX strings?

I'm not sure about it. Two IDX strings seems to be a typo.
>
>			/* value = dest | type | index; */
>			value = RT_IDX_DST_DFLT_Q |
>				RT_IDX_TYPE_NICQ  |
>				(RT_IDX_IP_CSUM_ERR_SLOT << RT_IDX_IDX_SHIFT);
>

This looks better! Thanks!

>
>>  			break;
>>  		}
>>  	case RT_IDX_TU_CSUM_ERR: /* Pass up TCP/UDP CSUM error frames. */
>> @@ -554,7 +553,8 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
>>  		{
>>  			value = RT_IDX_DST_DFLT_Q |	/* dest */
>>  			    RT_IDX_TYPE_NICQ |	/* type */
>> -			    (RT_IDX_MCAST_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
>> +			(RT_IDX_MCAST_MATCH_SLOT
>> +			 << RT_IDX_IDX_SHIFT); /* index */
>
>Original is better.

I'll also move the comments in the front.
>
>>  			break;
>>  		}
>>  	case RT_IDX_RSS_MATCH:	/* Pass up matched RSS frames. */
>> @@ -648,15 +648,15 @@ static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset, __le32 *d
>>  {
>>  	int status = 0;
>>  	/* wait for reg to come ready */
>> -	status = qlge_wait_reg_rdy(qdev,
>> -				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
>> +	status = qlge_wait_reg_rdy(qdev, FLASH_ADDR, FLASH_ADDR_RDY,
>> +				   FLASH_ADDR_ERR);
>>  	if (status)
>>  		goto exit;
>>  	/* set up for reg read */
>>  	qlge_write32(qdev, FLASH_ADDR, FLASH_ADDR_R | offset);
>>  	/* wait for reg to come ready */
>> -	status = qlge_wait_reg_rdy(qdev,
>> -				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
>> +	status = qlge_wait_reg_rdy(qdev, FLASH_ADDR, FLASH_ADDR_RDY,
>> +				   FLASH_ADDR_ERR);
>>  	if (status)
>>  		goto exit;
>>  	/* This data is stored on flash as an array of
>> @@ -792,8 +792,8 @@ static int qlge_write_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 data)
>>  {
>>  	int status;
>>  	/* wait for reg to come ready */
>> -	status = qlge_wait_reg_rdy(qdev,
>> -				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
>> +	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
>> +				   XGMAC_ADDR_XME);
>>  	if (status)
>>  		return status;
>>  	/* write the data to the data reg */
>> @@ -811,15 +811,15 @@ int qlge_read_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 *data)
>>  {
>>  	int status = 0;
>>  	/* wait for reg to come ready */
>> -	status = qlge_wait_reg_rdy(qdev,
>> -				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
>> +	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
>> +				   XGMAC_ADDR_XME);
>
>Need a blank line after the declaration block.

Sure, I will fix it in next version.

>
>>  	if (status)
>>  		goto exit;
>>  	/* set up for reg read */
>>  	qlge_write32(qdev, XGMAC_ADDR, reg | XGMAC_ADDR_R);
>>  	/* wait for reg to come ready */
>> -	status = qlge_wait_reg_rdy(qdev,
>> -				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
>> +	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
>> +				   XGMAC_ADDR_XME);
>>  	if (status)
>>  		goto exit;
>>  	/* get the data */
>
>regards,
>dan carpenter

-- 
Best regards,
Coiby
