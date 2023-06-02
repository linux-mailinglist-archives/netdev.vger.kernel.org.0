Return-Path: <netdev+bounces-7566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A09B7209E8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7B5F1C20EEC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E03F1E529;
	Fri,  2 Jun 2023 19:36:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803861E510
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:36:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24062198
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685734597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2CUCXI96yir6udrUWzudogfb6Fk60GzSPA2Rq+YK7A=;
	b=fQI/PnPvIMYCXtYQHw2CctkT5+VOTlWgkuIuunxmJ+0hY3qZo+0/ScF3CeU0bHDVPTIJFW
	4E299EddImeWC3CmWRbT9Z8go14UUvUExBqnpQLY0B4Z/R0iuocBNmwLZnyaoa/ze5CxIU
	o6o5SBPJ8qgVKcOysf356XWDfyzo4X4=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-1iy-RfoNMR6rI3ZwPBgw7g-1; Fri, 02 Jun 2023 15:36:36 -0400
X-MC-Unique: 1iy-RfoNMR6rI3ZwPBgw7g-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-437e4ab227bso701168137.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 12:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685734596; x=1688326596;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2CUCXI96yir6udrUWzudogfb6Fk60GzSPA2Rq+YK7A=;
        b=WOipWV9Vlpt+n4/pVKeWWV7KGCuqtMkWd9r0XOYqolsgDigTw/m0eyCO1Z6tDJHDD3
         WBTB4sdKfScyJNpO/2tiZuAUSmH2IqeHCIdFCX5g2nRavQ0f4gmUjqqytPRjWLiXCcxv
         GMmYZFDZL+JbYnwRINtBSgQg5e504DGwqNCwk3Hw9rVnbhKUPMRdGOFehJlMUx9Sdz3W
         huKKq7YR1W+MnKvRJhqwLI1i1uKOFUJUHbOogpgQEvp0XmZnIVX7WpZOkwHGbYdAwoKd
         RukwWl+Bbg4PYjaIzvG3h9Q8iDGLh93iLaxI2ZeDV7WN9Q6D0sd6tXOn7Q7JtXmoSU3U
         OdgA==
X-Gm-Message-State: AC+VfDxAmO2Uu2PyvU5Zjrde5ju692emXNyKqyWpeGShCjOUXSJW5GPy
	lrDL54fIs86zSDYHL/uHGPAghvV+xCXCe2CDq9t/fDM3JdLg5D6v5oUSyx01urz6XO1AEh9gNU2
	7MaSgU48NKx5Z98UZxt7klWULGDQI+ge0
X-Received: by 2002:a67:f716:0:b0:42f:78d5:d987 with SMTP id m22-20020a67f716000000b0042f78d5d987mr5873460vso.1.1685734595764;
        Fri, 02 Jun 2023 12:36:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5jlppEcC+UjTF+u/96rLpBy9/9Um0EzzmQDfoLtgfIpL59Vjd3rPxHg88svWQwu1sGyPAJPcbTvbSvVwkaC88=
X-Received: by 2002:a67:f716:0:b0:42f:78d5:d987 with SMTP id
 m22-20020a67f716000000b0042f78d5d987mr5873454vso.1.1685734595497; Fri, 02 Jun
 2023 12:36:35 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 12:36:34 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110232.29349-5-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 12:36:34 -0700
Message-ID: <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 05/28] net/sched: act_api: introduce tc_lookup_action_byid()
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

On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> +/* lookup by ID */
> +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id)
> +{
> +	struct tcf_dyn_act_net *base_net;
> +	struct tc_action_ops *a, *res = NULL;
> +
> +	if (!act_id)
> +		return NULL;
> +
> +	read_lock(&act_mod_lock);
> +
> +	list_for_each_entry(a, &act_base, head) {
> +		if (a->id == act_id) {
> +			if (try_module_get(a->owner)) {
> +				read_unlock(&act_mod_lock);
> +				return a;
> +			}
> +			break;

It shouldn't call break here but instead already return NULL:
if id matched, it cannot be present on the dyn list.

Moreover, the search be optimized: now that TCA_ID_ is split between
fixed and dynamic ranges (patch #3), it could jump directly into the
right list. Control path performance is also important..

> +		}
> +	}
> +	read_unlock(&act_mod_lock);
> +
> +	read_lock(&base_net->act_mod_lock);
> +
> +	base_net = net_generic(net, dyn_act_net_id);
> +	a = idr_find(&base_net->act_base, act_id);
> +	if (a && try_module_get(a->owner))
> +		res = a;
> +
> +	read_unlock(&base_net->act_mod_lock);
> +
> +	return res;
> +}
> +EXPORT_SYMBOL(tc_lookup_action_byid);


