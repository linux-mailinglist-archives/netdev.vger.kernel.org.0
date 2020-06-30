Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD2E20EFCC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbgF3Hpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731077AbgF3Hpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:45:33 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48211C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:45:33 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id c21so10772949lfb.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:to:cc:subject:date:message-id
         :in-reply-to;
        bh=KM7gSW3CzjQWJvnlCpUDA+jtSslXvsOZptlraFzipQY=;
        b=Gs8x+KVbUDBWSeX0zJTYhkq1CpLSiVmLARhaYp+55BT3JLzBur9Qa3E2hg9yATZdtV
         8KT6BuEGwccuKpXTRwtpSCZRqj4FyFFJ22piLRKA1QBH40ypqg9e6W/34QXUIec6CJJd
         tFq6ZIZcQmjOvXdazhwfjwZMt7a5ScfDf/B1IOP5zcys2W269TZyfsHWfr1+2s3wndLe
         ID2ko2cptCJARl5+gez+8brKnH/O2BnggCjw5pzAI6xPCTGWquebbuLkJbQRguix2ekz
         /WfeEUqMkY2ywzi3n1fOwc9kuD/cICOGa6lj4bwhqARIYGdh7lOez9F8fML/cOiTD+3q
         adBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:to:cc:subject
         :date:message-id:in-reply-to;
        bh=KM7gSW3CzjQWJvnlCpUDA+jtSslXvsOZptlraFzipQY=;
        b=HSyNhOCm55A7hDolN/U5fwg3MoNItXSALNxqAjUxZZ+gs+Th57ttlnxYh5VV+tZSeu
         KOmTIb4mwzDI2mNgWRjNHBjyxVTiX1mL5OOqPc+QP6OqB6J0SbUKPC/ViRsvBQRQo4ES
         CH5WUSUhzikAewEdgHPmMrICE6+m+z/eh7NXQbdD96Vp/saK3Tao/d1hZhJak2GplQ1D
         50rE5xP2RUN79bDzBP87bssA3AVCgrFZ6aCyZpqJeqNHO5Ru0nu4MIhUz1h+kvZfmw1p
         47uEZi25vlsyafxHLPTtCwyZjU5jxRIsKPYYwY6yz2YgY6sppH4aNIZKAqQRTsSNs8qo
         YQjw==
X-Gm-Message-State: AOAM533A4DCk60PEVmjH7Pof3siRyeiyIPLVacnTWIvTC+CZAvOxoXRD
        lCKRV0SpFtEhyaUsG7sWt374wrCZTso=
X-Google-Smtp-Source: ABdhPJzO3WRaxOlX4Et++XY6ksHgLNiWEvzL3ynBOfOt/dezUXQPuv3a0m6GHlrewWpIaRyjCJTjoQ==
X-Received: by 2002:a19:787:: with SMTP id 129mr11360276lfh.147.1593503131224;
        Tue, 30 Jun 2020 00:45:31 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d3sm513772lfe.93.2020.06.30.00.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:45:29 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "David Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Date:   Tue, 30 Jun 2020 09:30:41 +0200
Message-Id: <C3U9EFL9CA15.QDKTU9Y4EZXM@wkz-x280>
In-Reply-To: <AM6PR0402MB36075CF372D7A31932E32B60FF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jun 30, 2020 at 8:27 AM CEST, Andy Duan wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday, June 30,
> 2020 12:29 AM
> > On Sun Jun 28, 2020 at 8:23 AM CEST, Andy Duan wrote:
> > > I never seem bandwidth test cause netdev watchdog trip.
> > > Can you describe the reproduce steps on the commit, then we can
> > > reproduce it on my local. Thanks.
> >=20
> > My setup uses a i.MX8M Nano EVK connected to an ethernet switch, but ca=
n
> > get the same results with a direct connection to a PC.
> >=20
> > On the iMX, configure two VLANs on top of the FEC and enable IPv4
> > forwarding.
> >=20
> > On the PC, configure two VLANs and put them in different namespaces. Fr=
om
> > one namespace, use trafgen to generate a flow that the iMX will route f=
rom
> > the first VLAN to the second and then back towards the second namespace=
 on
> > the PC.
> >=20
> > Something like:
> >=20
> >     {
> >         eth(sa=3DPC_MAC, da=3DIMX_MAC),
> >         ipv4(saddr=3D10.0.2.2, daddr=3D10.0.3.2, ttl=3D2)
> >         udp(sp=3D1, dp=3D2),
> >         "Hello world"
> >     }
> >=20
> > Wait a couple of seconds and then you'll see the output from fec_dump.
> >=20
> > In the same setup I also see a weird issue when running a TCP flow usin=
g
> > iperf3. Most of the time (~70%) when i start the iperf3 client I'll see
> > ~450Mbps of throughput. In the other case (~30%) I'll see ~790Mbps. The
> > system is "stably bi-modal", i.e. whichever rate is reached in the begi=
nning is
> > then sustained for as long as the session is kept alive.
> >=20
> > I've inserted some tracepoints in the driver to try to understand what'=
s going
> > on:
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsvg=
sha
> > re.com%2Fi%2FMVp.svg&amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%
> > 7C12854e21ea124b4cc2e008d81c59d618%7C686ea1d3bc2b4c6fa92cd99c5c
> > 301635%7C0%7C0%7C637290519453656013&amp;sdata=3Dby4ShOkmTaRkFfE
> > 0xJkrTptC%2B2egFf9iM4E5hx4jiSU%3D&amp;reserved=3D0
> >=20
> > What I can't figure out is why the Tx buffers seem to be collected at a=
 much
> > slower rate in the slow case (top in the picture). If we fall behind in=
 one NAPI
> > poll, we should catch up at the next call (which we can see in the fast=
 case).
> > But in the slow case we keep falling further and further behind until w=
e freeze
> > the queue. Is this something you've ever observed? Any ideas?
>
> Before, our cases don't reproduce the issue, cpu resource has better
> bandwidth
> than ethernet uDMA then there have chance to complete current NAPI. The
> next,
> work_tx get the update, never catch the issue.

It appears it has nothing to do with routing back out through the same
interface.

I get the same bi-modal behavior if just run the iperf3 server on the
iMX and then have it be the transmitting part, i.e. on the PC I run:

    iperf3 -c $IMX_IP -R

I would be very interesting to see what numbers you see in this
scenario.
