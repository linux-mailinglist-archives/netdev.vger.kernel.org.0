Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5952A1F56C1
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 16:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgFJO1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 10:27:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37233 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgFJO1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 10:27:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E1775C00D5;
        Wed, 10 Jun 2020 10:27:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 10 Jun 2020 10:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rhIqEN
        wItHTUdYSJXDCTpsJI7T8rn+xHMXcBrDyWMmo=; b=UEddviaTLW+7QpjSuJ3grL
        NKvE0nNFYQ6YRdKaPJjAKqPj9XjsEat+nOGAiUvKkzA5GZjMniO3+uCSlsGd+ue+
        IvDTwD3rKXZ0txV34co0oPIDTs3VfZd+zcaml2rfNflK1IY3ce/U672jG2sosmyY
        sOA9Qm4/Yjhf0aUaijJYpHj7vW3mkiVEeIzqWWS1rH5c9inEQw5WlXbxn5gwsUt4
        i0rg6ejVT04Mopw0QINoboklX0wiEmpQ6qP00EWPuYeSIXG03POuBNe6VZjDHEzg
        ZUy/WXIg3eMvAWA3GlT+JOxyw6ItIVH6lgMIJeqIOOKlDkZnc2M0h9yt3PLXvx9A
        ==
X-ME-Sender: <xms:tu3gXuTu06hEV7gT87bygj9vPtbaguA5GCWEBWk2cTaQcVY-Btd2HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehiedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tu3gXjyrA4VP3YoxCOzUExNvVeWx3p6MNo-YmRP9PG9IGR96-Fs31A>
    <xmx:tu3gXr0oGMk6UBLeMbHf3kG8XT3mLCSLB-vZFgC7mvJzjAdvK-Lwqw>
    <xmx:tu3gXqCSAg13SxzWSPiBS7jRVVH_Sqec3giO2jqxqTxbnlFQfPoHiQ>
    <xmx:t-3gXnfLEzg9h-_nFKrBKaeykvcIei529V1Np6u2_pS6cJYyQyS0XQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBF713060FE7;
        Wed, 10 Jun 2020 10:27:01 -0400 (EDT)
Date:   Wed, 10 Jun 2020 17:27:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shaochun Chen <cscnull@gmail.com>
Subject: Re: [Patch net v2] genetlink: fix memory leaks in
 genl_family_rcv_msg_dumpit()
Message-ID: <20200610142700.GA2174714@splinter>
References: <20200603044910.27259-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603044910.27259-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 09:49:10PM -0700, Cong Wang wrote:
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 9f357aa22b94..bcbba0bef1c2 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -513,15 +513,58 @@ static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
>  		kfree(attrbuf);
>  }
>  
> -static int genl_lock_start(struct netlink_callback *cb)
> +struct genl_start_context {
> +	const struct genl_family *family;
> +	struct nlmsghdr *nlh;
> +	struct netlink_ext_ack *extack;
> +	const struct genl_ops *ops;
> +	int hdrlen;
> +};
> +
> +static int genl_start(struct netlink_callback *cb)
>  {
> -	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
> +	struct genl_start_context *ctx = cb->data;
> +	const struct genl_ops *ops = ctx->ops;
> +	struct genl_dumpit_info *info;
> +	struct nlattr **attrs = NULL;
>  	int rc = 0;
>  
> +	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
> +		goto no_attrs;
> +
> +	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
> +		return -EINVAL;
> +
> +	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,
> +						ops, ctx->hdrlen,
> +						GENL_DONT_VALIDATE_DUMP_STRICT,
> +						true);
> +	if (IS_ERR(attrs))
> +		return PTR_ERR(attrs);
> +
> +no_attrs:
> +	info = genl_dumpit_info_alloc();
> +	if (!info) {
> +		kfree(attrs);
> +		return -ENOMEM;
> +	}
> +	info->family = ctx->family;
> +	info->ops = ops;
> +	info->attrs = attrs;
> +
> +	cb->data = info;
>  	if (ops->start) {
> -		genl_lock();
> +		if (!ctx->family->parallel_ops)
> +			genl_lock();
>  		rc = ops->start(cb);
> -		genl_unlock();
> +		if (!ctx->family->parallel_ops)
> +			genl_unlock();
> +	}
> +
> +	if (rc) {
> +		kfree(attrs);
> +		genl_dumpit_info_free(info);
> +		cb->data = NULL;
>  	}
>  	return rc;
>  }
> @@ -548,7 +591,7 @@ static int genl_lock_done(struct netlink_callback *cb)
>  		rc = ops->done(cb);
>  		genl_unlock();
>  	}
> -	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
> +	genl_family_rcv_msg_attrs_free(info->family, info->attrs, false);

