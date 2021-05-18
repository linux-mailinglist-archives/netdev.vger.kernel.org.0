Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC84A3870F5
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbhEREry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 00:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbhERErw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 00:47:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C89C061573;
        Mon, 17 May 2021 21:46:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so828782pjb.3;
        Mon, 17 May 2021 21:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sQNZf7rDSs5L4UF53pIulq/HEniCHBE6M/99uTQIboA=;
        b=W+dLLwJbPu1kKukzz6V2PruQ4fBijCJisRjCnYytaBZWeTjTQGgYSDBQLyEnMEp1rE
         QOAc1XP1csQ3YF1aNeYzGILI/hkTNeSh4PVZSmzctMKBHp3rslviegz3FLtTB5U64neu
         SF3pXTMGb0+wpThvWsXJWZobcZ0X+PjzPzY+4oE7dxGXjsbPR+H19QagsRdAwERlvh+Z
         FUSOmmH/Sih1EgeUAFhjJ+U2WUj7vlYdKiS4JT2XXxF93dhYjlhPRiBi6NTS7DrzFxBP
         tiQQCz35N0dy1p7/7F1NyM13RRLzpow5MTEYND5TQbBCcWEOftGasPdlkUGyp53zePPo
         +8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sQNZf7rDSs5L4UF53pIulq/HEniCHBE6M/99uTQIboA=;
        b=nXwXRbsEjLBmDpQ6/g7VkwU1axsrZsnJQ+0/s7IPy+Pjk1vpvfqPG71xceo1myQeqa
         TtbXDJki02ErhnSI71c9hB2NvHlZo6+dawHpURxnQt1/Dsa2H8apndy8LL1jtk+HrI/E
         HskrNzjM7zGeqoJ5T5QuMJFecKnhLB/c/Y0+UTI+MoPS9/BwQbAEvXavM0s3mRjRCiDY
         mvbf/fRr3KufyU/feP/Hg5j7877Fh83pCzz3xL2zs3U6zhYw2SThjLQTnw6FhcFfhtxn
         /U3FWd5GBT3BA9rdXJEy5ovrY9mNFnSIbR+ooam7rjILU1TxI0wIMdDpn7aQiabHtgu1
         9r0w==
X-Gm-Message-State: AOAM532p0+DiDzxAatTrOOGsQs6h8EShCpvHT4A1LbOQo8nVh6z3q6FL
        WdCX/dfgI5BhP1d8KQkkxnEA+EFBIiyKRiciCZgu55hy9Byg5pRj
X-Google-Smtp-Source: ABdhPJwwkV6hsSHjbrjD1U7ZoIJkgl2mA8jYx1d3bULUPdJvyxgXmgfa0zADh2x21saxBC1HUkvGXjvLZiQf/NF/9e0=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr3417543pjb.56.1621313194880;
 Mon, 17 May 2021 21:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-3-xiyou.wangcong@gmail.com> <609a1765cf6d7_876892080@john-XPS-13-9370.notmuch>
In-Reply-To: <609a1765cf6d7_876892080@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 May 2021 21:46:24 -0700
Message-ID: <CAM_iQpUawKFmqL-XLMwoBjSTAwj+NLhZ0Su1r-W+6U_fttZp9Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 02/10] af_unix: implement ->read_sock() for sockmap
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 10:34 PM John Fastabend
<john.fastabend@gmail.com> wrote:
> > +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +                       sk_read_actor_t recv_actor)
> > +{
> > +     int copied = 0;
> > +
> > +     while (1) {
> > +             struct unix_sock *u = unix_sk(sk);
> > +             struct sk_buff *skb;
> > +             int used, err;
> > +
> > +             mutex_lock(&u->iolock);
> > +             skb = skb_recv_datagram(sk, 0, 1, &err);
> > +             if (!skb) {
> > +                     mutex_unlock(&u->iolock);
> > +                     return err;
>
> Here we should check copied and break if copied is >0. Sure the caller here
> has desc.count = 1 but its still fairly fragile.

Technically, sockmap does not even care about what we return
here, so I am sure what you suggest here even makes a difference.
Also, desc->count is always 1 and never changes here.

Thanks.
