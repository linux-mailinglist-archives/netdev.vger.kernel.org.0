Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E16A65741B
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 09:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiL1ImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 03:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiL1Ilb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 03:41:31 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42972F008
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 00:41:25 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h192so5348702pgc.7
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 00:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yvj55CUZVCpdK9tC6JA3gmtuDAM/gaelNridt/7u11Y=;
        b=cb+ADU30lE5jSgFfBK/kMZi0PzvidhODTaEE7xHcKyktscW9t4vCWBMb3tVC/EidBw
         FkUqjauT4GkFaF2azPDNSag6bOtg+yRmRqYNT61vDwlrG/yeD+sWBMGaDXZg8ePghHwb
         283AVV0pLzDkix9N2DmzIcfF2FL6eLcH9iNdpSh27Crj1UrZPLb+OvUJL/eMuvdS37tL
         cL+Wyv9sHOnLiLEEtOozX8h293ISYNR/0yHaz42Nvten26mBSR1ucb/+jzc3Jh098w14
         k3pTU1xGwsTiU4PVJE37cQjPMoAQYxwXzN9RVLOqw8ar30ivhWD+/2Jz4rVV8oZlfpO0
         QcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvj55CUZVCpdK9tC6JA3gmtuDAM/gaelNridt/7u11Y=;
        b=3pUT8pZ61XmGi9H4xYyYEZCu5RFdtMKCECUzNpYhqkeiCOinn+go38HcjN6GL3gAqo
         IjnVY4o2px8ZamJwO5KlAbQZVA+la0uFc0H9N6Nd0tmZfnn4YgywVXU9/gJmy05IZ0Au
         Z8kNtDRpxYKU+qt9vdH3ISMzNCmdRr/PNKCovUY6DwtOTwnsIPXCk30+g7bOd0WxCbUO
         hQ3bMt+smejpDDx4rJrp7AoGOdWYTkk5qFoBoq/oO04/b4bkJQJ7IODdmfoTDXUt21qN
         iwRHbs0EP4ZcUqG9jlbGF62tsh1mONhkzdZ4LXD33sGcW5vEQEXO064AfSG/cZnx8f9J
         NaMw==
X-Gm-Message-State: AFqh2krIDjoHMoze8Q2vui5OFs3qQO4Fqhq/9yT0OOelF+BgLk1LyiYI
        ms6PmpOAVBduu4HZjm8MG5q1CqntXzi+yE+U
X-Google-Smtp-Source: AMrXdXvtVbV680kBX71/OxS4ndQ5sX0d+9L8r6vPPbDJ8i86kNTDQ2Iz/7Tur4YNzYQaQlmY7jiiWQ==
X-Received: by 2002:a62:5245:0:b0:581:2c4f:e969 with SMTP id g66-20020a625245000000b005812c4fe969mr9409027pfb.5.1672216884937;
        Wed, 28 Dec 2022 00:41:24 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 21-20020a621515000000b005813aec74bdsm4177777pfv.139.2022.12.28.00.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 00:41:24 -0800 (PST)
Date:   Wed, 28 Dec 2022 16:41:19 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
Message-ID: <Y6wBLyUfRT2p/6UJ@Laptop-X1>
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org>
 <Y6QLz7pCnle0048z@Laptop-X1>
 <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org>
 <Y6UUBJQI6tIwn9tH@Laptop-X1>
 <CAM0EoMndCfTkTBhG4VJKCmZG3c58eLRai71KzHG-FfzyzSwbew@mail.gmail.com>
 <Y6ptX6Sq+F+tE+Ru@Laptop-X1>
 <CAM0EoM=rMPpXEs6xdRvfJtXFo8OjtGiOOMViFuWR7QiRQfx7DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=rMPpXEs6xdRvfJtXFo8OjtGiOOMViFuWR7QiRQfx7DA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 11:23:23AM -0500, Jamal Hadi Salim wrote:
> Hi Hangbin,
> 
> On Mon, Dec 26, 2022 at 10:58 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > Hi Jamal,
> > On Mon, Dec 26, 2022 at 11:31:24AM -0500, Jamal Hadi Salim wrote:
> > > My only concern is this is not generic enough i.e can other objects
> > > outside of filters do this?
> > > You are still doing it only for the filter (in tfilter_set_nl_ext() -
> > > sitting in cls_api)
> > > As i mentioned earlier, actions can also be offloaded independently;
> > > would this work with actions extack?
> > > If it wont work then perhaps we should go the avenue of using
> > > per-object(in this case filter) specific attributes
> > > to carry the extack as suggested by Jakub earlier.
> >
> > Yes, I think we can do it on action objects, e.g. call tfilter_set_nl_ext()
> > in tca_get_fill:
> >
> > tcf_add_notify() - tca_get_fill()
> >
> > I will rename tfilter_set_nl_ext() to tc_set_nl_ext(). BTW, should we also
> > do it in qdisc/ class?
> >
> > tclass_notify() - tc_fill_tclass()
> > qdisc_notify() - tc_fill_qdisc()
> >
> 
> The only useful cases imo are the ones that do h/w offload. So those two seem
> reasonable. Not sure where you place that tc_set_nl_ext() so it is
> visible for all.

How about put tc_set_nl_ext() to net/sched/sch_generic.c?

Hangbin
