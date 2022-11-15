Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5F9629F01
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbiKOQ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiKOQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:27:07 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E41DF0A
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:27:06 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id 136so2133033ybn.1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SDTKLYSurT7qM+3OnEx56Vq/amIa5X4SF7DfWiQQ7R4=;
        b=fpKsIy919MpbCLC6SiKd/HWphl73zClpE/qvwUQvMwjnIeah88n/MvLzOGwW3Himn2
         TGPWjXBw1b/UwXH59fhIggqlzN7mw9iL4rm5IRGpbDa1eT/LjQEF3Nq3rqCge/2VgVmj
         rVwHNFhXo8uLzo6GA6jhdPVER12daOfliO5s9zQxZMMFw1QphW8QJltpsobLu7jsRKkl
         OfBC5jfTiBQ0tPp4hvRf7lp0N8pVDhB7j76BS8y3J5W2irr4paH9wfNeArilUevYNu5r
         C8HdnOIg3VifRTHwniu4Q2a5EQ40/VQaX8MbZWu9Pn4kWjEwNXcAgk5Y1D2dfik8g0hP
         EPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDTKLYSurT7qM+3OnEx56Vq/amIa5X4SF7DfWiQQ7R4=;
        b=clTEezBhp7AcoKTGNifx3GgeRfR6LlCufAZz9yjWbhX2UsWbDIimPdWPviqDzsUHFi
         ApOHa8UIlTHT+gcCuxUXOYcJIzuQp1RitYJu33n2x8lDbqioJNCXJDIp5TGDg5Vj0YBx
         YtFNQR1XTXfO8QAUamA0uZc6q0Jqbs7qTzlpsQEClPo50+b34O0usWu5pfImbLNJx5tm
         xtzJFCWJRwHPVQLkCVHlUtv4pOiVwFMNPK/vMrOSnqWYPa7SJo2pqUgHAgYh5Zp8YSHM
         w1z9TUzgqh8HYOXE6NL3YFAq5/04K992AepWg7+JQN23C9T3qUaCGCAxm1D/MHoMz6T1
         MIyw==
X-Gm-Message-State: ANoB5pmROxJYILAQneNsp0MUsAUA08GZB9/wULs4pa51rFb/YzJYVl34
        mTON+R1gfsh4hdu8nVm/sUWYuY2Fx3T5702E6iOGXg==
X-Google-Smtp-Source: AA0mqf4ahJ85CVkaMC9Gvh9aEfTJtKJOUZAt153wD0lnRiHmBZfPEM1nuAS+TGSEE9icvQy5bsYucUc0h6dt/Jh9WIw=
X-Received: by 2002:a25:8286:0:b0:6be:266d:eeec with SMTP id
 r6-20020a258286000000b006be266deeecmr17868939ybk.397.1668529625609; Tue, 15
 Nov 2022 08:27:05 -0800 (PST)
MIME-Version: 1.0
References: <20221108105544.65e728ad@kernel.org> <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org> <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org> <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org> <Y3OJucOnuGrBvwYM@Laptop-X1>
 <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com> <Y3Oa1NRF9frEiiZ3@Laptop-X1>
In-Reply-To: <Y3Oa1NRF9frEiiZ3@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 15 Nov 2022 11:26:54 -0500
Message-ID: <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
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

On Tue, Nov 15, 2022 at 8:57 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Nov 15, 2022 at 08:13:15AM -0500, Jamal Hadi Salim wrote:

> > That's what I meant. Do you have time to try this? Otherwise i will make time.
>
> Yes, I can have a try.
>
> > Your patch is still very specific to cls. If you only look at h/w
> > offload, actions can also
> > be added independently and fail independently as well. But in general this would
> > be useful for all notifications.
>
> I saw your last mail mean to pass extack to nlmsg_notify() and do
> the NLM_F_ACK_TLVS there. This is more agile but need to re-write what
> netlink_ack() does. If we pass GROUP ID to netlink_ack() directly, we can
> save this work. But from the call path like netlink_rcv_skb() ->
> netlink_ack(). I don't have a good way to get the GROUP ID.
>
> Should we write a new helper to convert the GROUP ID from nlmsg_type?
> On the other hand, if we add this helper, not suer if we should only
> add RTNLGRP_TC first in case other field do not want to multicast the ack
> message?
>

Ok, I think i get what Jakub meant by "internal / netlink level attributes" now.
i.e the problem is there is a namespace collision for attributes between
the global NLMSG_ERROR and service local. It is more tricky than i thought.
How were you thinking of storing the extack info into the message?
Note: I wouldnt touch netlink_ack() - maybe write a separate helper for events.

cheers,
jamal
