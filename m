Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6070D2F9149
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbhAQH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 02:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbhAQH6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 02:58:41 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB777C061573
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 23:57:59 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id o11so13214250ote.4
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 23:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VESx0q50uHif31i5KEl5hWIvCIRQQNFTAOMGoAM4sHk=;
        b=dowfzTW23mQmJth/93y3cwCyGyvAl+fFqQcvXECxcGq8jo5zaQkT722+738BfC0A14
         Bsqd/ozm5BiNtKsHXJ5UDIa7Wfm31hW52j0wVk/7WFwHHDzt1eytW0ilYs1zsM5BMX7s
         t1nLNTzQDYtxUd/eiOB+foBYE4wfdrR00TKQgH+31X2W7aLhZPfvJR4go5ov7vm4hlh+
         814jWwD7JM8JKTkGOMTEvwqXRqGSJC9Z16hI/+aYhFdXlqRtovk9JT9kkHGl5VyDVRY2
         DewWaIsAU0QFt3CgW6rxqv0Qz3cazUlkFC55+YDczF0e0pq3KuAN2Y+g7PvU+9NnN9hd
         t2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VESx0q50uHif31i5KEl5hWIvCIRQQNFTAOMGoAM4sHk=;
        b=EXgOkCewY1q0OvAl0A0pfMYoYZQiSB8Z3pUtjVDpCT3VB5+kNmmHUvvFbU7tylawJf
         w05UKzZ/KVEh62Br6Zr9HD0+2zYq9Siutq8+qfzUvvxVMSgAWzA3RywMedOeK1k0GAWV
         6Krf44wcRnLujlUKL/SuwAePQ2n08J7Qjbj3UVKeekmjZIirxdDRtlzRDceXt8Bvgsby
         HsUtzxnDabgT1Hn8E5xklFgODOuOOGy7ldHTrTIBGvOkOvyQEgzRqO1gjSGYpdD6kCIt
         +X+OVZA7EPjD0OwzV49oR9lUHobT9kOqm5jEYCDmiqp0kDjEmspmV0oixNA++yTjkNPt
         YQmg==
X-Gm-Message-State: AOAM531cPHHs7Wyrhz7EON+fkev924ua25QcXgl/AG9WTp3cbPA5hLAd
        XqfdSREvSVW1yJjX3EcjlmUQBXLizs4jnPj6HMOuyw==
X-Google-Smtp-Source: ABdhPJw72h9Qq08nM/YnqFoYtJLR5CwoCt5GmjOdfecQ7OjxFIthON9NM5A1BUKUsEtaY5OOl0Rzt3RdzKkeCVJhpec=
X-Received: by 2002:a9d:4715:: with SMTP id a21mr14710269otf.220.1610870278976;
 Sat, 16 Jan 2021 23:57:58 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <CAOEp5OejaX4ZETThrj4-n8_yZoeTZs56CBPHbQqNsR2oni8dWw@mail.gmail.com>
 <CAOEp5Oc5qif_krU8oC6qhq6X0xRW-9GpWrBzWgPw0WevyhT8Mg@mail.gmail.com>
 <CA+FuTSfhBZfEf8+LKNUJQpSxt8c5h1wMpARupekqFKuei6YBsA@mail.gmail.com>
 <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com> <CA+FuTSfJJhEYr6gXmjpjjXzg6Xm5wWa-dL1SEV-Zt7RcPXGztg@mail.gmail.com>
 <8ea218a8-a068-1ed9-929d-67ad30111c3c@redhat.com>
In-Reply-To: <8ea218a8-a068-1ed9-929d-67ad30111c3c@redhat.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Sun, 17 Jan 2021 09:57:47 +0200
Message-ID: <CAOEp5OfyHz2rXHmOeojNNE2wvrHMn_z1egr5aGQborEq829TLw@mail.gmail.com>
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

