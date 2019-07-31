Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BE7C6A1
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfGaPb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:31:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37172 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbfGaPb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:31:59 -0400
Received: by mail-io1-f67.google.com with SMTP id q22so17391869iog.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 08:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mUN1pvMl8svBUjCaR0OxnSiYPVvf6+NNwTE7JqyHeGo=;
        b=Lz/OoRSBQngNq7qk2Ls23OczsyfF+YccBluCPWG7IS7H2uuPnlh1HSGyfgXfwgGlES
         cVL2dXXA7Fhc4epnBjF0cO1zMIQ5f3Pn6flq9z88B6QJPH6EbMIx9wTNvpq5yRvjWqyc
         wpgsnb5DDxaigNDWgbA/vmbkhmMOF4JBZU/4Bk11OUt1nDfwbNY7SsZF72Nc5/nmMCwE
         yGTwQfUViPaZ0//I4K21aNpX+U9cFpehlX+JN5PI558d9qtExMGTbAv2ZgVVWRAmkWt8
         YF0aPFQ5DNHkEGfwmEvmJanvVR26ZoEuPjy7iKpYk84Ya/KQh+EsPapOIbwr+r7TguNI
         uNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mUN1pvMl8svBUjCaR0OxnSiYPVvf6+NNwTE7JqyHeGo=;
        b=qEumVh+rUcb3Gqyy5u1G8vo8ORoGmxMwyV93rr//dREY6xTqqD7pylSO4Rzti9Chb7
         NO1L24XXPUW5Pabd/Kfg0H49OKfaBoyJw52Qi6NssNFukZUO8a1UUp8O10fakwcoJR8P
         u7Q/5OT42gfHGMLqEfXoRrEHnZrWfl4TNDWdDlHmznWkibeGis9byO5uVhXTuaCiTBA5
         rwshmPVaquZ61LSk7Fg1zx1oAabr2vX9kfpD4N17xVg5wTMx4KgyelfJ/jEbfftaZ/4Z
         oHfns/1v5k9sBgZr8E2VZjj6Qzxf6F4MxhpmuR5Tiogfu7fMSkTmHsIx9rlhfaovzBtU
         c8tw==
X-Gm-Message-State: APjAAAVIYjAYRp9gXGHor0e6/XK1JeWxjGUO24ga06ElQp1oZff8Y7/+
        2z/oleBPCaSUXZVLQOZYqJ2RGlvrY18z+aY88a4Yxw==
X-Google-Smtp-Source: APXvYqw2UXK6ZDLM4RK1EtyppjWajVOjmU7VeSiTcfg7vyOElSybY1Vr7ei0QqNz3/vdV59RExuEHrI8732XCga8lek=
X-Received: by 2002:a5e:c241:: with SMTP id w1mr106076388iop.58.1564587118129;
 Wed, 31 Jul 2019 08:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000004c2416058c594b30@google.com> <24282.1562074644@warthog.procyon.org.uk>
 <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com>
 <20330.1564583454@warthog.procyon.org.uk> <CACT4Y+Y4cRgaRPJ_gz_53k85inDKq+X+bWmOTv1gPLo=Yod1=A@mail.gmail.com>
 <22318.1564586386@warthog.procyon.org.uk>
In-Reply-To: <22318.1564586386@warthog.procyon.org.uk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 31 Jul 2019 17:31:45 +0200
Message-ID: <CACT4Y+bjLBwVK_6fz2H8fXm0baAVX+vRJ4UbVWG_7yNUO-SOUg@mail.gmail.com>
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 5:19 PM David Howells <dhowells@redhat.com> wrote:
>
> Dmitry Vyukov <dvyukov@google.com> wrote:
>
> > Please send a patch for testing that enables this tracing
> > unconditionally. This should have the same effect. There is no way to
> > hook into a middle of the automated process and arbitrary tune things.
>
> I don't know how to do that off hand.  Do you have an example?

Few messages above I asked it to test:
https://groups.google.com/d/msg/syzkaller-bugs/gEnZkmEWf1s/r2_X_KVQAQAJ

Basically, git repo + branch + patch. Here are the docs:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patches


> Anyway, I think rxrpc_local_processor() is broken with respect to refcounting
> as it gets scheduled when usage==0, but that doesn't stop it being rescheduled
> again by a network packet before it manages to close the UDP socket.
>
> David
