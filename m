Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602B15FA66E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJJUi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJJUin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:38:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E50356CC;
        Mon, 10 Oct 2022 13:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Hjyn8dqoIEtIO27l3MzacOUF4IDEr7dDUJYhUQFgMXo=; b=F8dZ+DVrjvmQ0TStDXpOGnk/sd
        O/3IcPkTalZQK7fEPgfOWlCFlN7txtkkDwqyn5jB+tA8vL1S9pa60z8zmuKzX8+8bxTIALJSSB1iE
        7Njin9Y1I/oMulkxaZTXJn+6v7hNxpxR8bsEp4n2UADO5fPG54ay3+uGdf4UbBC2UycE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ohzXV-001eex-BB; Mon, 10 Oct 2022 22:38:17 +0200
Date:   Mon, 10 Oct 2022 22:38:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Soha Jin <soha@lohu.info>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yangyu Chen <cyy@cyyself.name>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: stmmac: use fwnode instead of of to configure
 driver
Message-ID: <Y0SCuaVpAnbpMk72@lunn.ch>
References: <20221009162247.1336-1-soha@lohu.info>
 <20221009162247.1336-2-soha@lohu.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009162247.1336-2-soha@lohu.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
> -	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
> -	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
> -	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
> -	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
> -	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
> +	axi->axi_lpi_en = fwnode_property_read_bool(fwnode, "snps,lpi_en");
> +	axi->axi_xit_frm = fwnode_property_read_bool(fwnode, "snps,xit_frm");
> +	axi->axi_kbbe = fwnode_property_read_bool(fwnode, "snps,axi_kbbe");
> +	axi->axi_fb = fwnode_property_read_bool(fwnode, "snps,axi_fb");
> +	axi->axi_mb = fwnode_property_read_bool(fwnode, "snps,axi_mb");
> +	axi->axi_rb =  fwnode_property_read_bool(fwnode, "snps,axi_rb");
>  
> -	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
> +	if (fwnode_property_read_u32(fwnode, "snps,wr_osr_lmt",
> +				     &axi->axi_wr_osr_lmt))
>  		axi->axi_wr_osr_lmt = 1;
> -	if (of_property_read_u32(np, "snps,rd_osr_lmt", &axi->axi_rd_osr_lmt))
> +	if (fwnode_property_read_u32(fwnode, "snps,rd_osr_lmt",
> +				     &axi->axi_rd_osr_lmt))
>  		axi->axi_rd_osr_lmt = 1;
> -	of_property_read_u32_array(np, "snps,blen", axi->axi_blen, AXI_BLEN);
> -	of_node_put(np);
> +	fwnode_property_read_u32_array(fwnode, "snps,blen", axi->axi_blen,
> +				       AXI_BLEN);
> +	fwnode_handle_put(fwnode);

None of these are documented as being valid in ACPI. Do you need to
ensure they only come from DT, or you document them for ACPI, and get
the ACPI maintainers to ACK that they are O.K.

>  
>  	return axi;
>  }
>  
>  /**
> - * stmmac_mtl_setup - parse DT parameters for multiple queues configuration
> + * stmmac_mtl_setup - parse properties for multiple queues configuration
>   * @pdev: platform device
>   * @plat: enet data
>   */
>  static int stmmac_mtl_setup(struct platform_device *pdev,
>  			    struct plat_stmmacenet_data *plat)
>  {
> -	struct device_node *q_node;
> -	struct device_node *rx_node;
> -	struct device_node *tx_node;
> +	struct fwnode_handle *fwnode = dev_fwnode(&pdev->dev);
> +	struct fwnode_handle *q_node;
> +	struct fwnode_handle *rx_node;
> +	struct fwnode_handle *tx_node;
>  	u8 queue = 0;
>  	int ret = 0;
>  
> -	/* For backwards-compatibility with device trees that don't have any
> +	/* For backwards-compatibility with properties that don't have any
>  	 * snps,mtl-rx-config or snps,mtl-tx-config properties, we fall back
>  	 * to one RX and TX queues each.
>  	 */

Backward compatibility only applies to DT. Anybody using ACPI should
not expect any backwards compatibility, they should be documented
mandatory properties right from the beginning.

	  Andrew
