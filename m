Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654D7616637
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKBPdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKBPdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:33:36 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56882183AE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:33:31 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id a13-20020a9d6e8d000000b00668d65fc44fso10471616otr.9
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 08:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H8dbYX6PbViXvHlkenHJQMTQyQ7dbC0bq+/cgEib5J0=;
        b=bgEMJuufxd6HG8jDg8yAB/Um3zcG+4a0kPHTS0Uw8JMHdGeeiENqsLXVQac50Mq2uB
         oxn8ZoqSwExEomYD1z98FwVYVcnHU0aAeEoSgIaRcSUzukjV3qkxtfHu8v5PsXoq5vfl
         FS69VaVKc7VZgc2vfNKpCjIPVk/zTwYcK8tiz2W0Zg1/Fdb6c3DfKTqwCzKE07ux/OGQ
         zAUZ9NefBepXKv4D3Ae4GR3YjBOP0GI9Bcq/ptJPzM6lZFe9aeuWr0VB0Wew/LoindCj
         Z62qNHKhSTgYGWaY3xGdO8BP6m+5h7Q/0WyeXuWqr2CMRdqb18yKD2VCEhBV/xTFk922
         B8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H8dbYX6PbViXvHlkenHJQMTQyQ7dbC0bq+/cgEib5J0=;
        b=xOD6sojM4mkQL9VT+aasX2ZOnRiXc6HByhFuYnLU1zJ7cnj5CURaXRC4ZSvimIKMyt
         aL03HqOLU+MiV8Qu9+qCOccuzA6miVEprtA8ql+V4sFwPhmlK3I3/Kb6N5PlPL5gNeya
         aqzFzAV8Gzg6lkpTv/r+eDpIxb846T/eqAH2+eW6Jf1SWf1wxYE2MdrdN05DRH767F+S
         YOQrjN0OdQ71MQFEkaEyiz/27uPed5DqkwyJd1SGoysEpKBSylALljnGxqiJ+wW+z+ko
         NgVKodZS31jS1D0olzydwOdyTG2TMjqGo/QogevsO/CplA3aQcmxWZxOBDEumKrfNi2I
         6ezA==
X-Gm-Message-State: ACrzQf0RNIUr0T/ETG/jENK0JA+cIcAeygzWpuPIgrHKSoPODpnNXyNT
        0RSu/s+3ykYP7bHFteCNiav56y0edGmoSwaPjR42Cg==
X-Google-Smtp-Source: AMsMyM7zoEDVa+xyalPuZBA6NaCYek9724dTn87A2zd1Wed3AoXrrikpuY4KkpR+U6w/3nUvUOJtdED9iNSeX8RGakI=
X-Received: by 2002:a9d:7f84:0:b0:66c:53ef:e555 with SMTP id
 t4-20020a9d7f84000000b0066c53efe555mr7997746otp.34.1667403210666; Wed, 02 Nov
 2022 08:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220929033505.457172-1-liuhangbin@gmail.com> <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain> <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1>
In-Reply-To: <Y1kEtovIpgclICO3@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 2 Nov 2022 11:33:18 -0400
Message-ID: <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 5:58 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Sun, Oct 02, 2022 at 11:27:08AM -0400, Jamal Hadi Salim wrote:
> > > But, precisely. In the example Hangbin gave, it is showing why the
> > > entry is not_in_hw. That's still data that belongs to the event that
> > > happened and that can't be queried afterwards even if the user/app
> > > monitoring it want to. Had it failed entirely, I agree, as the control
> > > path never changed.
> > >
> > > tc monitor is easier to use than perf probes in some systems. It's not
> > > uncommon to have tc installed but not perf. It's also easier to ask a
> > > customer to run it than explain how to enable the tracepoint and print
> > > ftrace buffer via /sys files, and the output is more meaningful for us
> > > as well: we know exactly which filter triggered the message. The only
> > > other place that we can correlate the filter and the warning, is on
> > > vswitchd log. Which is not easy to read either.
> >
> > To Jakub's point: I think one of those NLMSGERR TLVs is the right place
> > and while traces look attractive I see the value of having a unified
> > collection point via the tc monitor.
>

Sorry for the latency - was at conference and still in travel mode...

> Hi Jamal,
>
> Sorry for the late response. I just came back form vacation. For this issue,
> I saw netlink_dump_done() also put NLMSGERR_ATTR_MSG in NLMSG_DONE.
> So why can't we do the same here?
>
> In https://www.kernel.org/doc/html//next/userspace-api/netlink/intro.html,
> The "optionally extended ACK" in NLMSG_DONE is OK.
>

Ok.
[That seemd to  be a nice doc - need to find time to look at it]

> > IMO:
> > I think if you need to do this, then you have to teach iproute2
> > new ways of interpreting the message (which is nice because you
> > dont have to worry about backward compat). Some of that code
> > should be centralized and reused by netlink generically
> > instead of just cls_api, example the whole NLM_F_ACK_TLVS dance.
>
> Would you please help explain more about this?
>

I meant you only added it for filter notification - but such a feature would
be useful also for other tc pieces (like actions and qdiscs). Is there a better
way to do it such that the other tc parts may benefit (instead of just
filter_notify?).

> >
> > Also - i guess it will depend on the underlying driver?
> > This seems very related to a specific driver:
> > "Warning: mlx5_core: matching on ct_state +new isn't supported."
> > Debuggability is always great but so is backwards compat.
> > What happens when you run old userspace tc? There are tons
> > of punting systems that process these events out there and
> > depend on the current event messages as is.
>
> I think old tc should just ignore this NLMSGERR_ATTR_MSG?

Yes.
So looks good to me then.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
