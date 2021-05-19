Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209953897B6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhESUTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhESUTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 16:19:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EBCC06175F;
        Wed, 19 May 2021 13:17:59 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i6so2869140plt.4;
        Wed, 19 May 2021 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5zIcIhUmQl8zDk/tvSIthaU5QXdETbXtspPUnjre1bE=;
        b=O0okUgGoKbuvklJDEpycQIH6C//iicWXBBCVYE45ZcTA0+TOQf0Byn9UBEtwLwf/4/
         +OtHZhPY6azLTer2Zq4OR1lHk2vIqen2b6YZ9W2tpvTCUCYXFD6aT6/f2x46gO7Wbo62
         YoPOYDr3P+ooe3oStgBkYGmwm7jCTWy/ME1cuxQ0SxGvBM2yKobha8VaH36qPjxZFY2c
         Bq1Fwkbz5iz1d1e1Kr/wR5Nitqqe+sIFvW1yZob3OCih09k3bqN/34BPpHwynOMDPcwa
         MtC854TrymxxxV5vinZ1EDWPY25YyvpiEyqLkKEdMvKdPSopzf10CRIT8w+T9noJjofX
         pAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5zIcIhUmQl8zDk/tvSIthaU5QXdETbXtspPUnjre1bE=;
        b=k2iBtM5VOzFIxwvtvvl00X0tB4k+M1am8pIWiumyh9fa1GLMRsV4VVu1Z65C3W8iE9
         sZRRmM7ja6G/o9N6RYiUoSE8Bq9apbmh1ZJbS74bZHJ/I+ryZt+zNOpCGZ4k9PjmvCcX
         tm7oSb3XiiN+vmB0Q99OUNlMnMcRMjXNUEZqs0AHmD5re8cWQ3ODhgf2mq10omkST5VX
         ucjqVvoPWdNqz2/LwaSRhKXGLSdqqytjA0wcluaF5XX9iNL0O+HxcOVQUdmEs+46tRAs
         IFnYaHWsPHQ/own9ICuc0CxgSsi2fxI4CRfFg9qp7nwpulGhrbeB3BxtJZKof5PwtR6G
         ouGg==
X-Gm-Message-State: AOAM533MsJCyXSDnFZv69l1SdvYJSwvBvsjvrIvfEIhzz3kKaVGJCRyQ
        CG9D4nTIOs6Ns7D/P2yPxz2UV+XGb/w1YDNCgiqxfVm9guKhOg==
X-Google-Smtp-Source: ABdhPJywBMAie+Fb7gtvec2FysvIeEwYrk267qtzZjrgEE7dwWNj0pYg6eYUOrNVWGJDfWrhmlrZ3beNg+5vRjR2vvI=
X-Received: by 2002:a17:902:c784:b029:ef:b14e:2b0b with SMTP id
 w4-20020a170902c784b02900efb14e2b0bmr1523748pla.64.1621455479040; Wed, 19 May
 2021 13:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch> <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch> <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch>
In-Reply-To: <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 19 May 2021 13:17:47 -0700
Message-ID: <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
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

On Wed, May 19, 2021 at 12:06 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Tue, May 18, 2021 at 12:56 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > > <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Cong Wang wrote:
> > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > >
> > > > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > > > afterward, so udp_read_sock() should free the original skb after
> > > > > > done using it.
> > > > >
> > > > > The clone only happens if sk_psock_verdict_recv() returns >0.
> > > >
> > > > Sure, in case of error, no one uses the original skb either,
> > > > so still need to free it.
> > >
> > > But the data is going to be dropped then. I'm questioning if this
> > > is the best we can do or not. Its simplest sure, but could we
> > > do a bit more work and peek those skbs or requeue them? Otherwise
> > > if you cross memory limits for a bit your likely to drop these
> > > unnecessarily.
> >
> > What are the benefits of not dropping it? When sockmap takes
> > over sk->sk_data_ready() it should have total control over the skb's
> > in the receive queue. Otherwise user-space recvmsg() would race
> > with sockmap when they try to read the first skb at the same time,
> > therefore potentially user-space could get duplicated data (one via
> > recvmsg(), one via sockmap). I don't see any benefits but races here.
>
> The benefit of _not_ dropping it is the packet gets to the receiver
> side. We've spent a bit of effort to get a packet across the network,
> received on the stack, and then we drop it at the last point is not
> so friendly.

Well, at least udp_recvmsg() could drop packets too in various
scenarios, for example, a copy error. So, I do not think sockmap
is special.

>
> About races is the socket is locked by the caller here? Or is this
> not the case for UDP.

Unlike TCP, the sock is not locked during BH for UDP receive path.
Locking it is not the answer here, because 1) we certainly do not want
to slow down UDP fast path; 2) UDP lacks sk->sk_backlog_rcv().

>
> Its OK in the end to say "its UDP and lossy" but ideally we don't
> make things worse by adding sockmap into the stack. We had these
> problems already on TCP side, where they are much more severe
> because sender believes retransmits will happen, and fixed them
> by now. It would be nice if UDP side also didn't introduce
> drops.

Like I said, the normal UDP receive path drops packets too,
sockmap is not different here. TCP does peek packets, for two
reasons: 1) it has to support splice(); 2) it has locked the socket
during BH receive. UDP has none of them, so UDP can't peek
packets here.

Thanks.
