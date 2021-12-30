Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D683481C9C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhL3Noz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:44:55 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46827 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239674AbhL3Noy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:44:54 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 89984580353;
        Thu, 30 Dec 2021 08:44:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 30 Dec 2021 08:44:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kUnCTK
        VccAG9TDr0bmNbdN0Ycd6Gkh0pcViXdB0HZ8k=; b=HjAaI/i/hWeNFn5zOteE5B
        ZdW9+OLFa8RR8pNQCf+vL0fcFOaYvIgw8D8eIJhbz1DBR+fCwNryXLjUBgT+5Mrv
        D3TjA3sSvH7raKUW7X6Tbz9yivqCi8e6+l20YCQmzxN0C0sbREDBw/pvEI9y2oz3
        Imz4wD4mXTwB+BV9hT7mPbosn0LFLWh4U4EqOJAGR46YKejDPU7sBt+UYzMSivAa
        7qJ6qcaHcDtq4I3pTMb8bHn08yyL3ukAZmt5uHkYDpDmyvAkiDoiTcdFx71w+pRT
        xxcpdJmJAXPnSp0YSAGYlx1NCT/7+F9mq5/EAdtYv/jiwL0G5AIEjlJq9EzNLT6A
        ==
X-ME-Sender: <xms:1bfNYXxtA89VDPHH7Ca6qnrYZEt91Jmx8ROYXEIUNFKsEV4aXq-pHg>
    <xme:1bfNYfQhGfcUudC1Rh2DHPhAbfXiYBFJhlSQ6xWUq1BPKVvI84umWRUWQ-cLTIsKr
    r23EncgeEf00Zw>
X-ME-Received: <xmr:1bfNYRUFhaZAyInpc72_n5bnlrtkulEbex-gX5J6hiIfc8eQmSlikcd4H0ErpA8fmYazJwt5sOUgd6nwXkWKBWOORKNkHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1bfNYRh0c5PmxQNhibF6ONwiNhsLJgTjaTFkryO-rRqnVLX9Dbyx8w>
    <xmx:1bfNYZDC2ZSIw4nslJOC49vAKHWAG5aIXfbjBIENRoZd6Sx-fiIs4Q>
    <xmx:1bfNYaLTK8Os0bZWWOOeeIJOju_qGnh0XviKI1GcY8tMs2oDwEZZSQ>
    <xmx:1bfNYd4YdjgKiudx2QnP9yzKPBHvFRLYkezWJlu6Ps0ggQzj8kU4nQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 08:44:52 -0500 (EST)
Date:   Thu, 30 Dec 2021 15:44:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/6] net: marvell: prestera: Add router
 interface ABI
Message-ID: <Yc230kOuj+tHOkjQ@shredder>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-3-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227215233.31220-3-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 11:52:27PM +0200, Yevhen Orlov wrote:
> Add functions to enable routing on port, which is not in vlan.
> Also we can enable routing on vlan.

I don't understand these two lines. Can you explain for which netdev
types you can create a router interface?

> prestera_hw_rif_create() take index of allocated virtual router.

s/take/takes/

