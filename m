Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0661D6983BA
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBOSpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBOSpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:45:21 -0500
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37133D0AD
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:44:49 -0800 (PST)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-5258f66721bso293779797b3.1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IsTIL7qr2+KKhNOl9Nmy1v+6Dt1pH9MgKU5X83JiRW8=;
        b=jYhHSLxs1j1r5DBaUgEkXzX+dm2hRVdou26JvtCgr0wmHl0S9nLVIrSSOVqa/GD4Oi
         TE4ShlMeq7Q4egOw+kUyajFW/pLwGeGl/qx0rHL9RPuY8mE1U49xDKNSaC7Zn0objUK3
         +7PDSxUodZuzrhI4FA9SnXZ1Yxqcy8a0VBZvc7nqv0cRrC7W54JfihWGYu4vGQqBTT99
         xmbCPwPl92T9gdq5x/ZT868WT8sgLqGb/pZetaLIANw701hbJGNSsiXqZ46B9C8OGIH1
         6F2LdwjAcTF0xKDRBxkTA1N+RqYSKW4xt42TtqCKPgVt4UAf46OEX6ekHbplzd1sjyHG
         ZP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IsTIL7qr2+KKhNOl9Nmy1v+6Dt1pH9MgKU5X83JiRW8=;
        b=sFMpQ0ImKo0YEYz1fXVo8gyoy8B70TJ6x9ZBcloOhJHCNkaOduT8E+b/9APOSEB2V1
         7Uii/5CxMM7SWLKrExuS8WBmV4Uhz3gK3wChnAsWIWeLqRApUI3Q7dQMARbuZpElpTWc
         zj0yJ4JnwdBgJf2twMH50kN5oZ5wuvvzIC3LekAnCDerxb9nNlXdqEsBLxn1/+lOZ6W4
         l7lLIBD4DrHC37rEQAuGToQUwgOfgbH3b6ZO96xbd2tmcaF1o12ulIicPVjuopGAJUTN
         Lu2zn5kTLoolBjrFgxT2D4T9peAWUmoGeH4DzkyRZKvM72Zy4fNUlfyD5DCUGi3gtA/u
         ODEA==
X-Gm-Message-State: AO0yUKUZm2qvbrkQzyGg6JAq0eIj8FRqi3fFbmJuKngU1IEtdAodpTeF
        wYJO6+9mhCel2hRDayJmyX5Ape3eAGolUCo/A8hkF1UnsYx/Sw==
X-Google-Smtp-Source: AK7set/kpHzRwcO90lhA0uYDMEtS2O88GCzZPke21YoXQpnxfR1/TYyu3Q0awqu++uz4+GnbcR/AOZtdoCHvRMvCg68=
X-Received: by 2002:a25:2fd4:0:b0:915:a25b:a4de with SMTP id
 v203-20020a252fd4000000b00915a25ba4demr362948ybv.195.1676486323583; Wed, 15
 Feb 2023 10:38:43 -0800 (PST)
MIME-Version: 1.0
References: <20230215034355.481925-1-kuba@kernel.org> <20230215034355.481925-4-kuba@kernel.org>
 <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com> <20230215093505.4b27c8ea@kernel.org>
In-Reply-To: <20230215093505.4b27c8ea@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 15 Feb 2023 13:38:32 -0500
Message-ID: <CAM0EoMmtXbgN2JLVovWfw=kwk9pifPgMQk1DcNkjVRxyFKgw6A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: create and use NAPI version of tc_skb_ext_alloc()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, fw@strlen.de,
        saeedm@nvidia.com, leon@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, roid@nvidia.com, ozsh@nvidia.com,
        paulb@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 12:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 15 Feb 2023 11:50:55 -0500 Jamal Hadi Salim wrote:
> > Dumb question: Would this work with a consumer of the metadata past
> > RPS stage? didnt look closely but assumed per cpu skb_ext because of
> > the napi context - which will require a per cpu pointer to fetch it
> > later.
>
> The cache is just for allocation, specifically for the case where
> driver allocates the skb and it's quickly coalesced by GRO.
> The lifetime of the allocated object is not changed.

ah. That certainly works.

cheers,
jamal
