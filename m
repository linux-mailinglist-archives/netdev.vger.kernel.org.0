Return-Path: <netdev+bounces-10510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF13F72EC5E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 835221C20880
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F4B3D39F;
	Tue, 13 Jun 2023 19:57:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730D0136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:57:01 +0000 (UTC)
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84B4118
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:56:59 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1a6a4dc59bdso1814827fac.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686686219; x=1689278219;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLfPUvJqWn30bdBGr/DHzbEZ290RRadQ/WucWRNMoEU=;
        b=RHA/gy90YbdB0KGbuKwXSmxpvruMphzdSFgrSImllIYka2fb7ywiOn1fxJ7PYbqeSI
         0SDqPyPk7DiDRuq9PskATxSsse/P8+bCrbFQFEjTZvJWbglowOp8m265DjehpZ/w0mfZ
         hJuTufDtLRw/tx5absWOkzpTMMa6MmyeM1FgGlF1xfzoFs0YscjvWhv86T1mj/ER02XA
         u6ypaY/bE6rSXzdVJiHu6p6pMC6trOxaPGfrWSk4fgEa7MI1WSO1sM5GhNod7IAOv3hk
         +V1UnIGjZqf4dpqdRQsI36NEh9co9II3Pj3Aidz579rkvO0a/h+iks1Tg7pYqlsvcJ6Q
         LUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686686219; x=1689278219;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bLfPUvJqWn30bdBGr/DHzbEZ290RRadQ/WucWRNMoEU=;
        b=Jlwm84O2mFy9CYJxJj7sICbJOmrVatbmZ3UfX1PQ5AtOFj74zckLVmY9zTWv/lCai4
         w/7u6dIyjEVF7Sctj4U60HcIKmaup6JtesW8yNvsDXxed7odWLlzHU+gq6o1dlwrKeHL
         rfXBBbSH9cdktt6fwcLYu1mIlbPk78RpxfDf3eYLQ2dAnfe6sFTtTra9cs37AfP/24R3
         nFhXjA/zToritE5P1tMJxznesPt0838E+nIU+r2tJJtq598+JFL1/rmmv8pGnJlQJiDL
         U04LQCsvnoYQ2Q234AJbGB4paXNHcgPt6ZvlU+F8zbPVuVJKNwWV3JvAfj3gib8bShPy
         Re9w==
X-Gm-Message-State: AC+VfDyI9llizoN5DuXoai2YxZZLuNqmqLXW0Ot3Pzoj/lFhIkJroG7m
	8xA9xYwVC77lv9P41kRdAFY=
X-Google-Smtp-Source: ACHHUZ72XgnpZ9NjL6LUGv87LEhqBnBjXbZpn4jXCPBclThAY0M9TlD4nzYuaZiKJenbiDafQ41tZg==
X-Received: by 2002:a05:6870:e297:b0:19f:827b:d50b with SMTP id v23-20020a056870e29700b0019f827bd50bmr7818406oad.15.1686686218780;
        Tue, 13 Jun 2023 12:56:58 -0700 (PDT)
Received: from espresso.lan.box ([179.219.237.97])
        by smtp.gmail.com with ESMTPSA id os12-20020a0568707d0c00b001802d3e181fsm7704781oab.14.2023.06.13.12.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:56:58 -0700 (PDT)
Date: Tue, 13 Jun 2023 16:56:54 -0300
From: Ricardo Nabinger Sanchez <rnsanchez@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org
Subject: panic in udp_init() when using FORCE_NR_CPUS
Message-ID: <20230613165654.3e75eda8@espresso.lan.box>
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

Hello,

I have hit again an old panic that, in the past, I could not check in
more depth.  But today I was able to pinpoint to a single config knob:

$ diff -u /mnt/tmp/Kernel/linux-6.4-rc6/.config{.old,}
--- /mnt/tmp/Kernel/linux-6.4-rc6/.config.old	2023-06-13
10:34:11.881004307 -0300 +++
/mnt/tmp/Kernel/linux-6.4-rc6/.config	2023-06-13
13:42:46.396967635 -0300 @@ -4996,7 +4996,7 @@ CONFIG_SGL_ALLOC=3Dy
 CONFIG_CHECK_SIGNATURE=3Dy
 CONFIG_CPUMASK_OFFSTACK=3Dy
