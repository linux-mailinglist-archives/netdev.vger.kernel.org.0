Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44226662A9C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjAIP5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjAIP5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:57:52 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E4D36310
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 07:57:52 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 16so8981203ybc.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 07:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FuOMe9GRhY7G2IqJm2FLlmviiRH2/UdEk0aC9bsDBeQ=;
        b=p6a/ETyUdLVnQS2aN4WuVJe6NLzXLVBoB4IUaAwURczdXLzzT4gBqAdqSw0MPyW+bo
         vaRkKYqJi5MHzIXLMcSl+8CMDPHt0KwTHZuzlBcOFh+G7Nkj98CDireHU4Xb5pq3vmeP
         HkTI4/OMWg9VuC3Daw2HmT3EAe36uEhM40Onwst99MANpsOXyx0EeIkgrxfMOfe8iRr5
         KCpTPdfCUSWGzcZ9srtZZo89+I8+oHrYemR1d6N8DHiI+yeSXIHyUfAt4AHtcB8GoHaB
         xNL/p64cOgig6+ofK1Y3ndE68akTtINMG6FcvO+nDta+zy6GKqtm8j9ee1lnsQiYXbmv
         OusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FuOMe9GRhY7G2IqJm2FLlmviiRH2/UdEk0aC9bsDBeQ=;
        b=KQUPY0QTOb/l1E/n5ENK3Og6fx2kcG2zvqQ3dTCpHGdxBtJUGgi6Cxcm1/ZEqStpAD
         FAjSJ6JL/6EKmV/aqVx+7XzhI1oRVl1pfkrRfRfMvJcGdmi8cM/rK5wernOQbaG881/8
         fU7lGGsJqXyHc/cnbUpFFHJhxUG6KOK5QdBfmEm1sohOZl4jLIpWolNY822IiEKP1kZf
         WAFYzWAg4TmNERNycKFVmjmxpc0BsB4+jQXZzKdIsQg2wjXgUc4tq5NBDvZ+3okrSTBb
         CGiRyGfTLll3ardf4XPqGjb3j07w7z3GpeAYI0OG1ZdRqnyu+0t2RBkrnSXegGsZ97U/
         Ki/w==
X-Gm-Message-State: AFqh2krZGJdfhauJGFQHrvqUfn01mFRa+7BXe72BQTwVGKTt6Lihx4Sr
        XIvlfz0nT36KxNmmK1aTLbwFHv5/vmeGPyxtcWbTlg==
X-Google-Smtp-Source: AMrXdXtg4atwXjsilGzUooDJYSsrBzOcTqa4boasyoh4nTU1U03vy7DmUAtc4PG+zRBk7osBp+uxdm7SpL0D/db7LVE=
X-Received: by 2002:a25:6e87:0:b0:6dd:702f:c995 with SMTP id
 j129-20020a256e87000000b006dd702fc995mr5384222ybc.204.1673279871272; Mon, 09
 Jan 2023 07:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20230104091608.1154183-1-liuhangbin@gmail.com>
 <20230104200113.08112895@kernel.org> <Y7ail5Ta+OgMXCeh@Laptop-X1>
In-Reply-To: <Y7ail5Ta+OgMXCeh@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 9 Jan 2023 10:57:40 -0500
Message-ID: <CAM0EoMnJZDmFtm4iEpXjunQujTm2QwA5eEE85cTiGSOrvnWgRA@mail.gmail.com>
Subject: Re: [PATCHv3 net-next] sched: multicast sched extack messages
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 10:56 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
IMO the feature is useful. The idea of using a single tool to get the
details improves the operational experience.
And in this case this is a valid event (someone tried to add an entry
to hardware and s/ware and it worked for
one and not the other).
I think Jakub's objection is in the approach. Jakub, would  using
specific attributes restricted to
just QDISC/FILTER/ACTION work for you?

cheers,
jamal


On Thu, Jan 5, 2023 at 5:12 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
On Wed, Jan 04, 2023 at 08:01:13PM -0800, Jakub Kicinski wrote:
> On Wed,  4 Jan 2023 17:16:08 +0800 Hangbin Liu wrote:
> > In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> > made cls could log verbose info for offloading failures, which helps
> > improving Open vSwitch debuggability when using flower offloading.
> >
> > It would also be helpful if userspace monitor tools, like "tc monitor",
> > could log this kind of message, as it doesn't require vswitchd log level
> > adjusment. Let's add a new function to report the extack message so the
> > monitor program could receive the failures. e.g.
>
> If you repost this ever again please make sure you include my tag:
>
> Nacked-by: Jakub Kicinski <kuba@kernel.org>
>
> I explained to you at least twice why this is a terrible idea,
> and gave you multiple alternatives.

Hi Jakub,

I'm very sorry if this patch makes you feel disturbed. I switched the
notification
to NLMSG_ERROR instead of NLMSG_DONE as you pointed out. I also made the
notification only in sched sub-system, not using netlink_ack() globally.
Oh, and forgot to reply to you, I use portid and seq in the notification as all
the tc notifies also use them.

In the last patch, I saw Jamal reply to you about the usability. So I thought
you might reconsider this feature. Now I will stop posting this patch unless
you agree to keep working on this.

Sorry again if I missed any other suggestions from you.

Best regards
Hangbin

On Thu, Jan 5, 2023 at 5:12 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Wed, Jan 04, 2023 at 08:01:13PM -0800, Jakub Kicinski wrote:
> > On Wed,  4 Jan 2023 17:16:08 +0800 Hangbin Liu wrote:
> > > In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> > > made cls could log verbose info for offloading failures, which helps
> > > improving Open vSwitch debuggability when using flower offloading.
> > >
> > > It would also be helpful if userspace monitor tools, like "tc monitor",
> > > could log this kind of message, as it doesn't require vswitchd log level
> > > adjusment. Let's add a new function to report the extack message so the
> > > monitor program could receive the failures. e.g.
> >
> > If you repost this ever again please make sure you include my tag:
> >
> > Nacked-by: Jakub Kicinski <kuba@kernel.org>
> >
> > I explained to you at least twice why this is a terrible idea,
> > and gave you multiple alternatives.
>
> Hi Jakub,
>
> I'm very sorry if this patch makes you feel disturbed. I switched the notification
> to NLMSG_ERROR instead of NLMSG_DONE as you pointed out. I also made the
> notification only in sched sub-system, not using netlink_ack() globally.
> Oh, and forgot to reply to you, I use portid and seq in the notification as all
> the tc notifies also use them.
>
> In the last patch, I saw Jamal reply to you about the usability. So I thought
> you might reconsider this feature. Now I will stop posting this patch unless
> you agree to keep working on this.
>
> Sorry again if I missed any other suggestions from you.
>
> Best regards
> Hangbin
