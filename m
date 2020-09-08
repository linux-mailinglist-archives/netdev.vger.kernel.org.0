Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0A261864
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgIHRyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731577AbgIHQMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:12:49 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8356CC09B040
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:40:02 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a12so16195936eds.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QSNh/eG8P3ImDv2x9ZW66TIS2gtlEjngknN7ANV4t7s=;
        b=qo1N284nT48/pkjX8QmS+vOGODMRD07o5G2+afYipGSZHse2uieqBr3+VLeSfV6XOb
         d4x7v9xaruz1r+zoP0nPKZ09gz1G/G3fyB5yDW1KBkPfmjTWF54137xZXP1DdUtvQ+R4
         /U2h2ShLukEHGRQ0M6AY4Q0/7rC+XUTZ+uuGCvjphyTpJT/93ORBpDQhY/nCu0v99tRE
         fxF4aD5TEWpQLducifnIA/xwAEHsHUpic32qZof1p7YD7aT1r8Nyb2XME64DkdgbiVbM
         zO4nogVN0I7dqkhbnncrYTuuM5nWfYBk7OlkqMUR8rEHC56KVh/reU8KLgXvXmKQIc8Q
         FYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QSNh/eG8P3ImDv2x9ZW66TIS2gtlEjngknN7ANV4t7s=;
        b=Cv/83FOisnlTMicleBCyEq3+9Z1m7lZr6sz5iwPTZHn/QaiRZYwJzM0KhL3O03DH30
         Im0qrL39Wc8USGBRYCfahtV3/1LQQUwy2QEL/US/DfJYpp45Cf0mZLDupq0VuURbbU+I
         VUzFALvDDPzmcimWhm0GvfTkNz3Fd/j99JeyDC0+04akJy/6DrOWVH6liXSnldIpruc+
         fTTUfIIMCd51mP7OKt1stCK6Ueq1NdQAJnyozgEibVDwRTZaCvZ9pkz0ax7muDVmz6l3
         N7BIERaIOubsJmF6nk4ONdesb1bIhA34e+TvB8TGb+jCqj6acuV5z3UgwzsaICTcFdtr
         FUBw==
X-Gm-Message-State: AOAM530qejECutP2jqaRqGhaqlVbFebPjGB6AnD+zMmiTaPgttROU1s+
        VQEaARoLuiccr8kwg2fg083ULA==
X-Google-Smtp-Source: ABdhPJx2L9FNJkRU04yZXaXvnUV6IEKnWgX3mnYX8z2vL21ubOvj5URh4Bqwf1kiqgVeibBH/d7Kfg==
X-Received: by 2002:a50:fe82:: with SMTP id d2mr322481edt.86.1599576001211;
        Tue, 08 Sep 2020 07:40:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j8sm17510419edp.58.2020.09.08.07.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 07:40:00 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:39:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 03/22] nexthop: Only emit a notification
 when nexthop is actually deleted
Message-ID: <20200908143959.GP2997@nanopsycho.orion>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908091037.2709823-4-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 08, 2020 at 11:10:18AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@nvidia.com>
>
>Currently, the delete notification is emitted from the error path of
>nexthop_add() and replace_nexthop(), which can be confusing to listeners
>as they are not familiar with the nexthop.
>
>Instead, only emit the notification when the nexthop is actually
>deleted. The following sub-cases are covered:

Well, in theory, this might break some very odd app that is adding a
route and checking the errors using this notification. My opinion is to
allow this breakage to happen, but I'm usually too benevolent :)


>
>1. User space deletes the nexthop
>2. The nexthop is deleted by the kernel due to a netdev event (e.g.,
>   nexthop device going down)
>3. A group is deleted because its last nexthop is being deleted
>4. The network namespace of the nexthop device is deleted
>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>
>---
> net/ipv4/nexthop.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>index 13d9219a9aa1..8c0f17c6863c 100644
>--- a/net/ipv4/nexthop.c
>+++ b/net/ipv4/nexthop.c
>@@ -870,8 +870,6 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
> 	bool do_flush = false;
> 	struct fib_info *fi;
> 
>-	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
>-
> 	list_for_each_entry(fi, &nh->fi_list, nh_list) {
> 		fi->fib_flags |= RTNH_F_DEAD;
> 		do_flush = true;
>@@ -909,6 +907,8 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
> static void remove_nexthop(struct net *net, struct nexthop *nh,
> 			   struct nl_info *nlinfo)
> {
>+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
>+
> 	/* remove from the tree */
> 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
> 
>-- 
>2.26.2
>
