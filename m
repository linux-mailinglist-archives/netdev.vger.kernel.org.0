Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9382A6585D2
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 19:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiL1SlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 13:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiL1SlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 13:41:05 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B7A12775
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 10:41:04 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o5so15624027wrm.1
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 10:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xWoXykhJPTYLGHM2xeYKlowfV+GzXQkOFpktbQv4Uz4=;
        b=AvFlp4uwTsc2AwPy6iOHe/Xb54qMGw/I+Oa/ayX9s/jn0Ecn0eHdRMPI17fJ+dlsJN
         qUoUwHCND0TSLRtcQX3UDZ8W8J7yO04qLpZn2Tp8IG1djRDYGnYHhe1D7tgJQRxe/aEK
         W6u0OhCRbqIF/puZnBG/ZPQov/73WVqFwwh3IzbkV9pqqcoRrdqibxwu32DKc98kKjAH
         gS/f+MswWde5EC9LAM58LdEBUyhhKiDIP4OtqBXfa6xixvPkcW9Ro3NFn9K2kJtbu+uV
         QqkPuFMX95K1PJ3hZbtTM8kBA/cBUZwQ8OERzd6Ij8x5wNutUfpNPkEbwgK5j9VWRvlN
         jNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xWoXykhJPTYLGHM2xeYKlowfV+GzXQkOFpktbQv4Uz4=;
        b=0GQ+CCRolsoO2lp4LYtbyRDrGMmwPS/cnwYTMhOrO/bbWaxLG5s8sFRcNivFTef96w
         XegvKTug3CWx1TlM2xUYQFs522QFWGCCENkZmMF3ytBvobyHzHDLXBDhjYbsloSWhgtn
         MGwC5bTGxkCjE1AuSP0dY+jvYmvSxf2I1yJQMHpQ05Bq4kNHrHi44qoMhqLmuDkjGdOt
         z3CAdj6bhgE2Ncr3ni6op85JoRFZ131BiubjoU6LEuzbIG6Q9ZYNjwSZIlIU8UH8ikGh
         OI4I0mapt5ZIwIVGoss98gOgxOLC4TffICrqgfA6fAQ/UN9HukRC1leC87JqHdno1Zy6
         EjYQ==
X-Gm-Message-State: AFqh2ko/We7BXVl81JnCaJ/qmY6NNigjJrDQuJJ247c5CBuyO5yZXQfd
        N0B3KAz5C86QrwO2JkItV3rdT5dBDmJWsdrWegaE0Q==
X-Google-Smtp-Source: AMrXdXsqeWYZHD6v60PQ/Zpy6g3TpXVXmCO3SF78RShEjD58IQGvgjtBKdFG5kyq61bIXx+U+q7k+waQ8tYiXGIdIR4=
X-Received: by 2002:a05:6000:100c:b0:242:4d66:d10 with SMTP id
 a12-20020a056000100c00b002424d660d10mr565160wrx.504.1672252863149; Wed, 28
 Dec 2022 10:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20221222191005.71787-1-maheshb@google.com> <20221222181250.23c6a4ee@kernel.org>
In-Reply-To: <20221222181250.23c6a4ee@kernel.org>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 28 Dec 2022 10:40:36 -0800
Message-ID: <CAF2d9jifsKH+67m8QsC9O0_21KiMOPKRU+=M_9xyJ-Y03bMwRw@mail.gmail.com>
Subject: Re: [PATCH next] sysctl: expose all net/core sysctls inside netns
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 6:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Dec 2022 11:10:05 -0800 Mahesh Bandewar wrote:
> > All were not visible to the non-priv users inside netns. However,
> > with 4ecb90090c84 ("sysctl: allow override of /proc/sys/net with
> > CAP_NET_ADMIN"), these vars are protected from getting modified.
> > A proc with capable(CAP_NET_ADMIN) can change the values so
> > not having them visible inside netns is just causing nuisance to
> > process that check certain values (e.g. net.core.somaxconn) and
> > see different behavior in root-netns vs. other-netns
>
> SG, but net-next is closed, please repost after New Year.
My bad, thanks for the note. Happy holidays and will post it next year.
