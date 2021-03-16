Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA033CB9B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhCPCtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhCPCsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:48:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758B9C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:48:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mm21so69617849ejb.12
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6YHRJMUQAt5BQU/ChG4TfRRnQRInjJDMBnIovWqAbr8=;
        b=g5Bi3z8hLHYwdFuTjylEbiJvq0TJiQ+1F2Shv+P8OkxeXV+gLFKTUHQTGjvsshlopQ
         zPKAgfc7edZwDm2MtCZdnGxNHIyFkmmI01KWJ3Xu/qHn26GD8daYprhLK/hUwVY4t88V
         JqSPXeRxNQB5eNHGmZ6iNEdYmss8LI27jiGVoAINvjC8FBFjtccoEsXmQxEyU7P4AmOf
         /kGDD16HcAjKfuvNHjPx5z1nRyIHsnXGG2SwITzAYqS7GJUKjaLpnXRiWn8tWm9NCUUE
         O5PK/2k9vHHi9Ltw7fJ3LPRWafBb5NW55+WWLRwS8uirBQjQ09kztUliq/R47hkDeYv4
         4MRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6YHRJMUQAt5BQU/ChG4TfRRnQRInjJDMBnIovWqAbr8=;
        b=Td4iU1JYxnCegKl59q1ts24g2xMaHNGVWc2RGlxaasiDJ1VkHvOp/hfkvMwK9cuNDG
         TvpqyOSnS7GEqKzmz7x4MtEIZ9staG7KiEgtz0edzMxDFSuW4NH0UGfP/L/22J44xBU5
         IupuOZ8Z+Ib6G6Wxz6p/96vLIKb6R/WZsbukAbg/xkB8MK2iRpw6+Ljp/YdrX8W2/PiN
         iIaKvVI0G514Jm3UvjUeoshp3DCcHwfnNHp15bIWbW0hsM4yzZaOEdm4lVEDtk09rjtC
         LUUmJVUNt1019GJwZJZfam9YnkxjskfZhzIzWBqT6hfgqKfUJ+cQaSmIueY4R+F7BgdJ
         7Abw==
X-Gm-Message-State: AOAM5323bsCIWgw2Y05fMBvFJP+DoXnmphZEiVPKlwapfMSzKaX4nEFX
        zZoic/WHiVa7AG6/Fe46p9ft1J86Ajq93IYljFKA
X-Google-Smtp-Source: ABdhPJy0ICdduYRDHSmiF4haaSwq3bkzggSvGMl6zEhufrsHVi06l5MZQv1rzb9mRhh63kXlEFazRulaAIfKxc2r6kI=
X-Received: by 2002:a17:906:311a:: with SMTP id 26mr26907944ejx.395.1615862905272;
 Mon, 15 Mar 2021 19:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-2-xieyongji@bytedance.com>
 <20210315090822.GA4166677@infradead.org> <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
 <20210315144444.bgtllddee7s55lfx@gmail.com>
In-Reply-To: <20210315144444.bgtllddee7s55lfx@gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 16 Mar 2021 10:48:14 +0800
Message-ID: <CACycT3tX74QtzBoZ9UHWbdbvaUBruGyjyrOPmiWEwff5rJ7Bjg@mail.gmail.com>
Subject: Re: Re: [PATCH v5 01/11] file: Export __receive_fd() to modules
To:     Christian Brauner <christian.brauner@canonical.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:44 PM Christian Brauner
<christian.brauner@canonical.com> wrote:
>
> On Mon, Mar 15, 2021 at 05:46:43PM +0800, Yongji Xie wrote:
> > On Mon, Mar 15, 2021 at 5:08 PM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Mon, Mar 15, 2021 at 01:37:11PM +0800, Xie Yongji wrote:
> > > > Export __receive_fd() so that some modules can use
> > > > it to pass file descriptor between processes.
> > >
> > > I really don't think any non-core code should do that, especilly not
> > > modular mere driver code.
> >
> > Do you see any issue? Now I think we're able to do that with the help
> > of get_unused_fd_flags() and fd_install() in modules. But we may miss
> > some security stuff in this way. So I try to export __receive_fd() and
> > use it instead.
>
> The __receive_fd() helper was added for core-kernel code only and we
> mainly did it for the seccomp notifier (and scm rights). The "__" prefix
> was intended to convey that message.
> And I agree with Christoph that we should probably keep it that way
> since __receive_fd() allows a few operations that no driver should
> probably do.
> I can see it being kinda ok to export a variant that really only
> receives and installs an fd, i.e. if we were to export what's currently
> available as an inline helper:
>
> static inline int receive_fd(struct file *file, unsigned int o_flags)
>
> but definitely none of the fd replacement stuff; that shold be
> off-limits. The seccomp notifier is the only codepath that should even
> think about fd replacement since it's about managing the syscalls of
> another task. Drivers swapping out fds doesn't sound like a good idea to
> me.
>

Thanks for the explanation, I got it. I will switch to use
receive_fd() in the next version.

Thanks,
Yongji
