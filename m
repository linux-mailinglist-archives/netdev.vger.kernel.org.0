Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D110E930
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfLBKxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:53:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727308AbfLBKxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 05:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575284009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yUTWiUzu4a4U+qEusJB/wdWLedKDKqGhMji3MyMGPO0=;
        b=KKAyS4srJFs5MOrQtVXn0WiWvO+7AxBVb0bj9cTw5mKtDO+oWTnHh/pueGv/wMTXzZ7cQf
        bUDJkjCABmxzKQLIXMwG62DmmbrONK0WgbWZ12K2vzYNfYp3qXJAu3stvHsHhzr3gBRrgN
        NUAAuxedT8DluDbxczvC2F1PNk2sxUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-KB7fmiunMPSqPrpHqT5aUA-1; Mon, 02 Dec 2019 05:53:27 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE2B4801E7A;
        Mon,  2 Dec 2019 10:53:26 +0000 (UTC)
Received: from ovpn-116-116.ams2.redhat.com (ovpn-116-116.ams2.redhat.com [10.36.116.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 199165D6A0;
        Mon,  2 Dec 2019 10:53:22 +0000 (UTC)
Message-ID: <9c5c6dc9b7eb78c257d67c85ed2a6e0998ec8907.camel@redhat.com>
Subject: Re: Linux kernel - 5.4.0+ (net-next from 27.11.2019)
 routing/network performance
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?UTF-8?Q?Pawe=C5=82?= Staszewski <pstaszewski@itcare.pl>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Mon, 02 Dec 2019 11:53:22 +0100
In-Reply-To: <8e17a844-e98b-59b1-5a0e-669562b3178c@itcare.pl>
References: <81ad4acf-c9b4-b2e8-d6b1-7e1245bce8a5@itcare.pl>
         <589d2715-80ae-0478-7e31-342060519320@gmail.com>
         <8e17a844-e98b-59b1-5a0e-669562b3178c@itcare.pl>
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: KB7fmiunMPSqPrpHqT5aUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-12-02 at 11:09 +0100, Pawe=C5=82 Staszewski wrote:
> W dniu 01.12.2019 o 17:05, David Ahern pisze:
> > On 11/29/19 4:00 PM, Pawe=C5=82 Staszewski wrote:
> > > As always - each year i need to summarize network performance for
> > > routing applications like linux router on native Linux kernel (withou=
t
> > > xdp/dpdk/vpp etc) :)
> > >=20
> > Do you keep past profiles? How does this profile (and traffic rates)
> > compare to older kernels - e.g., 5.0 or 4.19?
> >=20
> >=20
> Yes - so for 4.19:
>=20
> Max bandwidth was about 40-42Gbit/s RX / 40-42Gbit/s TX of=20
> forwarded(routed) traffic
>=20
> And after "order-0 pages" patches - max was 50Gbit/s RX + 50Gbit/s TX=20
> (forwarding - bandwidth max)
>=20
> (current kernel almost doubled this)

Looks like we are on the good track ;)

[...]
> After "order-0 pages" patch
>=20
>     PerfTop:  104692 irqs/sec  kernel:99.5%  exact:  0.0% [4000Hz=20
> cycles],  (all, 56 CPUs)
> -------------------------------------------------------------------------=
---------------------------------------------------------------------------=
-----------------------------------------------------------=20
>=20
>=20
>       9.06%  [kernel]       [k] mlx5e_skb_from_cqe_mpwrq_linear
>       6.43%  [kernel]       [k] tasklet_action_common.isra.21
>       5.68%  [kernel]       [k] fib_table_lookup
>       4.89%  [kernel]       [k] irq_entries_start
>       4.53%  [kernel]       [k] mlx5_eq_int
>       4.10%  [kernel]       [k] build_skb
>       3.39%  [kernel]       [k] mlx5e_poll_tx_cq
>       3.38%  [kernel]       [k] mlx5e_sq_xmit
>       2.73%  [kernel]       [k] mlx5e_poll_rx_cq

Compared to the current kernel perf figures, it looks like most of the
gains come from driver changes.

[... current perf figures follow ...]
> -------------------------------------------------------------------------=
---------------------------------------------------------------------------=
-----------------------------------------------------------
>=20
>=20
>       7.56%  [kernel]       [k] __dev_queue_xmit

This is a bit surprising to me. I guess this is due
'__dev_queue_xmit()' being calling twice per packet (team, NIC) and due
to the retpoline overhead.

>       1.74%  [kernel]       [k] tcp_gro_receive

If the reference use-case is with a quite large number of cuncurrent
flows, I guess you can try disabling GRO

Cheers,

Paolo

