Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D785E94B2
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 19:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiIYRNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 13:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIYRNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 13:13:33 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9252B27CF8
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 10:13:32 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-12803ac8113so6624557fac.8
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 10:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=V+KaTdAKkQZ1XSBh4p2sc1M/KAQsWHa8khKpB3E7NLs=;
        b=ptQbJTkAtJ0FiPs+v+66iqNZYHj4Xu12W3RjUQBIaeaRKmcaBUV6BVQ4/T8zVaWuXf
         SO1w4qbpYGrRofQZAlqgAc4ztEuJWXK1JCtCpLByo9heDygzOaXJ8S5ihRG/PNxyXZm4
         423QE5/QJr2XiX/8a2HP9QGz6/OPcFxW4DmNRTo26R7fl4ocobk9DEce8uPrN5dEGwRJ
         XzaggwIs28HReLk76QrelhQgRDmoubp/dJYzNZQGxQd0K9QhL6WYXGkuIsELWC2oH7kn
         g6YMAkCsZuBlGZ96KiQBBPsbTIzHKCUNFECA+iFgOekjAl/UflfuP5dBRCvCiYrs719l
         0jeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=V+KaTdAKkQZ1XSBh4p2sc1M/KAQsWHa8khKpB3E7NLs=;
        b=u7Eyhf1m5EOfcfnvYLafwmnSB02kRhbQDa8ugq74uX4xrl9tvlZINEPu38Bprg9VOp
         dF5Ipm0cnQIFkeejAuWdIpyY/kVIBUqnsl2ojyYbtu9B3MGGaaBjBaNh5oZ+oqzik32N
         kO/rLnSf5Vdag0nJ1UtI24yQ8Hp5uml2q5UHIWT1iQ3yXuxKOB15ZSGsNOcDmhK3PAni
         UFR3XT8NFclN+Frk5Mstq/aphhK5BvldjRxEJopH0wkxprJB+0PaJYXGqlF8iL+jg1Gu
         nc2TDarwWcUYkXzKoFkiTOFbdzMimJyUiOi6QZ+99gm6TnPsUY186i2MiAAvBnBSo97E
         5glA==
X-Gm-Message-State: ACrzQf30n3EiBSwdzbpmsymaPT6M+bhs4C+RUnsWH5F8knZaWcPxP4r4
        UVC9/o2j/qWNyBwALlgtDDInk5BncRehhWQFTLTiYw==
X-Google-Smtp-Source: AMsMyM4sx0PEj4cQHvR2BVwQt/BXKSJvR+7ZJ6msNiTiu0LYGMXKlpa3zEIjMo2c7Mzs8/sEZz+jHiXmncrUV0nC9/w=
X-Received: by 2002:a05:6870:1490:b0:126:e07:2a4a with SMTP id
 k16-20020a056870149000b001260e072a4amr9943567oab.2.1664126011909; Sun, 25 Sep
 2022 10:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a96c0b05e97f0444@google.com> <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
 <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com> <CAM0EoMkLdOUQ3yrBuYsLdZvqniZ_r0VoACzOzKCo1VVzYeyPbw@mail.gmail.com>
In-Reply-To: <CAM0EoMkLdOUQ3yrBuYsLdZvqniZ_r0VoACzOzKCo1VVzYeyPbw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 25 Sep 2022 13:13:20 -0400
Message-ID: <CAM0EoMmr8trH0EOtOfvTpYiTq1tt7RUamf1u_R0+USOU_gYUVg@mail.gmail.com>
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be clear, that splat didnt happen for me.
Is there something else syzbot does to activate it?

cheers,
jamal

On Sun, Sep 25, 2022 at 1:08 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Yes, after testing i realize there is nothing wrong here.
> What warning was i supposed to see from running the reproducer?
>
> We will still add the test will multiple keys later
>
> cheers,
> jamal
>
> On Sun, Sep 25, 2022 at 12:29 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sun, Sep 25, 2022 at 9:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > >
> > > On Sun, Sep 25, 2022 at 11:38 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > >
> > > > Is there a way to tell the boat "looking into it?"
> > >
> > >
> > > I guess I have to swim across to it to get the message;->
> > >
> > > I couldnt see the warning message  but it is obvious by inspection that
> > > the memcpy is broken. We should add more test coverage.
> > > This should fix it. Will send a formal patch later:
> > >
> > > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > > index 4d27300c2..591cbbf27 100644
> > > --- a/net/sched/cls_u32.c
> > > +++ b/net/sched/cls_u32.c
> > > @@ -1019,7 +1019,7 @@ static int u32_change(struct net *net, struct
> > > sk_buff *in_skb,
> > >         }
> > >
> > >         s = nla_data(tb[TCA_U32_SEL]);
> > > -       sel_size = struct_size(s, keys, s->nkeys);
> > > +       sel_size = struct_size(s, keys, s->nkeys) + sizeof(n->sel);
> > >         if (nla_len(tb[TCA_U32_SEL]) < sel_size) {
> > >                 err = -EINVAL;
> > >                 goto erridr;
> >
> > This patch is not needed, please look at struct_size() definition.
> >
> > Here, we might switch to unsafe_memcpy() instead of memcpy()
