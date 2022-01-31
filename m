Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EBC4A4F92
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241087AbiAaTkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiAaTkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:40:45 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9B0C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:40:45 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id j24so10790341qkk.10
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RUiNyOIBBjmijdWjG+pP4fLDPA7sZdvUwUWwld+weuc=;
        b=pysog4ms94wK+bvLBuh4xYIsKmIoN0MlZQvXHv1I4SXSRPW+AARxsHpHjWAMt+Oqt/
         wKhVz4SarxVzg0QegGGxtNg26z/y4i2d2oRcZ/N76aKOSc3lQmfgLZwq965t6B/dZx91
         lHX674rZYiGCtXZAl1mV79xoMrHXceD8YyhYwFAz0W++WHgxajgShaHZUUv0SyEPuPZl
         fszeyGG2dThBQc/Kg5kG3e0E7Y1matuAx8Mz+kg5ZM4lVKXP/HLlg40H0DeYPA6zOlO2
         hfyn9GnNvEoQTbqMqLKgktfVU2OlfBvG6zZV1L1PO4YYbEbdgMsFg4R0K+ROFBA3/tyW
         dStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RUiNyOIBBjmijdWjG+pP4fLDPA7sZdvUwUWwld+weuc=;
        b=Jav528FWXF3d4Eqi3A8ita1KpT3AvCQPmivxfWsbxM6VLNJ8VqtHDcOZ1zcF1TyYwP
         DQgSOC40k5GXeJXxb0uoQ/zTJdZNdl5ix5DMbsAs5LRNFAmEoq61MIl7l8/qsFfjel5x
         qypNohggD7iJZ+NMVgbRI7OQeFQerTMlruelUraFQezUzBU9qF7VyLu57MObntS5HDsM
         gNcO1CwTpg+tiGwj6IJ0XgX/XtNbVr6hKntwpWko5a6ZTtniHqdpiNr31Q10LBf24VzG
         uyc0tL92YOET2G/4EtfRmkJ3aHD7n6lmexHXhlwXRCelVh8aHtounEgLjhN3t2goJlIk
         BQrw==
X-Gm-Message-State: AOAM531K+Y659p3mokOUnpTk6jUtT4dxXVE/pkFfeghkIvX52XyYT5K3
        2k0+42JWk8B71JA5bWuywA/I/Q==
X-Google-Smtp-Source: ABdhPJyemglDmaFMPAWeqzCDEMusz4U0gQRFBizDeEVKcZHj1CIlxQ/XJNMDWuo7C8O/UrV1yPejFQ==
X-Received: by 2002:a05:620a:2890:: with SMTP id j16mr14414411qkp.437.1643658044596;
        Mon, 31 Jan 2022 11:40:44 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id br30sm7566318qkb.67.2022.01.31.11.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 11:40:44 -0800 (PST)
Message-ID: <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
Date:   Mon, 31 Jan 2022 14:40:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
To:     Victor Nogueira <victor@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 08:41, Victor Nogueira wrote:
> On Wed, Jan 26, 2022 at 3:55 AM Baowen Zheng <baowen.zheng@corigine.com> wrote:
>>
>> Add skip_hw and skip_sw flags for user to control whether
>> offload action to hardware.
>>
>> Also we add hw_count to show how many hardwares accept to offload
>> the action.
>>
>> Change man page to describe the usage of skip_sw and skip_hw flag.
>>
>> An example to add and query action as below.
>>
>> $ tc actions add action police rate 1mbit burst 100k index 100 skip_sw
>>
>> $ tc -s -d actions list action police
>> total acts 1
>>      action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
>>      ref 1 bind 0  installed 2 sec used 2 sec
>>      Action statistics:
>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>      backlog 0b 0p requeues 0
>>      skip_sw in_hw in_hw_count 1
>>      used_hw_stats delayed
>>
>> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> I applied this version, tested it and can confirm the breakage in tdc is gone.
> Tested-by: Victor Nogueira <victor@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
