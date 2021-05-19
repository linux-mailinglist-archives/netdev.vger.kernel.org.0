Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12E538962A
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhESTIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhESTH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:07:59 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC0CC06175F;
        Wed, 19 May 2021 12:06:38 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k4so9451627ili.4;
        Wed, 19 May 2021 12:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=u+JB5CzqqD0vgr92eEb0p1bRL3UPNgHtHbJI4HxoI1Y=;
        b=BOGD6udYKthVDYYZHuXrJxnmYI9E88BG9eqZELr4y88knJ7HMI6CeiEnbAsapk90ro
         qKxh86I7eBBN77NhDFK1HHe3lK+9PQMN7yxrt08PK6skbSndQ8VtwOtqMz64ISt1IOn4
         puZ5p3jLnLqSwS2wSxqyg+sl8cMYBlRoTqtT31319VPLdrD8idPyOnXdlBtQK4Db2i9w
         hJbwZZpmIZJZBJDKrUfudww19/rlsFgY63W4OjvtTdtkozWwd2Bw2xF+LP9y8j+I2Qo0
         UQuW3WbWNEyB9IvGI5tmxbszE9RMZigak41RBaj5u38bnJmcMLGGVeerpcvGeZTF8pSD
         rnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=u+JB5CzqqD0vgr92eEb0p1bRL3UPNgHtHbJI4HxoI1Y=;
        b=l/PxxPas684lYycpA0Se8TRQPkl1isb5ViuWkzXrXT6rU/FDOd6jplc7D70BPwGly0
         SHclNbsc1U8z4IIUo8V9q2nva+PJ8da4q4oyPm+akWw895mAdqv2aOdPf8Jdv0HTpn9A
         0f0ut9voNspPYsBfdmZUVdRcWqEdAaOoe7hQ7rQtSI/ddFEBl9EVY6/v9ssEM1HLplYk
         +ABAEOswnDcELPv7G6H+QkDEzyf7HLCwxfh3B1wQTtOEtmXbnpM4bZ3uDatnCeFOYDO8
         Sc9/LDJ0NBwO2zF9IJkcfZL24vWw137AxkCBjbjrDwQIjqbG4Mhj24JTgvv9Yvb5yLv5
         9+XA==
X-Gm-Message-State: AOAM530DBbYsf1JDhy0BqG0JR/5HzV015Gn7VrfL17uoBmwipYuKKMfD
        2igK18ESBiXJfKoNe5Cty8E=
X-Google-Smtp-Source: ABdhPJywjpccI22JoICo0sFH3589ujRP6p6xWR0dNbE+Q8nvlqSe4fGxrDP4QeAKtbjm8saIw+fLlQ==
X-Received: by 2002:a05:6e02:156d:: with SMTP id k13mr522555ilu.149.1621451197429;
        Wed, 19 May 2021 12:06:37 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id q19sm351274ilc.70.2021.05.19.12.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 12:06:36 -0700 (PDT)
Date:   Wed, 19 May 2021 12:06:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
 <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
 <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Tue, May 18, 2021 at 12:56 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Cong Wang wrote:
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > > afterward, so udp_read_sock() should free the original skb after
> > > > > done using it.
> > > >
> > > > The clone only happens if sk_psock_verdict_recv() returns >0.
> > >
> > > Sure, in case of error, no one uses the original skb either,
> > > so still need to free it.
> >
> > But the data is going to be dropped then. I'm questioning if this
> > is the best we can do or not. Its simplest sure, but could we
> > do a bit more work and peek those skbs or requeue them? Otherwise
> > if you cross memory limits for a bit your likely to drop these
> > unnecessarily.
> 
> What are the benefits of not dropping it? When sockmap takes
> over sk->sk_data_ready() it should have total control over the skb's
> in the receive queue. Otherwise user-space recvmsg() would race
> with sockmap when they try to read the first skb at the same time,
> therefore potentially user-space could get duplicated data (one via
> recvmsg(), one via sockmap). I don't see any benefits but races here.

The benefit of _not_ dropping it is the packet gets to the receiver
side. We've spent a bit of effort to get a packet across the network,
received on the stack, and then we drop it at the last point is not
so friendly.

About races is the socket is locked by the caller here? Or is this
not the case for UDP.

Its OK in the end to say "its UDP and lossy" but ideally we don't
make things worse by adding sockmap into the stack. We had these
problems already on TCP side, where they are much more severe
because sender believes retransmits will happen, and fixed them
by now. It would be nice if UDP side also didn't introduce
drops.

> 
> Thanks.


