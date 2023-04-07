Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E986DB03B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjDGQJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjDGQJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:09:42 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814E6BDDF
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:09:19 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id h198so5681496ybg.12
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680883758; x=1683475758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG4bkww4TTKH5g62+sthOLOmqZqedZWZduXMaCftkq4=;
        b=wO/b6t0TAhKJ7bG5BAH8ilaCdIekWtZdXo5wLOJrG1RO6kku1Vr/OAiB5x05nSbiI8
         SkPgZpgZ4/6tGs8Hthod/dDkKpFZFHb8joim2BmuiCYWF3hd61faFClVR65J3+xUgvHc
         QMbssiyAzV/1FDNc8tpgAgYWN+Rv+4vlQp2g3YFzJJhnw37gziOreeGwHxNTJw21n2Wr
         0ikt8o8jq84Za+/DrAJj/OHHBqwbNS1pWwaGK5KaQYQC3WAWSBPl7ZERAOWjv0H0o/L1
         rH7U5HtwbZ2jwD2CBRhOzk0vq8Ow2ShAtcsIgPn57RKCu6W+el9HMkgXz4TYhkK2I3qR
         VRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680883758; x=1683475758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pG4bkww4TTKH5g62+sthOLOmqZqedZWZduXMaCftkq4=;
        b=OV0Amqx2yzntw+AB51AxCpEUQCbe4yo+vwR2wGp3FwMFTke3WAtid+IKdxkYIngvDw
         NxZWc6i8wDAj+o64vf0l45uz5hwqRS63jCnfZPg0uRciPz/f7KL/wBWvkkiYFo2LWsrq
         LNhAQi/6ECAuXOFfBeJa2lZ6DpHcwwk6XmBbmZjVMT2NrtJCypecVsmwE4E02tUAJncN
         rYT+HDGfH2KU3jWM93Xj8Oo8EIbSKYTvX7d/ukNEhgjJTkOf5ws9wrzXT8kIh+QxoH14
         VpaWPjAyQ4yRpsmYa2T25uCd9KYSu8VlBX02lkCHUc9ILCH3T2BZRiPbR6jkLQawC5r6
         oMdw==
X-Gm-Message-State: AAQBX9ce3B+g8RXZYToD3jyieHRAYjPQ6Fw5BgvOE8CV7g4bEdGqlBt6
        P3A+8jcbkAvEot8oBrxUk+oCQ729dHrmkkiboHXeVU3Hzit87L547TQ=
X-Google-Smtp-Source: AKy350YoEtAJiSIWvIlzd/ZkwZq+Yj/GschfHgVBkfpUuNJ35GSsEj8AzA1+CZ84p3LXxGc5NvSh1Y/+A/AOmcmytDM=
X-Received: by 2002:a25:7490:0:b0:b78:45fd:5f01 with SMTP id
 p138-20020a257490000000b00b7845fd5f01mr2072667ybc.7.1680883758618; Fri, 07
 Apr 2023 09:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com> <20230403103440.2895683-6-vladimir.oltean@nxp.com>
