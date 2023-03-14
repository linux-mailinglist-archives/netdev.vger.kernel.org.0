Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E56BA168
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 22:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCNVYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 17:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCNVYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 17:24:32 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C425951C8A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 14:24:26 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-17997ccf711so5271542fac.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 14:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678829066;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7dYvtD8d6WHnALHflQ2oISvxU+0amMGU/t7X/TGB00c=;
        b=4piP9+xU6KYr0HY2ODryfJMGMQ/IfUJP1mPvQkJ6HMd1ojiujNj5J1AhS3H+KRMg3w
         h6HnEBdUaj0NGDARE8LjHvuEQHuzZGAfZzA2ilKGHUKWIW0GmBl67Gr/ePyUtRxip/Yw
         vLBW0vnTtD/Tvr1K8duYm7iqDVImSrOmli2VmxHNAc//O5QGtYCSbTifg+2NZ8bWnrlS
         xPk2YzA1sJmmUzL2kyRcM3eYW9hyVbWK0YojendeJH2rr7wrE1Cy2T1ojn+N8W9awOW0
         cKAjbuXYtpSpua4xmVvcElt5Xmbb6mXef0DPKetsAMEo5FwkZWeyFsM2Ks/0FybhM1HZ
         qtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678829066;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7dYvtD8d6WHnALHflQ2oISvxU+0amMGU/t7X/TGB00c=;
        b=4ZdyASlyDNnvz1Qzjd6YHFATzN7CoUPRsveXpCcO+7XLTxCm2rKN79D/aHv7hVmLha
         ZoHYArYmOAUJv6xggZuwA3O6c1fPqhC5nAoZoFTUIVFSuUf3mScrR7EmxX/qwYUN2IwW
         55ItmS1fsiWOerToAy5v+0YLx9SbY6mDxRXNB4LS4yy45GvgeTwhlsmhhIdb3JknfdIU
         XT0TzB3IlG7uHva/ZpYhBKQavP3oXxNS0OY7n5T1I/jjDCfEmPlfdIbYJHwScyTiWm5Z
         qsfYq4EdgMy7wBnYp40pZ+LyWDGa3vEb2krjEZ+ZED3lMc3P6s6Avr3a6wQ9g1c/RbfR
         dBMQ==
X-Gm-Message-State: AO0yUKWcckZqmkfQGMx8pbrUP8Qqd7KJRR8m96ZT50H0KeB6JKjQDCDf
        AApk6rFAnQjPrWbIFHkVzsSOkPN/xAorTduZ9t0=
X-Google-Smtp-Source: AK7set8qsuJrbmwqWM90kkdJN7DrSPt1jYt9tXgISizRYnL1xw3TL4imQIhFZ9e1WN4Qelvf9sc3Tg==
X-Received: by 2002:a05:6870:e387:b0:176:3704:1a13 with SMTP id x7-20020a056870e38700b0017637041a13mr23082072oad.10.1678829064469;
        Tue, 14 Mar 2023 14:24:24 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:95f9:b8d9:4b9:5297? ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id u36-20020a05687004e400b00172899830dasm1583588oam.4.2023.03.14.14.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 14:24:24 -0700 (PDT)
Message-ID: <cbe9959a-7a8c-cab4-b7d0-6babd5a8234c@mojatatu.com>
Date:   Tue, 14 Mar 2023 18:24:19 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 0/4] net/sched: act_pedit: minor improvements
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20230314202448.603841-1-pctammela@mojatatu.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230314202448.603841-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 17:24, Pedro Tammela wrote:
> This series aims to improve the code and usability of act_pedit for
> netlink users.
> 
> Patch 1 improves error reporting for extended keys parsing with extack.
> While at it, do a minor refactor on error handling.
> 
> Patch 2 checks the static offsets a priori on create/update. Currently,
> this is done at the datapath for both static and runtime offsets.
> 
> Patch 3 removes a check from the datapath which is redundant since the
> netlink parsing validates the key types.
> 
> Patch 4 changes the 'pr_info()' calls in the datapath to rate limited
> versions.
> 
> v1->v2: Added patch 3 to the series as discussed with Simon.
> 
> Pedro Tammela (4):
>    net/sched: act_pedit: use extack in 'ex' parsing errors
>    net/sched: act_pedit: check static offsets a priori
>    net/sched: act_pedit: remove extra check for key type
>    net/sched: act_pedit: rate limit datapath messages
> 
>   net/sched/act_pedit.c | 77 +++++++++++++++++++------------------------
>   1 file changed, 33 insertions(+), 44 deletions(-)
> 

I forgot to add this to the cover letter:

