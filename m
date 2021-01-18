Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651D32F9CF4
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbhARKiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388384AbhARJKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 04:10:18 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E4CC061757
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 01:09:38 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id 15so17025355oix.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 01:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iyUr2EgGCnuUt3y/cH5aSG2HAJUp7cXdt4Nx2pCWr4g=;
        b=f96HLZybXBomHbZjfEeNmJfwR7umLve2pIoZYj8ptkr7OnfTAZSmefAMbptggGDL+Y
         Hh+9FqZiBM7aGgoRouxrrpMU2OXZAQdiAZWbbaQ8V9ZRhFj3u5a3mStCS39mgHe9u/JZ
         oQozomJNhiNp+gYoptW5Jjbz8P1vQ5U6SOOOg+PAlWJaRIRvanoGNN7P3rW7Vn9Tjbcv
         0s6nrL9ZNz9crr4I3Fr4P55rirCZ5shFGuehsTFV7q1MbQLVckyULHmp7EezU9XCrfIn
         8SSr+eXCN2hoXazKGk4OUvpa37tSYZ3y2UftBLhoVgv9DmwaOPEJ4iTkP5ch8Xqd9wox
         9KDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iyUr2EgGCnuUt3y/cH5aSG2HAJUp7cXdt4Nx2pCWr4g=;
        b=VzWgarEVnPPPrtSZFr/rI0AKUh/rZfMi84OTK8T5idnFuGvynyLGBbHjaDelrV9xAH
         vwJ8DaCN+747NE7iCihxLL1w1+V2cChFAVXtt36hKaTlanp7F1mukUgyfqNFRgN+yPaD
         5QkqzntGGiDZBWaFyzE2eQ6Fr4VdpkarjQdisDAOMnS5OeBpy2JxmG20HnFO5wc41rEL
         Hn2PGmFvw9DCgE5U68CPlkD0b341a1nWv/2VPLeDusFwBEs4YMWpi72jRmg+hDqEm9Va
         /SmS8yvIYGw2fHbmFLpUVbGioeAuSXYu6kmpwW3QADCNJySuB2M2F0q2d2zHpExMys/4
         qkJQ==
X-Gm-Message-State: AOAM530pBFelLWwChD9VcpyAvZxko3cFF3/JfhMoNCca0IA+1I0VK7QL
        yklWnj/742fJuMyjhbcT4SFHbYtfmNQM52B/tAImcQ==
X-Google-Smtp-Source: ABdhPJw+2U7EkClEvBeCT04KoyygELeG+nZn5vZo4Y3LdmCElyqZrbLg/iChUH/U5QQp5D9OHKiE/L47zsMpHxGJEZc=
X-Received: by 2002:aca:cc03:: with SMTP id c3mr2345722oig.137.1610960976993;
 Mon, 18 Jan 2021 01:09:36 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <CAOEp5OejaX4ZETThrj4-n8_yZoeTZs56CBPHbQqNsR2oni8dWw@mail.gmail.com>
 <CAOEp5Oc5qif_krU8oC6qhq6X0xRW-9GpWrBzWgPw0WevyhT8Mg@mail.gmail.com>
 <CA+FuTSfhBZfEf8+LKNUJQpSxt8c5h1wMpARupekqFKuei6YBsA@mail.gmail.com>
 <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com> <CA+FuTSfJJhEYr6gXmjpjjXzg6Xm5wWa-dL1SEV-Zt7RcPXGztg@mail.gmail.com>
 <8ea218a8-a068-1ed9-929d-67ad30111c3c@redhat.com> <CAOEp5OfyHz2rXHmOeojNNE2wvrHMn_z1egr5aGQborEq829TLw@mail.gmail.com>
 <65fe1a40-abc0-77ed-56df-3f0a70615016@redhat.com>
In-Reply-To: <65fe1a40-abc0-77ed-56df-3f0a70615016@redhat.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Mon, 18 Jan 2021 11:09:25 +0200
Message-ID: <CAOEp5Oe4TcOukJa+OGj-ynfMMrZC=_YQDpzSC9_9p+UXSH7hmg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
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

