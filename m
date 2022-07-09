Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F413E56C81E
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 10:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiGIIhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 04:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiGIIhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 04:37:05 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842B767C84;
        Sat,  9 Jul 2022 01:37:04 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id i190so790434pge.7;
        Sat, 09 Jul 2022 01:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1d0xQDbiqOm4xHoNeGRYZWlXM5lvmpFGoowlPoRlBA=;
        b=DB2/3U2eialrjaOb0mFGoJCvEh30k7ZpSf0bS/bJRkpOecubVOPJ9q6Gmo+aZMgLsm
         7MMReC546VXEc7FLVxwcl7zJjaS5Q2ATFqbOKtXxs9nb8/eSKBwXANFMW0YM2DEpRLqh
         /npF9+9k4u78BKkvKmOKi6V5adNoEzmpV3ET3G/uLrWjvqOuao8Dp8mhj8jKRINK0ncd
         pwHB2rJgO7ekyIkhJUyH0JO1inoVG1JjvH/pIunUKQoZTvCltyJMPVjp3X4ttWyq88kc
         ia+UudsmvyU210rVKaeAorx4+wfQ3CxdfqYbgnYFVMN/6+3ijbsn4bVKMJ9y9e/lXoIc
         GQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1d0xQDbiqOm4xHoNeGRYZWlXM5lvmpFGoowlPoRlBA=;
        b=Sr0T8udRdepdq4r7NDirgNrMcEdUyv6PH88yWowrOKKqSAIl6SFKu8q9gzqO+JK+7X
         G1AhZY4D3TC2tBMUNuyvoD00FuGJ0ZaAXgFZSW3sW8USSoDhjZiqJVmckFqnJ7hLHTMA
         qV5oXfPuo1Pgy+KWb+kRdXsKP0mbOJSBH2n0dI+S/9EvtvDK/MU030GtOYfjDNQNa1Ul
         Ek90r2OIW09Pcq98Q1RICTUIAD8caFArVX1kJzfpqcut0eFpVRN8PNAMbsbxquBRHVb3
         kK2veYzwzDFG8uAYnJ8l74Hj5NxYn0xvXdMeWRfR5Og1WO9S3I78OkrTMb+0Nki/7WIt
         PCBQ==
X-Gm-Message-State: AJIora+uG6blDYrnSvA9MBCMDO/tA5e77wMvhBINuRXGXtRE9HyUNHWv
        k7U5n+VwCqkaS8fBCTSQnQk=
X-Google-Smtp-Source: AGRyM1sYkaJbnS/KJOVYg78AEzQOMDdoEzoud2ZtojUlPutt7DIF/hUo0iBBBgpH2Z28qeRz/4MR0g==
X-Received: by 2002:a05:6a00:84d:b0:525:3ce6:9c33 with SMTP id q13-20020a056a00084d00b005253ce69c33mr7777463pfk.47.1657355823800;
        Sat, 09 Jul 2022 01:37:03 -0700 (PDT)
Received: from ubuntu.lan (pcd364232.netvigator.com. [203.218.154.232])
        by smtp.gmail.com with ESMTPSA id t10-20020a65554a000000b004126f1e48f4sm685439pgr.20.2022.07.09.01.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 01:37:03 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        guwen@linux.alibaba.com, john.fastabend@gmail.com, kafai@fb.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Date:   Sat,  9 Jul 2022 16:36:42 +0800
Message-Id: <20220709083641.2060-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708200602.1059bc09@kernel.org>
References: <20220708200602.1059bc09@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Jul 2022 at 11:06, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat,  9 Jul 2022 10:46:59 +0800 Hawkins Jiawei wrote:
> > Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
> > Signed-off-by: hawk <18801353760@163.com>
> > ---
> >  net/ipv4/tcp.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 9984d23a7f3e..a1e6cab2c748 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -3395,10 +3395,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
> >       }
> >       case TCP_ULP: {
> >               char name[TCP_ULP_NAME_MAX];
> > +             struct sock *smc_sock;
> >
> >               if (optlen < 1)
> >                       return -EINVAL;
> >
> > +             /* SMC sk_user_data may be treated as psock,
> > +              * which triggers a refcnt warning.
> > +              */
> > +             rcu_read_lock();
> > +             smc_sock = rcu_dereference_sk_user_data(sk);
> > +             if (level == SOL_TCP && smc_sock &&
> > +                 smc_sock->__sk_common.skc_family == AF_SMC) {
>
> This should prolly be under the socket lock?
>
> Can we add a bit to SK_USER_DATA_PTRMASK and have ULP-compatible
> users (sockmap) opt into ULP cooperation? Modifying TCP is backwards,
> layer-wise.

Thanks for your suggestion, I also agree that modifying TCP directly
is not wise.

I am sorry that I can't follow you on haveing ULP-compatible
users (sockmap) opt into ULP cooperation, yet adding a bit to
SK_USER_DATA_PTRMASK seems like a good way.

I plan to add a mask bit, and check it during sk_psock_get(),
in v2 patch

>
> > +                     rcu_read_unlock();
> > +                     return -EOPNOTSUPP;
> > +             }
> > +             rcu_read_unlock();
> > +