Cong,

This seems to result in a memory leak because 'info->attrs' is never
freed in the non-parallel case.

Both the parallel and non-parallel code paths call genl_start() which
allocates the array, but the latter calls genl_lock_done() as its done()
callback which never frees it.

Can be reproduced as follows:

echo "10 1" > /sys/bus/netdevsim/new_device
devlink trap &> /dev/null
echo scan > /sys/kernel/debug/kmemleak
cat /sys/kernel/debug/kmemleak

unreferenced object 0xffff88810f1ed000 (size 2048):
  comm "devlink", pid 201, jiffies 4295606431 (age 35.858s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a7cb7530>] __kmalloc+0x1d6/0x3d0
    [<000000001cb013e1>] genl_family_rcv_msg_attrs_parse+0x1f3/0x320
    [<00000000b201bc93>] genl_start+0x1ab/0x5e0
    [<00000000786e531e>] __netlink_dump_start+0x5b5/0x940
    [<00000000a2332fcb>] genl_family_rcv_msg_dumpit+0x32e/0x3a0
    [<00000000112052dd>] genl_rcv_msg+0x6d7/0xb40
    [<000000005826e358>] netlink_rcv_skb+0x175/0x490
    [<000000002c5f41ae>] genl_rcv+0x2d/0x40
    [<00000000f0301e6d>] netlink_unicast+0x5d0/0x7f0
    [<00000000a76a3934>] netlink_sendmsg+0x981/0xe90
    [<000000001c478a6f>] __sys_sendto+0x2cd/0x450
    [<0000000079d420b0>] __x64_sys_sendto+0xe6/0x1a0
    [<000000004e535e4b>] do_syscall_64+0xc1/0x600
    [<000000006e5dd3c4>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

>  	genl_dumpit_info_free(info);
>  	return rc;
>  }
> @@ -573,43 +616,23 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
>  				      const struct genl_ops *ops,
>  				      int hdrlen, struct net *net)
>  {
> -	struct genl_dumpit_info *info;
> -	struct nlattr **attrs = NULL;
> +	struct genl_start_context ctx;
>  	int err;
>  
>  	if (!ops->dumpit)
>  		return -EOPNOTSUPP;
>  
> -	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
> -		goto no_attrs;
> -
> -	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
> -		return -EINVAL;
> -
> -	attrs = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
> -						ops, hdrlen,
> -						GENL_DONT_VALIDATE_DUMP_STRICT,
> -						true);
> -	if (IS_ERR(attrs))
> -		return PTR_ERR(attrs);
> -
> -no_attrs:
> -	/* Allocate dumpit info. It is going to be freed by done() callback. */
> -	info = genl_dumpit_info_alloc();
> -	if (!info) {
> -		genl_family_rcv_msg_attrs_free(family, attrs, true);
> -		return -ENOMEM;
> -	}
> -
> -	info->family = family;
> -	info->ops = ops;
> -	info->attrs = attrs;
> +	ctx.family = family;
> +	ctx.nlh = nlh;
> +	ctx.extack = extack;
> +	ctx.ops = ops;
> +	ctx.hdrlen = hdrlen;
>  
>  	if (!family->parallel_ops) {
>  		struct netlink_dump_control c = {
>  			.module = family->module,
> -			.data = info,
> -			.start = genl_lock_start,
> +			.data = &ctx,
> +			.start = genl_start,
>  			.dump = genl_lock_dumpit,
>  			.done = genl_lock_done,
>  		};
> @@ -617,12 +640,11 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
>  		genl_unlock();
>  		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
>  		genl_lock();
> -
>  	} else {
>  		struct netlink_dump_control c = {
>  			.module = family->module,
> -			.data = info,
> -			.start = ops->start,
> +			.data = &ctx,
> +			.start = genl_start,
>  			.dump = ops->dumpit,
>  			.done = genl_parallel_done,
>  		};
> -- 
> 2.26.2
> 
