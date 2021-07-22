Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1481F3D2B07
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhGVQlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 12:41:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhGVQlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 12:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626974495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhyUdv/wS7/qpkdnVTe3lZ4lblQbChSsd8efBcTCfhU=;
        b=GFqbhN5yDofqEb2p0t0Unzm7V6CLMa5endDLIHzXEqiYT3ZFV3Il2rAckrynhiQibHFJlG
        GnedwC+eBj/q2/EcWhWIj65Bs5dgjIEjX1Hs3lSPumGl4Uek/6LaxkJhnhxHpjnVEAkBaE
        7IRGHYXHzWrtMHqWr5M/vGMETc3tmTM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-5PbMuG_EM76llJ9BFSaq3A-1; Thu, 22 Jul 2021 13:21:34 -0400
X-MC-Unique: 5PbMuG_EM76llJ9BFSaq3A-1
Received: by mail-ed1-f69.google.com with SMTP id v4-20020a50a4440000b02903ab1f22e1dcso3114157edb.23
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 10:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MhyUdv/wS7/qpkdnVTe3lZ4lblQbChSsd8efBcTCfhU=;
        b=Dgu9x5w+zNmBA7J7BdCamwhPz/63fkjPfN7khrsgFOzJ9/b/3WqFEaBfAeN+YJm4+m
         vGAPf7A7EXluChtDJFmWAuTrh4YmE1x7FYq1DjRPzTx018U8+10YG7O/ieahq7+80H/0
         oghKVtQZXG2CGPMe28dlpW2iIg0lFiCP7UwVlhbdDovDSBmkcWHuFjngK1nQbRomk5tQ
         ICMGJDkrSNoIMuaynU+cf3hDIkWkwdGGL2K+QkDaqrZKVUN0SJYiiMU82yBhgU2qtrbr
         3nD1REzENHqQd/DYAd3hfx6raCXE/9FI6WPUqXFUT3YjEsfcXutjE7Y8fd1FGdU22HRi
         41nA==
X-Gm-Message-State: AOAM5315eemQNtgLCR6UyKvE34Sn/A0lA+oZyBYDyWSaQwZ7TH5sWYhY
        oE0zWQsRTTnkuEL4FtbEc5vUahStvxA4NQCY0aer1I8MaSv1+13HSswbhDFXoDRdR3Iqu4RXHoM
        YITiaQkGnjlY2YMzF
X-Received: by 2002:a17:907:3d8a:: with SMTP id he10mr927986ejc.16.1626974492712;
        Thu, 22 Jul 2021 10:21:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy03hTZzY/x6WB/cNAkreu3VdkYxjq9Ro2zEp3v9VjpFcjuDPtBqyD9nTDSsszmEOWHB8P0Nw==
X-Received: by 2002:a17:907:3d8a:: with SMTP id he10mr927958ejc.16.1626974492173;
        Thu, 22 Jul 2021 10:21:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d8sm6875198edj.19.2021.07.22.10.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 10:21:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5882418031E; Thu, 22 Jul 2021 19:21:30 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Gilad Naaman <gnaaman@drivenets.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: Set true network header for ECN decapsulation
In-Reply-To: <20210722170128.223387-1-gnaaman@drivenets.com>
References: <20210722170128.223387-1-gnaaman@drivenets.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Jul 2021 19:21:30 +0200
Message-ID: <87v9526z8l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gilad Naaman <gnaaman@drivenets.com> writes:

> In cases where the header straight after the tunnel header was
> another ethernet header (TEB), instead of the network header,
> the ECN decapsulation code would treat the ethernet header as if
> it was an IP header, resulting in mishandling and possible
> wrong drops or corruption of the IP header.
>
> In this case, ECT(1) is sent, so IP_ECN_decapsulate tries to copy it to t=
he
> inner IPv4 header, and correct its checksum.
>
> The offset of the ECT bits in an IPv4 header corresponds to the
> lower 2 bits of the second octet of the destination MAC address
> in the ethernet header.
> The IPv4 checksum corresponds to end of the source address.
>
> In order to reproduce:
>
>     $ ip netns add A
>     $ ip netns add B
>     $ ip -n A link add _v0 type veth peer name _v1 netns B
>     $ ip -n A link set _v0 up
>     $ ip -n A addr add dev _v0 10.254.3.1/24
>     $ ip -n A route add default dev _v0 scope global
>     $ ip -n B link set _v1 up
>     $ ip -n B addr add dev _v1 10.254.1.6/24
>     $ ip -n B route add default dev _v1 scope global
>     $ ip -n B link add gre1 type gretap local 10.254.1.6 remote 10.254.3.=
1 key 0x49000000
>     $ ip -n B link set gre1 up
>
>     # Now send an IPv4/GRE/Eth/IPv4 frame where the outer header has ECT(=
1),
>     # and the inner header has no ECT bits set:
>
>     $ cat send_pkt.py
>         #!/usr/bin/env python3
>         from scapy.all import *
>
>         pkt =3D IP(b'E\x01\x00\xa7\x00\x00\x00\x00@/`%\n\xfe\x03\x01\n\xf=
e\x01\x06 \x00eXI\x00'
>                  b'\x00\x00\x18\xbe\x92\xa0\xee&\x18\xb0\x92\xa0l&\x08\x0=
0E\x00\x00}\x8b\x85'
>                  b'@\x00\x01\x01\xe4\xf2\x82\x82\x82\x01\x82\x82\x82\x02\=
x08\x00d\x11\xa6\xeb'
>                  b'3\x1e\x1e\\xf3\\xf7`\x00\x00\x00\x00ZN\x00\x00\x00\x00=
\x00\x00\x10\x11\x12'
>                  b'\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !=
"#$%&\'()*+,-./01234'
>                  b'56789:;<=3D>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ')
>
>         send(pkt)
>     $ sudo ip netns exec B tcpdump -neqlllvi gre1 icmp & ; sleep 1
>     $ sudo ip netns exec A python3 send_pkt.py
>
> In the original packet, the source/destinatio MAC addresses are
> dst=3D18:be:92:a0:ee:26 src=3D18:b0:92:a0:6c:26
>
> In the received packet, they are
> dst=3D18:bd:92:a0:ee:26 src=3D18:b0:92:a0:6c:27
>
> Thanks to Lahav Schlesinger <lschlesinger@drivenets.com> and Isaac Garzon=
 <isaac@speed.io>
> for helping me pinpoint the origin.

Oops! Thank you for the fix :)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

