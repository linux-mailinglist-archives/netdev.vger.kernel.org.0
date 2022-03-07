Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A885B4CFF07
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbiCGMpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242470AbiCGMpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:45:23 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60983B54C;
        Mon,  7 Mar 2022 04:44:24 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 227Ci78D077726;
        Mon, 7 Mar 2022 06:44:07 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1646657047;
        bh=yrWf0B/fJAOio3vFdUY7ba/YHjA66XBw8K8AaY9J4cA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=ZFNpivCeJsVtZp1cz5guGxCWalEHX0vqmaRZi1hC35hLdr0bkPcjkiIvxMWmc+5Ly
         UBwEJf9e86ym19n+mBfSJsdbgEbZNg+Z6aDLhtvb0AINn9NNQx5oIqlFwXSqDAYuoh
         CXMNvwt29OIjFkapgaEaIU9DXNXFzmipWPV/Fc60=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 227Ci6Ld101768
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Mar 2022 06:44:07 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 7
 Mar 2022 06:44:06 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 7 Mar 2022 06:44:06 -0600
Received: from [10.250.232.186] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 227Ci2M5088480;
        Mon, 7 Mar 2022 06:44:03 -0600
Message-ID: <229abc21-ebf6-4b78-e92a-2e943d46b84b@ti.com>
Date:   Mon, 7 Mar 2022 18:14:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RESEND PATCH] net: ethernet: ti: am65-cpsw: Convert to PHYLINK
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <vigneshr@ti.com>,
        <grygorii.strashko@ti.com>
References: <20220304075812.1723-1-s-vadapalli@ti.com>
 <YiHa/himI3WJVOhy@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YiHa/himI3WJVOhy@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 04/03/22 14:55, Russell King (Oracle) wrote:
> Hi,
> 
> On Fri, Mar 04, 2022 at 01:28:12PM +0530, Siddharth Vadapalli wrote:
>> Convert am65-cpsw driver and am65-cpsw ethtool to use Phylink APIs
>> as described at Documentation/networking/sfp-phylink.rst. All calls
>> to Phy APIs are replaced with their equivalent Phylink APIs.

Thank you for reviewing the patch.

> 
> Okay, that's what you're doing, but please mention what the reason for
> the change is.

This patch does not intend to make any functional change. The aim is just to
update the existing driver to use the Phylink framework.

Though the same functionality can be achieved by using the Phylib framework, we
would like to add Phylink support before adding support for SGMII/QSGMII modes
in am65-cpsw driver. The patches for SGMII/QSGMII support in am65-cpsw driver
will be sent later.

> 
>> @@ -1494,6 +1409,87 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
>>  	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
>>  };
>>  
>> +static void am65_cpsw_nuss_validate(struct phylink_config *config, unsigned long *supported,
>> +				    struct phylink_link_state *state)
>> +{
>> +	phylink_generic_validate(config, supported, state);
>> +}
> 
> If you don't need anything special, please just initialise the member
> directly:
> 
> 	.validate = phylink_generic_validate,

Sure, I will fix this in v2.

