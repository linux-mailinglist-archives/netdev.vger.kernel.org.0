Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8A3621A30
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbiKHRNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiKHRND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:13:03 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B143554F1
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:13:01 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w14so21985937wru.8
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 09:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8A9SN6GA7iui8q0N6B6Jh9IkTxfSUaxa79xTNwU/+jo=;
        b=Pvie15L4ZnPpV6ZrhLy70pbvGdH205FkcjERHJ++xFPRo+HsPFxpzoO8KKNwUpA+Pp
         PNsP1QuSsv3H9qb6qUZ8mkNANSl1b26QTuWLcHZiAa8ViIw2xE9e5/1wbQZoHa6I7MG1
         vuJsW0NTMUOTRfs0Sn46T2a3EQ4ADC18vfkiVZPEzReL7P8c7JCCoLtVaNBnolJrQvYm
         YfLLPNP3kQAcsPx5TTAfOlCzp5++C7R9N/tSSEoBkriJXT5PrtszkNfVImhGju2zymnl
         Mld5Hsc+ySu0CjMG8LNa75FdOaeNNnrtjHxi7ctIUw8eXWQ5hOL0S60frrLJv9pcAFIw
         v6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8A9SN6GA7iui8q0N6B6Jh9IkTxfSUaxa79xTNwU/+jo=;
        b=fK8jHoePSLCz1y6SLzMZmX/XmFBU5YlwJispCJnLocZB2giy82aVXlgiRx/tVLLNxk
         k8InAd1jki06hqShPw8kSV0d60Hoo6nQUIhLToXHgHAjk3Sn9EwwI7yu1K8R7Bs4xB/K
         2t7+TWh/RkyjAga1fROFLNAo8c+C9FlojUzPswpjk1BXY9v+BLRWmLh4WjgixTbHdI0t
         /ZNoR00Ui7DbiZi+jBa4t4ncLVtc4XIwi1fZHa0qTfchmfooVgO7APx674cIIUow9E4O
         yyxXDHqYKIHFX9Mz/6WG4SP5tlDZcMq2/uAFIdrM635gCZV18Ab3kF6h1s2HGXu2usvr
         gC+w==
X-Gm-Message-State: ACrzQf26+I5fuJTZ7E9QIqfSBzh6S6H4rG+/cgVKRo2dzcLK9VnUa1CW
        XZKDDgJq7Qmz9S4CixWxOnIz1sTsjDk=
X-Google-Smtp-Source: AMsMyM59HzbWRXnSpfxKeRWKeqf08k/WOn/uMpm9pDLW11ts8mOVwDvcGTk7oWovxYlLezFU7WD5Mg==
X-Received: by 2002:adf:f84c:0:b0:236:6e52:504 with SMTP id d12-20020adff84c000000b002366e520504mr35079274wrq.564.1667927579713;
        Tue, 08 Nov 2022 09:12:59 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n11-20020a5d67cb000000b00236576c8eddsm10783255wrw.12.2022.11.08.09.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 09:12:59 -0800 (PST)
Subject: Re: Confused about ip_summed member in sk_buff
To:     "J.J. Mars" <mars14850@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAHUXu_WyYzuTOiz75VfhST6nL3gm0B49dDMjgkzEQ0m_h4Rh1g@mail.gmail.com>
 <Y1RJvsTpbC6K5I9Y@pop-os.localdomain>
 <CAHUXu_Vf5f8G3YkWzNQhqi2ZTjNKGu_BwkuV7SzD-Tc_fHW63g@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d309d044-6e9f-e722-6d75-46b174736cc2@gmail.com>
