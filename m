Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691236B9871
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjCNO7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjCNO7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:59:42 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAD9738AA
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:59:41 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j7so5077403ybg.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678805980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c68s71ci5RzD1RLlqzOZqYMPisXV5XHHiU9eL0FAO2c=;
        b=Ev3WCqJWjHJhYjE6/X6Z3t2+GsBR9Bk2cKqpPFUZxtr38To7DAATlQuj/C09ufn87h
         oWs5XcVf6AhuVtzZ0N/bQLjHTZ4qhC/178eOZfDsTkfm6tdog2ZxqCC0ed6QNsede6Ag
         QEUc2RNr0NrPkJeQXvRV6dq2zn1S9yspHAR8tO/kTEhFqrKBMXI+vPfqxR7grq/395rn
         lYbD7fQXE8Wu1TUaBHrD3bSUc5EYTpvoQjEmsjm2SWo3BhMnVBDoul8SpMa29EApKJhk
         NkmVOwIOG4pWbXUeyWOJ6rkR9dGWAf2tn45li/T3Gm8l9lkgbEOX+TXcS+CB5ENnloUo
         GPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678805980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c68s71ci5RzD1RLlqzOZqYMPisXV5XHHiU9eL0FAO2c=;
        b=o8wMvpQ3QurENo9h1HPUzhKk+FC4G84HTYBB5Ymkt2bNSHySl5lw0TXAYHd1pA4NCr
         MLmAtb0qTZTLxB++s8Z3wZ1X9R1VLvWg5li9wCzG9wo9srC2pRjxUgoy3cSt3VGfr+mV
         qmqtI1zNt3wqScw8rDDui9dPFNEf+caSGQynbXGtz2c58TTwrzocTnIHgsVSVXjXIS3i
         hmaxgRXXsJnn0NEnfpV8BySceplHW0uu6lB9OZPeBSBG61d5tYamnooA/CUAjGJi0vzf
         skQvhplbfwsP1vnBRjPAF4l0AD/FRi6SRMiUcHkIiSnBLSinEQ0nYf5fDUDBJjVpBA82
         rMeQ==
X-Gm-Message-State: AO0yUKU2i1mlPo0WHhPPK+gEKOiZEpFdDWbpo41pcp7aQ9L+K0S97FUa
        LBlrbPNnDm1gE5v6iSITcWOzeVfrkNjYkDwSokhj3Q==
X-Google-Smtp-Source: AK7set+taVqRjysfrXwZjEOrW14xiSSmBbVSfwPv8GseJcaGRfTAlBKx0b0vhLrr5SXTdaEBEDmocz6zQ+CfvBONjTM=
X-Received: by 2002:a05:6902:4f:b0:b38:461f:daeb with SMTP id
 m15-20020a056902004f00b00b38461fdaebmr5052439ybh.6.1678805980327; Tue, 14 Mar
 2023 07:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230314030532.9238-1-kerneljasonxing@gmail.com> <20230314030532.9238-2-kerneljasonxing@gmail.com>
In-Reply-To: <20230314030532.9238-2-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 14 Mar 2023 07:59:27 -0700
Message-ID: <CANn89iKP7GVxZ0HYcPQq5ryC+rtwyymZuHuvza_SoCOJeADzGw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] net-sysfs: display two backlog queue len separately
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, stephen@networkplumber.org,
        simon.horman@corigine.com, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
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

On Mon, Mar 13, 2023 at 8:06=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
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
> v2: keep the total len of backlog queues untouched as Eric said
> Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing=
@gmail.com/
> ---
>  net/core/net-procfs.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 1ec23bf8b05c..2809b663e78d 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -115,10 +115,19 @@ static int dev_seq_show(struct seq_file *seq, void =
*v)
>         return 0;
>  }
>
> +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> +{
> +       return skb_queue_len_lockless(&sd->input_pkt_queue);
> +}
> +
> +static u32 softnet_process_queue_len(struct softnet_data *sd)
> +{
> +       return skb_queue_len_lockless(&sd->process_queue);
> +}
> +
>  static u32 softnet_backlog_len(struct softnet_data *sd)
>  {
> -       return skb_queue_len_lockless(&sd->input_pkt_queue) +
> -              skb_queue_len_lockless(&sd->process_queue);
> +       return softnet_input_pkt_queue_len(sd) + softnet_process_queue_le=
n(sd);

Reading these variables twice might lead to inconsistency that can
easily be avoided.

I would suggest you cache the values,

u32 len1 =3D softnet_input_pkt_queue_len(sd);
u32 len2 =3D softnet_process_queue_len(sd);



>  }
>
>  static struct softnet_data *softnet_get_online(loff_t *pos)
> @@ -169,12 +178,15 @@ static int softnet_seq_show(struct seq_file *seq, v=
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
> +                  softnet_backlog_len(sd),     /* keep it untouched */
                    len1 + len2.

> +                  (int)seq->index,
> +                  softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd));
               len1,  len2);

>         return 0;
>  }
>
> --
> 2.37.3
>
