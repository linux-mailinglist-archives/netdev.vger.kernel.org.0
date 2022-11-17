Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EB862E34C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiKQRkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiKQRkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:40:12 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D541A1010
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:40:10 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e68so2742629ybh.2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AKl1hHI5se5hw6UJ9agcMcck6mPAULEqYlgEMH+yNFQ=;
        b=Nbf/olEfLZZXz7uiFTazHgrt6PaxZPZNdS17D5K2J6t9KQIhcV+YJjWktIXwgjlTY0
         GpuiEnVuIIP16rXL/3UbqClkbwxNCZrqzxScSlrZvLP42fuOr8KHRjAguMSSGODsgO3E
         /fsoB0TbOFNEtFPXrEqvkEgo7nSdpnV22auDYH5pLwzZ87DEOy5Cf2ivZtCDwIhXk0Eb
         x6+nYZAbCiRu1pxIB1t1ONlwggxNrmOTnUSmjPLsEdS+e9vJkZR8dWcOrYrcHKKgw5E7
         HahCGTyComxOFcxrBBsX9VJWEwWA4Q2sWGTv1JkwK9NcWx8i+fxMsrczZWZaoL+5zpc4
         hyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AKl1hHI5se5hw6UJ9agcMcck6mPAULEqYlgEMH+yNFQ=;
        b=EOkBI5NgHY5wB2XlhAwngqRhgArKOHLnw2OTM93xMpCGc7dFoIMLcApk/y0MOZOh/l
         iOe5RXOX+t6OKCxf+AjwKNAV40VirGnrGM3aaGoVGfSaYITGUvy/y/huNCZoqYaEfE9F
         MMp5B+IUcIilGYp+weY8BCf9PlEaofPmYFjDaCc6YrCFYsqhO1tniUF56GilrQdlvkrq
         8J4fzH1ypwNfLP0DPUbWE2PqNtg+GgyqkLAxZR/Q6tJsLBhNZ6+dQkQ9nDparEjDnMgI
         CNemNu9gEZvoyb56YkAOztdR7Ftz5gdBImidSBiPJNmgubhaCkQkR4f+DKnt+PVlTYqi
         Ox0A==
X-Gm-Message-State: ANoB5pmjfohPd+d22b4mIV7Ctac1OJPSjWlUSkAUl82Cqu4Nl3Fg/CaN
        rc+nx177FErAa82HHMeJvfN9hpUCLVXW0cSka7hjdw==
X-Google-Smtp-Source: AA0mqf6uttxSWotz+Oayev08TSggx/5dMxILtzURgKDg1t+nWq4ImxvQ68Ne+mSpn5oyL8Ufjg4XsybtkACdF+cJR5c=
X-Received: by 2002:a05:6902:11cd:b0:6e7:f2ba:7c0f with SMTP id
 n13-20020a05690211cd00b006e7f2ba7c0fmr1182001ybu.55.1668706809796; Thu, 17
 Nov 2022 09:40:09 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-3-joel@joelfernandes.org> <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
 <Y3ZaH4C4omQs1OR4@google.com> <CANn89iJRhr8+osviYKVYhcHHk5TnQQD53x87-WG3iTo4YNa0qA@mail.gmail.com>
 <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
In-Reply-To: <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 09:39:57 -0800
Message-ID: <CANn89i+9XRh+p-ZiyY_VKy=EcxEyg+3AdtruMnj=KCgXF7QtoQ@mail.gmail.com>
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
        jiejiang@google.com, Thomas Glexiner <tglx@linutronix.de>
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

On Thu, Nov 17, 2022 at 9:38 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Thu, Nov 17, 2022 at 5:17 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > Hello Eric,
> > >
> > > On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
> > > > On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> > > > <joel@joelfernandes.org> wrote:
> > > > >
> > > > > In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> > > > > causes a networking test to fail in the teardown phase.
> > > > >
> > > > > The failure happens during: ip netns del <name>
> > > >
> > > > And ? What happens then next ?
> > >
> > > The test is doing the 'ip netns del <name>' and then polling for the
> > > disappearance of a network interface name for upto 5 seconds. I believe it is
> > > using netlink to get a table of interfaces. That polling is timing out.
> > >
> > > Here is some more details from the test's owner (copy pasting from another
> > > bug report):
> > > In the cleanup, we remove the netns, and thus will cause the veth pair being
> > > removed automatically, so we use a poll to check that if the veth in the root
> > > netns still exists to know whether the cleanup is done.
> > >
> > > Here is a public link to the code that is failing (its in golang):
> > > https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env/env.go;drc=6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=161
> > >
> > > Here is a public link to the line of code in the actual test leading up to the above
> > > path (this is the test that is run:
> > > network.RoutingFallthrough.ipv4_only_primary) :
> > > https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/routing_fallthrough.go;drc=8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=52
> > >
> > > > > Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> > > > > call_rcu_flush() to revert to the old behavior. With that, the test passes.
> > > >
> > > > What is this test about ? What barrier was used to make it not flaky ?
> > >
> > > I provided the links above, let me know if you have any questions.
> > >
> > > > Was it depending on some undocumented RCU behavior ?
> > >
> > > This is a new RCU feature posted here for significant power-savings on
> > > battery-powered devices:
> > > https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPad-P17-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
> > >
> > > There is also an LPC presentation about the same, I can dig the link if you
> > > are interested.
> > >
> > > > Maybe adding a sysctl to force the flush would be better for functional tests ?
> > > >
> > > > I would rather change the test(s), than adding call_rcu_flush(),
> > > > adding merge conflicts to future backports.
> > >
> > > I am not too sure about that, I think a user might expect the network
> > > interface to disappear from the networking tables quickly enough without
> > > dealing with barriers or kernel iternals. However, I added the authors of the
> > > test to this email in the hopes he can provide is point of views as well.
> > >
> > > The general approach we are taking with this sort of thing is to use
> > > call_rcu_flush() which is basically the same as call_rcu() for systems with
> > > CALL_RCU_LAZY=n. You can see some examples of that in the patch series link
> > > above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU so its only
> > > Android and ChromeOS that are using it. I am adding Jie to share any input,
> > > he is from the networking team and knows this test well.
> > >
> > >
> >
> > I do not know what is this RCU_LAZY thing, but IMO this should be opt-in
>
> You should read the links I sent you. We did already try opt-in,
> Thomas Gleixner made a point at LPC that we should not add new APIs
> for this purpose and confuse kernel developers.
>
> > For instance, only kfree_rcu() should use it.
>
> No. Most of the call_rcu() usages are for freeing memory, so the
> consensus is we should apply this as opt out and fix issues along the
> way. We already did a lot of research/diligence on seeing which users
> need conversion.
>
> > We can not review hundreds of call_rcu() call sites and decide if
> > adding arbitrary delays cou hurt .
>
> That work has already been done as much as possible, please read the
> links I sent.

Oh well. No.

I will leave it to other folks dealing with this crazy thing.
