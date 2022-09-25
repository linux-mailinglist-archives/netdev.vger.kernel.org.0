Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AACC5E94AB
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 19:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiIYRIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 13:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiIYRI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 13:08:29 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FEB2E68F
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 10:08:28 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id j188so5903608oih.0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 10:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=x/mLY200nExok1rcGyv5cZRAN/HZiWpEMUT9zCLunDY=;
        b=CtuCaN1W/G+5IuzqlATEaaV4Xs2Nc5TepFhZKgkh3REVr+AsXYMElB6HCvsgTDKo1X
         s+Kit44WHsmSX4qckTDCNtWF8jPNeinculIi1dwp5H9+VoNuADOErzQkpnVXjjZh65UV
         C7+2O0Ow/N8ap5WmUPKCW8d+78yCB2e9nglH/bC3F1sOZVaUDE40hud882jmDu9+9QeW
         Kt6Cik7N4ZSASzWFjQnJLAg/bLb3lvFp+7HAeGGwYfaWg7sKKxE7zV39va9GGb0RMKa/
         PY/834ql4nU6D3mpBwbV6Cc3Aqhu4Na2ZKAC2DWFuAMFl2C8md3m+UjQ2cOreNLvuur9
         XhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=x/mLY200nExok1rcGyv5cZRAN/HZiWpEMUT9zCLunDY=;
        b=uKzOv1Wml6uWNYWAqAhanmo4vV0ts2IFwmdb5CMCSbKByOpRIP3yaMeSLf+YMq1Oup
         awTX1Z1IXz8A8wHsMFVpwxtK/sxq3elgVgwUH7EA4uWauC2KYZv03kSbzrvdLyRWaQOV
         55bkAoZrQ7QdRs7QOrAO02/TdzdPYBknTODrcNepqPZUXm+/02CVhfoes8XHgJl3nxoa
         evrP3nqo1XRIWN5EPEPEnG10KCK7AlDZhC5yf1rcOnzONA3+XH0avP/orH2od0527Rb7
         wAhDVheIRgdxEtqzmV2YdZPEtWj3slORJpdXecEayiab0M8BLJW7abgjJFWxsTN9QedE
         GYQQ==
X-Gm-Message-State: ACrzQf0PwnZtUz3oz9Lpt8IU26lXPBjGFtzMtf1KvwZ455wMIze3e0us
        BqHiyK1iyMPp0aQ6c/mmPy160w60S3TzABwPeUnLzNfxpp2RQdD4
X-Google-Smtp-Source: AMsMyM6JqVyRVSONDUfU1I/N2AUhOEfvGKpU9QiU2v66w5QrRTd9rBptGOadIve3hiFQlcjyvBc40fEjaWV0hEjhKhw=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr8441959oiw.106.1664125707738; Sun, 25
 Sep 2022 10:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a96c0b05e97f0444@google.com> <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com> <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com>
In-Reply-To: <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 25 Sep 2022 13:08:16 -0400
Message-ID: <CAM0EoMkLdOUQ3yrBuYsLdZvqniZ_r0VoACzOzKCo1VVzYeyPbw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in u32_change
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, after testing i realize there is nothing wrong here.
What warning was i supposed to see from running the reproducer?

We will still add the test will multiple keys later

cheers,
jamal

On Sun, Sep 25, 2022 at 12:29 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, Sep 25, 2022 at 9:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > On Sun, Sep 25, 2022 at 11:38 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > >
> > > Is there a way to tell the boat "looking into it?"
> >
> >
> > I guess I have to swim across to it to get the message;->
> >
> > I couldnt see the warning message  but it is obvious by inspection that
> > the memcpy is broken. We should add more test coverage.
> > This should fix it. Will send a formal patch later:
> >
> > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > index 4d27300c2..591cbbf27 100644
> > --- a/net/sched/cls_u32.c
> > +++ b/net/sched/cls_u32.c
> > @@ -1019,7 +1019,7 @@ static int u32_change(struct net *net, struct
> > sk_buff *in_skb,
> >         }
> >
> >         s = nla_data(tb[TCA_U32_SEL]);
> > -       sel_size = struct_size(s, keys, s->nkeys);
> > +       sel_size = struct_size(s, keys, s->nkeys) + sizeof(n->sel);
> >         if (nla_len(tb[TCA_U32_SEL]) < sel_size) {
> >                 err = -EINVAL;
> >                 goto erridr;
>
> This patch is not needed, please look at struct_size() definition.
>
> Here, we might switch to unsafe_memcpy() instead of memcpy()
