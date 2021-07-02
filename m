Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5988B3BA148
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 15:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhGBNgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 09:36:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231985AbhGBNgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 09:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625232830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hYKQz8dHROV63iIjkLsL92tnKpMRXspNrGM7O81lboU=;
        b=ENdjRLUcFcjxSw3odCnLS8mlWF/kxhfvNTINdTWi5aRLcxG6kACOMR9joTwLUqFYGAOgNB
        ipCiiELbBX+67ApuFaHP0ctwZu0BOkNWjgOxEJT00jL0ZEfdiIkw0TCY0EQqTMLw4VGXDO
        siIY8Ioep1j45bnbmyh7OTHQH1wK7rE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-IREetcUiMAC-unZ0tXYEYQ-1; Fri, 02 Jul 2021 09:33:49 -0400
X-MC-Unique: IREetcUiMAC-unZ0tXYEYQ-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640200d3b02903948b71f25cso5090472edu.4
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 06:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hYKQz8dHROV63iIjkLsL92tnKpMRXspNrGM7O81lboU=;
        b=bwMwpfG0+p6URFiVY2UM2t30slD+Nj4tmHsSCdwwgIKt11172BjYiJLjvrAiTNfTQR
         TyyZQpC+/vKUqsQRvYbmv7LysnPMeHYTuOucpEeetN4fmVQJ8kX31C6yqpPfv+r/FW01
         5XKXO1X5EGMyTJU6Pqt11ffXzDQ2Ze8s0FahddTd4YkyNO686ka1bvQnqwE/lcqWCh2L
         NNhmBUzaCuLm3KUhB8cGb9ZdzNlQTzgsGQn4nY6BHHxNUoG+crN0gBkeXUNZSHDXF/An
         1PoVaQEmDn8sQCFS8P1wKXRWXqgU//iJun0lxlzyaVV0o7C+FTTVfhY33UFys9u51Q2h
         UX6A==
X-Gm-Message-State: AOAM533+16ispgUuWbQ0wDbXv+Z9hOdJGpXdhqdr+t8bY6fsnHEoz7F8
        sZnVZHACLmoMVb1nBXl0xTiLYJDqdplSUOjTN4caGi7Xv4VOf8fbOCBm865mlUl2psbr6bRnIGD
        ok1o+tUNMb61eaN4P
X-Received: by 2002:aa7:d309:: with SMTP id p9mr6770686edq.340.1625232827889;
        Fri, 02 Jul 2021 06:33:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOMUHDoddBA5sp10yG3YXm6PqdvK6huTExDGur4boRDEBmFAt35QaUttGF5RdlnIST91GBCA==
X-Received: by 2002:aa7:d309:: with SMTP id p9mr6770656edq.340.1625232827709;
        Fri, 02 Jul 2021 06:33:47 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id ee25sm1355416edb.6.2021.07.02.06.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 06:33:47 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next v6 3/5] bpf: cpumap: implement generic cpumap
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>, bpf@vger.kernel.org
References: <20210702111825.491065-1-memxor@gmail.com>
 <20210702111825.491065-4-memxor@gmail.com>
Message-ID: <954f8592-285c-8d2b-db22-7d8818e0903c@redhat.com>
Date:   Fri, 2 Jul 2021 15:33:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702111825.491065-4-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02/07/2021 13.18, Kumar Kartikeya Dwivedi wrote:
> This change implements CPUMAP redirect support for generic XDP programs.
> The idea is to reuse the cpu map entry's queue that is used to push
> native xdp frames for redirecting skb to a different CPU. This will
> match native XDP behavior (in that RPS is invoked again for packet
> reinjected into networking stack).
>
> To be able to determine whether the incoming skb is from the driver or
> cpumap, we reuse skb->redirected bit that skips generic XDP processing
> when it is set. To always make use of this, CONFIG_NET_REDIRECT guard on
> it has been lifted and it is always available.
>
>  From the redirect side, we add the skb to ptr_ring with its lowest bit
> set to 1.  This should be safe as skb is not 1-byte aligned. This allows
> kthread to discern between xdp_frames and sk_buff. On consumption of the
> ptr_ring item, the lowest bit is unset.
>
> In the end, the skb is simply added to the list that kthread is anyway
> going to maintain for xdp_frames converted to skb, and then received
> again by using netif_receive_skb_list.
>
> Bulking optimization for generic cpumap is left as an exercise for a
> future patch for now.
>
> Since cpumap entry progs are now supported, also remove check in
> generic_xdp_install for the cpumap.
>
> Reviewed-by: Toke Høiland-Jørgensen<toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi<memxor@gmail.com>
> ---
>   include/linux/bpf.h    |   9 +++-
>   include/linux/skbuff.h |  10 +---
>   kernel/bpf/cpumap.c    | 116 ++++++++++++++++++++++++++++++++++-------
>   net/core/dev.c         |   3 +-
>   net/core/filter.c      |   6 ++-
>   5 files changed, 114 insertions(+), 30 deletions(-)


Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


