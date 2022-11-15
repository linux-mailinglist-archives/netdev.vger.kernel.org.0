Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F13629B46
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiKON5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKON5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:57:49 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED681F37
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:57:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 4so13267913pli.0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fARm1ORVDQtghFSakbFeMcDqn60xBvsEeOoLqzs7+/E=;
        b=LmQMLcfmrBa4eOVz5Lc7PpzGVixr/y8oLXcp7aF6DrRs5KuN67MV3Wxn0R52NfBAfh
         XR5trAkDDsoPi8aA1iyvZFmcLmTdeG+PCQfV1tCoeIsM+I7b2lDIhdL+E4WEXQVN9b9x
         pfCPeltIWHpLaKF63bmWZE48JfUCiOuA5C5FMj3djNut37wqBSOlyFG3+saFHJxnVFVO
         S+S+aOhgIDqe9zygzmjruaOytfCYrA5NccTQUm/8LfOsrAYGwDkf6CqhLsKTr4pMf/8K
         z898l/9DxicQr3aisfxmLY3+7vtmfg782+rYZyWq/sYPP5pGwI4WCZyddqbujT9Z2WBq
         ghNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fARm1ORVDQtghFSakbFeMcDqn60xBvsEeOoLqzs7+/E=;
        b=rBRVNN1z4kC8llz/CsAhsfmpEy5CAWxjM13wUXuVr6sbk+gb8/3/IywFcyTJw1NnJx
         206RF0JgSp+KqBMQ5mLjqZsF1Z+cFUMti7YDf4Nkb57Ble28c85WNYNtW+knv3547oEt
         CqB/ZBvd7QI5sJJT9Px+r+Zdj2EHfze3yxIXNyvqnOjfG7NAPja6DfgW8wOxzusSRmUU
         T1gZXPSnu/qQZMVaO1Dtv0NJ33i0S2JiwtgtEqY96LOQeFQ9P9C8zFEVd4jzzvhetTF4
         bf4HmrtU5RBvYQ2+pUf2bsOx9s+Qr3W8DhTaRj61KV1qDHQN0KC2b5X+a3zYx+xyHSoS
         bAOg==
X-Gm-Message-State: ANoB5pkGv7wQkYBRlgEOgzNwbY38qPRC+PD+cA11xQL7BAMX6VyZ09cs
        RoIVLwMTqJsaV7YQOuJpdyo=
X-Google-Smtp-Source: AA0mqf5zt3exgxhnqadzHG+tbdueCFst1KUtByFgsZP+UlC4+mn7jYmfTI4RFJ5Rkp8oyVeWn2bAFA==
X-Received: by 2002:a17:902:a5c3:b0:187:11d:e426 with SMTP id t3-20020a170902a5c300b00187011de426mr4224155plq.91.1668520667468;
        Tue, 15 Nov 2022 05:57:47 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902e74400b00172951ddb12sm9985429plf.42.2022.11.15.05.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 05:57:46 -0800 (PST)
Date:   Tue, 15 Nov 2022 21:57:40 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y3Oa1NRF9frEiiZ3@Laptop-X1>
References: <20221108105544.65e728ad@kernel.org>
 <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org>
 <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org>
 <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org>
 <Y3OJucOnuGrBvwYM@Laptop-X1>
 <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 08:13:15AM -0500, Jamal Hadi Salim wrote:
> > > but I would prefer for the extack via notification to spread to other
> > > notifications.
> >
> > Not sure if we could find a way to pass the GROUP ID to netlink_ack(),
> > and use nlmsg_notify() instead of nlmsg_unicast() in it. Then the tc monitor
> > could handle the NLMSG_ERROR directly.
> >
> 
> That's what I meant. Do you have time to try this? Otherwise i will make time.

Yes, I can have a try.

> Your patch is still very specific to cls. If you only look at h/w
> offload, actions can also
> be added independently and fail independently as well. But in general this would
> be useful for all notifications.

I saw your last mail mean to pass extack to nlmsg_notify() and do
the NLM_F_ACK_TLVS there. This is more agile but need to re-write what
netlink_ack() does. If we pass GROUP ID to netlink_ack() directly, we can
save this work. But from the call path like netlink_rcv_skb() ->
netlink_ack(). I don't have a good way to get the GROUP ID.

Should we write a new helper to convert the GROUP ID from nlmsg_type?
On the other hand, if we add this helper, not suer if we should only
add RTNLGRP_TC first in case other field do not want to multicast the ack
message?

Thanks
Hangbin
