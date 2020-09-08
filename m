Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC4B260DA6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgIHIf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:35:28 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:12260
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729629AbgIHIfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 04:35:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQXQuNDLr954XuRPivWas7UWUGBibKFZp76f1a9UDC0dxw2W2l+uE8nfnFaVXQ4YVBmCnVGGJkkx7esTDHCsIG84Cu8oB9+B58dPij4nf99i3/IpJaRaIqoy8j1F5n5JY1ka/CHryevg/fuwBsbLL8MR0a1Xj9Kb9LGf2/0RDRUtUQ0w3s2DGDoSOFhGjezoFgSHmaPdNd4XfyT34fBfJQupfsc8B8+i2reer8794RgHTuj+4vgMNvc4kCbKU3I0ENcr2JVDCV+XdNggDCmNlV0FLwGSWn78ZN9z+fxTvaEKwpVAQLGoXPXITjFVcdZG0jnsNteFD3r8HCtqH0llew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTZn7RlLb9m54AFu8hMF3hXlKTDvQ9xvgH+xd9ZXI4s=;
 b=StJFyxlfDb/40Z5e7nvOKwEJP0wzliNZ+7x0V81L/NwbcDyyUf4XAO5J3XIa3B7950yiw1AS/ivDVsU8a/TeA9dvi5pYWK14odkppQJRgwVlTMettPqjNhx1l/bcW68KBe9cpck9HPexcJ34WAd/2gBMpWaTisDZB4Ry/8wEZQrPkcr4Hcy+a6coUUe2gTjFU4y8Eyr5XhsxaiRFanMqbEj9q8sbjsFEMUzN1f6Otv7h/QaRCDKmxXB2rGtNtA/j/oJrHUb/2PZ7VGhd2M3YZRx1klI40mPg27t1BIWvroNuFbozrXrRTCVlrBCI5P9SBDETuNG7DYKzy0e05oqhoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTZn7RlLb9m54AFu8hMF3hXlKTDvQ9xvgH+xd9ZXI4s=;
 b=rCVCs8nPu2nkRJ39dL/Ck13EwY7LIbP12dsva48Gx2rbzrbRNF2mo+pYJGdQDeFWQ9fLYEYiUUgoQAU96enXJL3+i4+qokFRpXTYNOIWNN35pgGVV/mDDNaW+kaDVFnfqZUnGZVzMqNLswQScwh7A4AhbqKjhVH5+5sT8MGWk+M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0267.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Tue, 8 Sep 2020 08:35:19 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 08:35:19 +0000
Date:   Tue, 8 Sep 2020 11:35:14 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net-next v7 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200908083514.GB3562@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu>
 <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P193CA0118.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::23) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P193CA0118.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 08:35:17 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e083e8a3-4d93-4fa2-145e-08d853d21e1f
