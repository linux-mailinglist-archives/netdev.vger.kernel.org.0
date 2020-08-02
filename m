Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0877239CE4
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHBWyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgHBWyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 18:54:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83262C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 15:54:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so18895252pgq.1
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 15:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zsKJnZQ+iDpiD2hQut7ybv5oAM4MZ6a2+0NCzEOOjwk=;
        b=e72+FoulSESefDBEV0z6B8eqbLMd52Z8fh+E+qi223vBxm43DIvDSU5ipfUpNSuzkK
         8IixBy2YhDJZTHJHnGhRsgRQuRDvkxRa83xEyk6+X7F+TjCo1Ntf5en+LK7wxWWav45p
         eecvCdrpvoBZFKwb5I5xUPnDiBByTENuwh9+t7dXQ/ysYtyEhHv0OemR7V2u5cBydSeR
         ssNo0Ja90K2aTqsHCTwYRZj1U+zMjHHAgAjPYeMaCv4bVbah9LPvP8yOVV70PFkCihro
         odzhGHoTizvCiftzkLCB/Wh+kaAiYCnE1H06x4+w3D1+EE+yVgsL8tSrYd1oswToSv/t
         PeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zsKJnZQ+iDpiD2hQut7ybv5oAM4MZ6a2+0NCzEOOjwk=;
        b=ZM0I3D9cK9xNjaXrRVaDJ2xih3USYlL4c/C3Y8tezNJs8QyhcJk6StEcRGVAa3/mRb
         9V8snDYml9pPIxQ9UnI5ml+FA+TGnUfToahI3nhxgHr81rgR+VFEhxMKgjfxIlAr2U9n
         56HRcXKziqrDGu5qmq5fjaaLfjgKV5Vrd4wZ4YED2K9CBbb/4sz8sipteu+Tn8/pQX7Y
         QFmPx4E+qyTzkYgQenpAc2NMI4thlEeNoZjMKa8vQPR3YSOPyoAeMEEDg2ibIe/I2OKE
         hXU54fl2bCyfQxDLTpd+rr8jfyznPLAePM303XdGWm2EYRlJ7J4o/4VBIlRSTFOgibjD
         xfRg==
X-Gm-Message-State: AOAM530rJ+BGovBwlDml+BwIugofOn+xQZ/wLUVAdqIjc7+/CNETsrcH
        EhlZ3538XeqNyIS42UHcrrDEcrqz
X-Google-Smtp-Source: ABdhPJxE6RFEQWgcF31RtmiSHFXy/K7Z6uHyIU4xeQ9x31txOsPMoIj6/xzieNckJ5kyLZHw15ZGdA==
X-Received: by 2002:a63:3308:: with SMTP id z8mr12386678pgz.409.1596408858825;
        Sun, 02 Aug 2020 15:54:18 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g10sm17696514pfb.82.2020.08.02.15.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 15:54:18 -0700 (PDT)
Date:   Sun, 2 Aug 2020 15:54:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v3 7/9] net: phy: dp83640: Use generic helper function
Message-ID: <20200802225415.GA8728@hoboy>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-8-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730080048.32553-8-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:00:46AM +0200, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/phy/dp83640.c | 69 +++++++++------------------------------
>  1 file changed, 16 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
> index 50fb7d16b75a..1cd987e3d0f2 100644
> --- a/drivers/net/phy/dp83640.c
> +++ b/drivers/net/phy/dp83640.c
> @@ -803,46 +803,28 @@ static int decode_evnt(struct dp83640_private *dp83640,
>  
>  static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
>  {
> -	unsigned int offset = 0;
> -	u8 *msgtype, *data = skb_mac_header(skb);
> -	__be16 *seqid;
> +	struct ptp_header *hdr;
> +	u8 msgtype;
> +	u16 seqid;
>  	u16 hash;
>  
>  	/* check sequenceID, messageType, 12 bit hash of offset 20-29 */
>  
> -	if (type & PTP_CLASS_VLAN)
> -		offset += VLAN_HLEN;
> -
> -	switch (type & PTP_CLASS_PMASK) {
> -	case PTP_CLASS_IPV4:
> -		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
> -		break;
> -	case PTP_CLASS_IPV6:
> -		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
> -		break;
> -	case PTP_CLASS_L2:
> -		offset += ETH_HLEN;
> -		break;
> -	default:
> +	hdr = ptp_parse_header(skb, type);
> +	if (!hdr)
>  		return 0;
> -	}
>  
> -	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
> -		return 0;
> +	msgtype = ptp_get_msgtype(hdr, type);
>  
> -	if (unlikely(type & PTP_CLASS_V1))
> -		msgtype = data + offset + OFF_PTP_CONTROL;
> -	else
> -		msgtype = data + offset;
> -	if (rxts->msgtype != (*msgtype & 0xf))
> +	if (rxts->msgtype != (msgtype & 0xf))
>  		return 0;
>  
> -	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
> -	if (rxts->seqid != ntohs(*seqid))
> +	seqid = be16_to_cpu(hdr->sequence_id);
> +	if (rxts->seqid != seqid)
>  		return 0;
>  
>  	hash = ether_crc(DP83640_PACKET_HASH_LEN,
> -			 data + offset + DP83640_PACKET_HASH_OFFSET) >> 20;
> +			 (unsigned char *)&hdr->source_port_identity) >> 20;

Looks like DP83640_PACKET_HASH_OFFSET can be removed now.

Tested-by: Richard Cochran <richardcochran@gmail.com>
