Return-Path: <netdev+bounces-1173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 820756FC7F5
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957B41C20B61
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A73D182CE;
	Tue,  9 May 2023 13:34:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221876116
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:34:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8228E61
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683639287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YiPDca4XqAyJCen9Gu1W4qph7SI4eX56cUBCImbYYj8=;
	b=OEwgFBPpi+Envu84JVYzNLKcl1n4kllrJOH4nL914wz/aCSf8zxG8VlJfcWWe7sW4Ngrim
	A8N8hG+mJ7jV/eIqgP4Ug2TiPNVahH4MspA+BXQwQjbDrMFinhFv1Bogq2LttTNvpgGJzQ
	0X5CCvPdIsEoFMqu+RAtoVaCbB0dMpQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-WBvN8PiXMtOPBotymPPtig-1; Tue, 09 May 2023 09:34:45 -0400
X-MC-Unique: WBvN8PiXMtOPBotymPPtig-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f08900caadso6802045e9.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 06:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683639284; x=1686231284;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YiPDca4XqAyJCen9Gu1W4qph7SI4eX56cUBCImbYYj8=;
        b=L+dBuIiCBwbLJz1blU45jaSeDvUlqEWPTZHlJdEJMXKqhsIj95c1LrO99P38KxW9x2
         fnEhYNM/DthPDn8E2vAJS9AtTtDTywKyuCwttkIxsUzrwxNO1PO2MmdRrfzseZX744r/
         +aaok50hQeXNNblhFbz6XxVME3KTGb8hrXMVYCtbHre4bVE7H44fVQSn1vnHW2YEM7v3
         wNrOscoiEvALZMjaQh4D4t0fsltKH+V0VD6DLiZ014zc0YbRHmOsXvDGe4BzIzip4AQe
         4AC+ASoTrrJnrEGCKjynYKFpaB/TEeGWLbx2v4GFWM2upHMqeSNgsfIHcXWXMp/I5FHy
         Vz2A==
X-Gm-Message-State: AC+VfDyEYtj/rm72/WdgSCbZ7O7lOpqPzE9zOQC3VdtlPq/lKotNU8pB
	dS6/q6ixM9oSnnm4dfn5TYhUhKsRXzwq8N9ox6pdg1ca1oe6P8BXkB8kJZBlaux1WuGTQbosT38
	pSBYCHALLHwrNgyUnjeVwAcjg8WE=
X-Received: by 2002:a05:600c:3489:b0:3f4:2297:f25b with SMTP id a9-20020a05600c348900b003f42297f25bmr6209905wmq.0.1683639284376;
        Tue, 09 May 2023 06:34:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ68M5u2oFdH/Fa6JihPQkNJfVp8qqZGQXcv2S5nhLZJSyC6Yz/80CMJG711dKVJZCKJtHHOrg==
X-Received: by 2002:a05:600c:3489:b0:3f4:2297:f25b with SMTP id a9-20020a05600c348900b003f42297f25bmr6209888wmq.0.1683639284008;
        Tue, 09 May 2023 06:34:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-255-65.dyn.eolo.it. [146.241.255.65])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c290600b003f18992079dsm19843750wmd.42.2023.05.09.06.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 06:34:43 -0700 (PDT)
Message-ID: <df46c00581155a42e132c8896667c39f83828dd7.camel@redhat.com>
Subject: Re: [PATCH v1 net-next] tcp: Add net.ipv4.tcp_reset_challenge.
From: Paolo Abeni <pabeni@redhat.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, David Ahern <dsahern@kernel.org>
Cc: Mubashir Adnan Qureshi <mubashirq@google.com>, Neal Cardwell
	 <ncardwell@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, 
	netdev@vger.kernel.org, Jon Zobrist <zob@amazon.com>
