Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF24E747B
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 14:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358292AbiCYNuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 09:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357290AbiCYNux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 09:50:53 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D34A5EBC
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:49:19 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id p25so5976979qkj.10
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98/USP9WhCm9yFVujLvLXObgTqJRm62hpT05OLs5ACA=;
        b=GgSUf3Z9vLbK1V1vBPfA3IdL4eq9x0yogPi6T9HzDzU0/dGG8YJEGcY5eGj+GXfOk7
         XHW9BEGndwU13FG1FXJ8tZA8OD7vTpIOIFgAAJumfLiYWMDpabYnxkKWBPae6tNViESb
         eEu8qAQkCm69dgYziAnfaUPCLAbVeGLyhortthLcv+9420oBC1UdHypKkxMmCQcjTjB3
         M2pHvNYYRK5+SBs9FD3Qyj/PB4YOCfzNR9vlu0OcDwnwo1YRRCnOp2cWHe+9LV+w8N30
         dnbRlIqkSBtttzI17+44DLuCWgvPO3OpoAaxhbCbapLaIoFGlIlGTPV2/bM/KSG7S9or
         Bh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98/USP9WhCm9yFVujLvLXObgTqJRm62hpT05OLs5ACA=;
        b=ZwKp9EQU68LYuXEYSSBy7Fmx5l0oN0l0Cxt3HrFdZSa/aW/5oMxXFf2JEkG6ZN41N6
         KdbKTZxa8eGvqlmBvENpP0ntebyKEG7liRuLyTXItsar0JZUwxN9t+sAPaMaM0dQ0VoD
         Lk6zakzwvHcsydXFEz9HvoqGjln4kWx0jDvcCIFS5nN8ok8JPvgs3xAZBoS3umUERrXh
         H4v4ermbVDXHg2fW70IUTfcgUrQBC7rBzYwNsUFO52VUDSW0Ga8EUZxlKhJs+bgmD6Kv
         DNhjm6DuWAW985YNmjmuqSMaaPz0sjthaklajOYyJL0o0/e66T7J6afDU1TIiwKSsI6B
         41Rg==
X-Gm-Message-State: AOAM530zOQKvAhyK72tPl+pWYkmOMPZZRQmKbexffiqVjYUgjnvwxaKC
        oHp70y/RfvVQjJHDzhoU9UXpibFo0co=
X-Google-Smtp-Source: ABdhPJx0BMVteB1P+ysW5PrNVvBATJN/EXa7n6xUG7jfw+skG/cWo8xSCRX8t4BgHTRhkmVq2uCPpg==
X-Received: by 2002:a05:620a:240c:b0:680:a0f6:af19 with SMTP id d12-20020a05620a240c00b00680a0f6af19mr5123355qkn.110.1648216158963;
        Fri, 25 Mar 2022 06:49:18 -0700 (PDT)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com. [209.85.128.170])
        by smtp.gmail.com with ESMTPSA id t7-20020a05622a180700b002e0ccf0aa49sm5280686qtc.62.2022.03.25.06.49.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:49:18 -0700 (PDT)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2e5e176e1b6so83466577b3.13
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:49:18 -0700 (PDT)
X-Received: by 2002:a81:ad67:0:b0:2e5:8466:322a with SMTP id
 l39-20020a81ad67000000b002e58466322amr10500973ywk.54.1648216157853; Fri, 25
 Mar 2022 06:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220324213954.3ln7kvl5utadnux6@skbuf> <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
 <20220325133722.sicgl3kr5ectveix@skbuf>
In-Reply-To: <20220325133722.sicgl3kr5ectveix@skbuf>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 25 Mar 2022 09:48:41 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeJCZ1F3b9rrLpdcp6sbok8OXBA40jSmtxbJ7cnQayr+w@mail.gmail.com>
Message-ID: <CA+FuTSeJCZ1F3b9rrLpdcp6sbok8OXBA40jSmtxbJ7cnQayr+w@mail.gmail.com>
Subject: Re: Broken SOF_TIMESTAMPING_OPT_ID in linux-4.19.y and earlier stable branches
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
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

