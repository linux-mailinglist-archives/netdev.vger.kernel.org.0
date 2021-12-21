Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361E747C91B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 23:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhLUWNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 17:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbhLUWNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 17:13:20 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8D3C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 14:13:19 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id b77so146419vka.11
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 14:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vM8VgcoxLDfDIf7FCAnC13av05TsIvh/3jkSUgs5TQU=;
        b=oeR+lg6HsOP+onH1k1WWTSqep4A74MKLqSklmpBcih5teIG+zlSZEBPIPCi5QBRWL4
         6tQlGn2OEq7hW6PO4pHeUKIXvjM1tAg0VS2UXinLcdQZ57+V3FiqaXuQ6HbYQrqMuw1l
         7Er5lsoKHhD+z0wvjTOLk6/F/63OgXlyJRmHYwjN6jKL3uhbXMkwGMkQf/vs9ClmVDJi
         pKIAEm1HwLPNtYKGmwxmwoQ9y49CIIb1shGhLcgirFJs8banB5/bOOGsdQl+2zppl96z
         VjhfCdKQw5R5oPFHBRFRNSR1Ul2LS6FbGavesbmGW5TC5pHGhAVR5P5/s+zw4eTAX0AC
         IeEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vM8VgcoxLDfDIf7FCAnC13av05TsIvh/3jkSUgs5TQU=;
        b=Ola7p7HqP1zv5vfUz90YZbHgbGlIFauKm9bID4Bi3a98d3KGH9YMamlkPxF3hSmOo8
         wN+ACvFZmAHuY4aL1jxw4Lz3D3pfVrG4YL73MqknjnTBikGy3v0fStZ73UlqFY4ATPQe
         70lT5jvD10rwmDuHllHAvr9q3MlywxCpKIJcq/exc7qCt/kK13MYNbxA90Udsz+6iT7y
         T+u1c8oYJ7V27uj3yuYDPM1W2GfnwiVy/iObwVTO7Io3Fdag6H79+Epp9AsUzTMyDFyT
         uFw6nfOQvs2M8BUle1RVGbj1ySGEtJR+3fpF9qp/X/0qmC+ie5pLzG0S5WGIptIzqP/N
         kGTA==
X-Gm-Message-State: AOAM533svvH2NmVgxSucsKl44y68dnEBLrtQbzJjo9j0qPxGVU+DdjQ9
        eqSzDfGhUEwi6DhtYDErZNeooZKtDgLW3as3rso0+w==
X-Google-Smtp-Source: ABdhPJxXTeGuW+KIKQRbAy+VieqCf3aAbSq0ZgDPQbCrlRWXj+whAhsXfDHrOw48OtF7eYylxL3DzxQrVWq/Yn7kSx8=
X-Received: by 2002:a05:6122:21a6:: with SMTP id j38mr60425vkd.39.1640124798797;
 Tue, 21 Dec 2021 14:13:18 -0800 (PST)
MIME-Version: 1.0
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com> <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CANP3RGeNVSwSfb9T_6Xp8GyggbwnY7YQjv1Fw5L2wTtqiFJbpw@mail.gmail.com> <20211221215227.4kpw65oeusfskenx@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211221215227.4kpw65oeusfskenx@kafai-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 21 Dec 2021 14:13:04 -0800
Message-ID: <CANP3RGdbYsue7xiYgVavnq2ysg6N6bWpFKnHxg4YkpQF9gv4oA@mail.gmail.com>
Subject: Re: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 1:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> On Tue, Dec 21, 2021 at 11:46:40AM -0800, Maciej =C5=BBenczykowski wrote:
> > On Tue, Dec 21, 2021 at 11:16 AM Tyler Wear (QUIC)
> > <quic_twear@quicinc.com> wrote:
> > > > On Mon, Dec 20, 2021 at 07:18:42PM -0800, Yonghong Song wrote:
> > > > > On 12/20/21 12:40 PM, Tyler Wear wrote:
> > > > > > New bpf helper function BPF_FUNC_skb_change_dsfield "int
> > > > > > bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)"=
.
> > > > > > BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can be
> > > > > > attached to the ingress and egress path. The helper is needed
> > > > > > because this type of bpf_prog cannot modify the skb directly.
> > > > > >
> > > > > > Used by a bpf_prog to specify DS field values on egress or ingr=
ess.
> > > > >
> > > > > Maybe you can expand a little bit here for your use case?
> > > > > I know DS field might help but a description of your actual use c=
ase
> > > > > will make adding this helper more compelling.
> > > > +1.  More details on the use case is needed.
> > > > Also, having an individual helper for each particular header field =
is too specific.
> > > >
> > > > For egress, there is bpf_setsockopt() for IP_TOS and IPV6_TCLASS an=
d it can be called in other cgroup hooks. e.g.
> > > > BPF_PROG_TYPE_SOCK_OPS during tcp ESTABLISHED event.
> > > > There is an example in tools/testing/selftests/bpf/progs/test_tcpbp=
f_kern.c.
> > > > Is it enough for egress?
> > >
> > > Using bpf_setsockopt() has 2 issues: 1) it changes the userspace visi=
ble state 2) won't work with udp sendmsg cmsg
> >
> > Right, so to clarify since I've been working with Tyler on a project
> > of which this patch is a small component.
> > Note, I may be wrong here, I don't fully understand how all of this
> > works... but:
> >
> > ad 1) AFAIK if bpf calls bpf_setsockopt on the socket in question,
> > then userspace's view of the socket settings via
> > getsockopt(IP_TOS/IPV6_TCLASS) will also be affected - this may be
> > undesirable (it's technically userspace visible change in behaviour
> > and could, as unlikely as it is, lead to application misbehaviour).
> > This can be worked around via also overriding getsockopt/setsockopt
> > with bpf, but then you need to store the value to return to userspace
> > somewhere... AFAICT it all ends up being pretty ugly and very complex.
> CGROUP_(SET|GET)SOCKOPT is created for that.
> The user's value can be stored in bpf_sk_storage.

