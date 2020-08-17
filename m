Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4D2475B0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgHQT0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbgHQT0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:26:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30FCC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:26:15 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so18817436ioj.4
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=We09K2kpSGTMwiTDa/DNKX90SOIVCSo6B9tkMW6n9SI=;
        b=A5GEh7BqzYIDgfKHPcKrqz8+N6xXK5PlOdyHStSpSeqyAxr7X2HSoRlNSR/ZGXD9xw
         ySKGVKJvQf7RdDo1mCpCbn0cbfCWuZygDYdfTxJb85SLVR0xYsoT5r670jMjJJfH33WV
         IFc8b+P4Nd0bz9lbZTx3/sdU6q5UlOYBLy0oGgtJRuHyYHiFcrYwnLUKyh1nLv+pUUC3
         /HwxWxG2o/8EKWnBuDXekUkE7W/bj/4KBglr/ifD0TXgLA3zs9rMIIU5dNThZ264g2Jy
         zRRSW9x1GO1m3wtJyMwrgN3OO9FhYor0tEJZ09I7+9GeNd6PgGosdaS5F0gbU+6/HBG+
         /iHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=We09K2kpSGTMwiTDa/DNKX90SOIVCSo6B9tkMW6n9SI=;
        b=JmokY7CihqCdItpgxCgFiw2FgEoLhrhWrskCHCSNnX6TzzPw13SGzJ5fyhf0ttNitS
         JKLGTE+ZJPOkQKdk9gquNpC+iuzJaODopbn9GYhHbxrrcgdnouMGIbTxW8vKbUUZnTjm
         QSfjZiWN4Ca0rlUFvJwhURsdtDdxOC5Jyq3fscaF0Av56MLa69vnIuxCDohkVCSRciEn
         LEt/+IS3usiLjw6Aa9PASAgS4TEUh0qej3JyC2S4vymxuOoRDd3u2ie4oG+4QVeUPsR6
         c5jvFNHzvqv2E76MEMJIvPsZbaABhqcias23aVk6+G0o51O3WVRx1ISP+TZ9e0iGIwuy
         F50A==
X-Gm-Message-State: AOAM530jLAWGnkAV17cX98nJMRT8Jb54AcAm4kNP4reVgi6perg2Hrlk
        BvX2/mCqByXtnrS4oarJDpd/sbktHrj4IeB08Gs=
X-Google-Smtp-Source: ABdhPJwH8d8uUk4/0tuJjy6gwCIH64i9g7tM9CfHzYo115XBXlyxIuy6VjUVDMdzhbAq+BfQUf0orOxz5N2k4N3cGYI=
X-Received: by 2002:a5d:980f:: with SMTP id a15mr2393586iol.12.1597692375123;
 Mon, 17 Aug 2020 12:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
 <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
 <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com>
 <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org> <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
 <1b45393f-bc09-d981-03bd-14c4088178ad@infradead.org>
In-Reply-To: <1b45393f-bc09-d981-03bd-14c4088178ad@infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 12:26:03 -0700
Message-ID: <CAM_iQpWOTLKHsJYDsCM3Pd1fsqPxqj8cSP=nL63Dh0esiJ2QfA@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 12:00 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 8/17/20 11:55 AM, Cong Wang wrote:
> > On Mon, Aug 17, 2020 at 11:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> >>
> >> On 8/17/20 11:31 AM, Cong Wang wrote:
> >>> On Sun, Aug 16, 2020 at 11:37 PM Xin Long <lucien.xin@gmail.com> wrote:
> >>>>
> >>>> On Mon, Aug 17, 2020 at 2:29 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>>
> >>>>> Or put it into struct ipv6_stub?
> >>>> Hi Cong,
> >>>>
> >>>> That could be one way. We may do it when this new function becomes more common.
> >>>> By now, I think it's okay to make TIPC depend on IPV6 || IPV6=n.
> >>>
> >>> I am not a fan of IPV6=m, but disallowing it for one symbol seems
> >>> too harsh.
> >>
> >> Hi,
> >>
> >> Maybe I'm not following you, but this doesn't disallow IPV6=m.
> >
> > Well, by "disallowing IPV6=m" I meant "disallowing IPV6=m when
> > enabling TIPC" for sure... Sorry that it misleads you to believe
> > completely disallowing IPV6=m globally.
> >
> >>
> >> It just restricts how TIPC can be built, so that
> >> TIPC=y and IPV6=m cannot happen together, which causes
> >> a build error.
> >
> > It also disallows TIPC=m and IPV6=m, right? In short, it disalows
> > IPV6=m when TIPC is enabled. And this is exactly what I complain,
> > as it looks too harsh.
>
> I haven't tested that specifically, but that should work.
> This patch won't prevent that from working.

Please give it a try. I do not see how it allows IPV6=m and TIPC=m
but disallows IPV6=m and TIPC=y.

>
> We have loadable modules calling other loadable modules
> all over the kernel.

True, we rely on request_module(). But I do not see TIPC calls
request_module() to request IPV6 module to load "ipv6_dev_find".

Thanks.
