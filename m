Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BB42EB14A
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbhAERWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbhAERWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:22:35 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EBEC061574;
        Tue,  5 Jan 2021 09:21:54 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g20so1326162ejb.1;
        Tue, 05 Jan 2021 09:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSRxfexlX+TmtuDQNvbFyHaBrUOTIF7TI7Ukl++5ydM=;
        b=U+o+pyp+l3zyd5upJtpbXP/u6KjtyGjSfnZ6gLtcvkij67ckfF8VUgA1Ak2plHowP7
         w7SVES4ctWMjJ7oc47tdLrUHf2hKI9NRUrQzzkI8m7vV6S/f9zgNqCefTIY4bEzBRgrO
         LoZN1MK1x8HRnI0Z7Q1arW5kIuD5tSboEWwLiZ7IRgSa7GPjBk4JjnFxR185U9GfQfJm
         tMuamTwL+c6EEQjDjWQJG9wOLN9SiAcYHyRImct024Gqgn/wxClXzOd2tPPzZHGmIq/D
         olsD4lYQKKOZblsQ9B4nZVvvUY6citQxkQFpKIv7XxGbcz4n/uZ6KtYC5Yuh750MSVFu
         zPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSRxfexlX+TmtuDQNvbFyHaBrUOTIF7TI7Ukl++5ydM=;
        b=V4l4z5WeiTsMz6/nMcSrMGmi+SlLTWxV98NO2DIetBN423T69F59RwNF3ThRI93vAs
         /9NGhxa/LGr09tvtbbG7hV1vz+EqTggSTW8KTJj6TexcYtpqfcL5wzmHiBtoRI8tidTC
         JEn0YaQnmfNqUU/Avn8BdTFyA5gx2/hCvuABuAn9qTb/RQQ+fh1IR96rcQIUAGjP4Wxw
         WxH7TJzrtTJUY0O4wb6vQnrswlV4qhmiwAj/p9wI0wcpHKnxv7TaoCA5AGj0jI88kMag
         qHmG0AQHxKFubqe0ghiqfsOM29hPVeWMpYJQaZ3Y9hE6NbxYZPRzIJIiU+6SM6g9CtvP
         VdAg==
X-Gm-Message-State: AOAM532sVhfIqjUoUfAdjSQXyNz5MlNUkQmUsN69kMPW/7BEYdqYfdiO
        9UvIT7y+EyrdOWPwnS816Lq6onDyzfT27bcxzto=
X-Google-Smtp-Source: ABdhPJwysOD9E7pxkEqAaLv2NlRBgkBFWH4JrO6h2Uhg0SUJwj/aOHvX9EFy0WCEPdW8KYO8dCdIdkVw+kgsRL0P5BI=
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr159861ejb.11.1609867312746;
 Tue, 05 Jan 2021 09:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20210105122416.16492-1-yuri.benditovich@daynix.com>
In-Reply-To: <20210105122416.16492-1-yuri.benditovich@daynix.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 5 Jan 2021 12:21:17 -0500
Message-ID: <CAF=yD-+UwgObscAq96Rc3zO=Ky8iquQrcx33StXPMkMw1ukSSw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, yan@daynix.com,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 8:12 AM Yuri Benditovich
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
>
> Yuri Benditovich (7):
>   skbuff: define field for hash report type
>   vhost: support for hash report virtio-net feature
>   tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
>   tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
>   tun: add ioctl code TUNSETHASHPOPULATION
>   tun: populate hash in virtio-net header when needed
>   tun: report new tun feature IFF_HASH

Patch 1/7 is missing.

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