Yes, it can be done, it's very complex to do so.

The policy can change during run time (indeed that's probably a
relatively likely situation,
network gear notices a new high bandwidth connection and provides out
of band feedback
that it should be using a different dscp code point - we probably
don't want the full policy to
be present in the device because it might be a huge number of entries,
with wildcards).

> > I wouldn't be worried about needing to override each individual field,
> > as the only other field that looks likely to be potentially beneficial
> > to override would be the ipv6 flowlabel.
> >
> > ad 2) I don't think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) approach
> > works for packets generated via udp sendmsg where cmsg is being used
> > to set tos.
> There is CGROUP_UDP[4|6]_SENDMSG.  Right now, it can only change the addr=
.
> tos/tclass support could be added.

It could, that doesn't seem easier to do than this approach though.

> > 3) I also think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) might be too
> > late, since it would be in response to an already built packet, and
> > would thus presumably only take effect on the next packet, and not for
> > this one, no?
> The bpf_setsockopt can be called in bind and connect.
> Is it not early enough?

It depends, it's actually too early in some cases.  The information
may come post connect.

Worst case the actual dscp marking to use could potentially even be
dynamic, for example tcp pure acks
should use one value, while tcp data packets another (not saying this
is a good idea,
but I've seen hw implementations of pure ack prioritization...)

> > Technically this could be done by attaching the programs to tc egress
> > instead of the cgroup hook, but then it's per interface, which is
> > potentially the wrong granularity...

> Right, there is advantage to do it at higher layer,
> and earlier also.
>
> If the tos/tclass value can be changed early on, the correct
> ip[6] header can be written at the beginning instead
> of redoing it later and need to worry about the skb_clone_writable(),
> rewriting it, do iph->check..etc.

I would indeed like it if we could decouple what userspace wants,
from what the kernel/network actually uses.  There would need to be
some sort of bpf hook,
that takes a socket/flow and returns the tos/dscp to actually use
(based on 5-tuple and other information).

But again, this would be *much* more complex.

> > As for what is driving this?  Upcoming wifi standard to allow access
> > points to inform client devices how to dscp mark individual flows.
> Interesting.
>
> How does the sending host get this dscp value from wifi
> and then affect the dscp of a particular flow?  Is the dscp
> going to be stored in a bpf map for the bpf prog to use?

It gets it out of band via some wifi signaling mechanism.
Tyler probably knows the details.

Storing flow match information to dscp mapping in a bpf map is indeed the p=
lan.

> Are you testing on TCP also?
>
> > As for the patch itself, I wonder if the return value shouldn't be
> > reversed, currently '1 if the DS field is set, 0 if it is not set.'
> > But I think returning 0 on success and an error on failure is more in
> > line with what other bpf helpers do?
> > OTOH, it does match bpf_skb_ecn_set_ce() returning 0 on failure...

> If adding a helper , how about making the bpf_skb_store_bytes()
> available to BPF_PROG_TYPE_CGROUP_SKB?  Then it will be
> more flexible to change other fields in the future in
> the network and transport header.

I assume there's some reason why it's not available?
