Return-Path: <netdev+bounces-10516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 950EE72ECC8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E328281238
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD5B3D3AE;
	Tue, 13 Jun 2023 20:20:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E9D136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:20:07 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF801BEF
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:19:46 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f9d619103dso2941cf.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686687585; x=1689279585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dr/hNDqeNMt0Zodnd16RuaB3rHPqCK1WibdMLfwqwik=;
        b=Gd8isxhqKgPJs3Drcr3O/ci0ju7YoIUIVB9bIwXP2WNSIq6cDPLoY5oADgjsMY9UzI
         9X6YagCmqS+mtOPCZISpIVcnk2aLnaXpeCw7DiM1yRNcVCm23smN2pRhXOtSydCQ0icK
         yv7y0M1apdJQ7YbQLvT9TS3ybyMmoNpzQIU50GwNzmrhxB3WC2NjQTdfGTF9YcCuGgSe
         p2B1rKZy18XtTMvqI8IH57IAWn8PMgWa8GTv0PeZnMrG3NeYiumdWRZAdTIvv9gOyMA5
         AaERa/g0gtz4Rbu5Yr857aDbfBNkToFq4okf2HaeDY+UxEImj0zeWumjrnU/RgGRr+IQ
         3WpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686687585; x=1689279585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dr/hNDqeNMt0Zodnd16RuaB3rHPqCK1WibdMLfwqwik=;
        b=VMwQAgjhr3WdLztIAQRWURuGyLg1PzvA3YX7TQVBU+cXv15MziSndjp6Nsdtc8OJbC
         PsuvG/tmPrkDJp4qaVVDw83hS2Ffrs7hVfBERGy/Y3fmg4lLRtn2j/gmHLl8D3J808Nc
         7tjo22VhcpJdrtJcekOffz2dUKF2o83oaLTvLoSrbhYS7gY1goI+NyXjwQFSU88EYFV2
         g8gJ8g0xOBHOedTwaGlNQVi6cINFk4Jccj9ELs6fPlQZr8orbuQAxIK7W5D6pBtoCIvX
         7+dtNN4O3XK7FDlrpiKJv/LCSKYmRtOzx82xViCh7+AwSLSN2m7+/jqKxC199rb5Ub4x
         okWw==
X-Gm-Message-State: AC+VfDz7ZcI365C2Iy/HSvGB/2RRWd++C+Qi9/vvU57cuG0gONTqC2i7
	oGVJitnxoDSTn2Ncb1TAoc91nvvoW5lHpWUPclXAoA==
X-Google-Smtp-Source: ACHHUZ4+1vmvLDMUfAo6tq7ONCOZryebZdOCU9VIQa/8OGTcZNP7huTptsksEtMdGM6S/CtYWnMBsvCApU91OZorlNI=
X-Received: by 2002:a05:622a:283:b0:3f9:f877:1129 with SMTP id
 z3-20020a05622a028300b003f9f8771129mr26036qtw.29.1686687584508; Tue, 13 Jun
 2023 13:19:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230613165654.3e75eda8@espresso.lan.box>
In-Reply-To: <20230613165654.3e75eda8@espresso.lan.box>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 13 Jun 2023 22:19:33 +0200
Message-ID: <CANn89i+5DoHFh-2MvLy740ikLdV-sE8pEEM+R=i0i77Pyc1ADQ@mail.gmail.com>
Subject: Re: panic in udp_init() when using FORCE_NR_CPUS
To: Ricardo Nabinger Sanchez <rnsanchez@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 9:56=E2=80=AFPM Ricardo Nabinger Sanchez
<rnsanchez@gmail.com> wrote:
>
> Hello,
>
> I have hit again an old panic that, in the past, I could not check in
> more depth.  But today I was able to pinpoint to a single config knob:
>
> $ diff -u /mnt/tmp/Kernel/linux-6.4-rc6/.config{.old,}
> --- /mnt/tmp/Kernel/linux-6.4-rc6/.config.old   2023-06-13
> 10:34:11.881004307 -0300 +++
> /mnt/tmp/Kernel/linux-6.4-rc6/.config   2023-06-13
> 13:42:46.396967635 -0300 @@ -4996,7 +4996,7 @@ CONFIG_SGL_ALLOC=3Dy
>  CONFIG_CHECK_SIGNATURE=3Dy
>  CONFIG_CPUMASK_OFFSTACK=3Dy
> -CONFIG_FORCE_NR_CPUS=3Dy
> +# CONFIG_FORCE_NR_CPUS is not set
>  CONFIG_CPU_RMAP=3Dy
>  CONFIG_DQL=3Dy
>  CONFIG_GLOB=3Dy
>

