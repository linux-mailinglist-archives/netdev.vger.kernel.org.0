Return-Path: <netdev+bounces-5051-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4513370F8F0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD0251C20DAE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A0B17ACB;
	Wed, 24 May 2023 14:43:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C607D6084A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:43:51 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA91180
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:43:48 -0700 (PDT)
Date: Wed, 24 May 2023 16:43:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684939426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LHgrw9qdIMC3z7WYxNuJXIAI2oyypGtsquiBageqa60=;
	b=AQbfDFRSrGMCaBwuWyQeyatxlOpxVxo3n7t/L/Kaj2uKCitLw61QMHLRfb92HyKHSf1U5n
	7HAxGEfwIbmxE98hSZqXchx1rJGSNZox+T6rAjZu05yYYgV6CJVZFYBZ4sNG0QEKeTj3Y6
	g4XzT0Fn56o848DcBpRS2Xw29VOgiDQrmQU5YMEKKJH5iZ72ntV9I8ag5hKqW4hV6uoi4g
	yPQfMqxMZH65bNBdUb/S8+aObbkM51+RMNNMG8aej2OoPKZP2lZmOHFrYDDpeaxuC1zVaF
	4Mz+GMyaM11//7EtzIktIK2Q6tRxB9YdnHQqhjsGxUKEthRkdXT5fm79cXb2yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684939426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LHgrw9qdIMC3z7WYxNuJXIAI2oyypGtsquiBageqa60=;
	b=ZnREWOLxQ/pxdViXSs575MKqUkmgwXEYI0LPaTrDi1WDqql6t/Kf6ynjhraMIcrNuDnFDa
	7v4YbCQaI5KhTaAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Message-ID: <20230524144344.9Xu6U4Lj@linutronix.de>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
 <20230524111259.1323415-2-bigeasy@linutronix.de>
 <CANn89iLRALON8-Bp+0iN8qEfSas2QoAE0nPMTDHS97QQWS9gyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANn89iLRALON8-Bp+0iN8qEfSas2QoAE0nPMTDHS97QQWS9gyg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-24 15:53:27 [+0200], Eric Dumazet wrote:
> How is interface rename handled ?
>=20
> root@edumazet1:~# ip link show dev dummy0
> 4: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether f2:38:20:69:b4:ca brd ff:ff:ff:ff:ff:ff
> root@edumazet1:~# ip link set dummy0 name new-name
> root@edumazet1:~# ip link show dev dummy0
> Device "dummy0" does not exist.
> root@edumazet1:~# ip link show dev new-name
> 4: new-name: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether f2:38:20:69:b4:ca brd ff:ff:ff:ff:ff:ff

Not sure I understood the question. But after
	ip link set eno0 name newdev

I have
| root@box:/sys/class/net/newdev# ps uax | grep napi
| root        2246  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8200]
| root        2247  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8199]
| root        2248  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8198]
| root        2249  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8197]
| root        2250  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8196]
| root        2251  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8195]
| root        2252  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8194]
| root        2253  0.0  0.0      0     0 ?        S    12:04   0:00 [napi/=
eno0-8193]
|
| root@box:/sys/class/net/newdev# ls -lh napi
| total 0
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-0
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-1
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-2
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-3
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-4
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-5
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-6
| drwxr-xr-x 2 root root 0 May 24 12:05 eno0-TxRx-7

NAPI was not freed/ allocated again. For some reason the interface went
down during the rename. I suspect the fancy network manager because it
does not know the interface. It did noto happen again after a further
rename of the renamed device and it remained up.

A link up request resulted in requesting the interrupts again and so the
names of the IRQ-threads contain now "newdev" in /proc/interrupts and
the relevant interrupt thread. This isn't the case if I rename it again
since the device isn't going down.

If I reconfigure the queues
	ethtool -L newdev combined 6 other 1

which drops all NAPI devices and asks for new then the NAPI threads are
displayed properly (in ps) but the sysfs entries in the napi folder are
napi_id-$id so I probably missed a spot in the igb driver. And reverting
back to the original 8 channels does not change the fact that I still
see napi_id-$id. So details=E2=80=A6 But the interrupt number and so on mat=
ch :)

> Thanks.

Sebastian

