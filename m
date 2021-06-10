Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74403A2DB0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFJOHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhFJOHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:07:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A8BC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:05:16 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id he7so24944372ejc.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O68LTwdMkJTPL4/GAGTyk/CDx9zRZmkpq5dKsgDWAag=;
        b=gWDtipOsTu0+GzqDS/qvvNo3mTkuNlFPZPnbJnj6n3E6etGyx+V/cUthorZ6ESVst3
         e/c64+ra5ic4zsLDAoyMSCHVytNmWOOzSM8wgQMhCy63YPe7NUKdncMDRi75hUclm6j4
         mW9q9HcmLvSIRBgZrohY6m2UqVvxcKYv9Xk6In5YpBGFQHCErRzPO8onxlPmA5gQC+LW
         HHLa4C3NOxWBe/p51cpDpkJF4LtWdEsHUllVdMxsnhe0Dxni4A8n1lLYkYhdn7BOgXHA
         czVyt8VkAU+3DXZfEsEQv0kcW54C90wqSzkdDfbuEJdPMebJBl6w+CuxDxtVu1/O0K3w
         RRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O68LTwdMkJTPL4/GAGTyk/CDx9zRZmkpq5dKsgDWAag=;
        b=O2kqcOBEiHyCM92cCuMByrKOLMaBzSEow3bCq4AV4CyoU9+loavM/pR6askLoXhznn
         JJj9Hl4Xr+kaCgo+8JPi1broaXDSF5uEKo0T3GuYMb4IXTG9nb1cW2C9M0DTPnagc/WO
         JW19yWhuY5sGgflyeXPpvFqJj2E67zg5PbkRHPwgoxpgGCetVyt2fLcJI7hXTt2//i12
         nVngx9G+W/dSkyNijuHY/JihdIS6kI1VBb8hNUqNj5rEdtZEZ3qsu4LGdmW23QBRc9vt
         4vxZn0bEbuhKWJx6hD6CMTCa4EzP1NTMkyZDHDI7KTLYS8K3Wu1fDh1qzeeIE8p9ohSw
         1GGw==
X-Gm-Message-State: AOAM532urVqzviq1BIeDC3qZ52Jf4JA9GeAbbazWZiAj6VkieKjuV91+
        fGOk0IsgwWd64zKvaBusnHL98j5Ej9w6EQ==
X-Google-Smtp-Source: ABdhPJwsy6Gs49UIIQeL0JrJry/vyUNUNtjenfQu49lZ4/qL+WUBoD6qWHaAAUIQp3ub8l/TKC7WFA==
X-Received: by 2002:a17:906:af55:: with SMTP id ly21mr4500140ejb.276.1623333914643;
        Thu, 10 Jun 2021 07:05:14 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id f10sm1391387edx.60.2021.06.10.07.05.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:05:13 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso6626410wmi.3
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:05:13 -0700 (PDT)
X-Received: by 2002:a7b:c935:: with SMTP id h21mr15233756wml.183.1623333912587;
 Thu, 10 Jun 2021 07:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com> <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com>
In-Reply-To: <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Jun 2021 10:04:34 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
Message-ID: <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
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

On Thu, Jun 10, 2021 at 1:25 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=8812:19, Alexei Starovoitov =E5=86=99=
=E9=81=93:
> > On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> wrote:
> >> So I wonder why not simply use helpers to access the vnet header like
> >> how tcp-bpf access the tcp header?
> > Short answer - speed.
> > tcp-bpf accesses all uapi and non-uapi structs directly.
> >
>
> Ok, this makes sense. But instead of coupling device specific stuffs
> like vnet header and neediness into general flow_keys as a context.
>
> It would be better to introduce a vnet header context which contains
>
> 1) vnet header
> 2) flow keys
> 3) other contexts like endian and virtio-net features
>
> So we preserve the performance and decouple the virtio-net stuffs from
> general structures like flow_keys or __sk_buff.

You are advocating for a separate BPF program that takes a vnet hdr
and flow_keys as context and is run separately after flow dissection?

I don't understand the benefit of splitting the program in two in this mann=
er.

Your previous comment mentions two vnet_hdr definitions that can get
out of sync. Do you mean v1 of this patch, that adds the individual
fields to bpf_flow_dissector? That is no longer the case: the latest
version directly access the real struct. As Alexei points out, doing
this does not set virtio_net_hdr in stone in the ABI. That is a valid
worry. But so this patch series will not restrict how that struct may
develop over time. A version field allows a BPF program to parse the
different variants of the struct -- in the same manner as other
protocol headers. If you prefer, we can add that field from the start.
I don't see a benefit to an extra layer of indirection in the form of
helper functions.

I do see downsides to splitting the program. The goal is to ensure
consistency between vnet_hdr and packet payload. A program split
limits to checking vnet_hdr against what the flow_keys struct has
extracted. That is a great reduction over full packet access. For
instance, does the packet contain IP options? No idea.

If stable ABI is not a concern and there are no different struct
definitions that can go out of sync, does that address your main
concerns?
