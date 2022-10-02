Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A9A5F23DB
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJBP1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:27:22 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA65F3C173
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 08:27:20 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-131ea99262dso8293627fac.9
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 08:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Zk2uZZAvvjysnQmSo8T7Fl01EjGrwQMIHLBMf/WI1UY=;
        b=2yztuQhd9mJAilYxXL1mxYATL6ZgBP+OTQk8Wz6zDnXlsFSTtZNNgt0KgNrzz4QTkA
         ZmkOq3SnGEP24/8hv1G0X/fITeafczN19xJ1Np9d2UtZR/SJkWCxKq9uWVNcKZtYRVO5
         VNoez5Ic4WL7W7mKALv80WEqdkFY1WWjy7Lni8HcPBNJpjz1amsATulqNOOWF+teQV7o
         osiXsCB6wcQbOwFbFfFYAXkrDFPuJfTSN+V4ITWYLawHk+IiVwwY7OehPmtH40GML6AI
         QyoB/hCz+2b+W+Dpf9b8Vx3HWG+aDPOGTMk4fUCLc+B5rS07Mx2BJ8ioQiMxK/4WzQvY
         PdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Zk2uZZAvvjysnQmSo8T7Fl01EjGrwQMIHLBMf/WI1UY=;
        b=I/bBZYr9P0spTkKoOjEpL1AmOyklqCE5KJHqthkGouuxKU0dKDS0HxTnrQL6uGO4cx
         GAAmlAuyGTkYy8ekZdGAyU5tUWT3Do67E5TvwVScVB62MlSHRVEHtGNcYuX7Dp5ZYHDT
         NlDORhy8NGwFylITxnKoxJvf8mYA7fpbhAFULKzNn+lpLiXP/wAwMWYzVVqb0lVBb3Vo
         93f7E4ryCyugkSeAbfw67zuP7AmO7dy+L9FWiFr4KAFi/o/wUQs9GVnlYCXAzk3vYDIj
         fd8ogQ5cz4omPb2Nob6SxBt9oX6oPcE+qPgZLZcN2npp1HlsnioLnR7pZxFoTKMh8mJm
         rwKg==
X-Gm-Message-State: ACrzQf2t0ntGO+FJ4QdssCatJ6HvLZJXvxiMCBjaJZ9JpFdsHRZMop8s
        ti/D7FcrNgZK3bOdoOLq5qfpXu6b3ju10UAnFAKwaw==
X-Google-Smtp-Source: AMsMyM4isGVZvbs1a67fNi2BD+XZLBBdG5UY8T3WQGMUAO4TxqalLbd1ghTHOdSkSu+kEvzDLmsJcTD6FJsudR+NxKs=
X-Received: by 2002:a05:6870:609c:b0:131:c972:818f with SMTP id
 t28-20020a056870609c00b00131c972818fmr3267441oae.2.1664724440068; Sun, 02 Oct
 2022 08:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220929033505.457172-1-liuhangbin@gmail.com> <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain>
In-Reply-To: <Yzillil1skRfQO+C@t14s.localdomain>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 2 Oct 2022 11:27:08 -0400
Message-ID: <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
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

On Sat, Oct 1, 2022 at 4:39 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sat, Oct 01, 2022 at 11:39:07AM -0700, Cong Wang wrote:
> > On Thu, Sep 29, 2022 at 11:35:05AM +0800, Hangbin Liu wrote:
> > > In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> > > made cls could log verbose info for offloading failures, which helps
> > > improving Open vSwitch debuggability when using flower offloading.
> > >
> > > It would also be helpful if "tc monitor" could log this message, as it
> > > doesn't require vswitchd log level adjusment. Let's add the extack message
> > > in tfilter_notify so the monitor program could receive the failures.
> > > e.g.
> > >
> >
> > I don't think tc monitor is supposed to carry any error messages, it
> > only serves the purpose for monitoring control path events.
>
> But, precisely. In the example Hangbin gave, it is showing why the
> entry is not_in_hw. That's still data that belongs to the event that
> happened and that can't be queried afterwards even if the user/app
> monitoring it want to. Had it failed entirely, I agree, as the control
> path never changed.
>
> tc monitor is easier to use than perf probes in some systems. It's not
> uncommon to have tc installed but not perf. It's also easier to ask a
> customer to run it than explain how to enable the tracepoint and print
> ftrace buffer via /sys files, and the output is more meaningful for us
> as well: we know exactly which filter triggered the message. The only
> other place that we can correlate the filter and the warning, is on
> vswitchd log. Which is not easy to read either.

To Jakub's point: I think one of those NLMSGERR TLVs is the right place
and while traces look attractive I see the value of having a unified
collection point via the tc monitor.
Since you cant really batch events - it seems the NLMSG_DONE/MULTI
hack is done just to please iproute2::tc?
IMO:
I think if you need to do this, then you have to teach iproute2
new ways of interpreting the message (which is nice because you
dont have to worry about backward compat). Some of that code
should be centralized and reused by netlink generically
instead of just cls_api, example the whole NLM_F_ACK_TLVS dance.

Also - i guess it will depend on the underlying driver?
This seems very related to a specific driver:
"Warning: mlx5_core: matching on ct_state +new isn't supported."
Debuggability is always great but so is backwards compat.
What happens when you run old userspace tc? There are tons
of punting systems that process these events out there and
depend on the current event messages as is.

cheers,
jamal
