Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48143B2E6A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhFXMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhFXMDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:03:02 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3528C061574;
        Thu, 24 Jun 2021 05:00:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g24so3323872pji.4;
        Thu, 24 Jun 2021 05:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YUdxYuClvDRmHqPmsuWUK5u98CIP+cWKtyMM1DPZLOY=;
        b=UTz+UmFTNa1qSkUmlCLB7WVVC9g1kbwD3dvQ0RbTBOQnD1Q/YA0DNcbjshDh7K9/2B
         ay/8b0+Un7GhGmDZDM8YRRuUWY8+vbicPGCRsIuqpgE/hhGZWJnyv2aWAPrqOCoblOtj
         WFpkHgq/qjygkSJ+5/0K9OOkyu7KbzDll6Hns0/kCpXdAETEH27U6Iw42Ld4az+OkoYv
         Qcv0LMcrhiZ6bCc7maERmuprC2Iz5zvatCL9ge1uN4vqKKNI+iPnGpYZoJqh6TS84TuP
         DQZibK4wruhGpxmPbPrp40aapvGdUp5bxoxa441VRo2A7V9HAJUezk09EidMO+U43sPY
         AGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YUdxYuClvDRmHqPmsuWUK5u98CIP+cWKtyMM1DPZLOY=;
        b=GmB6BD46UpZuRbnYEKtpQ2NWDcTeAQoAoFBkd43hQPuHcS6iZ3RwzodTyUr/SileU+
         4/ld8UkH7VD7pbxlnJD2Eov4/tByTITN/BHE2S5i2Y8Ro7AjKlpL0cES5eDhUvBEbPtH
         rLOUBRxFoqxo9tILUelAbcASXKmL5Ob/eD/t52JhXxs6yoXjkDX8bnlvsTkoSIfrcV8m
         8ZID0RDp3UF1AWFq+7051amJ4P5tHC0R9NnU5y9ClKPqx1vB21WFaphPT9mwJ/9YkdrB
         wikB30noBMKTLZJyb9UVCX0PoOVbTda7jv5KL3fpHPt8Jvstm87YQlsvKFIOS+sPaV2q
         VzxQ==
X-Gm-Message-State: AOAM5311YhgRiUjAc7XZ70FA35OtrAwbsQGzAHn6AERAzMIsKDYeGY/F
        iYnDJMHlaoKwpDO1pTT4Ls0=
X-Google-Smtp-Source: ABdhPJyRqHSvRYgXQ2+WgWDELsTdMQrdiwif2M/USvVlAWybsvolUNbiMruzbgseX4W6ghdnv4q/ng==
X-Received: by 2002:a17:90a:a611:: with SMTP id c17mr14623473pjq.184.1624536043137;
        Thu, 24 Jun 2021 05:00:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w123sm2936836pff.186.2021.06.24.05.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 05:00:42 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 24 Jun 2021 19:56:44 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 12/19] staging: qlge: rewrite do while loops as for loops
 in qlge_start_rx_ring
Message-ID: <20210624115644.dmjskfsbcu7xcat5@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-13-coiby.xu@gmail.com>
 <YNGVEiS8mITXQ5sS@d3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YNGVEiS8mITXQ5sS@d3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 04:45:22PM +0900, Benjamin Poirier wrote:
>On 2021-06-21 21:48 +0800, Coiby Xu wrote:
>> Since MAX_DB_PAGES_PER_BQ > 0, the for loop is equivalent to do while
>> loop.
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/qlge_main.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
>> index 7aee9e904097..c5e161595b1f 100644
>> --- a/drivers/staging/qlge/qlge_main.c
>> +++ b/drivers/staging/qlge/qlge_main.c
>> @@ -3029,12 +3029,11 @@ static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
>>  		tmp = (u64)rx_ring->lbq.base_dma;
>>  		base_indirect_ptr = rx_ring->lbq.base_indirect;
>>  		page_entries = 0;
>
>This initialization can be removed now. Same thing below.

Yes, thanks for the suggestion!

>
>> -		do {
>> +		for (page_entries = 0; page_entries < MAX_DB_PAGES_PER_BQ; page_entries++) {
>>  			*base_indirect_ptr = cpu_to_le64(tmp);
>>  			tmp += DB_PAGE_SIZE;
>>  			base_indirect_ptr++;
>> -			page_entries++;
>> -		} while (page_entries < MAX_DB_PAGES_PER_BQ);
>> +		}
>>  		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
>>  		cqicb->lbq_buf_size =
>>  			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
>> @@ -3046,12 +3045,11 @@ static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
>>  		tmp = (u64)rx_ring->sbq.base_dma;
>>  		base_indirect_ptr = rx_ring->sbq.base_indirect;
>>  		page_entries = 0;
>> -		do {
>> +		for (page_entries = 0; page_entries < MAX_DB_PAGES_PER_BQ; page_entries++) {
>>  			*base_indirect_ptr = cpu_to_le64(tmp);
>>  			tmp += DB_PAGE_SIZE;
>>  			base_indirect_ptr++;
>> -			page_entries++;
>> -		} while (page_entries < MAX_DB_PAGES_PER_BQ);
>> +		}
>>  		cqicb->sbq_addr = cpu_to_le64(rx_ring->sbq.base_indirect_dma);
>>  		cqicb->sbq_buf_size = cpu_to_le16(QLGE_SMALL_BUFFER_SIZE);
>>  		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
>> --
>> 2.32.0
>>

-- 
Best regards,
Coiby
