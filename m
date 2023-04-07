Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39186DB02B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbjDGQGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240764AbjDGQF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:05:59 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A58BDC7
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:05:48 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-54c12009c30so90440297b3.9
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680883547; x=1683475547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ikt4cUnbAD+aNtn12UlFaiBStoPGqSHVX26BE/7WeM=;
        b=qW65ZX/foFdpDfE3Ib3eFqGMbd36ADAGUHlyKPdtan0k1ZOf6XvSqQddwkzHUBMBak
         3/9mo9/7/4mVZoZKZOair9LztKforOnN51P1FqfCb4ocR9yDRl/DmT1mKg/eR1Ztf6zK
         W5SmbB4vywpEhq3qXzWBJlEwbYud17wSwGbkM9B+6KoimE4yzYNkLaqFXbs+jcJiFSes
         UujHFLDkg1ulIrSdrkPuRFFGnpmYoxrA+/d+m5EzfzUk4rgG0JtNpp0eazFmR6yxCSr6
         SS/a4+sbUO5YTyGl6/l+4Mfm9aPpZCYzKqzHMXbqgJR1AbkXDU7G6qLfoShp7tukBhV0
         fFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680883547; x=1683475547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Ikt4cUnbAD+aNtn12UlFaiBStoPGqSHVX26BE/7WeM=;
        b=JNEGdIRutcmc7mhQN6Q29FeIYvjYNpRvztb0x+JbdF6iuzrOpjqIbhHrdssSc5j4MM
         9S4WzqG/T8hBQMY3MLIoVDYjyPxQHgZZlLmB2HAJGqbh+whJLhGHyRsJpI6GM+LveKiI
         qNRU4ZLRZousiPCh4a1BtFauwiaEhju8IhYPm3fuV62pAN5pBbeFOah+xgQetgrayDdY
         EjrjHWxA9OXIUxPs+9nUy8FubrIv9TmJWVkY1RBnTBpGJqfI8iasB1zk74OAva7r4KFU
         ALdZ5h1223xLA3IFu9eeeZF+JPO79pW9fjIFv+uH0xKC3xYZjj5cfMMFFVzhecM0xEW/
         E0NQ==
X-Gm-Message-State: AAQBX9e6RVCDajSZ+9OJhnW9pGjxxDuN3e+PMPoPqqB1QyU8uEAm55Dd
        qCugaLvkrUqg/SM7tNw0s2cVUR4xzRBatjVxj2NAfA==
X-Google-Smtp-Source: AKy350YbB1pgB5FsM3mPp7fRcjtnL/fnlVWw/6wN0V6q8XGLC7gFBY6iDdFdqaXh/WNbi7aQD0caxkPakBB5fhVA6Hc=
X-Received: by 2002:a81:e20a:0:b0:54d:4a49:ba22 with SMTP id
 p10-20020a81e20a000000b0054d4a49ba22mr1019445ywl.7.1680883547060; Fri, 07 Apr
 2023 09:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com> <20230403103440.2895683-3-vladimir.oltean@nxp.com>
In-Reply-To: <20230403103440.2895683-3-vladimir.oltean@nxp.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 12:05:35 -0400
Message-ID: <CAM0EoMkvfUOubhgC+PpLi9vKcjsyc+Tp-uOuK60AJhaMaS2ogA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/9] net/sched: mqprio: simplify handling of
 nlattr portion of TCA_OPTIONS
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
> In commit 4e8b86c06269 ("mqprio: Introduce new hardware offload mode and
> shaper in mqprio"), the TCA_OPTIONS format of mqprio was extended to
> contain a fixed portion (of size NLA_ALIGN(sizeof struct tc_mqprio_qopt))
> and a variable portion of other nlattrs (in the TCA_MQPRIO_* type space)
> following immediately afterwards.
>
> In commit feb2cf3dcfb9 ("net/sched: mqprio: refactor nlattr parsing to a
> separate function"), we've moved the nlattr handling to a smaller
> function, but yet, a small parse_attr() still remains, and the larger
> mqprio_parse_nlattr() still does not have access to the beginning, and
> the length, of the TCA_OPTIONS region containing these other nlattrs.
>
> In a future change, the mqprio qdisc will need to iterate through this
> nlattr region to discover other attributes, so eliminate parse_attr()
> and add 2 variables in mqprio_parse_nlattr() which hold the beginning
> and the length of the nlattr range.
>
> We avoid the need to memset when nlattr_opt_len has insufficient length
> by pre-initializing the table "tb".
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
>  net/sched/sch_mqprio.c | 32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
>
> diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
> index 48ed87b91086..94093971da5e 100644
> --- a/net/sched/sch_mqprio.c
> +++ b/net/sched/sch_mqprio.c
> @@ -146,32 +146,26 @@ static const struct nla_policy mqprio_policy[TCA_MQ=
PRIO_MAX + 1] =3D {
>         [TCA_MQPRIO_MAX_RATE64] =3D { .type =3D NLA_NESTED },
>  };
>
> -static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *n=
la,
> -                     const struct nla_policy *policy, int len)
> -{
> -       int nested_len =3D nla_len(nla) - NLA_ALIGN(len);
> -
> -       if (nested_len >=3D nla_attr_size(0))
> -               return nla_parse_deprecated(tb, maxtype,
> -                                           nla_data(nla) + NLA_ALIGN(len=
),
> -                                           nested_len, policy, NULL);
> -
> -       memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
> -       return 0;
> -}
> -
> +/* Parse the other netlink attributes that represent the payload of
> + * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
> + */
>  static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt =
*qopt,
>                                struct nlattr *opt)
>  {
> +       struct nlattr *nlattr_opt =3D nla_data(opt) + NLA_ALIGN(sizeof(*q=
opt));
> +       int nlattr_opt_len =3D nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
>         struct mqprio_sched *priv =3D qdisc_priv(sch);
> -       struct nlattr *tb[TCA_MQPRIO_MAX + 1];
> +       struct nlattr *tb[TCA_MQPRIO_MAX + 1] =3D {};
>         struct nlattr *attr;
>         int i, rem, err;
>
> -       err =3D parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
> -                        sizeof(*qopt));
> -       if (err < 0)
> -               return err;
> +       if (nlattr_opt_len >=3D nla_attr_size(0)) {
> +               err =3D nla_parse_deprecated(tb, TCA_MQPRIO_MAX, nlattr_o=
pt,
> +                                          nlattr_opt_len, mqprio_policy,
> +                                          NULL);
> +               if (err < 0)
> +                       return err;
> +       }
>
>         if (!qopt->hw)
>                 return -EINVAL;
> --
> 2.34.1
>
