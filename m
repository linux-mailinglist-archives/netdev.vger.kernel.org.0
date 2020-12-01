Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FB32C956D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 03:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgLACxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 21:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLACxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 21:53:04 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7597F20809;
        Tue,  1 Dec 2020 02:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606791143;
        bh=T0O0YtG6eYFBodmY8eFDW7vU5XkNZ8nxVt9KDqwf0kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P8Jrz6ITSLhddabVIbbFj9tthhds+ah0HRycFkEjBIH/828VtLq5fdHu1PkPOg6Mo
         ejAWwYRPD+7j+IUj82GONswrXB0CUZHt76kBlILlZFgDGJ7HxK6aXs+1EpeevhEqlD
         +o39bOZ409K2AwqEq0wReD7KgaMtAXRA2UsZ3XsE=
Date:   Mon, 30 Nov 2020 18:52:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: remove redundant 'rtnl_held'
 argument
Message-ID: <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127151205.23492-1-vladbu@nvidia.com>
References: <20201127151205.23492-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 17:12:05 +0200 Vlad Buslov wrote:
> @@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  
>  	if (prio == 0) {
>  		tfilter_notify_chain(net, skb, block, q, parent, n,
> -				     chain, RTM_DELTFILTER, rtnl_held);
> +				     chain, RTM_DELTFILTER);
>  		tcf_chain_flush(chain, rtnl_held);
>  		err = 0;
>  		goto errout;

Hum. This looks off.