Date: Tue, 09 May 2023 15:34:42 +0200
In-Reply-To: <20230508222736.13249-1-kuniyu@amazon.com>
References: <20230508222736.13249-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-08 at 15:27 -0700, Kuniyuki Iwashima wrote:
> Our Network Load Balancer (NLB) [0] consists of multiple nodes with uniqu=
e
> IP addresses.  These nodes forward TCP flows from clients to backend
> targets by modifying the destination IP address.  NLB offers an option [1=
]
> to preserve the client's source IP address and port when routing packets
> to backend targets.
>=20
> When a client connects to two different NLB nodes, they may select the sa=
me
> backend target.  If the client uses the same source IP and port, the two
> flows at the backend side will have the same 4-tuple.
>=20
>                          +---------------+
>             1st flow     |  NLB Node #1  |   src: 10.0.0.215:60000
>          +------------>  |   10.0.3.4    |  +------------+
>          |               |    :10000     |               |
>          +               +---------------+               v
>   +------------+                                   +------------+
>   |   Client   |                                   |   Target   |
>   | 10.0.0.215 |                                   | 10.0.3.249 |
>   |   :60000   |                                   |   :10000   |
>   +------------+                                   +------------+
>          +               +---------------+               ^
>          |               |  NLB Node #2  |               |
>          +------------>  |   10.0.4.62   |  +------------+
>             2nd flow     |    :10000     |   src: 10.0.0.215:60000
>                          +---------------+
>=20
> The kernel responds to the SYN of the 2nd flow with Challenge ACK.  In th=
is
> situation, there are multiple valid reply paths, but the flows behind NLB
> are tracked to ensure symmetric routing [2].  So, the Challenge ACK is
> routed back to the 2nd NLB node.
>=20
> The 2nd NLB node forwards the Challenge ACK to the client, but the client
> sees it as an invalid response to SYN in tcp_rcv_synsent_state_process()
> and finally sends RST in tcp_v[46]_do_rcv() based on the sequence number
> by tcp_v[46]_send_reset().  The RST effectively closes the first connecti=
on
> on the target, and a retransmitted SYN successfully establishes the 2nd
> connection.
>=20
>   On client:
>   10.0.0.215.60000 > 10.0.3.4.10000: Flags [S], seq 772948343  ... via NL=
B Node #1
>   10.0.3.4.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 7729=
48344
>   10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675
>=20
>   10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743 ... via NL=
B Node #2
>   10.0.4.62.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Invali=
d Challenge ACK
>   10.0.0.215.60000 > 10.0.4.62.10000: Flags [R], seq 772948344 ... RST w/=
 correct seq #
>   10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743
>   10.0.4.62.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 248=
180744
>   10.0.0.215.60000 > 10.0.4.62.10000: Flags [.], ack 4160908214
>=20
>   On target:
>   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 772948343 ... via N=
LB Node #1
>   10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 77=
2948344
>   10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 3739044675
>=20
>   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743 ... via N=
LB Node #2
>   10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Forwa=
rded to 2nd flow
>   10.0.0.215.60000 > 10.0.3.249.10000: Flags [R], seq 772948344 ... Close=
 the 1st connection
>   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743
>   10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 24=
8180744
>   10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 4160908214
>=20
> The first connection is still alive from the client's point of view.  Whe=
n
> the client sends data over the first connection, the target responds with
> Challenge ACK.  The Challenge ACK is routed back to the 1st connection, a=
nd
> the client responds with Dup ACK, and the target responds to the Dup ACK
> with Challenge ACK, and this continues.
>=20
>   On client:
>   10.0.0.215.60000 > 10.0.3.4.10000: Flags [P.], seq 772948344:772948349,=
 ack 3739044675, length 5
>   10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0  =
... Challenge ACK
>   10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675, length 0 =
... Dup ACK
>   10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0  =
... Challenge ACK
>   ...
>=20
> In RFC 5961, Challenge ACK assumes that it will be routed back via an
> asymmetric path to the peer of the established connection.  However, in
> a situation where multiple valid reply paths are tracked, Challenge ACK
> gives a hint to snipe another connection and also triggers the Challenge
> ACK Dup ACK war on the connection.
>=20
> A new sysctl knob, net.ipv4.tcp_reset_challenge, allows us to respond to
> invalid packets described in RFC 5961 with RST and keep the established
> socket open.

I did not double check with the RFC, but the above looks like a knob to
enable a protocol violation.

I'm wondering if the same results could be obtained with a BPF program
instead?

IMHO we should avoid adding system wide knobs for such specific use-
case, especially when the controlled behaviour is against the spec.

Cheers,

Paolo


