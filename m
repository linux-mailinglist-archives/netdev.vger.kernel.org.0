Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD15311646
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhBEW7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:59:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:53478 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhBEMtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612529369; x=1644065369;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G5v10OekAfMU75J/gA/fGdNpssEIG6nR9R4yJm1gNUU=;
  b=EUpU0ffaIZI+yjc0Yl2xZ4O4eCdXfiCSmsIp7z9T1wpsaB/WUvfrKl52
   mSEvYkl4Sx52nO0g6kA6TKzqCp28Cf2WDWbN/FgY3LXKVHPOAx1yIl373
   DtIKVAKn5kkhOt8fOS6WWLm8MD8PQ1qd8JF6cBsSr1a0JPQkJ7Loqit5r
   7WaNeC/Va9GgkAazQVZF3UdgYckGdilw8oY7qmSzshsNxnogUadiH0DJJ
   LHcahC9yCGpRb4f/CCYROdXEbC7mkh/++axshLv4DHc6mtSMuSVmb6ZiZ
   xAcaSFtjJgvdGgB0n4ODJLbw0mVxR5CJML70+5lzg0mqYw+rlPomyqT99
   g==;
IronPort-SDR: jrDKhXlDRjKerIL/GVxeMjLtldb+zGeUkSCnKr9zVTLyzC1OPBrW9/bka+3cMnnZddkCiVm0j+
 P3WcNCQcmWZvTgrim/7sNIzMrTMVrY2kHq71zT/Q7hJHLB0e+ECfKmJUOeWd7udtKMa0P1Qiko
 2w5Kf8Hv93yvUzh90KL74a4f0HgscEW+rkzUNjIaa/eBbEFMPHgeUBIMYat1keq2YmO81Mv06i
 ePtwGYYhtJCBPC8Yr+SrhPTJ6M0r74X5DcVJZF7CtCXbQ4myLZy0hzWwuyg6AG4eQpq5X/2R9U
 KJQ=
X-IronPort-AV: E=Sophos;i="5.81,154,1610434800"; 
   d="scan'208";a="113957690"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Feb 2021 05:48:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 5 Feb 2021 05:48:12 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 5 Feb 2021 05:48:06 -0700
Message-ID: <b565944e72a0af12dec0430bd819eb6b755d84b4.camel@microchip.com>
Subject: Re: [PATCH net-next 3/8] net: dsa: microchip: add DSA support for
 microchip lan937x
From:   Prasanna Vengateshan Varadharajan 
        <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>, <kuba@kernel.org>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Date:   Fri, 5 Feb 2021 18:18:03 +0530
In-Reply-To: <YBNf715MJ9OfaXfV@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
         <20210128064112.372883-4-prasanna.vengateshan@microchip.com>
         <YBNf715MJ9OfaXfV@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-29 at 02:07 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe

Thanks for your time on reviewing the patches.

