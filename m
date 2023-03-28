Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC236CCD3B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjC1Wao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjC1Wal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:30:41 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7C11BEF
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:30:39 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h14so5794833ilj.0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680042639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XfrOsOpnqxrdbXw8cTpOjnxBsJ1WSvwEhP/QCOfZvvM=;
        b=AYZZ+7FN2S0eFfWorKzduUULM2BMIh3SqbYaWQX6KuhcT1YbPyif2xYDrAJ1QT3d2q
         ISh9i0FHBIN3JXd484BwYdfRQclk8eULgKRL3aXULq3P6MSBckvdnb9HJWzP6EWA2FDH
         rozer6sKkrIq6+tJurfUip3LB/c3NiS6GffJCbi9kR5ec2aO+CEOqAMi9YMaD4xdJWMJ
         jiH6G+aUtgNtjTdJQG3eT+o3E5ppNeRe6JWvSGZ+IpaymYbEe6Nf6FbSnzlmhomgGr1c
         Zc/ulJ/lVkXN3IeCaUfuac3otZVMEnECqaEcpor3aRAlQN6NI2tGOpPy9h6mU2F8/awQ
         BxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680042639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XfrOsOpnqxrdbXw8cTpOjnxBsJ1WSvwEhP/QCOfZvvM=;
        b=kY3tayHKDokUAFIqxmrNFEp2LavZbP8ZaseYeLVMJ6yc1Ad/92pbdwfpmdWRJmpNOT
         oMZlCYzThOHty9l/OblGBgR5jzbZA0iMCQ9OJoP7ZVDCcIzdmJOdJs8K6hbAemhWX5bY
         ydYwEF4OULygXvXozaZzFQLxCF/qHTVQVwAAtJFD8xO+gseN74g16QjRP29GxgBWZgVj
         HooUI7AL+trDmh8A71ZzUvDTZbQga2S4PXCPc4wdyncgrWvEOhe2EfFeSCOtZBn+aF8W
         9pLSoaBJ37L560GV3vJnaNL8zafw32zF19f8+hkagXFhY6AjnXrrGE4Ucqlaxk5ZhXtt
         aiFw==
X-Gm-Message-State: AAQBX9frVHPyGAfISGtyRDWLTz9GYccR6Iu3fudEbRRalaFv+lB2Jscg
        LX07NO3I/nIfKaK8sCNs7JL72mU75Mm2djLx8Kie3Q==
X-Google-Smtp-Source: AKy350ZK5IyYA9Wk4KwHRYcFlwgupqb8zlGkiiXMerP6RT7ZRB3sqFXY2PYSe7FENYWQkdqCH95ry1OfFmMXvph6qq4=
X-Received: by 2002:a05:6e02:218d:b0:322:fd25:872c with SMTP id
 j13-20020a056e02218d00b00322fd25872cmr9145652ila.2.1680042638741; Tue, 28 Mar
 2023 15:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230328195925.94495-1-nbd@nbd.name>
