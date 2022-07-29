Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D085854F3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 20:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiG2SOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 14:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiG2SOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 14:14:31 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B79666B8B
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:14:30 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i10-20020a1c3b0a000000b003a2fa488efdso2282753wma.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1bEysmv7DUwDiWfIZxDD+RekV6Ic0d49dGNuoQ3mv7w=;
        b=db9Krd1aWfoeKZCHnw+UDhb91HCFeqrPMGUQ1R3yQnidJ5hiXpakr1RU1i7zouiQKH
         t4v9KRh4GJREQ1dW97zpem8UqI15hoGyDyNMS+WFvhoporiwHRdSgZ7iyxHAhmR3ixrm
         MUs4/6JG5zdMpTEp0eE3Pv9tqtwG94WbpYjFb5VGdCQYMwCmBJl9HyNzc9WXyq/5ioIO
         XJYLsUp5pEYYiBWD19FWoijrcAOQhg1PjhunIfwWIHG+iptBoEXziQSVnDFe5oSIqAJM
         qm1/MWbv8YHPTZS/EWhz9eeQ+ZUBF/SkjwOZOQq0bl5xhWSLclUdb5tl3PVUuGrIqMuk
         FSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1bEysmv7DUwDiWfIZxDD+RekV6Ic0d49dGNuoQ3mv7w=;
        b=uQA0RC7OfEH38gYQ0NtAUsQTsiQThdR4M48c3nlHt7djvRlykN4PXYZSH7tsYN0iqw
         8+VGJx+fsAHNGbbsu7k/UfUzVoMBRoCT9ZK/7oUqq8K2O6H6wVFWPAMQzWxQ8LXJgRr8
         Y1bx7tSwn75eTFrQBoQSMHeq550V3Oz9MmIRQVboRhATmDW//z8fMiWf91v0EX5e7fsX
         fbrFCwUkAk464XCwbZIAL9ZTQIMTuKaXGUSsWDw9PsgVATYVhj75AOMFyPx1pCO9U+c9
         jE5NTfEjR9FvKTVyrCErKU6FVJo00xand+OxTh/bWLQwsxNgzOF/eTiDb5puMswcNYRL
         nqJw==
X-Gm-Message-State: AJIora8prA81oBHqhpBllxi13tBVxEkU1b9kcQBRaxlfDxLOHMC/r1kn
        pl61Z38sZfRNbMc8c9lqm3EreM0bPXMENEtVyZqd6c+bukk=
X-Google-Smtp-Source: AGRyM1vNIqqTynC14515u9J2/P0rkP479B1tf7gFxlPj4mKK5VbRn/Qndwl2NlKP/tDgXTEl7bGDMaVW7E4oJQGDFow=
X-Received: by 2002:a1c:21c3:0:b0:3a2:fdba:3f39 with SMTP id
 h186-20020a1c21c3000000b003a2fdba3f39mr3434545wmh.194.1659118468514; Fri, 29
 Jul 2022 11:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220729174316.398063-1-anthony.l.nguyen@intel.com> <20220729174316.398063-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20220729174316.398063-3-anthony.l.nguyen@intel.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 29 Jul 2022 11:14:14 -0700