In-Reply-To: <20230403103440.2895683-6-vladimir.oltean@nxp.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 12:09:07 -0400
Message-ID: <CAM0EoM=4DOj3Np3a_uYxKp2fD2pUPkaF_QiZjuD57c00pjncuA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 5/9] net/sched: pass netlink extack to mqprio
 and taprio offload
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 6:35=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> With the multiplexed ndo_setup_tc() model which lacks a first-class
> struct netlink_ext_ack * argument, the only way to pass the netlink
> extended ACK message down to the device driver is to embed it within the
> offload structure.
>
> Do this for struct tc_mqprio_qopt_offload and struct tc_taprio_qopt_offlo=
ad.
>
> Since struct tc_taprio_qopt_offload also contains a tc_mqprio_qopt_offloa=
d
> structure, and since device drivers might effectively reuse their mqprio
> implementation for the mqprio portion of taprio, we make taprio set the
> extack in both offload structures to point at the same netlink extack
> message.
>
> In fact, the taprio handling is a bit more tricky, for 2 reasons.
>
> First is because the offload structure has a longer lifetime than the
> extack structure. The driver is supposed to populate the extack
> synchronously from ndo_setup_tc() and leave it alone afterwards.
> To not have any use-after-free surprises, we zero out the extack pointer
> when we leave taprio_enable_offload().
>
> The second reason is because taprio does overwrite the extack message on
> ndo_setup_tc() error. We need to switch to the weak form of setting an
> extack message, which preserves a potential message set by the driver.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
> v3->v4: none
> v2->v3: patch is new
>
>  include/net/pkt_sched.h |  2 ++
>  net/sched/sch_mqprio.c  |  5 ++++-
>  net/sched/sch_taprio.c  | 12 ++++++++++--
>  3 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index bb0bd69fb655..b43ed4733455 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -166,6 +166,7 @@ struct tc_mqprio_caps {
>  struct tc_mqprio_qopt_offload {
>         /* struct tc_mqprio_qopt must always be the first element */
>         struct tc_mqprio_qopt qopt;
> +       struct netlink_ext_ack *extack;
>         u16 mode;
>         u16 shaper;
>         u32 flags;
> @@ -193,6 +194,7 @@ struct tc_taprio_sched_entry {
>
>  struct tc_taprio_qopt_offload {
>         struct tc_mqprio_qopt_offload mqprio;
> +       struct netlink_ext_ack *extack;
>         u8 enable;
>         ktime_t base_time;
>         u64 cycle_time;
> diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
> index 9ee5a9a9b9e9..5287ff60b3f9 100644
> --- a/net/sched/sch_mqprio.c
> +++ b/net/sched/sch_mqprio.c
> @@ -33,9 +33,12 @@ static int mqprio_enable_offload(struct Qdisc *sch,
>                                  const struct tc_mqprio_qopt *qopt,
>                                  struct netlink_ext_ack *extack)
>  {
> -       struct tc_mqprio_qopt_offload mqprio =3D {.qopt =3D *qopt};
>         struct mqprio_sched *priv =3D qdisc_priv(sch);
>         struct net_device *dev =3D qdisc_dev(sch);
> +       struct tc_mqprio_qopt_offload mqprio =3D {
> +               .qopt =3D *qopt,
> +               .extack =3D extack,
> +       };
>         int err, i;
>
>         switch (priv->mode) {
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 1f469861eae3..cbad43019172 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1520,7 +1520,9 @@ static int taprio_enable_offload(struct net_device =
*dev,
>                 return -ENOMEM;
>         }
>         offload->enable =3D 1;
> +       offload->extack =3D extack;
>         mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
> +       offload->mqprio.extack =3D extack;
>         taprio_sched_to_offload(dev, sched, offload, &caps);
>
>         for (tc =3D 0; tc < TC_MAX_QUEUE; tc++)
> @@ -1528,14 +1530,20 @@ static int taprio_enable_offload(struct net_devic=
e *dev,
>
>         err =3D ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>         if (err < 0) {
> -               NL_SET_ERR_MSG(extack,
> -                              "Device failed to setup taprio offload");
> +               NL_SET_ERR_MSG_WEAK(extack,
> +                                   "Device failed to setup taprio offloa=
d");
>                 goto done;
>         }
>
>         q->offloaded =3D true;
>
>  done:
> +       /* The offload structure may linger around via a reference taken =
by the
> +        * device driver, so clear up the netlink extack pointer so that =
the
> +        * driver isn't tempted to dereference data which stopped being v=
alid
> +        */
> +       offload->extack =3D NULL;
> +       offload->mqprio.extack =3D NULL;
>         taprio_offload_free(offload);
>
>         return err;
> --
> 2.34.1
>
