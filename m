Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9D84FB693
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243892AbiDKI75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236336AbiDKI74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:59:56 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A673EBA5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:57:43 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7CDE73202052;
        Mon, 11 Apr 2022 04:57:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Apr 2022 04:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649667462; x=
        1649753862; bh=yNRP+BeaZ6KoeHmUkIOEOQrMJmaiMlpxTKCXBPTBYvM=; b=b
        Ljb6dEOxLaf4F4CwnDSZ+7lJvIcyfCLKU8wi6AeFRfUkJH8VF5TKN2ioFZJMOdzp
        UmLMj30sFUn/cr3Jn0bhFlZurtDJI1PwRvPBcqDfkfXe8vJ4QFjw7fyF1x2MQFjW
        vmWBHvO213lUfaGt+ScDUgdFUBDeTLI0db4AqlgE7pNZzawBt17jY1mX2UvWCu9C
        RTBYsftd61BkBKmZnHvr1REKkSBPlGnLIceV4sT0JD65CE1QFj/K2ahRgAb+91gO
        w1z7h8ZiTvzcOn5vvIsQcmA6gEMh/0KjfvlwDnazXtd+xoaNazGTMQH0psol/DQJ
        cJ0rlPN2NBHprZGTGpu/A==
X-ME-Sender: <xms:he1TYvBGOdipG_iNUplpETclk-GuX0ktfQ9LQrWJ4wXuF15-80KOJA>
    <xme:he1TYljwVFMlCjHnbuo_sTKsQytoXHE04J5qkDVw6aONeYsMnnuK3FqXSSHm2q-wZ
    SMEV6ynyCFJzqs>
X-ME-Received: <xmr:he1TYqm9maOzmV2U2_AEw_WPpLjQB9xaKZ7Nq4s5l7jloO-vwX3IIPpRw4U6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hu1TYhwDi3OhHPFUzsUHo3U7qZWH8-yf6cPiuzazm7iEu-MDnmodNA>
    <xmx:hu1TYkQ_D3mzUJ3z4XiqlGEZS_nc2OGNta_rcFXPW38imsS1UoUmnw>
    <xmx:hu1TYkak6wnktXgvDZfe7yWfPf649Nh4nqDkEMHz24R_8ekyNvevPw>
    <xmx:hu1TYqcMLsBQjGyBtM2T8RCJN10DusjUtNQBdY9tlzr3fH8lC80MEw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 04:57:41 -0400 (EDT)
Date:   Mon, 11 Apr 2022 11:57:39 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 5/6] net: bridge: fdb: add support for flush
 filtering based on ifindex
Message-ID: <YlPtg6eHuWaOEy/7@shredder>
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-6-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409105857.803667-6-razor@blackwall.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:58:56PM +0300, Nikolay Aleksandrov wrote:
> Add support for fdb flush filtering based on destination ifindex. The
> ifindex must either match a port's device ifindex or the bridge's.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  include/uapi/linux/if_bridge.h | 1 +
>  net/bridge/br_fdb.c            | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 4638d7e39f2a..67ee12586844 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -819,6 +819,7 @@ enum {
>  	FDB_FLUSH_NDM_STATE_MASK,
>  	FDB_FLUSH_NDM_FLAGS,
>  	FDB_FLUSH_NDM_FLAGS_MASK,
> +	FDB_FLUSH_PORT_IFINDEX,
>  	__FDB_FLUSH_MAX
>  };
>  #define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 340a2ace1d5e..53208adf7474 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -628,6 +628,7 @@ static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
>  	[FDB_FLUSH_NDM_FLAGS]	= { .type = NLA_U16 },
>  	[FDB_FLUSH_NDM_STATE_MASK]	= { .type = NLA_U16 },
>  	[FDB_FLUSH_NDM_FLAGS_MASK]	= { .type = NLA_U16 },
> +	[FDB_FLUSH_PORT_IFINDEX]	= { .type = NLA_S32 },
>  };
>  
>  int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
> @@ -664,6 +665,12 @@ int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
>  		ndm_flags_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]);
>  		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
>  	}
> +	if (fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]) {
> +		int port_ifidx;
> +
> +		port_ifidx = nla_get_u32(fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]);
> +		desc.port_ifindex = port_ifidx;

Commit message says "ifindex must either match a port's device ifindex
or the bridge's", but there is no validation. I realize such an
operation won't flush anything, but it's cleaner to just reject it here.

> +	}
>  
>  	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
>  		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
> -- 
> 2.35.1
> 