> 
>> +
>> +static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
>> +				      const struct phylink_link_state *state)
>> +{
>> +	/* Currently not used */
>> +}
>> +
>> +static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
>> +					 phy_interface_t interface)
>> +{
>> +	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
>> +							  phylink_config);
>> +	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>> +	struct am65_cpsw_common *common = port->common;
>> +	struct net_device *ndev = port->ndev;
>> +	int tmo;
>> +
>> +	/* disable forwarding */
>> +	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
>> +
>> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
>> +
>> +	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
>> +	dev_dbg(common->dev, "down msc_sl %08x tmo %d\n",
>> +		cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
>> +
>> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
>> +
>> +	am65_cpsw_qos_link_down(ndev);
>> +	netif_tx_disable(ndev);
> 
> You didn't call netif_tx_disable() in your adjust_link afaics, so why
> is it added here?

When I was working on the conversion, I had added the phylink_create() and
related initialization in the wrong section of the driver. This had caused
"NETDEV WATCHDOG: transmit queue timed out" errors on calls to
netif_tx_stop_all_queues(ndev).

To fix this, I had used netif_tx_disable() as a temporary workaround then.
Now, after fixing the calls to phylink_create() and related code, I realize that
it works even with netif_tx_stop_all_queues(ndev), so I will revert to it in v2.

> 
>> +}
>> +
>> +static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy_device *phy,
>> +				       unsigned int mode, phy_interface_t interface, int speed,
>> +				       int duplex, bool tx_pause, bool rx_pause)
>> +{
>> +	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
>> +							  phylink_config);
>> +	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>> +	struct am65_cpsw_common *common = port->common;
>> +	struct net_device *ndev = port->ndev;
>> +	u32 mac_control = CPSW_SL_CTL_GMII_EN;
>> +
>> +	if (speed == SPEED_1000)
>> +		mac_control |= CPSW_SL_CTL_GIG;
>> +	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
>> +		/* Can be used with in band mode only */
>> +		mac_control |= CPSW_SL_CTL_EXT_EN;
>> +	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
>> +		mac_control |= CPSW_SL_CTL_IFCTL_A;
>> +	if (duplex)
>> +		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
>> +
>> +	/* rx_pause/tx_pause */
>> +	if (rx_pause)
>> +		mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
>> +
>> +	if (tx_pause)
>> +		mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
>> +
>> +	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
>> +
>> +	/* enable forwarding */
>> +	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
>> +
>> +	am65_cpsw_qos_link_up(ndev, speed);
>> +	netif_tx_wake_all_queues(ndev);
>> +}
>> +
>> +static const struct phylink_mac_ops am65_cpsw_phylink_mac_ops = {
>> +	.validate = am65_cpsw_nuss_validate,
>> +	.mac_config = am65_cpsw_nuss_mac_config,
>> +	.mac_link_down = am65_cpsw_nuss_mac_link_down,
>> +	.mac_link_up = am65_cpsw_nuss_mac_link_up,
>> +};
>> +
>>  static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
>>  {
>>  	struct am65_cpsw_common *common = port->common;
>> @@ -1887,24 +1883,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
>>  				of_property_read_bool(port_np, "ti,mac-only");
>>  
>>  		/* get phy/link info */
>> -		if (of_phy_is_fixed_link(port_np)) {
>> -			ret = of_phy_register_fixed_link(port_np);
>> -			if (ret)
>> -				return dev_err_probe(dev, ret,
>> -						     "failed to register fixed-link phy %pOF\n",
>> -						     port_np);
>> -			port->slave.phy_node = of_node_get(port_np);
>> -		} else {
>> -			port->slave.phy_node =
>> -				of_parse_phandle(port_np, "phy-handle", 0);
>> -		}
>> -
>> -		if (!port->slave.phy_node) {
>> -			dev_err(dev,
>> -				"slave[%d] no phy found\n", port_id);
>> -			return -ENODEV;
>> -		}
>> -
>> +		port->slave.phy_node = port_np;
>>  		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
>>  		if (ret) {
>>  			dev_err(dev, "%pOF read phy-mode err %d\n",
>> @@ -1947,6 +1926,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>>  	struct am65_cpsw_ndev_priv *ndev_priv;
>>  	struct device *dev = common->dev;
>>  	struct am65_cpsw_port *port;
>> +	struct phylink *phylink;
>>  	int ret;
>>  
>>  	port = &common->ports[port_idx];
>> @@ -1984,6 +1964,26 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>>  	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
>>  	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
>>  
>> +	/* Configuring Phylink */
>> +	port->slave.phylink_config.dev = &port->ndev->dev;
>> +	port->slave.phylink_config.type = PHYLINK_NETDEV;
>> +	port->slave.phylink_config.pcs_poll = true;
> 
> Does this compile? This member was removed, so you probably get a
> compile error today.

Sorry for not updating to the latest kernel before posting. I was working with
5.16 when I was creating the patch.

> 
>> +	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
>> +	MAC_100 | MAC_1000FD | MAC_2500FD;
>> +
>> +	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
>> +	__set_bit(PHY_INTERFACE_MODE_SGMII, port->slave.phylink_config.supported_interfaces);
>> +	__set_bit(PHY_INTERFACE_MODE_1000BASEX, port->slave.phylink_config.supported_interfaces);
> 
> If you support SGMII and 1000BASE-X with inband signalling, I strongly
> recommend that you implement phylink_pcs support as well, so you are
> able to provide phylink with the inband results.

Currently, SGMII and 1000BASE-X are not supported by the driver. I had added
these as supported modes accidentally. I will be working on supporting SGMII and
QSGMII modes in the near future and will add these along with phylink_pcs
support as well in the patch for the same. I will remove these from the v2 patch.

> 
>> +
>> +	phylink = phylink_create(&port->slave.phylink_config, dev->fwnode, port->slave.phy_if,
>> +				 &am65_cpsw_phylink_mac_ops);
>> +	if (IS_ERR(phylink)) {
>> +		phylink_destroy(port->slave.phylink);
> 
> This is wrong and will cause a NULL pointer dereference - please remove
> the call to phylink_destroy() here.
> 
> However, I could not find another call to phylink_destroy() in your
> patch which means you will leak memory when the driver is unbound.

I added this in the wrong section due to a misunderstanding on my part. I will
fix this in v2.

Regards,
Siddharth.
