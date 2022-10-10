Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63755FA3B3
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 20:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJJSxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 14:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJJSxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 14:53:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00522786E5;
        Mon, 10 Oct 2022 11:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mQOcbgqlc7YWpQLopbZ7qox0JJ82m+Wb0DJKAyjCUZA=; b=y14sdLtWMIQwI8Ff8AWvJCr39k
        4rC1V6N7RyYWmjQadNm1cDcVtxErCQ4NZJGXFTwPMydS3R4YskDUFX4eUVTkFYLzM42D1OyCBhY35
        TuJMX63oSz2MGChjQs/0wO1+5DuV0cCpgdm4W5+dMrvvpmY0ztEl3EbRHII8Q4D8vCjc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ohxtd-001e6Y-Pl; Mon, 10 Oct 2022 20:53:01 +0200
Date:   Mon, 10 Oct 2022 20:53:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
Message-ID: <Y0RqDd/P3XkrSzc3@lunn.ch>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010111459.18958-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /* Special struct emulating a Ethernet header */
>  struct qca_mgmt_ethhdr {
> -	u32 command;		/* command bit 31:0 */
> -	u32 seq;		/* seq 63:32 */
> -	u32 mdio_data;		/* first 4byte mdio */
> +	__le32 command;		/* command bit 31:0 */
> +	__le32 seq;		/* seq 63:32 */
> +	__le32 mdio_data;		/* first 4byte mdio */
>  	__be16 hdr;		/* qca hdr */
>  } __packed;

It looks odd that hdr is BE while the rest are LE. Did you check this?

   Andrew
