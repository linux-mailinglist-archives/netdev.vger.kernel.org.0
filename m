Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E316C6ED5
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjCWR3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjCWR3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFC81BE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F9A6282A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 17:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C3DC4339B;
        Thu, 23 Mar 2023 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679592548;
        bh=2wD+Yhui6h/4n2Ta6y2M26vmdm9ZRpyu3gJp179tOts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TEWFMs2D0i64WpH2S9EP8qUVA/F7cvTPng2TYaRooSEmnOoutidR9HMTHMfn7d9Zq
         coG5tvU7BSTRJXlDWPNMf2i9+p51R3WL9haYplJfUML3Y0W+oNDSymuBYCuKuOgsie
         11cXEYxBbxfX42DpMFTnjPCL/7EBBqsprXW2LGqD7yRWnHeQJVVISoAEPglnkrjusb
         Vz69Nsz26cvYEy606l7lo002jUYsCQRcVF6DE6SMZIOn0WIMyfGi41ZGjrcrvKn+h3
         aq36fo9YDcRWsoq8EIC6CEz4cvQ2RON4i6vYsEP20g0FWA/fniDR/xc3kr8V+iZY9h
         6t+PUcdYY4GDg==
Date:   Thu, 23 Mar 2023 10:29:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Jie Wang" <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v7 net-next 1/7] netlink: Add a macro to set policy
 message with format string
Message-ID: <20230323102906.3fb3d658@kernel.org>
In-Reply-To: <20230323163610.1281468-2-shayagr@amazon.com>
References: <20230323163610.1281468-1-shayagr@amazon.com>
        <20230323163610.1281468-2-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 18:36:04 +0200 Shay Agroskin wrote:
> +#define NL_SET_ERR_MSG_ATTR_POL_FMT(extack, attr, pol, fmt, args...) do {	\
> +	struct netlink_ext_ack *__extack = (extack);				\
> +										\
> +	if (!__extack)								\
> +		break;								\
> +										\
> +	if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,		\
> +		     "%s" fmt "%s", "", ##args, "") >=				\
> +	    NETLINK_MAX_FMTMSG_LEN)						\
> +		net_warn_ratelimited("%s" fmt "%s", "truncated extack: ",       \
> +				     ##args, "\n");				\
> +										\
> +	do_trace_netlink_extack(__extack->_msg_buf);				\
> +										\
> +	__extack->_msg = __extack->_msg_buf;					\
> +	__extack->bad_attr = (attr);						\
> +	__extack->policy = (pol);						\
> +} while (0)

Given the misunderstanding let me give you an exception to the 24h 
wait period. Feel free to send v8 when ready, I'll drop this version 
from pw.
