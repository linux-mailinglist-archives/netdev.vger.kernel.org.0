Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0C366CF5B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 20:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjAPTKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 14:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjAPTKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 14:10:50 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC3B2A153
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 11:10:50 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id c124so31315882ybb.13
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 11:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T1mT9mRqrzrIwg9TcgFcM5mvnxSJtYl+A/F8TWm+guQ=;
        b=C9iEtLNzlzxohepfrcOUAIyCYrC5bWfGIfxpKfEExFHZgdWo93Pl151ZeLHSrVA5Jw
         rSzygP9inecEgeszxTDO1MeLQN523/6g7DiSInp4286bgRl9w1Iha8rBAI9fLg1cIuWj
         bjjPVZ6U6hVJ9NMXRNMKy2xrI2FREc7jc0pbh6KmZ8QqDdUkbv3WUM8vHynvmD7ZKzFE
         zNRwuPsopj2Hs0iPeNOvEJcB+e8NtBlIEAw3sy7Dfbk95LnbqwrVLSIEZ3xwtcYsToSc
         bnp5cvlld0lHqEF6mfaYvdcToaQCT4uJ6n20uOzNDS0MJ3EABCaUuHyG0wqMW4P3dv4J
         XLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T1mT9mRqrzrIwg9TcgFcM5mvnxSJtYl+A/F8TWm+guQ=;
        b=0qxN1J/0ENrf807ocyKrhSqxtGUrcDPaYKLy5RpEKFMrTwL1IEkQJFdzyQFUb+mm1y
         xVqIfxPZ5qno+6YTJwkzBlhfiYKrifUiE/igl3VasM9PhTu4L98JTE38buOWbI+80iui
         ovRlxBQx4i/7ucDwwTYwLPRLO8/XGCWceEbzvYq2gZ0aZsw0BWBrdzgQvLadB59ZxIfu
         hGAmtfHtVVCQUHxSedM4nIKBQ3LHrHsX9O1IblD+ZA09BGCRl75oHuLX4fXc+tlHDPFI
         SX2AXaJLXiPlyBdvl3hbbqTmEyrImiP4ftapfI/i0QqqV28PHf9Lr9NmP/AbYKhROgUy
         7ENw==
X-Gm-Message-State: AFqh2krvosTyP2XYAC8MS66ReP/5jvFHmtipjwtbGEGYTI8kissc8LXb
        feuDrfWogDu6iovokmEBUwY290/s7UpNzLcxzLQ=
X-Google-Smtp-Source: AMrXdXv/JJSND8vKw9TnBaaL5ZCDAKJK2pFeYHaJ3gCN0TNCExe9h/C543N3oZ1E8iZyeyXtRUg7J7nsWB99N+/L1Rk=
X-Received: by 2002:a05:6902:4ee:b0:7b9:d00b:5892 with SMTP id
 w14-20020a05690204ee00b007b9d00b5892mr101992ybs.470.1673896249257; Mon, 16
 Jan 2023 11:10:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
In-Reply-To: <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 16 Jan 2023 14:09:29 -0500
Message-ID: <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
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

On Mon, Jan 16, 2023 at 11:02 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jan 16, 2023 at 4:08 PM David Ahern <dsahern@gmail.com> wrote:
> >
>
> > not sure why you think it would not be detected. Today's model for gro
> > sets tot_len based on skb->len. There is an inherent trust that the
> > user's of the gro API set the length correctly. If it is not, the
> > payload to userspace would ultimately be non-sense and hence detectable.
>
> Only if you use some kind of upper protocol adding message integrity
> verification.
>
> > >
> > > As you said, user space sniffing packets now have to guess what is the
> > > intent, instead of headers carrying all the needed information
> > > that can be fully validated by parsers.
> >
> > This is a solveable problem within the packet socket API, and the entire
> > thing is opt-in. If a user's tcpdump / packet capture program is out of
> > date and does not support the new API for large packets, then that user
> > does not have to enable large GRO/TSO.
>
> I do not see this being solved yet.
I think it's common that we add a feature that is disabled by
default in the kernel if the userspace might not support it.

>
> We have enabled BIG TCP only for IPv6, we do not want the same to
> magically be enabled for ipv4
> when a new kernel is deployed.
>
> Make sure that IPV4 BIG TCP is guarded by a separate tunable.
I can understand this.

Thanks.
