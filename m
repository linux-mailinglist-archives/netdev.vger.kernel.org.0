Return-Path: <netdev+bounces-3938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6B4709A50
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95C4C1C20B17
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11F0C2F5;
	Fri, 19 May 2023 14:46:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26678BE2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:46:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC039C9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684507606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mSlH9yed2+egztC1235eRiYpBNaIcoimkdcsVGFGI0o=;
	b=ORXElE425COH1r8J/0IRwlGRwon6vcnakJzOOHRx1ZMkP5dZFG956pbM4qwd+iLTy68zwC
	mg5ZXZErDr1U+KHBXPPnEMkxFJsItebJTY4mANgvh1m9OJW03W8cekNEt8FGXt7fXPXRRj
	MVVz3ktTVkW1zofFAZKtRd5kaCVQX74=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-qRtGBcacMLSADPtGZYe3Ig-1; Fri, 19 May 2023 10:46:45 -0400
X-MC-Unique: qRtGBcacMLSADPtGZYe3Ig-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f508c2b301so3470015e9.0
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:46:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684507604; x=1687099604;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mSlH9yed2+egztC1235eRiYpBNaIcoimkdcsVGFGI0o=;
        b=kDfMhAuA/gzL0/l3b4LK8Xzrk/zS5L+IzesZhXGqf/yTaLZTXnJmQQMIkK5NkAumVr
         M9QDUux1bOj1MXhwiW4thSS4I6KD6ZQkZbu3Ya512cI1blV8IWFjw6KRN7yvs/GYHWwt
         Ce9TwKz+3GaDCaP9ibW/+sMLCRnMGBF3m3CMSOALFCROXwPU3htnwyI1zRY+Hx5mLm5D
         neirF0LpQfgEo6HIRQOG0KflO0VMjtLxIP+7xNh3TluU/CqP/gz5oc/unbVm6jCeLdgt
         kXCjAA0rZLPQs8+LxwWJYMPympr/19DZ0PbTDaeyf4IzeMjFDsyEFwpdSrEhYD/uCVDZ
         PNtg==
X-Gm-Message-State: AC+VfDzz1NB2D8nDU238dljhfH2oFNqLzA4PqDGFFHEBPPRwE+dUURP5
	9iw4LNpVQSUCbrW1qjUDOcRWtX6RNdSL+PARGHXcf5JrelU6anH01apizEQoda286U11x37dhgZ
	0DMCmslf8rOJ0T9mLMj0Lelbg
X-Received: by 2002:a5d:4b4a:0:b0:307:5561:5eec with SMTP id w10-20020a5d4b4a000000b0030755615eecmr1603019wrs.0.1684507604324;
        Fri, 19 May 2023 07:46:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5C903d6ahLAiz8d0kKQA1HiJ8aJs3uxoW70pAdOmb9Ign7FpFP2GnVquoogPSXHNEO9bUbaA==
X-Received: by 2002:a5d:4b4a:0:b0:307:5561:5eec with SMTP id w10-20020a5d4b4a000000b0030755615eecmr1603008wrs.0.1684507604009;
        Fri, 19 May 2023 07:46:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-235-104.dyn.eolo.it. [146.241.235.104])
        by smtp.gmail.com with ESMTPSA id n6-20020adff086000000b002f6176cc6desm5423908wro.110.2023.05.19.07.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 07:46:43 -0700 (PDT)
Message-ID: <7f189d22226841168eb46b7be8939e2d06fa476c.camel@redhat.com>
Subject: Re: memory leak in ipv6_sock_ac_join
From: Paolo Abeni <pabeni@redhat.com>
To: =?UTF-8?Q?=E8=8C=83=E4=BF=8A=E6=9D=B0?= <junjie2020@iscas.ac.cn>, 
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org,  netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: syzkaller-bugs@googlegroups.com
Date: Fri, 19 May 2023 16:46:42 +0200
In-Reply-To: <13e257b8.6869.18833286427.Coremail.junjie2020@iscas.ac.cn>
References: <13e257b8.6869.18833286427.Coremail.junjie2020@iscas.ac.cn>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

