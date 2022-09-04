Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12D05AC28A
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 06:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiIDEec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 00:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDEeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 00:34:31 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B0D38AA;
        Sat,  3 Sep 2022 21:34:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l65so5689238pfl.8;
        Sat, 03 Sep 2022 21:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=rwZfnPErYVdrHZlGao6PR4yNldq77TfSQMeE7mXUsqE=;
        b=IESSFQr6sBOdPgDU0pkieqe5dkTbyrCb2vwGezLC5PA9WwF2V7fL102dSFGaE1Ocna
         ymw1NWXD1AAFVH5JVRSx6Zcyk/603+O9c/SDOAuHFE41Ax56C6Px32Iu7tJkfLRgWKjY
         tSDK8gytZudktmDSfCjSinfoYvVdsM6pB4fduOeGLEFhcE7Gb5kdP+zauty9jGhKKjtO
         ER4h1XNzhcICD4h8cvbz+zaw1n1pGnCTY/DIXB7QkNSHE/i7uyXrzeQr5HTvmQZvmxFi
         grP4cdmGjgNoiwPj1wBCy5cZQZ5cGNqMe+66iStSMFviWPGDh9K+LQypBze25dW2cT1B
         eiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=rwZfnPErYVdrHZlGao6PR4yNldq77TfSQMeE7mXUsqE=;
        b=x9GubfAPXU7cmOi8co0ymKkumxSV2807PfDorjQRCLircAjbuRnwQKq4Z32SIiIY1c
         a7UfnuivM/mlt1kk0jMqSZFffq0+ms/rNNBgFuKTjyba5ATXh0Syg90S83Dd3LgbovhN
         aJY7OPvcuiGlbT/9f+fCQLGd+WyaWKDJAN7hH88kmx88jt3Zp9kCkee4yk8ZhT4THHRd
         Q2G2D4gG+gK6wSZDcugBD5ZWSnOtrlRRS8qfJFmZtj6JSzmHGN5/tuyZnHdZUgi6NLAs
         IDrUzRL/LDasyd4SlL8YIxgt+qjn9EEY/aqmI6bClJl6sgXEZLxL0xsQm8s5gc0cHTUm
         jpTA==
X-Gm-Message-State: ACgBeo1ufw1UGJYI7j/dJqpP0amnlnDczECKCvQCpZKiRwv50Ztu9BbS
        wODM0lnnEREIw/lZMpLpUD6/0KdCXtssw48hTVg=
X-Google-Smtp-Source: AA6agR5IU17Wyp6JayLZn0CZS/fKsWIXnduAszhA7nLIXl32T2uckLu10z9hgrsAbYpGWbP9h/PJx3R+9MXQLqpWPg8=
X-Received: by 2002:a63:83c7:0:b0:42b:b618:31b4 with SMTP id
 h190-20020a6383c7000000b0042bb61831b4mr30080252pge.607.1662266069201; Sat, 03
 Sep 2022 21:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220902141715.1038615-1-imagedong@tencent.com> <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
In-Reply-To: <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 4 Sep 2022 12:34:18 +0800
Message-ID: <CADxym3bo8iQGmM-K-CUSGpjWSaBO5eg1=V8Cfs6wiSjWsEXydw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM
To:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Hao Peng <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, robh@kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 11:43 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Sep 2, 2022 at 7:18 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > As Eric reported, the 'reason' field is not presented when trace the
> > kfree_skb event by perf:
> >
> > $ perf record -e skb:kfree_skb -a sleep 10
> > $ perf script
> >   ip_defrag 14605 [021]   221.614303:   skb:kfree_skb:
> >   skbaddr=0xffff9d2851242700 protocol=34525 location=0xffffffffa39346b1
> >   reason:
> >
> > The cause seems to be passing kernel address directly to TP_printk(),
> > which is not right. As the enum 'skb_drop_reason' is not exported to
> > user space through TRACE_DEFINE_ENUM(), perf can't get the drop reason
> > string from the 'reason' field, which is a number.
> >
> > Therefore, we introduce the macro DEFINE_DROP_REASON(), which is used
> > to define the trace enum by TRACE_DEFINE_ENUM(). With the help of
> > DEFINE_DROP_REASON(), now we can remove the auto-generate that we
> > introduced in the commit ec43908dd556
> > ("net: skb: use auto-generation to convert skb drop reason to string"),
> > and define the string array 'drop_reasons'.
> >
> > Hmmmm...now we come back to the situation that have to maintain drop
> > reasons in both enum skb_drop_reason and DEFINE_DROP_REASON. But they
> > are both in dropreason.h, which makes it easier.
> >
> > After this commit, now the format of kfree_skb is like this:
> >
> > $ cat /tracing/events/skb/kfree_skb/format
> > name: kfree_skb
> > ID: 1524
> > format:
> >         field:unsigned short common_type;       offset:0;       size:2; signed:0;
> >         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
> >         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
> >         field:int common_pid;   offset:4;       size:4; signed:1;
> >
> >         field:void * skbaddr;   offset:8;       size:8; signed:0;
> >         field:void * location;  offset:16;      size:8; signed:0;
> >         field:unsigned short protocol;  offset:24;      size:2; signed:0;
> >         field:enum skb_drop_reason reason;      offset:28;      size:4; signed:0;
> >
> > print fmt: "skbaddr=%p protocol=%u location=%p reason: %s", REC->skbaddr, REC->protocol, REC->location, __print_symbolic(REC->reason, { 1, "NOT_SPECIFIED" }, { 2, "NO_SOCKET" } ......
> >
> > Reported-by: Eric Dumazet <edumazet@google.com>
>
> Note that I also provided the sha1 of the faulty patch.
>
> You should add a corresponding Fixes: tag, to help both humans and bots.
>

Okay, I'll add the Fixes tag......and  the Link tag.

> This would also hint that this patch should target net tree, not net-next ?
>

It seems that the net tree is more suitable. I'll change it.

Thanks!

> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> > v2:
> > - undef FN/FNe after use it (Jakub Kicinski)
>
> I would love some feedback from Steven :)

Hi, Steven! Do you have any feedback? Yes, I add the
TRACE_DEFINE_ENUM() back! (Hmm...I deleted it before,
without knowing its function :/ )

Thanks!
Menglong Dong
