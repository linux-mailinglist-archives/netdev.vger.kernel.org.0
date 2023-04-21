Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546A66EA6C2
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjDUJRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjDUJRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:17:37 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43129008
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:17:35 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-329577952c5so645455ab.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682068655; x=1684660655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xi77l6nFIDq2U6loR3FxGhe3CQWmMa5/qtacXKDF8U=;
        b=3zpIecJ5nJmmKDpFfC/7W6jp+PgnoDoGHZSB1k/RN+5AiNJOamugg5RVSRGJSqemDw
         qaQA1e4jWnCI2uHbtD0ETKZagNYi7wiWga3266rFfiSRY1x8LK3icHTKfRRDJ3mjmp5V
         xJJeLCurB2WhwMsKBXqB51n+zfYvmhTA5q1J1ba269rAAy/GjKvj3YNWgF6vDjNbN7Ra
         B21i8kzKCq5yP2vGiAqN/qxz9NqmxVIYLne/O4z0/oneVuahJJdmNVRWKNHklgziKIGq
         OxYdCoIDOwT6JNUedS9Gj9HYrCBePqML9gNYwe3dRTVOc3StQd0czzkvXiw7hM1XqFvE
         zB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682068655; x=1684660655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xi77l6nFIDq2U6loR3FxGhe3CQWmMa5/qtacXKDF8U=;
        b=ir4scFDi0iTnSYtgzxe/k9xhUfafnTvjmbYm9F0ifMtVjdac2poWfyTuIlWCvrfwXO
         inOI7O0xJ29v+ulLVGS1UpdqD7t+mLF9XVJTVIATU9ZXDvypaUUZtGf8GsBlZu0UfE5E
         oLJIHZY4XAon79TrumneqbfFhdN3sbQPz9tA5hYkULDjAam4CyTndwqmmknB9IXtGNym
         VVqgBMbqlQ7Ndm/utjoxPXIuDBJcdAf3DmBQV+3A1es1h8wElCHmPDCbbU7iOptSTAL+
         yj7Y1fibzjTgEVmdhrH8WAZn6UaQE++Cp1p6FnGP9Qrm+zv1obs09ubAoq+8UvU62CHI
         uVVg==
X-Gm-Message-State: AAQBX9fO0AzNs2i+Ukfor5LokzqI1eCyt91MF9NLBzdV9wvpzy0l6h3l
        Ijwv1eKghep1I5TObwMNyJS8ClB462G0YLViaYchNA==
X-Google-Smtp-Source: AKy350YQxMH/5VhuS1k8alvc4+CJ5uJbiZ0RNk66YHCR1FebgmlqvaR9gUvi13xQqnFWATyGPkSnEYu/55A0lmPZP7A=
X-Received: by 2002:a05:6e02:12e8:b0:32c:a94e:b4b2 with SMTP id
 l8-20020a056e0212e800b0032ca94eb4b2mr149904iln.7.1682068654989; Fri, 21 Apr
 2023 02:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230420164928.237235-1-pctammela@mojatatu.com> <20230420164928.237235-6-pctammela@mojatatu.com>
In-Reply-To: <20230420164928.237235-6-pctammela@mojatatu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Apr 2023 11:17:23 +0200
Message-ID: <CANn89iJsn1Xj8Y4tL69FA5a0y21R4-qBjMddH5rGOBD_iQ0qmw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/5] net/sched: sch_qfq: BITify two bound definitions
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 6:50=E2=80=AFPM Pedro Tammela <pctammela@mojatatu.c=
om> wrote:
>
> For the sake of readability, change these two definitions to BIT()
> macros.
>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  net/sched/sch_qfq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
> index dfd9a99e6257..4b9cc8a46e2a 100644
> --- a/net/sched/sch_qfq.c
> +++ b/net/sched/sch_qfq.c
> @@ -105,7 +105,7 @@
>  #define QFQ_MAX_INDEX          24
>  #define QFQ_MAX_WSHIFT         10
>
> -#define        QFQ_MAX_WEIGHT          (1<<QFQ_MAX_WSHIFT) /* see qfq_sl=
ot_insert */
> +#define        QFQ_MAX_WEIGHT          BIT(QFQ_MAX_WSHIFT) /* see qfq_sl=
ot_insert */

I am not sure I find BIT(X) more readable in this context.

Say MAX_WEIGHT was 0xF000, should we then use

#define MAX_WEIGHT (BIT(15) | BIT(14) |BIT(13) | BIT(12))
