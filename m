Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAC5323038
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhBWSFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhBWSFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:05:41 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC5BC06174A;
        Tue, 23 Feb 2021 10:05:01 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id b145so9294461pfb.4;
        Tue, 23 Feb 2021 10:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jni0I5KUbpyJPp5sKbF1W67l095+0KeZYaoZazXEhV4=;
        b=hTZ4Xy2nsFNSCYpykQtkOt9Rp89Om4gV0KBAKmg4DIf41TQ9a9Q7cPIFkPqNhnjxg8
         IypeZWgNUe60zD1tUKCCICCskPn/GKoi7eT1bYy+bLlgv/cmFL4HzDb8zdkgz7M0Kr7S
         A4grYPzqyc1K6y+xqExGCz7Q+4voF3QdAAoNrxtofzWiToTG8t4Tf0RZxsadw2zRFaVb
         JmIFl9hTUJumdiwC6KL/lOltYnapXA2VWhICpR9UIjwiG2motPIPxflfgJn22VrAredh
         sS5L4sCAsG+inVm7SGzSVpnNrhpIOMOHVMpm6KiVqzEzkGEqJ/5qm0gIoPMGx6idLRB7
         I2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jni0I5KUbpyJPp5sKbF1W67l095+0KeZYaoZazXEhV4=;
        b=fV7XyTtC3PVJnGYKJ02AA5YAh6nWFYlYSn7kpY3ev6ymphdNqWB7EcWYxmhQIt62fV
         31EzhDVxzcSeKcG6zitPB6LDYvX11KLetqMtk1ViyrXWe3jU1nbVgyXIHi2sMu2YEOgp
         y1Dz1nhFKt7HTgYEn2kPMRmGw8LGZb732TIyhEdClIojOPch6/VWKaImw1LWPGlJyfpn
         R/xTsv8A2bBX4NGWhQqugIcwpRmCWmbbJWU8Ysj5C3NUmAmbWmvBdXqeJewXBGeuDLuU
         QRuLr8NA4aR0SjKTD+Oz/gEMdDa0EAQJU8PfjiKt2fDx9G7q7+jWhA2tqr42DS0ob0y7
         jevA==
X-Gm-Message-State: AOAM532JJQjriKt6HqHcb8/S6BFZAH1iDy77NxMxSXffVOiKgIi3QUw4
        HR4NjuvcllD5J1VOzV59Idtmd4IqxaTMyPDX9AKkOHpG1000+Q==
X-Google-Smtp-Source: ABdhPJxXd9NJDiokQk7GKHeD5De85lt6jb76OZtoqTFnBpbkSX2/4U6FohDe+STKtR5gizibshG8cJrfXFzYp+DvgE8=
X-Received: by 2002:a65:4584:: with SMTP id o4mr3519705pgq.266.1614103500899;
 Tue, 23 Feb 2021 10:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-5-xiyou.wangcong@gmail.com> <87eeh847ko.fsf@cloudflare.com>
 <CAM_iQpVS_sJy=sM31pHZVi6njZEAa7Hv_Bkt2sB7JcAjFw3guw@mail.gmail.com> <875z2i4qo5.fsf@cloudflare.com>
In-Reply-To: <875z2i4qo5.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 23 Feb 2021 10:04:49 -0800
Message-ID: <CAM_iQpWofNM=erfyP8b_qrezJN6d51UDW5bfgo2LHkPOTXqm8Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 4/8] skmsg: move sk_redir from TCP_SKB_CB to skb
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 9:53 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> Based on what I've seen around, mask for sanitizing tagged pointers is
> usually derived from the flag(s). For instance:
>
> #define SKB_DST_NOREF   1UL
> #define SKB_DST_PTRMASK ~(SKB_DST_NOREF)
>
> #define SK_USER_DATA_NOCOPY     1UL
> #define SK_USER_DATA_BPF        2UL     /* Managed by BPF */
> #define SK_USER_DATA_PTRMASK    ~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
>
> Using ~(BPF_F_INGRESS) expression would be like substituting mask
> definition.

Yes, that is why I said we need a mask.

>
> Alternatively we could clear _skb_refdest after clone, but before
> enqueuing the skb in ingress_skb. And only for when we're redirecting.
>
> I believe that would be in sk_psock_skb_redirect, right before skb_queue_tail.

Hmm? We definitely cannot clear skb->_sk_redir there, as it is used after
enqueued in ingress_skb, that is in sk_psock_backlog().

Thanks.
