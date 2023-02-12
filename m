Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E2693706
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 12:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBLLf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 06:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLLf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 06:35:28 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F948211E;
        Sun, 12 Feb 2023 03:35:27 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E83F0320085B;
        Sun, 12 Feb 2023 06:35:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 12 Feb 2023 06:35:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676201723; x=1676288123; bh=qu9vWWhIaYeQ0uftrVDwsKdmucKH
        LvqQT7a0KyHpieY=; b=RAc0bxO96qlBkgwdQQM2UTz348zDDjwJunpJFt07qh3O
        z2CUalXmB3qaFfgJKRo+lwUqP4bPBD2Jbfed9H2Fwwe9B1Gi7z8hOqD+j7GtyNsZ
        BxXiUNxNOl8dBymDZkc5QxFgQVarjfK9wssfCjc5QSy5o1/116ocBUl3rNDMFTHZ
        14fsLrPmXQQAFTrQnkOfGiCHr30XJHwE1768Fw3d2pz4rysSuBxVS5nzDP04hHbC
        ugdKSKwiuo1BTYMJ24Lzt0qrTNPgvlilvhDw+1ChIlaIEkE4Lux+vRRO4wnQo4eq
        +n/NfBU6kuj9YkH2ZDKAKV1iIel/lOP9CI5s9QLGvg==
X-ME-Sender: <xms:-s7oY5-rZXiMHew2yK0PF1Y-Msk-lT_WxJY4OMUbrwGf5uABxCtB0w>
    <xme:-s7oY9sIBfyW0OK_T6JPj_yB_fLQDfnr-tjxpz790kDfchwSxfewET-i4DJZgiDy7
    H5REBsHksvu2Ho>
X-ME-Received: <xmr:-s7oY3DfXd-kwr04nVyG9oFcgcnFcsaVFtJpjnVtBBTnADvwhVcO4wDR_AB5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-s7oY9cu2tEHamzj34xzFbSRvHyWWlKNyo5LY-nnMZrml0TkSOHCJw>
    <xmx:-s7oY-PfcjyKFyuFGaApnEt2_ASCkGjwWcSVVXwmerWzB4PPL3UxQg>
    <xmx:-s7oY_nhObIFGAU2n2Vp3tvlGKxK_tUYv_pUU6lrQJNG389G8KyQMA>
    <xmx:-87oY7otdSLsNEEiBMIGKHJTXMle4YoLj7MkUGmuc4lktr760PkQ0A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Feb 2023 06:35:21 -0500 (EST)
Date:   Sun, 12 Feb 2023 13:35:18 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net-next] sock_map: dump socket map id via diag
Message-ID: <Y+jO9vxrjdppeg9a@shredder>
References: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 12:19:54PM -0800, Cong Wang wrote:
> +int sock_map_idiag_dump(struct sock *sk, struct sk_buff *skb, int attrtype)
> +{
> +	struct sk_psock_link *link;
> +	struct nlattr *nla, *attr;
> +	int nr_links = 0, ret = 0;
> +	struct sk_psock *psock;
> +	u32 *ids;
> +
> +	rcu_read_lock();
> +	psock = sk_psock_get(sk);
> +	if (unlikely(!psock)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +
> +	nla = nla_nest_start_noflag(skb, attrtype);

Since 'INET_DIAG_SOCKMAP' is a new attribute, did you consider using
nla_nest_start() instead?

> +	if (!nla) {
> +		sk_psock_put(sk, psock);
> +		rcu_read_unlock();
> +		return -EMSGSIZE;
> +	}
> +	spin_lock_bh(&psock->link_lock);
> +	list_for_each_entry(link, &psock->link, list)
> +		nr_links++;
> +
> +	attr = nla_reserve(skb, SK_DIAG_BPF_SOCKMAP_MAP_ID,
> +			   sizeof(link->map->id) * nr_links);
> +	if (!attr) {
> +		ret = -EMSGSIZE;
> +		goto unlock;
> +	}
> +
> +	ids = nla_data(attr);
> +	list_for_each_entry(link, &psock->link, list) {
> +		*ids = link->map->id;
> +		ids++;
> +	}

No strong preferences, but I think a more "modern" netlink usage would
be to encode each ID in a separate u32 attribute rather than encoding an
array of u32 in a single attribute. Example:

[ INET_DIAG_SOCKMAP ]	// nested
	[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
	[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
	...

Or:

[ INET_DIAG_SOCKMAP ]	// nested
	[ SK_DIAG_BPF_SOCKMAP_MAP_IDS ] // nested
		[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
		[ SK_DIAG_BPF_SOCKMAP_MAP_ID ] // u32
		...

> +unlock:
> +	spin_unlock_bh(&psock->link_lock);
> +	sk_psock_put(sk, psock);
> +	rcu_read_unlock();
> +	if (ret)
> +		nla_nest_cancel(skb, nla);
> +	else
> +		nla_nest_end(skb, nla);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sock_map_idiag_dump);
