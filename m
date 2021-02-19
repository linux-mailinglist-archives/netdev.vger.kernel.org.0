Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44D131FB76
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 15:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBSO4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 09:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBSO4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 09:56:52 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E12BC061756
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 06:56:10 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id e13so10679736ejl.8
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 06:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9KW+1lIwPV9FPrnZg5vNSqypATsMZae7KiNb0eudmHM=;
        b=fWlizlEuP6fQFXcSfr57FExVLI3CPIV2N2m+q43FPhwTzlg8qFqVtR2ot7crvh/QW2
         Qs8fcmRxZoRaSthNGmlfJA5Rv1YBC4S9VvZN9TBF+pu585Yd1tSv+dganVhM4259iily
         Wk8X2dC0CiMSntdm2q50kxGpwkPvEF2mKeZbx3Rd9w0aV1hEjvzOeSYK91djuqD/9uRz
         IybFBgnlTsOuU0j8UxqZHZhzAmejyXt6wOt88B/zjfNk8g3b8pKf0IPPwq3gTBJNFb6m
         sZQFyr10ifWODIk6m67nbAeupaz3rX9483lUva4ErH/Z1+sVoqOuBKu+W0aPvF0RE7bF
         LqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9KW+1lIwPV9FPrnZg5vNSqypATsMZae7KiNb0eudmHM=;
        b=TDOBCLFK4pW68FKoYtmj+XLa10T8b+cg81BeGLUlElXsvLWR2bXyWMZodMsPtgQ5Fe
         v+tVKazWW5UJ4OJlSkryAkWHgINQ1EgDCND1Fu4LkpR+1Rh69g+pV7M13EJnRAn4Dqqx
         WcvYVfjw842H8zfg80l/mK1nTYSPtznBHM13pHKibsxRcp+aiBqhwTqQEaJi+QLsH2Mf
         652Cz6/m+DFmK/bwDhc29l070l6e1YOnjbtnqiFzG29KdneMKlCRPWUkHUBcGFIkRGXd
         9HzqXqz3tFKwhTIrJ7Nu+FvkxBocDnDxNdJTQuvBDyQlECViFu4vfdRTKKFruGhocw5D
         tRKA==
X-Gm-Message-State: AOAM533OhhY2KjFSh/Et3zOW9oYIUo5ccBYSCLGVs9Z98iFDAPHpF9iP
        dSnXR9EMJBwMjaLwBQhhhsJ99xAcWCI=
X-Google-Smtp-Source: ABdhPJwMYsj/9mVd0g8NP2LYwJ8orMYR1kg+jSFq0FlnLjJrNdWhKfl5xRJpz6ORJCVE0kUeZKQ5JQ==
X-Received: by 2002:a17:906:cf84:: with SMTP id um4mr9121601ejb.61.1613746568297;
        Fri, 19 Feb 2021 06:56:08 -0800 (PST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id d23sm2950491ejw.109.2021.02.19.06.56.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 06:56:06 -0800 (PST)
Received: by mail-wr1-f47.google.com with SMTP id 7so8969336wrz.0
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 06:56:06 -0800 (PST)
X-Received: by 2002:a5d:4488:: with SMTP id j8mr8312106wrq.12.1613746565793;
 Fri, 19 Feb 2021 06:56:05 -0800 (PST)
MIME-Version: 1.0
References: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
 <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com> <2cc06597-8005-7be8-4094-b20f525afde8@redhat.com>
In-Reply-To: <2cc06597-8005-7be8-4094-b20f525afde8@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 19 Feb 2021 09:55:28 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf2GCi+RzpkFeBgtSOyhjsBFfApjekzupHLfyeYDn-JYQ@mail.gmail.com>
Message-ID: <CA+FuTSf2GCi+RzpkFeBgtSOyhjsBFfApjekzupHLfyeYDn-JYQ@mail.gmail.com>
Subject: Re: [PATCH] net: check if protocol extracted by virtio_net_hdr_set_proto
 is correct
To:     Jason Wang <jasowang@redhat.com>
Cc:     Balazs Nemeth <bnemeth@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 3:53 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/18 11:50 =E4=B8=8B=E5=8D=88, Willem de Bruijn wrote:
> > On Thu, Feb 18, 2021 at 10:01 AM Balazs Nemeth <bnemeth@redhat.com> wro=
te:
> >> For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn=
't
> >> set) based on the type in the virtio net hdr, but the skb could contai=
n
> >> anything since it could come from packet_snd through a raw socket. If
> >> there is a mismatch between what virtio_net_hdr_set_proto sets and
> >> the actual protocol, then the skb could be handled incorrectly later
> >> on by gso.
> >>
> >> The network header of gso packets starts at 14 bytes, but a specially
> >> crafted packet could fool the call to skb_flow_dissect_flow_keys_basic
> >> as the network header offset in the skb could be incorrect.
> >> Consequently, EINVAL is not returned.
> >>
> >> There are even packets that can cause an infinite loop. For example, a
> >> packet with ethernet type ETH_P_MPLS_UC (which is unnoticed by
> >> virtio_net_hdr_to_skb) that is sent to a geneve interface will be
> >> handled by geneve_build_skb. In turn, it calls
> >> udp_tunnel_handle_offloads which then calls skb_reset_inner_headers.
> >> After that, the packet gets passed to mpls_gso_segment. That function
> >> calculates the mpls header length by taking the difference between
> >> network_header and inner_network_header. Since the two are equal
> >> (due to the earlier call to skb_reset_inner_headers), it will calculat=
e
> >> a header of length 0, and it will not pull any headers. Then, it will
> >> call skb_mac_gso_segment which will again call mpls_gso_segment, etc..=
.
> >> This leads to the infinite loop.
>
>
> I remember kernel will validate dodgy gso packets in gso ops. I wonder
> why not do the check there? The reason is that virtio/TUN is not the
> only source for those packets.

It is? All other GSO packets are generated by the stack itself, either
locally or through GRO.

But indeed some checks are better performed in the GSO layer. Such as
likely the 0-byte mpls header length.

If we cannot trust virtio_net_hdr.gso_type passed from userspace, then
we can also not trust the eth.h_proto coming from the same source. But
it makes sense to require them to be consistent. There is a
dev_parse_header_protocol that may return the link layer type in a
more generic fashion than casting to skb_eth_hdr.

Question remains what to do for the link layer types that do not implement
header_ops->parse_protocol, and so we cannot validate the packet's
network protocol. Drop will cause false positives, accepts will leave a
potential path, just closes it for Ethernet.

This might call for multiple fixes, both on first ingest and inside the sta=
ck?
