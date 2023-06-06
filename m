Return-Path: <netdev+bounces-8550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F35572484B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC9B8280D57
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080D730B7C;
	Tue,  6 Jun 2023 15:54:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBDA37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:54:49 +0000 (UTC)
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E8310F7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:54:48 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-565cfe4ece7so69036937b3.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686066887; x=1688658887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujsBZ4uJZL6h/JTt6Bm6m0i19TW1ClrPykPvvOH8c+0=;
        b=Gfe9q+EQbN6cypOvXXejGp3X4dRIIILfIWSQsFxRdmgm4K1J6yjkP2FnReagCDhrMK
         bl9JsxYhiTlb94i+r0O2PWJzDXsp301xxFanTB2awQJnM8r7beq+KVWs4nx9cgvnPxz1
         rCbiXQO/jAZTwBbAE7OAZJJhLXAA8MMkblXSwwIIl3ghLxb/0jFm3TsZl87/7r315iuB
         20Yo15fek6UW5vbOo135girDEDbXui3sY9WmQ6dwZ2tMOaFcyDVtOWVnVLNU2a/qORrn
         XOaZrEiLCZ4Hdy+eORoSw4W4SLppLOmLLbvDZvct3WpcDF0ry0cyEsJtBwY0krHHNpcU
         c4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686066887; x=1688658887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujsBZ4uJZL6h/JTt6Bm6m0i19TW1ClrPykPvvOH8c+0=;
        b=WnYB3ZOKIk16lOaLhzSRLf2C8hrre06Q/sjLLdwH/Qf9KWxBo/WmD1ziMTfJMaZLWT
         oD0t/Y+PIkCAITcDHTazxJe3qQgTogoddfIAY9D0DpE3rQbo3K02x2ISzU0n4hrvi0K2
         QuhW2XB2T2scGc8ryhuZTLUfuA62pvHFmOUqezpaJdTPQ+RTPwP4NPFmwpqO4pEZgDUE
         S+F6UAFcU7uk4C0k8SONdUfSaH3Ps/MovGAI17uQ6PJRxoA7MEI289VktfgTChdQQq1f
         L1nCyHyoDdRvzjaqPvCMLwjwm//NKwUYn1S1piWcGcAb7QrjQn/a8BrIJPkw81b0a3UO
         LbQw==
X-Gm-Message-State: AC+VfDz8vwqA45SeWGyBSFxsTscNxaRQLXhF5VCw2PS2l7N2UqYegegz
	2mwfzOoK/93h/lvVBdQ9Bl+XpVd+Nrd6WyvltefCkA==
X-Google-Smtp-Source: ACHHUZ7uru3DrlP35Y4533Xy4mo6SF0bcMx2ZlLeOfWv5VOysH70dYtySFD1q8f3e1+9z8OOe8w7iL5HVuPwrSaAWAo=
X-Received: by 2002:a81:5b8a:0:b0:561:e724:eb3 with SMTP id
 p132-20020a815b8a000000b00561e7240eb3mr3054503ywb.17.1686066887570; Tue, 06
 Jun 2023 08:54:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606114233.4160703-1-edumazet@google.com>
In-Reply-To: <20230606114233.4160703-1-edumazet@google.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 6 Jun 2023 11:54:36 -0400
Message-ID: <CAM0EoMnm+hdpA7VNPK6iK_05crK7V3AG2qVwKnQcMbChtKzT=Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: move rtm_tca_policy declaration to
 include file
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 7:42=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
> rtm_tca_policy is used from net/sched/sch_api.c and net/sched/cls_api.c,
> thus should be declared in an include file.
>
> This fixes the following sparse warning:
> net/sched/sch_api.c:1434:25: warning: symbol 'rtm_tca_policy' was not dec=
lared. Should it be static?
>
> Fixes: e331473fee3d ("net/sched: cls_api: add missing validation of netli=
nk attributes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal

>  include/net/pkt_sched.h | 2 ++
>  net/sched/cls_api.c     | 2 --
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index f436688b6efc8f20ee5ede6ee94404e22bbebf3f..5722931d83d431d8cc625d44b=
a2bc22d88301d5b 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -127,6 +127,8 @@ static inline void qdisc_run(struct Qdisc *q)
>         }
>  }
>
> +extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
> +
>  /* Calculate maximal size of packet seen by hard_start_xmit
>     routine of this device.
>   */
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc1e466b6a03b0ce6eb5de25ab7476..b2432ee04f3193f6bbcb7986f=
d950d470fd28e55 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -43,8 +43,6 @@
>  #include <net/flow_offload.h>
>  #include <net/tc_wrapper.h>
>
> -extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
> -
>  /* The list of all installed classifier types */
>  static LIST_HEAD(tcf_proto_base);
>
> --
> 2.41.0.rc0.172.g3f132b7071-goog
>

