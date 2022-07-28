Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4558460C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiG1SmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiG1SmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:42:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84FD874E26
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659033736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cyqjGuqo8Xez9KZB2n6ef57YiIlFUesAYzckfJsYgo=;
        b=BLPvxdsiz7h2mcBaSvYmYHaYXZe43JIBwsQ85N7ryB9oRJZ4YMLEwnviAyJGxtynVOaItH
        zX5/tJxgzUapoNFHb7nB5vmvxCku2UsDK4z6To9pfvftkmbP2CR8DwgeKEaLZHcEhhzWjj
        6AsQSvf1mrKUhHggPTpXZ6CTdbFynMo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-cLJYadqgNPavVRFauLOS6g-1; Thu, 28 Jul 2022 14:42:15 -0400
X-MC-Unique: cLJYadqgNPavVRFauLOS6g-1
Received: by mail-ed1-f70.google.com with SMTP id w5-20020a05640234c500b0043be08bb082so1596897edc.9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/cyqjGuqo8Xez9KZB2n6ef57YiIlFUesAYzckfJsYgo=;
        b=YlIjw4RTLUxjKw8w1Ugn3SXsRchJfdp4DtsrtDVlVBb/LG8E4ZQEujOX6CrxLC3eCD
         QTSxgnNcW+E7OGliervjccmz6uLWn/rPO/x4i4TClFQlw/d/YpSLr94dwW5n1gHNFqcB
         dSxGGmC5sGIB0BKfP8lyBvIhRZnwtHmcqQgw8haMVS4MTP7euI8sYTOnycaxCNdD2PwX
         HSat6iEATQ/ybf2szq/1WYhCGqvlQxFA43Fo+A9htUWYmLK8xtvYfeNtCIDWIlKP3I7V
         6zS4Kahq+SHEkh6xaZs0l5sjoaz0uVCJHFuHggnjrmtIMAuE7WQx/cBLmXkd5joqr6au
         PWJQ==
X-Gm-Message-State: AJIora9clQL5EMGoooSR5ZdP0y62DX+CM9V80+KVHibpYclv+wZFEgi1
        vnGtoqQzo7SN1ph4BKZC8623IvFenCs91uJfB5iCesTVvmfINZt65sCXzXi0mHyyC5XYxKSgvhG
        usjF9d5PQQpcqrm8d
X-Received: by 2002:a17:907:2848:b0:72b:5ba5:1db5 with SMTP id el8-20020a170907284800b0072b5ba51db5mr174749ejc.703.1659033733783;
        Thu, 28 Jul 2022 11:42:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vF8qNtAYroVPoKQ2UZq+B8Pj08nF2u1AMY8+URINTGN7OPMC6aKfgY/EB5StPCkopth70xBw==
X-Received: by 2002:a17:907:2848:b0:72b:5ba5:1db5 with SMTP id el8-20020a170907284800b0072b5ba51db5mr174717ejc.703.1659033733286;
        Thu, 28 Jul 2022 11:42:13 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id w10-20020a50fa8a000000b0043bdc47803csm1150947edr.30.2022.07.28.11.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 11:42:12 -0700 (PDT)
Message-ID: <71041a3b-cdb4-dd3a-d94e-c8f77179a31f@redhat.com>
Date:   Thu, 28 Jul 2022 20:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] platform/x86: pmc_atom: Add DMI quirk for Lex 3I380A/CW
 boards
Content-Language: en-US
To:     "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        carlo@endlessm.com, davem@davemloft.net, hkallweit1@gmail.com,
        js@sig21.net, linux-clk@vger.kernel.org,
        linux-wireless@vger.kernel.org, mturquette@baylibre.com,
        netdev@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        sboyd@kernel.org, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        paul.gortmaker@windriver.com, stable@vger.kernel.org
References: <20220727153232.13359-1-matwey@sai.msu.ru>
 <5f0b98a5-1929-a78e-4d44-0bb2aec18b5a@redhat.com>
 <CAJs94EYdNVROqDw=ZpzBTGeNRQzzCN9QQNkicv6LapJGDmb=Dg@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CAJs94EYdNVROqDw=ZpzBTGeNRQzzCN9QQNkicv6LapJGDmb=Dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/28/22 20:39, Matwey V. Kornilov wrote:
