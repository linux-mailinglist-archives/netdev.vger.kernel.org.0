Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196983789FA
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 13:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbhEJLfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 07:35:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235142AbhEJLYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 07:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620645784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YReM1a+d1MF8qH1RqPBWq7lyKLZMBFgM7TkuSYkEfg=;
        b=R5YNkrBE6SfOlCPDorsB3I9n1e+gBiMUykzAoykGtJy3agGJ+BkJ8d+F6njosr/p6Wupop
        50z1LgQ7+IcshOgUm3kOl9LQXUVoiWpM5NalIxMB1p/KKzifezsPxHEhukYWmMKyKdDZHy
        kmUgF9iEZkvVbLb9HDiqnGC2zRkxrag=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-wyIit4EuMGyBPD_5drUUfw-1; Mon, 10 May 2021 07:22:58 -0400
X-MC-Unique: wyIit4EuMGyBPD_5drUUfw-1
Received: by mail-ej1-f72.google.com with SMTP id fs16-20020a1709076010b02903bceecba067so566289ejc.6
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 04:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8YReM1a+d1MF8qH1RqPBWq7lyKLZMBFgM7TkuSYkEfg=;
        b=FbxLOYHXjLZqpV2SSW5lsUXWwc303HaQRYQG6f/JBmNVfs4ctnIUZrsJEPGRS1QJyK
         ekqYQKUx7Fyu5pzvpg0bgC9RciqPIUe+ZePHjIraX+5jyF5R/3UkAqMg10adhOQEA1Tg
         0OWDWZW2nk3Rcu1ZdiW9q/RVoqUX0j0LPsPKeXN0bT0FkD4HQD4zkuVuTe28Gbdh9jjT
         EGoZZkow14Djn6JwMjdwMh9VSTiQmPnpr33tMAVfSWhiiLuTtZvjSDaMEhOkOvYlTUJ3
         r6MDuJ0Fq82cZF6J5OJswNJ42ucA8WaQiq4EIMk6otjgFZm6vFwjQhlpEHNEIzI+EWsN
         Yzfg==
X-Gm-Message-State: AOAM533A6tAqf7pn9WgPAK7w154iAG7EX7Vxbu8UjhMVjB/iLLlnc2DT
        KvkZ0fAkGD5JiHNKmmpfs6e7f6qfSaB+t+k1hXNUel7Z1w0Y0VHCghA6sj1MBMCTGpuYrCNrojN
        Bl/aamjqxEPlGbR/y
X-Received: by 2002:a17:906:564f:: with SMTP id v15mr24572027ejr.96.1620645776844;
        Mon, 10 May 2021 04:22:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysz/2WfT0uGh3jgW0w0gReeejEVaKQsGCoxpsAYkWLKTIj1uKWrHn36k2xpZm2LYxMOYPsRA==
X-Received: by 2002:a17:906:564f:: with SMTP id v15mr24571993ejr.96.1620645776281;
        Mon, 10 May 2021 04:22:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p4sm8912154ejr.81.2021.05.10.04.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 04:22:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1254F1808AA; Mon, 10 May 2021 13:22:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Zvi Effron <zeffron@riotgames.com>,
        T K Sourabh <sourabhtk37@gmail.com>,
        Xdp <xdp-newbies@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, kuba@kernel.org
Subject: Re: Dropped packets mapping IRQs for adjusted queue counts on i40e
In-Reply-To: <20210509155033.GB36905@ranger.igk.intel.com>
References: <CAC1LvL1NHj6n+RNYRmja2YDhkcCwREuhjaBz_k255rU1jdO8Sw@mail.gmail.com>
 <CADS2XXpjasmJKP__oHsrvv3EG8n-FjB6sqHwgQfh7QgeJ8GrrQ@mail.gmail.com>
 <CAC1LvL2Q=s8pmwKAh2615fsTFEETKp96jpoLJS+75=0ztwuLFQ@mail.gmail.com>
 <CADS2XXptoyPTBObKgp3gcRZnWzoVyZrC26tDpLWhC9YrGMSefw@mail.gmail.com>
 <CAC1LvL2zmO1ntKeAoUMkJSarJBgxNhnTva3Di4047MTKqo8rPA@mail.gmail.com>
 <CAC1LvL1Kd-TCuPk0BEQyGvEiLzgUqkZHOKQNOUnxXSY6NjFMmw@mail.gmail.com>
 <20210505130128.00006720@intel.com>
 <20210505212157.GA63266@ranger.igk.intel.com> <87fsz0w3xn.fsf@toke.dk>
 <20210509155033.GB36905@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 10 May 2021 13:22:54 +0200