> 
> > +bool lan937x_is_internal_phy_port(struct ksz_device *dev, int
> > port)
> > +{
> > +     /* Check if the port is RGMII */
> > +     if (port == LAN937X_RGMII_1_PORT || port ==
> > LAN937X_RGMII_2_PORT)
> > +             return false;
> > +
> > +     /* Check if the port is SGMII */
> > +     if (port == LAN937X_SGMII_PORT &&
> > +         GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_73)
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> > +static u32 lan937x_get_port_addr(int port, int offset)
> > +{
> > +     return PORT_CTRL_ADDR(port, offset);
> > +}
> > +
> > +bool lan937x_is_internal_tx_phy_port(struct ksz_device *dev, int
> > port)
> > +{
> > +     /* Check if the port is internal tx phy port */
> 
> What is an internal TX phy port? Is it actually a conventional t2
> Fast
> Ethernet port, as opposed to a t1 port?
This is 100 Base-Tx phy which is compliant with
802.3/802.3u standards. Two of the SKUs have both T1 and TX integrated
Phys as mentioned in the patch intro mail.

> 
> > +     if (lan937x_is_internal_phy_port(dev, port) && port ==
> > LAN937X_TXPHY_PORT)
> > +             if ((GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_71) ||
> > +                 (GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_72))
> > +                     return true;
> > +
> > +     return false;
> > +}
> > +
> > +bool lan937x_is_internal_t1_phy_port(struct ksz_device *dev, int
> > port)
> > +{
> > +     /* Check if the port is internal t1 phy port */
> > +     if (lan937x_is_internal_phy_port(dev, port) &&
> > +         !lan937x_is_internal_tx_phy_port(dev, port))
> > +             return true;
> > +
> > +     return false;
> > +}
> > +
> > +int lan937x_t1_tx_phy_write(struct ksz_device *dev, int addr,
> > +                         int reg, u16 val)
> > +{
> > +     u16 temp, addr_base;
> > +     unsigned int value;
> > +     int ret;
> > +
> > +     /* Check for internal phy port */
> > +     if (!lan937x_is_internal_phy_port(dev, addr))
> > +             return 0;
> 
> All this t1 and tx is confusing. I think lan937x_internal_phy_write()
> would be better.
Sure, will rename it to lan937x_internal_phy_write()

> 
> I also wonder if -EOPNOTSUPP would be better, or -EINVAL?
-EOPNOTSUPP would be better. Currently return value has not checked for
phy_write() calls, i will add that as well in the list

> 
> > +
> > +     if (lan937x_is_internal_tx_phy_port(dev, addr))
> > +             addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> > +     else
> > +             addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> > +
> > +     temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> > +
> > +     ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> > +
> > +     /* Write the data to be written to the VPHY reg */
> > +     ksz_write16(dev, REG_VPHY_IND_DATA__2, val);
> > +
> > +     /* Write the Write En and Busy bit */
> > +     ksz_write16(dev, REG_VPHY_IND_CTRL__2, (VPHY_IND_WRITE
> > +                             | VPHY_IND_BUSY));
> > +
> > +     ret = regmap_read_poll_timeout(dev->regmap[1],
> > +                                    REG_VPHY_IND_CTRL__2,
> > +                             value, !(value & VPHY_IND_BUSY), 10,
> > 1000);
> > +
> > +     /* failed to write phy register. get out of loop */
> > +     if (ret) {
> > +             dev_err(dev->dev, "Failed to write phy register\n");
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +int lan937x_t1_tx_phy_read(struct ksz_device *dev, int addr,
> > +                        int reg, u16 *val)
> > +{
> > +     u16 temp, addr_base;
> > +     unsigned int value;
> > +     int ret;
> > +
> > +     if (lan937x_is_internal_phy_port(dev, addr)) {
> > +             if (lan937x_is_internal_tx_phy_port(dev, addr))
> > +                     addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> > +             else
> > +                     addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> 
> You could reduce the indentation by doing what you did above:
Sure, will change it.

> 
> > +     /* Check for internal phy port */
> > +     if (!lan937x_is_internal_phy_port(dev, addr))
> > +             return 0;
> 
> You might want to return 0xffff here, which is what a read on a
> non-existent device on an MDIO bus should return.
Sure, will change it

> 
> 
> > +
> > +             /* get register address based on the logical port */
> > +             temp = PORT_CTRL_ADDR(addr, (addr_base + (reg <<
> > 2)));
> > +
> > +             ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> > +             /* Write Read and Busy bit to start the transaction*/
> > +             ksz_write16(dev, REG_VPHY_IND_CTRL__2,
> > VPHY_IND_BUSY);
> > +
> > +             ret = regmap_read_poll_timeout(dev->regmap[1],
> > +                                            REG_VPHY_IND_CTRL__2,
> > +                                     value, !(value &
> > VPHY_IND_BUSY), 10, 1000);
> > +
> > +             /*  failed to read phy register. get out of loop */
> > +             if (ret) {
> > +                     dev_err(dev->dev, "Failed to read phy
> > register\n");
> > +                     return ret;
> > +             }
> > +             /* Read the VPHY register which has the PHY data*/
> > +             ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
> > +     }
> > +
> > +     return 0;
> > +}
> > +static void tx_phy_setup(struct ksz_device *dev, int port)
> > +{
> > +     u16 data_lo;
> > +
> > +     lan937x_t1_tx_phy_read(dev, port, REG_PORT_TX_SPECIAL_MODES,
> > &data_lo);
> > +     /* Need to change configuration from 6 to other value. */
> > +     data_lo &= TX_PHYADDR_M;
> > +
> > +     lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_SPECIAL_MODES,
> > data_lo);
> > +
> > +     /* Need to toggle test_mode bit to enable DSP access. */
> > +     lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL,
> > TX_TEST_MODE);
> > +     lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, 0);
> > +
> > +     /* Note TX_TEST_MODE is then always enabled so this is not
> > required. */
> > +     lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL,
> > TX_TEST_MODE);
> > +     lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, 0);
> 
> This is only accessing PHY registers, not switch registers. So this
> code belongs in the PHY driver, not the switch driver.
> 
> What PHY driver is actually used? The "Microchip LAN87xx T1" driver?
Phy is basically a LAN87xx PHY. But the driver is customized for
LAN937x.

