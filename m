Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6A47FAC3
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 08:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhL0Hix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 02:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbhL0Hiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 02:38:52 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D9BC06173E;
        Sun, 26 Dec 2021 23:38:52 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id q14so12848369qtx.10;
        Sun, 26 Dec 2021 23:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLLDyPbuFc71N5K2zSJPqE0SmFPRDoGs5Kv4v58VpBI=;
        b=FyPnz4xIpOXCcntG8ScUiWt5TJs0lkHXe80x2MPr0QK8d3FWA683EIuuRmZ14cwT4V
         +sEbRUJ2v6PMOUda53jIguPp5Vm8chfCKV15VPYZb5gim3S7SuMvLoDGcnDyIC23u+43
         1c+cVxkL3nhK8JF3188ymIwKjnTRA3kAeQtVKorf5nZ3mGAVzrc5ObQg686b3Z8TrLue
         4pAPsMpgiGCZ67/QDRq90kpC4GTZxZEv2VgoqvR/YbJ5QPs4Z0iq6yakdg/EGLf30VLR
         sHbDIHB5p7XLqR/HCBXQaq1z8VAtHoUS0oUykjsacB0Sy269OkYV2UfKg59sxv6fLRZ1
         j1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLLDyPbuFc71N5K2zSJPqE0SmFPRDoGs5Kv4v58VpBI=;
        b=Lr4f9IiOhuj/nqb9tfOQQYokMN7sI5UncTvpblVJ6qansCTwAe2Hnt4Pr+VQvwezlu
         ZqbDz/89x2cNjtzIDtcMq//mQ+H5JoUOsuYrPypwnZ67PBY1xHDrmkcU3pqg8oxWtGHR
         fJ5Gs6hQhzgdw8awDieZzqduQW1esxD35+nk/+IXuU7gz5LHth6SmiIKtsw7TX5kPDwl
         j5+QeFsYwlwRA0RvozdD4zsIiECPzPHKQGo5c375u8vlvd9fBubVRCPL1fRAJ5lkUBLC
         R1zVewNHeO+NmFcLf4YyuVd3SC/H5aejhYgIlXX9q7lx3ACWJq0EtfZJOuJ1gIOf0ZqE
         +D6w==
X-Gm-Message-State: AOAM530ZU6LsdBPrjpNL+kp/dt49MXV9Pj7mvUhmGfM/xXK9Us6b7HJo
        Xa38FGrL0rhrbC6ujECJpNoEgT/RQdnOParkyMs/hTFVgilIvZk4
X-Google-Smtp-Source: ABdhPJxO4a5utljn6qlZLhYHKQ88/2/whjajkZnu5/o7ux1NZmFNBOaeokZQUuUdqP6PWJ1Wt4IsHcMHv5CiWDfJq6Q=
X-Received: by 2002:a05:622a:120b:: with SMTP id y11mr13853987qtx.544.1640590731295;
 Sun, 26 Dec 2021 23:38:51 -0800 (PST)
MIME-Version: 1.0
References: <1640224567-3014-1-git-send-email-huangzhaoyang@gmail.com>
 <20211223091100.4a86188f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <CAGWkznHcjrM2kth8uWtuu+H-LOdPGXAN70nBYJax7aqcuHkECg@mail.gmail.com>
In-Reply-To: <CAGWkznHcjrM2kth8uWtuu+H-LOdPGXAN70nBYJax7aqcuHkECg@mail.gmail.com>
From:   Zhaoyang Huang <huangzhaoyang@gmail.com>
Date:   Mon, 27 Dec 2021 15:38:31 +0800
Message-ID: <CAGWkznEOsLweqA3omJ+xMs4bWvyphSvKBQmqPs+rer_e5fqKHg@mail.gmail.com>
Subject: Re: [PATCH] net: remove judgement based on gfp_flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 2:14 PM Zhaoyang Huang <huangzhaoyang@gmail.com> wrote:
>
> On Fri, Dec 24, 2021 at 1:11 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 23 Dec 2021 09:56:07 +0800 Huangzhaoyang wrote:
> > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > >
> > > The parameter allocation here is used for indicating if the memory
> > > allocation can stall or not. Since we have got the skb buffer, it
> > > doesn't make sense to check if we can yield on the net's congested
> > > via gfp_flags. Remove it now.
> >
> > This is checking if we can sleep AFAICT. What are you trying to fix?
> Yes and NO. gfp means *get free pages* which indicate if the embedded
> memory allocation among the process can sleep or not, but without any
> other meanings. The driver which invokes this function could have to
> use GFP_KERNEL for allocating memory as the critical resources but
> don't want to sleep on the netlink's congestion.
Since unique block flags(msg_flags & MSG_DONTWAIT) work as parameters
for unicast, could we introduce it to broadcast, instead of abusing
gfp_flag.

 static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
...
         if (dst_group) {
                 refcount_inc(&skb->users);
                 netlink_broadcast(sk, skb, dst_portid, dst_group, GFP_KERNEL);
         }
         err = netlink_unicast(sk, skb, dst_portid, msg->msg_flags &
MSG_DONTWAIT);

>
> >
> > > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > > index 4c57532..af5b6af 100644
> > > --- a/net/netlink/af_netlink.c
> > > +++ b/net/netlink/af_netlink.c
> > > @@ -1526,7 +1526,7 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
> > >       consume_skb(info.skb2);
> > >
> > >       if (info.delivered) {
> > > -             if (info.congested && gfpflags_allow_blocking(allocation))
> > > +             if (info.congested)
> > >                       yield();
> > >               return 0;
> > >       }
> >
