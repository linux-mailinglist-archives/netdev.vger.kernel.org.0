Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205DF2FDE8B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388444AbhAUBL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 20:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391901AbhAUBKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 20:10:03 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E7EC0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 17:09:23 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m6so425704pfm.6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 17:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZV+XonpfWCiGtxFl9R/bsaR6/VXbkXHhE9Oc5dE5nA=;
        b=UxKxW6tVNqEuc4CLZq4D4Z2SiMToUoEi01PImAhLo10mMVf958ihyUsDhed/aSQYQC
         iVkSxUK191HT5xF312yy+CeyabptGAW8Gk8r9sJCbruJ9eBzUawAnnwva+6q87y+yN9W
         O2ofVq9Bv3fGYSztbS3iXH3evx4jGe5bi01Apqk6hnvGIPk2wnhfI9RgI7JfMdpa9om4
         tfyoxkSQLcgrtAbVnP+czKDgvHusvMH8E2IN9RJZ1bXQbLUU+NDAOe7Dk+f2APYNg/Oo
         SyRvgX5vvLYi8xzRxS7kKAtEymVAHmq31MmmAurmql1IAVe8U7tg8qjd/+p7hCwKMbQk
         QSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZV+XonpfWCiGtxFl9R/bsaR6/VXbkXHhE9Oc5dE5nA=;
        b=NP/fi8rRWFZm1fQ0wh3Qjbv9Q9X6ZJBaNzn9d1AYfxv+cAnHwN9UWeaqq9neJpZeBY
         TR9syHxvgSOGTqQ3cvXWaD6EHEYYfqQLeX4X8jAzBlUL6Wd+vDQaZsf1UZRhYZH3kP7y
         hNk5XiNG1/4vbJVLx6oHyGTZg0FXYxs5lJtVCetjECc1grFrzlivFoeXLqY7JEcTuFmd
         6HEDQ1YUhUvdZ6uuLJHtcnLZJi5YYpAOXHSmAdnLOl6smXNLLe4jr75eOVLtlG6mXFlk
         OTLnArOmuwQAMpqEK7TEiTU7PaqHvtpcKl8HqK+OVQqlNGAYnRslJ04KWFzDxmSYSmLR
         Yptg==
X-Gm-Message-State: AOAM532K/CUtdyh8prQ/ln4rTQVtrq2pcYv8GQm8tDTHiMxSA/kT4vf8
        tPZL/E45/ufRjd6tB2SPvX6vJ1997w486wH7JQE=
X-Google-Smtp-Source: ABdhPJx6yV7zZu6EvD/IE1XqtZX6ETDiEv9b3CbqhitKnUM5uazwDfu5Bzi2pPdJ+IVtKAbKLT4kjkw+vb/sQqrn0po=
X-Received: by 2002:a05:6a00:88b:b029:19c:780e:1cd with SMTP id
 q11-20020a056a00088bb029019c780e01cdmr11481245pfj.64.1611191362543; Wed, 20
 Jan 2021 17:09:22 -0800 (PST)
MIME-Version: 1.0
References: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVs5WOS0-Y7RvpOr12F8u84Rwna8EQ0NzuFof7Suc7Wyw@mail.gmail.com> <20210120234045.GC3863@horizon.localdomain>
In-Reply-To: <20210120234045.GC3863@horizon.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 20 Jan 2021 17:09:11 -0800
Message-ID: <CAM_iQpX7TSB1f4SY-tapnsGQr6HXv=sfGod9wcFvEd0oign6PQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID
 flag support
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 3:40 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Jan 20, 2021 at 02:18:41PM -0800, Cong Wang wrote:
> > On Tue, Jan 19, 2021 at 12:33 AM <wenxu@ucloud.cn> wrote:
> > > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > > index 2d70ded..c565c7a 100644
> > > --- a/net/core/flow_dissector.c
> > > +++ b/net/core/flow_dissector.c
> > > @@ -237,9 +237,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
> > >  void
> > >  skb_flow_dissect_ct(const struct sk_buff *skb,
> > >                     struct flow_dissector *flow_dissector,
> > > -                   void *target_container,
> > > -                   u16 *ctinfo_map,
> > > -                   size_t mapsize)
> > > +                   void *target_container, u16 *ctinfo_map,
> > > +                   size_t mapsize, bool post_ct)
> >
> > Why do you pass this boolean as a parameter when you
> > can just read it from qdisc_skb_cb(skb)?
>
> In this case, yes, but this way skb_flow_dissect_ct() can/is able to
> not care about what the ->cb actually is. It could be called from
> somewhere else too.

This sounds reasonable, it is in net/core/ directory anyway,
so should be independent of tc even though cls_flower is its
only caller.

Thanks.
