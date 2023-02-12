Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C626937D7
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 15:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBLO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 09:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLO7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 09:59:13 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB681205D
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 06:59:12 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-52ecd867d89so85505447b3.8
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 06:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lA8oZ3VG0tHn3woNuW1RoibOyhixnHlXfovXGvddlWA=;
        b=pBB9PfwFoIeGki+p8/ATSfZZRfH4emRjVVsCInZXra/w1RGmS7TefQGsIxlyFKr/Rc
         BtKcsQMQtHxP7JYsS+xmz29/DuOQ+rjJPV47veVPC7YyGtjArZJpxseoWBht3Doiokxq
         jVL9tvOUZ8OFRasYPicLAMVeq7HCOd82j4c/reBX3MYWCp3f2ax40zzoWUFlS2WsKJBB
         lYpvhrtpHdS+Yr/RQtUZ8lVmHGL3NsyVI139/bG59kpDhi4gjj8EaBnNwjah9/7+K9MF
         bUnOlIYB29Ap5PxaseFizMpTuj+rV07h6H2VTe0rtNHgJDEjGJ7rs3WnwG2MH9qySnRO
         fWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lA8oZ3VG0tHn3woNuW1RoibOyhixnHlXfovXGvddlWA=;
        b=FDdJN3qvVybAQhfNPanQvMxBqXUje2+QSJAEX2xqV0M4+2Dk5Nypo8OK5GqHExRndN
         9fHNl1Cuq3wopJ7itZf2aHtNNIqtF9qitsbPI9/QpDc96T2pFgoNMUTp4LLPSlFvOaie
         /xwoAA1Nun+HnSK9W/d9bMXMyooLrtUdUYo9vWL+AP9fdGDqFfkHQGbf6z4hBlCYl5NJ
         8JV4zcuVcg7Z31ywrzwYNoQ9IlB2pK6bWBpT2p81Ilb30ZyJNSvj98w16pym9Azcwep4
         cYoM/EBPslWbykn+evUIasBhSFDj2y6R9B1TF+ELYpbZYAOvvTd1LPXaiKm4GC47m/bm
         frNg==
X-Gm-Message-State: AO0yUKVIhoJ5hgXj3ECzrcy3TftGSCuNI/eKQJf0McgYrUgF8zvpwiwJ
        c8uMIKen2ack/0pD7WHkEC0dRPv+LDL06yf63YF5Pg==
X-Google-Smtp-Source: AK7set9qg/FibIfuiMJYoy/mKfBaSjeh293usKbe6eaem7bQhnOSlW49MPAiT9tj6ARm1GNVVmihJG8r6oSI6sl9Hts=
X-Received: by 2002:a05:690c:eab:b0:4ff:a70a:1286 with SMTP id
 cr11-20020a05690c0eab00b004ffa70a1286mr1978622ywb.447.1676213951910; Sun, 12
 Feb 2023 06:59:11 -0800 (PST)
MIME-Version: 1.0
References: <20230212132520.12571-1-ozsh@nvidia.com> <20230212132520.12571-3-ozsh@nvidia.com>
In-Reply-To: <20230212132520.12571-3-ozsh@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 12 Feb 2023 09:59:00 -0500
Message-ID: <CAM0EoMkTdJ0shmSGkLsL1j2d-R9nxxMJBtc30XtYBWs5CzqFCw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/9] net/sched: act_pedit, setup offload
 action for action stats query
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 8:26 AM Oz Shlomo <ozsh@nvidia.com> wrote:
>
> A single tc pedit action may be translated to multiple flow_offload
> actions.
> Offload only actions that translate to a single pedit command value.
>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
> Change log:
>
> V1 -> V2:
>     - Add extack message on error
>     - Assign the flow action id outside the for loop.
>       Ensure the rest of the pedit actions follow the assigned id.
>
> V2 -> V3:
>     - Fix last_cmd initialization
>
> V3 -> V4:
>     - Compare all action types to the first action
> ---
>  net/sched/act_pedit.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index c42fcc47dd6d..35ebe5d5c261 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -545,7 +545,28 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
>                 }
>                 *index_inc = k;
>         } else {
> -               return -EOPNOTSUPP;
> +               struct flow_offload_action *fl_action = entry_data;
> +               u32 cmd = tcf_pedit_cmd(act, 0);
> +               int k;
> +
> +               switch (cmd) {
> +               case TCA_PEDIT_KEY_EX_CMD_SET:
> +                       fl_action->id = FLOW_ACTION_MANGLE;
> +                       break;
> +               case TCA_PEDIT_KEY_EX_CMD_ADD:
> +                       fl_action->id = FLOW_ACTION_ADD;
> +                       break;
> +               default:
> +                       NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +                       return -EOPNOTSUPP;
> +               }
> +
> +               for (k = 1; k < tcf_pedit_nkeys(act); k++) {
> +                       if (cmd != tcf_pedit_cmd(act, k)) {
> +                               NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +                               return -EOPNOTSUPP;
> +                       }
> +               }
>         }
>
>         return 0;
> --
> 1.8.3.1
>
