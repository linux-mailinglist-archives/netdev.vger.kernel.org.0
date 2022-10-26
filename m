Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736FF60E9AC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 21:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiJZT7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 15:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiJZT7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 15:59:46 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCB524BED
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 12:59:39 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-36cbcda2157so102722777b3.11
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 12:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X5K3M1cKuBGcnzHdJ/ZU9f+JQhLOYZLbD++nTg1Hiz4=;
        b=GI7gJx+oA9c3u1/SQb7gVG5T9q9tfP7iRJ7aZ4Ag1gotleqk2md3nehaImC1arfb8A
         ArvHjDAEG4yQ9XcULB8mbgnMK45HvBC+7IDLKpWl5wHG/tvUZRVUGGcev4IJW4X8wCgO
         KHENpP/0coe7TuW5/P/c6YP4wRe+a4dOTdHwlDvF4D0zfhZh77ad2i3YFsZ8clUDbo7W
         o/hugjuFuS4hYTRb8aXm7YzaViqpNUTIukXlpBu59Jd14PpKF0AYIzISqUCJb+jYsP3T
         3ubQFIkymVu2CiwHkvvn4t7rn+wjCu8MfHCL0eZnJ/cJhR6H6NIBVPwRnip4VTkd810C
         Bs5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5K3M1cKuBGcnzHdJ/ZU9f+JQhLOYZLbD++nTg1Hiz4=;
        b=HhWIztCLDlT4oDW0IXuWo0KL/jn6rIVHqd/rq/PzVgx51puczMvZeMu+d7jpBZ+xfy
         QwmL4MiGFN+HIsv/OyBhIdM8O8h+8E920HuVEufBm5imukP7IbNCt8lZFVKZQoYhR0fh
         2jPiUko/NiQp60PIk336EwNSKxHei7ClBBJmSWslN45vram6RQnAqLhAXGBt2NEpB46c
         fZMLyanOcjQmKzNG3k0cv9InFXP96SPT2uHwoxaFVZEGszQdwyCDgCbnk4KqoEYEC1Ce
         7GxUAooI1wu8syGPY0Y+RzufWsCknEAXFqoK4093BXwkWZyvQcSK4hoFRaJPSgPm5C5+
         Krug==
X-Gm-Message-State: ACrzQf3TLxZLTfbNNmXqj1gohRmuZW6JuTf0xRdvKQ3S8pZw5XDN7kqO
        nOJd7IfBUMwP/h0HnzC1P5DhY4LnCMoZYI9iuRLX4g==
X-Google-Smtp-Source: AMsMyM764c4S89wwpydebt+KOMUw3QGtem4RlFd9lYq5tb9f8HkQMZ+IeNDiFteZImOKLefmM062P4eOb2CvgQZReC0=
X-Received: by 2002:a81:c11:0:b0:36a:bcf0:6340 with SMTP id
 17-20020a810c11000000b0036abcf06340mr23861479ywm.467.1666814378325; Wed, 26
 Oct 2022 12:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221026151558.4165020-1-luwei32@huawei.com> <CANn89iJQn5ET3U9cYeiT0ijTkab2tRDBB1YP3Y6oELVq0dj6Zw@mail.gmail.com>
 <CANn89iLcnPAzLZFiCazM_y==33+Zhg=3bGY70ev=5YwDoZw-Vg@mail.gmail.com> <fd9abfe4-962e-ceef-5ab8-29e654303343@virtuozzo.com>
