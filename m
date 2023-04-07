Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792446DB033
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbjDGQHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjDGQHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:07:04 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44EA9745
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:06:36 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id d3so21536827ybu.1
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680883593; x=1683475593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krZ9WXVd+XUYGaJUuD4z7K2OnYayfwpJS65M3AnYm68=;
        b=Owkl2alqiRS1TfrgjEEXHOxmEzJEWwi4rpTQnjh/YgyiF5An50fY2F3b7dZoqdeEsD
         7bmR7fJ6NCy1aLdpsSPEtakrkrUveU+7TfY/snJE0s14DFRA7WtxjyT78aIiQfRyHJG8
         vWr9a7oVHa72TqtECZsflb2yUPQrYuGhLXpSJCWQ96tIWy7+ej8URSFJFO4dXsBQVpge
         3MTWbONXGH5AZLopEIs496Sl4fKQ0/ytiEyvRhYF/g6V4BLFIHRfS+CHmQO0bVq5G5Gl
         9S8N7J0XRjLWWA8rdpUEg7WOBB+Js4mHVqBtoSyeqslAQAsjxWrsTpt2V0fvobbgjXmj
         wmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680883593; x=1683475593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krZ9WXVd+XUYGaJUuD4z7K2OnYayfwpJS65M3AnYm68=;
        b=ANZ4gFb1Mp14LqKIdH585yTV3rPyt0qUqHiHQD/Pm3MiGZ+G3MGz2QPfb7/9oqqEUW
         2+PPbeaegrvzA4ibOUZOOUO6k7hbu163lGDPAcUGwCAv3+VzsBa4J1tIHj/8nAinDLjx
         MpqivX7gbvpT4uduCotEu0cvuq/KAmmLGBBkPxSCioHYwwdkGYLZww7NfhbTwNDOQ5b3
         2q3g2QPDSM2Wtwm71LLZyQn52eMt3MrEbo84OcWOxTRcWSquDUOy2RmVx3rSbpvazf9l
         eBSqq6Kk88efFoi7huLKy8ZrSqWs0NoIaeSI1bO0JcfPZU3NuWl0PRBGX5LkXSr4eVw4
         D4Qg==
X-Gm-Message-State: AAQBX9e5Qey35lKe8dfPPOPL/ZNngT6ZpZNYDlxmLjFktZ6WFXU7miKg
        o7bcRoNUwXQc+1HbahruY8/n7JHA9SLCfyjnjkuu3g==
X-Google-Smtp-Source: AKy350Z534dcCizub+W9Fc5oBNCNBZO749oz5AHtVyQbNLXf0HYOD8YJE2HMJ85/zJyr2Qj5aA0O6H0u3DmTBqDpbII=
X-Received: by 2002:a25:c907:0:b0:b39:b0d3:9a7f with SMTP id
 z7-20020a25c907000000b00b39b0d39a7fmr1601845ybf.7.1680883593480; Fri, 07 Apr
 2023 09:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com> <20230403103440.2895683-4-vladimir.oltean@nxp.com>
In-Reply-To: <20230403103440.2895683-4-vladimir.oltean@nxp.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 12:06:22 -0400
Message-ID: <CAM0EoMnyKkNDv1JJs19Uo3cw4oAskqCesmy9O5F9zy=KQRUJxA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/9] net/sched: mqprio: add extack to mqprio_parse_nlattr()
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
> Netlink attribute parsing in mqprio is a minesweeper game, with many
> options having the possibility of being passed incorrectly and the user
> being none the wiser.
>
> Try to make errors less sour by giving user space some information
> regarding what went wrong.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
> v1->v4: none
>
>  net/sched/sch_mqprio.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
> index 94093971da5e..5a9261c38b95 100644
> --- a/net/sched/sch_mqprio.c
> +++ b/net/sched/sch_mqprio.c
> @@ -150,7 +150,8 @@ static const struct nla_policy mqprio_policy[TCA_MQPR=
IO_MAX + 1] =3D {
>   * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
>   */
>  static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt =
*qopt,
> -                              struct nlattr *opt)
> +                              struct nlattr *opt,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct nlattr *nlattr_opt =3D nla_data(opt) + NLA_ALIGN(sizeof(*q=
opt));
>         int nlattr_opt_len =3D nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
> @@ -167,8 +168,11 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, st=
ruct tc_mqprio_qopt *qopt,
>                         return err;
>         }
>
> -       if (!qopt->hw)
> +       if (!qopt->hw) {
> +               NL_SET_ERR_MSG(extack,
> +                              "mqprio TCA_OPTIONS can only contain netli=
nk attributes in hardware mode");
>                 return -EINVAL;
> +       }
>
>         if (tb[TCA_MQPRIO_MODE]) {
>                 priv->flags |=3D TC_MQPRIO_F_MODE;
> @@ -181,13 +185,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, s=
truct tc_mqprio_qopt *qopt,
>         }
>
>         if (tb[TCA_MQPRIO_MIN_RATE64]) {
> -               if (priv->shaper !=3D TC_MQPRIO_SHAPER_BW_RATE)
> +               if (priv->shaper !=3D TC_MQPRIO_SHAPER_BW_RATE) {
> +                       NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MIN_RAT=
E64],
> +                                           "min_rate accepted only when =
shaper is in bw_rlimit mode");
>                         return -EINVAL;
> +               }
>                 i =3D 0;
>                 nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
>                                     rem) {
> -                       if (nla_type(attr) !=3D TCA_MQPRIO_MIN_RATE64)
> +                       if (nla_type(attr) !=3D TCA_MQPRIO_MIN_RATE64) {
> +                               NL_SET_ERR_MSG_ATTR(extack, attr,
> +                                                   "Attribute type expec=
ted to be TCA_MQPRIO_MIN_RATE64");
>                                 return -EINVAL;
> +                       }
>                         if (i >=3D qopt->num_tc)
>                                 break;
>                         priv->min_rate[i] =3D *(u64 *)nla_data(attr);
> @@ -197,13 +207,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, s=
truct tc_mqprio_qopt *qopt,
>         }
>
>         if (tb[TCA_MQPRIO_MAX_RATE64]) {
> -               if (priv->shaper !=3D TC_MQPRIO_SHAPER_BW_RATE)
> +               if (priv->shaper !=3D TC_MQPRIO_SHAPER_BW_RATE) {
> +                       NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MAX_RAT=
E64],
> +                                           "max_rate accepted only when =
shaper is in bw_rlimit mode");
>                         return -EINVAL;
> +               }
>                 i =3D 0;
>                 nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
>                                     rem) {
> -                       if (nla_type(attr) !=3D TCA_MQPRIO_MAX_RATE64)
> +                       if (nla_type(attr) !=3D TCA_MQPRIO_MAX_RATE64) {
> +                               NL_SET_ERR_MSG_ATTR(extack, attr,
> +                                                   "Attribute type expec=
ted to be TCA_MQPRIO_MAX_RATE64");
>                                 return -EINVAL;
> +                       }
>                         if (i >=3D qopt->num_tc)
>                                 break;
>                         priv->max_rate[i] =3D *(u64 *)nla_data(attr);
> @@ -252,7 +268,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlat=
tr *opt,
>
>         len =3D nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
>         if (len > 0) {
> -               err =3D mqprio_parse_nlattr(sch, qopt, opt);
> +               err =3D mqprio_parse_nlattr(sch, qopt, opt, extack);
>                 if (err)
>                         return err;
>         }
> --
> 2.34.1
>
