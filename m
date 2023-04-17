Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EA36E53EA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDQVdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjDQVds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:33:48 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637E94EC9
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:33:46 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-54fbee98814so185366257b3.8
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681767225; x=1684359225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKCePm3ajYIi83+RipY8QNKSSnNw0uz4x0IE1t5/iA4=;
        b=FwvsARl7D+4MqR0JA1Y+q2Fte10nfp3NEpS7gIFffgaEi5Lfc9nE4z3Kxby3OI9sja
         TAOofwI1Zf/5wTxl7AenBr1KRXIHEeqtlW5Ya02W2ITtvrnDFgKPGOUaa0ZJjvgKIopl
         EqrO5cxqvDgN92s7VjUUe3qbX2X7LS3IlVDxgXunOWzicFjUoGrTuubdZPMusISb5k1d
         ADQW1+D5ZOG/017CK5h9TzbzUXcK8jjEFsw/b0M+StQLvd+MQAqKhiUPiFqIPWsaSaLG
         1tNkDB6ona7OnLhCYgEm2eiUd0OirgwkuuYbbFz2IHJRuKwGh1vUUfIBQtDWjYlClJmo
         7+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681767225; x=1684359225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKCePm3ajYIi83+RipY8QNKSSnNw0uz4x0IE1t5/iA4=;
        b=OFr5GoIyAGGbLYoM9N5v63zR+mliLhRFQZo0vB/DrRkIFPaoq/5+4V7OaTT7+T2mOe
         irCUhuPlFORkOYkUAqlby1fBAy3DQTR1zzSTgCRqbsp/9MqunB+lvA7BYgdgmhOmFb1O
         5gsmAReYy24VfUK+iUwOs9d/FrOTjNbB9LkOlezql5YvH1pnHclI8DwQ2iMEo60IkAHx
         8e2wVQ4chr2EEXz+1Fi6wbfmW0bYeZwQUlxVu6no5lsynm1dk4HaqijnsvQvx7wS/GrQ
         TBLsGsOT9u4qmCrHSUG+2qN95dH1Nwnmo5evMV4VyzGogtVwWDwxO+xhoLFftruRxaPW
         E5lg==
X-Gm-Message-State: AAQBX9ci0bmtRlrNsk0hjmRCD7MIFQSXnP+3SCPjXMdSztAwqX6U8Ar9
        De6pXVDEVNjAoWzU/ixit7c5z4SdnltF6cNFkflovRYeW90CVu0tGMQ=
X-Google-Smtp-Source: AKy350bkctE0AUV8AVNhXMjiJtNJ4bfHBOjW2z5wo/H4tRakzWZBubmcuyqP7ZCntokm1rI0mjQn5HsoRaWcucZqH3I=
X-Received: by 2002:a81:b667:0:b0:54f:cc40:cf68 with SMTP id
 h39-20020a81b667000000b0054fcc40cf68mr9299674ywk.7.1681767225622; Mon, 17 Apr
 2023 14:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230417171218.333567-1-pctammela@mojatatu.com> <20230417171218.333567-3-pctammela@mojatatu.com>
In-Reply-To: <20230417171218.333567-3-pctammela@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 17 Apr 2023 17:33:34 -0400
Message-ID: <CAM0EoMnr_a5-R_HdUGk7tG9s9KesReVhch=5ncp44aaPBv6BKA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] net/sched: sch_qfq: use extack on errors messages
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 1:12=E2=80=AFPM Pedro Tammela <pctammela@mojatatu.c=
om> wrote:
>
> Some error messages are still being printed to dmesg.
> Since extack is available, provide error messages there.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

> ---
>  net/sched/sch_qfq.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
> index cf5ebe43b3b4..323609cfbc67 100644
> --- a/net/sched/sch_qfq.c
> +++ b/net/sched/sch_qfq.c
> @@ -402,8 +402,8 @@ static int qfq_change_class(struct Qdisc *sch, u32 cl=
assid, u32 parentid,
>         int err;
>         int delta_w;
>
> -       if (tca[TCA_OPTIONS] =3D=3D NULL) {
> -               pr_notice("qfq: no options\n");
> +       if (NL_REQ_ATTR_CHECK(extack, NULL, tca, TCA_OPTIONS)) {
> +               NL_SET_ERR_MSG_MOD(extack, "missing options");
>                 return -EINVAL;
>         }
>
> @@ -441,8 +441,9 @@ static int qfq_change_class(struct Qdisc *sch, u32 cl=
assid, u32 parentid,
>         delta_w =3D weight - (cl ? cl->agg->class_weight : 0);
>
>         if (q->wsum + delta_w > QFQ_MAX_WSUM) {
> -               pr_notice("qfq: total weight out of range (%d + %u)\n",
> -                         delta_w, q->wsum);
> +               NL_SET_ERR_MSG_FMT_MOD(extack,
> +                                      "total weight out of range (%d + %=
u)\n",
> +                                      delta_w, q->wsum);
>                 return -EINVAL;
>         }
>
> --
> 2.34.1
>
