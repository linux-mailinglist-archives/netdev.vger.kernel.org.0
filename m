Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B178597377
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbiHQQB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiHQQBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:01:54 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235AF9DFA7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:01:52 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id q39-20020a056830442700b0063889adc0ddso8761094otv.1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QjyUDvJ7iwmc0ra7oOeyYvg1tNnn3D1w9sE1ADUUeFk=;
        b=lsO3jJGAgKnlwg/EP5AW1QClcxpSPMzwfKK7ZrUVBas+QB1c4o/nIkJ+AtoVIsGNPo
         /fxrgQX7Pudy3dL3OOnSrOSbKY0mSZs0xmGbkOhueAgqMf3dJKqFN22NM2YeRCFiGQWw
         M0jpuI0ixf5xWd4DZtwDW5uiM6JQbdvyjw2AOwwGR9TXseNHTFlda4QkSXjShKW6wrne
         Cb7XJ8nljWuGbx/7WMnM+eabP7WgNDuHh0h/vRbrPUDyCu9hxXAglP+bdMeOMqaODLuq
         aFVmeTq3ET1DLeFdSLaaipA3MtYPBNSDM49uzLnn85Jz0RDE73xHlHXHFGb0zKQIPKau
         2Dsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QjyUDvJ7iwmc0ra7oOeyYvg1tNnn3D1w9sE1ADUUeFk=;
        b=3jHSfpc3fNJRKVKCU01vc1OO3kdhNnBQv6DWnfN7g1CpMFYKVsvhMcKd93UWxE0MVY
         jNZnw2kyyUoRaraXmE2r1gaVXD38hPu8uB/AmtRnnNFG6dtALidXLZlOuiaGGhxdhAuK
         cX+/1mHfONolgNnMIQDgUbcfH6lT1jiMtQPWH2zHtNdkmlM7WXMl8V0GiNUUoqJdQZk3
         7o1MWHO+mi7lLkaiJOZ1vwv63hhgBymoArBRyCau4XJs/d9DE6IyZerpdCBQ2OACQZiK
         XYmGq2F3k9l8bGnOVZkeBUeG5PlGXaVDyr4tYzD8381fODXOtUY3TME9somdWygP88JB
         wsPg==
X-Gm-Message-State: ACgBeo2tBtRVReoFFaENTTfzboa6w5cAFro/Mv82AKDn7ouvm/6cL6Cr
        6D8UcQCTqakx/UgxghrdqwH4tAabE5+rvsS53YuG
X-Google-Smtp-Source: AA6agR6k8S5KHHDdNHN0nb6d+yqydtBrtcybaSqfpgfRVzpYW/c5se+RRaLyh9Xa8S++SmB0U64Bn2EXUWEKmWFNo9I=
X-Received: by 2002:a05:6830:449e:b0:638:c72b:68ff with SMTP id
 r30-20020a056830449e00b00638c72b68ffmr3536226otv.26.1660752110415; Wed, 17
 Aug 2022 09:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220815162028.926858-1-fred@cloudflare.com> <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <8735dux60p.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 17 Aug 2022 12:01:39 -0400
Message-ID: <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 11:08 AM Eric W. Biederman
<ebiederm@xmission.com> wrote:
> > I just merged this into the lsm/next tree, thanks for seeing this
> > through Frederick, and thank you to everyone who took the time to
> > review the patches and add their tags.
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git next
>
> Paul, Frederick
>
> I repeat my NACK, in part because I am being ignored and in part
> because the hook does not make technical sense.
>
> Linus I want you to know that this has been put in the lsm tree against
> my explicit and clear objections.

Eric, we are disagreeing with you, not ignoring you; that's an
important distinction.  This is the fifth iteration of the patchset,
or the sixth (?) if you could Frederick's earlier attempts using the
credential hooks, and with each revision multiple people have tried to
work with you to find a mutually agreeable solution to the use cases
presented by Frederick and others.  In the end of the v4 discussion it
was my opinion that you kept moving the goalposts in an effort to
prevent any additional hooks/controls/etc. to the user namespace code
which is why I made the decision to merge the code into the lsm/next
branch against your wishes.  Multiple people have come out in support
of this functionality, and you remain the only one opposed to the
change; normally a maintainer's objection would be enough to block the
change, but it is my opinion that Eric is acting in bad faith.

At the end of the v4 patchset I suggested merging this into lsm/next
so it could get a full -rc cycle in linux-next, assuming no issues
were uncovered during testing I was planning to send it to Linus
during the next merge window with commentary on the contentiousness of
the patchset, including Eric's NACK.  I'm personally very disappointed
that it has come to this, but I'm at a loss of how to work with you
(Eric) to find a solution; this is the only path forward that I can
see at this point.  Others have expressed their agreement with this
approach, both on-list and privately.

If anyone other than Eric or myself has a different view of the
situation, *please* add your comments now.  I believe I've done a fair
job of summarizing things, but everyone has a bias and I'm definitely
no exception.

Finally, I'm going to refrain from rehashing the same arguments over
again in this revision of the patchset, instead I'll just provide
links to the previous drafts in case anyone wants to spend an hour or
two:

Revision v1
https://lore.kernel.org/linux-security-module/20220621233939.993579-1-fred@cloudflare.com/

Revision v2
https://lore.kernel.org/linux-security-module/20220707223228.1940249-1-fred@cloudflare.com/

Revision v3
https://lore.kernel.org/linux-security-module/20220721172808.585539-1-fred@cloudflare.com/

Revision v4
https://lore.kernel.org/linux-security-module/20220801180146.1157914-1-fred@cloudflare.com/

--
paul-moore.com
