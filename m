Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6994058965F
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 05:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbiHDDHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 23:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHDDHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 23:07:18 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB3457267;
        Wed,  3 Aug 2022 20:07:16 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s206so16788362pgs.3;
        Wed, 03 Aug 2022 20:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=OatUP4rKx+f2k6sv6SpcwdsysXb7D++KfTGUd92YzvM=;
        b=gmV7O6gvZgtLqZhBEeoWOXh3PB0+zkVmCCT6nsoqdCJf7Prj4hL/yp9jgKI/YAtPzw
         IzG80HVr9P1EtIrKRJ90QQe9HYwsFmZR+MViKbNdgeWe6f/pO/z1RpuLsOBSLwMefYg1
         +4KAYtJKqfONpkkVzVaPMDzgL7eEK2O8qWnbATOxscjKWNHXpetfpYiFxyRsXlLjdeAz
         Ay1N/69TZJW6RKcAfuenKTGxwk0KoJdctjTtXfgIouDDZ+90hkbyzOaf859pHHvRmLv4
         mPbE8Rf6sXt2KNYG+fnlxR6qnadVD3CuA9tMhGyKSYCfRpZNg4bXGe7tcykGv2sFtRr6
         GM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=OatUP4rKx+f2k6sv6SpcwdsysXb7D++KfTGUd92YzvM=;
        b=xYEJu90V1teFbDaMhNEVgRAHZX0g0fJt7G4ToD/C063gdQvdzwtEVGl3JfZqjuXQVN
         xpgdEqb+v27M1vDbVmeef+OmXk0u5dfMgsBPrBQIXMr2Ma67uWcdyxEeLI2/16pT7ypf
         kKkA+95exmgpCdaaiZ1RUmatW4Edi4rkrGaS/Ao6qTFPpxrGz5NUUGJq0GPmiw7Akxc1
         WTc2N7qDvXlH8s/+siDDz0Rd7mYgCcfcJ17tU7/uNppd6RxqcOCV0YQTdr7SQoFlKCFT
         A7IhCLxZDxxu3AzSDlyj7itYOhTmJhyOlIMS02gu7/o7NCtPkYqAjTtAyjI74QMIhbPI
         LDZQ==
X-Gm-Message-State: ACgBeo13jPsGVU/yBy8sxc7sOpcgylbzlbfj6LpiYP+T9czxmJjJIsxI
        eTJ5mUSeM5pLTKDmhFKigp4=
X-Google-Smtp-Source: AA6agR5OYfmxlNz5L/Fh+E6App0P7yGi5uWLpFGu2JrMbeuktY9eOdlQ4FrBj/LVcfxdM/2a0+JXog==
X-Received: by 2002:a65:6d97:0:b0:41c:1e06:3ba4 with SMTP id bc23-20020a656d97000000b0041c1e063ba4mr13729414pgb.282.1659582435835;
        Wed, 03 Aug 2022 20:07:15 -0700 (PDT)
Received: from localhost ([223.104.103.89])
        by smtp.gmail.com with ESMTPSA id w9-20020a628209000000b0052e594064a8sm863246pfd.220.2022.08.03.20.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 20:07:15 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kafai@fb.com
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, guwen@linux.alibaba.com,
        jakub@cloudflare.com, john.fastabend@gmail.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com
Subject: Re: [PATCH v4] net: fix refcount bug in sk_psock_get (2)
Date:   Thu,  4 Aug 2022 11:05:15 +0800
Message-Id: <20220804030514.7118-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803153706.oo47lv3kvkpb7yem@kafai-mbp.dhcp.thefacebook.com>
References: <20220803153706.oo47lv3kvkpb7yem@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 at 23:37, Martin KaFai Lau <kafai@fb.com> wrote:
> > > + * SK_USER_DATA_BPF    - Managed by BPF
> >
> > I'd use this opportunity to add more info here, BPF is too general.
> > Maybe "Pointer is used by a BPF reuseport array"? Martin, WDYT?
> SGTM.  Thanks.
OK. It seems that this flag is introduced from
c9a368f1c0fb ("bpf: net: Avoid incorrect bpf_sk_reuseport_detach call").
I will search for more detailed description in this commit.

> >
> > > +/**
> > > + * rcu_dereference_sk_user_data_psock - return psock if sk_user_data
> > > + * points to the psock type(SK_USER_DATA_PSOCK flag is set), otherwise
> > > + * return NULL
> > > + *
> > > + * @sk: socket
> > > + */
> > > +static inline
> > > +struct sk_psock *rcu_dereference_sk_user_data_psock(const struct sock *sk)
> >
> > nit: the return type more commonly goes on the same line as "static
> > inline"
Ok. I will correct it.

> >
> > > +{
> > > +     uintptr_t __tmp = (uintptr_t)rcu_dereference(__sk_user_data((sk)));
> > > +
> > > +     if (__tmp & SK_USER_DATA_PSOCK)
> > > +             return (struct sk_psock *)(__tmp & SK_USER_DATA_PTRMASK);
> > > +
> > > +     return NULL;
> > > +}
> >
> > As a follow up we can probably generalize this into
> >  __rcu_dereference_sk_user_data_cond(sk, bit)
> >
> > and make the psock just call that:
> >
> > static inline struct sk_psock *
> > rcu_dereference_sk_user_data_psock(const struct sock *sk)
> > {
> >         return __rcu_dereference_sk_user_data_cond(sk, SK_USER_DATA_PSOCK);
> > }
Yes. I will refactor it in this way.

> >
> > diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> > index e2618fb5870e..ad5c447a690c 100644
> > --- a/kernel/bpf/reuseport_array.c
> > +++ b/kernel/bpf/reuseport_array.c
> > @@ -21,14 +21,11 @@ static struct reuseport_array *reuseport_array(struct bpf_map *map)
> >  /* The caller must hold the reuseport_lock */
> >  void bpf_sk_reuseport_detach(struct sock *sk)
> >  {
> > -       uintptr_t sk_user_data;
> > +       struct sock __rcu **socks;
> >
> >         write_lock_bh(&sk->sk_callback_lock);
> > -       sk_user_data = (uintptr_t)sk->sk_user_data;
> > -       if (sk_user_data & SK_USER_DATA_BPF) {
> > -               struct sock __rcu **socks;
> > -
> > -               socks = (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
> > +       socks = __rcu_dereference_sk_user_data_cond(sk, SK_USER_DATA_BPF);
> > +       if (socks) {
> >                 WRITE_ONCE(sk->sk_user_data, NULL);
> >                 /*
> >                  * Do not move this NULL assignment outside of
> >
> >
> > But that must be a separate patch, not part of this fix.
I wonder if it is proper to gather these together in a patchset, for
they are all about flags in sk_user_data, maybe:

[PATCH v5 0/2] net: enhancement to flags in sk_user_data field
	- introduce the patchset

[PATCH v5 1/2] net: clean up code for flags in sk_user_data field
	- refactor the things in include/linux/skmsg.h and
include/net/sock.h
	- refactor the flags's usage by other code, such as
net/core/skmsg.c and kernel/bpf/reuseport_array.c

[PATCH v5 2/2] net: fix refcount bug in sk_psock_get (2)
	- add SK_USER_DATA_PSOCK flag in sk_user_data field
