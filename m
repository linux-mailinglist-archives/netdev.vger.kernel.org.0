Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8642267F8F7
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjA1PKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjA1PKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:10:14 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A87EAD2F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:10:12 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4fd37a1551cso104446987b3.13
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eZGkQc3mM0OKIrPFWJ+rJgKmsjDI5wHs4GaRqpgHK5I=;
        b=CYFZJi6WJVUIBFoJIc51VfHQcvhSg4+z5fWXJ4a96+O1cnb+WtAA/HFCLW15kr1lHe
         gYmrtskx3rxpr7UW+oqy4RAK/n9OhgAYdcLlDdF312zoJpKKAxQfjjVZvlkyABtbgKC8
         ztHsOxqrK1cDaTlM8VVLhBbZTBaza+l4YcZQkD73qX3VEOnMwHaCI3ym+BfjEalw1GNp
         V9jy0x+uyDvflenuw2khtc6iiYpIIWeIqzlRIJKcBlGbt6k/CV/G+AHaKdB3hbbM5MzL
         TQhgs6LsKbr9Gts0jpPNywBa3C5J5TUZ4iHCYs+CNHh9H6a4fBHJaLKRKoXNnX45Bu6v
         t/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZGkQc3mM0OKIrPFWJ+rJgKmsjDI5wHs4GaRqpgHK5I=;
        b=T80YC6lri25FWhNkL2Mffo8Jvr8Fcqo3CcbudUtgMy6pEmnYEgTWK29IVAzwsJawB4
         zuEs5dWJaws/uuabtkp/MaaGusvBBDeR30nsnakIkHT7A/VLZfoqNOzy3D55f8917o8a
         qoRrsXtRqckg9pQsykO0ZwDX4EiIbazsdiR9xlb0yTjGoJMbtCjDyAt8pmmXhAnduXNc
         rjYNEJvJCDyZ/ee23J1pKuEXCCWPEsW8jM1yQgXCc3aGCukzG4vgQxsCEao1LGbZc8sx
         tKZfO6QVSTU+EFfYiACRdSBr5q5g3tlIoISxB1Zv5YWtZKDOKidagO4AoOA4xPxXn3jF
         qa8Q==
X-Gm-Message-State: AO0yUKVmS9LpnblEQRTAPZ4aE9FTksV4ACEqgdyNY8L2oTwDyd/mlTpk
        iVtJ334LZmlIwSuIY5gZ7IpiKPbmkWgUeRNb24c3IQ==
X-Google-Smtp-Source: AK7set85TqeJyQ8jjFbM0RJTBFvHc731Z0TBhX9hU+DzE3ihHRvVbiI1b2OX7Oksa1dFO4Htfzn2wTS+vpPg7pkdsCM=
X-Received: by 2002:a81:430b:0:b0:506:f1d6:2b6b with SMTP id
 q11-20020a81430b000000b00506f1d62b6bmr1722221ywa.376.1674918611770; Sat, 28
 Jan 2023 07:10:11 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com> <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
