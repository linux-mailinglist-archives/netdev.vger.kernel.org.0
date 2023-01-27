Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF82867F202
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 00:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjA0XGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 18:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjA0XGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 18:06:49 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55320166DE
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:06:45 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id fi26so6039884edb.7
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Da7wcxbTm1hVEEV+xKbsEkotS4x+ABVR4YHc9OL91yM=;
        b=6a1CU3elbns0m9CRkSRqEEDc7Hw/vjyAdXOzz6RgGpye+FPmu07ysWLUNBml3y/Ehy
         SIB2oY37XBwK2wEZbYMshKP0MGNMcStFEaFs4jzauMaoFYWds5te9/0CJdofMtZprk6U
         1RAkhM7ir4WYUIQ9fKq7EgG0w9dWkt/R/gq002YThebsIMVGHOZzsIV35RzpmIWaovTK
         bj3LwqYb2QTUCD3nokFPsgvIz+2Vmw+Nkrokr3eSJkIEDgqZaA5QMPgRsJpecZLahkjT
         xQAewe+KO4NGsqVEZHA1t/UCPc4heo61XlxnxfRwSVK91eGlZr43NeMjL9WgHsUzFL8F
         7D8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Da7wcxbTm1hVEEV+xKbsEkotS4x+ABVR4YHc9OL91yM=;
        b=DsEcGWGMA3R28CI8N8tIYTYNO6vsfUTXQ8TmqN1us/gSnNjlkmQyEJm/GS4rUgLhvo
         v+jR8iQFaV6AIoNWShfuq4sJyAdSsSWckV5JDOqsONf9Re2eU8R90yE2uqDId6O6UtyX
         hcQlIg1Y/pY3MyXpmsm+VazSwJHRbhvI+SyuHBW+z68dktJnBGF5CLwJDDWSCiHf/c3R
         c9YNNauXBZuEb9wvczPzJU5mQ20dATKI0ZaIeyUX/ywg/sPIsyVgEfRdlkwCccRUNimK
         HXZrOZghzUGBHm+hFkgYvxCIXNLT0IJfZLtfs+a36FjEhhruXbO86lKL4sedHtxvZQCQ
         11LA==
X-Gm-Message-State: AO0yUKUvfQnFvClWoe0iE+ez2R4ByTxv+s1gLr2MpCq7X1baE2iy/FvJ
        SUTFQafQFHjcUpDoeDA/8BknbrKATgV7/13OHrEwQQ==
X-Google-Smtp-Source: AK7set+rKZVlezS/+EzpRVURUzROwsnb76NNoFyIFDCOobSEDe07WhGflDhvObHt6fAPEFHS+8Nt3QlkY4oebbqZJl4=
X-Received: by 2002:aa7:c3c9:0:b0:4a0:e29d:18c9 with SMTP id
 l9-20020aa7c3c9000000b004a0e29d18c9mr2125326edr.69.1674860803828; Fri, 27 Jan
 2023 15:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
In-Reply-To: <Y9RPsYbi2a9Q/H8h@google.com>
From:   Tom Herbert <tom@sipanda.io>
Date:   Fri, 27 Jan 2023 15:06:32 -0800
Message-ID: <CAOuuhY-JT5mLKDBDScjyDA5grA2M8E9ECvyC6FJE3Ot-VLKh=w@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     sdf@google.com
Cc:     Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, pratyush@sipanda.io, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 2:26 PM <sdf@google.com> wrote:
>
> On 01/27, Jamal Hadi Salim wrote:
> > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > >
> > > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > > >> There have been many discussions and meetings since about 2015 in
> > regards to
> > > >> P4 over TC and now that the market has chosen P4 as the datapath
> > specification
> > > >> lingua franca
> > > >
> > > >Which market?
> > > >
> > > >Barely anyone understands the existing TC offloads. We'd need strong,
> > > >and practical reasons to merge this. Speaking with my "have suffered
> > > >thru the TC offloads working for a vendor" hat on, not the "junior
> > > >maintainer" hat.
> > >
> > > You talk about offload, yet I don't see any offload code in this RFC.
> > > It's pure sw implementation.
> > >
> > > But speaking about offload, how exactly do you plan to offload this
> > > Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> > > HW acceptable blob. How exactly do you plan to deliver it to the driver?
> > > If HW offload offload is the motivation for this RFC work and we cannot
> > > pass the TC in kernel objects to drivers, I fail to see why exactly do
> > > you need the SW implementation...
>
> > Our rule in TC is: _if you want to offload using TC you must have a
> > s/w equivalent_.
> > We enforced this rule multiple times (as you know).
> > P4TC has a sw equivalent to whatever the hardware would do. We are
> > pushing that
> > first. Regardless, it has value on its own merit:
> > I can run P4 equivalent in s/w in a scriptable (as in no compilation
> > in the same spirit as u32 and pedit),
> > by programming the kernel datapath without changing any kernel code.
>
> Not to derail too much, but maybe you can clarify the following for me:
> In my (in)experience, P4 is usually constrained by the vendor
> specific extensions. So how real is that goal where we can have a generic
> P4@TC with an option to offload? In my view, the reality (at least
> currently) is that there are NIC-specific P4 programs which won't have
> a chance of running generically at TC (unless we implement those vendor
> extensions).
>
> And regarding custom parser, someone has to ask that 'what about bpf
> question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> usermode helper to transparently compile it to bpf (for SW path) instead
> inventing yet another packet parser? Wrestling with the verifier won't be
> easy here, but I trust it more than this new kParser.

Yes, wrestling with the verifier is tricky, however we do have a
solution to compile arbitrarily complex parsers into eBFP. We
presented this work at Netdev 0x15
https://netdevconf.info/0x15/session.html?Replacing-Flow-Dissector-with-PANDA-Parser.
Of course this has the obvious advantage that we don't have to change
the kernel (however, as we talk about in the presentation, this method
actually produces a faster more extensible parser than flow dissector,
so it's still on my radar to replace flow dissector itself with an
eBPF parser :-) )

The value of kParser is that it is not compiled code, but dynamically
scriptable. It's much easier to change on the fly and depends on a CLI
interface which works well with P4TC. The front end is the same as
what we are using for PANDA parser, that is the same parser frontend
(in C code or other) can be compiled into XDP/eBPF, kParser CLI, or
other targets (this is based on establishing a IR which we talked
about in https://myfoobar2022.sched.com/event/1BhCX/high-performance-programmable-parsers

Tom

>
>
> > To answer your question in regards to what the interfaces "P4
> > speaking" hardware or drivers
> > are going to be programmed, there are discussions going on right now:
> > There is a strong
> > leaning towards devlink for the hardware side loading.... The idea
> > from the driver side is to
> > reuse the tc ndos.
> > We have biweekly meetings which are open. We do have Nvidia folks, but
> > would be great if
> > we can have you there. Let me find the link and send it to you.
> > Do note however, our goal is to get s/w first as per tradition of
> > other offloads with TC .
>
> > cheers,
> > jamal
