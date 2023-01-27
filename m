Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6430767F23E
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 00:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjA0X1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 18:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjA0X1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 18:27:42 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CA483052
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:27:41 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4ff1fa82bbbso87142597b3.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 15:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gSb8qFmDdWJ+rb1VD5lYXX/N2oNvRUrQ8nK9x0s6wok=;
        b=D9RhZIY/DiSxjeUv+hoxohlHdr8venqVhZ69NechXzj/BUumxoi8V09ape+oNRZvxO
         mBMMZxmNMfrM/DLqP6wkImoJFmUNOhXU+nRYtATL/0jGgGQfyu+TV7kQQ+BNeA7HiAMd
         AuJH8/xXwA6GL64i4MaQ6347RPlNpOHWw1ifeIKy8dPah56I/PM3SIVrPNgwKUT8AEnS
         7BbV18iFIlsp8Cgr37TaKZJKOp0wQUk0mp0zx8kpx87xUzEoIX0qcYjx3q7BmGZT2PLA
         K/yvvZMnsLkdMvegk93Zt8GjMvxHG0YT7iNFVFxZbU6tRIVxolWps3h7Ypj4ErkNawyu
         znjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gSb8qFmDdWJ+rb1VD5lYXX/N2oNvRUrQ8nK9x0s6wok=;
        b=1vphfVn51rCgTtAI+FUMbAUMhs/E4aa97bBVU5bI824bIV4nSMyI/QmjtMQUCK4JUt
         xeXYRt0ro14qBkk8EAd+2/wwqvETLcY1CSMMP+veB3rsizePg93xfCj/CHyqlosI8cxQ
         6nwdEYkGmyvuLpwjbdfQo1b5cj7KdHpAS8KxU332So0C88WkYGTU7WjDO+IUotfPpCzz
         enoNE+J3f7N+EJmcq0cLpPZMWmL2MP7j5as8QNpLFlTYm8F41yt8qjK8dSYSB+Ff5O6g
         yW1HNxn6Cdfd27fxky4NgbuCwJie5iAeAfNrpipCMB/+0fzOFVM3JwK7trHo7N07cQkC
         JNSQ==
X-Gm-Message-State: AFqh2kojzhaqdBNbB3yJL9syAHxK+Rkcn16HRXxgf+7KNnlY5LugtrzZ
        ocgw8WzuDkgBLY7Fzxl08KrUWcw2PEEu92DrWztmVA==
X-Google-Smtp-Source: AMrXdXspJToG6VVA/pgTAA2nHMu5ZEXc8hBNK4wjrhR9Z3QDpimxH3LxSu0p6TYuFHi4sFwiXYYUYQmuOCiynHqXOj8=
X-Received: by 2002:a0d:fe83:0:b0:4e3:4496:224e with SMTP id
 o125-20020a0dfe83000000b004e34496224emr4326489ywf.146.1674862060624; Fri, 27
 Jan 2023 15:27:40 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
In-Reply-To: <Y9RPsYbi2a9Q/H8h@google.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 27 Jan 2023 18:27:29 -0500
Message-ID: <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     sdf@google.com
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 5:26 PM <sdf@google.com> wrote:
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

We are going to implement all the PSA/PNA externs. Most of these
programs tend to
be set or ALU operations on headers or metadata which we can handle.
Do you have
any examples of NIC-vendor-specific features that cant be generalized?

> And regarding custom parser, someone has to ask that 'what about bpf
> question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> usermode helper to transparently compile it to bpf (for SW path) instead
> inventing yet another packet parser? Wrestling with the verifier won't be
> easy here, but I trust it more than this new kParser.
>

We dont compile anything, the parser (and rest of infra) is scriptable.

cheers,
jamal
