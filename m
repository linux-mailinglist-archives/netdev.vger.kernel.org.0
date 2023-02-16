Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4855F699D9D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjBPUYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjBPUYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:24:34 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3101353807
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:24:14 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id i137so3621957ybg.4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EEpgJmgklLpO8h5YhCwHX+OfpAlsIU/aDajUy+UApiM=;
        b=w5JvbylcetomtcDtrFV1dpzvU+htmHTF+NfWICCW0myV7CyjVtBdugGKKSgeqvGwgU
         NjRLuV66MssDkA5AENIkHP/HmDLoRzJzirFUG/Eq2MOBhWg6No/fJPKBZIKgjwbni38N
         NZ3ecOYeSLHhFGDO3irRWplu1nIEiZ2kpwKxD50Wl9iFWcIOtTNrSW3nMkqrgn3/pCXv
         uA/fYfEIMmEEoi9vy26KNXSNJN9ofd2dOI9dUcO1Kr033Ou+RfkFlWOQ/KZlCKknpEc3
         gNb6VHle44YPQhEDX3UV1qymTuPBXOyJjoKvh/YBCbvUYd4pDjjhAtohFONuiwGyvz2b
         r1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EEpgJmgklLpO8h5YhCwHX+OfpAlsIU/aDajUy+UApiM=;
        b=yAVIdnirHpk1uvtFPW0iXwV6zCsHi4ArFtwwa3G2v5PmW60hwG4uWR5JpAiUzdFN39
         pDgGjPJXfBEuRrPjJv60sn7hcfwd+W16FHTMhMvTBncRfQfwdcNsdkDnuRYtHa4gw0qS
         GAFZwsPcS8vMvCBSNls9D9L0X/ugryBj8CDu6zVy00ydlj2b4aoFS5nrBbf6RjSEMkU2
         AoASLj0d+h2eoaTQW5rM87inYtNzIx/1qmb+i7TNeQLOMic1rTme/o2Ap2trU3xz65aT
         Bd+cK++ehobvUlypzcHpap8YGBXfc3j915hL7barfRdJU99b80h5eFws6yGuERcsKWm3
         yfPw==
X-Gm-Message-State: AO0yUKXFK3dMNUdUGF7N1FkqJWLo4rFLQ8IA6PKdkARtkbL/vD0aws5p
        r6DF5RN5rccH2gOtKQ+VTjN3PwkSjwz+t9uIB9C05A==
X-Google-Smtp-Source: AK7set8cTO2Bg1QRzOgD0NauNr+RZ5DodtL6Ojz6+V9dkoPB8nnD6NF07D8bGxZIjmO5x9N06BBHyJ+dshr0GOkwQYM=
X-Received: by 2002:a25:9706:0:b0:8d0:40b4:23ac with SMTP id
 d6-20020a259706000000b008d040b423acmr1130970ybo.214.1676579053358; Thu, 16
 Feb 2023 12:24:13 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <b7dafeb9-4535-9fa6-fb42-d6538b7ecf10@gmail.com> <CAAFAkD8Z5ZUQTcwsXPph0ms=mDJj2h2mYtRP4xGAbWvGUnnA2A@mail.gmail.com>
In-Reply-To: <CAAFAkD8Z5ZUQTcwsXPph0ms=mDJj2h2mYtRP4xGAbWvGUnnA2A@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 16 Feb 2023 15:24:01 -0500
Message-ID: <CAM0EoMkV6STz+aGuZ8vtHHXSkS0yQJpcre32B5erLbqRiY6Azg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jamal Hadi Salim <hadi@mojatatu.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com,
        "Jain, Vipin" <Vipin.Jain@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Want to provide an update to this thread and a summary of where we are
(typing this on web browser client so i hope it doesnt come all
mangled up):

I have had high bandwidth discussions with several people offlist
(thanks to everyone who invested their time in trying to smoothen
this); sometimes cooler   headers prevail this way. We are willing
(and are starting) to invest time to  see how we can fit ebpf for the
software datapath. Should be noted that we did  look at ebpf when this
project started and we ended up not going that path. I think what is
new in this equation is the concept of kfuncs - which we didnt  have
back then. Perhaps with kfuncs we can make both worlds work together.
XDP as well is appealing.

As i have stated earlier:
The starting premise is that the posted code meets our requirements so
 whatever we do using ebpf has to meet our requirements. I am ok with
some limited degree of square hole round peg situation but it cant  be
interfering in meeting our goals.

So let me restate those goals so we dont go into some rabit hole in
the discussion:
1) Supporting P4 in the kernel both for the sw and hw datapath
utilizing the well established tc infra which allows both sw
equivalence and hw offload.  We are _not_ going to reinvent this.
Essentially we get the whole package: from the control plane to the
tooling infra, netlink messaging to s/w and h/w symbiosis, the
autonomous kernel control, etc. The advantage is that we have a
singular vendor-neutral interface via the kernel using well understood
mechanisms.
Behavioral equivalence between hw and sw is a given.

2) Operational usability - this is encoded currently in the
scriptability approach. Ex, I can just ship someone a shell script in
an email but more important if they have deployed tc offloads the
runtime semantics are unchanged. "write once, run anywhere" paradigm
is easier to state in ascii;-> The interface is designed to be
scriptable to remove the burden of  making kernel and user space code
changes for any new processing functions  (whether in s/w or
hardware).
3) Debuggability - developers and ops people who are familiar with tc
offloads  can continue using the _same existing techniques and tools_.
This also eases support.

4) Performance - note our angle on this, based on the niche we are
looking at  is "if you want performance then offload". However, one
discussion point that has been raised multiple times in the thread and
in private is that  there are performance gains when using ebpf. This
arguement is reasonable and a motivator for us to invest our time in
evaluating.

 We have started doing off the cuff measurements. With very simple P4
program which receives a packet, looks up a table, and on a hit
changes src/mac address then forwards. We have: A) implemented a
handcoded ebpf program, B) generated  P4TC sw only C) flower s/w  only
(skip_hw) rules and D) hardware offload (skip_sw) all on tc (so we can
do orange-orange comparison). The SUT has a dual port CX6 NIC capable
of offloading pedit and mirred. Trex is connected to one port and
sending http gets which goes via the box and a response comes back on
the other port which we send back to trex. The traffic is very
asymettric; data coming  back to the client fills up the 25G pipe but
ACKs going back consume a lot less. Unfortunately all 4 scenarios were
able to handle the wire rate - we are going to set up more nasty
traffic generation later; for now we opted to look at cpu utilization
for the 4 scenarios. We have the following results:

 A) 35% CPU B) 39% C) 36% D) 0%

This is by no means a good test but i wanted to illustrate the
relevance of  #D (0%) - which is a main itch for us.

We need to test more complex programs which is where probably the
performance of ebpf will shine. XDP for sure will beat all the others
- but i would rather get the facts in place first. So we are investing
effort in this direction
and will share results at some point.

There may be other low hanging fruits that have been brought up in the
discussion for ebpf (the parser being one); we will be looking at all
those as well.

Note:
 The goal of this exercise for us is to evaluate not just performance
but   also consider how it affects the other P4TC goals. There may be
a sweet happy point somewhere in there but we need to collect the data
instead of hypothesizing.

cheers,
jamal
