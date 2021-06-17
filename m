Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08D3AB647
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFQOp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhFQOpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 10:45:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAA4C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 07:43:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id u24so4327381edy.11
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 07:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sba7znE8l+N6G+hAqTMdAlmuQF6MkcwYiB7smC9PhCQ=;
        b=FQ8nGeLo9PH/hS8YKeWYtUFc30ycBzomHxNasEYsZUJUVW0fIMqmnm8cmVxJs2A/7/
         52ljvPOcJyr9V55Cd8R68S0c/0BjKpa36rumYQFWRJrgQTxp11jZhIOB/4VNHZhu0QNq
         Y0jfpR+BOfg4UIOwEd8aVDmz+o1lIOhXzfrdG2oujpeaHRVPKQF+BgKLNnESak0i0SeZ
         /WHswqpmYyugRBFP2TyO9OUFpkMPswabKfOz4KUzaGNxkXvzRqDOpqCRL5bPkWCcyrJu
         H0y+lUqRZjTq/Buk3p7rNFGcicbVUkDz6E2G4Ygc8Aq8fyWAz8PWILCdBQUr7ioBJFTk
         cX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sba7znE8l+N6G+hAqTMdAlmuQF6MkcwYiB7smC9PhCQ=;
        b=EaU/CcLrl5tvU9APY1ypV/FlbCmnGTcSuF+4JAhMMT89YzwM0rFbTnBtEVhDM6dBW9
         cx+Hdiy4KtgIkRGJl36rbLSgB/GxxvGCKinNRcR74WAWda39m1807X8RiTcxhRM50GY8
         EZKHJvAabjh3YucciIss9kUYm6Gj1uFHTqAjKnsXddU+wTIxyxPmDndK3/9d8+wcHMqy
         bTQPT5y4/Zg/POp+Rze00fvzz5lC2ZfY3p9RTtc0RYPfcYYazrCHNyLiO0CzJynceGVs
         eqRcdr11Kk6ohzGcwYqSSqnmzNRZSWzxeQYZjQB3CbsolKttSMEFGCzC3RIBHe6UlRO6
         BdmA==
X-Gm-Message-State: AOAM530Rkp054GSdA9a0pbOZqzhEN6MJK/BncSmJJQVs+i/WbEWG0xzJ
        mDW2IbC3vkNsxwrUrX/Z7zqmWlvY7142mA==
X-Google-Smtp-Source: ABdhPJy/5SaT/Bk45WQI96a//uXEhk3S2v75IRUrje+p0nErKt9qlH+bJ6W9jsnHxtGQLoMXV1UvUQ==
X-Received: by 2002:a50:8dc6:: with SMTP id s6mr7042557edh.50.1623941026514;
        Thu, 17 Jun 2021 07:43:46 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id y10sm3862907ejm.76.2021.06.17.07.43.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 07:43:44 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso6574581wmg.2
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 07:43:44 -0700 (PDT)
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr5583296wmq.169.1623941023632;
 Thu, 17 Jun 2021 07:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com> <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com> <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com> <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com> <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
 <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com> <CAF=yD-J7kcXSqrXM1AcctpdBPznWeORd=z+bge+cP9KO_f=_yQ@mail.gmail.com>
 <7a63ca2a-7814-5dce-ce8b-4954326bb661@redhat.com>
In-Reply-To: <7a63ca2a-7814-5dce-ce8b-4954326bb661@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 17 Jun 2021 10:43:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTScJtyzx4nhoSp1fb2UZ3hPj6Ac_OeV4_4Tjfp8WvUpB1g@mail.gmail.com>
Message-ID: <CA+FuTScJtyzx4nhoSp1fb2UZ3hPj6Ac_OeV4_4Tjfp8WvUpB1g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 6:22 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/15 =E4=B8=8B=E5=8D=8810:47, Willem de Bruijn =E5=86=99=
=E9=81=93:
> >>>> Isn't virtio_net_hdr a virito-net specific metadata?
> >>> I don't think it is ever since it was also adopted for tun, tap,
> >>> pf_packet and uml. Basically, all callers of virtio_net_hdr_to_skb.
> >>
> >> For tun/tap it was used to serve the backend of the virtio-net datapat=
h
> > The purpose of this patch series is to protect the kernel against packe=
ts
> > inserted from userspace, by adding validation at the entry point.
> >
> > Agreed that BPF programs can do unspeakable things to packets, but
> > that is a different issue (with a different trust model), and out of sc=
ope.
>
>
> Ok, I think I understand your point, so basically we had two types of
> untrusted sources for virtio_net_hdr_to_skb():
>
> 1) packet injected from userspace: tun, tap, packet
> 2) packet received from a NIC: virtio-net, uml
>
> If I understand correctly, you only care about case 1). But the method
> could also be used by case 2).
>
> For 1) the proposal should work, we only need to care about csum/gso
> stuffs instead of virtio specific attributes like num_buffers.
>
> And 2) is the one that I want to make sure it works as expected since it
> requires more context to validate and we have other untrusted NICs

Yes. I did not fully appreciate the two different use cases of this
interface. For packets entering the the receive stack from a network
device, I agree that XDP is a suitable drop filter in principle. No
need for another layer. In practice, the single page constraint is a
large constraint today. But as you point out multi-buffer is a work in
progress.

> Ideally, I think XDP is probably the best. It is designed to do such
> early packet dropping per device. But it misses some important features
> which makes it can't work today.
>
> The method proposed in this patch should work for userspace injected
> packets, but it may not work very well in the case of XDP in the future.
> Using another bpf program type may only solve the issue of vnet header
> coupling with vnet header.
>
> I wonder whether or not we can do something in the middle:
>
> 1) make sure the flow dissector works even for the case of XDP (note
> that tun support XDP)

I think that wherever an XDP program exists in the datapath, that can
do the filtering, so there is no need for additional flow dissection.

If restricting this patch series to the subset of callers that inject
into the egress path *and* one of them has an XDP hook, the scope for
this feature set is narrower.

> 2) use some general fields instead of virtio-net specific fields, e.g
> using device header instead of vnet header in the flow keys strcuture

Can you give an example of what would be in the device header?

Specific for GSO, we have two sets of constants: VIRTIO_NET_HDR_GSO_..
and SKB_GSO_.. Is the suggestion to replace the current use of the
first in field flow_keys->virtio_net_hdr.gso_type with the second in
flow_keys->gso_type?
