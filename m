Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A35617E74
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiKCNzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiKCNzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:55:20 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8040AC774
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:55:18 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-13b103a3e5dso2219869fac.2
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 06:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TdPz9mrMSV0mLDD1LnuAN/2YSbFaycNRPgnZMSbqQC0=;
        b=rRZyZDoJLafXrgdXqgVgLeouQmCst+dIde8a/yUKgaCQ1TKsoxzrCCXzx0lX0fBPM3
         t8YAIVv849tDGaDrEreXNQTWM548v4HF0a+oPf+4lWoRWp5zeuHra0458duf5bVmrcYg
         zMeyTYGfQW4Mmh/SEKF1n8oQWOkoZeyE7xXVbVrocWuDvJwPDaRDe2ws5/e7dUnQ/OPC
         J5h7xcM3I/iejlNCp+osg1bEuoHa544UVyHg41VS6B9zLJEftUxA5UWctjrw3rfQA9bC
         defdrtdS9za2T0eVXw2LCEJM5D4ChKciu6uStni8W0++gnX3bPkpF1IhotMstsAQIc9s
         p1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TdPz9mrMSV0mLDD1LnuAN/2YSbFaycNRPgnZMSbqQC0=;
        b=inueRd4ybnkDOnHnHyK36JRcAN8aGgr2yZ+uirQvACthcFJJoRgIcXXxXKpYEPAB0c
         uuLazT4/bmDOvPqSIXnEkHA2qftQsioFfS6q0JXdJkbClx56QoPK88EAEYOEDXiRqbD+
         ttqCdz+IVlx31KIjAzoEQf89ZdtbTj3D+nuLkFSmoMug8p5Sv4M2srV5Qw86oU02/aH8
         CkyZMKU0YTAYnrshCAHbHZ3RWdYSV+MGNJll4JzeGydRsO32Wap7dwQABV9EhkUTYLCv
         01eNNXZ7FAbwUOupNNNROod3i2Du420PK1KKnyh+b50sO0bOUb9aWyAWBHpyDuuUMhwZ
         ILcg==
X-Gm-Message-State: ACrzQf3O3/hp6nTtHkEEXsIcokRr1kyS0xbckNQdFuB6avdL75Oj6zx6
        DnQdVXX64wr0G51+0G5P+wRHsyPicptCNTqlnVqDo+sOW3KKyQ==
X-Google-Smtp-Source: AMsMyM6A42zFf7qwvxhyWF96vGGy5g/f5NYHsJkE4IQvv0YEIYu8k0360thGfSEE4gq7Ulzi7BY11ljbkITGoJPaII0=
X-Received: by 2002:a05:6870:9a05:b0:132:ebf:dc61 with SMTP id
 fo5-20020a0568709a0500b001320ebfdc61mr17653487oab.76.1667483717633; Thu, 03
 Nov 2022 06:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221102132811.70858-1-luwei32@huawei.com> <CADVnQy=uE68AWKuSddKEt3T2X=HUYzs0SQPX31+HgafuysJzkA@mail.gmail.com>
 <ef5c0948-1a40-e4b7-5b1b-629cfcad1c37@huawei.com>
In-Reply-To: <ef5c0948-1a40-e4b7-5b1b-629cfcad1c37@huawei.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 3 Nov 2022 09:54:59 -0400
Message-ID: <CADVnQynXDAL=6V-a+L34bP3KEDWAWwk1kdL2ym0AttL_t54miA@mail.gmail.com>
Subject: Re: [patch net v3] tcp: prohibit TCP_REPAIR_OPTIONS if data was
 already sent
