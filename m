Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E24354900
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhDEW43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhDEW42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 18:56:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57225C06174A
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 15:56:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so6606152pjg.5
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 15:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GnBTwzcZV685J0475cPgRz0vQiiNBuFhIooUNB9eYFo=;
        b=Jwqe6DRFWifhHtHc1/FP6LlXkwFiIRMWnJDDixPEp3WM6rlgezo0a5E1tdGERiVTp2
         ixApuBcdSVxFmSoitDwTsYUJAxSCMYbEWLJnjluSgsnv1h5ho8gKBGAmzQRxV4cUHEVi
         3E0TceZR3OCo+V5MgalcefC66qCIRQjbaEtSzTxVSACrAlJWjT37X3b2fdGM/N8SpDNi
         H603yZcA/8J1y+kDVmbalc6IfPNc+wqRC66VPw01tVOQniULx0bw4wTNBPEQ4NihMO9k
         IJrFmMoeA7kAzGM4wlIbqpOaHj8wWZOWCcIEsU+FvnHjU1Gsgv/si7nIiZQR6wSASjuD
         piEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GnBTwzcZV685J0475cPgRz0vQiiNBuFhIooUNB9eYFo=;
        b=ZTjXfxRSVshcSv8iO3xWVpMTYfywLMGblqO4uYItsMFCyabdfdoWA+N/gBNcr5Z9KH
         qW7D72p2bAMBUNgNWZkuYC0VlakpkAoD5n19uo2AGR+KvYATvxerL5BrxFnmQaNnOgCS
         08Toe9fDsZ9wRl+GvllCudW5jSIjFkZXM4VSUrJnnK7WTxLKfDotD9KQ4sq0coVuTCLe
         ISTZ8Ze23jOb/lHSyWAeQdrEQjwi9IyApUL7xq7zr6F/ZugddHYxYlgavy9cDQgF74Mq
         +cm9o0QGr3wE/1gPjj8KLQkAzBqRzNK5RwyAkbMrrxAQTJGuxWe6JHt22Ig2FqgsO8sd
         kwxQ==
X-Gm-Message-State: AOAM531Llr4VQhRoOnxILzPBpjYEzwlNubvChzUcoL+nk7xo7w4KFnvn
        EMstjLjAdrUVN2lmpFS8hfRYOUmXyfDrtnuXW8E=
X-Google-Smtp-Source: ABdhPJxQv4ohf+itNN8WVgue14pZZkhEoOXrQAnLNQgw8js2LI0B0mbwakjWGVSVoev49TQHN0Rf8bHvygZOPRbg1nE=
X-Received: by 2002:a17:902:8347:b029:e7:4a2d:6589 with SMTP id
 z7-20020a1709028347b02900e74a2d6589mr26637965pln.64.1617663379776; Mon, 05
 Apr 2021 15:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210331164012.28653-1-vladbu@nvidia.com> <20210331164012.28653-3-vladbu@nvidia.com>
 <CAM_iQpXRfHQ=Hzhon=ggjPJGjfS1CCkM6iV8oJ3iHZiTpnJFmw@mail.gmail.com> <ygnhy2dzadqt.fsf@nvidia.com>
In-Reply-To: <ygnhy2dzadqt.fsf@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 5 Apr 2021 15:56:08 -0700
Message-ID: <CAM_iQpXx4Ex7-=u5W7rDtykbSL0bdnzHhhVJ12cVcswBWYx_5g@mail.gmail.com>
Subject: Re: [PATCH RFC 2/4] net: sched: fix err handler in tcf_action_init()
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 3, 2021 at 3:01 AM Vlad Buslov <vladbu@nvidia.com> wrote:
> So, the following happens in reproduction provided in commit message
> when executing "tc actions add action simple sdata \"1\" index 1
> action simple sdata \"2\" index 2" command:
>
> 1. tcf_action_init() is called with batch of two actions of same type,
> no module references are held, 'actions' array is empty:
>
> act_simple refcnt balance = 0
> actions[] = {}
>
> 2. tc_action_load_ops() is called for first action:
>
> act_simple refcnt balance = +1
> actions[] = {}
>
> 3. tc_action_load_ops() is called for second action:
>
> act_simple refcnt balance = +2
> actions[] = {}
>
> 4. tcf_action_init_1() called for first action, succeeds, action
> instance is assigned to 'actions' array:
>
> act_simple refcnt balance = +2
> actions[] = { [0]=act1 }
>
> 5. tcf_action_init_1() fails for second action, 'actions' array not
> changed, goto err:
>
> act_simple refcnt balance = +2
> actions[] = { [0]=act1 }
>
> 6. tcf_action_destroy() is called for 'actions' array, last reference to
> first action is released, tcf_action_destroy_1() calls module_put() for
> actions module:
>
> act_simple refcnt balance = +1
> actions[] = {}
>
> 7. err_mod loop starts iterating over ops array, executes module_put()
> for first actions ops:
>
> act_simple refcnt balance = 0
> actions[] = {}
>
> 7. err_mod loop executes module_put() for second actions ops:
>
> act_simple refcnt balance = -1
> actions[] = {}
>
>
> The goal of my fix is to not unconditionally release the module
> reference for successfully initialized actions because this is already
> handled by action destroy code. Hope this explanation clarifies things.

Great explanation! It seems harder and harder to understand the
module refcnt here. How about we just take the refcnt when we
successfully create an action? Something like this:

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b919826939e0..075cc80480bf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -493,6 +493,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32
index, struct nlattr *est,
        }

        p->idrinfo = idrinfo;
+       __module_get(ops->owner);
        p->ops = ops;
        *a = p;
        return 0;
@@ -1035,13 +1036,6 @@ struct tc_action *tcf_action_init_1(struct net
*net, struct tcf_proto *tp,
        if (!name)
                a->hw_stats = hw_stats;

-       /* module count goes up only when brand new policy is created
-        * if it exists and is only bound to in a_o->init() then
-        * ACT_P_CREATED is not returned (a zero is).
-        */
-       if (err != ACT_P_CREATED)
-               module_put(a_o->owner);
-
        return a;

 err_out:
@@ -1100,7 +1094,8 @@ int tcf_action_init(struct net *net, struct
tcf_proto *tp, struct nlattr *nla,
        tcf_idr_insert_many(actions);

        *attr_size = tcf_action_full_attrs_size(sz);
-       return i - 1;
+       err = i - 1;
+       goto err_mod:

 err:
        tcf_action_destroy(actions, bind);

The idea is on the higher level we hold refcnt when loading module and
put it back _unconditionally_ when returning, and hold a refcnt only when
we create an action and conditionally put it back when an error happens.
With pseudo code, it is something like this:

load_ops() // module refcnt +1
init_actions(); // module refcnt +1 only when create a new one
if (err)
  // module refcnt -1 when we delete one
  module_put();
module_put(); // module refcnt -1

This looks much easier to track. What do you think?

Thanks!
