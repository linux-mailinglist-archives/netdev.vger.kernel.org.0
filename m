Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5339BB11
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFDOqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFDOqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 10:46:32 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE6C061766
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 07:44:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ho18so3920999ejc.8
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 07:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rzUMQzM9CPDNdDmna10qeEEbaBSRzoclI/nFPuyQDgI=;
        b=B+o51f/x+rHcsKGmjZx5n/ML2UMsFBijq9gm52HkFahb+gaMmUYYfPXJImUTmXboxg
         Li3C2/UZsRb/pVcMKfROaBQUA07SvTfeDZIpjCwccU6/t+K6WvbSB4UGLGI5n0yaHNlr
         NDESrwB6qM6Z/5VnMVUxv4Jtb8mvI7/TBxA8ZaXxXBZ+qd5Z6oeBeGaIN09hd/0G+/yN
         sufzNbqgdvoapVIP34FlEGTt8AK6KN0EOeSGt/C2KnIpsqio9Q7Ry3MfL2v5dNf/X55e
         sqIKr7qGPGf1jRctAUP4zjtPAsn2B/d5GlEsFPsNBiFCAYRWRbOXB8COLis6iJe+2Kf0
         nLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rzUMQzM9CPDNdDmna10qeEEbaBSRzoclI/nFPuyQDgI=;
        b=ZnDbE+fL6kzm/lxjWRa5xGCbgyNNa1D74UgDG+4sfchirDuumW/HvyazVzZ5OpCnZZ
         0SEsNIlPUnASopZ3ykmryfxZl+Yp3m3ZgxrI++t86z4vzZclbsn2k9Inil/l660Kf1bZ
         7KcSG+BIVhC2fQTKjOmlsiTys10IePSO6BaJzkhl4QxaCuzbTJz2K4ypkjbFhhy06Vik
         J1Wn3ZcS2I2S7XsVtCqNzT5U6RnC6ujpgRSK9b/1aeC/S8ZAwQALLgA9+d6xA8sIvavf
         BoQWZaABUXEpnuV7hQnJcIXKRUWwkcwTWGa7munkKDrPvzCkCvzfgHv02bZzpnMlSO5M
         VYXg==
X-Gm-Message-State: AOAM533JCQEfXiZkEwLWOgWaZ8VEmX17AGh/fIAXSWqMaPo7Rs0kYO9V
        SEYx/Ye+6QcuaUTkuO673wLj9a7IeFmA0A==
X-Google-Smtp-Source: ABdhPJzHdcPHBxBwtgHFw7ZIhkL14xJZdQ3QH6xkM2KL7MH9njmvvexCpz3k4oFlQtaEJuHBBj101A==
X-Received: by 2002:a17:906:4e05:: with SMTP id z5mr4452617eju.520.1622817869163;
        Fri, 04 Jun 2021 07:44:29 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id b14sm3388378edz.21.2021.06.04.07.44.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 07:44:28 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id h5-20020a05600c3505b029019f0654f6f1so7547633wmq.0
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 07:44:27 -0700 (PDT)
X-Received: by 2002:a1c:2456:: with SMTP id k83mr4047546wmk.87.1622817867489;
 Fri, 04 Jun 2021 07:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
 <eef275f7-38c5-6967-7678-57dd5d59cf76@redhat.com> <CA+FuTSdEF7dONWZWR3t9EZ5VU3XrfWTb0CmWKe7pQBL-tje0WA@mail.gmail.com>
 <d56a153a-ba13-480f-2ce2-7cbc7fd4c529@redhat.com>
In-Reply-To: <d56a153a-ba13-480f-2ce2-7cbc7fd4c529@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 4 Jun 2021 10:43:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfe7PmPnjqGGFfte3xhjQjb5oN0Wak205RZa3TAx2e5sA@mail.gmail.com>
Message-ID: <CA+FuTSfe7PmPnjqGGFfte3xhjQjb5oN0Wak205RZa3TAx2e5sA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> Several questions:
> >>
> >> 1) having bpf core to know about virito-net header seems like a layer
> >> violation, it doesn't scale as we may add new fields, actually there's
> >> already fields that is not implemented in the spec but not Linux right now.
> > struct virtio_net_hdr is used by multiple interfaces, not just virtio.
> > The interface as is will remain, regardless of additional extensions.
> >
> > If the interface is extended, the validation can be extended with it.
>
>
> One possible problem is that there's no sufficient context.
>
> The vnet header length is not a fixed value but depends on the feature
> negotiation. The num_buffers (not implemented in this series) is an
> example. The field doesn't not exist for legacy device if mergeable
> buffer is disabled. If we decide to go with this way, we probably need
> to fix this by introducing a vnet header length.
>
> And I'm not sure it can work for all the future cases e.g the semantic
> of a field may vary depends on the feature negotiated, but maybe it's
> safe since it needs to set the flags.
>
> Another note is that the spec doesn't exclude the possibility to have a
> complete new vnet header format in the future. And the bpf program is
> unaware of any virtio features.

We can extend the program with a version or type field, if multiple
variants appear. The callers can set this.

Thanks for the examples. As a matter of fact, I do know that kind of
extension. I proposed new fields myself this winter, to for timestamps,
pacing offload and hash info on tx:

https://lore.kernel.org/netdev/20210208185558.995292-1-willemdebruijn.kernel@gmail.com/T/#mcbd4dff966a93d61a31844c9d968e7cd4ee7f0ab

Like num_buffers, those are new fields appended to the struct.

Agreed that if the semantics of the existing fields would change or
a whole new v2 type would be defined (with much stricter semantics
that time around, and validation from the start), then a type field in
the flow dissector will be needed.

That is feasible and won't have to break the BPF interface.

> >
> > Just curious: can you share what extra fields may be in the pipeline?
> > The struct has historically not seen (m)any changes.
>
>
> For extra fields, I vaguely remember we had some discussions on the
> possible method to extend that, but I forget the actual features.
>
> But spec support RSC which may reuse csum_start/offset but it looks to
> me RSC is not something like Linux need.
>
>
> >
> >> 2) virtio_net_hdr_to_skb() is not the single entry point, packet could
> >> go via XDP
> > Do you mean AF_XDP?
>
>
> Yes and kernel XDP as well. If the packet is redirected or transmitted,
> it won't even go to virtio_net_hdr_to_skb().

Redirected packets are already in the kernel.

This is strictly a chokepoint for new packets injected from userspace.

> Since there's no GSO/csum support for XDP, it's probably ok, but needs
> to consider this for the future consider the multi-buffer XDP is being
> developed right now, we can release those restriction.

Yes, we have to make sure not to introduce the same issues with any
XDP GSO extensions, if it comes to that.

> > As far as I know, vnet_hdr is the only injection
> > interface for complex packets that include offload instructions (GSO,
> > csum) -- which are the ones mostly implicated in bug reports.
>
>
> Ideally, if GSO/csum is supported by XDP, it would be more simple to use
> XDP I think.

That might actually reduce the odds of seeing new virtio_net_hdr extensions?

That legacy interface is here to stay, though, so we have to continue
to be prepared to handle any input that comes that way.
