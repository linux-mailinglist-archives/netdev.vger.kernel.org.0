Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC18E2F4D29
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 15:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbhAMOer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 09:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMOeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 09:34:46 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F344C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 06:34:06 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 30so1606659pgr.6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 06:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2ujGnSKYEthvi0rZ2iClFRGUsHpgEMsu727w+G030VY=;
        b=KUPL716HUHhkSt/RjEEjpWlYVDKM/abejwsbcqehL7DCSQm+pJqoncUorlVw/OV54k
         YViU+8HHMxFP67B4XdlZeuFHhKN8LFgxxyAuzbMhI/TONKoL8kkMF1z2PUJzY2Z+Gzd3
         6FVdE8sdiBLfF+nzsTAeDoSVodGoWs6pbHJdyHrDWIya8fLkDBpMubiZhda8l6YVYSQL
         TQ6gMvrlDp0E9Pb02g8KV/58eBqEYu+BKtSUdEXFQfnPiTe80AhbbzV2fj9dw+KuF5nx
         E8XWoEDWqy7jLDC+GnO6H3xkacv1NVRiFqCnTzYxIU/DjZQs+qOL0hVLJ+Us+11Zm6ot
         B0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2ujGnSKYEthvi0rZ2iClFRGUsHpgEMsu727w+G030VY=;
        b=CFFBPuLprYUIom1O2J3bv75iRhHwGyHhqFsFyqKPkGwHuM1D6/4nuLBGTPWN7oH6+U
         AJiQidmAYqGSH6OLv4KY7mrJ7F/7OwvOf5b3TaxzTKIAblDsFZHj1XiCtE4yx53Y5ZlD
         e2uPVX+3/n7sn3I4mncMg8UkgjjfCmfs75t8VsRbjasK5gHkWvj2Dj6Yx2Xc2+dJzq7M
         GecrdematE9yHOewe15ox5N5bdZ5Bazk5hGT18GoyMpaU2e1PWDBB4g2zsVMwuaZL8OB
         Wgdn+7azLnbXbvNkUCnB84jmbO9XPDKsfnSJ3BsvAoJVefmbN0NRhphu2My359JBZCCz
         h/sQ==
X-Gm-Message-State: AOAM531n3zlk/5pH8WwJ6HkB4t+qGTRbvYl/YxvO7rSbU91Jwq3ew+95
        6LjYk5kISIA/ABp8no4O2UjULdzlCM8=
X-Google-Smtp-Source: ABdhPJyjLxwwUI2WkN/SIFqW4R6NpORvq42Jaiaqmu4s+cBJ1EqTHmO7zvLrAAixbH93dH0dgR/dyQ==
X-Received: by 2002:a63:235b:: with SMTP id u27mr2344318pgm.129.1610548445583;
        Wed, 13 Jan 2021 06:34:05 -0800 (PST)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com. [209.85.214.182])
        by smtp.gmail.com with ESMTPSA id z3sm2771832pgs.61.2021.01.13.06.34.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 06:34:04 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d4so1170107plh.5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 06:34:02 -0800 (PST)
X-Received: by 2002:a67:bd0a:: with SMTP id y10mr2141127vsq.28.1610548441862;
 Wed, 13 Jan 2021 06:34:01 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <CAOEp5OejaX4ZETThrj4-n8_yZoeTZs56CBPHbQqNsR2oni8dWw@mail.gmail.com>
 <CAOEp5Oc5qif_krU8oC6qhq6X0xRW-9GpWrBzWgPw0WevyhT8Mg@mail.gmail.com>
 <CA+FuTSfhBZfEf8+LKNUJQpSxt8c5h1wMpARupekqFKuei6YBsA@mail.gmail.com> <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com>
In-Reply-To: <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 13 Jan 2021 09:33:25 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfJJhEYr6gXmjpjjXzg6Xm5wWa-dL1SEV-Zt7RcPXGztg@mail.gmail.com>
Message-ID: <CA+FuTSfJJhEYr6gXmjpjjXzg6Xm5wWa-dL1SEV-Zt7RcPXGztg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, rdunlap@infradead.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, decui@microsoft.com,
        cai@lca.pw, Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>, Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:11 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/13 =E4=B8=8A=E5=8D=887:47, Willem de Bruijn wrote:
