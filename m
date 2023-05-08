Return-Path: <netdev+bounces-809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5154E6F9FCA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 754701C2099C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A0913AFF;
	Mon,  8 May 2023 06:22:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB533E3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:22:32 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DB511B71;
	Sun,  7 May 2023 23:22:30 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-965a68abfd4so777001566b.2;
        Sun, 07 May 2023 23:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683526949; x=1686118949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vw8CSw8/kqkr/nW0ZHKrE8vFpeahAapoWHjswcPuL9E=;
        b=koEemG7vRAfynkdz9DNrQOAF6Jwa+C7C3q15nv2adIoHYNGLxSoPfHQq7C2pbgZzSg
         yzEv0NjsvAihk42RnJupvuFhKYcgs7+Lh7CM0D0ND2QE5D3lGuwq0GylR/H5GjBjRKKP
         RDh/ebS6b24gcGS8Ni5z8Yxgt2/vEYVVEkiiN0Y6S/7s8etmhFVyMvZ0Qea9L63SirDZ
         v91QCTGQANoXukJZSuzkT74qnAoLR3PcKbdFz5nXXsRT8cCbdK4hfoJzhoAB5K741I5t
         sdF7sVetn88njXsnaSnlVrEHKCP85oJXdN+lMRu3DXa7Z0WflRiAS0jpFZPCocby8cA4
         EM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683526949; x=1686118949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vw8CSw8/kqkr/nW0ZHKrE8vFpeahAapoWHjswcPuL9E=;
        b=OPN7pOuBY60dIZQu5N3jvBbanLsLEHZ2a98xaifcl2kiDZfy6gS6559ALGUwfATLDa
         dOvwBQfyVtob3+5cKt5ZVHhWp/i4KI/qeeo43+EuQd+osHmHJ23cVR/ewBqVp9nwDRuT
         0KA62dhPO+mlQrxY+f8SCinO9vj11xpuB6YuYsIzjgD1f2D9SGm6lKPeXcZ/KToG7vQ7
         NIppSE6MTimL45ofOtV4RYGVyaclhAgBTkJpo8eF38ygafGSuLRi255tQ6FXKvPkR23L
         ce92Ve8kzZX2Zh/m2f420cdHiet5nqQ/f0VyJEe8RHhKt0PY5H2m3NE2nXIu3iPFj5cC
         PMRw==
X-Gm-Message-State: AC+VfDz1h47rZAe6mgteGYP1Ahp7B4AKTluEUM6UiaNqIHzUWObR8cP2
	rorYu4rjzqLwDSNUU59XE13nshci1oUZmWLwY5A=
X-Google-Smtp-Source: ACHHUZ5328pDEz0a5JABi/wRllwutYN11eMceJJKBtx2CcdIcWeEs7l0hVe0ErW7kOxexcCvXxfuf+f0bwj4UE25KCc=
X-Received: by 2002:a17:907:26c6:b0:91f:b13f:a028 with SMTP id
 bp6-20020a17090726c600b0091fb13fa028mr6728320ejc.34.1683526948612; Sun, 07
 May 2023 23:22:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230505113315.3307723-1-liujian56@huawei.com> <20230505113315.3307723-8-liujian56@huawei.com>
In-Reply-To: <20230505113315.3307723-8-liujian56@huawei.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 8 May 2023 14:21:52 +0800
Message-ID: <CAL+tcoCKBcM8PnZ3_u-TFs8EyAGtuu7be7_akXBCX-gq0R2-+A@mail.gmail.com>
Subject: Re: [PATCH 7/9] softirq,net: Use softirq_needs_break()
To: Liu Jian <liujian56@huawei.com>
Cc: corbet@lwn.net, paulmck@kernel.org, frederic@kernel.org, 
	quic_neeraju@quicinc.com, joel@joelfernandes.org, josh@joshtriplett.org, 
	boqun.feng@gmail.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang1.zhang@intel.com, jstultz@google.com, 
	tglx@linutronix.de, sboyd@kernel.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, peterz@infradead.org, 
	frankwoo@google.com, Rhinewuwu@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 7:27=E2=80=AFPM Liu Jian <liujian56@huawei.com> wrot=