To:     "luwei (O)" <luwei32@huawei.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        xemul@parallels.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Nov 2, 2022 at 10:11 PM luwei (O) <luwei32@huawei.com> wrote:
>
>
> =E5=9C=A8 2022/11/2 10:46 PM, Neal Cardwell =E5=86=99=E9=81=93:
> > On Wed, Nov 2, 2022 at 8:23 AM Lu Wei <luwei32@huawei.com> wrote:
> >> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
> >> of TCPOPT_SACK_PERM is called to enable sack after data is sent
> >> and before data is acked, ...
> > This "before data is acked" phrase does not quite seem to match the
> > sequence below, AFAICT?
> >
> > How about something like:
> >
> >   If setsockopt TCP_REPAIR_OPTIONS with opt_code TCPOPT_SACK_PERM
> >   is called to enable SACK after data is sent and the data sender recei=
ves a
> >   dupack, ...
>       yes, thanks for suggestion
> >
> >
> >> ... it will trigger a warning in function
> >> tcp_verify_left_out() as follows:
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
> >> tcp_timeout_mark_lost+0x154/0x160
> >> tcp_enter_loss+0x2b/0x290
> >> tcp_retransmit_timer+0x50b/0x640
> >> tcp_write_timer_handler+0x1c8/0x340
> >> tcp_write_timer+0xe5/0x140
> >> call_timer_fn+0x3a/0x1b0
> >> __run_timers.part.0+0x1bf/0x2d0
> >> run_timer_softirq+0x43/0xb0
> >> __do_softirq+0xfd/0x373
> >> __irq_exit_rcu+0xf6/0x140
> >>
> >> The warning is caused in the following steps:
> >> 1. a socket named socketA is created
> >> 2. socketA enters repair mode without build a connection
> >> 3. socketA calls connect() and its state is changed to TCP_ESTABLISHED
> >>     directly
> >> 4. socketA leaves repair mode
> >> 5. socketA calls sendmsg() to send data, packets_out and sack_outs(dup
> >>     ack receives) increase
> >> 6. socketA enters repair mode again
> >> 7. socketA calls setsockopt with TCPOPT_SACK_PERM to enable sack
> >> 8. retransmit timer expires, it calls tcp_timeout_mark_lost(), lost_ou=
t
> >>     increases
> >> 9. sack_outs + lost_out > packets_out triggers since lost_out and
> >>     sack_outs increase repeatly
> >>
> >> In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
> >> Step7 not happen and the warning will not be triggered. As suggested b=
y
> >> Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
> >> already sent. So this patch checks tp->segs_out, only TCP_REPAIR_OPTIO=
NS
> >> can be set only if tp->segs_out is 0.
> >>
> >> socket-tcp tests in CRIU has been tested as follows:
> >> $ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
> >>         --ignore-taint
> >>
> >> socket-tcp* represent all socket-tcp tests in test/zdtm/static/.
> >>
> >> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameter=
s")
> >> Signed-off-by: Lu Wei <luwei32@huawei.com>
> >> ---
> >>   net/ipv4/tcp.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >> index ef14efa1fb70..1f5cc32cf0cc 100644
> >> --- a/net/ipv4/tcp.c
> >> +++ b/net/ipv4/tcp.c
> >> @@ -3647,7 +3647,7 @@ int do_tcp_setsockopt(struct sock *sk, int level=
, int optname,
> >>          case TCP_REPAIR_OPTIONS:
> >>                  if (!tp->repair)
> >>                          err =3D -EINVAL;
> >> -               else if (sk->sk_state =3D=3D TCP_ESTABLISHED)
> >> +               else if (sk->sk_state =3D=3D TCP_ESTABLISHED && !tp->s=
egs_out)
> > The tp->segs_out field is only 32 bits wide. By my math, at 200
> > Gbit/sec with 1500 byte MTU it can wrap roughly every 260 secs. So a
> > caller could get unlucky or carefully sequence its call to
> > TCP_REPAIR_OPTIONS (based on packets sent so far) to mess up the
> > accounting and trigger the kernel warning.
> >
> > How about using some other method to determine if this is safe?
> > Perhaps using tp->bytes_sent, which is a 64-bit field, which by my
> > math would take 23 years to wrap at 200 Gbit/sec?
> >
> > If we're more paranoid about wrapping we could also check
> > tp->packets_out, and refuse to allow TCP_REPAIR_OPTIONS if either
> > tp->bytes_sent or tp->packets_out are non-zero. (Or if we're even more
> > paranoid I suppose we could have a special new bit to track whether
> > we've ever sent something, but that probably seems like overkill?)
> >
> > neal
> > .
>
> I didn't notice that u32 will be easily wrapped in huge network throughpu=
t,
> thank you neal.
>
> But tcp->packets_out shoud not be used because tp->packets_out can decrea=
se
> when expected ack is received, so it can decrease to 0 and this is the co=
mmon
> condition.

To say tp->packets_out should not be used is a bit strong. :-)
Obviously packets_out decreases when packets are ACKed. The point of
checking both tp->bytes_sent and tp->packets_out would be if we are
paranoid enough that we want to prevent this warning in the case where
tp->bytes_sent wraps and becomes zero. If tp->bytes_sent wraps and is
zero, we will be saved from hitting this warning if we deny the
request to set TCP_REPAIR_OPTIONS if tp->packets_out is non-zero.
(Because we can only hit this warning if tp->sacked_out is non-zero,
and tp->sacked_out should only be non-zero if tp->packets_out is
non-zero.)

neal
