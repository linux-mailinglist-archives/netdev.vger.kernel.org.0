Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2000C6D4486
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjDCMfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjDCMfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:35:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893BF113FF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pC0wtOr+lO2bhGgrQVPulNiPhlHAGEXnCYuWKEGLSQE=; b=bUJAiiz03Y+7kQxc66CC1DBkmG
        DiWUqT3ZSQdCPh0oo44BhNwByaN6p5mlGEsWByTyu4KVULgK9G+OC0kAFP8wfDxR4CD6v8Zp6F/r+
        khwbTqLoN/JZ+jf9ZCuo0i02ehFGDF+IEVqp76rhNTw7gmeztLa8DaAPAGjsGubfmOuA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjJOp-009HQf-Ba; Mon, 03 Apr 2023 14:35:03 +0200
Date:   Mon, 3 Apr 2023 14:35:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 1/6] net: txgbe: Add software nodes to support
 phylink
Message-ID: <27f26edc-5248-4562-8c26-c5dcce9dde59@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064528.343866-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	nodes->gpio_props[0] = PROPERTY_ENTRY_STRING("pinctrl-names", "default");
> +	swnodes[SWNODE_GPIO] = NODE_PROP(nodes->gpio_name, nodes->gpio_props);
> +	nodes->gpio0_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 0, GPIO_ACTIVE_HIGH);
> +	nodes->gpio1_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 1, GPIO_ACTIVE_HIGH);
> +	nodes->gpio2_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 2, GPIO_ACTIVE_LOW);
> +	nodes->gpio3_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 3, GPIO_ACTIVE_HIGH);
> +	nodes->gpio4_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 4, GPIO_ACTIVE_HIGH);
> +	nodes->gpio5_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 5, GPIO_ACTIVE_HIGH);

Please could you add some comments indicating what these 6 GPIOs
are. Or use more descriptive names than gpioX_ref.

> +int txgbe_init_phy(struct txgbe *txgbe)
> +{
> +	int ret;
> +
> +	ret = txgbe_swnodes_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to register software nodes\n");
> +		return ret;
> +	}
> +
> +	return 0;


I assume this function is going to be extended with later patches?
Otherwise you can simply it.

	  Andrew