In-Reply-To: <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 28 Jan 2023 10:10:00 -0500
Message-ID: <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Willem de Bruijn <willemb@google.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 8:37 AM Willem de Bruijn <willemb@google.com> wrote:
>
> On Fri, Jan 27, 2023 at 7:48 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Fri, Jan 27, 2023 at 3:27 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > >
> > > On Fri, Jan 27, 2023 at 5:26 PM <sdf@google.com> wrote:
> > > >
> > > > On 01/27, Jamal Hadi Salim wrote:
> > > > > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > > >
> > > > > > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > > > > > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > > > > > >> There have been many discussions and meetings since about 2015 in
> > > > > regards to
> > > > > > >> P4 over TC and now that the market has chosen P4 as the datapath
> > > > > specification
> > > > > > >> lingua franca
> > > > > > >
> > > > > > >Which market?
> > > > > > >
> > > > > > >Barely anyone understands the existing TC offloads. We'd need strong,
> > > > > > >and practical reasons to merge this. Speaking with my "have suffered
> > > > > > >thru the TC offloads working for a vendor" hat on, not the "junior
> > > > > > >maintainer" hat.
> > > > > >
> > > > > > You talk about offload, yet I don't see any offload code in this RFC.
> > > > > > It's pure sw implementation.
> > > > > >
> > > > > > But speaking about offload, how exactly do you plan to offload this
> > > > > > Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> > > > > > HW acceptable blob. How exactly do you plan to deliver it to the driver?
> > > > > > If HW offload offload is the motivation for this RFC work and we cannot
> > > > > > pass the TC in kernel objects to drivers, I fail to see why exactly do
> > > > > > you need the SW implementation...
> > > >
> > > > > Our rule in TC is: _if you want to offload using TC you must have a
> > > > > s/w equivalent_.
> > > > > We enforced this rule multiple times (as you know).
> > > > > P4TC has a sw equivalent to whatever the hardware would do. We are
> > > > > pushing that
> > > > > first. Regardless, it has value on its own merit:
> > > > > I can run P4 equivalent in s/w in a scriptable (as in no compilation
> > > > > in the same spirit as u32 and pedit),
> > > > > by programming the kernel datapath without changing any kernel code.
> > > >
> > > > Not to derail too much, but maybe you can clarify the following for me:
> > > > In my (in)experience, P4 is usually constrained by the vendor
> > > > specific extensions. So how real is that goal where we can have a generic
> > > > P4@TC with an option to offload? In my view, the reality (at least
> > > > currently) is that there are NIC-specific P4 programs which won't have
> > > > a chance of running generically at TC (unless we implement those vendor
> > > > extensions).
> > >
> > > We are going to implement all the PSA/PNA externs. Most of these
> > > programs tend to
> > > be set or ALU operations on headers or metadata which we can handle.
> > > Do you have
> > > any examples of NIC-vendor-specific features that cant be generalized?
> >
> > I don't think I can share more without giving away something that I
> > shouldn't give away :-)
> > But IIUC, and I might be missing something, it's totally within the
> > standard for vendors to differentiate and provide non-standard
> > 'extern' extensions.
> > I'm mostly wondering what are your thoughts on this. If I have a p4
> > program depending on one of these externs, we can't sw-emulate it
> > unless we also implement the extension. Are we gonna ask NICs that
> > have those custom extensions to provide a SW implementation as well?
> > Or are we going to prohibit vendors to differentiate that way?
> >
> > > > And regarding custom parser, someone has to ask that 'what about bpf
> > > > question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> > > > usermode helper to transparently compile it to bpf (for SW path) instead
> > > > inventing yet another packet parser? Wrestling with the verifier won't be
> > > > easy here, but I trust it more than this new kParser.
> > > >
> > >
> > > We dont compile anything, the parser (and rest of infra) is scriptable.
> >
> > As I've replied to Tom, that seems like a technicality. BPF programs
> > can also be scriptable with some maps/tables. Or it can be made to
> > look like "scriptable" by recompiling it on every configuration change
> > and updating it on the fly. Or am I missing something?
> >
> > Can we have a P4TC frontend and whenever configuration is updated, we
> > upcall into userspace to compile this whatever p4 representation into
> > whatever bpf bytecode that we then run. No new/custom/scriptable
> > parsers needed.
>
> I would also think that if we need another programmable component in
> the kernel, that this would be based on BPF, and compiled outside the
> kernel.
>
> Is the argument for an explicit TC objects API purely that this API
> can be passed through to hardware, as well as implemented in the
> kernel directly? Something that would be lost if the datapath is
> implement as a single BPF program at the TC hook.
>

We use the skip_sw and skip_hw knobs in tc to indicate whether a
policy is targeting hw or sw. Not sure if you are familiar with it but its
been around (and deployed) for a few years now. So a P4 program
policy can target either.

In regards to the parser - we need a scriptable parser which is offered
by kparser in kernel. P4 doesnt describe how to offload the parser
just the matches and actions; however, as Tom alluded there's nothing
that obstructs us offer the same tc controls to offload the parser or pieces
of it.

cheers,
jamal

> Can you elaborate some more why this needs yet another in-kernel
> parser separate from BPF? The flow dissection case is solved fine by
> the BPF flow dissector. (I also hope one day the kernel can load a BPF
> dissector by default and we avoid the majority of the unsafe C code
> entirely.)
