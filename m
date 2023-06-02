Return-Path: <netdev+bounces-7568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E46720A01
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E86281A77
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B041E535;
	Fri,  2 Jun 2023 19:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB851E510
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:44:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3191A4
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685735037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mcN5AdUPgGMDaOClfPnHhOH2Cz/TnbTqpdlQW/RhZ/Y=;
	b=IRaOQ23gkUgU6FI5e27Zn3usC0yljH6XkgsmvcTAgzR1VJSZGwKDy5VGMk1S/yFy9NHwIg
	DI8QGdAI6Wga04WY1zBXY3HN7xpzYKUfKAB9khVaCgdbGgE/AYXtFr1OCfCKEoA6vGGg8W
	54HtSBidAr6Yd7SCjXi7BDeLcpa9K3g=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-FfPrzsO9NCmMmOpdoa_pgQ-1; Fri, 02 Jun 2023 15:43:56 -0400
X-MC-Unique: FfPrzsO9NCmMmOpdoa_pgQ-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4630577fedcso47504e0c.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 12:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685735035; x=1688327035;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mcN5AdUPgGMDaOClfPnHhOH2Cz/TnbTqpdlQW/RhZ/Y=;
        b=dN7YbM0+nRweZUGo4HcdlHnmxDRHk4cAck6XwnxZexqQ/xVpNCSg1VACJ3YXPPXtf/
         OJ6+LWgUEOOaxj5wTxhJ3YL2j/x6HLuImpmstYZqzokfqoLpChWl3RXcAWdOBMzgoJ0Y
         W0beHDryl0X+M3htdoAyAk1cRI9jj0NYq1z7VLmdKx7I/b+z8SCX3+NbcZM56+JcZToF
         2J0LQPlB/Nt5C0jGDziHbEgowvjvasLmVNJ0SmYoHz8q9qRqinwHzteiwkhlJmbYzHln
         bnNfonWuABdiek6BXIAgWPRiPUSDe8TFBubNV3ZEt0P2DGZh3oQz0qg63z4k4fLut+6Q
         OxpQ==
X-Gm-Message-State: AC+VfDwOLh5TIyAUPRr1t2Gzk1IX2EJU82kAr/WuSvKLhUkrvLdF6hyy
	HZ+E5/8JWWXtCKztKXEE2D5LKXyt+S4+OoMmgoF+IEWbwH/mWutZ0gViclqwMKY4Pqnh4Rid+WY
	YZk6kXO5Y+0ItQtKkBYnYOXZeLcI8/RXd
X-Received: by 2002:a05:6102:3d0:b0:439:31ea:7121 with SMTP id n16-20020a05610203d000b0043931ea7121mr6728263vsq.10.1685735035578;
        Fri, 02 Jun 2023 12:43:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Fh3tVUx+vUbmcAtfgUULGOjLqV2timqhE7AM5h5nWF3f5GckFQr4OHanH3RFKC8qMHsXCGzYxi6KD7DYMKcY=
X-Received: by 2002:a05:6102:3d0:b0:439:31ea:7121 with SMTP id
 n16-20020a05610203d000b0043931ea7121mr6728248vsq.10.1685735035330; Fri, 02
 Jun 2023 12:43:55 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 12:43:54 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-7-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110232.29349-7-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 12:43:54 -0700
Message-ID: <CALnP8ZZ60R3ToiKfTkF6JTA6UpL4=6D+D1b37b1S8_2OA-sGqA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 07/28] net/sched: act_api: add struct
 p4tc_action_ops as a parameter to lookup callback
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:11AM -0400, Jamal Hadi Salim wrote:
> @@ -115,7 +115,8 @@ struct tc_action_ops {
>  		       struct tcf_result *); /* called under RCU BH lock*/
>  	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
>  	void	(*cleanup)(struct tc_action *);
> -	int     (*lookup)(struct net *net, struct tc_action **a, u32 index);
> +	int     (*lookup)(struct net *net, const struct tc_action_ops *ops,
> +			  struct tc_action **a, u32 index);
>  	int     (*init)(struct net *net, struct nlattr *nla,
>  			struct nlattr *est, struct tc_action **act,
>  			struct tcf_proto *tp,
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index ba0315e686bf..788127329d96 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -728,7 +728,7 @@ int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
>  	struct tc_action_net *tn = net_generic(net, ops->net_id);
>
>  	if (unlikely(ops->lookup))
> -		return ops->lookup(net, a, index);
> +		return ops->lookup(net, ops, a, index);

Interesting. I could swear that this patch would break the build if
only up to this patch was applied (like in a git bisect), but then,
currently no action is defining this method. :D

  Marcelo