hi,

Please use plain-text when sending messages to a kernel devel mailing
list.

On Fri, 2023-05-19 at 16:37 +0800, =E8=8C=83=E4=BF=8A=E6=9D=B0 wrote:
> Our modified=C2=A0tool found a new bug=C2=A0BUG: unable to handle kernel =
NULL
> pointer dereference in scsi_queue_rq=C2=A0

What you mention above is different from what you actually reports
below.

> in=C2=A0Kernel=C2=A0commit v5.14.=C2=A0

That is not exactly new.

> The report is as below and this bug don't have a repro C program
> until now.=C2=A0Please inform me if you confirm this is a=C2=A0reproducib=
le
> bug.

I think the above expectation is quite beyond what you could get. When
you reports a bug _you_ are supposed to try to reproduce it.

> =C2=A0---
> =C2=A0BUG: memory leak
> unreferenced object 0xffff8ad4e16c5760 (size 32):
> =C2=A0 comm "syz-executor.2", pid 17137, jiffies 4295510146 (age 7.862s)
> =C2=A0 hex dump (first 32 bytes):
> =C2=A0 =C2=A0 fe 80 00 00 00 00 00 00 00 00 00 00 00 00 00 bb=C2=A0 .....=
...........
> =C2=A0 =C2=A0 01 00 00 00 d4 8a ff ff 00 00 00 00 00 00 00 00=C2=A0 .....=
...........
> =C2=A0 backtrace:
> =C2=A0 =C2=A0 [<00000000033cd1b4>] kmalloc include/linux/slab.h:605 [inli=
ne]
> =C2=A0 =C2=A0 [<00000000033cd1b4>] sock_kmalloc+0x48/0x80 net/core/sock.c=
:2563
> =C2=A0 =C2=A0 [<00000000724962dc>] ipv6_sock_ac_join+0xf0/0x2d0
> net/ipv6/anycast.c:86
> =C2=A0 =C2=A0 [<0000000027291f90>] do_ipv6_setsockopt.isra.14+0x1e23/0x21=
a0
> net/ipv6/ipv6_sockglue.c:868
> =C2=A0 =C2=A0 [<00000000bb6b5160>] ipv6_setsockopt+0xa9/0xf0
> net/ipv6/ipv6_sockglue.c:1021
> =C2=A0 =C2=A0 [<0000000057fe6cc3>] udpv6_setsockopt+0x53/0xa0
> net/ipv6/udp.c:1652
> =C2=A0 =C2=A0 [<0000000023dcd6bb>] __sys_setsockopt+0xb6/0x160
> net/socket.c:2259
> =C2=A0 =C2=A0 [<0000000081a16a2e>] __do_sys_setsockopt net/socket.c:2270
> [inline]
> =C2=A0 =C2=A0 [<0000000081a16a2e>] __se_sys_setsockopt net/socket.c:2267
> [inline]
> =C2=A0 =C2=A0 [<0000000081a16a2e>] __x64_sys_setsockopt+0x22/0x30
> net/socket.c:2267
> =C2=A0 =C2=A0 [<0000000075aec224>] do_syscall_x64 arch/x86/entry/common.c=
:50
> [inline]
> =C2=A0 =C2=A0 [<0000000075aec224>] do_syscall_64+0x37/0x80
> arch/x86/entry/common.c:80
> =C2=A0 =C2=A0 [<000000006cd4d12f>] entry_SYSCALL_64_after_hwframe+0x46/0x=
b0
>=20
> BUG: leak checking failed

This was probably addressed by:

8c0de6e96c97 ("ipv6: fix memory leaks on IPV6_ADDRFORM path")=C2=A0


Cheers,

Paolo


