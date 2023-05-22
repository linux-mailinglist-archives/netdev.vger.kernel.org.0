Return-Path: <netdev+bounces-4387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B88670C517
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7636B1C20A58
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE151643C;
	Mon, 22 May 2023 18:24:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313A1642C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:24:03 +0000 (UTC)
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5C2189
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:24:02 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-2536b4b3398so4075308a91.3
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684779841; x=1687371841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=msgMReVyIvBu/bwIUP7X7q2ZMnoRqp8LGJXsMcFUvcs=;
        b=aHRH/zKGBDEc02+tUp4uzQfBwuRMYKhtH/VSuyaJ+fL4LRwlVratK6g5Ty0wfGlV/7
         Y/VyfeULzj3JpgHIQBBrC9MtY/lF88HAZ0kM+hRL8Yte8RRWf4oSdlYRF/XqpF2XA2Vg
         Y/TBhVrCE5UVfu/3DPCR/eGCu5HHdDIPvWJbwZoG6y01qPt/jfHqLq2YSEyrxZgpYPOZ
         5TeWBF8wX2Hl7c/4w4Wjfe9Y/AHiyPIm2pHjBcmDKl/I63SEPBuRujPlyBZmGp/Eq4q5
         sv5hd33nwR1BM9jefCd6kQ+ZNnJaSfCWvqDe+M0wEL70LWLYrdvJ409IFNQvdJFQXqdp
         h0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684779841; x=1687371841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msgMReVyIvBu/bwIUP7X7q2ZMnoRqp8LGJXsMcFUvcs=;
        b=VxhwWeS0fadzsmXdVzG0DebQ4Nd/kTNvS2BHyDXAtl6Y8GdW2BUtUtH8hXhvVdknaf
         pvS46AQTnmc0EY8dKy/lZzgFaCC8F+O9IWhorfey+uY4ShHgbDfJk5s/0/++9wIO45Os
         0otyn3ZGyK5qzAj+Y+t+Y0RH/BIXkP1Apsgf3QOwW5hOrmc+57twd0bH09rjt4ZDR5NW
         KLIu41MosccGLlBfPTj01pss2SpDLJwwX2kwHlGMwj6SFWjZAdxO2GZsFsXuhzIoi+5u
         opqqGKTiaxU9N+7M576tNVThQQ6DNyclKmfeWYATNA3h8xv4re/6P7w2htWFjdqzm2Ep
         Mz/w==
X-Gm-Message-State: AC+VfDwqJKgju3mWDiKpd/rKgplb4ZJ3HsXLURLRDFsAVYHOnm9VZfo/
	5XgBVX90zQPyxwv5odfdRlCB42uJRo9KBytVCL6C+g==
X-Google-Smtp-Source: ACHHUZ6kdZR7qEFCbldz7uvdvDR5AlZ74YO/t4UiDPEmkgkrjjjgqDRSNzOgFw8RL8QhF7CCiVwX7Jzh4v1RebH6w3M=
X-Received: by 2002:a17:90a:b292:b0:255:4b79:1ef9 with SMTP id
 c18-20020a17090ab29200b002554b791ef9mr6188889pjr.16.1684779841457; Mon, 22
 May 2023 11:24:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 22 May 2023 12:23:50 -0600
Message-ID: <CAEUSe78ip=wkHUSz3mBFMcd-LjQAnByuJm1Oids5GSRm-J-dzA@mail.gmail.com>
Subject: Stable backport request: skbuff: Proactively round up to kmalloc
 bucket size
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	linux- stable <stable@vger.kernel.org>
Cc: open list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, ndesaulniers@google.com, rientjes@google.com, 
	vbabka@suse.cz, Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello!

Would the stable maintainers please consider backporting the following
commit to the 6.1? We are trying to build gki_defconfig (plus a few
extras) on Arm64 and test it under Qemu-arm64, but it fails to boot.
Bisection has pointed here.

We have verified that cherry-picking this patch on top of v6.1.29
applies cleanly and allows the kernel to boot.

commit 12d6c1d3a2ad0c199ec57c201cdc71e8e157a232
Author: Kees Cook <keescook@chromium.org>
Date:   Tue Oct 25 15:39:35 2022 -0700

    skbuff: Proactively round up to kmalloc bucket size

    Instead of discovering the kmalloc bucket size _after_ allocation, roun=
d
    up proactively so the allocation is explicitly made for the full size,
    allowing the compiler to correctly reason about the resulting size of
    the buffer through the existing __alloc_size() hint.

    This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
    coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
    back the __alloc_size() hints that were temporarily reverted in commit
    93dd04ab0b2b ("slab: remove __alloc_size attribute from
__kmalloc_track_caller")

    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: Eric Dumazet <edumazet@google.com>
    Cc: Jakub Kicinski <kuba@kernel.org>
    Cc: Paolo Abeni <pabeni@redhat.com>
    Cc: netdev@vger.kernel.org
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: Nick Desaulniers <ndesaulniers@google.com>
    Cc: David Rientjes <rientjes@google.com>
    Acked-by: Vlastimil Babka <vbabka@suse.cz>
    Link: https://patchwork.kernel.org/project/netdevbpf/patch/202210212347=
13.you.031-kees@kernel.org/
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Link: https://lore.kernel.org/r/20221025223811.up.360-kees@kernel.org
    Signed-off-by: Paolo Abeni <pabeni@redhat.com>


Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org

