Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3B69C23B
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjBSUVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjBSUVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:21:42 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1200617179;
        Sun, 19 Feb 2023 12:21:42 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id a28so662106qtw.7;
        Sun, 19 Feb 2023 12:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yg5WqNAUGtM21o5WykHGgReJqD9RkF4lAOwqTObCJr4=;
        b=NgsROoZ9/qassGuNConPfp+ek3L4wwvDMiPuQ4PZCYfQTMeGkCal82NCzSUpPxT+tW
         RYsZFtVVK0pXh6PK+U/Iq9pnOQ4V53l5OKYs9NXiBpnl8y5jB2HHvpYiGseOVX+N7rb9
         GU4AKxYBUXNbkN736VlBbCDfDMAPbl8MCqpNt/cl/Z0SwXA7P8CNFNjWkD7S7py4oO1+
         Xb3hyfiIma93DwYvwFt83V8lQWDbAEGNmSJOopl7l9jIVuh7UuSFhnbUDzJXwUIzXU0+
         l9zh6wIjcnNipK7kskl+PiJxYMwvv9Yq+cTkIYamaPLUSyOnVs/m/GS+g7f+qwRva67A
         y4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yg5WqNAUGtM21o5WykHGgReJqD9RkF4lAOwqTObCJr4=;
        b=yLyWpE0i9zf/tgsawPVVn86UKMLiJeanLO0hvoGzFl4FpMzo658RKCozRhzHd1SuQo
         XTQ6Dk5Kssv4+QqFB4tiZL9+u/UQJz9H4/pTPQ2prtRuqA/n3LLsB7537aWEuoAQqejC
         kvQvu+Dm8PqX/y2RUm7iVHl5lswTYPi2VQdBrBh4r/j6TmloZK3SNgcN/Nr1IQxnM4nd
         PYAWoL28eMZBW5uxPRLerUi0f2X8teYNi+ftEwnLSIaRmPv4baZzCz1l7g8OwQixv9L5
         YnJtuxfnAuPmqLQySR9HyOn8bcaJLHbUaoKbOq2Loyf0nSfsrDhOfasG+7RaMe+F0hiF
         D6vw==
X-Gm-Message-State: AO0yUKXyY4cCTKoch3EzNQn6R75sYYmbiGXhiiz2hYt8N37NiYQVp1Cs
        X5AI6Qxe4ndpJwsUmzNyA4Y=
X-Google-Smtp-Source: AK7set9RuH8wQ94bRZGgGTJIpp6iHZY603oA4TyDrCtDiSRXiNQelZSlMiU5ymmDnWNUKv6viFCdGA==
X-Received: by 2002:ac8:7d8d:0:b0:3bb:855a:9ed7 with SMTP id c13-20020ac87d8d000000b003bb855a9ed7mr10037665qtd.42.1676838101177;
        Sun, 19 Feb 2023 12:21:41 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:c829:c422:d5dc:95ba])
        by smtp.gmail.com with ESMTPSA id fp42-20020a05622a50aa00b003ba11bfe4fcsm7496421qtb.28.2023.02.19.12.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 12:21:40 -0800 (PST)
Date:   Sun, 19 Feb 2023 12:21:39 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net-next] sock_map: dump socket map id via diag
Message-ID: <Y/KE0y9zVLKnO8e4@pop-os.localdomain>
References: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
 <Y+jO9vxrjdppeg9a@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+jO9vxrjdppeg9a@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 01:35:18PM +0200, Ido Schimmel wrote:
> On Sat, Feb 11, 2023 at 12:19:54PM -0800, Cong Wang wrote:
> > +int sock_map_idiag_dump(struct sock *sk, struct sk_buff *skb, int attrtype)
> > +{
> > +	struct sk_psock_link *link;
> > +	struct nlattr *nla, *attr;
> > +	int nr_links = 0, ret = 0;
> > +	struct sk_psock *psock;
> > +	u32 *ids;
> > +
> > +	rcu_read_lock();
> > +	psock = sk_psock_get(sk);
> > +	if (unlikely(!psock)) {
> > +		rcu_read_unlock();
> > +		return 0;
> > +	}
> > +
> > +	nla = nla_nest_start_noflag(skb, attrtype);
> 
> Since 'INET_DIAG_SOCKMAP' is a new attribute, did you consider using
> nla_nest_start() instead?

Yes, but other INET_DIAG_* attributes are not new, hence why ss.c still
uses parse_rtattr(), I am not sure whether it is okay to change it to
parse_rtattr_nested() just because of this.

> 
> > +	if (!nla) {
> > +		sk_psock_put(sk, psock);
> > +		rcu_read_unlock();
> > +		return -EMSGSIZE;
> > +	}
> > +	spin_lock_bh(&psock->link_lock);
> > +	list_for_each_entry(link, &psock->link, list)
> > +		nr_links++;
> > +
> > +	attr = nla_reserve(skb, SK_DIAG_BPF_SOCKMAP_MAP_ID,
> > +			   sizeof(link->map->id) * nr_links);
> > +	if (!attr) {
> > +		ret = -EMSGSIZE;
> > +		goto unlock;
> > +	}
> > +
> > +	ids = nla_data(attr);
> > +	list_for_each_entry(link, &psock->link, list) {
> > +		*ids = link->map->id;
> > +		ids++;
> > +	}
> 
> No strong preferences, but I think a more "modern" netlink usage would
> be to encode each ID in a separate u32 attribute rather than encoding an
> array of u32 in a single attribute. Example:
> 
> [ INET_DIAG_SOCKMAP ]	// nested
> 	[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
> 	[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
> 	...

How do we know how many ID's we have here? Note, INET_DIAG_SOCKMAP in
the future could have other attributes, so can't simply mark the end of
ID's.

> 
> Or:
> 
> [ INET_DIAG_SOCKMAP ]	// nested
> 	[ SK_DIAG_BPF_SOCKMAP_MAP_IDS ] // nested
> 		[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
> 		[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
> 		...

Yet one more nested level...

I prefer the current layout.

Thanks.