> чт, 28 июл. 2022 г. в 21:33, Hans de Goede <hdegoede@redhat.com>:
>>
>> Hi,
>>
>> On 7/27/22 17:32, Matwey V. Kornilov wrote:
>>> Lex 3I380A/CW (Atom E3845) motherboards are equipped with dual Intel I211
>>> based 1Gbps copper ethernet:
>>>
>>>      http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf
>>>
>>> This patch is to fix the issue with broken "LAN2" port. Before the
>>> patch, only one ethernet port is initialized:
>>>
>>>      igb 0000:01:00.0: added PHC on eth0
>>>      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
>>>      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
>>>      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
>>>      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>>>      igb: probe of 0000:02:00.0 failed with error -2
>>>
>>> With this patch, both ethernet ports are available:
>>>
>>>      igb 0000:01:00.0: added PHC on eth0
>>>      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
>>>      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
>>>      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
>>>      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>>>      igb 0000:02:00.0: added PHC on eth1
>>>      igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
>>>      igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
>>>      igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
>>>      igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>>>
>>> The issue was observed at 3I380A board with BIOS version "A4 01/15/2016"
>>> and 3I380CW board with BIOS version "A3 09/29/2014".
>>>
>>> Reference: https://lore.kernel.org/netdev/08c744e6-385b-8fcf-ecdf-1292b5869f94@redhat.com/
>>> Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
>>> Cc: <stable@vger.kernel.org> # v4.19+
>>> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
>>
>>
>> Thank you for the patch.
>>
>> The last week I have received 2 different patches adding
>> a total of 3 new "Lex BayTrail" entries to critclk_systems[]
>> on top of the existing 2.
>>
>> Looking at: https://www.lex.com.tw/products/embedded-ipc-board/
>> we can see that Lex BayTrail makes many embedded boards with
>> multiple ethernet boards and none of their products are battery
>> powered so we don't need to worry (too much) about power consumption
>> when suspended.
>>
>> So instead of adding 3 new entries I've written a patch to
>> simply disable the turning off of the clocks on all
>> systems which have "Lex BayTrail" as their DMI sys_vendor:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/commit/?h=review-hans&id=c9d959fc32a5f9312282817052d8986614f2dc08
>>
>> I've added a Reported-by tag to give you credit for the work
>> you have done on this.
>>
>> I will send this alternative fix to Linus as part of
>> the other pdx86 patches for 5.21.
> 
> Thank you. Will your fix also appear in stable/lts kernels?

Yes it has the same Fixes tag as your patch did, this will
cause it to automatically get cherry-picked into kernels
which have the fixed commit hash.

Regards,

Hans


>>> ---
>>>  drivers/platform/x86/pmc_atom.c | 18 ++++++++++++++++++
>>>  1 file changed, 18 insertions(+)
>>>
>>> diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
>>> index b8b1ed1406de..5dc82667907b 100644
>>> --- a/drivers/platform/x86/pmc_atom.c
>>> +++ b/drivers/platform/x86/pmc_atom.c
>>> @@ -388,6 +388,24 @@ static const struct dmi_system_id critclk_systems[] = {
>>>                       DMI_MATCH(DMI_PRODUCT_NAME, "CEC10 Family"),
>>>               },
>>>       },
>>> +     {
>>> +             /* pmc_plt_clk* - are used for ethernet controllers */
>>> +             .ident = "Lex 3I380A",
>>> +             .callback = dmi_callback,
>>> +             .matches = {
>>> +                     DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
>>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "3I380A"),
>>> +             },
>>> +     },
>>> +     {
>>> +             /* pmc_plt_clk* - are used for ethernet controllers */
>>> +             .ident = "Lex 3I380CW",
>>> +             .callback = dmi_callback,
>>> +             .matches = {
>>> +                     DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
>>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "3I380CW"),
>>> +             },
>>> +     },
>>>       {
>>>               /* pmc_plt_clk0 - 3 are used for the 4 ethernet controllers */
>>>               .ident = "Lex 3I380D",
>>
> 
> 

