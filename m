Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57A84CE39D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiCEIiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCEIiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:38:22 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC3C344CD;
        Sat,  5 Mar 2022 00:37:31 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t5so9577283pfg.4;
        Sat, 05 Mar 2022 00:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Cl6q1jY9qj6kVLGuYkl47//3OSvehz/UM9+346VGHOI=;
        b=gHiXTuBxoDgcvsGN36B64kcON07eo2OGM22BLH5mgGZr4zW5VTUpqxoWLYG59cQEr4
         GMgD4uHyLTBUkdpqGlzCOLEIlvMKK4M60WGZ9KZwA7Wt+5eniZv7dG6m2mslKdDj1ytE
         vxCha/kg8+3S2weVm17GcCaBTL53GYWuYFH2ujS8uAK6AiUk4/+UfUpqBNS4wWoWzFNs
         szm+9hhmfWDzKKZm/qI2ARFb+tAclSayDJng2e3e78pPyJ/oVDR03czPPWoXdsL8tXuE
         cWP8xvbpHCLEqWagBQbBFL0lIja7OdqjpJ0oKG2+OOEfGZm9mdmkxBd+9Jqp/cJmvrS8
         ivRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Cl6q1jY9qj6kVLGuYkl47//3OSvehz/UM9+346VGHOI=;
        b=rFGSEc7zqPWh6jToHkoouqNJnEXM5DYyBMqsAQ/CuVjl+OtMG5+DuPIbmiP0TEL7i+
         EvRLVE7N4Fpl+t4ZtQTCcP6Ss7xiPGRt/oZvyZ8RRfV1nw3+Evl2dyOqSLt4N3VdMgMr
         dr7htU15SEeDtKGwNDTIithhON8THjEHQERJ/7Y458UGVTyLRUWxo4/XAASeYGHI0PLU
         rWtot0IFe9yHE+LZktUwGT++jzM+BQXRtw4bIqXpDyB7dwZlRe3ytKsLvG0GY0E8keqi
         bWlJtnPp7Fqa9c/UdNr9Zo6/6C/soYRn+hWtGJS1BCYwFsk5x288XT4CwvfjHIMqmXTe
         dC2w==
X-Gm-Message-State: AOAM5305TrTs6XQshA8MoDybDb07sCdOC4Ci2SOOqXm7AgETu24GVOtw
        cgzynisqD/bB467qRQWUTjCm7y9s/o08Vg==
X-Google-Smtp-Source: ABdhPJzCZbkM3yRTxwDhaNExVBNZ7PUdxPxsbyuYnTHyGRpeMkgUeHLsNTp/QQ46kX7ILi6hTel/xw==
X-Received: by 2002:a05:6a00:1a8f:b0:4e1:cde3:7bf7 with SMTP id e15-20020a056a001a8f00b004e1cde37bf7mr2927981pfv.52.1646469451094;
        Sat, 05 Mar 2022 00:37:31 -0800 (PST)
Received: from [10.107.0.6] ([64.64.123.82])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm8965655pfl.140.2022.03.05.00.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:37:30 -0800 (PST)
Subject: Re: [PATCH] net: qlogic: check the return value of
 dma_alloc_coherent() in qed_vf_hw_prepare()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220303033450.2108-1-baijiaju1990@gmail.com>
 <20220303211953.7d937dfc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <b9805786-d322-23b6-6a19-0e331b8957fe@gmail.com>
Date:   Sat, 5 Mar 2022 16:37:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20220303211953.7d937dfc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/4 13:19, Jakub Kicinski wrote:
> On Wed,  2 Mar 2022 19:34:50 -0800 Jia-Ju Bai wrote:
>> --- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
>> +++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
>> @@ -513,6 +513,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
>>   						    p_iov->bulletin.size,
>>   						    &p_iov->bulletin.phys,
>>   						    GFP_KERNEL);
>> +	if (!p_iov->bulletin.p_virt)
>> +		goto free_vf2pf_request;
> leaking the reply buffer

Hi Jakub,

Thanks for pointing out this problem.
I will send a V2 patch.


Best wishes,
Jia-Ju Bai
