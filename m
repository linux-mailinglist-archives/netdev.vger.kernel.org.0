Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77046B8E86
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCNJWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjCNJWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:22:31 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B17F039;
        Tue, 14 Mar 2023 02:22:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id o12so59175797edb.9;
        Tue, 14 Mar 2023 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678785746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Iz/Op1uHQSuQQeWYaqlQ+QdtdsgE+ySX7lS8xthNiQ=;
        b=o/rapE7CXHDBPyRoSf6j4yt63IrG5NRqjgR3aCb+ZxAo2G9enTDFczkC2YVSR2bPo0
         mcSPhdaR6ZIBbVpr+NDkmrEZp/VDAMlRMSRgE34Ubsegjx67g8P8Y96pC63JznoL8xQ0
         i+dAJdLFBgXU/CPza8r6RjbcBAVV+GKCO84YZ2IzuSl6T/d4cowTCdHo+jbwal/kdk5S
         zka9IaBorpSAxS+Fwko36Gxjb7OQDah2XrNnnf7HFLcXe2WDWp6sar5LVN43OmxUV3T4
         421meWXZuJr3gbjKmq15mM6sKEGL2fSiw60g3D9U4UAXH06wWGt8GztatGa5asEAICJh
         HSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678785746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Iz/Op1uHQSuQQeWYaqlQ+QdtdsgE+ySX7lS8xthNiQ=;
        b=sYwH+v/yoAlzSFwJZDe8T9G07+XGXVSpwcLud/WL6ymH02sn+at8Bhc2U61yXBm06p
         nC1tvPiR1+1fuhzQOX2OEBMwYZFcmhPTdUw5MRWYVBLtgHHZo+R1h8NuVykQUHfzr/ou
         S13ebqCsx22by2lTgR7teBzYD9bwX6GOdxRvJvKqqJjlNdIQhV2NywFmUzIdmwjVZWwr
         SxTOUQFa3ctCCpNe2El7idNojGHyDgyWyt2/aTrTerMntJIQp1oc6xodwQ6PhW1Txz+2
         iKuRZWImeslWyzGfk+1wNevjHAgGPd9ZtIRXKvAZ/713aOtiWSGS/hKB+D97e10sButC
         Ravw==
X-Gm-Message-State: AO0yUKU7PCfinE/e5L4X8/7hxVcj41XkuirazWYPRz5AQT2V1V9PkAJo
        lZX2ywAf4qjaQZcOxBQDgp59i1IVScXR2aW6/hWpJGBGef8S8A==
X-Google-Smtp-Source: AK7set9Ger9lshoE8Yg9qnDm/1cgbiD711EJJTSFtNfD8oLLFb1QdHah0yotqURFtHcjBWhGnzfGjvAbXlrmJVKgHY4=
X-Received: by 2002:a17:906:a94f:b0:8db:b5c1:7203 with SMTP id
 hh15-20020a170906a94f00b008dbb5c17203mr829287ejb.11.1678785746151; Tue, 14
 Mar 2023 02:22:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230311163614.92296-1-kerneljasonxing@gmail.com>
 <cb09d3eb-8796-b6b8-10cb-35700ea9b532@gmail.com> <CAL+tcoB9Gq44dKyZ2yvZdDHXp30=Hc_trbuuWDEeUZiNy9wRAw@mail.gmail.com>
 <3a103f0b-7c90-b9f5-0337-22ef46eba1a5@redhat.com>
In-Reply-To: <3a103f0b-7c90-b9f5-0337-22ef46eba1a5@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 17:21:49 +0800
Message-ID: <CAL+tcoByPYTcm11cPMoVww_Ba4pv3ApD7dJRjNGsOiHCuNaGiA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune rx behavior
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Kui-Feng Lee <sinquersw@gmail.com>, brouer@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kuniyu@amazon.com,
        liuhangbin@gmail.com, xiangxia.m.yue@gmail.com, jiri@nvidia.com,
        andy.ren@getcruise.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>,
        Willem de Bruijn <willemb@google.com>,
        Simon Sundberg <Simon.Sundberg@kau.se>
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