Sure, but you did not give NR_CPUS value ?

Also posting the stack trace might be useful.

> Today's build is 6.4-rc6 tarball from kernel.org and, if I enable
> FORCE_NR_CPUS, it panic()s after doing kmalloc(), with
>
>         "UDP: failed to alloc udp_busylocks"
>
> Backtrace leads to:
>
> void __init udp_init(void)
> {
>         unsigned long limit;
>         unsigned int i;
>
>         udp_table_init(&udp_table, "UDP");
>         limit =3D nr_free_buffer_pages() / 8;
>         limit =3D max(limit, 128UL);
>         sysctl_udp_mem[0] =3D limit / 4 * 3;
>         sysctl_udp_mem[1] =3D limit;
>         sysctl_udp_mem[2] =3D sysctl_udp_mem[0] * 2;
>
>         /* 16 spinlocks per cpu */
>         udp_busylocks_log =3D ilog2(nr_cpu_ids) + 4;
>         udp_busylocks =3D kmalloc(sizeof(spinlock_t) << udp_busylocks_log=
,
>                                 GFP_KERNEL);
>         if (!udp_busylocks)
>                 panic("UDP: failed to alloc udp_busylocks\n");
>         for (i =3D 0; i < (1U << udp_busylocks_log); i++)
>                 spin_lock_init(udp_busylocks + i);
>
>         if (register_pernet_subsys(&udp_sysctl_ops))
>                 panic("UDP: failed to init sysctl parameters.\n");
>
> #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
>         bpf_iter_register();
> #endif
> }
>
> For your convenience, this panic() is from the following commit:
>
> commit 4b272750dbe6f92a8d39a0ee1c7bd50d6cc1a2c8
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Dec 8 11:41:54 2016 -0800
>
>     udp: add busylocks in RX path
>
>     Idea of busylocks is to let producers grab an extra spinlock
>     to relieve pressure on the receive_queue spinlock shared by
>     consumer.
>     This behavior is requested only once socket receive queue is above
>     half occupancy.
>
>     Under flood, this means that only one producer can be in line
>     trying to acquire the receive_queue spinlock.
>
>     These busylock can be allocated on a per cpu manner, instead of a
>     per socket one (that would consume a cache line per socket)
>
>     This patch considerably improves UDP behavior under stress,
>     depending on number of NIC RX queues and/or RPS spread.
>
> This is very early in the boot process so I don't have textual output
> to paste, and the screen is pretty much on 80x25.  Let me know if you
> really need the backtrace/dump.
>
> It should reproduce on as early as 6.1-rc5 (which was the first time I
> tried to enable FORCE_NR_CPUS, as far as I can tell), but most likely
> any version since the mentioned commit went upstream.
>
> For reference, I'll leave the full .config.old in this Github gist:
>
>         https://gist.github.com/rnsanchez/fd60d25625a0459b4ee10b653fc11f9=
3
>
> If you need to know which CPU I'm using:
>
> Architecture:            x86_64
>   CPU op-mode(s):        32-bit, 64-bit
>   Address sizes:         39 bits physical, 48 bits virtual
>   Byte Order:            Little Endian
> CPU(s):                  12
>   On-line CPU(s) list:   0-11
> Vendor ID:               GenuineIntel
>   Model name:            Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
>     CPU family:          6
>     Model:               158
>     Thread(s) per core:  2
>     Core(s) per socket:  6
>     Socket(s):           1
>     Stepping:            10
>     CPU(s) scaling MHz:  93%
>     CPU max MHz:         4600.0000
>     CPU min MHz:         800.0000
>     BogoMIPS:            6399.96
>
> Let me know if you need any more information.
>
> Please keep me in Cc:.
>
> Best regards,
>
> --
> Ricardo Nabinger Sanchez
>
>     Dedique-se a melhorar seus esfor=C3=A7os.
>     Todas as suas conquistas evolutivas n=C3=A3o foram resultado dos
>     deuses, das outras consci=C3=AAncias, ou do acaso, mas unicamente
>     da sua transpira=C3=A7=C3=A3o. ---Waldo Vieira, L=C3=A9xico de Ortope=
nsatas

