Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6679D20408B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgFVTff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbgFVTff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 15:35:35 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB12A206E2;
        Mon, 22 Jun 2020 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592854535;
        bh=QfRYrK8z5849Hl/Iv9wWsynxoV1oaehOiifKZ4mfpNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JfokhTk1gxTrybajXHO0w4B3ciBNWwU36SoEDCyE/+X6vK5Et00KAkjVxKNN0XkgA
         W8G1f60AQ7oE2E7AwqAtU5bKVib0D7X1scKH4ZmxBAWYF9E55FYjVEoj7/qyFR74V7
         bGedwatZMKBKP00o8oIw6WbbODkDwYbay9WLC3tw=
Date:   Mon, 22 Jun 2020 12:35:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] [net] dcb_doit: remove redundant skb check
Message-ID: <20200622123533.4fd450b6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200621165657.9814-1-gaurav1086@gmail.com>
References: <20200621165657.9814-1-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Jun 2020 12:56:28 -0400 Gaurav Singh wrote:
> Remove the redundant null check for skb.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Thanks for the patch, it looks correct, but could you describe your
proof / reasoning based on which this change is correct?

Please post non-bug fixes like this with a [net-next] rather than [net]
tag (https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html).

> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index d2a4553bcf39..84dde5a2066e 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -1736,7 +1736,7 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	struct net_device *netdev;
>  	struct dcbmsg *dcb = nlmsg_data(nlh);
>  	struct nlattr *tb[DCB_ATTR_MAX + 1];
> -	u32 portid = skb ? NETLINK_CB(skb).portid : 0;
> +	u32 portid = NETLINK_CB(skb).portid;
>  	int ret = -EINVAL;
>  	struct sk_buff *reply_skb;
>  	struct nlmsghdr *reply_nlh = NULL;