On Thu, Jan 14, 2021 at 5:39 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/13 =E4=B8=8B=E5=8D=8810:33, Willem de Bruijn wrote:
> > On Tue, Jan 12, 2021 at 11:11 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> On 2021/1/13 =E4=B8=8A=E5=8D=887:47, Willem de Bruijn wrote:
> >>> On Tue, Jan 12, 2021 at 3:29 PM Yuri Benditovich
> >>> <yuri.benditovich@daynix.com> wrote:
> >>>> On Tue, Jan 12, 2021 at 9:49 PM Yuri Benditovich
> >>>> <yuri.benditovich@daynix.com> wrote:
> >>>>> On Tue, Jan 12, 2021 at 9:41 PM Yuri Benditovich
> >>>>> <yuri.benditovich@daynix.com> wrote:
> >>>>>> Existing TUN module is able to use provided "steering eBPF" to
> >>>>>> calculate per-packet hash and derive the destination queue to
> >>>>>> place the packet to. The eBPF uses mapped configuration data
> >>>>>> containing a key for hash calculation and indirection table
> >>>>>> with array of queues' indices.
> >>>>>>
> >>>>>> This series of patches adds support for virtio-net hash reporting
> >>>>>> feature as defined in virtio specification. It extends the TUN mod=
ule
> >>>>>> and the "steering eBPF" as follows:
> >>>>>>
> >>>>>> Extended steering eBPF calculates the hash value and hash type, ke=
eps
> >>>>>> hash value in the skb->hash and returns index of destination virtq=
ueue
> >>>>>> and the type of the hash. TUN module keeps returned hash type in
> >>>>>> (currently unused) field of the skb.
> >>>>>> skb->__unused renamed to 'hash_report_type'.
> >>>>>>
> >>>>>> When TUN module is called later to allocate and fill the virtio-ne=
t
> >>>>>> header and push it to destination virtqueue it populates the hash
> >>>>>> and the hash type into virtio-net header.
> >>>>>>
> >>>>>> VHOST driver is made aware of respective virtio-net feature that
> >>>>>> extends the virtio-net header to report the hash value and hash re=
port
> >>>>>> type.
> >>>>> Comment from Willem de Bruijn:
> >>>>>
> >>>>> Skbuff fields are in short supply. I don't think we need to add one
> >>>>> just for this narrow path entirely internal to the tun device.
> >>>>>
> >>>> We understand that and try to minimize the impact by using an alread=
y
> >>>> existing unused field of skb.
> >>> Not anymore. It was repurposed as a flags field very recently.
> >>>
> >>> This use case is also very narrow in scope. And a very short path fro=
m
> >>> data producer to consumer. So I don't think it needs to claim scarce
> >>> bits in the skb.
> >>>
> >>> tun_ebpf_select_queue stores the field, tun_put_user reads it and
> >>> converts it to the virtio_net_hdr in the descriptor.
> >>>
> >>> tun_ebpf_select_queue is called from .ndo_select_queue.  Storing the
> >>> field in skb->cb is fragile, as in theory some code could overwrite
> >>> that between field between ndo_select_queue and
> >>> ndo_start_xmit/tun_net_xmit, from which point it is fully under tun
> >>> control again. But in practice, I don't believe anything does.
> >>>
> >>> Alternatively an existing skb field that is used only on disjoint
> >>> datapaths, such as ingress-only, could be viable.
> >>
> >> A question here. We had metadata support in XDP for cooperation betwee=
n
> >> eBPF programs. Do we have something similar in the skb?
> >>
> >> E.g in the RSS, if we want to pass some metadata information between
> >> eBPF program and the logic that generates the vnet header (either hard
> >> logic in the kernel or another eBPF program). Is there any way that ca=
n
> >> avoid the possible conflicts of qdiscs?
> > Not that I am aware of. The closest thing is cb[].
> >
> > It'll have to aliase a field like that, that is known unused for the gi=
ven path.
>
>
> Right, we need to make sure cb is not used by other ones. I'm not sure
> how hard to achieve that consider Qemu installs the eBPF program but it
> doesn't deal with networking configurations.
>
>
> >
> > One other approach that has been used within linear call stacks is out
> > of band. Like percpu variables softnet_data.xmit.more and
> > mirred_rec_level. But that is perhaps a bit overwrought for this use
> > case.
>
>
> Yes, and if we go that way then eBPF turns out to be a burden since we
> need to invent helpers to access those auxiliary data structure. It
> would be better then to hard-coded the RSS in the kernel.
>
>
> >
> >>>>> Instead, you could just run the flow_dissector in tun_put_user if t=
he
> >>>>> feature is negotiated. Indeed, the flow dissector seems more apt to=
 me