e:
>
> From: Peter Zijlstra <peterz@infradead.org>
>
> SoftIRQs provide their own timeout/break code now, use that.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 11 +----------
>  net/core/dev.c                           |  6 +-----
>  net/core/dev.h                           |  1 -
>  net/core/sysctl_net_core.c               |  8 --------
>  4 files changed, 2 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/adm=
in-guide/sysctl/net.rst
> index 466c560b0c30..095c60788c61 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -267,16 +267,7 @@ netdev_budget
>
>  Maximum number of packets taken from all interfaces in one polling cycle=
 (NAPI
>  poll). In one polling cycle interfaces which are registered to polling a=
re
> -probed in a round-robin manner. Also, a polling cycle may not exceed
> -netdev_budget_usecs microseconds, even if netdev_budget has not been
> -exhausted.
> -
> -netdev_budget_usecs
> ----------------------
> -
> -Maximum number of microseconds in one NAPI polling cycle. Polling
> -will exit when either netdev_budget_usecs have elapsed during the
> -poll cycle or the number of packets processed reaches netdev_budget.
> +probed in a round-robin manner.
>
>  netdev_max_backlog
>  ------------------
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 735096d42c1d..70b6726beee6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4321,7 +4321,6 @@ int netdev_tstamp_prequeue __read_mostly =3D 1;
>  unsigned int sysctl_skb_defer_max __read_mostly =3D 64;
>  int netdev_budget __read_mostly =3D 300;
>  /* Must be at least 2 jiffes to guarantee 1 jiffy timeout */
> -unsigned int __read_mostly netdev_budget_usecs =3D 2 * USEC_PER_SEC / HZ=
;
>  int weight_p __read_mostly =3D 64;           /* old backlog weight */
>  int dev_weight_rx_bias __read_mostly =3D 1;  /* bias for backlog weight =
*/
>  int dev_weight_tx_bias __read_mostly =3D 1;  /* bias for output_queue qu=
ota */
> @@ -6659,8 +6658,6 @@ static int napi_threaded_poll(void *data)
>  static __latent_entropy void net_rx_action(struct softirq_action *h)
>  {
>         struct softnet_data *sd =3D this_cpu_ptr(&softnet_data);
> -       unsigned long time_limit =3D jiffies +
> -               usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
>         int budget =3D READ_ONCE(netdev_budget);
>         LIST_HEAD(list);
>         LIST_HEAD(repoll);
> @@ -6699,8 +6696,7 @@ static __latent_entropy void net_rx_action(struct s=
oftirq_action *h)
>                  * Allow this to run for 2 jiffies since which will allow
>                  * an average latency of 1.5/HZ.
>                  */
> -               if (unlikely(budget <=3D 0 ||
> -                            time_after_eq(jiffies, time_limit))) {
> +               if (unlikely(budget <=3D 0 || softirq_needs_break(h))) {
>                         sd->time_squeeze++;
>                         break;
>                 }
> diff --git a/net/core/dev.h b/net/core/dev.h
> index e075e198092c..e64a60c767ab 100644
> --- a/net/core/dev.h
> +++ b/net/core/dev.h
> @@ -39,7 +39,6 @@ void dev_addr_check(struct net_device *dev);
>
>  /* sysctls not referred to from outside net/core/ */
>  extern int             netdev_budget;
> -extern unsigned int    netdev_budget_usecs;
>  extern unsigned int    sysctl_skb_defer_max;
>  extern int             netdev_tstamp_prequeue;
>  extern int             netdev_unregister_timeout_secs;
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 782273bb93c2..59765c805f5b 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -595,14 +595,6 @@ static struct ctl_table net_core_table[] =3D {
>                 .extra1         =3D SYSCTL_ONE,
>                 .extra2         =3D &max_skb_frags,
>         },
> -       {
> -               .procname       =3D "netdev_budget_usecs",
> -               .data           =3D &netdev_budget_usecs,
> -               .maxlen         =3D sizeof(unsigned int),
> -               .mode           =3D 0644,
> -               .proc_handler   =3D proc_dointvec_minmax,
> -               .extra1         =3D SYSCTL_ZERO,
> -       },

I cannot help asking whether we really need to remove the sysctl knob
because it can let some users tune this. It's useful for some cases, I
believe. Do you have any evidence/number to prove we can get rid of
this?

Thanks,
Jason

>         {
>                 .procname       =3D "fb_tunnels_only_for_init_net",
>                 .data           =3D &sysctl_fb_tunnels_only_for_init_net,
> --
> 2.34.1
>
>

