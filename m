Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18816DB039
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjDGQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjDGQI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:08:58 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86D719D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:08:31 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54e40113cf3so22460397b3.12
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680883709; x=1683475709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LeEZxg1UYS1q1LhPGSoZJZ9gjeZy1fnhbR/cP8HF/o=;
        b=awIR+OnAfZQHVTuj2yAI08MICVo1FoFyzJbFl5vySdOvF5ihjHNlD2YKPRYCFW9An0
         pzlMnB1WyHj/c4mgrXyLiZ/INVqmLhjThn9W/IylKKPHde7yDX2Kg4/sOxl9ty4yu9rt
         JT7WykWXCB5uKyQSCCmi4PIpkiF0SOexiSV2wZxlk1dc2iC+4zzrbWwobYZzhi/9935G
         UZo/cVqmsBnISOXgQtyIaR8Ge3FWI43oCHh5I++ezP4U89PD5bNTUqfsVaI6cVPF6i9I
         qo5GZvT6qzBIWX2+wiJEvqJuRX00jhSmn0PCXvo3QnuZHG6eKkrZjWbzXmPiUGt5UyRw
         6thg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680883709; x=1683475709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LeEZxg1UYS1q1LhPGSoZJZ9gjeZy1fnhbR/cP8HF/o=;
        b=g1VePPoSjqef1rHTqLY22gNPgU5uV1rWxlpI/4CBzw6YeLg41m13Lo9ba8Blf7tHNZ
         dYI5zIbMRh5+Cc1y+6Dnb77U9pYH/U0MT7Xa0dYyZWcPiwXmybzYXPEn3VDGlMLMIPjq
         3fy7LVjSgu9LGdsXestO9bDqFvKynlHMUbCNfsuyu4+uy5APbEa/5y4f9MB309abBC86
         pJD5vmrhJeQfFBkI1J9UZ5LqPlfTbghzl7GuSiE3qBezPd8vsisR04otW2L9dTNIFhh7
         DQwucHMy5YV9xN20jFeKjBXZBMv30ZtG9Dqbrysdr3GsIMdXv8SuoI9hp+v9g+a62d1u
         y/9Q==
X-Gm-Message-State: AAQBX9dVID0GlzxWE3OHB9tiYWsixRJTquFXmT2Ug6OzP/MTiUvKOFJ8
        1Z9g/5E2dI4zcwG3uvZwjEjVlFKggcL6pa/kH+AVKw==
X-Google-Smtp-Source: AKy350Z6KRPSOSZ3YGzOesTXfsNpBulpvf1IoeAVC0oR6d1MsuNmHL1+pezZGj56+nJgd+PtdxptZLMQ1owXUgfOvfk=
X-Received: by 2002:a81:d304:0:b0:544:b9b2:5c32 with SMTP id
 y4-20020a81d304000000b00544b9b25c32mr1304432ywi.7.1680883709236; Fri, 07 Apr
 2023 09:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com> <20230403103440.2895683-5-vladimir.oltean@nxp.com>
In-Reply-To: <20230403103440.2895683-5-vladimir.oltean@nxp.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 12:08:18 -0400
Message-ID: <CAM0EoMmwER5--nkF2r4=qTHsTnCODy5F8VAo0j6HQOgeLLXbrw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 4/9] net/sched: mqprio: add an extack message
 to mqprio_parse_opt()
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
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
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
> Ferenc reports that a combination of poor iproute2 defaults and obscure
> cases where the kernel returns -EINVAL make it difficult to understand
> what is wrong with this command:
>
> $ ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name veth1
> $ tc qdisc add dev veth0 root mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
>         queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
> RTNETLINK answers: Invalid argument
>
> Hopefully with this patch, the cause is clearer:
>
> Error: Device does not support hardware offload.
>
> The kernel was (and still is) rejecting this because iproute2 defaults
> to "hw 1" if this command line option is not specified.
>
> Link: https://lore.kernel.org/netdev/ede5e9a2f27bf83bfb86d3e8c4ca7b34093b=
99e2.camel@inf.elte.hu/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
> ---
> v3->v4: none
> v2->v3: change link from patchwork to lore
> v1->v2: slightly reword last paragraph of commit message
>
>  net/sched/sch_mqprio.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
> index 5a9261c38b95..9ee5a9a9b9e9 100644
> --- a/net/sched/sch_mqprio.c
> +++ b/net/sched/sch_mqprio.c
> @@ -133,8 +133,11 @@ static int mqprio_parse_opt(struct net_device *dev, =
struct tc_mqprio_qopt *qopt,
>         /* If ndo_setup_tc is not present then hardware doesn't support o=
ffload
>          * and we should return an error.
>          */
> -       if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
> +       if (qopt->hw && !dev->netdev_ops->ndo_setup_tc) {
> +               NL_SET_ERR_MSG(extack,
> +                              "Device does not support hardware offload"=
);
>                 return -EINVAL;
> +       }
>
>         return 0;
>  }
> --
> 2.34.1
>
