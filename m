Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688B220F99C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732022AbgF3Qi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:38:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:35370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbgF3Qi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 12:38:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 78A7AAE07;
        Tue, 30 Jun 2020 16:38:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 14AAE604DC; Tue, 30 Jun 2020 18:38:56 +0200 (CEST)
Date:   Tue, 30 Jun 2020 18:38:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        o.rempel@pengutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        jacob.e.keller@intel.com, mlxsw@mellanox.com
Subject: Re: [PATCH ethtool 1/3] netlink: expand ETHTOOL_LINKSTATE with
 extended state attributes
Message-ID: <20200630163856.si5vs7ejikdzbb4y@lion.mk-sys.cz>
References: <20200630092412.11432-1-amitc@mellanox.com>
 <20200630092412.11432-2-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630092412.11432-2-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:24:10PM +0300, Amit Cohen wrote:
> Add ETHTOOL_A_LINKSTATE_EXT_STATE to expose general extended state.
> 
> Add ETHTOOL_A_LINKSTATE_EXT_SUBSTATE to expose more information in
> addition to the extended state.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> ---
>  netlink/desc-ethtool.c       | 2 ++
>  uapi/linux/ethtool_netlink.h | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
> index 98b898e..bce22e2 100644
> --- a/netlink/desc-ethtool.c
> +++ b/netlink/desc-ethtool.c
> @@ -95,6 +95,8 @@ static const struct pretty_nla_desc __linkstate_desc[] = {
>  	NLATTR_DESC_BOOL(ETHTOOL_A_LINKSTATE_LINK),
>  	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI),
>  	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI_MAX),
> +	NLATTR_DESC_U8(ETHTOOL_A_LINKSTATE_EXT_STATE),
> +	NLATTR_DESC_U8(ETHTOOL_A_LINKSTATE_EXT_SUBSTATE),
>  };
>  
>  static const struct pretty_nla_desc __debug_desc[] = {
> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
> index b18e7bc..0922ca6 100644
> --- a/uapi/linux/ethtool_netlink.h
> +++ b/uapi/linux/ethtool_netlink.h
> @@ -236,6 +236,8 @@ enum {
>  	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
>  	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
>  	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
> +	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
> +	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKSTATE_CNT,

Please do not mix uapi header updates with other changes. Once the
kernel counterpart is in net-next, update all headers in uapi/ to
a net-next snapshot as described at

  https://www.kernel.org/pub/software/network/ethtool/devel.html

and use that as first commit of your series.

Michal
