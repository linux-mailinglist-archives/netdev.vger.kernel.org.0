Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F9562E2BD
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbiKQRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiKQRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:17:34 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C2F7C00C
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:17:33 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id k84so2656229ybk.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TfyR42Rw7fajSCS2sVCfl9VRMWqE/0SBTvtxDZ7f2WE=;
        b=qCmP/eA6/5UdR6Qw9Wcp6BWygueNO+fpKceuuW0fRwSaskw4hNdQZGG511optr0DMU
         QBX08dMPfFKcq40jL4Oi1OVErlnaFQQGwsE9V3y91/3Mqkyow+i/sCHJeovnVm9l+/cg
         q9z4uNPnmEzIJOOQ5me7/fPVCFB8/LnVN21KwBZB0dT2/r4mm5da75L4IQZVxwxwTiZ8
         8NDpLCgN0foSY+sa+g3wcjnBcRyA4idrkIWtgkADW+cTZjzo3MiG60440K5bgwkt0KIG
         ypbZiWQc3jq4SP1f2Ad3cfTy19SajhMzIV6zm7Q+EvpyLpOLgqWNCOR+EFHRCFrxIrOz
         7vqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TfyR42Rw7fajSCS2sVCfl9VRMWqE/0SBTvtxDZ7f2WE=;
        b=CRyLXhtTYPkYgoCenG3B6LeEhKQRO7HO7aB5TK6kETSjPlaBk4At3/SY5T26XpXNoV
         5JmhEupTpPmeASbWlO17Sbm83VtIjcj7oZup8HCzfNCT8bW8DYdXGK4hxLpxPUuoWCFV
         kCLGIPR4OUtdpERrGmTplm556/GwpOr6f8X/ErsqeJ23WvdtgiCiR8VHaHapUh/yvtpJ
         wXfexM2JxHikUrsOkO5fE+wlh+BwGxuLcVu+7Rgjn91+2IWsw/YCTmdUTLkVWmRhImG/
         uhMBSfBeqqozLxF3OAaRwZKtT9LrrSito9IWXz9MmFYGbMuajdpl9BEt8JVbRFEdLymE
         TkUQ==
X-Gm-Message-State: ANoB5pmhJKyFoMhFAMO5R+p167Iqh6sBFZrSQoE5BLFjUQr4CVhkyWmv
        l4A8MdUQe/eaZ1zj8U0rK+KlLFJSTshDHM9m9YA4rg==
X-Google-Smtp-Source: AA0mqf73E4+kuvxdg0duH17ARaFj8atik60eG5l6dkv5xwpg4t6aJri+ZCy5XxZ3TixjUfLmq8pnVq3XwD9jewuLhEc=
X-Received: by 2002:a05:6902:11cd:b0:6e7:f2ba:7c0f with SMTP id
 n13-20020a05690211cd00b006e7f2ba7c0fmr1090831ybu.55.1668705452067; Thu, 17
 Nov 2022 09:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-3-joel@joelfernandes.org> <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
 <Y3ZaH4C4omQs1OR4@google.com>
In-Reply-To: <Y3ZaH4C4omQs1OR4@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 09:17:20 -0800
Message-ID: <CANn89iJRhr8+osviYKVYhcHHk5TnQQD53x87-WG3iTo4YNa0qA@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com,
        jiejiang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hello Eric,
>
> On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
> > On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> > <joel@joelfernandes.org> wrote:
> > >
> > > In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> > > causes a networking test to fail in the teardown phase.
> > >
> > > The failure happens during: ip netns del <name>
> >
> > And ? What happens then next ?
>
> The test is doing the 'ip netns del <name>' and then polling for the
> disappearance of a network interface name for upto 5 seconds. I believe it is
> using netlink to get a table of interfaces. That polling is timing out.
>
> Here is some more details from the test's owner (copy pasting from another
> bug report):
> In the cleanup, we remove the netns, and thus will cause the veth pair being
> removed automatically, so we use a poll to check that if the veth in the root
> netns still exists to know whether the cleanup is done.
>
> Here is a public link to the code that is failing (its in golang):
> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env/env.go;drc=6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=161
>
> Here is a public link to the line of code in the actual test leading up to the above
> path (this is the test that is run:
> network.RoutingFallthrough.ipv4_only_primary) :
> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/routing_fallthrough.go;drc=8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=52
>
> > > Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> > > call_rcu_flush() to revert to the old behavior. With that, the test passes.
> >
> > What is this test about ? What barrier was used to make it not flaky ?
>
> I provided the links above, let me know if you have any questions.
>
> > Was it depending on some undocumented RCU behavior ?
>
> This is a new RCU feature posted here for significant power-savings on
> battery-powered devices:
> https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPad-P17-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
>
> There is also an LPC presentation about the same, I can dig the link if you
> are interested.
>
> > Maybe adding a sysctl to force the flush would be better for functional tests ?
> >
> > I would rather change the test(s), than adding call_rcu_flush(),
> > adding merge conflicts to future backports.
>
> I am not too sure about that, I think a user might expect the network
> interface to disappear from the networking tables quickly enough without
> dealing with barriers or kernel iternals. However, I added the authors of the
> test to this email in the hopes he can provide is point of views as well.
>
> The general approach we are taking with this sort of thing is to use
> call_rcu_flush() which is basically the same as call_rcu() for systems with
> CALL_RCU_LAZY=n. You can see some examples of that in the patch series link
> above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU so its only
> Android and ChromeOS that are using it. I am adding Jie to share any input,
> he is from the networking team and knows this test well.
>
>

I do not know what is this RCU_LAZY thing, but IMO this should be opt-in

For instance, only kfree_rcu() should use it.

We can not review hundreds of call_rcu() call sites and decide if
adding arbitrary delays cou hurt .