Date:   Tue, 8 Nov 2022 17:12:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHUXu_Vf5f8G3YkWzNQhqi2ZTjNKGu_BwkuV7SzD-Tc_fHW63g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/11/2022 12:32, J.J. Mars wrote:
> Thanks for your reply. I've been busy these days so that I can't reply on time.
> I've read the annotation about ip_summed in skbuff.h many times but it
> still puzzles me so I write my questions here directly.
> 
> First of all, I focus on the receive direction only.
> 
> Q1: In section 'CHECKSUM_COMPLETE' it said 'The device supplied
> checksum of the _whole_ packet as seen by netif_rx() and fills out in
> skb->csum. Meaning, the hardware doesn't need to parse L3/L4 headers
> to implement this.' So I assume the 'device' is a nic or something
> like that which supplied checksum, but the 'hardware' doesn't need to
> parse L3/L4 headers. So what's the difference between 'device' and
> 'hardware'? Which one is the nic?

Both.
To implement this feature, the NIC is supposed to treat the packet data
 as an unstructured array of 16-bit integers, and compute their (ones-
 complement) sum.
When the kernel parses the packet headers, it will subtract out from
 this sum the headers it consumes, and then check that what's left over
 matches the sum of the L4 pseudo header (as it should for a correctly
 checksummed packet).
Note that this design means protocol parsing happens only in software,
 with the NIC completely protocol-agnostic; thus upgrades to support
 new protocols only require a kernel upgrade and not a new NIC.

> Q2: Which layer does the checksum refer in section 'CHECKSUM_COMPLETE'
> as it said 'The device supplied checksum of the _whole_ packet'. I
> assume it refers to both L3 and L4 checksum because of the word
> 'whole'.

See above - the device is not supposed to know or care where L3 or L4
 headers start or where their checksum fields live, it just sums the
 whole thing, and the kernel mathematically derives the sum of the L4
 payload from that.

> Q3: The full checksum is not calculated when 'CHECKSUM_UNNECESSARY' is
> set. What does the word 'full' mean? Does it refer to both L3 and L4?
> As it said 'CHECKSUM_UNNECESSARY' is set for some L4 packets, what's
> the status of L3 checksum now? Does L3 checksum MUST be right when
> 'CHECKSUM_UNNECESSARY' is set?

'full' here refers to the CHECKSUM_COMPLETE sum described above.
CHECKSUM_UNNECESSARY refers to the L4 checksum, and may be set by the
 driver when the hardware has determined that the L4 checksum is
 correct.  This is an inferior hardware design because it can only
 support those specific protocols the hardware understands; but we
 handle it in the kernel because lots of hardware like that exists :(
L3 checksums are never offloaded to hardware (neither by
 CHECKSUM_COMPLETE nor by CHECKSUM_UNNECESSARY); because they only
 sum over the L3 header (not its payload), they are cheap to compute
 in software (the costly bit is actually bringing the data into cache,
 and we have to do that anyway to parse the header, so summing it at
 the same time is almost free).
AFAIK a driver may set CHECKSUM_UNNECESSARY even if the L3 checksum is
 incorrect, because it only covers the L4 sum; but I'm not 100% sure.

> Q4: In section 'CHECKSUM_PARTIAL' it described status of SOME part of
> the checksum is valid. As it said this value is set in GRO path, does
> it refer to L4 only?

Drivers should not use CHECKSUM_PARTIAL on the RX side; only on TX
 (for which see [1] for additional documentation).

> Q5: 'CHECKSUM_COMPLETE' and 'CHECKSUM_UNNECESSARY', which one supplies
> the most complete status of checksum? I assume it's
> CHECKSUM_UNNECESSARY.

CHECKSUM_COMPLETE is preferred, as per above remarks about protocols.

> Q6: The name ip_summed doesn't describe the status of L3 only but also
> L4? Or just L4?

Just L4.  It's called "ip_summed" because the "16-bit ones-complement
 sum" style of checksum is also known as the "Internet checksum"
 since it is used repeatedly in the Internet protocol suite, such as
 in TCP and UDP as well as IPv4.  Yes, this is confusing, but it's
 too late to rename it now.

HTH,
-ed

[1] https://www.kernel.org/doc/html/latest/networking/checksum-offloads.html#tx-checksum-offload
