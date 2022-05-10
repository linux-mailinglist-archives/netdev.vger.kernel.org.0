Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48627522501
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiEJTtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiEJTtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:49:06 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5FF26865A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:49:05 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so63759pjq.2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/cEGBrcH73c0iVSDmBJMqSNGGQjyeAH5PCj+VxLlUrc=;
        b=JHILI1TMXT0t7n39awJqa7TI+Qj1wBySTqkY7RYt0pr45U/d2F1GCHTFRUHzuP28k1
         SDQb6+VDKJDSLgosJ2tK7DQ+EwydS0SEhXa209LtREQ0ewONNMdSZWsWLz1IezgOHBIy
         uFFMeA9KDc9tMlrFFHlzwpGzYrDUTxdXk0hJrffi/a1zLuFycEs+X5JNreOQZ+gcQZVQ
         OCzNLx5DAw4aIcC218mmQe5fUMT06fdY5ud+nOIRUFkzgjOwyaOuC73NTHH7WO/B0f1i
         NypDe0LRFK1yyeQW069Ap0U4JngHaxtnhU4LW/3Jl8ON7c0U1X+xqcyI31/4BLr487Er
         8uCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/cEGBrcH73c0iVSDmBJMqSNGGQjyeAH5PCj+VxLlUrc=;
        b=l3rDwYZ1i9h9WQyps3TlPgg+nHCs+YO/BJ3soLiWYPXM1MjpY13XtuAIuWZoDVRbt8
         0tj3vSeOv4aUTNDgz/tOK2QWNsbCMr/ZYMHxmHE7paz2qZX93POh9Zag8djgNrSNCJ6Z
         /IDFIgNPKH4xaGaUyMPBnLz1th1JeUeXmi5ga9cdJYpy0zE4QWqRquIeqprHkR5CO5yu
         mnKyxNHd+BibBwJAmQnY0h/4X5MHw+d0vDHburNPjr0aE/WtxQar89JXVTtZRdp6QlGa
         Q+1PtXvcUwgj+FPwtZ94TQZdb+yW66JFioc03Xpht4ZNpcOYFEkJR19clb5n+ZA05VxQ
         Sktw==
X-Gm-Message-State: AOAM533K7aKt5p64Nd3q3okTtmkbpaIdcL0SIwdfvUfEzxaWdDv4EVRO
        /6lJbdesAT8dMQve7cpBFhw=
X-Google-Smtp-Source: ABdhPJwRB2j9qbcwSXEUmTluLCBJIi4QDm5Z5dDKE+EWWIb/itD/WHkJ5Gx4m8jmxw4DaWpXvRS9Cw==
X-Received: by 2002:a17:902:6b42:b0:15d:3603:6873 with SMTP id g2-20020a1709026b4200b0015d36036873mr22193434plt.30.1652212145305;
        Tue, 10 May 2022 12:49:05 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.30])
        by smtp.googlemail.com with ESMTPSA id dt4-20020a17090afa4400b001cd4989fedfsm2230391pjb.43.2022.05.10.12.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 12:49:04 -0700 (PDT)
Message-ID: <d7d32ee0ce420233d641fc9fb7cef27b0ee271c3.camel@gmail.com>
Subject: Re: [PATCH v6 net-next 00/13] tcp: BIG TCP implementation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 May 2022 12:49:02 -0700
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-09 at 20:32 -0700, Eric Dumazet wrote:
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
> ip link set dev eth0 gro_max_size 185000 gso_max_size 185000
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
> v6: fix a compilation error for CONFIG_IPV6=n in
>     "net: allow gso_max_size to exceed 65536", reported by kernel bots.
> 
> v5: Replaced two patches (that were adding new attributes) with patches
>     from Alexander Duyck. Idea is to reuse existing gso_max_size/gro_max_size
> 
> v4: Rebased on top of Jakub series (Merge branch 'tso-gso-limit-split')
>     max_tso_size is now family independent.
> 
> v3: Fixed a typo in RFC number (Alexander)
>     Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.
> 
> v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
>     Addressed feedback, for Alexander and nvidia folks.
> 
> 
> Alexander Duyck (2):
>   net: allow gso_max_size to exceed 65536
>   net: allow gro_max_size to exceed 65536
> 
> Coco Li (2):
>   ipv6: Add hop-by-hop header to jumbograms in ip6_output
>   mlx5: support BIG TCP packets
> 
> Eric Dumazet (9):
>   net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
>   net: limit GSO_MAX_SIZE to 524280 bytes
>   tcp_cubic: make hystart_ack_delay() aware of BIG TCP
>   ipv6: add struct hop_jumbo_hdr definition
>   ipv6/gso: remove temporary HBH/jumbo header
>   ipv6/gro: insert temporary HBH/jumbo header
>   net: loopback: enable BIG TCP packets
>   veth: enable BIG TCP packets
>   mlx4: support BIG TCP packets

Looked over the changes to my patches and they all look good (sorry for
not catching that myself). This approach addresses all the concerns I
had.

For the series:
Acked-by: Alexander Duyck <alexanderduyck@fb.com>

