Return-Path: <netdev+bounces-4055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 396AD70A558
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2E131C20D4A
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1557664D;
	Sat, 20 May 2023 04:43:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D52363
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 04:43:35 +0000 (UTC)
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0466E40;
	Fri, 19 May 2023 21:43:33 -0700 (PDT)
Received: from smtpclient.apple (unknown [124.16.139.61])
	by APP-05 (Coremail) with SMTP id zQCowAAHDYnlT2hkQpDeAQ--.35351S2;
	Sat, 20 May 2023 12:43:17 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: memory leak in ipv6_sock_ac_join
From: =?utf-8?B?6IyD5L+K5p2w?= <junjie2020@iscas.ac.cn>
In-Reply-To: <7f189d22226841168eb46b7be8939e2d06fa476c.camel@redhat.com>
Date: Sat, 20 May 2023 12:43:07 +0800
Cc: davem@davemloft.net,
 dsahern@kernel.org,
 edumazet@google.com,
 kuba@kernel.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B4E62EDC-8364-4527-926D-6AFEFFB1D7B4@iscas.ac.cn>
References: <13e257b8.6869.18833286427.Coremail.junjie2020@iscas.ac.cn>
 <7f189d22226841168eb46b7be8939e2d06fa476c.camel@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-CM-TRANSID:zQCowAAHDYnlT2hkQpDeAQ--.35351S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1kAF1rCFWDKrWfCF4rKrg_yoW5XFykpa
	15G3Wjgr4ktry093WftFy8XFWFyw4rCFy5Grsaqrn5CF1xKFy5Kry2kr47Jan8Zrs8GrW5
	Zryj9r1qv348JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvab7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I
	8E87Iv6xkF7I0E14v26r4UJVWxJr1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8I
	j28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_Jr
	ylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxG
	rwCY02Avz4vE14v_Gryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
	IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
	6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
	IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv
	67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
	uYvjxUc75rUUUUU
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: xmxqyxbhsqji46lvutnvoduhdfq/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thank you for your response. This is my first time submitting crashes to =
kernel developers, so forgive me if there are any shortcomings. In my =
opinion, some of the code crashes in the old version may also be present =
in the new version. That=E2=80=99s why I want to report these crash to =
you. I will take note of the issues you mentioned and make a meaningful =
contribution by submitting valid kernel errors next time.!
Sincerely!

> 2023=E5=B9=B45=E6=9C=8819=E6=97=A5 22:46=EF=BC=8CPaolo Abeni =
<pabeni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> hi,
>=20
> Please use plain-text when sending messages to a kernel devel mailing
> list.
>=20
> On Fri, 2023-05-19 at 16:37 +0800, =E8=8C=83=E4=BF=8A=E6=9D=B0 wrote:
>> Our modified tool found a new bug BUG: unable to handle kernel NULL
>> pointer dereference in scsi_queue_rq=20
>=20
> What you mention above is different from what you actually reports
> below.
>=20
>> in Kernel commit v5.14.=20
>=20
> That is not exactly new.
>=20
>> The report is as below and this bug don't have a repro C program
>> until now. Please inform me if you confirm this is a reproducible
>> bug.
>=20
> I think the above expectation is quite beyond what you could get. When
> you reports a bug _you_ are supposed to try to reproduce it.
>=20
>>  ---
>>  BUG: memory leak
>> unreferenced object 0xffff8ad4e16c5760 (size 32):
>>   comm "syz-executor.2", pid 17137, jiffies 4295510146 (age 7.862s)
>>   hex dump (first 32 bytes):
>>     fe 80 00 00 00 00 00 00 00 00 00 00 00 00 00 bb  ................
>>     01 00 00 00 d4 8a ff ff 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<00000000033cd1b4>] kmalloc include/linux/slab.h:605 [inline]
>>     [<00000000033cd1b4>] sock_kmalloc+0x48/0x80 net/core/sock.c:2563
>>     [<00000000724962dc>] ipv6_sock_ac_join+0xf0/0x2d0
>> net/ipv6/anycast.c:86
>>     [<0000000027291f90>] do_ipv6_setsockopt.isra.14+0x1e23/0x21a0
>> net/ipv6/ipv6_sockglue.c:868
>>     [<00000000bb6b5160>] ipv6_setsockopt+0xa9/0xf0
>> net/ipv6/ipv6_sockglue.c:1021
>>     [<0000000057fe6cc3>] udpv6_setsockopt+0x53/0xa0
>> net/ipv6/udp.c:1652
>>     [<0000000023dcd6bb>] __sys_setsockopt+0xb6/0x160
>> net/socket.c:2259
>>     [<0000000081a16a2e>] __do_sys_setsockopt net/socket.c:2270
>> [inline]
>>     [<0000000081a16a2e>] __se_sys_setsockopt net/socket.c:2267
>> [inline]
>>     [<0000000081a16a2e>] __x64_sys_setsockopt+0x22/0x30
>> net/socket.c:2267
>>     [<0000000075aec224>] do_syscall_x64 arch/x86/entry/common.c:50
>> [inline]
>>     [<0000000075aec224>] do_syscall_64+0x37/0x80
>> arch/x86/entry/common.c:80
>>     [<000000006cd4d12f>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>=20
>> BUG: leak checking failed
>=20
> This was probably addressed by:
>=20
> 8c0de6e96c97 ("ipv6: fix memory leaks on IPV6_ADDRFORM path")=20
>=20
>=20
> Cheers,
>=20
> Paolo


