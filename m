Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58035F0D7A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiI3OZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiI3OZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:25:14 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B447D1F2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:25:11 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-131ea99262dso3338969fac.9
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=rURUKpfHlv+/hN/NdRFTYQ4W/O6UZsC8C13rSOpi/nk=;
        b=3Rt3IRcTUBfK7xn45e9sX12Sruhum7bK9rP0O20GLYHqNhPPnnuSREmaVnc/1UETln
         8gsPWQ5IG6rYjt9VUIEheku9e5EaawZIa9kYIH/yl+W+FzENLPLGloEgxCg+Y2mAjVqn
         xjRGQGNd2pK2mpU5q9DI+GgNDJtYBO9qzeq4hg/HhNoSy8e4b9HFFYI2w+znArW9ewlO
         /mAAswP/EK50GHg+3UD58XJlM3qnmjZ6ZEJKSdRKubS83lgPKhg2WJiDvLLhs/4hIyd2
         sj7oHjao69ZV6M7lNDRZHGQg6722XmNYqmqbPnweJLAZsbKWsxQoP+e/UXB58mThoHyD
         kNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=rURUKpfHlv+/hN/NdRFTYQ4W/O6UZsC8C13rSOpi/nk=;
        b=0RP191L50EhTpVICcRXGii8l4ZDfxjcFCXojGke5ttIxbK8piJSCwd8E12HmwFXGWv
         dkrWhY/D9K0qoeA8t4rO5Z6Q00FzQ+YpPkXIttD9VRY5LZzttvCjQswVjm23urowl6jF
         OchjMJATXiJlOn7p/jQ9jpu5aY0jmCawoOwxhLun4l1iEDPLf/zJ9ieWjkbqPS39PuQj
         LmegN1SMZQ06GzloSdbZ2CO3+OXOtPkJ/+vjECDm0j3IVqYAl6yTeoqiPCHBFn2utYqf
         E9wQ0+SlLCnifubFE7yTcN9gPsiilapsr6hV6RibVQcemPH+vnRy3hdGVK8p03dVu3un
         5i6A==
X-Gm-Message-State: ACrzQf2E/qUaDmt3qJe2J7Gp5PCpSoodySlyCXUyLowPZ2xmx/VIo/Gv
        nFfkyT9rX6VlsS8xILpaaIhZ9KDu7km3qbvI3wYGVA==
X-Google-Smtp-Source: AMsMyM4fnze3q+rYBkEWM2FBDAbtYpRZJZdHD79tagKsyis0dLueLkmMb6ij0YCfkdgrlXrKe7g5B2Wxny70RBd14I4=
X-Received: by 2002:a05:6870:609c:b0:131:c972:818f with SMTP id
 t28-20020a056870609c00b00131c972818fmr4782107oae.2.1664547911139; Fri, 30 Sep
 2022 07:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220927212306.823862-1-kuba@kernel.org> <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org> <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
 <c3033346-100d-3ec6-0e89-c623fc7b742d@blackwall.org>
In-Reply-To: <c3033346-100d-3ec6-0e89-c623fc7b742d@blackwall.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 30 Sep 2022 10:24:59 -0400
Message-ID: <CAM0EoMnpSMydZvQgLXzoqAHTe0=xx6zPEaP1482qHhrTWGH_YQ@mail.gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 7:29 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 30/09/2022 14:07, Jamal Hadi Salim wrote:
> > On Wed, Sep 28, 2022 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
> >>> The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
> >>> bulk delete to mdbs as well, and IIRC there were plans for other object types.
> >>> I can update the doc once they are applied, but IMO it will be more useful to explain
> >>> why they are used instead of who's using them, i.e. the BULK was added to support
> >>> flush for FDBs w/ filtering initially and it's a flag so others can re-use it
> >>> (my first attempt targeted only FDBs[1], but after a discussion it became clear that
> >>> it will be more beneficial if other object types can re-use it so moved to a flag).
> >>> The first version of the fdb flush support used only netlink attributes to do the
> >>> flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
> >>> finally settled on the flag[3][4] so everyone can use it.
> >>
> >> I thought that's all FDB-ish stuff. Not really looking forward to the
> >> use of flags spreading but within rtnl it may make some sense. We can
> >> just update the docs tho, no?
> >>
> >> BTW how would you define the exact semantics of NLM_F_BULK vs it not
> >> being set, in abstract terms?
> >
> > I missed the discussion.
> > NLM_F_BULK looks strange. Why pollute the main header? Wouldnt NLM_F_ROOT
> > have sufficed to trigger the semantic? Or better create your own
> > "service header"
> > and put fdb specific into that object header? i.e the idea in netlink
> > being you specify:
> > {Main header: Object specific header: Object specific attributes in TLVs}
> > Main header should only be extended if you really really have to -
> > i.e requires much
> > longer review..
> >
>
> I did that initially, my first submission used netlink attributes specifically
> for fdbs, but then reviews suggested same functionality is needed for other object types
> e.g. mdbs, vxlan db, neighbor entries and so on. My second attempt added a new RTM_ msg type that
> deletes multiple objects, and finally all settled on the flag because all families can
> make use of it, it modifies the delete op to act on multiple objects. For more context please
> check the discussions bellow [1] is my first submission (all netlink), [2] is RTM_
> and [3][4] are the flag:

I think what you are looking for is a way to either get or delete
selective objects
(dump and flush dont filter - they mean "everything"); iow, you send a filtering
expression and a get/del command alongside it. The filtering
expression is very specific
to the object and needs to be specified as such a TLV is appropriate.

Really NLM_F_ROOT and _MATCH are sufficient. The filtering expression is
the challenge.
"functionality is needed for other objects" is a true statement; the question is
whether we keep hacking into the kernel for these filtering expressions.
An idea i toyed with at one point was to send alongside the netlink
request a lua
program that will execute your selector. Then you dont have to keep hacking
and extending netlink TLVs or adding more to the kernel.
Lua is very appealing because you dont have to compile anything - and the
whole program goes into the kernel as a string.
Second best alternative could be to install a bpf program as your selector and
invoke it from netlink code to select the entries that get deleted or returned.
You will have to keep transactional state.

cheers,
jamal
