Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A24460AB1
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 23:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359474AbhK1W3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 17:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359430AbhK1W1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 17:27:52 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4DAC061763;
        Sun, 28 Nov 2021 14:23:53 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id bj13so30910962oib.4;
        Sun, 28 Nov 2021 14:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M5rtFSgsWKzafi8Cs4A/snez2F9siOW7EyMGKMlf5GI=;
        b=hq9071HUdLZ2TaOnDWMrUmkEjmGHPPdTYkA47Un8OgZrB6yRF/DDW8F2TRjD1Te19u
         iwz7IofjNHmeoxPcYl7UCdDln5AfF+oBejaZnHIFQwTg+gm1U9+1Rb0P0GWb/NR69e4e
         HeUhV/KFKLd9XUXKFJVmgeC4J0r5TQnv1NJ+2Bx+oe5ZCTpFo0EJ7t29VyUgLvsKBoqI
         /u1OO+yD8J5oRDDhs/6UAFhdL1gR7NeF9utMME7xbGZnk7Dwf0OIocm2klvolQJMDSs2
         1QegL3fy+FKj/LJwCCf6vQ7+wg9TQOQVwwqfaZxdwTR7sSWQu8DzfoZ1VoZlEQJGdoFg
         yLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M5rtFSgsWKzafi8Cs4A/snez2F9siOW7EyMGKMlf5GI=;
        b=BHMNg+OBT2fBeuD/ovlMpqWsxOQNR4hFGdeZh9pM7EFgXY69dipXA016diHw1dG2x5
         lOyhSiJaDqPI6/DOrzN06rad97jRizdNRGK7ndG4wZ/3JDcLRHADL72LtdYVV8sJYSBf
         Wa4865mBuqDV9KqEsCVOuLZI891ulPOzJRyzUwlGyWORtLFuQtfi8oMd93cDQn+ouIan
         pcivrbf2Q/uJojQH1MLX6oWCBqMVrq0OC73RepFWX9+WRHfToKP6OCKINPqFsUGu66Vq
         nizVSYldwQFNQMVQhqPfnxQJZIEuRs6caihngz+HKf+BUqGOpM3pREZqsEhJ4+Teu0BR
         +XVQ==
X-Gm-Message-State: AOAM531EBglsM8L1fEWMGLYYoVAFUPL9817Q3pfJePARhrsKMtQUIeQG
        JYtmvWQp+7AaUN1MVbPs6PE=
X-Google-Smtp-Source: ABdhPJzDpxaefKBU6oCHFFQgwoEO9P28FUz/LwlZRp8iIlHj4Qp+gFDBjfKDrMFg6OvgX+VjCyPvHw==
X-Received: by 2002:a54:4614:: with SMTP id p20mr38321110oip.39.1638138232614;
        Sun, 28 Nov 2021 14:23:52 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l9sm2021123oom.4.2021.11.28.14.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 14:23:52 -0800 (PST)
Message-ID: <2b9c3c1f-159f-f7c0-d4cb-1159e17e0dd4@gmail.com>
Date:   Sun, 28 Nov 2021 15:23:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP
 stats
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/21 9:39 AM, Alexander Lobakin wrote:
> This is an almost complete rework of [0].
> 
> This series introduces generic XDP statistics infra based on rtnl
> xstats (Ethtool standard stats previously), and wires up the drivers
> which collect appropriate statistics to this new interface. Finally,
> it introduces XDP/XSK statistics to all XDP-capable Intel drivers.
> 
> Those counters are:
> * packets: number of frames passed to bpf_prog_run_xdp().
> * bytes: number of bytes went through bpf_prog_run_xdp().
> * errors: number of general XDP errors, if driver has one unified
>   counter.
> * aborted: number of XDP_ABORTED returns.
> * drop: number of XDP_DROP returns.
> * invalid: number of returns of unallowed values (i.e. not XDP_*).
> * pass: number of XDP_PASS returns.
> * redirect: number of successfully performed XDP_REDIRECT requests.
> * redirect_errors: number of failed XDP_REDIRECT requests.
> * tx: number of successfully performed XDP_TX requests.
> * tx_errors: number of failed XDP_TX requests.
> * xmit_packets: number of successfully transmitted XDP/XSK frames.
> * xmit_bytes: number of successfully transmitted XDP/XSK frames.
> * xmit_errors: of XDP/XSK frames failed to transmit.
> * xmit_full: number of XDP/XSK queue being full at the moment of
>   transmission.
> 
> To provide them, developers need to implement .ndo_get_xdp_stats()
> and, if they want to expose stats on a per-channel basis,
> .ndo_get_xdp_stats_nch(). include/net/xdp.h contains some helper

Why the tie to a channel? There are Rx queues and Tx queues and no
requirement to link them into a channel. It would be better (more
flexible) to allow them to be independent. Rather than ask the driver
"how many channels", ask 'how many Rx queues' and 'how many Tx queues'
for which xdp stats are reported.

From there, allow queue numbers or queue id's to be non-consecutive and
add a queue id or number as an attribute. e.g.,

[XDP stats]
	[ Rx queue N]
		counters


	[ Tx queue N]
		counters

This would allow a follow on patch set to do something like "Give me XDP
stats for Rx queue N" instead of doing a full dump.