On Tue, Mar 14, 2023 at 4:41=E2=80=AFPM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 14/03/2023 02.57, Jason Xing wrote:
> > On Tue, Mar 14, 2023 at 5:58=E2=80=AFAM Kui-Feng Lee <sinquersw@gmail.c=
om> wrote:
> >>
> >> On 3/11/23 08:36, Jason Xing wrote:
> >>> From: Jason Xing <kernelxing@tencent.com>
> >>>
> >>> When we encounter some performance issue and then get lost on how
> >>> to tune the budget limit and time limit in net_rx_action() function,
> >>> we can separately counting both of them to avoid the confusion.
> >>>
> >>> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> >>> ---
> >>> note: this commit is based on the link as below:
> >>> https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@g=
mail.com/
> >>> ---
> [...]
> >>> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> >>> index 97a304e1957a..4d1a499d7c43 100644
> >>> --- a/net/core/net-procfs.c
> >>> +++ b/net/core/net-procfs.c
> >>> @@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *se=
q, void *v)
> >>>         */
> >>>        seq_printf(seq,
> >>>                   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x =
%08x %08x %08x "
> >>> -                "%08x %08x\n",
> >>> -                sd->processed, sd->dropped, sd->time_squeeze, 0,
> >>> +                "%08x %08x %08x %08x\n",
> >>> +                sd->processed, sd->dropped,
> >>> +                0, /* was old way to count time squeeze */
> >>
> >> Should we show a proximate number?  For example,
> >> sd->time_squeeze + sd->bud_squeeze.
> >
> > Yeah, It does make sense. Let the old way to display untouched.
> >
>
[...]
> Yes, I don't think we can/should remove this squeeze stat because
> several tools e.g. my own[1] captures these stats (and I know Willem
> also have his own tool).
> I like the sd->time_squeeze + sd->budget_squeeze suggestion.

So do I. Therefore I followed this suggestion in the next submission.

[1]
https://lore.kernel.org/lkml/20230314030532.9238-3-kerneljasonxing@gmail.co=
m/

>
>   [1]
> https://github.com/netoptimizer/network-testing/blob/master/bin/softnet_s=
tat.pl
>
>
> >>
> >>
> >>> +                0,
> >>>                   0, 0, 0, 0, /* was fastroute */
> >>>                   0,   /* was cpu_collision */
> >>>                   sd->received_rps, flow_limit_count,
> >>>                   0,   /* was len of two backlog queues */
> >>>                   (int)seq->index,
> >>> -                softnet_input_pkt_queue_len(sd), softnet_process_que=
ue_len(sd));
> >>> +                softnet_input_pkt_queue_len(sd), softnet_process_que=
ue_len(sd),
> >>> +                sd->time_squeeze, sd->budget_squeeze);
> >>>        return 0;
> >>>    }
> >>>
>
[...]
> We recently had a very long troubleshooting session around a latency
> issue (Cc Simon) where we used the tool[1].  The issue was NIC hardware
> RX queue was backlogged, but we didn't see any squeeze events, which
> confused us. (This happens because budget was 300 and two NICs using 64
> budget each doesn't exceed 300).

I recently found some users running on our production environment hit
the time_squeeze very often which aroused my interests.
Env:
1) budget is 300;
2) eth0 is virtio_net which only registers 32 input interrupts (32
queue pairs) with a larger number of cpus online.

>
> We were/are missing another counter to tell us net_rx_action() "repoll"
> is happening (as code !list_empty(&repoll)).  That were the case and it
> would have "told" us that hardware RX ring was full (larger than 64).
>
> We worked around this limitation by using the tracepoint for napi_poll,
> and manually deduced that 64 bulking must mean that "repoll" were happeni=
ng.
>
> Oneliner bpftrace script:
>
>   bpftrace -e 'tracepoint:napi:napi_poll {
> @napi_rx_bulk[str(args->dev_name)] =3D lhist(args->work, 0, 64, 4); }'
>
> We used this script (that also measures softirq latency):
>
>
> https://github.com/xdp-project/xdp-project/blob/master/areas/latency/napi=
_monitor.bt
>
>
[...]
> I do wonder is it would be valuable to *also* add a tracepoint to
> net_rx_action, that expose sd->time_squeeze, sd->budget_squeeze and
> repoll-not-empty.

I believe it's useful that we can show more details in softnet_data,
but I'm confused about how to display them.
This morning I submitted one patch[1] and chose to do such things when
reading the softnet_stat file.

Could we add more data in the softnet_stat file while also tracing
those three important points? I'm not sure.

Thanks,
Jason

>
> --Jesper
>
