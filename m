Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1667F349
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjA1AsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjA1AsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:48:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80151DBB0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:48:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so6246090pjb.5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KUB7VhQpOmzbZycPkRq+QPmcGxEJDorYOhvDr1fpga4=;
        b=JSa+ysIPj1uD+B2+sQ7bBNO5gLG0seqs/VJ80T2u6b2GfggFB69lFxWCD/eNjVQ6KK
         U2tYKaxXMKN1eSB2BTjQszZ2gkWo2tJv5Ce0dcnWgXPk9sRiG8yCVFYsaOhWmrL05yHq
         Tjf0Cl33EUleyTvT4hoq24JtC4NiTtZI9tVqKmKKZsabx6+CBariltbI5J4MujhQMGcI
         hEUB//+miFeDGT4Bu/NljXxFVvKMlByhxAGVzHcIIk07+VitTwRW6BjxDL+pPXI8mD3X
         PBrNgsR7t6fzu0kbgJUWIBGwfy9NvrLYo5djmsUveGDiH19yBbEJ/vCg70Snc68dPDvm
         nb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUB7VhQpOmzbZycPkRq+QPmcGxEJDorYOhvDr1fpga4=;
        b=7GXQwMGr6oB2jgVdmM8MJ4f0s8+1fCpX51JiOhw7qAWP7G/q9hFj/dL7A0cvCAwBvZ
         9cNweXPXUJmlvio/q1mcq31loUbaE97/HYhZjrPYzrFBJIlQ8Xx52tUW1WPHndmQM/sg
         TFnx/IgUSreMxVF7kLsWGyIxXadHYXBt1UOXADv0mQEmvUxA5Rb7SVC+lmvBBZdkvYEm
         9C0sfoSKW9i6D+FklvVhoac79CnMdtolBKVV1dSJsX6tCBiSHQcvAnVN+n7feJ+rVn2e
         Ugk7Xla/wyffkkVyh+A+PETKQqiyOKpZG6HaBpxRURkYC4J/dEF/9UPu/8Wl3/Eh+KlV
         JL9g==
X-Gm-Message-State: AFqh2kqnHdVUUtjgUiy0d7ChHNTk72bmBjRMkOwkZ+uz7d7rdZq+1qkg
        B91JlJH5k3hMP53rX4vNUECsBYl/bfu3Ad1wku83Cw==
X-Google-Smtp-Source: AMrXdXubCjXCuqVL6rpFu7bVm69wKSqp3/YkuFXPI51vdJh4t7kos2t+v8dFelrta8GrJh8s1UErpQzDVyhutkOWRh4=
X-Received: by 2002:a17:90a:66cb:b0:229:3b3f:75e1 with SMTP id
 z11-20020a17090a66cb00b002293b3f75e1mr6072725pjl.0.1674866886149; Fri, 27 Jan
 2023 16:48:06 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
In-Reply-To: <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 27 Jan 2023 16:47:54 -0800
Message-ID: <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jamal Hadi Salim <hadi@mojatatu.com>,
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

On Fri, Jan 27, 2023 at 3:27 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On Fri, Jan 27, 2023 at 5:26 PM <sdf@google.com> wrote:
> >
> > On 01/27, Jamal Hadi Salim wrote:
> > > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > >
> > > > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > > > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > > > >> There have been many discussions and meetings since about 2015 in
> > > regards to
> > > > >> P4 over TC and now that the market has chosen P4 as the datapath
> > > specification
> > > > >> lingua franca
> > > > >
> > > > >Which market?
> > > > >
> > > > >Barely anyone understands the existing TC offloads. We'd need strong,
> > > > >and practical reasons to merge this. Speaking with my "have suffered
> > > > >thru the TC offloads working for a vendor" hat on, not the "junior
> > > > >maintainer" hat.
> > > >
> > > > You talk about offload, yet I don't see any offload code in this RFC.
> > > > It's pure sw implementation.
> > > >
> > > > But speaking about offload, how exactly do you plan to offload this
> > > > Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> > > > HW acceptable blob. How exactly do you plan to deliver it to the driver?
> > > > If HW offload offload is the motivation for this RFC work and we cannot
> > > > pass the TC in kernel objects to drivers, I fail to see why exactly do
> > > > you need the SW implementation...
> >
> > > Our rule in TC is: _if you want to offload using TC you must have a
> > > s/w equivalent_.
> > > We enforced this rule multiple times (as you know).
> > > P4TC has a sw equivalent to whatever the hardware would do. We are
> > > pushing that
> > > first. Regardless, it has value on its own merit:
> > > I can run P4 equivalent in s/w in a scriptable (as in no compilation
> > > in the same spirit as u32 and pedit),
> > > by programming the kernel datapath without changing any kernel code.
> >
> > Not to derail too much, but maybe you can clarify the following for me:
> > In my (in)experience, P4 is usually constrained by the vendor
> > specific extensions. So how real is that goal where we can have a generic
> > P4@TC with an option to offload? In my view, the reality (at least
> > currently) is that there are NIC-specific P4 programs which won't have
> > a chance of running generically at TC (unless we implement those vendor
> > extensions).
>
> We are going to implement all the PSA/PNA externs. Most of these
> programs tend to
> be set or ALU operations on headers or metadata which we can handle.
> Do you have
> any examples of NIC-vendor-specific features that cant be generalized?

I don't think I can share more without giving away something that I
shouldn't give away :-)
But IIUC, and I might be missing something, it's totally within the
standard for vendors to differentiate and provide non-standard
'extern' extensions.
I'm mostly wondering what are your thoughts on this. If I have a p4
program depending on one of these externs, we can't sw-emulate it
unless we also implement the extension. Are we gonna ask NICs that
have those custom extensions to provide a SW implementation as well?
Or are we going to prohibit vendors to differentiate that way?

> > And regarding custom parser, someone has to ask that 'what about bpf
> > question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> > usermode helper to transparently compile it to bpf (for SW path) instead
> > inventing yet another packet parser? Wrestling with the verifier won't be
> > easy here, but I trust it more than this new kParser.
> >
>
> We dont compile anything, the parser (and rest of infra) is scriptable.

As I've replied to Tom, that seems like a technicality. BPF programs
can also be scriptable with some maps/tables. Or it can be made to
look like "scriptable" by recompiling it on every configuration change
and updating it on the fly. Or am I missing something?

Can we have a P4TC frontend and whenever configuration is updated, we
upcall into userspace to compile this whatever p4 representation into
whatever bpf bytecode that we then run. No new/custom/scriptable
parsers needed.

> cheers,
> jamal
