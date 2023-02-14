Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E49696D4A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjBNStT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbjBNStK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:49:10 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8666302BD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 10:48:39 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id di14so6841837qvb.12
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 10:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7KGDz9BEgwQtLaI47a2P6tiBiByET2KL4fGTQlZcbDw=;
        b=kvfXBvQMwyEywhm+p1n6cIv+Nu0zNqUUftWUQxJrKRNZhE/cGOz9ydL0fI0YYASCRE
         TvOUrKqw1nFQjvBwtLMukwtVzTfudtOSD2tWmMp7oN4yZYZXQEt7h8lKh1LVEDtIpoI5
         R1PGfOUrXI3L9aFBommeUAGmzJn/nRBg/NyctoKTuIrh+xhBfWPH/11bMRuZhBbG7Az/
         vjoTsoeqREF8bD9q1com0OntJEnx2umRj2G8H3X17VufHcRpI+Mihu+aItPUVT6km2tF
         mkei3Y6r7Wby0hDHDfzf/iEINpRoL83OCwwz7YBKnf1csYxDQkXuZwUFpFpuG3EnYwaw
         GjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KGDz9BEgwQtLaI47a2P6tiBiByET2KL4fGTQlZcbDw=;
        b=VQP+/vUXOmwRlINtOvSEVRnmYRtGlHzs6Xqj11PwGB7Nd0xITgbfm075sCSeD15KBk
         p1Gj9MR25NntLxC04QwLTIRCcrSCOe4ljL89+bQbr0FRfhW3AYmZzTu83BmNWC1K+ndA
         iKFdJfpWOhYIvw5nIFUT7vOLhcfYD7U1opCNvy74j3WmBIiXCn+Ap8jFcLvlHmjYPEC4
         t4lqoy1FITZNvM+RB+3AgisNuy+SgSkA44b5bNwYC9tCzYtnDpIcQqQE3YMs+ul4eOoP
         4YooqGz4OsIVuGFFuJ+G7MUFjdL/GPVDlHpIGRHk6JS6uIXUhhJo6AL+Cz2+i77J1CFD
         aPoA==
X-Gm-Message-State: AO0yUKUWNksqyIjj1vMWQ8JFSkeR+DBnRWDD3yJU+ORQs2htyevARM5o
        atfb0y+FP8F21RkXgZis2Bg=
X-Google-Smtp-Source: AK7set/ZdPl3Z11NibgFm2I0k+YV+uwapgkrei8KLokxBTrxDlX8EW+avliRnRlHshzElbhvKbvZkw==
X-Received: by 2002:a05:6214:29eb:b0:56e:9551:196a with SMTP id jv11-20020a05621429eb00b0056e9551196amr6931407qvb.1.1676400518784;
        Tue, 14 Feb 2023 10:48:38 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id t73-20020a37464c000000b007186c9e167esm12274235qka.52.2023.02.14.10.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 10:48:38 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id EF6944C2548; Tue, 14 Feb 2023 10:48:36 -0800 (PST)
Date:   Tue, 14 Feb 2023 10:48:36 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y+vXhDvkFL3DBqJu@t14s.localdomain>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-2-paulb@nvidia.com>
 <20230210022108.xb5wqqrvpqa5jqcf@t14s.localdomain>
 <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
 <Y+qE66i7R01QnvNk@t14s.localdomain>
 <a3f14d60-578f-bd00-166d-b8be3de1de20@nvidia.com>
 <8232a755-fea4-6701-badc-a684c5b22b20@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8232a755-fea4-6701-badc-a684c5b22b20@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 02:31:06PM +0200, Oz Shlomo wrote:
