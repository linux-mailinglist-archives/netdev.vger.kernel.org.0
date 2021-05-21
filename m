Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEF438D20D
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEUXla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 19:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhEUXl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 19:41:29 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE60C061574;
        Fri, 21 May 2021 16:40:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t193so15445473pgb.4;
        Fri, 21 May 2021 16:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9pEshn70i3/F8zDHAvfBp+zto3tjMu5UZEkuuxo6Xk=;
        b=VQTnUuDyMCXEkrsuj5Ae0Itdwk7pNSMzmLJJYTauOBJm4Ir7Bz9ZZO5BdH7+nOfI7f
         uVz7Q1wLOD6z2Ub8HumtMw6rUPv2wQrJXbeJm6BwT7nzlE5Zw+2KQsYcNkRjWiD++rM4
         94j2iM1i0ZuDrrO3/Z5bSnTb3Wdtc8SHIOYdVnR0rntfWjFAGgS/32+gRUO/fumLjyie
         f69rumsVk8EYNERj2nlln+yX53kPwx07R4R2NEqqfHHCI4uKS6IxhZHU2VDj2Z22O6Qp
         KJywySDBVtMI9HbONhCjKd+Wm1Tnma4YD3vdpRbY5G9G4LGq45z6YO4qSf/4oNCMA4g4
         w5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9pEshn70i3/F8zDHAvfBp+zto3tjMu5UZEkuuxo6Xk=;
        b=b6UXWZvpaAa8xVT2WNP5OHwApp7LrtNzjUgd87Kk2nczehQEEht2y6jPmJMs8IET+d
         56URhtdVe21uzD/9QEJ+hSElx8zGIVrY9k93gk2z1V+sQRWWBzAHda52HRHAwd2+J3kJ
         wgUJFvXJ/eGCHDLrL+SS8/i0SG4cKWE78NclayTGLande1LfS9GA3wtfoezuPUPi5uOb
         BSPL6A+3vyDqIJyTQCHSaIauEDh8MPcOfy9Kzf2m05sVQMRe4aruRko9/fejg68SgZHW
         l7KLU6VyBqwxxZdrcOdBME6uonI3saW39AN1AaIpZxOQWhQONFg31nCPWYKLZO0F3xSZ
         5H9A==
X-Gm-Message-State: AOAM530i4h/F9QQQPMrLDe9xbzz5KErjutRf3SpvhL/LmpjKLI2IcS5T
        oGyLIPKEiBXt91xh2yVx91u9ot9sUebKZeajPw3XnxzS6GW52A==
X-Google-Smtp-Source: ABdhPJynhZq53u41wRMGZudNFKL77KkNK0y7NqOCIsN/qdqiGYdx7zVXADDdDbxiVxetlvNV2yt43kk/ZNt4EBd0Cys=
X-Received: by 2002:a63:e709:: with SMTP id b9mr1241070pgi.18.1621640405536;
 Fri, 21 May 2021 16:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch> <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch> <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch> <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
 <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch> <CAM_iQpU5HEB_=+ih7_4FKqdkXJ4eYuw_ej5BTOdRK8wFVa7jig@mail.gmail.com>
 <60a69f9f1610_4ea08208a3@john-XPS-13-9370.notmuch> <CAM_iQpWxJrXhdxyhO6O+h1d9dz=4BBk8i-EYrVG6v8ix_0gCnQ@mail.gmail.com>
 <60a82f9c96de2_1c22f2086e@john-XPS-13-9370.notmuch>
In-Reply-To: <60a82f9c96de2_1c22f2086e@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 21 May 2021 16:39:54 -0700
Message-ID: <CAM_iQpUdSQmpH3rWpDUh_xFGDA1NHLjTBCEhv4qAgYh9wyt-pA@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 3:09 PM John Fastabend <john.fastabend@gmail.com> wrote:
> OK either add the counters in this patch or as a series of two
> patches so we get a complete fix in one series. Without it some
> box out there will randomly drop UDP packets, probably DNS
> packets for extra fun, and we will have no way of knowing other
> than sporadic packet loss. Unless your arguing against having the
> counters or that the counters don't make sense for some reason?

I never object increasing any counter here, My argument is it
belongs to a separate patch for 3 reasons:

1) TCP does not have one either, hence needs to fix together;

2) A patch should fix one bug, not two or more bugs together;

3) It is not the only one place which needs to increase the
counter, all of these kfree_skb()'s need, for example, this one
inside sk_psock_verdict_recv():

        psock = sk_psock(sk);
        if (unlikely(!psock)) {
                len = 0;
                kfree_skb(skb);
                goto out;
        }

This example also shows it is harder to do so, because
sk_psock_verdict_recv() is independent of any protocol, it is
hard to increase a protocol-specific counter there.

(Another one is in sk_psock_verdict_apply().)

>
> > counters either, yet another reason it deserves a separate patch
> > to address both.
>
> TCP case is different if we drop packets in a TCP error case
> thats not a 'lets increment the counters' problem the drop needs
> to be fixed we can't let data fall out of a TCP stream because
> no one will retransmit it. We've learned this the hard way.

I think TCP always increases some counter when dropping
a packet despite of retransmission, for example:

static void tcp_drop(struct sock *sk, struct sk_buff *skb)
{
        sk_drops_add(sk, skb);
        __kfree_skb(skb);
}

Thanks.