Message-ID: <87h7jaq1dd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Thu, May 06, 2021 at 12:29:40PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>>=20
>> > On Wed, May 05, 2021 at 01:01:28PM -0700, Jesse Brandeburg wrote:
>> >> Zvi Effron wrote:
>> >>=20
>> >> > On Tue, May 4, 2021 at 4:07 PM Zvi Effron <zeffron@riotgames.com> w=
rote:
>> >> > > I'm suspecting it's something with how XDP_REDIRECT is implemente=
d in
>> >> > > the i40e driver, but I don't know if this is a) cross driver beha=
vior,
>> >> > > b) expected behavior, or c) a bug.
>> >> > I think I've found the issue, and it appears to be specific to i40e
>> >> > (and maybe other drivers, too, but not XDP itself).
>> >> >=20
>> >> > When performing the XDP xmit, i40e uses the smp_processor_id() to
>> >> > select the tx queue (see
>> >> > https://elixir.bootlin.com/linux/v5.12.1/source/drivers/net/etherne=
t/intel/i40e/i40e_txrx.c#L3846).
>> >> > I'm not 100% clear on how the CPU is selected (since we don't use
>> >> > cores 0 and 1), we end up on a core whose id is higher than any
>> >> > available queue.
>> >> >=20
>> >> > I'm going to try to modify our IRQ mappings to test this.
>> >> >=20
>> >> > If I'm correct, this feels like a bug to me, since it requires a us=
er
>> >> > to understand low level driver details to do IRQ remapping, which i=
s a
>> >> > bit higher level. But if it's intended, we'll just have to figure o=
ut
>> >> > how to work around this. (Unfortunately, using split tx and rx queu=
es
>> >> > is not possible with i40e, so that easy solution is unavailable.)
>> >> >=20
>> >> > --Zvi
>> >
>> > Hey Zvi, sorry for the lack of assistance, there has been statutory fr=
ee
>> > time in Poland and today i'm in the birthday mode, but we managed to
>> > discuss the issue with Magnus and we feel like we could have a solution
>> > for that, more below.
>> >
>> >>=20
>> >>=20
>> >> It seems like for Intel drivers, igc, ixgbe, i40e, ice all have
>> >> this problem.
>> >>=20
>> >> Notably, igb, fixes it like I would expect.
>> >
>> > igb is correct but I think that we would like to avoid the introductio=
n of
>> > locking for higher speed NICs in XDP data path.
>> >
>> > We talked with Magnus that for i40e and ice that have lots of HW
>> > resources, we could always create the xdp_rings array of num_online_cp=
us()
>> > size and use smp_processor_id() for accesses, regardless of the user's
>> > changes to queue count.
>>=20
>> What is "lots"? Systems with hundreds of CPUs exist (and I seem to
>> recall an issue with just such a system on Intel hardware(?)). Also,
>> what if num_online_cpus() changes?
>
> "Lots" is 16k for ice. For i40e datasheet tells that it's only 1536 for
> whole device, so I back off from the statement that i40e has a lot of
> resources :)
>
> Also, s/num_online_cpus()/num_possible_cpus().

OK, even 1536 is more than I expected; I figured it would be way lower,
which is why you were suggesting to use num_online_cpus() instead; but
yeah, num_possible_cpus() is obviously better, then :)

>> > This way the smp_processor_id() provides the serialization by itself as
>> > we're under napi on a given cpu, so there's no need for locking
>> > introduction - there is a per-cpu XDP ring provided. If we would stick=
 to
>> > the approach where you adjust the size of xdp_rings down to the shrink=
ed
>> > Rx queue count and use a smp_processor_id() % vsi->num_queue_pairs for=
mula
>> > then we could have a resource contention. Say that you did on a 16 core
>> > system:
>> > $ ethtool -L eth0 combined 2
>> >
>> > and then mapped the q0 to cpu1 and q1 to cpu 11. Both queues will grab=
 the
>> > xdp_rings[1], so we would have to introduce the locking.
>> >
>> > Proposed approach would just result with more Tx queues packed onto Tx
>> > ring container of queue vector.
>> >
>> > Thoughts? Any concerns? Should we have a 'fallback' mode if we would be
>> > out of queues?
>>=20
>> Yes, please :)
>
> How to have a fallback (in drivers that need it) in a way that wouldn't
> hurt the scenario where queue per cpu requirement is satisfied?

Well, it should be possible to detect this at setup time, right? Not too
familiar with the driver code, but would it be possible to statically
dispatch to an entirely different code path if this happens?

-Toke

