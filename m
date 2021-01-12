Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A821B2F3B28
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393245AbhALTuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393208AbhALTuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:50:15 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023B1C061794
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:49:35 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id i6so3476199otr.2
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7/M6B7YqTGHi7NnZLBVw1iJEATx9VM5xn4jowTooqg=;
        b=UmdCnOd9p7HTDUpn111xjpsZhlH9Wyagx3fH8hlscE+sSrJz429k6OC+NnvRnFQwpl
         jqkR0s7AEDLjTJ0tq6hZBObi6DFBJPrI8K29WbKXWEX8kB539YWrgpGJqfy0ojTAcqlX
         A/8M+eXo7DG43n0QaITT1ZzZkFVJHA1wCZsMP/csUGUiOcYrjXPxCNQbVGHYFk8eZMml
         PQCZdfIhK5Q8tqATIShbwSMJx30AKk7x9Yiz8gp1FLSc6TkC1TzXRxLv7QIpuV8ow32m
         QHlWmBmHegqCq8m2hkfA2+d81qT2yKRdtWfqAGHKLt6uQt4tjNbi71loXt7+hIyfFEF8
         ILCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7/M6B7YqTGHi7NnZLBVw1iJEATx9VM5xn4jowTooqg=;
        b=HCy0RsDGuSA2LeF5nldkfKRsMWKDaRs8+FXSUefXW3KWqYoNr6xnALP39wPO70y3dW
         BvFe6jlAQOvcS/4TSU+79HP7vDf/RpT80a+Q8c0zR308VtJEENatYVZSlTmCN0/c1ZCl
         KegHwJBHoCypKU1VouMsgXM9Nuu2jyNo/c+gvVa4oIg8qNejRsBiHQJ/akziJTsuRClw
         /45VPMu/lJRHv9MCN+kbagSoNQcFnG0lxWbDKXmJriz8zG0hXPVosSOgLPTjGsydlv7R
         /itmfJJQd8D2128OG+TkZ1oj7nUjAimmQqNBM9+Z0e5GG6YMhhfphj/9neUvcB57ZOEU
         BXFA==
X-Gm-Message-State: AOAM5333SeYO887h/XNddAWE50SfKq0qCnZ2B9YX9sBXJRlvYlhSEtVe
        BPf0fiVSNpLgVppOabpw3BhTKDncpkoFtD3qDlnjwQ==
X-Google-Smtp-Source: ABdhPJzHurposwP0CkbMCdsJQYlpBWAqy5u0b6+ShjXQt+hgxjTlD6eu4NfdkCl4yEwTKKUdzPdbCNayYxSsoybE50Y=
X-Received: by 2002:a9d:4715:: with SMTP id a21mr734506otf.220.1610480974332;
 Tue, 12 Jan 2021 11:49:34 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
In-Reply-To: <20210112194143.1494-1-yuri.benditovich@daynix.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 12 Jan 2021 21:49:21 +0200
Message-ID: <CAOEp5OejaX4ZETThrj4-n8_yZoeTZs56CBPHbQqNsR2oni8dWw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, rdunlap@infradead.org,
        willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        nogikh@google.com, pablo@netfilter.org, decui@microsoft.com,
        cai@lca.pw, jakub@cloudflare.com, elver@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Cc:     Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 9:41 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> Existing TUN module is able to use provided "steering eBPF" to
> calculate per-packet hash and derive the destination queue to
> place the packet to. The eBPF uses mapped configuration data
> containing a key for hash calculation and indirection table
> with array of queues' indices.
>
> This series of patches adds support for virtio-net hash reporting
> feature as defined in virtio specification. It extends the TUN module
> and the "steering eBPF" as follows:
>
> Extended steering eBPF calculates the hash value and hash type, keeps
> hash value in the skb->hash and returns index of destination virtqueue
> and the type of the hash. TUN module keeps returned hash type in
> (currently unused) field of the skb.
> skb->__unused renamed to 'hash_report_type'.
>
> When TUN module is called later to allocate and fill the virtio-net
> header and push it to destination virtqueue it populates the hash
> and the hash type into virtio-net header.
>
> VHOST driver is made aware of respective virtio-net feature that
> extends the virtio-net header to report the hash value and hash report
> type.

Comment from Willem de Bruijn:

Skbuff fields are in short supply. I don't think we need to add one
just for this narrow path entirely internal to the tun device.

Instead, you could just run the flow_dissector in tun_put_user if the
feature is negotiated. Indeed, the flow dissector seems more apt to me
than BPF here. Note that the flow dissector internally can be
overridden by a BPF program if the admin so chooses.

This also hits on a deeper point with the choice of hash values, that
I also noticed in my RFC patchset to implement the inverse [1][2]. It
is much more detailed than skb->hash + skb->l4_hash currently offers,
and that can be gotten for free from most hardware. In most practical
cases, that information suffices. I added less specific fields
VIRTIO_NET_HASH_REPORT_L4, VIRTIO_NET_HASH_REPORT_OTHER that work
without explicit flow dissection. I understand that the existing
fields are part of the standard. Just curious, what is their purpose
beyond 4-tuple based flow hashing?

[1] https://patchwork.kernel.org/project/netdevbpf/list/?series=406859&state=*
[2] https://github.com/wdebruij/linux/commit/0f77febf22cd6ffc242a575807fa8382a26e511e
>
> Yuri Benditovich (7):
>   skbuff: define field for hash report type
>   vhost: support for hash report virtio-net feature
>   tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
>   tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
>   tun: add ioctl code TUNSETHASHPOPULATION
>   tun: populate hash in virtio-net header when needed
>   tun: report new tun feature IFF_HASH
>
>  drivers/net/tun.c           | 43 +++++++++++++++++++++++++++++++------
>  drivers/vhost/net.c         | 37 ++++++++++++++++++++++++-------
>  include/linux/skbuff.h      |  7 +++++-
>  include/uapi/linux/if_tun.h |  2 ++
>  4 files changed, 74 insertions(+), 15 deletions(-)
>
> --
> 2.17.1
>
