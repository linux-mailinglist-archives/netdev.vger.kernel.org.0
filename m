Return-Path: <netdev+bounces-9146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C337278CC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FABD281653
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652717479;
	Thu,  8 Jun 2023 07:28:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A656FB1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:28:41 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D834626AC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:28:29 -0700 (PDT)
X-QQ-mid: bizesmtp70t1686209281t5pmo3ky
Received: from smtpclient.apple ( [122.235.137.64])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 08 Jun 2023 15:28:00 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: OcwMSiKTK9TbCTrAUTdgGXZeI5xQ/HC7K+476jPYfF4I7ev2pb6758GNaeCIb
	cH2nBKuu/dz0jPqq1Ex77xzCGACIb0Uq8ckYI8JfcJS+Jlhlr868T1x8gCgfm27OJeeycBd
	Ex3MYErrlYnLpcSCZMXbCmX0CgO0n0/7MXDyND85yNLhnarEw1nnCp1sybhqEY26auHL0KQ
	Sf0Eq9oiSz023rC9uuQHw6VFteyvp8tBK2xU80F1fJ3p23hn63gfSflqKqZhUwYV5bOoMJL
	CVWfkTmYpyCdkwv9jFFkiyH7aJDxuU+QrQidQoyVXCpnfoNbjpZFlQY8r1tEr/C8s7tCE1O
	HImhmg+GEA17zg344ai/GvXZZG1mOEFxIZ7iZAWkaqfGyVQG2LiD8V0GCG6PxIFCItdM++x
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 18280197469729432243
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [RFC,PATCH net-next 1/3] net: ngbe: add Wake on Lan support
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <372be8c0-f83f-4641-ad6d-f126a01e02d4@lunn.ch>
Date: Thu, 8 Jun 2023 15:27:50 +0800
Cc: netdev@vger.kernel.org,
 Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <20AD5BE0-FAF6-4ED3-8A53-4550FCD87BFA@net-swift.com>
References: <20230605095527.57898-1-mengyuanlou@net-swift.com>
 <6DD3D5EDF01AE3F5+20230605095527.57898-2-mengyuanlou@net-swift.com>
 <372be8c0-f83f-4641-ad6d-f126a01e02d4@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3731.600.7)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> 2023=E5=B9=B46=E6=9C=885=E6=97=A5 21:00=EF=BC=8CAndrew Lunn =
<andrew@lunn.ch> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Jun 05, 2023 at 05:52:50PM +0800, Mengyuan Lou wrote:
>> Implement ethtool_ops get_wol.
>> Implement Wake-on-LAN support.
>>=20
>> Magic packets are checked by fw, for now just support
>> WAKE_MAGIC and do not supoort to set_wol.
>=20
> So are you saying WOL cannot be disabled? A magic packet will always
> wake the system?
>=20
>  Can the
> interrupt be masked to disable WoL?
When Firmware find a magic packet, it will set the GPIO.=20
Firmware do not care the interrupt of WOL.

> Can you disable WoL by not calling device_set_wakeup_enable()?
>=20
It is work by calling device_set_wakeup_enable() to disable WOL.


> Is this specific to ngbe? Does txgbe have different firmware and
> different WoL support?
>=20
I do not have NICs=EF=BC=88txgbe=EF=BC=89which is support to WOL.
I will add it after I will have tested it.


>  Andrew
>=20
>=20


