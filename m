Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1719F6B779E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCMMfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjCMMe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:34:58 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900FC574EC
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:34:47 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id e65so2924007ybh.10
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678710887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsHVLwfcxVAYySt9LSyHUL3FcFzpHzX+V7FtukH7vRo=;
        b=BGIEPb7mIl6tVYtg3mr1ncRxAzzbqOfM7H4uuLFeRNXzTWzrWs6Gtz2Oetn9JALfzH
         LXa+gu93ekJ6Pf51iMCHELNNLcxYJmelUXh7SJISqumFbqgTDOkLptDgXepF0/IWCpbc
         pew09vdfJ/+kaZlbk7QMQncaiG5KlIGIVIaVM4807KiVkvMwtDvDnkbbiFUYkpjzubGO
         6mVPdOTS2F/Q6KbFUrlsYW/xVWwa/a7kN4ttj7ltSZ2bPQ69h7trce42B6r6OYm+56Md
         dt7Jubvj6OMrtIpn3s2rvckDnjpgdwIhRZSM7q31CtuVpa1+eS2Td++jByvPQ6mtbXAV
         gpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678710887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsHVLwfcxVAYySt9LSyHUL3FcFzpHzX+V7FtukH7vRo=;
        b=S+TK10PnjYY5/p+ckk2pVa/1Wm6tLsIbRJ8pCUtDcAudmNwWWyXvP4rG/9W/oYRLeB
         VsZbZ8pFaJKX4TNnxclkhqnZBkN5HHk5xGw0K15wim+zUlVQfmwQI8K97cupMBLMCnNy
         FIn7OhbG6hI0ohnc3JX+ETUdf1+0uA+yf+39HMGY7qcnYakIsWVLeFs22N/vvH6qQga5
         hyTpwnma5o03ISiTvj84TopId9hIxkY9il9bNRrKk8IIeIx2eQmWVFxPP/4SkWV9U37s
         XzDHmO3w8quE3vKnqUP9fI0sU24EezP3jnPh6mVaCzCO58fQE78LhA1LZNA18gSR5Bgq
         E1YQ==
X-Gm-Message-State: AO0yUKUXD94H8xMAD29IWUG2MFD9f1UYAlzO9ITo0xglwN9Q0ZiuLcX3
        oO1pC3PsyLBU5NATyyZ9qfXKvowsvqP0ITRKy2ceeQ==
X-Google-Smtp-Source: AK7set82rpjxTuF9kCeDnmiGukE3YYZXrIdCpcqWKnHZrvThh4hI99qgocyXflmmscBnqfrZ3Iw45toaZGVUzBcifj4=
X-Received: by 2002:a25:d512:0:b0:b1d:5061:98e3 with SMTP id
 r18-20020a25d512000000b00b1d506198e3mr11990649ybe.6.1678710886550; Mon, 13
 Mar 2023 05:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230311151756.83302-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 05:34:35 -0700
Message-ID: <CANn89iKWewG7JZXQ=bmab9rSXUs_P5fX-BQ792QjYuH151DV-g@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 7:18=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> Sometimes we need to know which one of backlog queue can be exactly
> long enough to cause some latency when debugging this part is needed.
> Thus, we can then separate the display of both.
>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/core/net-procfs.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 1ec23bf8b05c..97a304e1957a 100644
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
> @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *seq, v=
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
> +                  0,   /* was len of two backlog queues */

You can not pretend the sum is zero, some user space tools out there
would be fooled.

> +                  (int)seq->index,
> +                  softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd));
>         return 0;
>  }
>
> --
> 2.37.3
>

In general I would prefer we no longer change this file.

Perhaps add a tracepoint instead ?
