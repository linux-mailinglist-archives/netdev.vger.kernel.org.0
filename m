Return-Path: <netdev+bounces-11222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22812732072
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76C7C2814E0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0384EAED;
	Thu, 15 Jun 2023 19:41:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39DE2E0C3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 19:41:28 +0000 (UTC)
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BDD2D5A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:41:10 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-7621a6d572cso3960385a.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686858069; x=1689450069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NlbV/io6ZnAx7JAxJ9SJ5+xvUoLv5sRoTG7hK5oHeTo=;
        b=GFnNxDFdBYxd575DVxV0+PA/2sBR4nZZfZJPPuIiT3HKO0wEjRW1jozB7WcA2ZGMRP
         4efzsaPjdJLsaOliiGFi5KB57mQa5nJShtM0YHgXPYjMnfmOqdVcCY3TkFhNelmV+4fP
         04nwylZZBep4ifnbnldy6PmZgO4qhaDHH+6ck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686858069; x=1689450069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlbV/io6ZnAx7JAxJ9SJ5+xvUoLv5sRoTG7hK5oHeTo=;
        b=BypTk0MK1VxoOs9KsJC+oVowa2uMq1h9IVpp5pJSFUc4OPZoRvvdnEfOHP+P1HvWoH
         oG1ZLqsxPYA9DQTy9JHCQTQUXqMxqykuerbJWpH2K7DPZ9RONgmS+eereT0ILZJzyAqb
         hiPEy3vywrnnWSucZuZDiwWb8LQaamyF9yiqZxLkjd7Ov9OPivdRUEytrPPscXV6ntoF
         qx3uTpplT6IWu23YII18gW9vhO3+djZgz53WJTo5gi+SG1q5SBeBHzDQbRq3RL95QNae
         VJMwypPCRyo3Vx0WHy8HvjvgmJ7pup78KW6NFnzCAJxODYodax7BtMJ+2cQ5HTua0opV
         ULuA==
X-Gm-Message-State: AC+VfDwvu4SG9AhDbtGL8IlKo88d4zLdwiXGHggfqq9p+PVqe6HPm6CX
	1UudRnb9Dlvjt7QrbAoTirYsm+3aY61k7ahdLgE=
X-Google-Smtp-Source: ACHHUZ74b+n3mTf/gwQdprUW7HEjichOotl6WWIGIYXB/BtEcEIowGAKzuvvnJ6nJ8t605qM5gsWAw==
X-Received: by 2002:a05:620a:4c8c:b0:75e:dbfa:e221 with SMTP id to12-20020a05620a4c8c00b0075edbfae221mr5719245qkn.20.1686858069220;
        Thu, 15 Jun 2023 12:41:09 -0700 (PDT)
Received: from nitro.local (bras-base-mtrlpq5031w-grc-30-209-226-106-132.dsl.bell.ca. [209.226.106.132])
        by smtp.gmail.com with ESMTPSA id h2-20020a37de02000000b0075cfe5c69cfsm5644764qkj.79.2023.06.15.12.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 12:41:08 -0700 (PDT)
Date: Thu, 15 Jun 2023 15:41:07 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com, dsahern@gmail.com, 
	"helpdesk@kernel.org" <helpdesk@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: create device lookup API with
 reference tracking
Message-ID: <20230615-73rd-axle-trots-7e1c65@meerkat>
References: <20230612214944.1837648-1-kuba@kernel.org>
 <168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
 <20230615100021.43d2d041@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230615100021.43d2d041@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:00:21AM -0700, Jakub Kicinski wrote:
> Any recent changes to the pw-bot in commit matching?
> We don't do any editing when applying, AFAIK, and it's 3rd or 4th case
> within a week we get a no-match.

Did you, by chance, set your diff.algorithm to "histogram"? I noticed that the
diffs in your submission are very different from what I get when I run "git
show". E.g. notice this block in your email:

    --- a/net/core/dev.c
    +++ b/net/core/dev.c
    @@ -758,18 +758,7 @@  struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
     }
     EXPORT_SYMBOL(dev_get_by_name_rcu);
     
    -/**
    - *	dev_get_by_name		- find a device by its name
    - *	@net: the applicable net namespace
    - *	@name: name to find
    - *
    - *	Find an interface by name. This can be called from any
    - *	context and does its own locking. The returned handle has
    - *	the usage count incremented and the caller must use dev_put() to
    - *	release it when it is no longer needed. %NULL is returned if no
    - *	matching device is found.
    - */
    -
    +/* Deprecated for new users, call netdev_get_by_name() instead */
     struct net_device *dev_get_by_name(struct net *net, const char *name)
     {
        struct net_device *dev;

When I run "git show 70f7457ad6d655e65f1b93cbba2a519e4b11c946", I get a very
different looking diff:

    --- a/net/core/dev.c
    +++ b/net/core/dev.c
    @@ -758,29 +758,43 @@ struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
     }
     EXPORT_SYMBOL(dev_get_by_name_rcu);

    +/* Deprecated for new users, call netdev_get_by_name() instead */
    +struct net_device *dev_get_by_name(struct net *net, const char *name)
    +{
    + struct net_device *dev;
    +
    + rcu_read_lock();
    + dev = dev_get_by_name_rcu(net, name);
    + dev_hold(dev);
    + rcu_read_unlock();
    ...

Unless I pass --histogram, in which case it starts to match yours. So, I'm
wondering if you have diff.algorithm set to "histogram" and this generates
patches that we can no longer match against commits, because we are generating
the diffs using the default algorithm.

-K

