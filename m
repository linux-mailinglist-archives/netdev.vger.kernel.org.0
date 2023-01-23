Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439766786FA
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjAWUAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjAWUAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:00:40 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FBF3250A
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:00:37 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4a2f8ad29d5so187701867b3.8
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fA7GCR1/7uoHSczwW7TGv2fvULCDkSVCUnOB1LeyYlI=;
        b=0igMzBynrUoT7R0w1Uvfy4GbPQwaj/MelvM4wDl44U2AmuI/ck8B+w3hTcMWF9kuqh
         2fSeQqm8onIgxp/MnkPE3ukGRyxi0Ck8wL3bs/UIbAi2V7IKvsFX5z5Rjkf4Lhbwrkdo
         r3w46zRYQrWZwbZSQ/ZJJ1NueoY0znjewPysWD0GFy//Cggl9yfhrsjoL4k9pE4uM6w1
         S2+39TsgwY+xidozFDErAczYdFGNHxBzlc3ZpEswIYOxUgWNw/0FPiReWeBvRLngGHkU
         i5caDmoMQdFVltNK4vpI8rSH9V6iRA6hnOzZ9VoFr4b5OIp2RBJPS8ebAmgAC73VzGfu
         I2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fA7GCR1/7uoHSczwW7TGv2fvULCDkSVCUnOB1LeyYlI=;
        b=pzFNxtMq14n5UugMHnZ7LeO98DO2UGgUAvxL70gNqRkpFy1X0gO1c7Aui+dlWknhWm
         VyfcssXjOOJSIULxteCXDdnu1U9+q0sOjiBmXZdg6JANYLJZdIrC4W5NnWl2s00jOu5z
         WmCBemWhEcoI5QUuNmvGffpQezeN74PqNvVCG8ZD/zfrXatF/wB9cbUanvZ7xqAtGYFg
         NJ0sg0r/Wm1CiMYBDx+Ahhv42FizfUI3ruHpNXIafn8XjHzXa6brXLORNZZPZXnLVyYq
         HAZ6JV51UP06meIMPZIJeYQBnBTmYPN7dyadOGHNPr6CrW1UXIsfA/VzEBw2GoqK6G28
         EK/Q==
X-Gm-Message-State: AO0yUKWtAAcA4Q9XXN1ntZ9ZqPkAI6EBOd+UD6Cdoj+iYV2c9tXRgg+3
        Hy1aOi+XMxGEQqCNbvoP1ZAgPLXARmcq7IXtWtDpV1++I8pVhg==
X-Google-Smtp-Source: AK7set8C+8kKj716gzSt60WoKwUEhsClP9EXdhKKAwBhHTkQQsTc2Hrxp//7QrQgsLD7C3eJCJHc3t1J8nb5bPF5eOU=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr18930ywk.360.1674504036405; Mon, 23 Jan
 2023 12:00:36 -0800 (PST)
MIME-Version: 1.0
References: <20230112105905.1738-1-paulb@nvidia.com> <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com> <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
 <8f9ca91e-1f3f-c3c1-cbab-4f9af3884b43@nvidia.com> <CAM0EoMm-YVTKWwTEEACjEuyh8C+tWiEWFurPB=F2JUT72nZp4A@mail.gmail.com>
 <d7404d79-1d3b-9392-7911-1851f1c37cbf@nvidia.com>
In-Reply-To: <d7404d79-1d3b-9392-7911-1851f1c37cbf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 23 Jan 2023 15:00:25 -0500
Message-ID: <CAM0EoM=BMcmMc-9JU+SdN6v2KqDUXgbY+xLsxs58WKiKnqWXog@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 4:27 PM Paul Blakey <paulb@nvidia.com> wrote:
>
>
>
> On 18/01/2023 14:54, Jamal Hadi Salim wrote:
> > On Tue, Jan 17, 2023 at 9:48 AM Paul Blakey <paulb@nvidia.com> wrote:
> >>
> >> On 17/01/2023 15:40, Jamal Hadi Salim wrote:
> >
> > [..]


> > Can you maybe post an example of such a working example in your commit message
> > with stats?
> > You showed a candidate scenario that could be sorted but not a running example.
> >
>
> Sure Ill give it as full example in v3.

I saw your latest - I meant an example with tc -s as well to show
stats so we can see
hw vs sw stats.



> > Yeah, that was initially confusing when i read the commit log. It sounded
> > like action continue == action pipe (because it continues to the next action
> > in the action graph).
> > Maybe fix the commit to be clearer.
>
> I don't think I mentioned it in the cover letter/commits, or did I miss
> it ?
>

It's clearer in the latest commit.


> > Let me give a longer explanation.
> > The key i believe is understanding the action dependency. In my mind
> > there are 3 levels of
> > complexity for assumed ordering of actions A, B, C:
> >
> > 1) The simplest thing is to assume all-or-nothing (which is what we
> > have done so far in tc);
> > IOW if not all of A, B, C can be offloaded then we dont offload. >
> > 2) next level of complexity is assuming that A MUST occur before B
> > which MUST occur before C.
> > Therefore on ingress you can offload part of that graph depending on
> > your hardware capability.
> > Example: On ingress A, B offloaded and then "continue" to C in s/w if
> > your hardware supports
> > only offloading A and B but not C. You do the reverse of that graph
> > for egress offload.
>
> This is actually the case we want support in this patchset.
> Assuming a tc filter has action A , action CT, action B.
> If hardware finds that it can't do CT action in hardware (for example
> for a new connection), but we already did action A, we want to continue
> executing to "action CT, action B" in sw.
>
> We can use it for partial offload of the action list, but for now it
> will be used for supporting tuple rewrite action followed by action ct
> such as in the example in the cover letter.
>

Ok. Part of the challenge here is also you are assuming that the rule is
both skip_sw and skip_hw which may simplify things but also adds to the
workaround complexity.
If i was a "smart user" i would split this into two: one that has
skip_sw and the
other that has skip_hw.


> > 3) And your case is even more complex because you have a lot more
> > knowledge that infact
> > there is no action dependency and you can offload something in the
> > middle like B.
> > So i believe you are solving a harder problem than #2 which is what
> > was referring to in
> > my earlier email.
> >
>
>
> This is something we currently do but is "transparent" to the user.
> If we have action A, action CT, action B, where A/B != CT and A doesn't
> affect CT result (no dependency), we reorder it internally as action CT,
> action A, action B. Then if we can't do CT in hardware, we didn't do A,
> and can continue in sw to re-execute the filter and actions.
>
> If there is no action dependency then let driver take care of the
> details as we currently do we mlx5.

I think that is a fitting abstraction. The driver with enough knowledge of the
hw can do the necessary transforms.

cheers,
jamal
