Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C269D6299C3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiKONNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiKONNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:13:44 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908FCB6F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:13:27 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 205so2606123ybe.7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bH4GMmb1KQhQSO19yVF0qTZFCdFPGnUJIyzzOE4zXo8=;
        b=hlqB59kd62ozw6gVOm7dIl1N/E6eE55M7eNdZvIThKfKBAAQ8ZA/19UX/8URNunS76
         mdS8U9YEhlneiTISFo1kDycA/2SZoGx1PZtbvO+WZ7SZS/VBDk2WaWLMVOSFcl07kb0K
         9IdFLNGaeVWv596ZltDYrUls2bBjdPw6qaud6rc8jqRQtXWRD8nJ+6iW1IxcB72ms08V
         1sVDlNKSwdqG1uNnSordZa1MrqSMOdY3pjTDkAzPxq3/5WXbTlCcXMlzVKT/dXpiWaL0
         ocOWCCzDJVqHf4z/64N/43x3AbZKVbdhRI//uTP0aCVw/RuM5Q/nIlT1fc7hZfdJQmlU
         Taiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bH4GMmb1KQhQSO19yVF0qTZFCdFPGnUJIyzzOE4zXo8=;
        b=PxybGoGZ4VD4azkmZu74VEM6nbGsRGvXTP9OhZPpQK2czCt2kcklK81O4YydO8RQUv
         8nmS11mnvjo7cxavgVUQY1ORfLYKu2BEu2e8nAu/pOzJmYDpa8DXzOGD5VYh38oJr+iR
         i1n3lWZSJwUilOFSM4eLjcL/n/O/+7Qi/N2bTBgAGo4BhSxGud+6rzo+12hYN62XseJ2
         56pJKr9/8NL6IknzPiErQY0mn46leraB5Rb+6HYo2qUjWisl2DbBFXVa/DODlQn0xTeO
         2tpK8aUBcyeUt2cy2fBu5qhJNqdwkEOHe/2QIPmSfwUntbAQJWLejlwajZf3f9M+AjaJ
         x4ig==
X-Gm-Message-State: ANoB5pnhSrAMoLpuUzE11rWQMmxhr8iY/sMZEtyUNTuNXJCawfWywTgI
        V+Qup2bi2POSbJdcAF3HD9WqhdBMOpq62jscYEQZlA==
X-Google-Smtp-Source: AA0mqf60i1y+c0ZmAVnz30OO7VHqUpVVte/DcQTgknd/JAm560p248PSlZcXZ7UTzAtbt1XKcgPdo37W3ug/3POs9Yk=
X-Received: by 2002:a25:2d4:0:b0:6d8:99bb:454e with SMTP id
 203-20020a2502d4000000b006d899bb454emr16613937ybc.259.1668518006983; Tue, 15
 Nov 2022 05:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20221102163646.131a3910@kernel.org> <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org> <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org> <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org> <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org> <Y3OJucOnuGrBvwYM@Laptop-X1>
In-Reply-To: <Y3OJucOnuGrBvwYM@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 15 Nov 2022 08:13:15 -0500
Message-ID: <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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

On Tue, Nov 15, 2022 at 7:44 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Mon, Nov 14, 2022 at 08:51:43PM -0800, Jakub Kicinski wrote:
> > > So maybe I should stop on here?
> >
> > It's a bit of a catch 22 - I don't mind the TCA_NTF_WARN_MSG itself
> > but I would prefer for the extack via notification to spread to other
> > notifications.
>
> Not sure if we could find a way to pass the GROUP ID to netlink_ack(),
> and use nlmsg_notify() instead of nlmsg_unicast() in it. Then the tc monitor
> could handle the NLMSG_ERROR directly.
>

That's what I meant. Do you have time to try this? Otherwise i will make time.
Your patch is still very specific to cls. If you only look at h/w
offload, actions can also
be added independently and fail independently as well. But in general this would
be useful for all notifications.

cheers,
jamal
