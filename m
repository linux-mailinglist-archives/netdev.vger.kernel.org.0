Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C052C49AFA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfFRHon convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jun 2019 03:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFRHon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 03:44:43 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C3D193092663;
        Tue, 18 Jun 2019 07:44:42 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-116-148.ams2.redhat.com [10.36.116.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BCA636FA;
        Tue, 18 Jun 2019 07:44:39 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        <871s05fd8o.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
        <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
        <87k1dkdr9c.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
        <87a7egdqgr.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wjF6ek4v04w2O3CuOaauDERfdyduW+h=u9uN5ja1ObLzQ@mail.gmail.com>
Date:   Tue, 18 Jun 2019 09:44:38 +0200
In-Reply-To: <CAHk-=wjF6ek4v04w2O3CuOaauDERfdyduW+h=u9uN5ja1ObLzQ@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 17 Jun 2019 11:48:47 -0700")
Message-ID: <87lfxzbamx.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 18 Jun 2019 07:44:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Linus Torvalds:

> On Mon, Jun 17, 2019 at 11:19 AM Florian Weimer <fweimer@redhat.com> wrote:
>> >
>> > Unlike the "val[]" thing, I don't think anybody is supposed to access
>> > those fields directly.
>>
>> Well, glibc already calls it __val …
>
> Hmm. If user space already doesn't see the "val[]" array anyway, I
> guess we could just do that in the kernel too.
>
> Looking at the glibc headers I have for fds_bits, glibc seems to do
> *both* fds_bits[] and __fds_bits[] depending on __USE_XOPEN or not.
>
> Anyway, that all implies to me that we might as well just go the truly
> mindless way, and just do the double underscores and not bother with
> renaming any files.
>
> I thought people actually might care about the "val[]" name because I
> find that in documentation, but since apparently it's already not
> visible to user space anyway, that can't be true.
>
> I guess that makes the original patch acceptable, and we should just
> do the same thing to fds_bits..

Hah.

I think Arnd's original patch already had both.  So it's ready to go in
after all?

Thanks,
Florian
