Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35003791E5
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240546AbhEJPGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231536AbhEJPCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620658893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQFidAMkIKIHS26NAPycpeHm02ATyGtJ8uUbhbJtKSE=;
        b=VUTSZFNcluJBOZho186nCBD9PHur19ogW5+5MfJxLVK8DEUSBsba6ZhhIZO4J412OKFX8T
        waBogxodm5JewxTPeStZxJ9c2UaWX7RjEd/wLf6xtyqlIM/AMtVk/T5Z7GyTWq/b+8PSrN
        BasRMNfN+1ZtB+5WqwanIpfDApQiLmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-X-Yxeb4tNHewz_99_55bkQ-1; Mon, 10 May 2021 11:01:27 -0400
X-MC-Unique: X-Yxeb4tNHewz_99_55bkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9700E107ACC7;
        Mon, 10 May 2021 15:01:25 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 861FC60CC5;
        Mon, 10 May 2021 15:01:11 +0000 (UTC)
Date:   Mon, 10 May 2021 17:01:10 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     brouer@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Zvi Effron <zeffron@riotgames.com>,
        T K Sourabh <sourabhtk37@gmail.com>,
        Xdp <xdp-newbies@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, kuba@kernel.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: Dropped packets mapping IRQs for adjusted queue counts on i40e
Message-ID: <20210510170110.52640ae8@carbon>
In-Reply-To: <87h7jaq1dd.fsf@toke.dk>
References: <CAC1LvL1NHj6n+RNYRmja2YDhkcCwREuhjaBz_k255rU1jdO8Sw@mail.gmail.com>
        <CADS2XXpjasmJKP__oHsrvv3EG8n-FjB6sqHwgQfh7QgeJ8GrrQ@mail.gmail.com>
        <CAC1LvL2Q=s8pmwKAh2615fsTFEETKp96jpoLJS+75=0ztwuLFQ@mail.gmail.com>
        <CADS2XXptoyPTBObKgp3gcRZnWzoVyZrC26tDpLWhC9YrGMSefw@mail.gmail.com>
        <CAC1LvL2zmO1ntKeAoUMkJSarJBgxNhnTva3Di4047MTKqo8rPA@mail.gmail.com>
        <CAC1LvL1Kd-TCuPk0BEQyGvEiLzgUqkZHOKQNOUnxXSY6NjFMmw@mail.gmail.com>
        <20210505130128.00006720@intel.com>
        <20210505212157.GA63266@ranger.igk.intel.com>
        <87fsz0w3xn.fsf@toke.dk>
        <20210509155033.GB36905@ranger.igk.intel.com>
        <87h7jaq1dd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 13:22:54 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>=20
> > On Thu, May 06, 2021 at 12:29:40PM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote: =20
> >> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> >>  =20
> >> > On Wed, May 05, 2021 at 01:01:28PM -0700, Jesse Brandeburg wrote: =20
> >> >> Zvi Effron wrote:
> >> >>  =20
> >> >> > On Tue, May 4, 2021 at 4:07 PM Zvi Effron <zeffron@riotgames.com>=
 wrote: =20
> >> >> > > I'm suspecting it's something with how XDP_REDIRECT is implemen=
ted in
> >> >> > > the i40e driver, but I don't know if this is a) cross driver be=
havior,
> >> >> > > b) expected behavior, or c) a bug. =20
> >> >> > I think I've found the issue, and it appears to be specific to i4=
0e
> >> >> > (and maybe other drivers, too, but not XDP itself).
> >> >> >=20
> >> >> > When performing the XDP xmit, i40e uses the smp_processor_id() to
> >> >> > select the tx queue (see
> >> >> > https://elixir.bootlin.com/linux/v5.12.1/source/drivers/net/ether=
net/intel/i40e/i40e_txrx.c#L3846).
> >> >> > I'm not 100% clear on how the CPU is selected (since we don't use
> >> >> > cores 0 and 1), we end up on a core whose id is higher than any
> >> >> > available queue.
> >> >> >=20
> >> >> > I'm going to try to modify our IRQ mappings to test this.
> >> >> >=20
> >> >> > If I'm correct, this feels like a bug to me, since it requires a =
user
> >> >> > to understand low level driver details to do IRQ remapping, which=
 is a