> 
> On 14/02/2023 14:14, Paul Blakey wrote:
> > On 13/02/2023 20:43, Marcelo Ricardo Leitner wrote:
> > > On Mon, Feb 13, 2023 at 06:13:34PM +0200, Paul Blakey wrote:
> > > > On 10/02/2023 04:21, Marcelo Ricardo Leitner wrote:
> > > > > On Mon, Feb 06, 2023 at 07:43:57PM +0200, Paul Blakey wrote:
> > > > > > For drivers to support partial offload of a filter's action list,
> > > > > > add support for action miss to specify an action instance to
> > > > > > continue from in sw.
> > > > > > 
> > > > > > CT action in particular can't be fully offloaded, as new connections
> > > > > > need to be handled in software. This imposes other limitations on
> > > > > > the actions that can be offloaded together with the CT action, such
> > > > > > as packet modifications.
> > > > > > 
> > > > > > Assign each action on a filter's action list a unique miss_cookie
> > > > > > which drivers can then use to fill action_miss part of the tc skb
> > > > > > extension. On getting back this miss_cookie, find the action
> > > > > > instance with relevant cookie and continue classifying from there.
> > > > > > 
> > > > > > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > > > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > > > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > > > > Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > > > ---
> > > > > >    include/linux/skbuff.h     |   6 +-
> > > > > >    include/net/flow_offload.h |   1 +
> > > > > >    include/net/pkt_cls.h      |  34 +++---
> > > > > >    include/net/sch_generic.h  |   2 +
> > > > > >    net/openvswitch/flow.c     |   3 +-
> > > > > >    net/sched/act_api.c        |   2 +-
> > > > > >    net/sched/cls_api.c        | 213 +++++++++++++++++++++++++++++++++++--
> > > > > >    7 files changed, 234 insertions(+), 27 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > > > > index 1fa95b916342..9b9aa854068f 100644
> > > > > > --- a/include/linux/skbuff.h
> > > > > > +++ b/include/linux/skbuff.h
> > > > > > @@ -311,12 +311,16 @@ struct nf_bridge_info {
> > > > > >     * and read by ovs to recirc_id.
> > > > > >     */
> > > > > >    struct tc_skb_ext {
> > > > > > -	__u32 chain;
> > > > > > +	union {
> > > > > > +		u64 act_miss_cookie;
> > > > > > +		__u32 chain;
> > > > > > +	};
> > > > > >    	__u16 mru;
> > > > > >    	__u16 zone;
> > > > > >    	u8 post_ct:1;
> > > > > >    	u8 post_ct_snat:1;
> > > > > >    	u8 post_ct_dnat:1;
> > > > > > +	u8 act_miss:1; /* Set if act_miss_cookie is used */
> > > > > >    };
> > > > > >    #endif
> > > > > > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > > > > > index 0400a0ac8a29..88db7346eb7a 100644
> > > > > > --- a/include/net/flow_offload.h
> > > > > > +++ b/include/net/flow_offload.h
> > > > > > @@ -228,6 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
> > > > > >    struct flow_action_entry {
> > > > > >    	enum flow_action_id		id;
> > > > > >    	u32				hw_index;
> > > > > > +	u64				miss_cookie;
> > > > > The per-action stats patchset is adding a cookie for the actions as
> > > > > well, and exactly on this struct:
> > > > > 
> > > > > @@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
> > > > >    struct flow_action_entry {
> > > > >           enum flow_action_id             id;
> > > > >           u32                             hw_index;
> > > > > +       unsigned long                   act_cookie;
> > > > >           enum flow_action_hw_stats       hw_stats;
> > > > >           action_destr                    destructor;
> > > > >           void                            *destructor_priv;
> > > > > 
> > > > > There, it is a simple value: the act pointer itself. Here, it is already more
> > > > > complex. Can them be merged into only one maybe?
> > > > > If not, perhaps act_cookie should be renamed to stats_cookie then.
> > > > I don't think it can be shared, actions can be shared between multiple
> > > > filters, while the miss cookie would be different for each used instance
> > > > (takes the filter in to account).
> > > Good point. So it would at best be a masked value that part A works
> > > for the miss here and part B for the stats, which is pretty much what
> > > the two cookies are giving, just without having to do bit gymnasics,
> > > yes.
> > act cookie is using 64 bits (to store the pointer and void a mapping), and I'm using at least
> > 
> > 32bits, so there is not simple type that will contain both.
> > 
> > So I'll rename the act_cookie to stats_cookie once I rebase.
> > 
> The current act_cookie uniquely identifies the action instance.
> 

While miss_cookie also uniquely identifies the action, within a filter list.
Or, miss_cookie uniquely identifies an action configuration.

> I think it might be used in other use cases and not just for stats.

I don't disagree.

> 
> Actually, I think the current naming scheme of act_cookie and miss_cookie
> makes sense.

act_cookie is actually already used (and differently) in tc_action itself here:
1045ba77a596 ("net sched actions: Add support for user cookies")

With this, IMO it is tough to know which one takes precedence where.

Then perhaps,
act_cookie here -> instance_cookie
miss_cookie -> config_cookie

Sorry for the bikeshedding, btw, but these cookies are getting
confusing. We need them to taste nice :-}
