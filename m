Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D14512B594
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 16:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL0PYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 10:24:51 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35201 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0PYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 10:24:51 -0500
Received: by mail-yb1-f194.google.com with SMTP id a124so11372581ybg.2
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 07:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5CBV5e3UwZ7IM8aDIRZKWmUeSfV3/CUU9bvs1CVz1tM=;
        b=rInWPVgIYggZPcAwBmekbZz4AoEChRpxiCLeuGAzEdjTrvOJw0NdEf9r3+I35sC/Qy
         TOOVAvlovpVJWv5SlDIe4SvPMOyaiGBeNBUu9vNBQMNbEIlV0Vkh7Pt3/x1WSdEK44kA
         1WWBmwwdwp8HprzB124xbegB6mRFSJuNO9NHzTFQ5zbX4X3np8t3a9gGFCikY67/PFr3
         yE9igHy1HMbAWhXDpgEJT3tNgJBbXpXjDU7HVEkMDTlKtP+rMYWV/95Ljx4Nz90RUUip
         vJiU/m1DacZ9sJR/+Ozo7Y5sKZmtlsWaHr53Ca77YI2yzq4WzFYYWJpHVyaCgLb2FzD+
         CaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5CBV5e3UwZ7IM8aDIRZKWmUeSfV3/CUU9bvs1CVz1tM=;
        b=bivyfaoMBehUjRWXcJmjVKq5YhDXSO2AZL0fc5zoKgvdJChgL9XxC/9dbTJBVOo0Ej
         Y+sVI7x1vSDuY18cuzmcIPrUwFuoJvojODXYXDj7zjg+K3Z7cpFLeymhSTNvkP2EPvqs
         csLiJ+0KtQ4Huhuoc/O2lXKMYJkkYrb8jqQwYc/27l2WPbktGySNd4gC5lFSEhVmoH0E
         7TwzFUEakLwqm5LXqzU1Sb1LRKbv/dxG1bFSH8eF8mpV9D3hXwO2ldqxye2bwR5PfPEt
         ENI7H+EfgTHtZcGgNBMYlzXF9tJ0ir/8IasGUBnhSE2KeYRFRVgakn4iLecHJFwFQe82
         IHGA==
X-Gm-Message-State: APjAAAVkyxnUvVjgO+ue4mV83LoZhUelH3vyoUIhi5V4Rljmfe7h0ewR
        iOkm3JDKxfkW+Vdqb8OoP/+gjqYrPJEVRHs31PPLcQ==
X-Google-Smtp-Source: APXvYqx8bX39QAmmD1HLfnCLBy+Fl7izG156OImc4AJZVOfV3SvBFS+fd/R3i57l18/DQvcrJAU65FDehB4UpRbRPnY=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr40252180ybc.101.1577460289989;
 Fri, 27 Dec 2019 07:24:49 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-4-edumazet@google.com>
 <CADVnQynXwSoG4mjAnpy_LrLpR0RGur2ZjayNMM-TX7vGo6BxuA@mail.gmail.com>
In-Reply-To: <CADVnQynXwSoG4mjAnpy_LrLpR0RGur2ZjayNMM-TX7vGo6BxuA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Dec 2019 07:24:38 -0800
Message-ID: <CANn89iKF8+sjonkgvw25V6or2huUffn9F7nNjiQDAsymLm-P0g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/5] tcp_cubic: switch bictcp_clock() to usec resolution
To:     Neal Cardwell <ncardwell@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 6:46 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Current 1ms clock feeds ca->round_start, ca->delay_min,
> > ca->last_ack.
> >
> > This is quite problematic for data-center flows, where delay_min
> > is way below 1 ms.
> >
> > This means Hystart Train detection triggers every time jiffies value
> > is updated, since "((s32)(now - ca->round_start) > ca->delay_min >> 4)"
> > expression becomes true.
> >
> > This kind of random behavior can be solved by reusing the existing
> > usec timestamp that TCP keeps in tp->tcp_mstamp
> ...
> > @@ -438,7 +431,7 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
> >         if (ca->epoch_start && (s32)(tcp_jiffies32 - ca->epoch_start) < HZ)
> >                 return;
> >
> > -       delay = (sample->rtt_us << 3) / USEC_PER_MSEC;
> > +       delay = sample->rtt_us;
>
> It seems there is a bug in this patch: it changes the code to not
> shift the RTT samples left by 3 bits, and adjusts the
> HYSTART_ACK_TRAIN code path to expect the new behavior, but does not
> change the HYSTART_DELAY code path to expect the new behavior, so the
> HYSTART_DELAY code path is still shifting right by 3 bits, when it
> should not... the HYSTART_DELAY remains like this at the end of the
> patch series:
>
>         if (hystart_detect & HYSTART_DELAY) {
> ...
>                         if (ca->curr_rtt > ca->delay_min +
>                             HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
>
> AFAICT the patch also should have:
>
> -                            HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
> +                           HYSTART_DELAY_THRESH(ca->delay_min)) {
>


I do not think so Neal.

The HYSTART_DELAY_THRESH(ca->delay_min >> 3) thing really means we
want to apply a 12.5 % factor.

See commit 42eef7a0bb09 "tcp_cubic: refine Hystart delay threshold"
for some context.

After this patch, ca->delay_min is in usec unit, and ca->cur_rtt is
also in usec unit.

Thanks !