> > On Tue, Jan 12, 2021 at 3:29 PM Yuri Benditovich
> > <yuri.benditovich@daynix.com> wrote:
> >> On Tue, Jan 12, 2021 at 9:49 PM Yuri Benditovich
> >> <yuri.benditovich@daynix.com> wrote:
> >>> On Tue, Jan 12, 2021 at 9:41 PM Yuri Benditovich
> >>> <yuri.benditovich@daynix.com> wrote:
> >>>> Existing TUN module is able to use provided "steering eBPF" to
> >>>> calculate per-packet hash and derive the destination queue to
> >>>> place the packet to. The eBPF uses mapped configuration data
> >>>> containing a key for hash calculation and indirection table
> >>>> with array of queues' indices.
> >>>>
> >>>> This series of patches adds support for virtio-net hash reporting
> >>>> feature as defined in virtio specification. It extends the TUN modul=
e
> >>>> and the "steering eBPF" as follows:
> >>>>
> >>>> Extended steering eBPF calculates the hash value and hash type, keep=
s
> >>>> hash value in the skb->hash and returns index of destination virtque=
ue
> >>>> and the type of the hash. TUN module keeps returned hash type in
> >>>> (currently unused) field of the skb.
> >>>> skb->__unused renamed to 'hash_report_type'.
> >>>>
> >>>> When TUN module is called later to allocate and fill the virtio-net
> >>>> header and push it to destination virtqueue it populates the hash
> >>>> and the hash type into virtio-net header.
> >>>>
> >>>> VHOST driver is made aware of respective virtio-net feature that
> >>>> extends the virtio-net header to report the hash value and hash repo=
rt
> >>>> type.
> >>> Comment from Willem de Bruijn:
> >>>
> >>> Skbuff fields are in short supply. I don't think we need to add one
> >>> just for this narrow path entirely internal to the tun device.
> >>>
> >> We understand that and try to minimize the impact by using an already
> >> existing unused field of skb.
> > Not anymore. It was repurposed as a flags field very recently.
> >
> > This use case is also very narrow in scope. And a very short path from
> > data producer to consumer. So I don't think it needs to claim scarce
> > bits in the skb.
> >
> > tun_ebpf_select_queue stores the field, tun_put_user reads it and
> > converts it to the virtio_net_hdr in the descriptor.
> >
> > tun_ebpf_select_queue is called from .ndo_select_queue.  Storing the
> > field in skb->cb is fragile, as in theory some code could overwrite
> > that between field between ndo_select_queue and
> > ndo_start_xmit/tun_net_xmit, from which point it is fully under tun
> > control again. But in practice, I don't believe anything does.
> >
> > Alternatively an existing skb field that is used only on disjoint
> > datapaths, such as ingress-only, could be viable.
>
>
> A question here. We had metadata support in XDP for cooperation between
> eBPF programs. Do we have something similar in the skb?
>
> E.g in the RSS, if we want to pass some metadata information between
> eBPF program and the logic that generates the vnet header (either hard
> logic in the kernel or another eBPF program). Is there any way that can
> avoid the possible conflicts of qdiscs?

Not that I am aware of. The closest thing is cb[].

It'll have to aliase a field like that, that is known unused for the given =
path.

One other approach that has been used within linear call stacks is out
of band. Like percpu variables softnet_data.xmit.more and
mirred_rec_level. But that is perhaps a bit overwrought for this use
case.

> >
> >>> Instead, you could just run the flow_dissector in tun_put_user if the
> >>> feature is negotiated. Indeed, the flow dissector seems more apt to m=
e
> >>> than BPF here. Note that the flow dissector internally can be
> >>> overridden by a BPF program if the admin so chooses.
> >>>
> >> When this set of patches is related to hash delivery in the virtio-net
> >> packet in general,
> >> it was prepared in context of RSS feature implementation as defined in
> >> virtio spec [1]
> >> In case of RSS it is not enough to run the flow_dissector in tun_put_u=
ser:
> >> in tun_ebpf_select_queue the TUN calls eBPF to calculate the hash,
> >> hash type and queue index
> >> according to the (mapped) parameters (key, hash types, indirection
> >> table) received from the guest.
> > TUNSETSTEERINGEBPF was added to support more diverse queue selection
> > than the default in case of multiqueue tun. Not sure what the exact
> > use cases are.
> >
> > But RSS is exactly the purpose of the flow dissector. It is used for
> > that purpose in the software variant RPS. The flow dissector
> > implements a superset of the RSS spec, and certainly computes a
> > four-tuple for TCP/IPv6. In the case of RPS, it is skipped if the NIC
> > has already computed a 4-tuple hash.
> >
> > What it does not give is a type indication, such as
> > VIRTIO_NET_HASH_TYPE_TCPv6. I don't understand how this would be used.
> > In datapaths where the NIC has already computed the four-tuple hash
> > and stored it in skb->hash --the common case for servers--, That type
> > field is the only reason to have to compute again.
>
>
> The problem is there's no guarantee that the packet comes from the NIC,
> it could be a simple VM2VM or host2VM packet.
>
> And even if the packet is coming from the NIC that calculates the hash
> there's no guarantee that it's the has that guest want (guest may use
> different RSS keys).

Ah yes, of course.

I would still revisit the need to store a detailed hash_type along with
the hash, as as far I can tell that conveys no actionable information
to the guest.