X-MS-TrafficTypeDiagnostic: HE1P190MB0267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB02679B2885E953EFE0D0516C95290@HE1P190MB0267.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgX64KavHIT31Fr7lwUMy3ozX3R69fKGGFLXeY/Xpx8Mo3/hk6Pm3vTpP39uzpDJfR8hHvwIo/7JsXicvMrDI9RxqHf0TomObQZxdNzSX2L4DifjZQvmrqp66pSp0t0R8EQNnBD6gvonzC7/M0J/6GxE7DJ0aBWMMSR5E7TFhzyKA90O+MLa3KIY/MuIxHogpRJjj2cPVwGXD9IXeoKAFAGA7BXJlOy/eKUa6XMppuuW5QVPXZYmw0jTSwuw3NKKhRkgY86Cm4baAENDUrJDT5IigcWCInimUpJG4+oi2B1L6b2gxar68PDsukos/pU9FdL9ifUdujTHMtTN7FKG8y8Q1buYtkNHwSf3MeKcDaSrAN7xwlyVr7V+AxclH4gULto1YhYEpmUx3lPrcp/v5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(39830400003)(396003)(366004)(376002)(66476007)(966005)(53546011)(55016002)(36756003)(8886007)(1076003)(2616005)(83380400001)(8936002)(956004)(8676002)(316002)(52116002)(7696005)(16526019)(66946007)(66556008)(6666004)(86362001)(54906003)(30864003)(478600001)(33656002)(6916009)(186003)(2906002)(26005)(5660300002)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: e/k46UA9POpoHw5DcbLW8SvdrsarYCD+WWcRAT0LBlfuHOLcq5Gls9bF3tkxDmkxsyweYr99lVNRKFJGQCqBFDjX3qUrgUqGjX5w5pXKEb0sAtIlShx/vAUrpaCqiiaHsCg34PBkkIOWxINZ68weuf8eiw7M443WaZFZKx2rYQ6MasSwzDpxDpTfPm7GFqQhy/hs3VNQqE11QzqOACDSspuFC3hF2Kd868h+Ncovb4NwIyWA9EKMOlhw+qILWQYEfO9UHyaLxBwlHMiAZCTCG5dTvuqjeVRfuHvlv4GdAgaFYTHefX2403uWiY8Pj6oIM+OhGQWQQ5F9A4TEyr9OVq3tmeZMdPaG03mIUA2M0AcyHAfsk6EIuww24BRZYO8ymxMjYPom51rvNwJJ5x61PqE2GPcLcNJ16k86V32+AXjg57q7fsOcwA1mA6BP73I2XoSgFDp/VV20BJfJj9+5Yu0FPgNor5dbdcvnT5xDOICFbmoYToB56z0ATU9fD/f1mJi/SNqt35KeH8WAQ0qNqJvbmYSfnvd7eWKbnTDJEY1UjyWjRZ3aNAXnBtTtPwbK/u+T9jbXsxsDNnjAY2OVt0KU2TVlnZ9rVYQxm1bNCpNjYUidsTTGQaqq37PvISKYkq9dgxwmF2D/zQfLpNGKnw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e083e8a3-4d93-4fa2-145e-08d853d21e1f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 08:35:18.9574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbrWS4l08h68ovFivyHNJA77avGyA+tl6kN/gkCLKykA75MZYFeSYaggOtbNFrnDXqYCahc1++h/JHOV+8C54tJo+fZ4zsMSRhKc/hvQuS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0267
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> >
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> >
> > The current implementation supports only boards designed for the Marvell
> > Switchdev solution and requires special firmware.
> >
> > The core Prestera switching logic is implemented in prestera_main.c,
> > there is an intermediate hw layer between core logic and firmware. It is
> > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > related logic, in future there is a plan to support more devices with
> > different HW related configurations.
> >
> > This patch contains only basic switch initialization and RX/TX support
> > over SDMA mechanism.
> >
> > Currently supported devices have DMA access range <= 32bit and require
> > ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
> > allocated in proper range supported by the Prestera device.
> >
> > Also meanwhile there is no TX interrupt support in current firmware
> > version so recycling work is scheduled on each xmit.
> >
> > Port's mac address is generated from the switch base mac which may be
> > provided via device-tree (static one or as nvme cell), or randomly
> > generated. This is required by the firmware.
> 
> ...
> 
> > +#define prestera_dev(sw)               ((sw)->dev->dev)
> 
> The point of this is...? (What I see it's 2 characters longer)
> 
> ...
> 
> > +       words[0] = ntohl(dsa_words[0]);
> > +       words[1] = ntohl(dsa_words[1]);
> > +       words[2] = ntohl(dsa_words[2]);
> > +       words[3] = ntohl(dsa_words[3]);
> 
> This is (semi-)NIH of be32_to_cpu_array()
> 
> You may add an additional patch to provide ntohl_array() as an alias
> how it's done for the rest:
> https://elixir.bootlin.com/linux/v5.9-rc3/source/include/linux/byteorder/generic.h#L123
> 
> ...
> 
> > +       dsa->vlan.vid &= ~PRESTERA_VID_MASK;
> > +       dsa->vlan.vid |= FIELD_PREP(PRESTERA_VID_MASK, field);
> 
> Consider to use uXX_replace_bits() (XX for size of the variable).
> Look at bitfield.h closer.
> 
> ...
> 
> > +       dsa->hw_dev_num &= PRESTERA_W3_HW_DEV_NUM;
> > +       dsa->hw_dev_num |= FIELD_PREP(PRESTERA_DEV_NUM_MASK, field);
> 
> Ditto? (Not sure why first line w/o _MASK)
> 
> ...
> 
> > +       if (dsa->hw_dev_num >= BIT(12))
> > +               return -EINVAL;
> > +       if (dsa->port_num >= BIT(17))
> > +               return -EINVAL;
> 
> Magic numbers!
> 
> ...
> 
> > +       words[3] |= FIELD_PREP(PRESTERA_W3_HW_DEV_NUM, (dsa->hw_dev_num >> 5));
> 
> Ditto.
> 
I am not sure 5 needs to be defined as macro as it just moves
hw_dev_num's higher bits into the last word.

> ...
> 
> > +       dsa_words[0] = htonl(words[0]);
> > +       dsa_words[1] = htonl(words[1]);
> > +       dsa_words[2] = htonl(words[2]);
> > +       dsa_words[3] = htonl(words[3]);
> 
> NIH of cpu_to_be32_array().
> 
> ...
> 
> > +/*
> > + * Copyright (c) 2020 Marvell International Ltd. All rights reserved.
> > + *
> > + */
> 
> One line.
> 
> ...
> 
> > +       err = prestera_find_event_handler(sw, msg->type, &eh);
> 
> > +       if (err || !fw_event_parsers[msg->type].func)
> > +               return -EEXIST;
> 
> Why shadowing error code?
> 
> ...
> 
> > +       struct prestera_msg_port_info_req req = {
> > +               .port = port->id
> 
> Leave comma here.
> Another possibility, if you not expect this to grow, move to one line.
> 
> > +       };
> 
> ...
> 
> > +               .param = {.admin_state = admin_state}
> 
> + white spaces? Whatever you choose, just be consistent among all
> similar definitions.
> 
> ...
> 
> > +               .port = port->hw_id,
> > +               .dev = port->dev_id
> 
> Leave comma.
> 
> ...
> 
> > +       struct prestera_msg_port_attr_req req = {
> > +               .attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
> > +               .port = port->hw_id,
> > +               .dev = port->dev_id
> 
> Ditto. I have a deja vu that I already pointed out to these.
> 
> > +       };
> 
> ...
> 
> > +       err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> > +                              &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> > +       if (err)
> > +               return err;
> > +
> > +       caps->supp_link_modes = resp.param.cap.link_mode;
> > +       caps->supp_fec = resp.param.cap.fec;
> > +       caps->type = resp.param.cap.type;
> > +       caps->transceiver = resp.param.cap.transceiver;
> > +
> 
> > +       return err;
> 
> return 0;
> 
> > +}
> 
> ...
> 
> > +               .param = {.autoneg = {.link_mode = link_modes,
> > +                                     .enable = autoneg,
> > +                                     .fec = fec}
> 
> Fix indentation and style.
> 
> > +               }
> 
> ...
> 
> > +       struct prestera_msg_port_attr_req req = {
> > +               .attr = PRESTERA_CMD_PORT_ATTR_STATS,
> > +               .port = port->hw_id,
> > +               .dev = port->dev_id
> 
> + Comma.
> 
> > +       };
> 
> ...
> 
> > +/*
> > + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> > + *
> > + */
> 
> One line.
> 
> ...
> 
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/list.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/netdev_features.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/jiffies.h>
> > +#include <linux/of.h>
> > +#include <linux/of_net.h>
> 
> Perhaps sorted?
> 
> ...
> 
> > +static int prestera_port_state_set(struct net_device *dev, bool is_up)
> > +{
> > +       struct prestera_port *port = netdev_priv(dev);
> > +       int err;
> > +
> > +       if (is_up) {
> > +               err = prestera_hw_port_state_set(port, true);
> > +               if (err)
> > +                       return err;
> > +
> > +               netif_start_queue(dev);
> > +       } else {
> > +               netif_stop_queue(dev);
> > +
> > +               err = prestera_hw_port_state_set(port, false);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int prestera_port_open(struct net_device *dev)
> > +{
> > +       return prestera_port_state_set(dev, true);
> > +}
> > +
> > +static int prestera_port_close(struct net_device *dev)
> > +{
> > +       return prestera_port_state_set(dev, false);
> > +}
> 
> What the point to have above function if you simple can put its
> contents in these two?
> 
> ...
> 
> > +       /* firmware requires that port's mac address contains first 5 bytes
> > +        * of base mac address
> 
> mac -> MAC? (two cases)
> 
> > +        */
> 
> ...
> 
> > +static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
> > +                                    u64 link_modes, u8 fec)
> > +{
> > +       bool refresh = false;
> 
> > +       int err = 0;
> 
> Redundant assignment.
> 
> > +       if (port->caps.type != PRESTERA_PORT_TYPE_TP)
> > +               return enable ? -EINVAL : 0;
> > +
> > +       if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
> > +               port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
> > +               port->adver_link_modes = link_modes;
> > +               refresh = true;
> > +       }
> > +
> > +       if (port->autoneg == enable && !(port->autoneg && refresh))
> > +               return 0;
> > +
> > +       err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
> > +                                          port->adver_fec);
> > +       if (err)
> 
> > +               return -EINVAL;
> 
> Why shadowed?
> 
> > +       port->autoneg = enable;
> > +       return 0;
> > +}
> 
> ...
> 
> > +       /* firmware requires that port's mac address consist of the first
> > +        * 5 bytes of base mac address
> > +        */
> 
> 
> > +       memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> 
> Can't you call above helper for that?
> 
> ...
> 
> > +       dev->dev_addr[dev->addr_len - 1] = (char)port->fp_id;
> 
> Why explicit casting?
> 
> ...
> 
> > +static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
> > +{
> > +       struct device_node *base_mac_np;
> > +       struct device_node *np;
> > +
> > +       np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
> 
> > +       if (np) {
> 
> I think it's useless check, b/c...
> 
> > +               base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
> 
> ...this will return error.
> 
> So, something like struct device_node *np = of_find_...(...); above.
> 
> > +               if (base_mac_np) {
> 
> I think it's useless check.
> Similar as above.
> 
> > +                       const char *base_mac;
> > +
> > +                       base_mac = of_get_mac_address(base_mac_np);
> > +                       of_node_put(base_mac_np);
> > +                       if (!IS_ERR(base_mac))
> > +                               ether_addr_copy(sw->base_mac, base_mac);
> > +               }
> > +       }
> > +       if (!is_valid_ether_addr(sw->base_mac)) {
> > +               eth_random_addr(sw->base_mac);
> > +               dev_info(sw->dev->dev, "using random base mac address\n");
> > +       }
> > +
> > +       return prestera_hw_switch_mac_set(sw, sw->base_mac);
> > +}
> 
> ...
> 
> > +int prestera_device_register(struct prestera_device *dev)
> > +{
> > +       struct prestera_switch *sw;
> > +       int err;
> > +
> > +       sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> > +       if (!sw)
> > +               return -ENOMEM;
> > +
> > +       dev->priv = sw;
> > +       sw->dev = dev;
> > +
> > +       err = prestera_switch_init(sw);
> > +       if (err) {
> > +               kfree(sw);
> 
> > +               return err;
> > +       }
> > +
> > +       return 0;
> 
> return err;
> 
why not keep 'return 0' as indication of success point ?

> > +}
> 
> ...
> 
> > +#include <linux/dmapool.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/if_vlan.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/platform_device.h>
> 
> ...
> 
> > +#define PRESTERA_SDMA_RX_DESC_IS_RCVD(desc) \
> > +       (PRESTERA_SDMA_RX_DESC_OWNER((desc)) == PRESTERA_SDMA_RX_DESC_CPU_OWN)
> 
> Double (()) make no sense here.
> 
> ...
> 
> > +static void prestera_sdma_rx_desc_set_len(struct prestera_sdma_desc *desc,
> > +                                         size_t val)
> > +{
> > +       u32 word = le32_to_cpu(desc->word2);
> > +
> > +       word = (word & ~GENMASK(15, 0)) | val;
> > +       desc->word2 = cpu_to_le32(word);
> > +}
> 
> Why not simple le32_replace_bits() ?
> 
> ...
> 
> > +       port = prestera_port_find_by_hwid(sdma->sw, dev_id, hw_port);
> > +       if (unlikely(!port)) {
> 
> > +               pr_warn_ratelimited("received pkt for non-existent port(%u, %u)\n",
> > +                                   dev_id, hw_port);
> 
> What's wrong with dev_warn_ratelimited() ?
> 
> > +               return -EEXIST;
> > +       }
> 
> ...
> 
> > +               for (b = 0; b < bnum; b++) {
> > +                       struct prestera_sdma_buf *buf = &ring->bufs[b];
> > +
> > +                       err = prestera_sdma_buf_init(sdma, buf);
> > +                       if (err)
> > +                               return err;
> > +
> > +                       err = prestera_sdma_rx_skb_alloc(sdma, buf);
> > +                       if (err)
> 
> No need to uninit previously init buffers?
> No need to dealloc previously allocated stuff?
> 
> > +                               return err;
> 
> ...
> 
> > +                       if (b == 0)
> > +                               continue;
> > +
> > +                       prestera_sdma_rx_desc_set_next(sdma,
> > +                                                      ring->bufs[b - 1].desc,
> > +                                                      buf->desc_dma);
> > +
> > +                       if (b == PRESTERA_SDMA_RX_DESC_PER_Q - 1)
> > +                               prestera_sdma_rx_desc_set_next(sdma, buf->desc,
> > +                                                              head->desc_dma);
> 
> I guess knowing what the allowed range of bnum the above can be optimized.
> 
You mean to replace PRESTERA_SDMA_RX_DESC_PER_Q by bnum ?

> > +               }
> 
> ...
> 
> > +       u32 word = le32_to_cpu(desc->word2);
> > +
> > +       word = (word & ~GENMASK(30, 16)) | ((len + ETH_FCS_LEN) << 16);
> > +
> > +       desc->word2 = cpu_to_le32(word);
> 
> le32_replace_bits()
> 
> ...
> 
> > +static void prestera_sdma_tx_desc_xmit(struct prestera_sdma_desc *desc)
> > +{
> > +       u32 word = le32_to_cpu(desc->word1);
> > +
> > +       word |= PRESTERA_SDMA_TX_DESC_DMA_OWN << 31;
> > +
> > +       /* make sure everything is written before enable xmit */
> > +       wmb();
> > +
> > +       desc->word1 = cpu_to_le32(word);
> 
> Seems to me it's also safe to use le32_replace_bits(), but I'm not
> sure if desc->word1 can be changed after barrier by somebody else.
> 
> > +}
> 
> ...
> 
> > +       for (b = 0; b < bnum; b++) {
> > +               struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
> > +
> > +               err = prestera_sdma_buf_init(sdma, buf);
> > +               if (err)
> > +                       return err;
> > +
> > +               prestera_sdma_tx_desc_init(sdma, buf->desc);
> > +
> > +               buf->is_used = false;
> > +
> > +               if (b == 0)
> > +                       continue;
> > +
> > +               prestera_sdma_tx_desc_set_next(sdma, tx_ring->bufs[b - 1].desc,
> > +                                              buf->desc_dma);
> > +
> > +               if (b == PRESTERA_SDMA_TX_DESC_PER_Q - 1)
> > +                       prestera_sdma_tx_desc_set_next(sdma, buf->desc,
> > +                                                      head->desc_dma);
> > +       }
> 
> Similar comments as per above similar for-loop.
> 
> ...
> 
> > +static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
> > +                                struct prestera_tx_ring *tx_ring)
> > +{
> > +       int tx_retry_num = PRESTERA_SDMA_WAIT_MUL * tx_ring->max_burst;
> > +
> > +       do {
> > +               if (prestera_sdma_is_ready(sdma))
> > +                       return 0;
> > +
> > +               udelay(1);
> > +       } while (--tx_retry_num);
> > +
> > +       return -EBUSY;
> > +}
> 
> iopoll.h
> readx_poll_timeout().
> 
> ...
> 
> > +/*
> > + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> > + *
> > + */
> 
> One line.
> 
> ...
> 
> > +#include "prestera.h"
> 
> I don't see users of the above header here. You may use declarations instead.
> 
> > +int prestera_rxtx_switch_init(struct prestera_switch *sw);
> > +void prestera_rxtx_switch_fini(struct prestera_switch *sw);
> > +
> > +int prestera_rxtx_port_init(struct prestera_port *port);
> > +
> > +netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
> 
> -- 
> With Best Regards,
> Andy Shevchenko

Thanks!
