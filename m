Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9F355DA3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbhDFVIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhDFVIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:08:14 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6182C06174A;
        Tue,  6 Apr 2021 14:08:05 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id 6so4710875ilt.9;
        Tue, 06 Apr 2021 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xxIJkbvz2ORzIHZBYWPlcoyRH9ByZNBxfwlcDMmobcs=;
        b=Ra6mCwmqi7gIxrDUvEZwd9SMVCRkjPK5Q1D2Ro2K9+DoRmxtFWI/1rSpPgx5OLKbA9
         7RM/pxy2r9UN1kFgGVZT5+j0KaX035y+VXb6RizEANx6eAR17htA+a8Da0MZ+oQ5XuM3
         GO5CbHSa1gf/Eg7VrWYJBFSQCH1IxMQcKvifTyBND+zZTZbEh0NTLbEnK+YG/IHLSDDg
         hk/lsIa2B9ounBTJ6FKhjbSQJKqUa7D3pkARJl2swCppuFycafVcxZPVODyzTryiim6S
         O24yjDWhJjRbnzE2wjGBDFK2gi2F2aWtwfs7fc1ee0eVPzzYHsU3/zzPnEXqB/4/ge76
         mwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xxIJkbvz2ORzIHZBYWPlcoyRH9ByZNBxfwlcDMmobcs=;
        b=BaxElYc2RMoCMhCoDfs0jqSaaNN+DsCUWs1mETU+cJkOeuvJGJ1/JGk5DCFGt6Itkt
         TOfPgk98ux60LFiOm/ksq0lmxVvBFU/hPCCk77qOI4Ay9cwz3hEGwDbjWkgnTniqFymm
         CadyTnEH4/0yOp7cGwKjPK67hOfbu287Hx5YX8DAo4P9e0N/ZfRpZD58qmvmF/PaKIFl
         j9zDwd35b8I2nIpokyPBE/o7xPkufsoZTdqe+X0si3B2RTbOtZJLvRXr577kU5NNg80S
         3v265yNiuRJ5Ybge1eDqSPSPE04zC5AKB9CfPDR3o5EMXt552cPWQ8PdxYYe/o8+v93c
         Vq7Q==
X-Gm-Message-State: AOAM5337QMT1brTyB3lptjeBVHJtDzJJnFpfG6w9loHO4nvVn4C2JPPK
        MSSIsBwqPdDwqNP8tdgT6PA=
X-Google-Smtp-Source: ABdhPJyhEtc1S4vbxNTCZrOBwr9QChm8pVQXtJeFqu6rOHLclNv7U4r9ATOw5/V9/JlXwcb+iAZcTQ==
X-Received: by 2002:a05:6e02:1303:: with SMTP id g3mr192342ilr.262.1617743285094;
        Tue, 06 Apr 2021 14:08:05 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id w16sm14131142iod.51.2021.04.06.14.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:08:04 -0700 (PDT)
Date:   Tue, 06 Apr 2021 14:07:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <606ccdacdbbf6_22ba52087f@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpVd8s0yqMLOR2B5uBxKFzWWZYoZ20WAN2MjcVEiiHX++A@mail.gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-11-xiyou.wangcong@gmail.com>
 <1aeb42b4-c0fe-4a25-bd73-00bc7b7de285@gmail.com>
 <CAM_iQpVd8s0yqMLOR2B5uBxKFzWWZYoZ20WAN2MjcVEiiHX++A@mail.gmail.com>
Subject: Re: [Patch bpf-next v8 10/16] sock: introduce
 sk->sk_prot->psock_update_sk_prot()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Apr 5, 2021 at 1:25 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 3/31/21 4:32 AM, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Currently sockmap calls into each protocol to update the struct
> > > proto and replace it. This certainly won't work when the protocol
> > > is implemented as a module, for example, AF_UNIX.
> > >
> > > Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
> > > protocol can implement its own way to replace the struct proto.
> > > This also helps get rid of symbol dependencies on CONFIG_INET.
> >
> > [...]
> >
> >
> > >
> > > -struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> > > +int tcp_bpf_update_proto(struct sock *sk, bool restore)
> > >  {
> > > +     struct sk_psock *psock = sk_psock(sk);
> >
> > I do not think RCU is held here ?
> >
> > sk_psock() is using rcu_dereference_sk_user_data()
> 
> Right, I just saw the syzbot report. But here we already have
> the writer lock of sk_callback_lock, hence RCU read lock here
> makes no sense to me. Probably we just have to tell RCU we
> already have sk_callback_lock.
> 
> Thanks.

I think you need to ensure its the psock we originally grabbed as
well. Otherwise how do we ensure the psock is not swapped from
another thread?