On Mon, Jan 18, 2021 at 4:46 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/17 =E4=B8=8B=E5=8D=883:57, Yuri Benditovich wrote:
> > On Thu, Jan 14, 2021 at 5:39 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/1/13 =E4=B8=8B=E5=8D=8810:33, Willem de Bruijn wrote:
> >>> On Tue, Jan 12, 2021 at 11:11 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>> On 2021/1/13 =E4=B8=8A=E5=8D=887:47, Willem de Bruijn wrote:
> >>>>> On Tue, Jan 12, 2021 at 3:29 PM Yuri Benditovich
> >>>>> <yuri.benditovich@daynix.com> wrote:
> >>>>>> On Tue, Jan 12, 2021 at 9:49 PM Yuri Benditovich
> >>>>>> <yuri.benditovich@daynix.com> wrote:
> >>>>>>> On Tue, Jan 12, 2021 at 9:41 PM Yuri Benditovich
> >>>>>>> <yuri.benditovich@daynix.com> wrote:
> >>>>>>>> Existing TUN module is able to use provided "steering eBPF" to
> >>>>>>>> calculate per-packet hash and derive the destination queue to
> >>>>>>>> place the packet to. The eBPF uses mapped configuration data
> >>>>>>>> containing a key for hash calculation and indirection table
> >>>>>>>> with array of queues' indices.
> >>>>>>>>
> >>>>>>>> This series of patches adds support for virtio-net hash reportin=
g
> >>>>>>>> feature as defined in virtio specification. It extends the TUN m=
odule
> >>>>>>>> and the "steering eBPF" as follows:
> >>>>>>>>
> >>>>>>>> Extended steering eBPF calculates the hash value and hash type, =
keeps
> >>>>>>>> hash value in the skb->hash and returns index of destination vir=
tqueue
> >>>>>>>> and the type of the hash. TUN module keeps returned hash type in
> >>>>>>>> (currently unused) field of the skb.
> >>>>>>>> skb->__unused renamed to 'hash_report_type'.
> >>>>>>>>
> >>>>>>>> When TUN module is called later to allocate and fill the virtio-=
net
> >>>>>>>> header and push it to destination virtqueue it populates the has=
h
> >>>>>>>> and the hash type into virtio-net header.
> >>>>>>>>
> >>>>>>>> VHOST driver is made aware of respective virtio-net feature that
> >>>>>>>> extends the virtio-net header to report the hash value and hash =
report
> >>>>>>>> type.
> >>>>>>> Comment from Willem de Bruijn:
> >>>>>>>
> >>>>>>> Skbuff fields are in short supply. I don't think we need to add o=
ne
> >>>>>>> just for this narrow path entirely internal to the tun device.
> >>>>>>>
> >>>>>> We understand that and try to minimize the impact by using an alre=
ady
> >>>>>> existing unused field of skb.
> >>>>> Not anymore. It was repurposed as a flags field very recently.
> >>>>>
> >>>>> This use case is also very narrow in scope. And a very short path f=
rom
> >>>>> data producer to consumer. So I don't think it needs to claim scarc=
e
> >>>>> bits in the skb.
> >>>>>
> >>>>> tun_ebpf_select_queue stores the field, tun_put_user reads it and
> >>>>> converts it to the virtio_net_hdr in the descriptor.
> >>>>>
> >>>>> tun_ebpf_select_queue is called from .ndo_select_queue.  Storing th=
e
> >>>>> field in skb->cb is fragile, as in theory some code could overwrite
> >>>>> that between field between ndo_select_queue and
> >>>>> ndo_start_xmit/tun_net_xmit, from which point it is fully under tun
> >>>>> control again. But in practice, I don't believe anything does.
> >>>>>
> >>>>> Alternatively an existing skb field that is used only on disjoint
> >>>>> datapaths, such as ingress-only, could be viable.
> >>>> A question here. We had metadata support in XDP for cooperation betw=
een
> >>>> eBPF programs. Do we have something similar in the skb?
> >>>>
> >>>> E.g in the RSS, if we want to pass some metadata information between
> >>>> eBPF program and the logic that generates the vnet header (either ha=
rd
> >>>> logic in the kernel or another eBPF program). Is there any way that =
can
> >>>> avoid the possible conflicts of qdiscs?
> >>> Not that I am aware of. The closest thing is cb[].
> >>>
> >>> It'll have to aliase a field like that, that is known unused for the =
given path.
> >>
> >> Right, we need to make sure cb is not used by other ones. I'm not sure
> >> how hard to achieve that consider Qemu installs the eBPF program but i=
t
> >> doesn't deal with networking configurations.
> >>
> >>
> >>> One other approach that has been used within linear call stacks is ou=
t
> >>> of band. Like percpu variables softnet_data.xmit.more and
> >>> mirred_rec_level. But that is perhaps a bit overwrought for this use
> >>> case.
> >>
> >> Yes, and if we go that way then eBPF turns out to be a burden since we
> >> need to invent helpers to access those auxiliary data structure. It
> >> would be better then to hard-coded the RSS in the kernel.
> >>
> >>
> >>>>>>> Instead, you could just run the flow_dissector in tun_put_user if=
 the