1..70
ok 1 319a - Add pedit action that mangles IP TTL
ok 2 7e67 - Replace pedit action with invalid goto chain
ok 3 377e - Add pedit action with RAW_OP offset u32
ok 4 a0ca - Add pedit action with RAW_OP offset u32 (INVALID)
ok 5 dd8a - Add pedit action with RAW_OP offset u16 u16
ok 6 53db - Add pedit action with RAW_OP offset u16 (INVALID)
ok 7 5c7e - Add pedit action with RAW_OP offset u8 add value
ok 8 2893 - Add pedit action with RAW_OP offset u8 quad
ok 9 3a07 - Add pedit action with RAW_OP offset u8-u16-u8
ok 10 ab0f - Add pedit action with RAW_OP offset u16-u8-u8
ok 11 9d12 - Add pedit action with RAW_OP offset u32 set u16 clear u8 invert
ok 12 ebfa - Add pedit action with RAW_OP offset overflow u32 (INVALID)
ok 13 f512 - Add pedit action with RAW_OP offset u16 at offmask shift set
ok 14 c2cb - Add pedit action with RAW_OP offset u32 retain value
ok 15 1762 - Add pedit action with RAW_OP offset u8 clear value
ok 16 bcee - Add pedit action with RAW_OP offset u8 retain value
ok 17 e89f - Add pedit action with RAW_OP offset u16 retain value
ok 18 c282 - Add pedit action with RAW_OP offset u32 clear value
ok 19 c422 - Add pedit action with RAW_OP offset u16 invert value
ok 20 d3d3 - Add pedit action with RAW_OP offset u32 invert value
ok 21 57e5 - Add pedit action with RAW_OP offset u8 preserve value
ok 22 99e0 - Add pedit action with RAW_OP offset u16 preserve value
ok 23 1892 - Add pedit action with RAW_OP offset u32 preserve value
ok 24 4b60 - Add pedit action with RAW_OP negative offset u16/u32 set value
ok 25 a5a7 - Add pedit action with LAYERED_OP eth set src
ok 26 86d4 - Add pedit action with LAYERED_OP eth set src & dst
ok 27 f8a9 - Add pedit action with LAYERED_OP eth set dst
ok 28 c715 - Add pedit action with LAYERED_OP eth set src (INVALID)
ok 29 8131 - Add pedit action with LAYERED_OP eth set dst (INVALID)
ok 30 ba22 - Add pedit action with LAYERED_OP eth type set/clear sequence
ok 31 dec4 - Add pedit action with LAYERED_OP eth set type (INVALID)
ok 32 ab06 - Add pedit action with LAYERED_OP eth add type
ok 33 918d - Add pedit action with LAYERED_OP eth invert src
ok 34 a8d4 - Add pedit action with LAYERED_OP eth invert dst
ok 35 ee13 - Add pedit action with LAYERED_OP eth invert type
ok 36 7588 - Add pedit action with LAYERED_OP ip set src
ok 37 0fa7 - Add pedit action with LAYERED_OP ip set dst
ok 38 5810 - Add pedit action with LAYERED_OP ip set src & dst
ok 39 1092 - Add pedit action with LAYERED_OP ip set ihl & dsfield
ok 40 02d8 - Add pedit action with LAYERED_OP ip set ttl & protocol
ok 41 3e2d - Add pedit action with LAYERED_OP ip set ttl (INVALID)
ok 42 31ae - Add pedit action with LAYERED_OP ip ttl clear/set
ok 43 486f - Add pedit action with LAYERED_OP ip set duplicate fields
ok 44 e790 - Add pedit action with LAYERED_OP ip set ce, df, mf, 
firstfrag, nofrag fields
ok 45 cc8a - Add pedit action with LAYERED_OP ip set tos
ok 46 7a17 - Add pedit action with LAYERED_OP ip set precedence
ok 47 c3b6 - Add pedit action with LAYERED_OP ip add tos
ok 48 43d3 - Add pedit action with LAYERED_OP ip add precedence
ok 49 438e - Add pedit action with LAYERED_OP ip clear tos
ok 50 6b1b - Add pedit action with LAYERED_OP ip clear precedence
ok 51 824a - Add pedit action with LAYERED_OP ip invert tos
ok 52 106f - Add pedit action with LAYERED_OP ip invert precedence
ok 53 6829 - Add pedit action with LAYERED_OP beyond ip set dport & sport
ok 54 afd8 - Add pedit action with LAYERED_OP beyond ip set icmp_type & 
icmp_code
ok 55 3143 - Add pedit action with LAYERED_OP beyond ip set dport (INVALID)
ok 56 815c - Add pedit action with LAYERED_OP ip6 set src
ok 57 4dae - Add pedit action with LAYERED_OP ip6 set dst
ok 58 fc1f - Add pedit action with LAYERED_OP ip6 set src & dst
ok 59 6d34 - Add pedit action with LAYERED_OP ip6 dst retain value (INVALID)
ok 60 94bb - Add pedit action with LAYERED_OP ip6 traffic_class
ok 61 6f5e - Add pedit action with LAYERED_OP ip6 flow_lbl
ok 62 6795 - Add pedit action with LAYERED_OP ip6 set payload_len, 
nexthdr, hoplimit
ok 63 1442 - Add pedit action with LAYERED_OP tcp set dport & sport
ok 64 b7ac - Add pedit action with LAYERED_OP tcp sport set (INVALID)
ok 65 cfcc - Add pedit action with LAYERED_OP tcp flags set
ok 66 3bc4 - Add pedit action with LAYERED_OP tcp set dport, sport & 
flags fields
ok 67 f1c8 - Add pedit action with LAYERED_OP udp set dport & sport
ok 68 d784 - Add pedit action with mixed RAW/LAYERED_OP #1
ok 69 70ca - Add pedit action with mixed RAW/LAYERED_OP #2
ok 70 abdc - Reference pedit action object in filter

