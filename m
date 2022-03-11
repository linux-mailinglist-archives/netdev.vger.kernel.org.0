Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223D74D6751
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350615AbiCKRPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350605AbiCKRO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:14:59 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BF31965F5
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:13:56 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id q4so7457796qki.11
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0SX9Ku7U8TYzy0UD+6RCalxEpEqPgEDglxqG8LvTkqo=;
        b=JboVs9ePJMkADHvjbVlWwjXXKgkPkgc10tmZh+pwrwvyDktrRXRcD3cGmclLHdWzyB
         cwtmoZnOoCv4pl53lVxRv2CE4QP6ZmB1z+sRmt1Q+7pBD2d0PWEtorj2VNsT6EulFlwm
         4NJHD+R4UywxKqgyZ9yrJg6hHPOeVaDPAVr8DDK7geYV9ymlph6wBemlX/J2XjDf1+En
         e2Q8a+fZ7unGg0ZDuetK82X9/YHqD4jT99Hg0c0NG+67j0jpg0CPj0RLnLiN+69zmXsD
         oHQsrC1AXSy+oA7XWUUxuh7eZTpPHtY8w7y+jH4fG43zGJS2IW0lfg8DajlwIE1+R6vK
         W/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0SX9Ku7U8TYzy0UD+6RCalxEpEqPgEDglxqG8LvTkqo=;
        b=vSJaEJoGdnup7W/rmHHrwLg9eLH7Gwa7Gr6YZuJvEpT4dDs26q5HBfoaa0mgadqnhd
         sZpA8f3o0gP44NC6YckqnVePNSIn8z/FuuoPgZdAdjpeXKRwanB/wvci9DVgNBd0nnY7
         oWjXP154cIz9fs4GpG9MNfMPnb7RDMMiWvGh/+Cd/z17xI2a2fgWkRHfi5oGMFhZmKNP
         Cr6tZQ12HoTnpZAD8LpqblTMNcQbLHX0g4mJlwSHqfWwKdP8RapM/Gbb31K0zUk6f7fp
         bUnraXvTwgasgXSpUI8INzRy5DngRiS5hw4qluJql9wuvt+v5MtZ3qA1T0ZMu18PtmrC
         zKPA==
X-Gm-Message-State: AOAM531QanbxnoNs3kEElDEPAXrD++o3U2/KG767V23AO0hNL/hM4OPk
        KF5crPcfZ6Pai4lwh+HGSrnzCVAIOmg=
X-Google-Smtp-Source: ABdhPJy1+63dc6PbMms7Xaz0V4jpw0vUiCSsczd7ol5lbB/yM0WtiAwXRGtkhSVA9DNlwYqCQ2B7iQ==
X-Received: by 2002:a37:65c5:0:b0:67b:3232:8cc8 with SMTP id z188-20020a3765c5000000b0067b32328cc8mr6825307qkb.170.1647018835407;
        Fri, 11 Mar 2022 09:13:55 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id y17-20020a05622a121100b002e0702457b2sm5872111qtx.20.2022.03.11.09.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 09:13:54 -0800 (PST)
Message-ID: <2151fe9e8bdf18ae02bd196f69f1b64af0eb4a55.camel@gmail.com>
Subject: Re: [PATCH v4 net-next 00/14] tcp: BIG TCP implementation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Mar 2022 09:13:53 -0800
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This series implements BIG TCP as presented in netdev 0x15:
> 
> https://netdevconf.info/0x15/session.html?BIG-TCP
> 
> Jonathan Corbet made a nice summary: https://lwn.net/Articles/884104/
> 
> Standard TSO/GRO packet limit is 64KB
> 
> With BIG TCP, we allow bigger TSO/GRO packet sizes for IPv6 traffic.
> 
> Note that this feature is by default not enabled, because it might
> break some eBPF programs assuming TCP header immediately follows IPv6 header.
> 
> While tcpdump recognizes the HBH/Jumbo header, standard pcap filters
> are unable to skip over IPv6 extension headers.
> 
> Reducing number of packets traversing networking stack usually improves
> performance, as shown on this experiment using a 100Gbit NIC, and 4K MTU.
> 
> 'Standard' performance with current (74KB) limits.
> for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 77           138          183          8542.19    
> 79           143          178          8215.28    
> 70           117          164          9543.39    
> 80           144          176          8183.71    
> 78           126          155          9108.47    
> 80           146          184          8115.19    
> 71           113          165          9510.96    
> 74           113          164          9518.74    
> 79           137          178          8575.04    
> 73           111          171          9561.73    
> 
> Now enable BIG TCP on both hosts.
> 
> ip link set dev eth0 gro_ipv6_max_size 185000 gso_ipv6_max_size 185000
> for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 57           83           117          13871.38   
> 64           118          155          11432.94   
> 65           116          148          11507.62   
> 60           105          136          12645.15   
> 60           103          135          12760.34   
> 60           102          134          12832.64   
> 62           109          132          10877.68   
> 58           82           115          14052.93   
> 57           83           124          14212.58   
> 57           82           119          14196.01   
> 
> We see an increase of transactions per second, and lower latencies as well.
> 
> v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y in mlx5 (Jakub)
> 
> v3: Fixed a typo in RFC number (Alexander)
>     Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.
> 
> v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
>     Addressed feedback, for Alexander and nvidia folks.

One concern with this patch set is the addition of all the max_size
netdev attributes for tsov6, gsov6, and grov6. For the gsov6 and grov6
maxes I really think these make more sense as sysctl values since it
feels more like a protocol change rather than a netdev specific one.

If I recall correctly the addition of gso_max_size and gso_max_segs
were added as a workaround for NICs that couldn't handle offloading
frames larger than a certain size. This feels like increasing the scope
of the workaround rather than adding a new feature.

I didn't see the patch that went by for gro_max_size but I am not a fan
of the way it was added since it would make more sense as a sysctl
which controlled the stack instead of something that is device specific
since as far as the device is concerned it received MTU size frames,
and GRO happens above the device. I suppose it makes things symmetric
with gso_max_size, but at the same time it isn't really a device
specific attribute since the work happens in the stack above the
device.

Do we need to add the IPv6 specific version of the tso_ipv6_max_size?
Could we instead just allow setting the gso_max_size value larger than
64K? Then it would just be a matter of having a protocol specific max
size check to pull us back down to GSO_MAX_SIZE in the case of non-ipv6
frames.






