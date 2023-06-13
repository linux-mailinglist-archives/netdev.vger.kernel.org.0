Return-Path: <netdev+bounces-10530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C59AE72EDCF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80C84281116
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10323D3A7;
	Tue, 13 Jun 2023 21:22:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0532174FA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:22:23 +0000 (UTC)
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C81F19B7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:22:21 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6b28fc460bcso3759282a34.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686691340; x=1689283340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcSq5gtVpF5kw0BUKhHtrVL/EwbWS56HCbSCa8xkX00=;
        b=EHX/NtXcQPx8/QYJVqpgVi8GLzLuaJ83IBLeWonAzQZY+MMYFgoyaha/k51ETXmxn7
         vR1quSXQ/k3H5bc+A2WAV84o4ZxxfSz2mssAlUzfeiZXlS2vxLXiz37u44oMzni1sTn5
         j7Ms5Wmx9INf4H+yFiyZTTYDgnOmaXFLGjiY7Byxpy7/sE7bRPMOTyXx4jB/KdTsSzL8
         BZIQEBnpfKtFldB9cyRhlaGXBD8rYwauqZ1omR16E8URteo0ES14G9JEt/VL4HQZCh/c
         8uO1t8TCtEFWK7VaWzdGriqAvBndx3hM3pWa8ijlPOylSFrGlN+74MxO97+tSCv7jV4r
         BFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686691340; x=1689283340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcSq5gtVpF5kw0BUKhHtrVL/EwbWS56HCbSCa8xkX00=;
        b=aD9aTyZo1+8Tm+PW3CK/Ty4VWn2mFQdPNYEn8/8jcExEerQaprYdyWXKhLSgnmpbow
         ZtyD3nlQOQKm+vQ83NfKGGXvj2fPJncxdPVUnSJp9yRrrsBVGHR7wCPOShSoofWGRIaz
         MWlVK94wT7BGwK2rUtuXTc5AH4sL+GOfXAq8e8nY6RvtYoPrUCdaE8ERVMbh/o4cOcrH
         6F22E9ToYMht20g9hta7clLt4uaJ/JggAW4whmdTqy3ps3RHfu7pnplrkS/uC31AFf2w
         /jKt+K6x0q4EvF/tzr+V4LFPi3Pp8lIMN4fQtJR6ikrPjb6qhTxQFNKppy4fydEpv4Rj
         20Cg==
X-Gm-Message-State: AC+VfDwhf6vcm33VrjIvU34aEjVfijbh9DJ9GCtyPO+7Y3NaalkeaqmL
	ly2Vu4uzpnStAy6h9OUAfok=
X-Google-Smtp-Source: ACHHUZ7Drij4CfuhRjdnVPye9AeWsJxoj2cLJuL9B2/lE/dO++cPy+MKxP+pUuWlxZeQhC0rhrE4zA==
X-Received: by 2002:a05:6830:104d:b0:6b1:604f:3f22 with SMTP id b13-20020a056830104d00b006b1604f3f22mr11606706otp.2.1686691340476;
        Tue, 13 Jun 2023 14:22:20 -0700 (PDT)
Received: from espresso.lan.box ([179.219.237.97])
        by smtp.gmail.com with ESMTPSA id o1-20020a9d7641000000b006a3f4c6f138sm5204699otl.36.2023.06.13.14.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 14:22:19 -0700 (PDT)
Date: Tue, 13 Jun 2023 18:22:15 -0300
From: Ricardo Nabinger Sanchez <rnsanchez@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org
Subject: Re: panic in udp_init() when using FORCE_NR_CPUS
Message-ID: <20230613182215.33bfc5ef@espresso.lan.box>
In-Reply-To: <CANn89i+5DoHFh-2MvLy740ikLdV-sE8pEEM+R=i0i77Pyc1ADQ@mail.gmail.com>
References: <20230613165654.3e75eda8@espresso.lan.box>
 <CANn89i+5DoHFh-2MvLy740ikLdV-sE8pEEM+R=i0i77Pyc1ADQ@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Eric,

On Tue, 13 Jun 2023 22:19:33 +0200
Eric Dumazet <edumazet@google.com> wrote:

> Sure, but you did not give NR_CPUS value ?
>=20
> Also posting the stack trace might be useful.

