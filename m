Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AD53C275C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhGIQPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:15:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhGIQPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 12:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625847183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uroG4ejneInhhnoGRBWsmMvnvKprQGYFLWi9+VdBOM0=;
        b=eu5vpNPYpKX0sjBWr7MS1zKPPXGRhsBSbY1RFhn/tPN+WDOvGa/lnCK2VWqtjMK9J8RAh6
        56HWqOOiqOGm3FQMP64FMOSD7B9tXtLEcbxXgKFulDTRcgxJdTnf2b+lwmcmYNt/qwEMmi
        sx/ZRWuRADcIiQFE9HmoQ4bGoEN//w4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-xR2e888hOfiz0DlWsEQHaQ-1; Fri, 09 Jul 2021 12:13:02 -0400
X-MC-Unique: xR2e888hOfiz0DlWsEQHaQ-1
Received: by mail-ej1-f72.google.com with SMTP id ia10-20020a170907a06ab02904baf8000951so3342996ejc.10
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 09:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=uroG4ejneInhhnoGRBWsmMvnvKprQGYFLWi9+VdBOM0=;
        b=othJwr0g9sFQVO7wmPj/r1uLyXqt0Acku8c3SBeLmB83YZBF/q/dnE2lhWYdbhu3Qj
         WCBUOgOyk2YfH6phlQxT5kcMJmvYvc4D+b5LMMhk1Nx94BT83B7tiUUr3E03IlPVz0zs
         UJQC4YsFsCe9maMIW7LS4CkSBDs4ky/2bYvHiLBBVBQATztjHuA7AkmwWqDfS6MRZq3P
         Ukxue5X1YZZjFL/hzQRshMz6gfoEy3jLWNGdlkUgXnDVNxPeRI1dpJr0CJV9LwusGhI0
         TOJLwvwrhW2GnKyZfgf9dll4Ow0xuKQ1oUe+VpzUTCRuSgyoFk/WQv1eJTQcFmSFL06y
         Aw7Q==
X-Gm-Message-State: AOAM531/8Hka+vTKrym/aZ9CIN84wg/NBn+UmmBR9+LnRMVUlHMumPWj
        rQ8rfTyE8zvjR4hqDvvlYTY8X/KKnJtPMB6x9+lXP+vLZZnbF1bqQZJdKdZMdB411heMqqwD8lf
        0V0zqTbyOW67OLG6R
X-Received: by 2002:a17:906:c30c:: with SMTP id s12mr4597614ejz.476.1625847180955;
        Fri, 09 Jul 2021 09:13:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYQvnEChigiI82DuVCc8sVbPOalhzgvc52vzAnO2Whdxd0xwe9gAlHSdpq86Sxtb2h7FM9vw==
X-Received: by 2002:a17:906:c30c:: with SMTP id s12mr4597587ejz.476.1625847180690;
        Fri, 09 Jul 2021 09:13:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p26sm2302400ejd.80.2021.07.09.09.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 09:13:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4CB8318072F; Fri,  9 Jul 2021 18:12:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH 2/3] veth: make queues nr configurable via kernel
 module params
In-Reply-To: <e425920ed8120597a3a2c129c5a19fa1bc4854a2.camel@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
 <480e7a960c26c9ab84efe59ed706f1a1a459d38c.1625823139.git.pabeni@redhat.com>
 <875yxjvl73.fsf@toke.dk>
 <e425920ed8120597a3a2c129c5a19fa1bc4854a2.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Jul 2021 18:12:59 +0200
Message-ID: <87fswnea9g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Fri, 2021-07-09 at 12:24 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Paolo Abeni <pabeni@redhat.com> writes:
>>=20
>> > This allows configuring the number of tx and rx queues at
>> > module load time. A single module parameter controls
>> > both the default number of RX and TX queues created
>> > at device registration time.
>> >=20
>> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> > ---
>> >  drivers/net/veth.c | 21 +++++++++++++++++++++
>> >  1 file changed, 21 insertions(+)
>> >=20
>> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>> > index 10360228a06a..787b4ad2cc87 100644
>> > --- a/drivers/net/veth.c
>> > +++ b/drivers/net/veth.c
>> > @@ -27,6 +27,11 @@
>> >  #include <linux/bpf_trace.h>
>> >  #include <linux/net_tstamp.h>
>> >=20=20
>> > +static int queues_nr	=3D 1;
>> > +
>> > +module_param(queues_nr, int, 0644);
>> > +MODULE_PARM_DESC(queues_nr, "Max number of RX and TX queues (default =
=3D 1)");
>>=20
>> Adding new module parameters is generally discouraged. Also, it's sort
>> of a cumbersome API that you'll have to set this first, then re-create
>> the device, and then use channels to get the number you want.
>>=20
>> So why not just default to allocating num_possible_cpus() number of
>> queues? Arguably that is the value that makes the most sense from a
>> scalability point of view anyway, but if we're concerned about behaviour
>> change (are we?), we could just default real_num_*_queues to 1, so that
>> the extra queues have to be explicitly enabled by ethtool?
>
> I was concerned by the amount of memory wasted memory (should be ~256
> bytes per rx queue, ~320 per tx, plus the sysfs entries).

I'm not too worried by that since it's per CPU; systems with a lot of
CPUs should hopefully also have plenty of memory. Or at least I think
the user friendliness outweighs the cost in memory.

> real_num_tx_queue > 1 will makes the xmit path slower, so we likely
> want to keep that to 1 by default - unless the userspace explicitly set
> numtxqueues via netlink.

Right, that's fine by me :)

> Finally, a default large num_tx_queue slows down device creation:
>
> cat << ENDL > run.sh
> #!/bin/sh
> MAX=3D$1
> for I in `seq 1 $MAX`; do
> 	ip link add name v$I type veth peer name pv$I
> done
> for I in `seq 1 $MAX`; do
> 	ip link del dev v$I
> done
> ENDL
> chmod a+x run.sh
>
> # with num_tx_queue =3D=3D 1
> time ./run.sh 100=20
> real	0m2.276s
> user	0m0.107s
> sys	0m0.162s
>
> # with num_tx_queue =3D=3D 128
> time ./run.sh 100 1
> real	0m4.199s
> user	0m0.091s
> sys	0m1.419s
>
> # with num_tx_queue =3D=3D 4096
> time ./run.sh 100=20
> real	0m24.519s
> user	0m0.089s
> sys	0m21.711s

So ~42 ms to create a device if there are 128 CPUs? And ~245 when
there's 4k CPUs? Doesn't seem too onerous to me...

> Still, if there is agreement I can switch to num_possible_cpus default,
> plus some trickery to keep real_num_{r,t}x_queue unchanged.
>
> WDYT?

SGTM :)

-Toke