In-Reply-To: <fd9abfe4-962e-ceef-5ab8-29e654303343@virtuozzo.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Oct 2022 12:59:27 -0700
Message-ID: <CANn89iJ+mkitMrn3LYmY80LhCOoc7PLPP6r2wvFTyvLeBBDtLQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: reset tp->sacked_out when sack is enabled
To:     "Denis V. Lunev" <den@virtuozzo.com>
Cc:     Lu Wei <luwei32@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Pavel Emelianov (Gmail)" <ovzxemul@gmail.com>, avagin@gmail.com,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:59 AM Denis V. Lunev <den@virtuozzo.com> wrote:
>
> On 10/26/22 16:33, Eric Dumazet wrote:
> > On Wed, Oct 26, 2022 at 7:30 AM Eric Dumazet <edumazet@google.com> wrote:
> >> On Wed, Oct 26, 2022 at 7:12 AM Lu Wei <luwei32@huawei.com> wrote:
> >>> The meaning of tp->sacked_out depends on whether sack is enabled
> >>> or not. If setsockopt is called to enable sack_ok via
> >>> tcp_repair_options_est(), tp->sacked_out should be cleared, or it
> >>> will trigger warning in tcp_verify_left_out as follows:
> >>>
> >>> ============================================
> >>> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
> >>> tcp_timeout_mark_lost+0x154/0x160
> >>> tcp_enter_loss+0x2b/0x290
> >>> tcp_retransmit_timer+0x50b/0x640
> >>> tcp_write_timer_handler+0x1c8/0x340
> >>> tcp_write_timer+0xe5/0x140
> >>> call_timer_fn+0x3a/0x1b0
> >>> __run_timers.part.0+0x1bf/0x2d0
> >>> run_timer_softirq+0x43/0xb0
> >>> __do_softirq+0xfd/0x373
> >>> __irq_exit_rcu+0xf6/0x140
> >>>
> >>> This warning occurs in several steps:
> >>> Step1. If sack is not enabled, when server receives dup-ack,
> >>>         it calls tcp_add_reno_sack() to increase tp->sacked_out.
> >>>
> >>> Step2. Setsockopt() is called to enable sack
> >>>
> >>> Step3. The retransmit timer expires, it calls tcp_timeout_mark_lost()
> >>>         to increase tp->lost_out but not clear tp->sacked_out because
> >>>         sack is enabled and tcp_is_reno() is false.
> >>>
> >>> So tp->left_out is increased repeatly in Step1 and Step3 and it is
> >>> greater than tp->packets_out and trigger the warning. In function
> >>> tcp_timeout_mark_lost(), tp->sacked_out will be cleared if Step2 not
> >>> happen and the warning will not be triggered. So this patch clears
> >>> tp->sacked_out in tcp_repair_options_est().
> >>>
> >>> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
> >>> Signed-off-by: Lu Wei <luwei32@huawei.com>
> >>> ---
> >>>   net/ipv4/tcp.c | 3 +++
> >>>   1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >>> index ef14efa1fb70..188d5c0e440f 100644
> >>> --- a/net/ipv4/tcp.c
> >>> +++ b/net/ipv4/tcp.c
> >>> @@ -3282,6 +3282,9 @@ static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
> >>>                          if (opt.opt_val != 0)
> >>>                                  return -EINVAL;
> >>>
> >>> +                       if (tcp_is_reno(tp))
> >>> +                               tp->sacked_out = 0;
> >>> +
> >>>                          tp->rx_opt.sack_ok |= TCP_SACK_SEEN;
> >>>                          break;
> >>>                  case TCPOPT_TIMESTAMP:
> >>> --
> >>> 2.31.1
> >>>
> >> Hmm, I am not sure this is the right fix.
> >>
> >> Probably TCP_REPAIR_OPTIONS should not be allowed if data has already been sent.
> >>
> >> Pavel, what do you think ?
> > Routing to Denis V. Lunev <den@openvz.org>, because Pavel's address no
> > longer works.
> >
> > Thanks !
> Hi, guys!
>
> This code is used in CRIU. I have added CRIU maintainers
> Andrey Vagin, Pavel Tikhomirov and new address of Pavel
> Emelyanov to CC list.
>
> Here is the quote from Pavel Tikhomirov on the topic.
> "We do setsockopt with TCP_REPAIR_OPTIONS in CRIU just
> after calling connect to the socket here
> https://github.com/checkpoint-restore/criu/blob/18c6426eaeebc5fe7d0f9ca0acb592a3ec828b0c/soccr/soccr.c#L566
>
> and before libsoccr_restore_queue.
>
> So it seems there should be no data sent in this socket at
> the moment, so I believe it is safe to prohibit
> TCP_REPAIR_OPTIONS if data was already sent.
>
> Though I'd recomend running some CRIU tests after this
> change just to be sure that we don't break it.
> E.g.: "zdtm/static/socket-tcp*" or just
> "./test/zdtm.py run -a --keep-going --ignore-taint".

Thanks for confirming my suspicion.

Please Lu submit a different patch.

Your patch is only addressing the immediate issue (a WARNNG), but
should really be preventing
future bug reports because fuzzers will hit other points in the stack,
not expecting fundamental
TCP options being flipped in the middle of a connection.

Thanks

>
> Thank you in advance,
>      Den
