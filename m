Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF0B210105
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGAAe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGAAe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:34:56 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A6C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:34:55 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s1so11044002ybo.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sw/9BSlskFJoZsd0uDBmQsKUlb+QnZQZcRBjT5AK4Fw=;
        b=Jk6k06d+edA0RH6RglzYOJDDi8vLoHo6A3Z2VWGV9XUR/OEWOU+xbuhJmV+R4jxg0L
         vb++v2zQ4vZkOKg8wbswkoSrZAxiFU3lcFmwRJQanSZk1Fv0GdB+dDpkMY/mTlHHJHX0
         DGwuNkID53F8SMlvfx4eykAn/ywGeD6qpMwK4WkgsEO+gMZWpBSGJVEOqX4s4XhLN1jp
         24qCSdSrFuO63uUa7oNxmIYEFbEAERDtMClBlBX9q26wCVF5MxGMX2Xlmz+E7puFnpYa
         f7tZr87bH5mMEpTtmhpB3ogByedhTaXBF1nt33PHmjVhZ64RYqoSZd4T23m1RIU0Zfyd
         xCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sw/9BSlskFJoZsd0uDBmQsKUlb+QnZQZcRBjT5AK4Fw=;
        b=m0nLi9zM8+etTr997BlRkxxXgZqFvInmnxdurY5E9/9Hm15rvu7lJzDfocLKn7Mzek
         f1twyC0rYOtB9GlH+4wKTlJ6hc7tPFUVtU/Ffsu5aaxzY3v356Wb2xD6xoZZeiht2cFS
         Kt66lQIhw29mBx+s1XKoxe6MoM12YPUJiALuELexBmoU/vfoD8AxgZ8PJDf4DjxbhX+K
         d+cV3rqiuamV3juhEzsVvkpd8oESjaUghxh1ctnp2BSb1QosWXzoi/mBdYOOucMKnHU8
         2g2JXix0NIELGFdksBRVtyvoSbBSUpyc6o6JflUBrZBvWK+xwyseJC2eXfFk8V2IHwDf
         CMHA==
X-Gm-Message-State: AOAM532bNwr48xQ+6wC7JHq0lzAuZK3nuYU+ltq3ey9xzTJqMPdmyWbt
        0FhQCYUAuQMeiiW5JPdL8/vG4xXQZXJNbsCl9SLjxA==
X-Google-Smtp-Source: ABdhPJxD8dslsIcsRzexVUjLSxnoLvufT4lSXGkqOBnILjcexhMtfUDGoommH0Z/vYlWl2Ze8c4nGn3L1IItqtWO+K8=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr35796339ybh.364.1593563694877;
 Tue, 30 Jun 2020 17:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200630234101.3259179-1-edumazet@google.com> <1359584061.18162.1593560822147.JavaMail.zimbra@efficios.com>
 <CANn89iKHBkTbT9fZ3qbfZKE25MuS=av+frnRerGvP+_gUHPSAA@mail.gmail.com> <731827688.18225.1593563240917.JavaMail.zimbra@efficios.com>
In-Reply-To: <731827688.18225.1593563240917.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 17:34:43 -0700
Message-ID: <CANn89iLvSSLRzRr0vPDNBfe_ukGecQZp4AN4ZODYjpebq643NQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 5:27 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jun 30, 2020, at 7:50 PM, Eric Dumazet edumazet@google.com wrote:
>
> > On Tue, Jun 30, 2020 at 4:47 PM Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> >>
> >> ----- On Jun 30, 2020, at 7:41 PM, Eric Dumazet edumazet@google.com wrote:
> >>
> >> > MD5 keys are read with RCU protection, and tcp_md5_do_add()
> >> > might update in-place a prior key.
> >> >
> >> > Normally, typical RCU updates would allocate a new piece
> >> > of memory. In this case only key->key and key->keylen might
> >> > be updated, and we do not care if an incoming packet could
> >> > see the old key, the new one, or some intermediate value,
> >> > since changing the key on a live flow is known to be problematic
> >> > anyway.
> >>
> >> What makes it acceptable to observe an intermediate bogus key during the
> >> transition ?
> >
> > If you change a key while packets are in flight, the result is that :
> >
> > 1) Either your packet has the correct key and is handled
> >
> > 2) Or the key do not match, packet is dropped.
> >
> > Sender will retransmit eventually.
>
> This train of thoughts seem to apply to incoming traffic, what about outgoing ?


Outgoing path is protected by the socket lock.

You can not change the TCP MD5 key while xmit is in progress.

>
> >
> > If this was not the case, then we could not revert the patch you are
> > complaining about :)
>
> Please let me know where I'm incorrect with the following scenario:
>
> - Local peer is a Linux host, which supports only a single MD5 key
>   per socket at any given time.
> - Remote peer is a Ericsson/Redback device allowing 2 passwords (old/new)
>   to co-exist until both sides are OK with the new password.
>
> The local peer updates the MD5 password for a socket in parallel with
> packets flow. If we guarantee that no intermediate bogus key state is
> observable, the flow going out of the Linux peer should always be seen as
> valid, with either the old or the new key.

Linux has one key.

If your peer sends a packet with the old key, you will drop the
packet, no matter how hard you try.


>
> Allowing an intermediate bogus key to be observable means this introduces
> a race condition during which the remote peer can observe a corrupted key.

Race condition is there, even if you change the whole TCP MD5 key atomically.

If another cpu receives a packet while you are changing the key, you
definitely can not predict
if the packet is going to be dropped or not.


>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