> >> >> > bit higher level. But if it's intended, we'll just have to figure=
 out
> >> >> > how to work around this. (Unfortunately, using split tx and rx qu=
eues
> >> >> > is not possible with i40e, so that easy solution is unavailable.)
> >> >> >=20
> >> >> > --Zvi =20
> >> >
> >> > Hey Zvi, sorry for the lack of assistance, there has been statutory =
free
> >> > time in Poland and today i'm in the birthday mode, but we managed to
> >> > discuss the issue with Magnus and we feel like we could have a solut=
ion
> >> > for that, more below.
> >> > =20
> >> >>=20
> >> >>=20
> >> >> It seems like for Intel drivers, igc, ixgbe, i40e, ice all have
> >> >> this problem.
> >> >>=20
> >> >> Notably, igb, fixes it like I would expect. =20
> >> >
> >> > igb is correct but I think that we would like to avoid the introduct=
ion of
> >> > locking for higher speed NICs in XDP data path.
> >> >
> >> > We talked with Magnus that for i40e and ice that have lots of HW
> >> > resources, we could always create the xdp_rings array of num_online_=
cpus()
> >> > size and use smp_processor_id() for accesses, regardless of the user=
's
> >> > changes to queue count. =20
> >>=20
> >> What is "lots"? Systems with hundreds of CPUs exist (and I seem to
> >> recall an issue with just such a system on Intel hardware(?)). Also,
> >> what if num_online_cpus() changes? =20
> >
> > "Lots" is 16k for ice. For i40e datasheet tells that it's only 1536 for
> > whole device, so I back off from the statement that i40e has a lot of
> > resources :)
> >
> > Also, s/num_online_cpus()/num_possible_cpus(). =20
>=20
> OK, even 1536 is more than I expected; I figured it would be way lower,
> which is why you were suggesting to use num_online_cpus() instead; but
> yeah, num_possible_cpus() is obviously better, then :)
>=20
> >> > This way the smp_processor_id() provides the serialization by itself=
 as
> >> > we're under napi on a given cpu, so there's no need for locking
> >> > introduction - there is a per-cpu XDP ring provided. If we would sti=
ck to
> >> > the approach where you adjust the size of xdp_rings down to the shri=
nked
> >> > Rx queue count and use a smp_processor_id() % vsi->num_queue_pairs f=
ormula
> >> > then we could have a resource contention. Say that you did on a 16 c=
ore
> >> > system:
> >> > $ ethtool -L eth0 combined 2
> >> >
> >> > and then mapped the q0 to cpu1 and q1 to cpu 11. Both queues will gr=
ab the
> >> > xdp_rings[1], so we would have to introduce the locking.
> >> >
> >> > Proposed approach would just result with more Tx queues packed onto =
Tx
> >> > ring container of queue vector.
> >> >
> >> > Thoughts? Any concerns? Should we have a 'fallback' mode if we would=
 be
> >> > out of queues? =20
> >>=20
> >> Yes, please :) =20
> >
> > How to have a fallback (in drivers that need it) in a way that wouldn't
> > hurt the scenario where queue per cpu requirement is satisfied? =20
>=20
> Well, it should be possible to detect this at setup time, right? Not too
> familiar with the driver code, but would it be possible to statically
> dispatch to an entirely different code path if this happens?

The ndo_xdp_xmit call is a function pointer.  Thus, if it happens at
this level, then at setup time the driver can simply change the NDO to
use a TX-queue-locked variant.

I actually consider it a bug that i40e allow this misconfig to happen.
The ixgbe driver solves the problem by rejecting XDP attach if the
system have more CPUs than TXQs available.

IMHO it is a better solution to add shard'ed/partitioned TXQ-locking
when this situation happens, instead of denying XDP attach.  Since the
original XDP-redirect the ndo_xdp_xmit call have gotten bulking added,
thus the locking will be amortized over the bulk.

One question is how do we inform the end-user that XDP will be using
a slightly slower TXQ-locking scheme?  Given we have no XDP-features
exposed, I suggest a simple kernel log message, which we already have
for other XDP situations when the MTU is too large, or TSO is enabled.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

