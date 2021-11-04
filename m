Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1030445AAE
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 20:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhKDTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 15:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhKDTw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 15:52:27 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF16CC061714;
        Thu,  4 Nov 2021 12:49:48 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o14so10286790wra.12;
        Thu, 04 Nov 2021 12:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vt4UwjSRvt86MSleOKVNLOxZeDwvrVGeX3RNYPe9uRQ=;
        b=HCJnkOesQZ74iQbwu267DhnjLV7f8ao9MidZSUhSzf6eGjdEt8ePK4AjGfzXS1Ze7Q
         ejOgmn64agpRR0A6YpJD++yXzhwlXlsOaGjpIMXdndTQ+fdFPzdDP8fQmqX2ZX3cR3BH
         m8SNJIVSaO7FskizHQrVnNEpjZua8PrpeQxn+x+cmWos0lYw1Kt3IlPplzSFXoYoDk0T
         iQJbS4cuOS6143Pn7CrPYW0iOyUp37OSKf7OtGwxNIXAoBp+OCLXrs1DnEw/+dmSeIYm
         9CcjT+CHtXbvrQRJbnYkKl7pLkzBVEQxLMKQHFCpVSiaatw0RRz6/94hY1EdTO++llN3
         ZC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vt4UwjSRvt86MSleOKVNLOxZeDwvrVGeX3RNYPe9uRQ=;
        b=HISPnJu62gWhk/MM5mm4HyjneAlKt3JY+mIfEPYycKOtw3mmHwzMgU4ifjWw1sfte3
         Cbjw8QSpbXm3tPozx2sbtqlEkdxu3NAZm7VIXTeijSpq1qbS7Ky9zwtQtZIvjeIrgc6X
         /gE/Qw+PQqOb2+Gl+68Oc3s3/HhQzU95+Aj3aWUTUS4xaD4TngX/au9XgvHewTgYVO84
         RYm4LaEG0sEuQPYZWJtbnmeq2hzrhHZKG0icRMKyoEfooEJ91Dj0/KmVKACuEh8TwDpQ
         EwpkvuzppcFV5Sg420B9mIzrd8SpRXHFXfuMOilzKpdqMEIY1T10j8qhqymaB9Aty6RL
         /7eg==
X-Gm-Message-State: AOAM531if+IQWxnUi53on8E86ojR518cP/pJ+d0sNdUbuGgBI1Hc86q8
        8XEJUObOEdjasXZlkb/DAZ3bfCEyolzfCi41RsA=
X-Google-Smtp-Source: ABdhPJwXBVzskBIwUOE9SXaAAQQFcNTxV3OjU7HIl27U2O+/9ZRgcRJkQ1h7tzKboHN6o2XXfkGJMEDfK5VJkj9LH3k=
X-Received: by 2002:a5d:6447:: with SMTP id d7mr35080476wrw.118.1636055387448;
 Thu, 04 Nov 2021 12:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
 <CADvbK_fVENGZhyUXKqpQ7mpva5PYJk2_o=jWKbY1jR_1c-4S-Q@mail.gmail.com>
 <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
 <20211104.110213.948977313836077922.davem@davemloft.net> <CAHC9VhQUdU6iXrnMTGsHd4qg7DnHDVoiWE9rfOQPjNoasLBbUA@mail.gmail.com>
In-Reply-To: <CAHC9VhQUdU6iXrnMTGsHd4qg7DnHDVoiWE9rfOQPjNoasLBbUA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 4 Nov 2021 15:49:35 -0400
Message-ID: <CADvbK_f7XyL8uvHdSgdvbphfw6QzTPFMvwZdW0P4R7qFJPc=yQ@mail.gmail.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Paul Moore <paul@paul-moore.com>
Cc:     David Miller <davem@davemloft.net>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jmorris <jmorris@namei.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 3:10 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Thu, Nov 4, 2021 at 7:02 AM David Miller <davem@davemloft.net> wrote:
> > From: Paul Moore <paul@paul-moore.com>
> > Date: Wed, 3 Nov 2021 23:17:00 -0400
> > >
> > > While I understand you did not intend to mislead DaveM and the netdev
> > > folks with the v2 patchset, your failure to properly manage the
> > > patchset's metadata *did* mislead them and as a result a patchset with
> > > serious concerns from the SELinux side was merged.  You need to revert
> > > this patchset while we continue to discuss, develop, and verify a
> > > proper fix that we can all agree on.  If you decide not to revert this
> > > patchset I will work with DaveM to do it for you, and that is not
> > > something any of us wants.
> >
> > I would prefer a follow-up rathewr than a revert at this point.
> >
> > Please work with Xin to come up with a fix that works for both of you.
>
> We are working with Xin (see this thread), but you'll notice there is
> still not a clear consensus on the best path forward.  The only thing
> I am clear on at this point is that the current code in linux-next is
> *not* something we want from a SELinux perspective.  I don't like
> leaving known bad code like this in linux-next for more than a day or
> two so please revert it, now.  If your policy is to merge substantive
> non-network subsystem changes into the network tree without the proper
> ACKs from the other subsystem maintainers, it would seem reasonable to
> also be willing to revert those patches when the affected subsystems
> request it.
>
> I understand that if a patchset is being ignored you might feel the
> need to act without an explicit ACK, but this particular patchset
> wasn't even a day old before you merged into the netdev tree.  Not to
> mention that the patchset was posted during the second day of the
> merge window, a time when many maintainers are busy testing code,
> sending pull requests to Linus, and generally managing merge window
> fallout.
>
> --
> paul moore
> www.paul-moore.com
Hi Paul,

It's applied on net tree, I think mostly because I posted this on net.git tree.
Also, it's well related to the network part and affects SCTP protocol
quite a lot.

I wanted to post it on selinux tree: pcmoore/selinux.git, but I noticed the
commit on top is written in 2019:

commit 6e6934bae891681bc23b2536fff20e0898683f2c (HEAD -> main,
origin/main, origin/HEAD)
Author: Paul Moore <paul@paul-moore.com>
Date:   Tue Sep 17 15:02:56 2019 -0400

    selinux: add a SELinux specific README.md

    DO NOT SUBMIT UPSTREAM

Then I thought this tree was no longer active, sorry about that.
