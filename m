Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800C96411D8
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 01:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiLCAQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 19:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiLCAQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 19:16:19 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BF2D80CC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:16:18 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id g7so9767492lfv.5
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 16:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q6KSjktME/5QLkkECb6V3O4oVTTs3x1Y91tqq5672Ik=;
        b=K6EZlKA3A44iFE9kLp1Jxv1KQoBE3YJolg/DI4Q0r+TwQzy0RA+Dfsac/ONugZCXAq
         vHe/EhNL4FK/NAGMuG0IIX80ibiSSBtuH8OrS8Clr9NNJ9og79CegOLuu76+G8IMHx3+
         8Z/P4npX5x4Fgv/25GUTXJ2gsQrne1hpkMCRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q6KSjktME/5QLkkECb6V3O4oVTTs3x1Y91tqq5672Ik=;
        b=VpHIn8tTxLMENe6Q+v50hFqZaFkxJapuCG5+EfOoCslQkRyS6mrR361TjQ8jSq/EP1
         WajSZkqwzo6dnnmNoHDBn1No6VAykbSgmwhaczrUZan2rukGhtE46vBmVKhAn4BfPKKx
         1/CAbbWEtN2S+hQc3wCo47pNovZUeOXBUz9EQIgY5ZbNF4ikn2oMWOvySPXo5XDLNdd4
         x5a7HGuJqRNcDTuUP11hnVBKn//HpiL9JdJUQDFeUpzns+bJIT4PH+1yfK8jGXDI5ycI
         qkJVijzAdExNxLiHDRH58DEWa66QOuKf+O7hs4O/UoyOIBcBK0dqAvc3QPpzk686MzGj
         gXhw==
X-Gm-Message-State: ANoB5plOPxdDWDLtFmdQf12ImM/O9vT0xBaym78GX7pgn6HAHF6EpDrp
        D2m1yiugh2pakL2gT96C5irJ1Rr6998ZWtmp1i0W5g==
X-Google-Smtp-Source: AA0mqf7hHKF9wuE6fKXIVkCiomYDkbaaZMl9vOFu1DW2te7JaW71sI7RcUy5gQAnNAO+B/2uV1oc/qzbTTtYfShhgF0=
X-Received: by 2002:a05:6512:3248:b0:4aa:148d:5168 with SMTP id
 c8-20020a056512324800b004aa148d5168mr23342800lfr.561.1670026576903; Fri, 02
 Dec 2022 16:16:16 -0800 (PST)
MIME-Version: 1.0
References: <20221202052847.2623997-1-edumazet@google.com> <Y4qPJ89SBWACbbTr@google.com>
 <20221203000325.GL4001@paulmck-ThinkPad-P17-Gen-1> <CAEXW_YQLYnufG2wx9R1xkQYwkugeN=VFf9Dgkfu8WGeYVFLcgw@mail.gmail.com>
In-Reply-To: <CAEXW_YQLYnufG2wx9R1xkQYwkugeN=VFf9Dgkfu8WGeYVFLcgw@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Sat, 3 Dec 2022 00:16:05 +0000
Message-ID: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
To:     paulmck@kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 3, 2022 at 12:12 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Sat, Dec 3, 2022 at 12:03 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Fri, Dec 02, 2022 at 11:49:59PM +0000, Joel Fernandes wrote:
> > > On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> > > > kfree_rcu(1-arg) should be avoided as much as possible,
> > > > since this is only possible from sleepable contexts,
> > > > and incurr extra rcu barriers.
> > > >
> > > > I wish the 1-arg variant of kfree_rcu() would
> > > > get a distinct name, like kfree_rcu_slow()
> > > > to avoid it being abused.
> > >
> > > Hi Eric,
> > > Nice to see your patch.
> > >
> > > Paul, all, regarding Eric's concern, would the following work to warn of
> > > users? Credit to Paul/others for discussing the idea on another thread. One
> > > thing to note here is, this debugging will only be in effect on preemptible
> > > kernels, but should still help catch issues hopefully.
> >
> > Mightn't there be some places where someone needs to invoke
> > single-argument kfree_rcu() in a preemptible context, for example,
> > due to the RCU-protected structure being very small and very numerous?
>
> This could be possible but I am not able to find examples of such
> cases, at the moment. Another approach could be to introduce a
> dedicated API for such cases, where the warning will not fire. And
> keep the warning otherwise.
>
> Example: kfree_rcu_headless()
> With a big comment saying, use only if you are calling from a
> preemptible context and cannot absolutely embed an rcu_head. :-)
>
> Thoughts?
>

Just to clarify, where I was getting at was to combine both ideas:
1. new API with suppression of the new warning mentioned above.
2. old API but add new warning mentioned above.

Cheers,

 - Joel