> 
> Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
> v1-->v2
> * No changes
> ---
>  .../net/ethernet/marvell/prestera/prestera.h  | 23 +++++
>  .../ethernet/marvell/prestera/prestera_hw.c   | 97 +++++++++++++++++++
>  .../ethernet/marvell/prestera/prestera_hw.h   |  7 ++
>  3 files changed, 127 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
> index 797b2e4d3551..636caf492531 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera.h
> @@ -225,6 +225,29 @@ struct prestera_event {
>  	};
>  };
>  
> +enum prestera_if_type {
> +	/* the interface is of port type (dev,port) */
> +	PRESTERA_IF_PORT_E = 0,
> +
> +	/* the interface is of lag type (lag-id) */
> +	PRESTERA_IF_LAG_E = 1,
> +
> +	/* the interface is of Vid type (vlan-id) */
> +	PRESTERA_IF_VID_E = 3,
> +};
> +
> +struct prestera_iface {
> +	enum prestera_if_type type;
> +	struct {
> +		u32 hw_dev_num;
> +		u32 port_num;
> +	} dev_port;
> +	u32 hw_dev_num;
> +	u16 vr_id;
> +	u16 lag_id;
> +	u16 vlan_id;
> +};
> +
>  struct prestera_switchdev;
>  struct prestera_span;
>  struct prestera_rxtx;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> index 8783adbad593..51fc841b1e7a 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -53,6 +53,8 @@ enum prestera_cmd_type_t {
>  	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
>  	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
>  
> +	PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE = 0x600,
> +	PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE = 0x601,
>  	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
>  	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
>  
> @@ -483,6 +485,36 @@ struct prestera_msg_rxtx_resp {
>  	__le32 map_addr;
>  };
>  
> +struct prestera_msg_iface {
> +	union {
> +		struct {
> +			__le32 dev;
> +			__le32 port;
> +		};
> +		__le16 lag_id;
> +	};
> +	__le16 vr_id;
> +	__le16 vid;
> +	u8 type;
> +	u8 __pad[3];
> +};
> +
> +struct prestera_msg_rif_req {
> +	struct prestera_msg_cmd cmd;
> +	struct prestera_msg_iface iif;
> +	__le32 mtu;
> +	__le16 rif_id;
> +	__le16 __reserved;
> +	u8 mac[ETH_ALEN];
> +	u8 __pad[2];
> +};
> +
> +struct prestera_msg_rif_resp {
> +	struct prestera_msg_ret ret;
> +	__le16 rif_id;
> +	u8 __pad[2];
> +};
> +
>  struct prestera_msg_vr_req {
>  	struct prestera_msg_cmd cmd;
>  	__le16 vr_id;
> @@ -564,8 +596,12 @@ static void prestera_hw_build_tests(void)
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_req) != 36);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
>  
> +	/*  structure that are part of req/resp fw messages */
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
> +
>  	/* check responses */
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
> @@ -577,6 +613,7 @@ static void prestera_hw_build_tests(void)
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_resp) != 12);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
>  
>  	/* check events */
> @@ -1769,6 +1806,66 @@ int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
>  			    &req.cmd, sizeof(req));
>  }
>  
> +static int prestera_iface_to_msg(struct prestera_iface *iface,
> +				 struct prestera_msg_iface *msg_if)
> +{
> +	switch (iface->type) {
> +	case PRESTERA_IF_PORT_E:
> +	case PRESTERA_IF_VID_E:
> +		msg_if->port = __cpu_to_le32(iface->dev_port.port_num);
> +		msg_if->dev = __cpu_to_le32(iface->dev_port.hw_dev_num);
> +		break;
> +	case PRESTERA_IF_LAG_E:
> +		msg_if->lag_id = __cpu_to_le16(iface->lag_id);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	msg_if->vr_id = __cpu_to_le16(iface->vr_id);
> +	msg_if->vid = __cpu_to_le16(iface->vlan_id);
> +	msg_if->type = iface->type;
> +	return 0;
> +}
> +
> +int prestera_hw_rif_create(struct prestera_switch *sw,
> +			   struct prestera_iface *iif, u8 *mac, u16 *rif_id)
> +{
> +	struct prestera_msg_rif_req req;
> +	struct prestera_msg_rif_resp resp;
> +	int err;

Same comment as before

> +
> +	memcpy(req.mac, mac, ETH_ALEN);

Each RIF can use whatever MAC it wants? You don't have limitations on
common prefix or something like that? Guess it depends on how many RIFs
you can support

> +
> +	err = prestera_iface_to_msg(iif, &req.iif);
> +	if (err)
> +		return err;
> +
> +	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE,
> +			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> +	if (err)
> +		return err;
> +
> +	*rif_id = __le16_to_cpu(resp.rif_id);
> +	return err;
> +}
> +
> +int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
> +			   struct prestera_iface *iif)
> +{
> +	struct prestera_msg_rif_req req = {
> +		.rif_id = __cpu_to_le16(rif_id),
> +	};
> +	int err;
> +
> +	err = prestera_iface_to_msg(iif, &req.iif);
> +	if (err)
> +		return err;
> +
> +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE, &req.cmd,
> +			    sizeof(req));
> +}
> +
>  int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
>  {
>  	int err;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> index 6d9fafad451d..3ff12bae5909 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> @@ -137,6 +137,7 @@ struct prestera_rxtx_params;
>  struct prestera_acl_hw_action_info;
>  struct prestera_acl_iface;
>  struct prestera_counter_stats;
> +struct prestera_iface;
>  
>  /* Switch API */
>  int prestera_hw_switch_init(struct prestera_switch *sw);
> @@ -238,6 +239,12 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
>  int prestera_hw_span_unbind(const struct prestera_port *port);
>  int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
>  
> +/* Router API */
> +int prestera_hw_rif_create(struct prestera_switch *sw,
> +			   struct prestera_iface *iif, u8 *mac, u16 *rif_id);
> +int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
> +			   struct prestera_iface *iif);
> +
>  /* Virtual Router API */
>  int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
>  int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
> -- 
> 2.17.1
> 
