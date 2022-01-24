Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A33498439
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbiAXQFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiAXQFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:05:41 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A622CC06173B;
        Mon, 24 Jan 2022 08:05:40 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c24so55239664edy.4;
        Mon, 24 Jan 2022 08:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MxIPg35/hMEKb65dLOLyBc6qfzIYj4rxK6ntVoYuCVw=;
        b=E92jNsFGeJT0SRoqkUQNuRyI6Y6aDMlFx71e5/ovdYSpvFtyPmuoOIIfVGnZtqi2CN
         NfbUNJehdtkKC8JzS0c3Jr/K3qYUKfFPRC0tF4LYqBmxz3Mb9ECqE0xLCoalOyEv2jUA
         GOmM6jdYX3yonxgqJ/eqVFgFm/eGNHK1FgQbaPSPN/7vXXQ0CFNhaRdknuM6KbxdfMCN
         N4vzImjnbqX+dhIdX/OXGayHBx/uqWnJVEBLTqqXvVCQLAblM4q7jjBekzZpi6SzHtz5
         YthRftMipsTan/D43hwvwwvTjJZ8vIsbxBKmdZKGpQi+5cNIdmzt9LPMBqxrolY5jeUF
         RBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MxIPg35/hMEKb65dLOLyBc6qfzIYj4rxK6ntVoYuCVw=;
        b=fmnxIs5gv5j3UT3oBw/PhbKMNg1RvD5HTGC09M9xVZO6SWiLb/y4fvNhAB5OK8W4XU
         9HHR++N5eVI4YCdoW7CNxGGXGWG1zD6bDw44gNiov0vCUTd6NpPz+nF30w8i34SHmvp8
         GFhyYc8Gsi3XvUw17RPqFAZuyA3uWAIpJNThhISv+GWXL2vr1PfH2PzjI6HOUP2Tffqf
         dzz3fqa9BX8tpL2ZbpUBUGzv5r+zeRtg5v9Dr0Hfh+fGRLIogx8cnysRfEZJ8UsbuMGB
         hU5ibbOymiq87KqG0e6T+Y5zI5h2OWe3tQ9wUcc+7EldynAX4CYEotbyL2/5ujts9SaC
         SvLg==
X-Gm-Message-State: AOAM533iVtakFXkh/4K2Idkw7Xxg/nKdOUwaHjLw0YPb7vRwgb6I3Gab
        Q5PPEvNYM2PVqmL8gIirAr5+0kphwfs=
X-Google-Smtp-Source: ABdhPJzkG5fWlvtS/zga4JjoPThId1pA6wmNsDl6Zz5DTDm8lXs9qm5k9MFk7WwstZhQLQ/tUAbJfg==
X-Received: by 2002:a05:6402:40d5:: with SMTP id z21mr13315228edb.239.1643040339182;
        Mon, 24 Jan 2022 08:05:39 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id z18sm5050049ejb.112.2022.01.24.08.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:05:38 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:05:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
Message-ID: <20220124160537.6xqdd337mg43ivn6@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:27AM +0100, Ansuel Smith wrote:
> Add all the required define to prepare support for mgmt read/write in
> Ethernet packet. Any packet of this type has to be dropped as the only
> use of these special packet is receive ack for an mgmt write request or
> receive data for an mgmt read request.
> A struct is used that emulates the Ethernet header but is used for a
> different purpose.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  include/linux/dsa/tag_qca.h | 44 +++++++++++++++++++++++++++++++++++++
>  net/dsa/tag_qca.c           | 13 ++++++++---
>  2 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index c02d2d39ff4a..1a02f695f3a3 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -12,10 +12,54 @@
>  #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
>  #define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
>  
> +/* Packet type for recv */
> +#define QCA_HDR_RECV_TYPE_NORMAL	0x0
> +#define QCA_HDR_RECV_TYPE_MIB		0x1
> +#define QCA_HDR_RECV_TYPE_RW_REG_ACK	0x2
> +
>  #define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
>  #define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
>  #define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
>  #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
>  #define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
>  
> +/* Packet type for xmit */
> +#define QCA_HDR_XMIT_TYPE_NORMAL	0x0
> +#define QCA_HDR_XMIT_TYPE_RW_REG	0x1
> +
> +/* Check code for a valid mgmt packet. Switch will ignore the packet
> + * with this wrong.
> + */
> +#define QCA_HDR_MGMT_CHECK_CODE_VAL	0x5
> +
> +/* Specific define for in-band MDIO read/write with Ethernet packet */
> +#define QCA_HDR_MGMT_SEQ_LEN		4 /* 4 byte for the seq */
> +#define QCA_HDR_MGMT_COMMAND_LEN	4 /* 4 byte for the command */
> +#define QCA_HDR_MGMT_DATA1_LEN		4 /* First 4 byte for the mdio data */
> +#define QCA_HDR_MGMT_HEADER_LEN		(QCA_HDR_MGMT_SEQ_LEN + \
> +					QCA_HDR_MGMT_COMMAND_LEN + \
> +					QCA_HDR_MGMT_DATA1_LEN)
> +
> +#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
> +#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
> +
> +#define QCA_HDR_MGMT_PKG_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
> +					QCA_HDR_LEN + \
> +					QCA_HDR_MGMT_DATA2_LEN + \
> +					QCA_HDR_MGMT_PADDING_LEN)

s/PKG/PKT/

> +
> +#define QCA_HDR_MGMT_SEQ_NUM		GENMASK(31, 0)  /* 63, 32 */
> +#define QCA_HDR_MGMT_CHECK_CODE		GENMASK(31, 29) /* 31, 29 */
> +#define QCA_HDR_MGMT_CMD		BIT(28)		/* 28 */
> +#define QCA_HDR_MGMT_LENGTH		GENMASK(23, 20) /* 23, 20 */
> +#define QCA_HDR_MGMT_ADDR		GENMASK(18, 0)  /* 18, 0 */
> +
> +/* Special struct emulating a Ethernet header */
> +struct mgmt_ethhdr {
> +	u32 command;		/* command bit 31:0 */
> +	u32 seq;		/* seq 63:32 */
> +	u32 mdio_data;		/* first 4byte mdio */
> +	__be16 hdr;		/* qca hdr */
> +} __packed;

Could you name this something a bit more specific, like qca_mgmt_ethhdr?

> +
>  #endif /* __TAG_QCA_H */
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index f8df49d5956f..c57d6e1a0c0c 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -32,10 +32,10 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  {
> -	u8 ver;
> -	u16  hdr;
> -	int port;
> +	u16 hdr, pk_type;
>  	__be16 *phdr;
> +	int port;
> +	u8 ver;
>  
>  	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
>  		return NULL;
> @@ -48,6 +48,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  	if (unlikely(ver != QCA_HDR_VERSION))
>  		return NULL;
>  
> +	/* Get pk type */
> +	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
> +
> +	/* Ethernet MDIO read/write packet */
> +	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
> +		return NULL;
> +
>  	/* Remove QCA tag and recalculate checksum */
>  	skb_pull_rcsum(skb, QCA_HDR_LEN);
>  	dsa_strip_etype_header(skb, QCA_HDR_LEN);
> -- 
> 2.33.1
> 

