Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CE037B186
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhEKWSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKWSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 18:18:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB24C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:17:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d11so21610143wrw.8
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rIMnU3pEMyzESxwl/9HGpb60VQFyauRdmgB1fZ2i0PQ=;
        b=lbQ/0T7CfsdayyPHbn5j4LU/IELNGNpn0EpNuxTYaaWR39f9MgG9/y4+g0Cm2GjRQV
         QQRZGDOKRn+tYKQc9u7XzQtJPqzXCuFixHfaFoMsgRqaBYAoGdPCNgRUX9yS1PO1QkLU
         Vtj96GjtmCI+Z1hZ5/bCnNBjuGeRAXQ0uoAf2E738XJ0O4KJh9JBzsyJnm5cZxQqQBcj
         cNYzAulxov0Vl5Vy6WIA8qON2WvpFmHCxcx8mYKYeetbMunHQxoysUbXjxM24/QraVCt
         QbUfnodLLtx9SATocntwK/2mWPtMFNYAAEuNlroBdkfm5vBBm69LIW9yUNv6l2ng4zbl
         usBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rIMnU3pEMyzESxwl/9HGpb60VQFyauRdmgB1fZ2i0PQ=;
        b=s9yxC8XOVwYDIF31cERB9P+TMGKR1lAQR7lrEk6j3a94ZwcthYphja/oTFFNaC7/cR
         2S2BXXKnxFqrVoIa5x0r1SBsAVG2pbM1QZ29yNoYbTm+ngpvDSTZmVvAex/XVzgtzUoy
         3UILAFycrx+yno905YV8nltbHzAavWGXMst65H0Qd+g9GZBQb6CoAKceGjeDkHDWfMGC
         AxSAWuOo5njg0tn3RzIHah4c/aWtVuLZfIO+eaX46Yitu39YcI1c9nYYZ3PivWrEDC+c
         ZLm8LVtuM1EfpG9AT+uOG5G5iQgPse5pNU24GNeNwcg+7pUMMrqdb8kOn/r80fm5Io8a
         I5KA==
X-Gm-Message-State: AOAM531dXq1ajGvSs4HSuFAVfFV2whzNruM6XOW5Lh+3eDVJNcAS7bsQ
        krw9rAajZi+PhYWK8yr/Y0QviA==
X-Google-Smtp-Source: ABdhPJwwI0m+O3Uja0c3Zn0UnwEmXQbJiNj29lXSpWpDwn3GIlYWdZnmmVFJR09jRPv3joVkZ6uiOg==
X-Received: by 2002:a05:6000:180a:: with SMTP id m10mr40452470wrh.215.1620771458027;
        Tue, 11 May 2021 15:17:38 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id r7sm4207518wmq.3.2021.05.11.15.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 15:17:37 -0700 (PDT)
Date:   Tue, 11 May 2021 23:17:35 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, kuba@kernel.org, yhs@fb.com, ast@kernel.org,
        johannes.berg@intel.com, rdunlap@infradead.org,
        0x7f454c46@gmail.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: netlink_sendmsg: memset unused tail bytes in skb
Message-ID: <YJsCf0tFub3YXKvh@equinox>
References: <20210509121858.1232583-1-phil@philpotter.co.uk>
 <20210509131051.GD4038@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509131051.GD4038@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 09, 2021 at 03:10:51PM +0200, Florian Westphal wrote:
> Phillip Potter <phil@philpotter.co.uk> wrote:
> > When allocating the skb within netlink_sendmsg, with certain supplied
> > len arguments, extra bytes are allocated at the end of the data buffer,
> > due to SKB_DATA_ALIGN giving a larger size within __alloc_skb for
> > alignment reasons. This means that after using skb_put with the same
> > len value and then copying data into the skb, the skb tail area is
> > non-zero in size and contains uninitialised bytes. Wiping this area
> > (if it exists) fixes a KMSAN-found uninit-value bug reported by syzbot at:
> > https://syzkaller.appspot.com/bug?id=3e63bcec536b7136b54c72e06adeb87dc6519f69
> 
> This patch papers over the real bug.
> 
> Please fix TIPC instead.
> Incomplete patch as a starting point:
> 
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -2481,7 +2481,6 @@ int tipc_nl_node_get_link(struct sk_buff *skb, struct genl_info *info)
>  	struct net *net = genl_info_net(info);
>  	struct nlattr *attrs[TIPC_NLA_LINK_MAX + 1];
>  	struct tipc_nl_msg msg;
> -	char *name;
>  	int err;
>  
>  	msg.portid = info->snd_portid;
> @@ -2499,13 +2498,11 @@ int tipc_nl_node_get_link(struct sk_buff *skb, struct genl_info *info)
>  	if (!attrs[TIPC_NLA_LINK_NAME])
>  		return -EINVAL;
>  
> -	name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
> -
>  	msg.skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>  	if (!msg.skb)
>  		return -ENOMEM;
>  
> -	if (strcmp(name, tipc_bclink_name) == 0) {
> +	if (nla_strcmp(attrs[TIPC_NLA_LINK_NAME], tipc_bclink_name) == 0) {
>  		err = tipc_nl_add_bc_link(net, &msg, tipc_net(net)->bcl);
>  		if (err)
>  			goto err_free;
> 
> 
> You will also need to change tipc_node_find_by_name() to pass the nla
> attr.
> 
> Alternatively TIPC_NLA_LINK_NAME policy can be changed:
> 
> diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
> --- a/net/tipc/netlink.c
> +++ b/net/tipc/netlink.c
> @@ -88,7 +88,7 @@ const struct nla_policy tipc_nl_net_policy[TIPC_NLA_NET_MAX + 1] = {
>  
>  const struct nla_policy tipc_nl_link_policy[TIPC_NLA_LINK_MAX + 1] = {
>         [TIPC_NLA_LINK_UNSPEC]          = { .type = NLA_UNSPEC },
> -       [TIPC_NLA_LINK_NAME]            = { .type = NLA_STRING,
> +       [TIPC_NLA_LINK_NAME]            = { .type = NLA_NUL_STRING,
> 
> 
> ... which makes it safe to treat the raw attribute payload as a c-string,
> but this might break existing userspace applications.
> 
> Its probably a good idea to audit all NLA_STRING attributes in tipc for
> similar problems.

Dear Florian,

Thank you for your feedback and code + suggestions, I will take a look at this over
the next few days and then resubmit.

Regards,
Phil