-CONFIG_FORCE_NR_CPUS=3Dy
+# CONFIG_FORCE_NR_CPUS is not set
 CONFIG_CPU_RMAP=3Dy
 CONFIG_DQL=3Dy
 CONFIG_GLOB=3Dy

Today's build is 6.4-rc6 tarball from kernel.org and, if I enable
FORCE_NR_CPUS, it panic()s after doing kmalloc(), with

	"UDP: failed to alloc udp_busylocks"

Backtrace leads to:

void __init udp_init(void)
{
        unsigned long limit;
        unsigned int i;

        udp_table_init(&udp_table, "UDP");
        limit =3D nr_free_buffer_pages() / 8;=20
        limit =3D max(limit, 128UL);
        sysctl_udp_mem[0] =3D limit / 4 * 3;=20
        sysctl_udp_mem[1] =3D limit;
        sysctl_udp_mem[2] =3D sysctl_udp_mem[0] * 2;=20

        /* 16 spinlocks per cpu */
        udp_busylocks_log =3D ilog2(nr_cpu_ids) + 4;=20
        udp_busylocks =3D kmalloc(sizeof(spinlock_t) << udp_busylocks_log,
                                GFP_KERNEL);
        if (!udp_busylocks)
                panic("UDP: failed to alloc udp_busylocks\n");
        for (i =3D 0; i < (1U << udp_busylocks_log); i++)=20
                spin_lock_init(udp_busylocks + i);

        if (register_pernet_subsys(&udp_sysctl_ops))
                panic("UDP: failed to init sysctl parameters.\n");

#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
        bpf_iter_register();
#endif
}

For your convenience, this panic() is from the following commit:

commit 4b272750dbe6f92a8d39a0ee1c7bd50d6cc1a2c8
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Dec 8 11:41:54 2016 -0800

    udp: add busylocks in RX path
   =20
    Idea of busylocks is to let producers grab an extra spinlock
    to relieve pressure on the receive_queue spinlock shared by
    consumer.=20
    This behavior is requested only once socket receive queue is above
    half occupancy.
   =20
    Under flood, this means that only one producer can be in line
    trying to acquire the receive_queue spinlock.
   =20
    These busylock can be allocated on a per cpu manner, instead of a
    per socket one (that would consume a cache line per socket)
   =20
    This patch considerably improves UDP behavior under stress,
    depending on number of NIC RX queues and/or RPS spread.

This is very early in the boot process so I don't have textual output
to paste, and the screen is pretty much on 80x25.  Let me know if you
really need the backtrace/dump.

It should reproduce on as early as 6.1-rc5 (which was the first time I
tried to enable FORCE_NR_CPUS, as far as I can tell), but most likely
any version since the mentioned commit went upstream.

For reference, I'll leave the full .config.old in this Github gist:

	https://gist.github.com/rnsanchez/fd60d25625a0459b4ee10b653fc11f93

If you need to know which CPU I'm using:

Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         39 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  12
  On-line CPU(s) list:   0-11
Vendor ID:               GenuineIntel
  Model name:            Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
    CPU family:          6
    Model:               158
    Thread(s) per core:  2
    Core(s) per socket:  6
    Socket(s):           1
    Stepping:            10
    CPU(s) scaling MHz:  93%
    CPU max MHz:         4600.0000
    CPU min MHz:         800.0000
    BogoMIPS:            6399.96

Let me know if you need any more information.

Please keep me in Cc:.

Best regards,

--=20
Ricardo Nabinger Sanchez

    Dedique-se a melhorar seus esfor=E7os.
    Todas as suas conquistas evolutivas n=E3o foram resultado dos
    deuses, das outras consci=EAncias, ou do acaso, mas unicamente
    da sua transpira=E7=E3o. ---Waldo Vieira, L=E9xico de Ortopensatas