Message-ID: <CAA93jw5wLd7UhdsMUsx4hsUSYK5gnY9iyq-=kvYz2U01p_G6SA@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] iavf: Fix 'tc qdisc show' listing too many queues
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 11:11 AM Tony Nguyen <anthony.l.nguyen@intel.com> w=
rote:
>
> From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
>
> Fix tc qdisc show dev <ethX> root displaying too many fq_codel qdiscs.
> tc_modify_qdisc, which is caller of ndo_setup_tc, expects driver to call
> netif_set_real_num_tx_queues, which prepares qdiscs.
> Without this patch, fq_codel qdiscs would not be adjusted to number of
> queues on VF.
> e.g.:
> tc qdisc show dev <ethX>
> qdisc mq 0: root
> qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5=
ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5=
ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5=
ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5=
ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> tc qdisc add dev <ethX> root mqprio num_tc 2 map 1 0 0 0 0 0 0 0 queues 1=
@0 1@1 hw 1 mode channel shaper bw_rlimit max_rate 5000Mbit 150Mbit
> tc qdisc show dev <ethX>
> qdisc mqprio 8003: root tc 2 map 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
>              queues:(0:0) (1:1)
>              mode:channel
>              shaper:bw_rlimit   max_rate:5Gbit 150Mbit
> qdisc fq_codel 0: parent 8003:4 limit 10240p flows 1024 quantum 1514 targ=
et 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent 8003:3 limit 10240p flows 1024 quantum 1514 targ=
et 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent 8003:2 limit 10240p flows 1024 quantum 1514 targ=
et 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent 8003:1 limit 10240p flows 1024 quantum 1514 targ=
et 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>
> While after fix:
> tc qdisc add dev <ethX> root mqprio num_tc 2 map 1 0 0 0 0 0 0 0 queues 1=
@0 1@1 hw 1 mode channel shaper bw_rlimit max_rate 5000Mbit 150Mbit
> tc qdisc show dev <ethX> #should show 2, shows 4
> qdisc mqprio 8004: root tc 2 map 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
>              queues:(0:0) (1:1)
>              mode:channel
>              shaper:bw_rlimit   max_rate:5Gbit 150Mbit
> qdisc fq_codel 0: parent 8004:2 limit 10240p flows 1024 quantum 1514 targ=
et 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent 8004:1 limit 10240p flows 1024 quantum 1514 targ=
et 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

I am curious if the rate setting vs a vs codel in this scenario is
effective. Could you post tc -s qdisc show output while running a few
dozen iperfs or netperfs through it? (e.g. add -s
)
>
> Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
> Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
> Co-developed-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
> Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
> Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h      |  5 +++++
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 21 +++++++++++++++++++++
>  2 files changed, 26 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/etherne=
t/intel/iavf/iavf.h
> index c241fbc30f93..a988c08e906f 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
> @@ -431,6 +431,11 @@ struct iavf_adapter {
>         /* lock to protect access to the cloud filter list */
>         spinlock_t cloud_filter_list_lock;
>         u16 num_cloud_filters;
> +       /* snapshot of "num_active_queues" before setup_tc for qdisc add
> +        * is invoked. This information is useful during qdisc del flow,
> +        * to restore correct number of queues
> +        */
> +       int orig_num_active_queues;
>
>  #define IAVF_MAX_FDIR_FILTERS 128      /* max allowed Flow Director filt=
ers */
>         u16 fdir_active_fltr;
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/et=
hernet/intel/iavf/iavf_main.c
> index 51ae10eb348c..3dbfaead2ac7 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -3429,6 +3429,7 @@ static int __iavf_setup_tc(struct net_device *netde=
v, void *type_data)
>                         netif_tx_disable(netdev);
>                         iavf_del_all_cloud_filters(adapter);
>                         adapter->aq_required =3D IAVF_FLAG_AQ_DISABLE_CHA=
NNELS;
> +                       total_qps =3D adapter->orig_num_active_queues;
>                         goto exit;
>                 } else {
>                         return -EINVAL;
> @@ -3472,7 +3473,21 @@ static int __iavf_setup_tc(struct net_device *netd=
ev, void *type_data)
>                                 adapter->ch_config.ch_info[i].offset =3D =
0;
>                         }
>                 }
> +
> +               /* Take snapshot of original config such as "num_active_q=
ueues"
> +                * It is used later when delete ADQ flow is exercised, so=
 that
> +                * once delete ADQ flow completes, VF shall go back to it=
s
> +                * original queue configuration
> +                */
> +
> +               adapter->orig_num_active_queues =3D adapter->num_active_q=
ueues;
> +
> +               /* Store queue info based on TC so that VF gets configure=
d
> +                * with correct number of queues when VF completes ADQ co=
nfig
> +                * flow
> +                */
>                 adapter->ch_config.total_qps =3D total_qps;
> +
>                 netif_tx_stop_all_queues(netdev);
>                 netif_tx_disable(netdev);
>                 adapter->aq_required |=3D IAVF_FLAG_AQ_ENABLE_CHANNELS;
> @@ -3489,6 +3504,12 @@ static int __iavf_setup_tc(struct net_device *netd=
ev, void *type_data)
>                 }
>         }
>  exit:
> +       if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
> +               return 0;
> +
> +       netif_set_real_num_rx_queues(netdev, total_qps);
> +       netif_set_real_num_tx_queues(netdev, total_qps);
> +
>         return ret;
>  }
>
> --
> 2.35.1
>


--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
