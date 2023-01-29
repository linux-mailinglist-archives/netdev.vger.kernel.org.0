Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9441C680171
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 22:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjA2VRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 16:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2VRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 16:17:47 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9A01B577;
        Sun, 29 Jan 2023 13:17:46 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p24so9699597plw.11;
        Sun, 29 Jan 2023 13:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WzCR/kkh0GClQTxeGrlzzYHLJyi3/RtweFdRsyAgojo=;
        b=L6QboMewpj+c4tcnEw4CQb4eTg2FCUOh4wzjgAZq6/f0dfi594K2DXdW+sknOaIDe+
         wBnWTkZ+QvijKxBW30aROUTdvn+dS7EV/j8PM9bXBzMCj5G+2pz1XxtowsFWS2bfz9W/
         jWoaYWG8pDz0tdBHWRSvzu8AgnsC+mLDf5d396HU6qcQuPso4eYscruSRMGV8XbFFO7q
         9gzs0fL9IhPH1NnSm+d4i/e2Qydibuwt7FASV6/HdWVX6wl6vJ0ebDzZfD9GBSgKfjuL
         gBD5IIvAnPaFFvDTpDAsxfukWSckWH6Dfbwf/QmVkdou4x73mOJllYSRKicg5TWT+mUu
         X3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WzCR/kkh0GClQTxeGrlzzYHLJyi3/RtweFdRsyAgojo=;
        b=0JTaY8p1nJEfFFLIfwMpniihkQLVyVylYTYDGXXr+NYvSH9OYO5oWzHtbTJmA9cf1G
         bmDDrkTYi4moJ1kGUjo+KNwAILOBtEz1QukUTr7DWiCDs5vpAz+rDpO8ret0G+gUxnPz
         FkCU+Y/AvfmPQXp87rgGTQ3YfBmzt+4euWZbcMNC1pMU6afhpubTxFyGgAaPT+yMrhPe
         O4JKT0uyjIJnPTJ6UcMT+Zg+/edBK8p2/gQi/3m/m6WyNJ0AAQ/j92SO6SaHWJYSKtlz
         mVNhKi4NaAzHSYOD2oCyrVTQnOy9GxSEJRhRvIfQB8fYWnfMT862A4ZHBN6W7CCp1ecK
         vP8Q==
X-Gm-Message-State: AO0yUKWc3Ed9UHJH2Ov/D4FaOLpzgCFfZikmxDZu4RPcOe6IMszUIzW8
        Q+UP+crru4g7P5TWUl9/HBc=
X-Google-Smtp-Source: AK7set8HHNHhlAQGnOpl/cVDTBE06f83yVIeCKG8Xb7OnikiOnLwXbANYso1MdtTTzmiWYdpTQwdxw==
X-Received: by 2002:a17:902:e5d2:b0:196:5425:9eea with SMTP id u18-20020a170902e5d200b0019654259eeamr12560789plf.41.1675027065926;
        Sun, 29 Jan 2023 13:17:45 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:9823:8a56:c0d8:5a7f? ([2600:8802:b00:4a48:9823:8a56:c0d8:5a7f])
        by smtp.gmail.com with ESMTPSA id jk22-20020a170903331600b00194c82c2a7bsm6290743plb.224.2023.01.29.13.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 13:17:45 -0800 (PST)
Message-ID: <7cbbb800-9999-302a-5ea9-b93020a1e9e8@gmail.com>
Date:   Sun, 29 Jan 2023 13:17:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net-next] net: bcmgenet: Add a check for oversized packets
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, maxime@cerno.tech,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230127000819.3934-1-f.fainelli@gmail.com>
 <Y9Y/jMZZbS4HNpCC@unreal>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y9Y/jMZZbS4HNpCC@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2023 1:42 AM, Leon Romanovsky wrote:
> On Thu, Jan 26, 2023 at 04:08:19PM -0800, Florian Fainelli wrote:
>> Occasionnaly we may get oversized packets from the hardware which
>> exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
>> check which drops the packet to avoid invoking skb_over_panic() and move
>> on to processing the next packet.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index 21973046b12b..d937daa8ee88 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -2316,6 +2316,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
>>   			  __func__, p_index, ring->c_index,
>>   			  ring->read_ptr, dma_length_status);
>>   
>> +		if (unlikely(len > RX_BUF_LENGTH)) {
>> +			netif_err(priv, rx_status, dev, "oversized packet\n");
> 
> I don't think that it is wise move to print to dmesg something that can
> be triggered by user over network.

A frame larger than RX_BUF_LENGTH intentionally received would be 
segmented by the MAC, we have seen this happen however while playing 
with unsafe clock ratios for instance or when there are insufficient 
credits given to the Ethernet MAC to write frames into DRAM. The print 
is consistent with other errors that are captured and is only enabled if 
the appropriate ethtool message level bitmask is set.
-- 
Florian
