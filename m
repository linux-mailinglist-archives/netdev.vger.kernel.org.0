Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4423A481C96
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhL3Nl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:41:28 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:54319 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235159AbhL3Nl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:41:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 68B735802B9;
        Thu, 30 Dec 2021 08:41:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 30 Dec 2021 08:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4AY61D
        BtQwXFCFWHjL38zj2+iJ873KyOoGnaOBAx+Ec=; b=fL96CM3VIZzVuFOhlLf39o
        D2gTH4HMzOOUyr6UktCZqU5/Wj4cGhKDyGeTloPAnec+tzLbhqhXBYLq1BQO7Eii
        xl3z5OJrJVYd2Z8FYZE0e0NxWZ9Q6PMzM7RX0ZCkqHsyZk5dY1HLLO5Vt3359MP3
        T+DrBy5n71dOdZg1cbVfHt1LoEVOS38jjdiiMb/NDLyRXK0Bwm5DMJDE2IbmIYV4
        LKg09YFpqkfeHBcA06H23jPnqz0yBiF6hzIuXGEgCMBk6nThzpV+sMI9JI+GccF+
        Sa0DeMiHoIK0+9Ocp9gHzGhp6/zNu+o/YeCDuyiOpdLmH2SrULuGrkKTh/ekqPrw
        ==
X-ME-Sender: <xms:B7fNYTxk5ee88EBxmjM3E11ZJuhaMwRFUw2svchiQXshG2YdivqnIw>
    <xme:B7fNYbSx_4syuE2nIr6Wx9EjMV-ZlyqV1hUgRSHOENJClvZe78Eb2qIQVdlbJE_6z
    AnDLJOWTvVc2ks>
X-ME-Received: <xmr:B7fNYdW51jYBWVmZs0ZNX-SN_NRzw2SeyleHZcRt_nDyPAGVwiDpo9DsSaaMSIE54POhybYVHY-EBaXsm-l8Z-FZVOrC6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:B7fNYdjpoY_w_VnsCJbrbzkCyBbL178KGlaHYghrJsKkVoGgjdi2nA>
    <xmx:B7fNYVBlbL-2SpRDZhGC4rQbeH6COwhwNbIiJ9CthG3AIq0g1PZ7OA>
    <xmx:B7fNYWKf0ypFaR8FGEPBPfTVepAaXcCFDMbfp3xh1VeEKHWFd15CMg>
    <xmx:B7fNYZ7r9uslSANGbKF5pfQ6PivFpDXLMmDqwfIlkbeDWWkbuTo-Ow>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 08:41:26 -0500 (EST)
Date:   Thu, 30 Dec 2021 15:41:21 +0200
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
Subject: Re: [PATCH net-next v2 1/6] net: marvell: prestera: add virtual
 router ABI
Message-ID: <Yc23AVK2STkzGuHg@shredder>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-2-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227215233.31220-2-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 11:52:26PM +0200, Yevhen Orlov wrote:
> Add functions and structures to allocate virtual router.
> prestera_hw_vr_create() return index of allocated VR so that we can move

s/return/returns/

> forward and also add another objects (e.g. router interface),
> which has link to VR.
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
>  .../ethernet/marvell/prestera/prestera_hw.c   | 42 +++++++++++++++++++
>  .../ethernet/marvell/prestera/prestera_hw.h   |  4 ++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> index 6282c9822e2b..8783adbad593 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -53,6 +53,9 @@ enum prestera_cmd_type_t {
>  	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
>  	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
>  
> +	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
> +	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
> +
>  	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
>  
>  	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
> @@ -480,6 +483,18 @@ struct prestera_msg_rxtx_resp {
>  	__le32 map_addr;
>  };
>  
> +struct prestera_msg_vr_req {
> +	struct prestera_msg_cmd cmd;
> +	__le16 vr_id;
> +	u8 __pad[2];
> +};
> +
> +struct prestera_msg_vr_resp {
> +	struct prestera_msg_ret ret;
> +	__le16 vr_id;
> +	u8 __pad[2];
> +};
> +
>  struct prestera_msg_lag_req {
>  	struct prestera_msg_cmd cmd;
>  	__le32 port;
> @@ -549,6 +564,7 @@ static void prestera_hw_build_tests(void)
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
>  
>  	/* check responses */
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
> @@ -561,6 +577,7 @@ static void prestera_hw_build_tests(void)
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
>  
>  	/* check events */
>  	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
> @@ -1752,6 +1769,31 @@ int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
>  			    &req.cmd, sizeof(req));
>  }
>  
> +int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
> +{
> +	int err;
> +	struct prestera_msg_vr_resp resp;
> +	struct prestera_msg_vr_req req;

Order local variables from longest to shortest (reverse xmas tree), so
'int err' should be at the end. Same in other places I might have missed

> +
> +	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_VR_CREATE,
> +			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> +	if (err)
> +		return err;
> +
> +	*vr_id = __le16_to_cpu(resp.vr_id);
> +	return err;
> +}
> +
> +int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id)
> +{
> +	struct prestera_msg_vr_req req = {
> +		.vr_id = __cpu_to_le16(vr_id),
> +	};
> +
> +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_VR_DELETE, &req.cmd,
> +			    sizeof(req));
> +}
> +
>  int prestera_hw_rxtx_init(struct prestera_switch *sw,
>  			  struct prestera_rxtx_params *params)
>  {
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> index 0496e454e148..6d9fafad451d 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> @@ -238,6 +238,10 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
>  int prestera_hw_span_unbind(const struct prestera_port *port);
>  int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
>  
> +/* Virtual Router API */
> +int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
> +int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
> +
>  /* Event handlers */
>  int prestera_hw_event_handler_register(struct prestera_switch *sw,
>  				       enum prestera_event_type type,
> -- 
> 2.17.1
> 
