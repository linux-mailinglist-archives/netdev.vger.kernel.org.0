Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A3867F824
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjA1Nh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjA1Nh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:37:56 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C70126E4
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 05:37:54 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-501c3a414acso102882957b3.7
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 05:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1q7pDePeyyn2r0rDBys5viWwLXUR3r2mrQ6UpqXoxos=;
        b=kehx3r4WOHv+k0+gUdgZr7EyDmYfxNZsktJsUY+gGaFo6r/FrI1LBx97JjfXsNMHQZ
         00unHEMKH/sXZNp8tEju1Niyz0l4yANUVOQXQsZOdvCDnhH7tKslprq3g2ATnIod3cCe
         sfAkaUb1blSc45hl7pQvBoIXCAoPN5jN3Oe9n+Oxhd1AW+tIYtTEKUinuWlM3TnfTpcD
         kDrhOOGKJ7VWGR6OhTgfnlazo+StqmX0AxWL6aa3F1LR9BxgdLQ3YpLoe9CmRI7Stg6n
         fVMC8q/KpDBfS8KCwtTA4tMPw1inNcTX9j9xHcAmSjKgwXbaK6OXzxQY/h6mW9f/aQ5q
         J30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1q7pDePeyyn2r0rDBys5viWwLXUR3r2mrQ6UpqXoxos=;
        b=YQ1CVxUg34a19cMjkYVtoBLaKoftKlYnMrW8xwybdGHtiivnqYtJFxnDVQEyuVUhfU
         FR5u7C+nFSS4DQOv3IxwHpQuriXmS+7zxM0Ou2Nn90zF1iZ+yP8f3vKPCZuT/ewIVb/G
         NuOLxLYepMpnVqCszOrfKfZWnR1jgmwi3n+hqeZuwF24BK++Ysr3NdA3+WbyM/dzd3O3
         3sfPOK79XEKFbeD42bhqLKP5KR2Ix5vpIopjuF3ocTbRy6PxQwm5JJ+cbS8cTBb01TZ/
         9Z0ugQDcmTE2K/AU64TJ7Kz8OaDnGrba+VMgReWulcEDzCHPxEdCfuY+f1DTYi0LZSxG
         FalA==
X-Gm-Message-State: AFqh2koxj8rCqPC9p39A0aTehoCr3KZOVMnp1az9mkdcHXmMF8zkZ0vs
        UjuSIfLsC49UAnt9zUlIZRwrNE2XQv2VWwXKAAdsCg==
X-Google-Smtp-Source: AMrXdXsfNnkuIvLTU9UFlqX3h+pL87X7qR9d8EbXrUZszslsIUIS59VzZLvwVmzUUzq7EP6HDdk0gCFCzp8xoZFQ6Is=
X-Received: by 2002:a81:4d57:0:b0:4fe:8e35:3c89 with SMTP id
 a84-20020a814d57000000b004fe8e353c89mr3240232ywb.287.1674913073682; Sat, 28
 Jan 2023 05:37:53 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
In-Reply-To: <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Sat, 28 Jan 2023 08:37:16 -0500
Message-ID: <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 7:48 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jan 27, 2023 at 3:27 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > On Fri, Jan 27, 2023 at 5:26 PM <sdf@google.com> wrote:
> > >
> > > On 01/27, Jamal Hadi Salim wrote:
> > > > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > >
> > > > > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > > > > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > > > > >> There have been many discussions and meetings since about 2015 in
> > > > regards to
> > > > > >> P4 over TC and now that the market has chosen P4 as the datapath
> > > > specification
> > > > > >> lingua franca
> > > > > >
> > > > > >Which market?
> > > > > >
> > > > > >Barely anyone understands the existing TC offloads. We'd need strong,
> > > > > >and practical reasons to merge this. Speaking with my "have suffered
> > > > > >thru the TC offloads working for a vendor" hat on, not the "junior
> > > > > >maintainer" hat.
> > > > >
> > > > > You talk about offload, yet I don't see any offload code in this RFC.
> > > > > It's pure sw implementation.
> > > > >
> > > > > But speaking about offload, how exactly do you plan to offload this
> > > > > Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> > > > > HW acceptable blob. How exactly do you plan to deliver it to the driver?
> > > > > If HW offload offload is the motivation for this RFC work and we cannot
> > > > > pass the TC in kernel objects to drivers, I fail to see why exactly do
> > > > > you need the SW implementation...
> > >
> > > > Our rule in TC is: _if you want to offload using TC you must have a
> > > > s/w equivalent_.
> > > > We enforced this rule multiple times (as you know).
> > > > P4TC has a sw equivalent to whatever the hardware would do. We are
> > > > pushing that
> > > > first. Regardless, it has value on its own merit:
> > > > I can run P4 equivalent in s/w in a scriptable (as in no compilation
> > > > in the same spirit as u32 and pedit),
> > > > by programming the kernel datapath without changing any kernel code.
> > >
> > > Not to derail too much, but maybe you can clarify the following for me:
> > > In my (in)experience, P4 is usually constrained by the vendor
> > > specific extensions. So how real is that goal where we can have a generic
> > > P4@TC with an option to offload? In my view, the reality (at least
> > > currently) is that there are NIC-specific P4 programs which won't have
> > > a chance of running generically at TC (unless we implement those vendor
> > > extensions).
> >
> > We are going to implement all the PSA/PNA externs. Most of these
> > programs tend to
> > be set or ALU operations on headers or metadata which we can handle.
> > Do you have
> > any examples of NIC-vendor-specific features that cant be generalized?
>
> I don't think I can share more without giving away something that I
> shouldn't give away :-)
> But IIUC, and I might be missing something, it's totally within the
> standard for vendors to differentiate and provide non-standard
> 'extern' extensions.
> I'm mostly wondering what are your thoughts on this. If I have a p4
> program depending on one of these externs, we can't sw-emulate it
> unless we also implement the extension. Are we gonna ask NICs that
> have those custom extensions to provide a SW implementation as well?
> Or are we going to prohibit vendors to differentiate that way?
>
> > > And regarding custom parser, someone has to ask that 'what about bpf
> > > question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> > > usermode helper to transparently compile it to bpf (for SW path) instead
> > > inventing yet another packet parser? Wrestling with the verifier won't be
> > > easy here, but I trust it more than this new kParser.
> > >
> >
> > We dont compile anything, the parser (and rest of infra) is scriptable.
>
> As I've replied to Tom, that seems like a technicality. BPF programs
> can also be scriptable with some maps/tables. Or it can be made to
> look like "scriptable" by recompiling it on every configuration change
> and updating it on the fly. Or am I missing something?
>
> Can we have a P4TC frontend and whenever configuration is updated, we
> upcall into userspace to compile this whatever p4 representation into
> whatever bpf bytecode that we then run. No new/custom/scriptable
> parsers needed.

I would also think that if we need another programmable component in
the kernel, that this would be based on BPF, and compiled outside the
kernel.

Is the argument for an explicit TC objects API purely that this API
can be passed through to hardware, as well as implemented in the
kernel directly? Something that would be lost if the datapath is
implement as a single BPF program at the TC hook.

Can you elaborate some more why this needs yet another in-kernel
parser separate from BPF? The flow dissection case is solved fine by
the BPF flow dissector. (I also hope one day the kernel can load a BPF
dissector by default and we avoid the majority of the unsafe C code
entirely.)