That's puzzling.  From menuconfig (which I always use), it is a bool:

[*] Set number of CPUs at compile time=20

CONFIG_FORCE_NR_CPUS:

Say Yes if you have NR_CPUS set to an actual number of possible
CPUs in your system, not to a default value. This forces the core
code to rely on compile-time value and optimize kernel routines
better.

Symbol: FORCE_NR_CPUS [=3Dy]
Type  : bool
Defined at lib/Kconfig:540
  Prompt: Set number of CPUs at compile time
  Depends on: SMP [=3Dy] && EXPERT [=3Dy] && !COMPILE_TEST [=3Dn]
  Location:
    -> Library routines
      -> Set number of CPUs at compile time (FORCE_NR_CPUS [=3Dy])



So I took another look into how I was setting these, and since I had
not realized I would need to disable MAXSMP and only then be able to
set NR_CPUS.  I must have misunderstood the help sections; the wording
suggests me that one of those knobs would trigger some automatic
enumeration.

Here is the diff on my resulting .config:

--- .config.old	2023-06-13 17:33:41.152720907 -0300
+++ .config	2023-06-13 17:46:48.515676191 -0300
@@ -388,11 +388,11 @@
 CONFIG_HPET_EMULATE_RTC=3Dy
 CONFIG_DMI=3Dy
 CONFIG_BOOT_VESA_SUPPORT=3Dy
-CONFIG_MAXSMP=3Dy
-CONFIG_NR_CPUS_RANGE_BEGIN=3D8192
-CONFIG_NR_CPUS_RANGE_END=3D8192
-CONFIG_NR_CPUS_DEFAULT=3D8192
-CONFIG_NR_CPUS=3D8192
+# CONFIG_MAXSMP is not set
+CONFIG_NR_CPUS_RANGE_BEGIN=3D2
+CONFIG_NR_CPUS_RANGE_END=3D512
+CONFIG_NR_CPUS_DEFAULT=3D64
+CONFIG_NR_CPUS=3D12
 CONFIG_SCHED_CLUSTER=3Dy
 CONFIG_SCHED_SMT=3Dy
 CONFIG_SCHED_MC=3Dy
@@ -430,7 +430,7 @@
 # CONFIG_AMD_NUMA is not set
 CONFIG_X86_64_ACPI_NUMA=3Dy
 # CONFIG_NUMA_EMU is not set
-CONFIG_NODES_SHIFT=3D10
+CONFIG_NODES_SHIFT=3D6
 CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
 CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
 CONFIG_ARCH_PROC_KCORE_TEXT=3Dy
@@ -4995,8 +4995,7 @@
 # CONFIG_DMA_MAP_BENCHMARK is not set
 CONFIG_SGL_ALLOC=3Dy
 CONFIG_CHECK_SIGNATURE=3Dy
-CONFIG_CPUMASK_OFFSTACK=3Dy
-# CONFIG_FORCE_NR_CPUS is not set
+CONFIG_FORCE_NR_CPUS=3Dy
 CONFIG_CPU_RMAP=3Dy
 CONFIG_DQL=3Dy
 CONFIG_GLOB=3Dy
@@ -5150,6 +5149,8 @@
 # CONFIG_DEBUG_VIRTUAL is not set
 CONFIG_DEBUG_MEMORY_INIT=3Dy
 # CONFIG_DEBUG_PER_CPU_MAPS is not set
+CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=3Dy
+# CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP is not set
 CONFIG_HAVE_ARCH_KASAN=3Dy
 CONFIG_HAVE_ARCH_KASAN_VMALLOC=3Dy
 CONFIG_CC_HAS_KASAN_GENERIC=3Dy


And I'm reporting from a freshly-rebuilt kernel, which succeeded in
booting.  So this was totally on me, I did not know about these
conflicts in my configuration.

Apologies on making noise about this panic.

Best regards,

--=20
Ricardo Nabinger Sanchez

    Dedique-se a melhorar seus esfor=E7os.
    Todas as suas conquistas evolutivas n=E3o foram resultado dos
    deuses, das outras consci=EAncias, ou do acaso, mas unicamente
    da sua transpira=E7=E3o. ---Waldo Vieira, L=E9xico de Ortopensatas

