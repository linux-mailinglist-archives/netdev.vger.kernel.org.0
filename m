Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD792B89DF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgKSByT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgKSByS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:54:18 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A7BC0613D4;
        Wed, 18 Nov 2020 17:54:18 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id g7so2928619pfc.2;
        Wed, 18 Nov 2020 17:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oilqbm0PbyF3KMvGCOoKWnR48rcsD2eNT+QPWjMgMFw=;
        b=XBYO4bbob8cQz4HlqKLE1CpP4bo91AyKwEtYi6lLaUPpXPb/l43xjXhmlhsfhdcWtu
         5dAK3cD7tFm1HvXrltDWAvY/qfCVXbzCCH/pq8cfwQsbnJsEi+L6fvP1aEuEjWjbjvmA
         RChjXZK5uTYhshAWglI19xWnnaSQ3O1lojiCx/l0feXQ7FzdhI/lH0OhJnqug9VuFavk
         iVWyEqBHCh12Pi6YwJJ+uHPhyKHK27yi8g5HKGmVTbXrIVrzU8qHWtvWhPvZ/EmYVwWc
         A4g8VUUCvhQisNyLY1jjaN9BUR+r/hVCPfVOCHGtv19arFF1XFfcEdD3WHK8GxWOX9/Z
         MZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oilqbm0PbyF3KMvGCOoKWnR48rcsD2eNT+QPWjMgMFw=;
        b=Re3uJFzzBz092FIm5QGklIWsqKD26DhRKKmX1m701hSx095oU/2RH1ktOXYvo37BzG
         GBOJLht3p+P5V9jTQuo+bTsqC66G5q1nK3jlYagCnPdYzeVT08A7xrqtNGUgaZtx9U9y
         C9qmc82gID7t/7XmtJAEwmUl2WoizgrFjHqwJMNuUXdxL2BSSJ+xX3yFmwlux/iZ4WM6
         T2H8kfAmzr8/QeIuMlyEkG+SzfFt9cVoWKb8c03fUc1dn7HTT6pbDI7cFrWeq1I2sZeu
         2tzrKc9oK42995QzJD6ReRVMwtii1Oxrj4uFvFtes0bxJ/ozD6ZlA+fd2Nsw0v75Gn+p
         IK4g==
X-Gm-Message-State: AOAM530z9YDbqZkYMOptncNOr3V5LctCKYnsR3EKDGlbsbLP3Loov/nW
        p9zHOby1O0yKe+CEWfm3FIDW2Kkhqd2sUA==
X-Google-Smtp-Source: ABdhPJyODx/iAkOp7RFSPXqLNcVJygh8K6z2gu97gOXFOyZNWaZZYMZ+k/FvdeND6jmU05sD+kwIxA==
X-Received: by 2002:a63:4558:: with SMTP id u24mr10751984pgk.376.1605750857559;
        Wed, 18 Nov 2020 17:54:17 -0800 (PST)
Received: from [10.165.0.22] ([45.56.153.149])
        by smtp.gmail.com with ESMTPSA id u5sm24066564pgj.28.2020.11.18.17.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 17:54:16 -0800 (PST)
Subject: Re: [PATCH v2 1/4] rtlwifi: rtl8188ee: avoid accessing the data
 mapped to streaming DMA
To:     Larry Finger <Larry.Finger@lwfinger.net>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201118015314.4979-1-baijiaju1990@gmail.com>
 <d3996305-136a-708b-0dba-e9428f9da5cb@lwfinger.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <9a4a11cf-6505-3434-85fa-262e3e16bc47@gmail.com>
Date:   Thu, 19 Nov 2020 09:54:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d3996305-136a-708b-0dba-e9428f9da5cb@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the advice.
I have added the description of the changes and resent the patches.


Best wishes,
Jia-Ju Bai

On 2020/11/19 1:20, Larry Finger wrote:
> On 11/17/20 7:53 PM, Jia-Ju Bai wrote:
>> In rtl88ee_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
>> line 677:
>>    dma_addr_t mapping = dma_map_single(..., skb->data, ...);
>>
>> On line 680, skb->data is assigned to hdr after cast:
>>    struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
>>
>> Then hdr->frame_control is accessed on line 681:
>>    __le16 fc = hdr->frame_control;
>>
>> This DMA access may cause data inconsistency between CPU and hardwre.
>>
>> To fix this bug, hdr->frame_control is accessed before the DMA mapping.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> What changed between v1 and v2?
>
> As outlined in Documentation/process/submitting-patches.rst, you 
> should add a '---' marker and descrive what was changed. I usually 
> summarize the changes, but it is also possible to provide a diffstat 
> of the changes as the above file shows.
>