> 
> > +static void tx_phy_port_init(struct ksz_device *dev, int port)
> > +{
> > +     u32 data;
> > +
> > +     /* Software reset. */
> > +     lan937x_t1_tx_phy_mod_bits(dev, port, MII_BMCR, BMCR_RESET,
> > true);
> > +
> > +     /* tx phy setup */
> > +     tx_phy_setup(dev, port);
> 
> And which PHY driver is used here? "Microchip LAN88xx"? All this code
> should be in the PHY driver.
As of now, no driver is available in the kernel since its part of
LAN937x.

> s
> > +void lan937x_port_setup(struct ksz_device *dev, int port, bool
> > cpu_port)
> > +{
> > +     struct ksz_port *p = &dev->ports[port];
> > +     u8 data8, member;
> > +     } else {
> > +             /* force flow control off*/
> > +             lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
> > +                              PORT_FORCE_TX_FLOW_CTRL |
> > PORT_FORCE_RX_FLOW_CTRL,
> > +                          false);
> > +
> > +             lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1,
> > &data8);
> > +
> > +             /* clear MII selection & set it based on interface
> > later */
> > +             data8 &= ~PORT_MII_SEL_M;
> > +
> > +             /* configure MAC based on p->interface */
> > +             switch (p->interface) {
> > +             case PHY_INTERFACE_MODE_MII:
> > +                     lan937x_set_gbit(dev, false, &data8);
> > +                     data8 |= PORT_MII_SEL;
> > +                     break;
> > +             case PHY_INTERFACE_MODE_RMII:
> > +                     lan937x_set_gbit(dev, false, &data8);
> > +                     data8 |= PORT_RMII_SEL;
> > +                     break;
> > +             default:
> > +                     lan937x_set_gbit(dev, true, &data8);
> > +                     data8 |= PORT_RGMII_SEL;
> > +
> > +                     data8 &= ~PORT_RGMII_ID_IG_ENABLE;
> > +                     data8 &= ~PORT_RGMII_ID_EG_ENABLE;
> > +
> > +                     if (p->interface ==
> > PHY_INTERFACE_MODE_RGMII_ID ||
> > +                         p->interface ==
> > PHY_INTERFACE_MODE_RGMII_RXID)
> > +                             data8 |= PORT_RGMII_ID_IG_ENABLE;
> > +
> > +                     if (p->interface ==
> > PHY_INTERFACE_MODE_RGMII_ID ||
> > +                         p->interface ==
> > PHY_INTERFACE_MODE_RGMII_TXID)
> > +                             data8 |= PORT_RGMII_ID_EG_ENABLE;
> 
> Normally, the PHY inserts the delay, not the MAC. If the MAC is doing
> the delay, you need to ensure the PHY knows this, when you call
> phy_connect() you need to pass PHY_INTERFACE_MODE_RGMII, so it does
> not add delays.
Okay, understand.

> 
> > +                     break;
> > +             }
> > +             lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1,
> > data8);
> > +     }
> > +
> > +     if (cpu_port)
> > +             member = dev->port_mask;
> > +     else
> > +             member = dev->host_mask | p->vid_member;
> > +
> > +     lan937x_cfg_port_member(dev, port, member);
> > +}
> > +
> > +static int lan937x_switch_init(struct ksz_device *dev)
> > +{
> > +     int i;
> > +
> > +     dev->ds->ops = &lan937x_switch_ops;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(lan937x_switch_chips); i++) {
> > +             const struct lan937x_chip_data *chip =
> > &lan937x_switch_chips[i];
> > +
> > +             if (dev->chip_id == chip->chip_id) {
> > +                     dev->name = chip->dev_name;
> > +                     dev->num_vlans = chip->num_vlans;
> > +                     dev->num_alus = chip->num_alus;
> > +                     dev->num_statics = chip->num_statics;
> > +                     dev->port_cnt = chip->port_cnt;
> > +                     dev->cpu_ports = chip->cpu_ports;
> > +                     break;
> > +             }
> > +     }
> 
> Please verify that the switch found actually matches the DT
> compatible
> string. With 4 compatible strings, if you don't verify it, you will
> find that 3/4 of the boards have it wrong, but it still works. You
> then get into trouble when you actually need to use the compatible
> string for something.
> 
> Or just use a single compatible string.
Okay, will add dt-compatible checks.

