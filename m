Return-Path: <netdev+bounces-4853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4377C70EC28
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E269A2811DA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451B5EC2;
	Wed, 24 May 2023 03:53:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929115B8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:53:07 +0000 (UTC)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C71D135
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:53:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-25355609a04so460661a91.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684900384; x=1687492384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAn/0YbSvS7UIq/EJgNYJfQt4mdVOO3/aNF3GYkOSB8=;
        b=Xqy6zWmUISjwt/sHtxPSERu/pWZZKDm7JsuBUWeEyIZgry52jgNlhRdZusod5zdoVi
         z1KSRqNxFXuO/IG/aJMV8u1J5BmvTpEysieDCG0cWGZgrFo7pGFdfxNBis7ntCtPKoLH
         3+yTAItVwrF6HsKyIWgVLas5UhN9WKmd8xwPHlPJeF1a0cX4kzlg66x+LTVASejPS9cR
         yoHIsP3iW2/1J3iJ3trP5ehDx+AuscrbTK3GJDSpqc5+DxcP+eaPXu/a4tr5uVpyrMpy
         gattTC4YKSVUNK9wk2H3zz5CLroHnEB8hYljbbOM2mxhYSqd0PXeDWN+g6/pURgY2Z3w
         XfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684900384; x=1687492384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gAn/0YbSvS7UIq/EJgNYJfQt4mdVOO3/aNF3GYkOSB8=;
        b=AIN61Y5SE7ko2ySqLOzlPzdLMm3nMpbZX2vFBAwif1NNqWC5Az6Sd2v0dJkHVkJSIU
         Fbi7e7L9LXshEx+K8DAELRzXEFS7JJom1UCGi17nVJzhJ1rPjkopU1y1yls576X2lCwG
         1geRZEF3zu5aX2cJmTRiXczMt1HKiD2PgYZhNwkoR8Yf+AVhl0L+EPsl+p17BXEW5haN
         hjDNQDYhlimsvC11hz1vAcDcHtoowDVO/UhuqtRZ3aFgeiqbDccugw+80F5U0tEj4qp5
         gAI5+AlO9p8NMtJ/iuczjN+MOT/fQpgA1JAZ0w8ymUJ0kNyQ2d1+LXZ+yGyevDht48HN
         af3w==
X-Gm-Message-State: AC+VfDxLROehDk/ZMNuuxhtvzqog90Uo87Y/5JUpCY/CxI4GxMNVwseq
	ZddxgSIn4VkTw4gGmOq6O4O+LsPa1MYZyvxXxgn+AQ==
X-Google-Smtp-Source: ACHHUZ4Z+Oz8x9s0V6SvZl3S9SrRGJP0brjEO/JkCuw7/oRmvsFSZCZcKpsxlo3zyYDUIojF7wPXXE3Cd0m20SQnTho=
X-Received: by 2002:a17:90a:6341:b0:252:8698:d03b with SMTP id
 v1-20020a17090a634100b002528698d03bmr14366512pjs.14.1684900384544; Tue, 23
 May 2023 20:53:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEUSe78ip=wkHUSz3mBFMcd-LjQAnByuJm1Oids5GSRm-J-dzA@mail.gmail.com>
 <e2f5ed62-eb6b-ea99-0e4d-da02160e99c8@suse.cz>
In-Reply-To: <e2f5ed62-eb6b-ea99-0e4d-da02160e99c8@suse.cz>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Tue, 23 May 2023 21:52:53 -0600
Message-ID: <CAEUSe794ifGiY9tsXfnqDsDSJ+UOOB1kJrm1Jb8kZ5fsoBZ5Sg@mail.gmail.com>
Subject: Re: Stable backport request: skbuff: Proactively round up to kmalloc
 bucket size
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	linux- stable <stable@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, ndesaulniers@google.com, rientjes@google.com, 
	Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello!

On Tue, 23 May 2023 at 00:28, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 5/22/23 20:23, Daniel D=C3=ADaz wrote:
> > Hello!
> >
> > Would the stable maintainers please consider backporting the following
> > commit to the 6.1? We are trying to build gki_defconfig (plus a few
> > extras) on Arm64 and test it under Qemu-arm64, but it fails to boot.
> > Bisection has pointed here.
>
> You mean the bisection was done to find the first "good" commit between 6=
.1
> and e.g. 6.3?
>
> As others said, this commit wasn't expected to be a fix to a known bug.
> Maybe you found one that we didn't know of, or it might be accidentaly
> masking some other bug.

How interesting! Yes, we happened to run a bisection between v6.1 and
v6.3 and we found where it started working with the following
configuration:
  https://storage.tuxsuite.com/public/linaro/daniel/builds/2QA2CHQUpqKe27Fy=
MZrBNILVwXi/config

With that patch on top of v6.1.29 it boots fine under Qemu-arm64; as
v6.1.y stands, it panics with this:
-----8<-----
  Unexpected kernel BRK exception at EL1
  Internal error: BRK handler: 00000000f2000001 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.29 #1
  Hardware name: linux,dummy-virt (DT)
  pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
  pc : pskb_expand_head+0x448/0x480
  lr : pskb_expand_head+0x13c/0x480
  sp : ffff80000802b850
  x29: ffff80000802b860 x28: 00000000000002c0 x27: 0000000000000ec0
  x26: ffff0000c02c8ec0 x25: ffff0000c02c8000 x24: 00000000000128c0
  x23: ffff0000c030e800 x22: ffff0000c030e800 x21: 0000000000000240
  x20: 0000000000000000 x19: ffff0000c085e900 x18: ffff800008021068
  x17: 00000000ad6b63b6 x16: 00000000ad6b63b6 x15: 0001001c00070038
  x14: 0000000c00020008 x13: 00882cc00000ffff x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000001
  x8 : ffff0000c030eac0 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : ffff0000c030eaf0 x4 : ffff0000ff7abd10 x3 : 0000000000001740
  x2 : ffff0000c02c8000 x1 : 0000000000000000 x0 : 0000000000000000
  Call trace:
   pskb_expand_head+0x448/0x480
   netlink_trim+0xa0/0xc8
   netlink_broadcast+0x54/0x764
   genl_ctrl_event+0x21c/0x37c
   genl_register_family+0x628/0x708
   thermal_netlink_init+0x28/0x3c
   thermal_init+0x28/0xec
   do_one_initcall+0xfc/0x358
   do_initcall_level+0xd8/0x1b4
   do_initcalls+0x64/0xa8
   do_basic_setup+0x2c/0x3c
   kernel_init_freeable+0x118/0x198
   kernel_init+0x30/0x1c0
   ret_from_fork+0x10/0x20
  Code: f9406679 38776b28 3707eba8 17ffff67 (d4200020)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: BRK handler: Fatal exception
  SMP: stopping secondary CPUs
----->8-----

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org

