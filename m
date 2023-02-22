Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7D69EDA1
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjBVDr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjBVDrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:47:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F270A2DE66;
        Tue, 21 Feb 2023 19:47:44 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f13so24705636edz.6;
        Tue, 21 Feb 2023 19:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JTsXlkDchbsVNM/nwNQgg0wYui/RKX5XK9Zb2Km8MwE=;
        b=V7/W1hgfvDAONcno96OpT6N8A4alYpITdl6yNt3D6Du105mXOO9iJDWUca1CaI/1K/
         PtFGI9r/YaT3SyeNQlE7O3hCy6LsvyUEOnWc2CDvQs9QOHSx7qANwoUP/1UCpIv6sMcr
         ctFhlLIeyWMx3vX0BdeGF3R5HO8iX96EHn+CEFqhopmDep+X9WanFWS/mD909T1JzJAe
         2xy4jMhrgo4d7f4eldJrqIY1qHCHIbr0kwX1myas17Ech1UqN/8mAl4rMeRN7ax7+hvN
         AsU1XagJzG9296HFLhl/yaCXBroyVWiaPb+4Glm5NP9+9D5qyB5xPfvYfLCX2PZGLdRF
         B4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JTsXlkDchbsVNM/nwNQgg0wYui/RKX5XK9Zb2Km8MwE=;
        b=ly5QMt6+FGDlKS1O7T84YRtExQENghjqRPt/+j0udiPPEb7WU6fDAc5oyQTkLcHSfM
         csG+cEiAW6Et+nYa+kR4MXuRt3H6487wqBkUCfqFNi2790Uwx2hErTycFJ6NVJ0paJgE
         kwGTbNfLDxh2ev2Jn4kR05ImqQgVFQYkjt74UkFFhCIY2NJ0nT3LVztc1kDlEkziKvmW
         n/ephBp4LZ85uG7N03oN2wuDj2LJmMQB87oJuPomAZ7fjaTSYf2Pc0aSxy+rz1qTHl9g
         G2nqkuc73GTFK886v7+m+OGj+iKPW2uU07nUWhoih9dmFqfBF5n8cxTVO9iuOtdJKZM/
         Te6g==
X-Gm-Message-State: AO0yUKWyb7PoPF92NQwp5p9J+iA5ALEVznvOrIWTbxUcU2irqDTtPMFC
        nl3IRB2N44sfiIBZXial/PqoVGxTvA8sTzMxOII=
X-Google-Smtp-Source: AK7set/RhKw0VVjD4gRGKEN6BevelxlvRv1gKfP1doPNzdzG4PYgYnMJRTXhRZ9KLvEl86zfMhRWGc+uG0efyeEi2CE=
X-Received: by 2002:a50:c052:0:b0:4ac:20b:96b7 with SMTP id
 u18-20020a50c052000000b004ac020b96b7mr3183468edd.8.1677037663301; Tue, 21 Feb
 2023 19:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20230221110344.82818-1-kerneljasonxing@gmail.com>
 <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
 <CAL+tcoD8PzL4khHq44z27qSHHGkcC4YUa91E3h+ki7O0u3SshQ@mail.gmail.com>
 <aaf3d11ea5b247ab03d117dadae682fe2180d38a.camel@redhat.com> <CAL+tcoBZFFwOnUqzcDtSsNyfPgHENAOv0bPcvncxuMPwCn40+Q@mail.gmail.com>
In-Reply-To: <CAL+tcoBZFFwOnUqzcDtSsNyfPgHENAOv0bPcvncxuMPwCn40+Q@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 22 Feb 2023 11:47:06 +0800
Message-ID: <CAL+tcoBGFkXea-GyzbO41Ve8_wUF3PT=YF43TxuzgM+adVa8gw@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix memory schedule error
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 11:46 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Tue, Feb 21, 2023 at 10:46 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Tue, 2023-02-21 at 21:39 +0800, Jason Xing wrote:
> > > On Tue, Feb 21, 2023 at 8:27 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > >
> > > > On Tue, 2023-02-21 at 19:03 +0800, Jason Xing wrote:
> > > > > From: Jason Xing <kernelxing@tencent.com>
> > > > >
> > > > > Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
> > > > > and sk_rmem_schedule() errors"):
> > > > >
> > > > > "If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> > > > > we want to allocate 1 byte more (rounded up to one page),
> > > > > instead of 150001"
> > > >
> > > > I'm wondering if this would cause measurable (even small) performance
> > > > regression? Specifically under high packet rate, with BH and user-space
> > > > processing happening on different CPUs.
> > > >
> > > > Could you please provide the relevant performance figures?
> > >
> > > Sure, I've done some basic tests on my machine as below.
> > >
> > > Environment: 16 cpus, 60G memory
> > > Server: run "iperf3 -s -p [port]" command and start 500 processes.
> > > Client: run "iperf3 -u -c 127.0.0.1 -p [port]" command and start 500 processes.
> >
> > Just for the records, with the above command each process will send
> > pkts at 1mbs - not very relevant performance wise.
> >
> > Instead you could do:
> >
>
> > taskset 0x2 iperf -s &
> > iperf -u -c 127.0.0.1 -b 0 -l 64
> >
>
> Thanks for your guidance.
>
> Here're some numbers according to what you suggested, which I tested
> several times.
> ----------|IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
> Before: lo 411073.41 411073.41  36932.38  36932.38
> After:   lo 410308.73 410308.73  36863.81  36863.81
>
> Above is one of many results which does not mean that the original
> code absolutely outperforms.
> The output is not that constant and stable, I think.

Today, I ran the same test on other servers, it looks the same as
above. Those results fluctuate within ~2%.

Oh, one more thing I forgot to say is the output of iperf itself which
doesn't show any difference.
Before: Bitrate is 211 - 212 Mbits/sec
After: Bitrate is 211 - 212 Mbits/sec
So this result is relatively constant especially if we keep running
the test over 2 minutes.

Jason

>
> Please help me review those numbers.
>
> >
> > > In theory, I have no clue about why it could cause some regression?
> > > Maybe the memory allocation is not that enough compared to the
> > > original code?
> >
> > As Eric noted, for UDP traffic, due to the expected average packet
> > size, sk_forward_alloc is touched quite frequently, both with and
> > without this patch, so there is little chance it will have any
> > performance impact.
>
> Well, I see.
>
> Thanks,
> Jason
>
> >
> > Cheers,
> >
> > Paolo
> >
