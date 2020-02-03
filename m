Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C65151241
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 23:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBCWPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 17:15:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726278AbgBCWPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 17:15:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580768124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OuiLcmdricrWzGWAwliznlzVTSee++iT6koFmwZwh8c=;
        b=UHx+C3WzOhWwr0RBlPmio5+7qj7zkcvDtLwSf2cMI2YD3jRuZhmaPkDAxTO0/Jtojkzbax
        ZBbooSw2ZsRszOWB9lllveiCzUXk39hIXLUD1ZM1+viS4R0KMkBAHPy12/MyFUyR1Ulgn7
        BcpGvwzlYjDV6tUw9luytATkncSq00E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-SI5VMMVnOA25bAzhnWtkHA-1; Mon, 03 Feb 2020 17:15:21 -0500
X-MC-Unique: SI5VMMVnOA25bAzhnWtkHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 826E2477;
        Mon,  3 Feb 2020 22:15:18 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9372919C58;
        Mon,  3 Feb 2020 22:15:04 +0000 (UTC)
Date:   Mon, 3 Feb 2020 23:15:03 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>, brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200203231503.24eec7f0@carbon>
In-Reply-To: <87zhdzbfa3.fsf@toke.dk>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
        <20200127061623.1cf42cd0@cakuba>
        <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
        <20200128055752.617aebc7@cakuba>
        <87ftfue0mw.fsf@toke.dk>
        <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
        <87sgjucbuf.fsf@toke.dk>
        <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
        <87zhdzbfa3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 03 Feb 2020 21:13:24 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Oops, I see I forgot to reply to this bit:
>=20
> >> Yeah, but having the low-level details available to the XDP program
> >> (such as HW queue occupancy for the egress hook) is one of the benefits
> >> of XDP, isn't it? =20
> >
> > I think I glossed over the hope for having access to HW queue occupancy
> > - what exactly are you after?=20
> >
> > I don't think one can get anything beyond a BQL type granularity.
> > Reading over PCIe is out of question, device write back on high
> > granularity would burn through way too much bus throughput. =20
>=20
> This was Jesper's idea originally, so maybe he can explain better; but
> as I understood it, he basically wanted to expose the same information
> that BQL has to eBPF. Making it possible for an eBPF program to either
> (re-)implement BQL with its own custom policy, or react to HWQ pressure
> in some other way, such as by load balancing to another interface.

Yes, and I also have plans that goes beyond BQL. But let me start with
explaining the BQL part, and answer Toke's question below.

On Mon, 03 Feb 2020 20:56:03 +0100 Toke wrote:
> [...] Hmm, I wonder if a TX driver hook is enough?

Short answer is no, a TX driver hook is not enough.  The queue state
info the TX driver hook have access to, needs to be updated once the
hardware have "confirmed" the TX-DMA operation have completed.  For
BQL/DQL this update happens during TX-DMA completion/cleanup (code
see call sites for netdev_tx_completed_queue()).  (As Jakub wisely
point out we cannot query the device directly due to performance
implications).  It doesn't need to be a new BPF hook, just something
that update the queue state info (we could piggy back on the
netdev_tx_completed_queue() call or give TX hook access to
dev_queue->dql).

Regarding "where is the queue": For me the XDP-TX queue is the NIC
hardware queue, that this BPF hook have some visibility into and can do
filtering on. (Imagine that my TX queue is bandwidth limited, then I
can shrink the packet size and still send a "congestion" packet to my
receiver).

The bigger picture is that I envision the XDP-TX/egress hook can
open-up for taking advantage of NIC hardware TX queue features.
This also ties into the queue abstraction work by Bj=C3=B6rn+Magnus.
Today NIC hardware can do a million TX-queues, and hardware can also do
rate limiting per queue.  Thus, I also envision that the XDP-TX/egress
hook can choose/change the TX queue the packet is queue/sent on (we can
likely just overload the XDP_REDIRECT and have a new bpf map type for
this).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

