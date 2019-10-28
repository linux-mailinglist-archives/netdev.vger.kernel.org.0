Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAEEE6F7E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 11:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388156AbfJ1KIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 06:08:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387884AbfJ1KIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 06:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572257332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BpDbywNaCDb3vLF/eHQmY1ae1u7iu+BzTbc3zMkDXW4=;
        b=eFSRlBkSkpO7nN3EmPyDFs4+z28MrjSoemyhZW6roSJHKRRI7DMsxg5b2QFlX6EKu/vMUy
        gsv6b+BW0JyFoFXmQYOROn2oqf83Yamp7feJyGfnpAOpZvXNGZrrzGJ2j9i1A74VQv2WCs
        QpH5k7rOnJiZMW+JeQ35QT1A4pdomKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-w_h-wWUxMkWF0Wcx2lo1rQ-1; Mon, 28 Oct 2019 06:08:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 950D1476;
        Mon, 28 Oct 2019 10:08:45 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8FB65C541;
        Mon, 28 Oct 2019 10:08:32 +0000 (UTC)
Date:   Mon, 28 Oct 2019 11:08:28 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
Message-ID: <20191028110828.512eb99c@carbon>
In-Reply-To: <87o8y1s1vn.fsf@toke.dk>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
        <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
        <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
        <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
        <87h840oese.fsf@toke.dk>
        <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch>
        <87sgniladm.fsf@toke.dk>
        <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
        <87zhhmrz7w.fsf@toke.dk>
        <47f1a7e2-0d3a-e324-20c5-ba3aed216ddf@gmail.com>
        <87o8y1s1vn.fsf@toke.dk>
Organization: Red Hat Inc.
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: w_h-wWUxMkWF0Wcx2lo1rQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 09:36:12 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> David Ahern <dsahern@gmail.com> writes:
>=20
> > On 10/27/19 9:21 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote: =20
> >> Rather, what we should be doing is exposing the functionality through
> >> helpers so XDP can hook into the data structures already present in th=
e
> >> kernel and make decisions based on what is contained there. We already
> >> have that for routing; L2 bridging, and some kind of connection
> >> tracking, are obvious contenders for similar additions. =20
> >
> > The way OVS is coded and expected to flow (ovs_vport_receive ->
> > ovs_dp_process_packet -> ovs_execute_actions -> do_execute_actions) I d=
o
> > not see any way to refactor it to expose a hook to XDP. But, if the use
> > case is not doing anything big with OVS (e.g., just ACLs and forwarding=
)
> > that is easy to replicate in XDP - but then that means duplicate data
> > and code. =20
>=20
> Yeah, I didn't mean that part for OVS, that was a general comment for
> reusing kernel functionality.
>=20
> > Linux bridge on the other hand seems fairly straightforward to
> > refactor. One helper is needed to convert ingress <port,mac,vlan> to
> > an L2 device (and needs to consider stacked devices) and then a second
> > one to access the fdb for that device. =20
>=20
> Why not just a single lookup like what you did for routing? Not too
> familiar with the routing code...

I'm also very interested in hearing more about how we can create an XDP
bridge lookup BPF-helper...


> > Either way, bypassing the bridge has mixed results: latency improves
> > but throughput takes a hit (no GRO). =20
>=20
> Well, for some traffic mixes XDP should be able to keep up without GRO.
> And longer term, we probably want to support GRO with XDP anyway

Do you have any numbers to back up your expected throughput decrease,
due to lack of GRO?  Or is it a theory?

GRO mainly gains performance due to the bulking effect.  XDP redirect
also have bulking.  For bridging, I would claim that XDP redirect
bulking works better, because it does bulking based on egress
net_device. (Even for intermixed packets per NAPI budget).  You might
worry that XDP will do a bridge-lookup per frame, but as the likely fit
in the CPU I-cache, then this will have very little effect.


> (I believe Jesper has plans for supporting bigger XDP frames)...

Yes [1], but it's orthogonal and mostly that to support HW features,
like TSO, jumbo-frames, packet header split.

 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-=
multi-buffer01-design.org
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

