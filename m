Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F71353B08
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 05:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhDEDKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 23:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbhDEDKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 23:10:15 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839B3C061756;
        Sun,  4 Apr 2021 20:10:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x21so11189243eds.4;
        Sun, 04 Apr 2021 20:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ybUuVGV/ftbkhaL6dd8KgunndxjqVlMExLpZx+2c90=;
        b=TBxj+T6jtZc5CpRQnmGBEmipLj3LGjnLbVtSazOH3ZI2C5g1KFWQyeB2RBrYO/ZCfO
         q0GRCulGutcnLE5RK/qST4tBRC7eavLYvCkYMzkg6ibmZKoyf+TjrVleSLVpaS9lxHnd
         b/XYNOYc/pnPk6TiNu2Rkfp/JGrhnYmMKo853c+G3rPMeQMF61Ro6m41nRy4rNmdsm+T
         OzjnmNkI/GlZ5/jKiHuapARuWARh1pEfTkjsJBI5YQPUsq44yyWkUnuWXX4WrmsxAH1+
         7IxhWaCS7X5ZpZvL5GMAhtaQW5sv28COXO8NgjLRN/jBIKeH9Z7FSS1XvhO/kqteL7CQ
         IEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ybUuVGV/ftbkhaL6dd8KgunndxjqVlMExLpZx+2c90=;
        b=ZyGdWTEQeBhGDn9tAyhXz8TGKy5HQe93JfwPAKh3NB/CMn1qAGApBQ3zrShC15DGFS
         ubl83JUu+5hTB9JuV81W6vzR2FR69O7PbessvXbdWi1tngjBVwqXkCuc54l/i1f46n52
         lqop3QY9TQkRg9QyXwtQYIxVIeOxxnFQySaS/lY9w9V24xTF+9d+PKJPk3gkil1I9a0A
         wgVEhCMaB/2wTnPHZ0WhvNCId16bfXprC69epMoDX/zSpO2zAcbhKoS1BFp4/lsz+YEg
         p0bckVnu4ienGEdH+MccHnmRTdeaSn8Pgjr5/lTmQU50V1PBX3z336nStu68+k7AKKUg
         IyZA==
X-Gm-Message-State: AOAM533npnz4WTzGDlOl1tUH7Kpz0KgRql1ab6NCGZYfbd5U3o7KhsTX
        S5WdIak8aoOmD1Vej8dsQHsSiKsG/K8RfeziH1YKzTsutXk=
X-Google-Smtp-Source: ABdhPJwg/B1NRjSSo1xg3oKdxwJ92yV1R5GKrTHieEcyBsN+BTYRe6XN797UQa0m/k0bZPXnjg1v8A8eDPxRR8D8OF4=
X-Received: by 2002:aa7:d813:: with SMTP id v19mr28961632edq.213.1617592208271;
 Sun, 04 Apr 2021 20:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210404175031.3834734-1-i.maximets@ovn.org> <84e7d112-f29f-022a-8863-69f1db157c10@ovn.org>
In-Reply-To: <84e7d112-f29f-022a-8863-69f1db157c10@ovn.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 5 Apr 2021 11:09:25 +0800
Message-ID: <CAMDZJNXvqMaTxwF2M79ohos0VYpGvjKjMokBv4wrEgej=bdJrA@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: fix send of uninitialized
 stack memory in ct limit reply
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Pravin B Shelar <pshelar@ovn.org>, ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 5, 2021 at 2:01 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> CC: ovs-dev
>
> On 4/4/21 7:50 PM, Ilya Maximets wrote:
> > 'struct ovs_zone_limit' has more members than initialized in
> > ovs_ct_limit_get_default_limit().  The rest of the memory is a random
> > kernel stack content that ends up being sent to userspace.
> >
> > Fix that by using designated initializer that will clear all
> > non-specified fields.
> >
> > Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> > Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> > ---
> >  net/openvswitch/conntrack.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > index c29b0ef1fc27..cadb6a29b285 100644
> > --- a/net/openvswitch/conntrack.c
> > +++ b/net/openvswitch/conntrack.c
> > @@ -2032,10 +2032,10 @@ static int ovs_ct_limit_del_zone_limit(struct nlattr *nla_zone_limit,
> >  static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
> >                                         struct sk_buff *reply)
> >  {
> > -     struct ovs_zone_limit zone_limit;
> > -
> > -     zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
> > -     zone_limit.limit = info->default_limit;
> > +     struct ovs_zone_limit zone_limit = {
> > +             .zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE,
> > +             .limit   = info->default_limit,
> > +     };
I review the code, userspace don't use the count of ovs_zone_lime
struct, but this patch looks to to me.
Thanks Ilya.
Acked-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >       return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
> >  }
> >
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev



-- 
Best regards, Tonghao
