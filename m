Return-Path: <netdev+bounces-563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462096F82AC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25D5A1C2182F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5903E8BF1;
	Fri,  5 May 2023 12:10:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0F5156CD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:10:40 +0000 (UTC)
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A346D19427
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 05:10:38 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-33164ec77ccso552935ab.0
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 05:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683288638; x=1685880638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tidKINGncTA+p8ufXsH97B8VbplL15U4SOqjeLKOv9Y=;
        b=Qa1lnDP3l0k8Xxa+71SWmPWHhAK4xR5nm2JTccTw0ouSLk777GR+fKH3/I/fWY4wCH
         4+5wSsRkFXN8UPLVVNxvBZmDxKMDebkojJbgjT5eeZCZnZ0ChXWwfaC52b7hBuk/63z6
         H+t5gTucE9URBCD0dHYHCOZbIn82h3iPFZWCv3UZqdwBFxEy1NslnVGpd3wFdU2cjsS+
         ZpDBzZmBRPKr6yNgP3bJrLaj+cLxgkqWJiwRRg8uSa8r9np9JKl36uf6vMFAhuhGc+/S
         XM2hCGTp5Zpc9yv025hX/+dEpUNOV6IWCl+df2WLbr11O/ZLp0hMjeGjbMfNAOma6R7S
         4Z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683288638; x=1685880638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tidKINGncTA+p8ufXsH97B8VbplL15U4SOqjeLKOv9Y=;
        b=MVAt2gulcEyyUDwhv/1cBxZyrGLfqxxOFxFffp0BsnyxQat5eV6WETCVUtDtNBGsbu
         6xCPkmBZ4Fjt94//VvKJHaIQiEeGIJhkdohkIs1dTuiE/fqs+JHtuFN/TtQNywyKPKFb
         4SsZ1NoaOHpnbqa3W2mKThibuFEdNTx8NAyPTSfgN+dXIBGEspRQFlgXMVTDAZ666yLW
         bWUZKZqyp4jESDKFhq1K2HzsImERDjiQvtyf4ZgZkbidPohPDeUyBzRVC3yNO9Y1LYi7
         TZQEwb/Cc+IuZas/Ngm4qwhCUzGHcX+5Rizs4hBf0yFQi4XdLHOcpxB7Vpz/CBL73n1z
         MAiw==
X-Gm-Message-State: AC+VfDzZJ7N+0jUhh4dtpilHa2RAyvVvrTC/IJf3kQS4SktFvXAlBfTz
	UVx8OIIexSm5rt96c+0YpWq1ulIxnwiDy5Uyv17oiA==
X-Google-Smtp-Source: ACHHUZ6+Sz9wXGNsJ54naDmeqrAHxiUZczPWVTomwvEYzipZXiygcBekORjvmD8FIQXG1o8L2hCtcBkjM4L0mNtEMX4=
X-Received: by 2002:a05:6e02:1609:b0:329:3f69:539e with SMTP id
 t9-20020a056e02160900b003293f69539emr158778ilu.2.1683288637752; Fri, 05 May
 2023 05:10:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230505113315.3307723-1-liujian56@huawei.com> <20230505113315.3307723-5-liujian56@huawei.com>
In-Reply-To: <20230505113315.3307723-5-liujian56@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 5 May 2023 14:10:26 +0200
Message-ID: <CANn89iJL3ywLwig8U6JKG6itL7Fr=ab_dv7Pz1YDiDvCiR-Fog@mail.gmail.com>
Subject: Re: [PATCH 4/9] softirq: Allow early break
To: Liu Jian <liujian56@huawei.com>
Cc: corbet@lwn.net, paulmck@kernel.org, frederic@kernel.org, 
	quic_neeraju@quicinc.com, joel@joelfernandes.org, josh@joshtriplett.org, 
	boqun.feng@gmail.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang1.zhang@intel.com, jstultz@google.com, 
	tglx@linutronix.de, sboyd@kernel.org, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, peterz@infradead.org, frankwoo@google.com, 
	Rhinewuwu@google.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 1:24=E2=80=AFPM Liu Jian <liujian56@huawei.com> wrot=
e:
>
> From: Peter Zijlstra <peterz@infradead.org>
>
> Allow terminating the softirq processing loop without finishing the
> vectors.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  kernel/softirq.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 48a81d8ae49a..e2cad5d108c8 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -582,6 +582,9 @@ asmlinkage __visible void __softirq_entry __do_softir=
q(void)
>                                prev_count, preempt_count());
>                         preempt_count_set(prev_count);
>                 }
> +
> +               if (pending && __softirq_needs_break(start))
> +                       break;

This means that some softirq may starve, because

for_each_set_bit(vec_nr, &pending, NR_SOFTIRQS)

Always iterate using the same order (of bits)




>         }
>
>         if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
> @@ -590,13 +593,14 @@ asmlinkage __visible void __softirq_entry __do_soft=
irq(void)
>
>         local_irq_disable();
>
> -       pending =3D local_softirq_pending();
> -       if (pending) {
> -               if (!__softirq_needs_break(start) && --max_restart)
> -                       goto restart;
> +       if (pending)
> +               or_softirq_pending(pending);
> +       else if ((pending =3D local_softirq_pending()) &&
> +                !__softirq_needs_break(start) &&
> +                --max_restart)
> +               goto restart;
>
> -               wakeup_softirqd();
> -       }
> +       wakeup_softirqd();
>
>         account_softirq_exit(current);
>         lockdep_softirq_end(in_hardirq);
> --
> 2.34.1
>