> >>>>> than BPF here. Note that the flow dissector internally can be
> >>>>> overridden by a BPF program if the admin so chooses.
> >>>>>
> >>>> When this set of patches is related to hash delivery in the virtio-n=
et
> >>>> packet in general,
> >>>> it was prepared in context of RSS feature implementation as defined =
in
> >>>> virtio spec [1]
> >>>> In case of RSS it is not enough to run the flow_dissector in tun_put=
_user:
> >>>> in tun_ebpf_select_queue the TUN calls eBPF to calculate the hash,
> >>>> hash type and queue index
> >>>> according to the (mapped) parameters (key, hash types, indirection
> >>>> table) received from the guest.
> >>> TUNSETSTEERINGEBPF was added to support more diverse queue selection
> >>> than the default in case of multiqueue tun. Not sure what the exact
> >>> use cases are.
> >>>
> >>> But RSS is exactly the purpose of the flow dissector. It is used for
> >>> that purpose in the software variant RPS. The flow dissector
> >>> implements a superset of the RSS spec, and certainly computes a
> >>> four-tuple for TCP/IPv6. In the case of RPS, it is skipped if the NIC
> >>> has already computed a 4-tuple hash.
> >>>
> >>> What it does not give is a type indication, such as
> >>> VIRTIO_NET_HASH_TYPE_TCPv6. I don't understand how this would be used=
.
> >>> In datapaths where the NIC has already computed the four-tuple hash
> >>> and stored it in skb->hash --the common case for servers--, That type
> >>> field is the only reason to have to compute again.
> >>
> >> The problem is there's no guarantee that the packet comes from the NIC=
,
> >> it could be a simple VM2VM or host2VM packet.
> >>
> >> And even if the packet is coming from the NIC that calculates the hash
> >> there's no guarantee that it's the has that guest want (guest may use
> >> different RSS keys).
> > Ah yes, of course.
> >
> > I would still revisit the need to store a detailed hash_type along with
> > the hash, as as far I can tell that conveys no actionable information
> > to the guest.
>
>
> Yes, need to figure out its usage. According to [1], it only mention
> that storing has type is a charge of driver. Maybe Yuri can answer this.
>

For the case of Windows VM we can't know how exactly the network stack
uses provided hash data (including hash type). But: different releases
of Windows
enable different hash types (for example UDP hash is enabled only on
Server 2016 and up).

Indeed the Windows requires a little more from the network adapter/driver
than Linux does.

The addition of RSS support to virtio specification takes in account
the widest set of
requirements (i.e. Windows one), our initial impression is that this
should be enough also for Linux.

The NDIS specification in part of RSS is _mandatory_ and there are
certification tests
that check that the driver provides the hash data as expected. All the
high-performance
network adapters have such RSS functionality in the hardware.
With pre-RSS QEMU (i.e. where the virtio-net device does not indicate
the RSS support)
the virtio-net driver for Windows does all the job related to RSS:
- hash calculation
- hash/hash_type delivery
- reporting each packet on the correct CPU according to RSS settings

With RSS support in QEMU all the packets always come on a proper CPU and
the driver never needs to reschedule them. The driver still need to
calculate the
hash and report it to Windows. In this case we do the same job twice: the d=
evice
(QEMU or eBPF) does calculate the hash and get proper queue/CPU to deliver
the packet. But the hash is not delivered by the device, so the driver need=
s to
recalculate it and report to the Windows.

If we add HASH_REPORT support (current set of patches) and the device
indicates this
feature we can avoid hash recalculation in the driver assuming we
receive the correct hash
value and hash type. Otherwise the driver can't know which exactly
hash the device has calculated.

Please let me know if I did not answer the question.

> Thanks
>
> [1]
> https://docs.microsoft.com/en-us/windows-hardware/drivers/network/indicat=
ing-rss-receive-data
>
>
> >
>