> 
> > +static int lan937x_get_link_status(struct ksz_device *dev, int
> > port)
> > +{
> > +     u16 val1, val2;
> > +
> > +     lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_PHY_M_STATUS,
> > +                            &val1);
> > +
> > +     lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_MODE_STAT,
> > &val2);
> > +
> > +     if (val1 & (PORT_T1_LOCAL_RX_OK | PORT_T1_REMOTE_RX_OK) &&
> > +         val2 & (T1_PORT_DSCR_LOCK_STATUS_MSK |
> > T1_PORT_LINK_UP_MSK))
> > +             return PHY_LINK_UP;
> > +
> > +     return PHY_LINK_DOWN;
> > +}
> 
> The PHY driver should tell you if the link is up. You should not
> being
> accessing the PHY directly.
> 
> It actually looks like you have your PHY drivers here, embedded
> inside
> this driver. That is wrong, they should move into drivers/net/phy.
> The
> switch driver should just give access to the registers, so that the
> PHY driver, and phylib and drive the PHY.
Sure, i think T1 & Tx phy drivers to be submitted.

> 
> > +static void lan937x_port_stp_state_set(struct dsa_switch *ds, int
> > port,
> > +                                    u8 state)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     struct ksz_port *p = &dev->ports[port];
> > +     int forward = dev->member;
> > +     int member = -1;
> > +     u8 data;
> > +
> > +     lan937x_pread8(dev, port, P_STP_CTRL, &data);
> > +     data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE |
> > PORT_LEARN_DISABLE);
> > +
> > +     switch (state) {
> > +     case BR_STATE_DISABLED:
> > +             data |= PORT_LEARN_DISABLE;
> > +             if (port != dev->cpu_port)
> > +                     member = 0;
> 
> You can remove all the tests for cpu_port. It should never
> happen.  If
> it does, something is broken in the DSA core.
Okay, will remove the checks of cpu_port.

> 
> > +             break;
> > +     case BR_STATE_LISTENING:
> > +             data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> > +             if (port != dev->cpu_port &&
> > +                 p->stp_state == BR_STATE_DISABLED)
> > +                     member = dev->host_mask | p->vid_member;
> > +             break;
> > +     case BR_STATE_LEARNING:
> > +             data |= PORT_RX_ENABLE;
> > +             break;
> > +     case BR_STATE_FORWARDING:
> > +             data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
> > +
> > +             /* This function is also used internally. */
> > +             if (port == dev->cpu_port)
> > +                     break;
> 
> You probably want to refactor this. Move the code which is needed for
> the CPU port into a helper, and call it directly.
Sure, will create one helper function.

> 
> > +
> > +             member = dev->host_mask | p->vid_member;
> > +             mutex_lock(&dev->dev_mutex);
> > +
> > +             /* Port is a member of a bridge. */
> > +             if (dev->br_member & (1 << port)) {
> > +                     dev->member |= (1 << port);
> > +                     member = dev->member;
> > +             }
> > +             mutex_unlock(&dev->dev_mutex);
> > +             break;
> > +     case BR_STATE_BLOCKING:
> > +             data |= PORT_LEARN_DISABLE;
> > +             if (port != dev->cpu_port &&
> > +                 p->stp_state == BR_STATE_DISABLED)
> > +                     member = dev->host_mask | p->vid_member;
> > +             break;
> > +     default:
> > +             dev_err(ds->dev, "invalid STP state: %d\n", state);
> > +             return;
> > +     }
> > +
> > +     lan937x_pwrite8(dev, port, P_STP_CTRL, data);
> > +
> > +     p->stp_state = state;
> > +     mutex_lock(&dev->dev_mutex);
> > +
> > +     /* Port membership may share register with STP state. */
> > +     if (member >= 0 && member != p->member)
> > +             lan937x_cfg_port_member(dev, port, (u8)member);
> > +
> > +     /* Check if forwarding needs to be updated. */
> > +     if (state != BR_STATE_FORWARDING) {
> > +             if (dev->br_member & (1 << port))
> > +                     dev->member &= ~(1 << port);
> > +     }
> > +
> > +     /* When topology has changed the function
> > ksz_update_port_member
> > +      * should be called to modify port forwarding behavior.
> > +      */
> > +     if (forward != dev->member)
> > +             ksz_update_port_member(dev, port);
> 
> Please could you explain more what is going on with membership?
> Generally, STP state is specific to the port, and nothing else
> changes. So it is not clear what this membership is all about.
It updates the membership for the forwarding behavior based on
forwarding state of the port.

