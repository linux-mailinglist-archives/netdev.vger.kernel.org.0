Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2EEC9F09
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 15:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbfJCNEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 09:04:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38425 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729677AbfJCNEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 09:04:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F022421CDD;
        Thu,  3 Oct 2019 09:04:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 09:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0vNiPs
        Um7dIGm4+F73chv6XOmKwLdMRF3RzyhHs+XjQ=; b=PE3Oz1tvTA+w0f76NaYsgW
        Wr63m7GmVVX99bTJOkNquriaYRmqt+YSXt3kjK8SSj7KZ4FMn07B0EBwa6z2+I9K
        U92+oKt7oYmtA+zm1gW3GwOnuThU9er2789qKXwwrhZPDAbNJOI/v1Q1XfVEG8Kk
        hIx7SE93mJjSYzwVvsWyYSi2rJtepD34jggMhpJjKcUHPmURX8Mn0A1FfCcf/QJO
        ONyDbbtXty5HOu58beOrnJPmmapw+VUM7GhrYFDSmaGYaeBQ5yRx7pbTUaJ8eKrQ
        yB3jvmUO1Mdk57ikePeXnoSYubI5Dwjkjle3GQEl/rcz/LrsQOLc6NMBqLt8L1+A
        ==
X-ME-Sender: <xms:3vGVXT4BVBB44cgH6e1vx-v1kvgl4cGdzLule77BcMSfxf0ddXbeSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:3vGVXWYzfCJgjeEKRE_MRWD8XIaqvdA6fZkupwXQcYO3u9vCs8ZNmg>
    <xmx:3vGVXQxHBGm_fGpH_oEiRH7XqwANBEK3l8qfUhXJea20Id0avzfa7g>
    <xmx:3vGVXbQvp5xuDEqDo56cQhPmk_08mvsQORM0HRugUYhydjT7hQKJ1w>
    <xmx:3vGVXcD2Nu_9iL41PbK0MIbI-EzYD5VQPuMjcVAVa5fzbz8G7-G7Nw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8EBED6005E;
        Thu,  3 Oct 2019 09:04:29 -0400 (EDT)
Date:   Thu, 3 Oct 2019 16:04:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 07/15] ipv4: Only Replay routes of interest
 to new listeners
Message-ID: <20191003130427.GA21529@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-8-idosch@idosch.org>
 <20191002174402.GB2279@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002174402.GB2279@nanopsycho>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 07:44:02PM +0200, Jiri Pirko wrote:
> Wed, Oct 02, 2019 at 10:40:55AM CEST, idosch@idosch.org wrote:
> >From: Ido Schimmel <idosch@mellanox.com>
> >
> >When a new listener is registered to the FIB notification chain it
> >receives a dump of all the available routes in the system. Instead, make
> >sure to only replay the IPv4 routes that are actually used in the data
> >path and are of any interest to the new listener.
> >
> >Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> >---
> > net/ipv4/fib_trie.c | 10 ++++++++++
> > 1 file changed, 10 insertions(+)
> >
> >diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> >index dc4c4e2cb0b3..4937a3503f4f 100644
> >--- a/net/ipv4/fib_trie.c
> >+++ b/net/ipv4/fib_trie.c
> >@@ -2096,6 +2096,7 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
> > 			   struct netlink_ext_ack *extack)
> > {
> > 	struct fib_alias *fa;
> >+	int last_slen = -1;
> > 	int err;
> > 
> > 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
> >@@ -2110,6 +2111,15 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
> > 		if (tb->tb_id != fa->tb_id)
> > 			continue;
> > 
> >+		if (fa->fa_slen == last_slen)
> >+			continue;
> 
> Hmm, I wonder, don't you want to continue only for FIB_EVENT_ENTRY_REPLACE_TMP
> and keep the notifier call for FIB_EVENT_ENTRY_ADD?

Yea, I think you're right. As-is this introduces a small regression
until later in the series. Will fix. Thanks!

> 
> 
> >+
> >+		last_slen = fa->fa_slen;
> >+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE_TMP,
> >+					      l->key, KEYLENGTH - fa->fa_slen,
> >+					      fa, extack);
> >+		if (err)
> >+			return err;
> > 		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
> > 					      KEYLENGTH - fa->fa_slen,
> > 					      fa, extack);
> >-- 
> >2.21.0
> >