In-Reply-To: <20230328195925.94495-1-nbd@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 Mar 2023 00:30:27 +0200
Message-ID: <CANn89iJ1-xSmTXbfhhiBxFE5cH=o4QWQdguWZUuSs8fehbOC=A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/core: add optional threading for backlog processing
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 9:59=E2=80=AFPM Felix Fietkau <nbd@nbd.name> wrote:
>
> When dealing with few flows or an imbalance on CPU utilization, static RP=
S
> CPU assignment can be too inflexible. Add support for enabling threaded N=
API
> for backlog processing in order to allow the scheduler to better balance
> processing. This helps better spread the load across idle CPUs.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
> v2:
>  - initialize sd->backlog.poll_list in order fix switching backlogs to th=
readed
>    that have not been scheduled before
> PATCH:
>  - add missing process_queue_empty initialization
>  - fix kthread leak
>  - add documentation
> RFC v3:
>  - make patch more generic, applies to backlog processing in general
>  - fix process queue access on flush
> RFC v2:
>  - fix rebase error in rps locking
>  Documentation/admin-guide/sysctl/net.rst |  9 +++
>  Documentation/networking/scaling.rst     | 20 ++++++
>  include/linux/netdevice.h                |  2 +
>  net/core/dev.c                           | 83 ++++++++++++++++++++++--
>  net/core/sysctl_net_core.c               | 27 ++++++++
>  5 files changed, 136 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/adm=
in-guide/sysctl/net.rst
> index 466c560b0c30..6d037633a52f 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -47,6 +47,15 @@ Table : Subdirectories in /proc/sys/net
>  1. /proc/sys/net/core - Network core options
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> +backlog_threaded
> +----------------
> +
> +This offloads processing of backlog (input packets steered by RPS, or
> +queued because the kernel is receiving more than it can handle on the
> +incoming CPU) to threads (one for each CPU) instead of processing them
> +in softirq context. This can improve load balancing by allowing the
> +scheduler to better spread the load across idle CPUs.
> +
>  bpf_jit_enable
>  --------------
>
> diff --git a/Documentation/networking/scaling.rst b/Documentation/network=
ing/scaling.rst
> index 3d435caa3ef2..ded6fc713304 100644
> --- a/Documentation/networking/scaling.rst
> +++ b/Documentation/networking/scaling.rst
> @@ -244,6 +244,26 @@ Setting net.core.netdev_max_backlog to either 1000 o=
r 10000
>  performed well in experiments.
>
>
> +Threaded Backlog
> +~~~~~~~~~~~~~~~~
> +
> +When dealing with few flows or an imbalance on CPU utilization, static
> +RPS CPU assignment can be too inflexible. Making backlog processing
> +threaded can improve load balancing by allowing the scheduler to spread
> +the load across idle CPUs.
> +
> +
> +Suggested Configuration
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +If you have CPUs fully utilized with network processing, you can enable
> +threaded backlog processing by setting /proc/sys/net/core/backlog_thread=
ed
> +to 1. Afterwards, RPS CPU configuration bits no longer refer to CPU
> +numbers, but to backlog threads named napi/backlog-<n>.
> +If necessary, you can change the CPU affinity of these threads to limit
> +them to specific CPU cores.
> +
> +
>  RFS: Receive Flow Steering
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 18a5be6ddd0f..953876cb0e92 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -527,6 +527,7 @@ static inline bool napi_complete(struct napi_struct *=
n)
>  }
>
>  int dev_set_threaded(struct net_device *dev, bool threaded);
> +int backlog_set_threaded(bool threaded);
>
>  /**
>   *     napi_disable - prevent NAPI from scheduling
> @@ -3217,6 +3218,7 @@ struct softnet_data {
>         unsigned int            cpu;
>         unsigned int            input_queue_tail;
>  #endif
> +       unsigned int            process_queue_empty;

Hmmm... probably better close to input_queue_head, to share a
dedicated cache line already dirtied
with input_queue_head_incr()

I also think we could avoid adding this new field.

Use instead input_queue_head, latching its value in void
flush_backlog() and adding sd->process_queue length ?

Then waiting for (s32)(input_queue_head - latch) >=3D 0 ?


>                         /*
>                          * Inline a custom version of __napi_complete().
> -                        * only current cpu owns and manipulates this nap=
i,
> -                        * and NAPI_STATE_SCHED is the only possible flag=
 set
> -                        * on backlog.
> +                        * only current cpu owns and manipulates this nap=
i.
>                          * We can use a plain write instead of clear_bit(=
),
>                          * and we dont need an smp_mb() memory barrier.
>                          */
> -                       napi->state =3D 0;
> +                       napi->state &=3D ~(NAPIF_STATE_SCHED |
> +                                        NAPIF_STATE_SCHED_THREADED);
>                         again =3D false;
>                 } else {
>                         skb_queue_splice_tail_init(&sd->input_pkt_queue,
> @@ -6350,6 +6370,55 @@ int dev_set_threaded(struct net_device *dev, bool =
threaded)
>  }
>  EXPORT_SYMBOL(dev_set_threaded);
>
> +int backlog_set_threaded(bool threaded)
> +{
> +       static bool backlog_threaded;
> +       int err =3D 0;
> +       int i;
> +
> +       if (backlog_threaded =3D=3D threaded)
> +               return 0;
> +
> +       for_each_possible_cpu(i) {
> +               struct softnet_data *sd =3D &per_cpu(softnet_data, i);
> +               struct napi_struct *n =3D &sd->backlog;
> +
> +               if (n->thread)
> +                       continue;
> +               n->thread =3D kthread_run(napi_threaded_poll, n, "napi/ba=
cklog-%d", i);
> +               if (IS_ERR(n->thread)) {
> +                       err =3D PTR_ERR(n->thread);
> +                       pr_err("kthread_run failed with err %d\n", err);
> +                       n->thread =3D NULL;
> +                       threaded =3D false;
> +                       break;
> +               }
> +
> +       }
> +
> +       backlog_threaded =3D threaded;
> +
> +       /* Make sure kthread is created before THREADED bit
> +        * is set.
> +        */
> +       smp_mb__before_atomic();
> +
> +       for_each_possible_cpu(i) {
> +               struct softnet_data *sd =3D &per_cpu(softnet_data, i);
> +               struct napi_struct *n =3D &sd->backlog;
> +               unsigned long flags;
> +
> +               rps_lock_irqsave(sd, &flags);
> +               if (threaded)
> +                       n->state |=3D NAPIF_STATE_THREADED;
> +               else
> +                       n->state &=3D ~NAPIF_STATE_THREADED;
> +               rps_unlock_irq_restore(sd, &flags);
> +       }
> +
> +       return err;
> +}
> +
>  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *n=
api,
>                            int (*poll)(struct napi_struct *, int), int we=
ight)
>  {
> @@ -11108,6 +11177,9 @@ static int dev_cpu_dead(unsigned int oldcpu)
>         raise_softirq_irqoff(NET_TX_SOFTIRQ);
>         local_irq_enable();
>
> +       if (test_bit(NAPI_STATE_THREADED, &oldsd->backlog.state))
> +               return 0;
> +
>  #ifdef CONFIG_RPS
>         remsd =3D oldsd->rps_ipi_list;
>         oldsd->rps_ipi_list =3D NULL;
> @@ -11411,6 +11483,7 @@ static int __init net_dev_init(void)
>                 INIT_CSD(&sd->defer_csd, trigger_rx_softirq, sd);
>                 spin_lock_init(&sd->defer_lock);
>
> +               INIT_LIST_HEAD(&sd->backlog.poll_list);
>                 init_gro_hash(&sd->backlog);
>                 sd->backlog.poll =3D process_backlog;
>                 sd->backlog.weight =3D weight_p;
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 74842b453407..77114cd0b021 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -30,6 +30,7 @@ static int int_3600 =3D 3600;
>  static int min_sndbuf =3D SOCK_MIN_SNDBUF;
>  static int min_rcvbuf =3D SOCK_MIN_RCVBUF;
>  static int max_skb_frags =3D MAX_SKB_FRAGS;
> +static int backlog_threaded;
>
>  static int net_msg_warn;       /* Unused, but still a sysctl */
>
> @@ -188,6 +189,23 @@ static int rps_sock_flow_sysctl(struct ctl_table *ta=
ble, int write,
>  }
>  #endif /* CONFIG_RPS */
>
> +static int backlog_threaded_sysctl(struct ctl_table *table, int write,
> +                              void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +       static DEFINE_MUTEX(backlog_threaded_mutex);
> +       int ret;
> +
> +       mutex_lock(&backlog_threaded_mutex);
> +
> +       ret =3D proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +       if (write && !ret)
> +               ret =3D backlog_set_threaded(backlog_threaded);
> +
> +       mutex_unlock(&backlog_threaded_mutex);
> +
> +       return ret;
> +}
> +
>  #ifdef CONFIG_NET_FLOW_LIMIT
>  static DEFINE_MUTEX(flow_limit_update_mutex);
>
> @@ -532,6 +550,15 @@ static struct ctl_table net_core_table[] =3D {
>                 .proc_handler   =3D rps_sock_flow_sysctl
>         },
>  #endif
> +       {
> +               .procname       =3D "backlog_threaded",
> +               .data           =3D &backlog_threaded,
> +               .maxlen         =3D sizeof(unsigned int),
> +               .mode           =3D 0644,
> +               .proc_handler   =3D backlog_threaded_sysctl,
> +               .extra1         =3D SYSCTL_ZERO,
> +               .extra2         =3D SYSCTL_ONE
> +       },
>  #ifdef CONFIG_NET_FLOW_LIMIT
>         {
>                 .procname       =3D "flow_limit_cpu_bitmap",
> --
> 2.39.0
>
