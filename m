Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516E46BFF32
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 04:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCSDGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 23:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCSDGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 23:06:36 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C7920D06;
        Sat, 18 Mar 2023 20:06:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h8so34530601ede.8;
        Sat, 18 Mar 2023 20:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679195194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGSR/jvqYyLC5uiAvVKQBCSDdL+jSStCaDouthbxepc=;
        b=R/PA770rEIHWvQOFKpKDmcqe29Ox143+BpESqy1PdFoYv8imzrID2FZUK6ufyztlhS
         aFSAvbAlKtbYxFur5DUYBQCs5yW6+SXeeCCrA/4u9fLIjIm5McQaGIVtQ5bEALiz4I3F
         +A/tasVvr/IOzTsaKLlmuCrTAMYywOnTfo9spFDKG3h45uh69fKlSsu0FPgygjDMpLzC
         NLOx8rke0FTZ5Py4l4ziDwWRYn4GhcrFVDzXstu4QXBCTu1qyQlS9B6OnpQM+LQl2EJN
         8WfT0wUszu0TbQgXVB5c2KJT63iQiug7p+gc9uXXOnrAzT2Q4tmCbgJY+mj2CWte4FeT
         S0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679195194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGSR/jvqYyLC5uiAvVKQBCSDdL+jSStCaDouthbxepc=;
        b=KYP4mxoMtqzyRwXn9odUe2zvHD6CX6JWs1qbOK8hI90BWcW0mL0t+zgX0nS4em6pLx
         gvLIYZ1xEvfcnjjck71YYfAnRtS69uqvjYB4g3NcxEY/T/b6WRhFkfVGqqLih+2fhtyu
         77GUrMyn2mn2NfL+Xh6DzTcFmkdN6doObqt+p91yZsy9GEGMu7ZOqxaPZf7M9Rq5yLCX
         VBOxENl9kC45jZZwLfgS5y3tHb5wBm5EShSeVl4LYMS4QVDUODgilDfpyrYuplh60OWL
         acgzzSNr6lDSZwzOnr6umibXQil6Ox+R9ta6UYRfds1MvPHUT+pkVv4XviH6NAQBglbj
         6O7Q==
X-Gm-Message-State: AO0yUKVgpxrSerHRnKpoPGC45X13tkXpqNplsmuXYAQUk+dV0L9Yoq8o
        s8FJJCLd4nGlbpUWwk28wH4xDFfGQ0Q7HyqZLsQ=
X-Google-Smtp-Source: AK7set+NEYvkXkhBS8MEj6cIM5HkblBtJwRGJ9AWwvpKZ4NZH5sNPGsl9k98QYig+vNafDF19YbrmEOVnxofBIuuRhM=
X-Received: by 2002:a17:906:abd6:b0:92a:a75e:6b9 with SMTP id
 kq22-20020a170906abd600b0092aa75e06b9mr1855022ejb.11.1679195193635; Sat, 18
 Mar 2023 20:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com> <20230315092041.35482-2-kerneljasonxing@gmail.com>
In-Reply-To: <20230315092041.35482-2-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 19 Mar 2023 11:05:57 +0800
Message-ID: <CAL+tcoCpgWUep+jAo--E2CGFp_AshZ+r89fGK_o7fOz9QqB8MA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 1/2] net-sysfs: display two backlog queue len separately
To:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Wed, Mar 15, 2023 at 5:21=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> Sometimes we need to know which one of backlog queue can be exactly
> long enough to cause some latency when debugging this part is needed.
> Thus, we can then separate the display of both.
>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

I just noticed that the state of this patch is "Changes Requested" in
the patchwork[1]. But I didn't see any feedback on this. Please let me
know if someone is available and provide more suggestions which are
appreciated.

[1]: https://patchwork.kernel.org/project/netdevbpf/patch/20230315092041.35=
482-2-kerneljasonxing@gmail.com/

Thanks,
Jason

> ---
> v4:
> 1) avoid the inconsistency through caching variables suggested
> by Eric.
> Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@=
gmail.com/
> 2) remove the unused function: softnet_backlog_len()
>
> v3: drop the comment suggested by Simon
> Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@=
gmail.com/
>
> v2: keep the total len of backlog queues untouched as Eric said
> Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing=
@gmail.com/
> ---
>  net/core/net-procfs.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 1ec23bf8b05c..09f7ed1a04e8 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq, void =
*v)
>         return 0;
>  }
>
> -static u32 softnet_backlog_len(struct softnet_data *sd)
> +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
>  {
> -       return skb_queue_len_lockless(&sd->input_pkt_queue) +
> -              skb_queue_len_lockless(&sd->process_queue);
> +       return skb_queue_len_lockless(&sd->input_pkt_queue);
> +}
> +
> +static u32 softnet_process_queue_len(struct softnet_data *sd)
> +{
> +       return skb_queue_len_lockless(&sd->process_queue);
>  }
>
>  static struct softnet_data *softnet_get_online(loff_t *pos)
> @@ -152,6 +156,8 @@ static void softnet_seq_stop(struct seq_file *seq, vo=
id *v)
>  static int softnet_seq_show(struct seq_file *seq, void *v)
>  {
>         struct softnet_data *sd =3D v;
> +       u32 input_qlen =3D softnet_input_pkt_queue_len(sd);
> +       u32 process_qlen =3D softnet_process_queue_len(sd);
>         unsigned int flow_limit_count =3D 0;
>
>  #ifdef CONFIG_NET_FLOW_LIMIT
> @@ -169,12 +175,14 @@ static int softnet_seq_show(struct seq_file *seq, v=
oid *v)
>          * mapping the data a specific CPU
>          */
>         seq_printf(seq,
> -                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x\n",
> +                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x "
> +                  "%08x %08x\n",
>                    sd->processed, sd->dropped, sd->time_squeeze, 0,
>                    0, 0, 0, 0, /* was fastroute */
>                    0,   /* was cpu_collision */
>                    sd->received_rps, flow_limit_count,
> -                  softnet_backlog_len(sd), (int)seq->index);
> +                  input_qlen + process_qlen, (int)seq->index,
> +                  input_qlen, process_qlen);
>         return 0;
>  }
>
> --
> 2.37.3
>
