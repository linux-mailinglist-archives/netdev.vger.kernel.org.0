Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8564FB64E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbiDKIuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbiDKIuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:50:03 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769D53EB9B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:47:38 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id E97253201F9F;
        Mon, 11 Apr 2022 04:47:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 11 Apr 2022 04:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649666855; x=
        1649753255; bh=DLzd+11ar8C9kgIOPbcqjBzeEwPEufkGvlYVemikKPo=; b=T
        ZZRqCZkhc85oRd1KmDz9vCSrOaHQnj7nfS1FrTDcvhCRTxXkYwhPBWUdrNdjHsoM
        D3hqEwFrey1bOdwHllDdb6ILuC9BOMcHacGJhw4eviwmb2Nc2OgAorDtAhVqe9Nk
        dRga2Bua5PzU5FiithwVKhVhh0Pt3FXGJQZmITgEm+IFPcqI06k6AO+d+liqzU+4
        VoR7mC1pHYzxpLtMPVPACdfXORI+5qdPbQvRb/VTtxWiQrOZW1EVw+xCJ7poLCEU
        6PyaVZ68fnUzSjmpGHPI3iJ4Oi76zhfiyosyogL8xjnBdPKYFsWrji+Q2zsTcIEU
        U6cx0x4K0l0Gqe41ctD1g==
X-ME-Sender: <xms:J-tTYgFDRCbtbVkPJLSYeRR9REMHZ8lLPaGUUm950edTw0fWBArL4Q>
    <xme:J-tTYpWJJYqzeL1fa0w10uDx5nBX2r3_IO6f3L3YDTHy9YRR5IIf3gKp5yGPCGsL1
    RzYTV5IOg8MDWI>
X-ME-Received: <xmr:J-tTYqLKU46XEQHz1Eu27AOnOT7q4jaLca_Q0DE94-rYwc5_08a04kANv23T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtro
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfejvefhvdegiedukeetudevgeeuje
    efffeffeetkeekueeuheejudeltdejuedunecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:J-tTYiE_9m_edRNQhURoLdvDuD_-Q67-RLqs4y6uRYUS42fI5Z8LsA>
    <xmx:J-tTYmVLQPUwG3wQlOlrpZ37iLT1W7OQZc42LLEd42c92hDU6Why1A>
    <xmx:J-tTYlN0H8gm0QbrNP5ZW8MOTi7UiCWXrA9Ihbda02LlTp7yvA_5jA>
    <xmx:J-tTYlTx9JfXEIxphbmzn_ZTz4RXL9a_DCNbajGpenKrg46PQvfixA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 04:47:34 -0400 (EDT)
Date:   Mon, 11 Apr 2022 11:47:33 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 4/6] net: bridge: fdb: add support for flush
 filtering based on ndm flags and state
Message-ID: <YlPrJaWjeObhxmwb@shredder>
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-5-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409105857.803667-5-razor@blackwall.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:58:55PM +0300, Nikolay Aleksandrov wrote:
> Add support for fdb flush filtering based on ndm flags and state. The
> new attributes allow users to specify a mask and value which are mapped
> to bridge-specific flags. NTF_USE is used to represent added_by_user
> flag since it sets it on fdb add and we don't have a 1:1 mapping for it.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  include/uapi/linux/if_bridge.h |  4 +++
>  net/bridge/br_fdb.c            | 55 ++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 2f3799cf14b2..4638d7e39f2a 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -815,6 +815,10 @@ enum {
>  /* embedded in BRIDGE_FLUSH_FDB */
>  enum {
>  	FDB_FLUSH_UNSPEC,
> +	FDB_FLUSH_NDM_STATE,
> +	FDB_FLUSH_NDM_STATE_MASK,
> +	FDB_FLUSH_NDM_FLAGS,
> +	FDB_FLUSH_NDM_FLAGS_MASK,
>  	__FDB_FLUSH_MAX
>  };
>  #define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 62f694a739e1..340a2ace1d5e 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -594,8 +594,40 @@ void br_fdb_flush(struct net_bridge *br,
>  	rcu_read_unlock();
>  }
>  
> +static unsigned long __ndm_state_to_fdb_flags(u16 ndm_state)
> +{
> +	unsigned long flags = 0;
> +
> +	if (ndm_state & NUD_PERMANENT)
> +		__set_bit(BR_FDB_LOCAL, &flags);
> +	if (ndm_state & NUD_NOARP)
> +		__set_bit(BR_FDB_STATIC, &flags);
> +
> +	return flags;
> +}
> +
> +static unsigned long __ndm_flags_to_fdb_flags(u16 ndm_flags)
> +{
> +	unsigned long flags = 0;
> +
> +	if (ndm_flags & NTF_USE)
> +		__set_bit(BR_FDB_ADDED_BY_USER, &flags);
> +	if (ndm_flags & NTF_EXT_LEARNED)
> +		__set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &flags);
> +	if (ndm_flags & NTF_OFFLOADED)
> +		__set_bit(BR_FDB_OFFLOADED, &flags);
> +	if (ndm_flags & NTF_STICKY)
> +		__set_bit(BR_FDB_STICKY, &flags);
> +
> +	return flags;
> +}
> +
>  static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
>  	[FDB_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
> +	[FDB_FLUSH_NDM_STATE]	= { .type = NLA_U16 },
> +	[FDB_FLUSH_NDM_FLAGS]	= { .type = NLA_U16 },
> +	[FDB_FLUSH_NDM_STATE_MASK]	= { .type = NLA_U16 },
> +	[FDB_FLUSH_NDM_FLAGS_MASK]	= { .type = NLA_U16 },

Might be better to use NLA_POLICY_MASK(NLA_U16, mask) and reject
unsupported states / flags instead of just ignoring them?

>  };
>  
>  int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
> @@ -610,6 +642,29 @@ int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
>  	if (err)
>  		return err;
>  
> +	if (fdb_flush_tb[FDB_FLUSH_NDM_STATE]) {
> +		u16 ndm_state = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_STATE]);
> +
> +		desc.flags |= __ndm_state_to_fdb_flags(ndm_state);
> +	}
> +	if (fdb_flush_tb[FDB_FLUSH_NDM_STATE_MASK]) {
> +		u16 ndm_state_mask;
> +
> +		ndm_state_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_STATE_MASK]);
> +		desc.flags_mask |= __ndm_state_to_fdb_flags(ndm_state_mask);
> +	}
> +	if (fdb_flush_tb[FDB_FLUSH_NDM_FLAGS]) {
> +		u16 ndm_flags = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS]);
> +
> +		desc.flags |= __ndm_flags_to_fdb_flags(ndm_flags);
> +	}
> +	if (fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]) {
> +		u16 ndm_flags_mask;
> +
> +		ndm_flags_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]);
> +		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
> +	}
> +
>  	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
>  		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
>  
> -- 
> 2.35.1
> 
