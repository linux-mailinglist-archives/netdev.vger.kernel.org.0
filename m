Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3331A666C4C
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjALIUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239528AbjALITj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:19:39 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3F432183;
        Thu, 12 Jan 2023 00:19:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c17so25730703edj.13;
        Thu, 12 Jan 2023 00:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5TOkh1E4yLSe/gL5600jUR0dGFo+fhLS+VjHOxc9+Po=;
        b=d/tx5PRDnPM3bBEE1L4MsTu+lRsR8zzRUIXNRPmjwi8L+KyYE3JNO7Z5RvdiRbhQ5H
         pZaMJMnyQJtYsJ3QIcJQaB/ZBYB6ycWQBrWV//0vhaF9F0JJt5npxDUwtlzuJgH2RuNt
         gkiOtjSnrI9OwdNpeG3i1F+wbPk+tb7MuD3IRb6Ex9j2n8gJQjm5J4tirx6QxzEnDELO
         u7LHVPUpyVsPwQsUGgMz/UYwYK8P8GdxnqLI40pNNwYI7HOynUDYkP6fDjbbvvM1323m
         gzlhLLTNHJB0CSbNg9xYx4F62C7KvLkJcuwsfO41Yemp1TmnQzdwS4/lm4XvF+dvtWcQ
         JabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5TOkh1E4yLSe/gL5600jUR0dGFo+fhLS+VjHOxc9+Po=;
        b=1ySnILTzWkSSFBx8p599r4juFvqHZWheewXMb5FYESC0eHFkrWwLirCUSIaZKUG5OL
         DnPjoaCZHxyWg2do0MOORh0D7JnHP4maZ5CjdW1Rusa/932ciNNqi8L6bFSRGc+I6CBY
         mUJkfyRoHeBLH5PZmZnZRWhL6vqN7cUMg96hddOqI1Wc+iaGLOxbleEJoOsLdaeejKDq
         i8VQCL49gw2vfK3pTqsFA5kLSnP7t/XQQzWRPwAkpLpXZp1EdtIILt93L9iCoaEvdplR
         /wBnDSe+5LAE0Y6As4W430v6U35sHYwd+kb4gVzV55+Ot0oa08kEP5lbWotPpGsIeyb5
         8KUA==
X-Gm-Message-State: AFqh2kp3rfWNZ9gg+J9R1fZxaZpvaj7ZyWRIFMnX39SVabE5BXviC08g
        5F5nMkc26u4yeMpiXRjdWZw=
X-Google-Smtp-Source: AMrXdXsB4carH8qJFFwYx8N+lMc5uLL83jgg0olBfipVxkysZZtYMO/oh9IouOI3JDE7NtBYW329VA==
X-Received: by 2002:a05:6402:220b:b0:475:32d2:74a5 with SMTP id cq11-20020a056402220b00b0047532d274a5mr57610467edb.42.1673511545495;
        Thu, 12 Jan 2023 00:19:05 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7dc1a000000b00499c3ca6a0dsm2849476edu.10.2023.01.12.00.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 00:19:04 -0800 (PST)
Message-ID: <2f76e7d6-1771-a8f5-4bd1-6f7cd0b59173@gmail.com>
Date:   Thu, 12 Jan 2023 10:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v7 00/17] xdp: hints via kfuncs
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, bpf@vger.kernel.org,
        xdp-hints@xdp-project.net, netdev@vger.kernel.org
References: <20230112003230.3779451-1-sdf@google.com>
 <f074b33d-c27a-822d-7bf6-16a5c8d9524d@linux.dev>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <f074b33d-c27a-822d-7bf6-16a5c8d9524d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/01/2023 9:29, Martin KaFai Lau wrote:
> On 1/11/23 4:32 PM, Stanislav Fomichev wrote:
>> Please see the first patch in the series for the overall
>> design and use-cases.
>>
>> See the following email from Toke for the per-packet metadata overhead:
>> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
>>
>> Recent changes:
>>
>> - Bring back parts that were removed during patch reshuffling from "bpf:
>>    Introduce device-bound XDP programs" patch (Martin)
>>
>> - Remove netdev NULL check from __bpf_prog_dev_bound_init (Martin)
>>
>> - Remove netdev NULL check from bpf_dev_bound_resolve_kfunc (Martin)
>>
>> - Move target bound device verification from bpf_tracing_prog_attach into
>>    bpf_check_attach_target (Martin)
>>
>> - Move mlx5e_free_rx_in_progress_descs into txrx.h (Tariq)
>>
>> - mlx5e_fill_xdp_buff -> mlx5e_fill_mxbuf (Tariq)
> 
> Thanks for the patches. The set lgtm.
> 
> The selftest patch 11 and 17 have conflicts with the recent changes in 
> selftests/bpf/xsk.{h,c} and selftests/bpf/Makefile. eg. it no longer 
> needs XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD, so please respin. From a 
> quick look, it should be some minor changes.
> 
> Not sure if Tariq has a chance to look at the mlx5 changes shortly. The 
> set is getting pretty long and the core part is ready with veth and mlx4 
> support. I think it is better to get the ready parts landed first such 
> that other drivers can also start adding support for it. One option is 
> to post the two mlx5 patches as another patchset and they can be 
> reviewed separately.
> 

Hi,
I posted new comments.
I think they can be handled quickly, and still be part of the next respin.

I'm fine with both options though. You can keep the mlx5e patches or 
defer them to a followup series. Whatever works best for you.

Tariq
