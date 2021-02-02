Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53E430BFCA
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhBBNmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbhBBNkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 08:40:09 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B64C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 05:39:25 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id r12so29995770ejb.9
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 05:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPZeXB7V8Wlr0PYj6GboFKNagNTgs7+rYQZBJK7V/u8=;
        b=AApL59fbAGaGWsVe31tViwwl0xLbqa7Ii8oj/UYP4QeMIp8BNNvHZZeO2wxU19spjc
         HpleKmk0H8nzl0VEvcM2WrwYXLjX9opCZL7pKFxiKicj4ncuQv9x35nOQTnCght65VWX
         kGeTqE2qRjRFc2C1mv8Anguq3TlvoEae58K5rUhqpFtk0Qy+9931kSFEBXv1j1ggfoSU
         5VbIyyAkYmwiq+xvfLtNOvWXR5zDn2SThfHBElJY2ELeBB94hgNLpkseU5Uc4jtQXadC
         fLfKGPyBA2wN7b5kiJgN8YUk/ZuwdOQdohjXgX6OAJQKH0rKckugsC/9dq4EkF7ms+qL
         wZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPZeXB7V8Wlr0PYj6GboFKNagNTgs7+rYQZBJK7V/u8=;
        b=luiJxvJSpURj32nRlkUXYhvOCS7DrkxgMRPKidj4Q+DgsZAESFJTPdpZX4DngDkLG0
         OjTfPNH8gJgrxuTXGmvcXoT3dXzjaaF0BkdUEVAgkN9cCst5zGzPFWESLTISZukpIWfx
         9iEYWOX2QqmAInf9bqtNUtwOnW2EFbT27TNJaVTw8ifuxj9qLBhBoi5/zdFVqpHZLqHn
         SWC+J8wnu5uQcmY5zEQ66nAgTpkYbW3CDdaCS03BbWYigar3hcNWud6kQRUzD12yxNZG
         MbDlrcO41NFkBs+4a9sSLyTsQZPkTvz0lmtQxUscHg1spLsD2Cp43lmzv4W1LbEpq4Qi
         RFFQ==
X-Gm-Message-State: AOAM532efeMwQaeU+K8vkT6vhsDwZ6lWnfSezrQFvlMmD68LwqFetbzP
        GPmZscRwqxLPj74ArPiSCMQaxz9+8VnTAQQRkRI=
X-Google-Smtp-Source: ABdhPJznwh9L4i5uF2VqpcAaQfKk4ks6NVOZrXPcQz8PF6LHD4/oFn3Rb/cMonsaDRs+G51TgfXSMw0z5boZIVWnUPI=
X-Received: by 2002:a17:906:82c9:: with SMTP id a9mr11784960ejy.547.1612273164707;
 Tue, 02 Feb 2021 05:39:24 -0800 (PST)
MIME-Version: 1.0
References: <CADxym3ba8R6fN3O5zLAw-e7q0gjFxBd_WUKjq0hTP+JpAbJEKg@mail.gmail.com>
 <20210201200733.4309ef71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <a24db624cb6b2df98e95b18bbcd55eca53c116ae.camel@redhat.com>
In-Reply-To: <a24db624cb6b2df98e95b18bbcd55eca53c116ae.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 2 Feb 2021 21:39:13 +0800
Message-ID: <CADxym3ZGdANUQmUTJ=_9YWs66JjjaYAwwn3eX8=f7hJ5tyKF=Q@mail.gmail.com>
Subject: Re: make sendmsg/recvmsg process multiple messages at once
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 6:18 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-02-01 at 20:07 -0800, Jakub Kicinski wrote:
>
[...]
>
> https://marc.info/?l=linux-netdev&m=148010858826712&w=2
>
> perf tests in lab with recvmmsg/sendmmsg could be great, but
> performance with real workload much less. You could try fine-tuning the
> bulk size (mmsg nr) for your workload and H/W. Likely a burst size
> above 8 is a no go.
>
> For the TX path there is already a better option - for some specific
> workload - using UDP_SEGMENT.
>
> In the RX path, for bulk transfer, you could try enabling UDP_GRO.
>
> As far as I can see, the idea you are proposing will be quite
> alike recvmmsg(), with the possible additional benefit of bulk dequeue
> from the UDP receive queue. Note that this latter optimization, since
> commmit 2276f58ac5890, will give very little perfomance gain.
>
> In the TX path there is no lock at all for the uncorking case, so the
> performance gain should come only from the bulk syscall.
>
> You will probably also need to cope with cmsg and msgname, so overall I
> don't see much differences from recvmmsg()/sendmmsg(), did I misread
> something?
>
> Thanks!
>
> Paolo
>

Wow, thanks for your professional explanation. In fact, "recvmmsg/sendmmsg"
is exactly what I want. (Haha... I didn't know their exists before, so
embarrassing ~)

By the way, I think my idea do have some benefit(maybe). For example, it
doesn't need to call __sys_recvmsg() for every skb, which avoids unnecessary
path. And it doesn't need to prepare msghdr for every skb, which is possible
to reduce memory copy between kernel and user space. As for msgname,
we can dequeue skbs that have the same source until we meet a different one,
in one cycle.

However, in view of the exist of "recvmmsg/sendmmsg", my idea seems
unnecessary~~~

Thanks~
Menglong Dong