> >>>>>>> feature is negotiated. Indeed, the flow dissector seems more apt =
to me
> >>>>>>> than BPF here. Note that the flow dissector internally can be
> >>>>>>> overridden by a BPF program if the admin so chooses.
> >>>>>>>
> >>>>>> When this set of patches is related to hash delivery in the virtio=
-net
> >>>>>> packet in general,
> >>>>>> it was prepared in context of RSS feature implementation as define=
d in
> >>>>>> virtio spec [1]
> >>>>>> In case of RSS it is not enough to run the flow_dissector in tun_p=
ut_user:
> >>>>>> in tun_ebpf_select_queue the TUN calls eBPF to calculate the hash,
> >>>>>> hash type and queue index
> >>>>>> according to the (mapped) parameters (key, hash types, indirection
> >>>>>> table) received from the guest.
> >>>>> TUNSETSTEERINGEBPF was added to support more diverse queue selectio=
n
> >>>>> than the default in case of multiqueue tun. Not sure what the exact
> >>>>> use cases are.
> >>>>>
> >>>>> But RSS is exactly the purpose of the flow dissector. It is used fo=
r
> >>>>> that purpose in the software variant RPS. The flow dissector
> >>>>> implements a superset of the RSS spec, and certainly computes a
> >>>>> four-tuple for TCP/IPv6. In the case of RPS, it is skipped if the N=
IC
> >>>>> has already computed a 4-tuple hash.
> >>>>>
> >>>>> What it does not give is a type indication, such as
> >>>>> VIRTIO_NET_HASH_TYPE_TCPv6. I don't understand how this would be us=
ed.
> >>>>> In datapaths where the NIC has already computed the four-tuple hash
> >>>>> and stored it in skb->hash --the common case for servers--, That ty=
pe
> >>>>> field is the only reason to have to compute again.
> >>>> The problem is there's no guarantee that the packet comes from the N=
IC,
> >>>> it could be a simple VM2VM or host2VM packet.
> >>>>
> >>>> And even if the packet is coming from the NIC that calculates the ha=
sh
> >>>> there's no guarantee that it's the has that guest want (guest may us=
e
> >>>> different RSS keys).
> >>> Ah yes, of course.
> >>>
> >>> I would still revisit the need to store a detailed hash_type along wi=
th
> >>> the hash, as as far I can tell that conveys no actionable information
> >>> to the guest.
> >>
> >> Yes, need to figure out its usage. According to [1], it only mention
> >> that storing has type is a charge of driver. Maybe Yuri can answer thi=
s.
> >>
> > For the case of Windows VM we can't know how exactly the network stack
> > uses provided hash data (including hash type). But: different releases
> > of Windows
> > enable different hash types (for example UDP hash is enabled only on
> > Server 2016 and up).
> >
> > Indeed the Windows requires a little more from the network adapter/driv=
er
> > than Linux does.
> >
> > The addition of RSS support to virtio specification takes in account
> > the widest set of
> > requirements (i.e. Windows one), our initial impression is that this
> > should be enough also for Linux.
> >
> > The NDIS specification in part of RSS is _mandatory_ and there are
> > certification tests
> > that check that the driver provides the hash data as expected. All the
> > high-performance
> > network adapters have such RSS functionality in the hardware.
> > With pre-RSS QEMU (i.e. where the virtio-net device does not indicate
> > the RSS support)
> > the virtio-net driver for Windows does all the job related to RSS:
> > - hash calculation
> > - hash/hash_type delivery
> > - reporting each packet on the correct CPU according to RSS settings
> >
> > With RSS support in QEMU all the packets always come on a proper CPU an=
d
> > the driver never needs to reschedule them. The driver still need to
> > calculate the
> > hash and report it to Windows. In this case we do the same job twice: t=
he device
> > (QEMU or eBPF) does calculate the hash and get proper queue/CPU to deli=
ver
> > the packet. But the hash is not delivered by the device, so the driver =
needs to
> > recalculate it and report to the Windows.
> >
> > If we add HASH_REPORT support (current set of patches) and the device
> > indicates this
> > feature we can avoid hash recalculation in the driver assuming we
> > receive the correct hash
> > value and hash type. Otherwise the driver can't know which exactly
> > hash the device has calculated.
> >
> > Please let me know if I did not answer the question.
>
>
> I think I get you. The hash type is also a kind of classification (e.g
> TCP or UDP). Any possibility that it can be deduced from the driver? (Or
> it could be too expensive to do that).
>
The driver does it today (when the device does not offer any features)
and of course can continue doing it.
IMO if the device can't report the data according to the spec it
should not indicate support for the respective feature (or fallback to
vhost=3Doff).
Again, IMO if Linux does not need the exact hash_type we can use (for
Linux) the way that Willem de Brujin suggested in his patchset:
- just add VIRTIO_NET_HASH_REPORT_L4 to the spec
- Linux can use MQ + hash delivery (and use VIRTIO_NET_HASH_REPORT_L4)
- Linux can use (if makes sense) RSS with VIRTIO_NET_HASH_REPORT_L4 and eBP=
F
- Windows gets what it needs + eBPF
So, everyone has what they need at the respective cost.

Regarding use of skb->cb for hash type:
Currently, if I'm not mistaken, there are 2 bytes at the end of skb->cb:
skb->cb is 48 bytes array
There is skb_gso_cb (14 bytes) at offset SKB_GSO_CB_OFFSET(32)
Is it possible to use one of these 2 bytes for hash_type?
If yes, shall we extend the skb_gso_cb and place the 1-bytes hash_type
in it or just emit compilation error if the skb_gso_cb grows beyond 15
bytes?


> Thanks
>
>
> >
> >> Thanks
> >>
> >> [1]
> >> https://docs.microsoft.com/en-us/windows-hardware/drivers/network/indi=
cating-rss-receive-data
> >>
> >>
>
