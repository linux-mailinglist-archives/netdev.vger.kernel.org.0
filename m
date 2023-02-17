Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE2169B3FF
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBQUfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBQUfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:35:00 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2723D498BF;
        Fri, 17 Feb 2023 12:35:00 -0800 (PST)
Message-ID: <d32b1c26-c401-1d07-bd8c-b71989b81ba6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676666098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yf/456e1/XCeVkDu4jJXfNbG82toNXFV1m8Rtl6WHhI=;
        b=ViOjym3iTupoWBvGUhACuJjNTMljvOOmC236GxP+gt3VSfvq81PA3D312AbvAMAoLQKLX2
        mR9VAuvRB4qEzyWaWBPcDL6dlgVVIBFCrgSQurABO63zJ5MCc1smNDLMsiRdiV2ImRFALU
        yQVQd+kDV/zjLFVWMcdVJ2k6g7t6+lg=
Date:   Fri, 17 Feb 2023 12:34:56 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for
 bpf_fib_lookup
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        netdev@vger.kernel.org, kernel-team@meta.com
References: <20230217181224.2320704-1-martin.lau@linux.dev>
 <1c275189-e693-18eb-444d-b125193af615@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <1c275189-e693-18eb-444d-b125193af615@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 12:34 PM, Daniel Borkmann wrote:
> On 2/17/23 7:12 PM, Martin KaFai Lau wrote:
> [...]
>>   include/uapi/linux/bpf.h       |  1 +
>>   net/core/filter.c              | 39 ++++++++++++++++++++++------------
>>   tools/include/uapi/linux/bpf.h |  1 +
>>   3 files changed, 28 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 1503f61336b6..6c1956e36c97 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -6750,6 +6750,7 @@ struct bpf_raw_tracepoint_args {
>>   enum {
>>       BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
>>       BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
>> +    BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
> 
> Sry, just noticed this now, but this would also need a uapi helper comment
> to describe the new BPF_FIB_LOOKUP_SKIP_NEIGH flag.

ah. right. will respin shortly.

