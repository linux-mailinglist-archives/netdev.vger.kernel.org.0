Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB9F50F0F3
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245147AbiDZGaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiDZGah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:30:37 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A1713D6D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:27:30 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e194so18278627iof.11
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OVE52PWB3epIrsc2bkBW7o6xAdNneO8xjiJH1QFI4cQ=;
        b=f4zTEn0laANyYJ3vf18n7z6Luwf+EZ3dKQYxcgjN+AD7o/srzdj/J0WRwQzPMDjtyY
         Dm75ZEYaXGlvuttkPO2HDjOzXRhFnPjoFK71CDk2Nkutz4zpYCngH/vMD4rr+k5qBEhZ
         drRxofF1raHBtUCfIvYel+xVmqtVFlYibkO9uvKZKOJrMXhlihocPxtmbjtrNkkI4ZFC
         l/zoSKU53jAMrJeAFQVXsVdjdqTevJwh4SltmfpmDVJGq1cRZ3Ef4Ob2mxV1WbqAnGLI
         Fezv8tgcmEql9Jv35NkDn2JQ7ei5JwaONzx9CJyOGowc/LvDI/VMWlsYBznKznvheMOH
         FZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OVE52PWB3epIrsc2bkBW7o6xAdNneO8xjiJH1QFI4cQ=;
        b=T0d4sc26H0EhwM6vN28G0J/sRIqakTBNLTkh4ukmX1rhypZ1fRby3YVWSAt4mrSVM2
         dmMNzGKjpOJomBPFYBDmEwKUAgJr/P2fXJxwV9f9LHf/YA/Bsa0t2iay9BeCGne3PW3m
         EYZr+iHIvf7KOxP9n4IwPCK648T0NuKSRnoddyCwZLvgWpVUt6uzDw9rzu7QPB5Dwt7s
         Ak20fsA4JpCIhMuDHvC4QywsrN1VNJtyfWT5ZocijyFm11S9F/VrD5crz6AJk5VjoCfY
         1eMDOdKtmBWtxbP+hidgcYgdjLQzKDTGH1EcaL+FA+GZfXA//b9XDcpBKh1Zdpw+qSZ0
         9WLw==
X-Gm-Message-State: AOAM531doISWk/bijvvFUS55s6m/k3JuIjcUunaNr+OPNhqwMUCPCvXA
        6vG3FvJZXKxMkuYHHw0u56E=
X-Google-Smtp-Source: ABdhPJx1kR/7rL7AukRz3+XVO9rhqLtQVCbRtQSkaMpY0i5NYP+lCKHi9QBbf/zsHz8ar9z5IKVpDA==
X-Received: by 2002:a5d:81cb:0:b0:653:7cec:64aa with SMTP id t11-20020a5d81cb000000b006537cec64aamr8966218iol.208.1650954450200;
        Mon, 25 Apr 2022 23:27:30 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id s5-20020a0566022bc500b0065490deaf19sm9052772iov.31.2022.04.25.23.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:27:29 -0700 (PDT)
Date:   Mon, 25 Apr 2022 23:27:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <626790c940273_6b2c0208ca@john.notmuch>
In-Reply-To: <CAM_iQpWQwsJ1eWv9X9O5DqJUhH3Cx-gz+CfHXQsyjeqF04bJPQ@mail.gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com>
 <6255da425c4ad_57e1208f9@john.notmuch>
 <CAM_iQpWQwsJ1eWv9X9O5DqJUhH3Cx-gz+CfHXQsyjeqF04bJPQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Tue, Apr 12, 2022 at 1:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> > > a preparation for the next patch which actually introduces
> > > a new sock ops.
> > >
> > > TCP is special here, because it has tcp_read_sock() which is
> > > mainly used by splice(). tcp_read_sock() supports partial read
> > > and arbitrary offset, neither of them is needed for sockmap.
> > >
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> >
> > Thanks for doing this Cong comment/question inline.
> >
> > [...]
> >
> > > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > > +              sk_read_actor_t recv_actor)
> > > +{
> > > +     struct sk_buff *skb;
> > > +     struct tcp_sock *tp = tcp_sk(sk);
> > > +     u32 seq = tp->copied_seq;
> > > +     u32 offset;
> > > +     int copied = 0;
> > > +
> > > +     if (sk->sk_state == TCP_LISTEN)
> > > +             return -ENOTCONN;
> > > +     while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {
> >
> > I'm trying to see why we might have an offset here if we always
> > consume the entire skb. There is a comment in tcp_recv_skb around
> > GRO packets, but not clear how this applies here if it does at all
> > to me yet. Will read a bit more I guess.
> >
> > If the offset can be >0 than we also need to fix the recv_actor to
> > account for the extra offset in the skb. As is the bpf prog might
> > see duplicate data. This is a problem on the stream parser now.
> >
> > Then another fallout is if offset is zero than we could just do
> > a skb_dequeue here and skip the tcp_recv_skb bool flag addition
> > and upate.
> 
> I think it is mainly for splice(), and of course strparser, but none of
> them is touched by my patchset.
> 
> >
> > I'll continue reading after a few other things I need to get
> > sorted this afternoon, but maybe you have the answer on hand.
> >
> 
> Please let me know if you have any other comments.

For now no more comments. If its not used then we can drop the offset
logic in this patch and the code looks much simpler.

> 
> Thanks.


