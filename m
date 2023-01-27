Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F30D67F116
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjA0W1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA0W1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:27:00 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A238E86EB9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:26:59 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u15-20020a170902a60f00b00194d7d89168so3492890plq.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NbuyITvPSOKc1jz+S/ft6dofjUNp+cIGwMA79f3VFEk=;
        b=f5x3qhocuPlwqyCCe4KzyunFep02grb522QNo+B29UMko/YawVUY7kGNJX6d9iaiiP
         QqwgcVCt7Q/ELI42F3mCZYhcPhXXfsxcz4LvYkKrge+iRkD4O9OC7SgCRbicUpRY/dox
         FdKv841T16VH1iJK9T2QkR73zG63mXlGXK0c4BETEhSbdCBOdbi8oase32jL9NYh674o
         XKIFriuKQSVMyPY3lPa81MWTwrr+dtF2MQ2SHyCW+niafiLEdyNkz2wwo0wXRoL95l62
         S9WW7gkzNLpOkGTbiJeUpSEJKnnJVXFOHttH0IfPeXvh40MV+bCCna3VvGW+tCS4AWos
         QAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NbuyITvPSOKc1jz+S/ft6dofjUNp+cIGwMA79f3VFEk=;
        b=v46VvtHLY47XUsjMdmRS6N8MJZ23owQtRuopJognKgY/dIZFeC6hzS9bhS9MpT0zIK
         VwJqJwfTM+XUjHSMjh2/3LOoMW0CKTZ0lWFr1DK5NXNdfTLZvYgCBsqULeAiZl+ya018
         6An+L8FuK9/qkVtsxVqqgdUvjmIblBL9pWAsgt9v/08k9cKwXeI45S5IQ60YzqgqfT6m
         SlBVOpFZBmE6KR4RYUE4z4DpOhNYKmjWHu4hSGiatTqMHx1ATj2vzMIQjl2HnTlg9SE5
         mn4hvgUIBMZvbnRidhb3Ozonq7Hz7gVAwUg0Zaca5WUWrWxQxYSAtGvEGv1F7wiVglH1
         ocYw==
X-Gm-Message-State: AO0yUKW4vAlicR3jtjRQvhVKQsQ+nw8aGgbHsqf3IRTnqM40MXOBb9al
        rs47eIAneEbCC9M55J/Z3VUVk+Y=
X-Google-Smtp-Source: AK7set+6qTy1UmuYi7HnnnQ/P+t1vNnSAXf1kqyS88Xzu95Wbftj8mxyiGZXV7/kZR1s5vHMA5f1yu0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:1003:b0:226:9980:67f3 with SMTP id
 gm3-20020a17090b100300b00226998067f3mr18917pjb.1.1674858418809; Fri, 27 Jan
 2023 14:26:58 -0800 (PST)
Date:   Fri, 27 Jan 2023 14:26:57 -0800
In-Reply-To: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
Message-ID: <Y9RPsYbi2a9Q/H8h@google.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
From:   sdf@google.com
To:     Jamal Hadi Salim <hadi@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/27, Jamal Hadi Salim wrote:
> On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > >> There have been many discussions and meetings since about 2015 in  
> regards to
> > >> P4 over TC and now that the market has chosen P4 as the datapath  
> specification
> > >> lingua franca
> > >
> > >Which market?
> > >
> > >Barely anyone understands the existing TC offloads. We'd need strong,
> > >and practical reasons to merge this. Speaking with my "have suffered
> > >thru the TC offloads working for a vendor" hat on, not the "junior
> > >maintainer" hat.
> >
> > You talk about offload, yet I don't see any offload code in this RFC.
> > It's pure sw implementation.
> >
> > But speaking about offload, how exactly do you plan to offload this
> > Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> > HW acceptable blob. How exactly do you plan to deliver it to the driver?
> > If HW offload offload is the motivation for this RFC work and we cannot
> > pass the TC in kernel objects to drivers, I fail to see why exactly do
> > you need the SW implementation...

> Our rule in TC is: _if you want to offload using TC you must have a
> s/w equivalent_.
> We enforced this rule multiple times (as you know).
> P4TC has a sw equivalent to whatever the hardware would do. We are  
> pushing that
> first. Regardless, it has value on its own merit:
> I can run P4 equivalent in s/w in a scriptable (as in no compilation
> in the same spirit as u32 and pedit),
> by programming the kernel datapath without changing any kernel code.

Not to derail too much, but maybe you can clarify the following for me:
In my (in)experience, P4 is usually constrained by the vendor
specific extensions. So how real is that goal where we can have a generic
P4@TC with an option to offload? In my view, the reality (at least
currently) is that there are NIC-specific P4 programs which won't have
a chance of running generically at TC (unless we implement those vendor
extensions).

And regarding custom parser, someone has to ask that 'what about bpf
question': let's say we have a P4 frontend at TC, can we use bpfilter-like
usermode helper to transparently compile it to bpf (for SW path) instead
inventing yet another packet parser? Wrestling with the verifier won't be
easy here, but I trust it more than this new kParser.

> To answer your question in regards to what the interfaces "P4
> speaking" hardware or drivers
> are going to be programmed, there are discussions going on right now:
> There is a strong
> leaning towards devlink for the hardware side loading.... The idea
> from the driver side is to
> reuse the tc ndos.
> We have biweekly meetings which are open. We do have Nvidia folks, but
> would be great if
> we can have you there. Let me find the link and send it to you.
> Do note however, our goal is to get s/w first as per tradition of
> other offloads with TC .

> cheers,
> jamal