> 
> 
> > +     mutex_unlock(&dev->dev_mutex);
> > +}
> > +
> > +static void lan937x_config_cpu_port(struct dsa_switch *ds)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     struct ksz_port *p;
> > +     int i;
> > +
> > +     ds->num_ports = dev->port_cnt;
> > +
> > +     for (i = 0; i < dev->port_cnt; i++) {
> > +             if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 <<
> > i))) {
> > +                     phy_interface_t interface;
> > +                     const char *prev_msg;
> > +                     const char *prev_mode;
> > +
> > +                     dev->cpu_port = i;
> > +                     dev->host_mask = (1 << dev->cpu_port);
> > +                     dev->port_mask |= dev->host_mask;
> > +                     p = &dev->ports[i];
> > +
> > +                     /* Read from XMII register to determine host
> > port
> > +                      * interface.  If set specifically in device
> > tree
> > +                      * note the difference to help debugging.
> > +                      */
> > +                     interface = lan937x_get_interface(dev, i);
> > +                     if (!p->interface) {
> > +                             if (dev->compat_interface) {
> > +                                     dev_warn(dev->dev,
> > +                                              "Using legacy switch
> > \"phy-mode\" property, because it is missing on port %d node.
> > Please update your device tree.\n",
> > +                                              i);
> 
> Since this is a new driver, there cannot be any legacy DT blobs which
> needs workarounds.
Understand, will remove the warning message.

> 
>       Andrew

