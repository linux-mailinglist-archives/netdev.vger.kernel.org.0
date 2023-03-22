Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4646C5004
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCVQGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCVQGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEF76545F
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679501118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R19EYQl/3a1OZn/7iEThbID+2P3CKP86RKDBkJY/6ig=;
        b=TijCuWaJuxlVE86GJrq6KsDri3M7suttw1jpZc9eriKUlgqov4mhQM6tiJo8pguNjFemzs
        OJfG502x7H9hvKqpazcehQEhzi4kskRsXPBuyT1uNjQhNMV5b84NmcAhuuJsFkkUkyf0S8
        +twBabhU/5LaaJlJkMkEyOgCG16RYQo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-LBhG6LMFOcqB20lCQjeVcg-1; Wed, 22 Mar 2023 12:05:15 -0400
X-MC-Unique: LBhG6LMFOcqB20lCQjeVcg-1
Received: by mail-ed1-f70.google.com with SMTP id j21-20020a508a95000000b004fd82403c91so27552497edj.3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679501113;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R19EYQl/3a1OZn/7iEThbID+2P3CKP86RKDBkJY/6ig=;
        b=srfRyOaNWdxeOOwhMgh3F9SOahQCAFG6jZ1bWOUXAgwk4b1L23Tp04ge+/VosbjnBK
         kFfUSRIYPECXRkKIUh83XgfGN+oMW0/wr7npqhZm8QD3iH/55mF6ZZSiEqD5cb923jXG
         378yrM4tW7iFDPhA25DndFQubo0YkK1nOnwSsz76oEwwvBvM4wx/b8JKurqRNaBbYlDu
         IGWT5mY9tNoWAtL0Q8o//ubo8MAQ34ScOR0r/ZDBfVIDh57DE79CzC2Yws77qUaCehlM
         SnFigLE9JSydRsDJHAiNJwC1V4WGjpTRvZFL+tq4r6z7uY5+4QYH3jkTDzZ7ChHanjc0
         OopA==
X-Gm-Message-State: AO0yUKVx0ZbO5mqAenxm6gXn8vbSodrTe9Bo6bNCr/SJ69iKLe51vZdZ
        lPFr+sw2ZxGor+6YyWLx7u5gTzC9GsPiBkEJAjfAKk/vcVM2Tggxw/lDUvGhQgiMdU3kpt9XFoE
        Di/TbgB0z34hOHU2D
X-Received: by 2002:a17:907:d9f:b0:930:3916:df1d with SMTP id go31-20020a1709070d9f00b009303916df1dmr9416077ejc.0.1679501113607;
        Wed, 22 Mar 2023 09:05:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set+eEG+9Nhjdu7pvohVMislIOYYj5JHPc8wzmjUCjfXB2jEEvGgjHeH7cZ4uUEeLZG8BmQFvpw==
X-Received: by 2002:a17:907:d9f:b0:930:3916:df1d with SMTP id go31-20020a1709070d9f00b009303916df1dmr9416034ejc.0.1679501113325;
        Wed, 22 Mar 2023 09:05:13 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906309600b0092f289b6fdbsm7373117ejv.181.2023.03.22.09.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 09:05:12 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com>
Date:   Wed, 22 Mar 2023 17:05:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul>
 <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
In-Reply-To: <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/03/2023 19.47, Stanislav Fomichev wrote:
> On Tue, Mar 21, 2023 at 6:47 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>>
>> When driver developers add XDP-hints kfuncs for RX hash it is
>> practical to print the return code in bpf_printk trace pipe log.
>>
>> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
>> as this makes it easier to spot poor quality hashes.
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
>>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> index 40c17adbf483..ce07010e4d48 100644
>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
>>                  meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
>>          }
>>
>> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
>> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
>> -       else
>> +       ret = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
>> +       if (ret >= 0) {
>> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash);
>> +       } else {
>> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>>                  meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
>> +       }
>>
>>          return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>>   }
>> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>> index 400bfe19abfe..f3ec07ccdc95 100644
>> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
>> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>> @@ -3,6 +3,9 @@
>>   /* Reference program for verifying XDP metadata on real HW. Functional test
>>    * only, doesn't test the performance.
>>    *
>> + * BPF-prog bpf_printk info outout can be access via
>> + * /sys/kernel/debug/tracing/trace_pipe
> 
> s/outout/output/
> 

Fixed in V3

> But let's maybe drop it? If you want to make it more usable, let's
> have a separate patch to enable tracing and periodically dump it to
> the console instead (as previously discussed).

Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless of
setting in
/sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable

We likely need a followup patch that adds a BPF config switch that can
disable bpf_printk calls, because this adds overhead and thus affects
the timestamps.

> With this addressed:
> Acked-by: Stanislav Fomichev <sdf@google.com>
> 
>> + *
>>    * RX:
>>    * - UDP 9091 packets are diverted into AF_XDP
>>    * - Metadata verified:
>> @@ -156,7 +159,7 @@ static void verify_xdp_metadata(void *data, clockid_t clock_id)
>>
>>          meta = data - sizeof(*meta);
>>
>> -       printf("rx_hash: %u\n", meta->rx_hash);
>> +       printf("rx_hash: 0x%08X\n", meta->rx_hash);
>>          printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
>>                 (double)meta->rx_timestamp / NANOSEC_PER_SEC);
>>          if (meta->rx_timestamp) {
>>
>>
> 

