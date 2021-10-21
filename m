Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A0F436B14
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhJUTKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUTKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:10:18 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8B8C061764;
        Thu, 21 Oct 2021 12:08:01 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id d125so2349663iof.5;
        Thu, 21 Oct 2021 12:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=TUzZuhjYpMvPdoQNG0gP2zaSWPan1XbqRxzouVeRBQs=;
        b=CRxhGy9zIQTyEjv/h2kwwy2/d6dI8JnCayWD18ZJhi56uZknOszIjlyTftpwy1bT8g
         GFKqb87VHBkuj6vg30awR0o+75jyr9VOyiPvwkO0yEvwXq6wMZyQwz8Yhe/M7ROroZ2g
         d5McfohoczzZaMjV3ea3jzyGZLoCYfKqFrOchZKoU3rkKR6JZkLJq3gMqWEndEnCZ8oA
         mjvvhFvVNQ/kxdS2zOSh9Az/Ui16CsfBeIaersg8CZTYB09RJYc+sk2csoRf5hq+5psA
         KxUdkoic666O+Hi+pZwj7rsvFJX+KAnqYdN6iqnCZvHOGi2kfm9Y6Nbp9qoXwkzL69N3
         nooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=TUzZuhjYpMvPdoQNG0gP2zaSWPan1XbqRxzouVeRBQs=;
        b=77ghA1ylG95Kn7aEu60L/Gs8rcCGcLVyc9K9LA11BDwkDPkX7AdURO/mRx16IDx3u8
         HBYo3GPrrjocVMjDlCI+pabauyBg2ufBaLwqoLjx489Ssucl5F2j1pyOTuufAhFAIGAZ
         +eNk0uT1y0dq193Khm3Ir74fGcpxRN5m7sXba/c6Z2tWV/cUz7/flwsW+Sm20O9yVSh1
         u5Rvv4YRm7WELbzQS75X9l7vqYhDdzl/uFoA0REwXodXryavTFNml50bw2JPtylspQb0
         Qn9IuVjWsJ0ViRAmllfBBSasvNv/TRpML8rotGM/c/OSF2iIIXNehWukVK4QuPeEPE6E
         au5A==
X-Gm-Message-State: AOAM531PRJcRcXOQCd6pWNzTqIHvR263a7tEnp9b4O4i00kScy2R7189
        lgGwv/2R/E0eNhu8+tCYA20=
X-Google-Smtp-Source: ABdhPJxooI5BtboklkIU0xvW9IdPIgKu/Mwx61YiPmfODaCsNIALEDdL51MtaTeCDq8UVegOmOXWBA==
X-Received: by 2002:a05:6602:123c:: with SMTP id z28mr2708378iot.113.1634843281374;
        Thu, 21 Oct 2021 12:08:01 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l4sm2891535ilg.44.2021.10.21.12.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 12:08:00 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:07:52 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Mark Pashmfouroush <markpash@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Message-ID: <6171ba88e5825_663a720836@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQ+_MysCNnaPZd550wQaohtWTikmgnsysoZhnNpwPgv23A@mail.gmail.com>
References: <20211015112336.1973229-1-markpash@cloudflare.com>
 <20211015112336.1973229-2-markpash@cloudflare.com>
 <CAADnVQ+_MysCNnaPZd550wQaohtWTikmgnsysoZhnNpwPgv23A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add ifindex to bpf_sk_lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Fri, Oct 15, 2021 at 4:24 AM Mark Pashmfouroush
> <markpash@cloudflare.com> wrote:
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 6fc59d61937a..9bd3e8b8a659 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -6262,6 +6262,7 @@ struct bpf_sk_lookup {
> >         __u32 local_ip4;        /* Network byte order */
> >         __u32 local_ip6[4];     /* Network byte order */
> >         __u32 local_port;       /* Host byte order */
> > +       __u32 ifindex;          /* Maps to skb->dev->ifindex */
> 
> Is the comment accurate?
> The bpf_sk_lookup_kern ifindex is populated with inet_iif(skb).
> Which is skb->skb_iif at this point (I think).
> skb->dev->ifindex would typically mean destination or egress ifindex.
> In __sk_buff we have 'ifindex' and 'ingress_ifindex' to differentiate them.
> If it's really dev->ifindex than keeping 'ifindex' name here would be correct,
> but looking at how it's populated in inet/udp_lookup makes me wonder
> whether it should be named 'ingress_ifindex' instead and comment clarified.
> 
> If/when you resubmit please trim cc list to a minimum.

At least in the tcp cases its coming from inet_iif which is either
the rtable or skb->skb_iif. Agree would be nice to fixup the comment.

Thanks.
