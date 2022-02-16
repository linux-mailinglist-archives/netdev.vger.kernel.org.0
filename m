Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C40A4B8CBC
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiBPPnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:43:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbiBPPnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:43:18 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA1E16FDC5
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:43:05 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b13so4686237edn.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pbcWZh3DyezC7QLlYPScEwVAhZAtfRfEQpP4p6aHgh8=;
        b=J4FEf7GuVdc69+UNYfnpFznxbko5upzWwb361wfPN7yS2kdSFUbzWC1RRvz/8kX3Gg
         294KVQAvN1KiN5xG67tNloe4Z1k9vEDHtEBOyEVFYPAqaisTVPH7W3rEnnp/2TLnY6Zt
         814ag6HMLdFX7VOVDIx3CTLd/xPCZCkoOzfc9VleC9hi/F4EsjbujvXZwF7ybA6Rfl5d
         iJ7B0FURlM6FXarhs/c8L8W1E1zup7hvQ0yGiptjawfN0ACj82OVOkWUa9gIaH580k4M
         0KiXDqFFKTxU9D9FRl72hqrdIPMFv3qjPKh4oKhBgO2xeTdip5XNx3EZQ0UcamCZOOTk
         BsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pbcWZh3DyezC7QLlYPScEwVAhZAtfRfEQpP4p6aHgh8=;
        b=17CjrnVD00v/OyntwTe/883EJnbiJImemfPQsiKhStngu40x3cahI+ZzsJMhJqIiLg
         H6TNd8Hr4aKj3irheqgFcQ9YGPBcHgUeT6jQ+1MckPObCNdTy9MPuyiUcYpRqnTQGDlx
         0S+ydJPCyVF2aofIjy4qoJzBwEf5URmyTVwEaaZ5Zc8aEWy/I2/JlEShacCOUXoa+7XK
         N2xIhPGG0W8qlmSOmKa5USESfUTFsh/lTrtu1ZpHwtYvFB3yvxS8U7jxZ3B7CmbNXY3P
         OxRI6hLP6DfwkWELCPy7Yg9jM6Z+wSYbXniiC1eE0OSBNDRX1XOp2X4naYQV7HYsUqw2
         oE5Q==
X-Gm-Message-State: AOAM532OqIn8PcR1j7okPYeSvZCat+UV+UWVo8/xVgBl66bbEzYvCVXn
        fiYBlfZuN6buB2nAAh+LF/c=
X-Google-Smtp-Source: ABdhPJzT6PSXo6jPwqDRnIsLok3XM1t9UAHKCwyM/7d6cJQ9oTI5y9uszbyd7DPBLkZr/8f+1G0WbA==
X-Received: by 2002:a50:c313:0:b0:410:ef83:3605 with SMTP id a19-20020a50c313000000b00410ef833605mr3648953edb.414.1645026184497;
        Wed, 16 Feb 2022 07:43:04 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id 25sm42359ejh.5.2022.02.16.07.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 07:43:03 -0800 (PST)
Date:   Wed, 16 Feb 2022 17:43:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <20220216154302.7g7kjbhfchuwzeef@skbuf>
References: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
 <E1nKLsX-009NMX-2e@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nKLsX-009NMX-2e@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 03:06:01PM +0000, Russell King (Oracle) wrote:
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index bd78192e0e47..1138d40f7897 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1011,6 +1011,20 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
>  	}
>  }
>  
> +static struct phylink_pcs *dsa_port_phylink_mac_select_pcs(
> +					struct phylink_config *config,
> +					phy_interface_t interface)

Would be nice to align the arguments to the open parenthesis if possible:

static struct phylink_pcs *
dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
				phy_interface_t interface)

Same 3 lines consumed in both cases, but it's more in line to what was
done for other functions - dsa_slave_fdb_dump, dsa_slave_vlan_check_for_8021q_uppers,
dsa_find_designated_bridge_port_by_vid, etc.

> +{
> +	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
> +	struct dsa_switch *ds = dp->ds;
> +	struct phylink_pcs *pcs = NULL;
> +
> +	if (ds->ops->phylink_mac_select_pcs)
> +		pcs = ds->ops->phylink_mac_select_pcs(ds, dp->index, interface);
> +
> +	return pcs;
> +}
