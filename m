Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7AC1FE680
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbgFRCeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbgFRBOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:36 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59AD221F0;
        Thu, 18 Jun 2020 01:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442875;
        bh=KzqQWBGzgxPDIiM2TLCHuHzA0lbc/p1k8n6t1lUjCWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3+/SWfWhMKw+skYhZV1LDxXhYDYVEYLeSzdKBYILRcQ0jD2LidHnzpTCJwXz8beG
         D2PhS+y4BMlh0J5Zcvn/1KmmYb9DtFNpvbzPPOofZdV811kUToX9Ub6tFAcKQAaf8A
         nTzpNL0E170FltTo3ZfKASk5sIQg3Yzl21DYYB0Y=
Date:   Wed, 17 Jun 2020 18:14:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:TC subsystem),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] [net/sched]: Remove redundant condition in qdisc_graft
Message-ID: <20200617181433.4aeee30c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618005526.27101-1-gaurav1086@gmail.com>
References: <20200618005526.27101-1-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 20:55:26 -0400 Gaurav Singh wrote:
> parent cannot be NULL here since its in the else part
> of the if (parent == NULL) condition. Remove the extra
> check on parent pointer.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Change seems legit, but it obviously doesn't build...

>  net/sched/sch_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 9a3449b56bd6..8c92d00c5c8e 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1094,7 +1094,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>  
>  		/* Only support running class lockless if parent is lockless */
>  		if (new && (new->flags & TCQ_F_NOLOCK) &&
> -		    parent && !(parent->flags & TCQ_F_NOLOCK))
> +		    && !(parent->flags & TCQ_F_NOLOCK))
>  			qdisc_clear_nolock(new);
>  
>  		if (!cops || !cops->graft)

