Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A921617013
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiKBVtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKBVtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:49:51 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90EB6428
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:49:50 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-368edbc2c18so178778887b3.13
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 14:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a+O/DyQ0G+dRjY5LIarEEDWC0+9+Vhve0t7ZqJKRHFo=;
        b=sctTR2AWCij59qT1LYe9H9J6FYKUKFMKJ0YheKvT7mHc2eIExKHyEFuScm2mQcl39v
         I/Rkojaphrtl/DkZYSSd9VuOVo0XsIeaS6aYCH0LyQsDw3sR/BloSc1vG5FoquWy2nli
         EjZHyhip/+635zi8lqkwEJvAuTuFc4+mgvUMAcH7uyfn1KTKrl4j3OsNZUOTYy91ppSK
         6doaF+atG0VHTvzwmvBYL9ASpAMFml/HvlH0GqU+eR4mQrZ/HJYYQJCPSnxO4yaqiTHp
         4RZ0IvHaAenXjCsS6jy6qqc/WpEEtstlAdm70ctrCCCvbGz1JFES9f/ButhCfldH6zr+
         jePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a+O/DyQ0G+dRjY5LIarEEDWC0+9+Vhve0t7ZqJKRHFo=;
        b=gblBGZR2HvzWwlwFP8tkY2cEJuz+v/XNbZhy4H2oTyyQ0h13xT4gZmgCQVoa9/9Xyr
         rRpY41VidVQxqoBnLREaH9/iZAGkvhqgcdHRX/u4Lr3P6GFyB2mjiVWr7dTi24rhWX6I
         4Xoj2szU1ZhkGAiUEP2moYYKdGP3I3VNUCq1XGsJ4YYLP0pNHXDOSpWS+YhmS+sT/z12
         +rGl2gK+dRYkZXRLTKXPwV/Mf5QIyEPXh32dFifOIj4/d4XtrvbRxnRSTWlctxxIORzH
         iKQZXK5qVwmsL/GJKG5LBrVaiXRSI88cWiPZvq2k52gAH1AEcSZfDP1TlaBbbwencS4+
         7LzA==
X-Gm-Message-State: ACrzQf2i4KkjN80ATb+iNTqgB8S2aalXVObluXUS68saYDsgc7ZXVz3k
        4/NwLBje9hbQrA9iz0Qq2t2aH7lqnXs34BCKp8fkzQ==
X-Google-Smtp-Source: AMsMyM7R0dIO3FRgY0SoeTGn3cQawzVAjJ1bCkU7NeraXVSDxfjCex/MdSyQJMnoCwoRT4l9P0gK3tCQueCqMuVBAwE=
X-Received: by 2002:a81:9a4f:0:b0:367:fbf9:b9f1 with SMTP id
 r76-20020a819a4f000000b00367fbf9b9f1mr25684882ywg.55.1667425789743; Wed, 02
 Nov 2022 14:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221102211350.625011-1-dima@arista.com> <20221102211350.625011-3-dima@arista.com>
 <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com> <483848f5-8807-fd97-babc-44740db96db4@arista.com>
In-Reply-To: <483848f5-8807-fd97-babc-44740db96db4@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 14:49:38 -0700
Message-ID: <CANn89i+XyQhh0eNMJWNn6NNLDaMtrzX3sq9Atu-ic7P5uqDODg@mail.gmail.com>
Subject: Re: [PATCH 2/2] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Nov 2, 2022 at 2:40 PM Dmitry Safonov <dima@arista.com> wrote:
>
> On 11/2/22 21:25, Eric Dumazet wrote:
> > On Wed, Nov 2, 2022 at 2:14 PM Dmitry Safonov <dima@arista.com> wrote:
> [..]
> >> +int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
> >> +                  int family, u8 prefixlen, int l3index, u8 flags,
> >> +                  const u8 *newkey, u8 newkeylen)
> >> +{
> >> +       struct tcp_sock *tp = tcp_sk(sk);
> >> +
> >> +       if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
> >> +               if (tcp_md5sig_info_add(sk, GFP_KERNEL))
> >> +                       return -ENOMEM;
> >> +
> >> +               static_branch_inc(&tcp_md5_needed.key);
> >> +       }
> >> +
> >> +       return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index, flags,
> >> +                               newkey, newkeylen, GFP_KERNEL);
> >> +}
> >>  EXPORT_SYMBOL(tcp_md5_do_add);
> >>
> >> +int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
> >> +                    int family, u8 prefixlen, int l3index,
> >> +                    struct tcp_md5sig_key *key)
> >> +{
> >> +       struct tcp_sock *tp = tcp_sk(sk);
> >> +
> >> +       if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
> >> +               if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
> >> +                       return -ENOMEM;
> >> +
> >> +               atomic_inc(&tcp_md5_needed.key.key.enabled);
> >
> > static_branch_inc ?
>
> That's the difference between tcp_md5_do_add() and tcp_md5_key_copy():
> the first one can sleep on either allocation or static branch patching,
> while the second one is used where there is md5 key and it can't get
> destroyed during the function call. tcp_md5_key_copy() is called
> somewhere from the softirq handler so it needs an atomic allocation as
> well as this a little bit hacky part.
>

Are you sure ?

static_branch_inc() is what we want here, it is a nice wrapper around
the correct internal details,
and ultimately boils to an atomic_inc(). It is safe for all contexts.

But if/when jump labels get refcount_t one day, we will not have to
change TCP stack because
it made some implementation assumptions.