On Fri, Mar 25, 2022 at 9:37 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Willem,
>
> Thanks for the reply.
>
> On Fri, Mar 25, 2022 at 09:15:30AM -0400, Willem de Bruijn wrote:
> > On Thu, Mar 24, 2022 at 5:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > Hello Willem,
> > >
> > > I have an application which makes use of SOF_TIMESTAMPING_OPT_ID, and I
> > > received reports from multiple users that all timestamps are delivered
> > > with a tskey of 0 for all stable kernel branches earlier than, and
> > > including, 4.19.
> > >
> > > I bisected this issue down to:
> > >
> > > | commit 8f932f762e7928d250e21006b00ff9b7718b0a64 (HEAD)
> > > | Author: Willem de Bruijn <willemb@google.com>
> > > | Date:   Mon Dec 17 12:24:00 2018 -0500
> > > |
> > > |     net: add missing SOF_TIMESTAMPING_OPT_ID support
> > > |
> > > |     SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
> > > |     But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.
> > > |
> > > |     Add skb_setup_tx_timestamp that configures both tx_flags and tskey
> > > |     for these paths that do not need corking or use bytestream keys.
> > > |
> > > |     Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
> > > |     Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > |     Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> > > |     Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
> > > and, interestingly, I found this discussion on the topic:
> > > https://www.spinics.net/lists/netdev/msg540752.html
> > > (copied here in case the link rots in the future)
> > >
> > > | > Series applied.
> > > | >
> > > | > What is your opinion about -stable for this?
> > > |
> > > | Thanks David. Since these are just missing features that no one has
> > > | reported as actually having been missing a whole lot, I don't think
> > > | that they are worth the effort or risk.
> > >
> > > So I have 2 questions:
> > >
> > > Is there a way for user space to validate functional kernel support for
> > > SOF_TIMESTAMPING_OPT_ID? What I'm noticing is that (at least with
> > > AF_PACKET sockets) the "level == SOL_PACKET && type == PACKET_TX_TIMESTAMP"
> > > cmsg is _not_ missing, but instead contains a valid sock_err->ee_data
> > > (tskey) of 0.
> >
> > The commit only fixes missing OPT_ID support for PF_PACKET and various SOCK_RAW.
> >
> > The cmsg structure returned for timestamps is the same regardless of
> > whether the option is set configured. It just uses an otherwise constant field.
> >
> > On these kernels the feature is supported, and should work on TCP and UDP.
> > So a feature check would give the wrong answer.
>
> Ok, I read this as "user space can't detect whether OPT_ID works on PF_PACKET sockets",
> except by retroactively looking at the tskeys, and if they're all zero, say
> "hmm, something's not right". Pretty complicated.
>
> So we probably need to fix the stable kernels. For the particular case
> of my application, I have just about zero control of what kernel the
> users are running, so the more stable branches we could cover, the better.
>
> > > If it's not possible, could you please consider sending these fixes as
> > > patches to linux-stable?
> >
> > The first of the two fixes
> >
> >     fbfb2321e9509 ("ipv6: add missing tx timestamping on IPPROTO_RAW")
> >
> > is in 4.19.y as of 4.19.99
> >
> > The follow-on fix that you want
> >
> >     8f932f762e79 ("net: add missing SOF_TIMESTAMPING_OPT_ID support")
> >
> > applies cleanly to 4.19.236.
> >
> > I think it's fine to cherry-pick. Not sure how to go about that.
>
> Do you have any particular concerns about sending this patch to the
> linux-stable branches for 4.19, 4.14 and 4.9? From https://www.kernel.org/
> I see those are the only stable branches left.

The second patch does not apply cleanly to 4.14.y and even the first
(one-liner) has a conflict on 4.9.y.

It would be good to verify by running the expanded
tools/testing/selftests/net/txtimestamp.c against the patched kernels
first. That should serve as a good test whether the feature works on a
kernel, re: that previous point.

If you want to test and send the 4.19.y patch, please go ahead. Or I
can do it, but it will take some time.
