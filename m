Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4050225F404
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgIGHbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:31:00 -0400
Received: from mail-eopbgr70123.outbound.protection.outlook.com ([40.107.7.123]:46400
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726443AbgIGHa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 03:30:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkVT13pg0VXwGGqqKpchewQwkxdsG8jReRJzXNY3/SWxdRe+dkGaqOSZJYv9/qz5Oss0d54RhuDZFy9Hjd0pEWwP5YBHx2t91JEHbCdmOXqi/IdUT4XpeJtuy9Vs8hj0BkKJJ2P2pzo3EGIXU0sQ89Jg6b7LfDHgINMLV9dStDzEN9e6m64VaHBzZo/QNYqXXk/eeuEbqPdRY05mx6NDc0nxkD5OV7kff5TuHtSk8j0gnSYEbKVIM9O0EIC/RD3MSY55HeyNW+F2Q4CL/C6F8+decYbGDC0JKZpEnxvkqAlEm1FzT/Z3534+kWcrVMLSdMCJcezZ62I1RuzJrDbxmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Asu9QQ7uZzBv+3AtFGfUUN3lBMygGG1JFsJEo3Vimo=;
 b=Jz9qUOOQlHxP3EAbJM+ncvjYNYv8mKIyDfSfiRKLKycioG0Ce1Hqzi8cYeY+nYZX508yyKhko/0JIm0jXroQ8N6oG/F1oi95C9d4ekqFNcXSbTEd2wedFe/iibEu5sW65+M8G98oRd19t/VKpgWXRnXOChfm9EFvNDDe30XbUQeUcPRskxupefutvUSKIbsY7jIbRB+4wNuBLs6gvL2dr3jaHSR+tIjNN7H+FF83WpEYrEy2H8hnfkrijBnxackYI2Q3Ga7TtJXoKyVA6/CayNNxMPv+hFHLZxnt06vD4YKl0SHZKjLPx2Mo2Nh6xKrhVY65y4xGsC79DDDHHZf5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Asu9QQ7uZzBv+3AtFGfUUN3lBMygGG1JFsJEo3Vimo=;
 b=hbz0xyHS7clJILOSB1pI8K3W/P51y9+ZvqNohxNQoJDVomqX2p32xES/69YlqZ3PPMDUTdz10FQm8vHcrDDqBZCoBSsHIJAn3wuSU/3305MiqBZ53uttea3L920c8nGufEcSQEHKnYpbQynSeoVEKDh0IZzaN2QAGCrEd8HmCk0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0490.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Mon, 7 Sep 2020 07:30:48 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 07:30:48 +0000
Date:   Mon, 7 Sep 2020 10:30:40 +0300
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
Message-ID: <20200907073040.GA3562@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu>
 <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P192CA0077.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::18) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P192CA0077.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 7 Sep 2020 07:30:46 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16e11fa7-541a-4f3f-3695-08d852fff0aa
X-MS-TrafficTypeDiagnostic: HE1P190MB0490:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0490CA1F34C9FA9D73CF941195280@HE1P190MB0490.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tlJERNxf48ip1eiRble7TL1oynzlniqI4/KA6ScL5RuOxoUN8GyjeL/7HLt6ynymH6MfcgzjjelXZ8q7PIJsNnp/u5YTvB2YZZIAM85v/P+XgQdvZhUMdzSck6wLpCCLYfDfLJFtjM9K1TluBzxm50Xkn2dk7aiHl3or8zrM5KsiWflhtbEPfMSVev7aes9AsXWzQBC2DFIf/jUx6wXiX6FZ0v2Eip4mq0N6zLRqgKj5PCHe7O5zgJPSZ3th8vMD6aFVcBqHRanhVehfa5+Fmn2T2spTqhlJXl+tfznmGUY6TevvbsIRCPpv4Z92xbeP0p19UlpUVQPXNKbUkq88UuHwoSzygIac7qnU54+Aq2EKHSexxoK30GrOz9pZs9f1UZdBjDtjByqGi0W/+klBHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(346002)(366004)(376002)(396003)(66946007)(66476007)(6666004)(53546011)(1076003)(55016002)(36756003)(8886007)(956004)(8936002)(966005)(8676002)(83380400001)(316002)(2616005)(52116002)(7696005)(16526019)(66556008)(86362001)(478600001)(5660300002)(44832011)(33656002)(6916009)(2906002)(26005)(30864003)(4326008)(54906003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +vV58xHQmFIYuD+HcBOmx/3SQvBifxx8ENunV7EFrmCrXHJM8QubNJFTWUWKywCSpcH/6/Iof8lXJLHcw8c0vp95R0olgzzi/RnFWnQeElRgZg+5al0FpFInhBKrLTPTzTJ7kD1X7a/80wwfxnkxIoJlhrLPqt9Hdd6afQb/KCvkFq3Ecij0xlAFVDiWZgOxDD9QG559qZ8/35nl5/7RrU5ZeHkHIeBiFxpaSAEr/OpJ0GWaSzDI08eUIBLkqJh8gXZDKtlfZKf2m1tvrcbbqa853ZK8VlBtznTieijWx2Osho6CCqSKw2crj8SHTVUDwbTLar4pOL1usVhOiBT/MEGvyZFM5dHGiBkKtN+fItFUzReGtlXmz6LQ5FdHYz4qlmVRLL+HF756jO1MytKlwyRevM1B6i1ypVVxSA8DTAA2ihXDLJz/1q5tR2VjjwuOnfd8M8cac73bKnSu5x9he67d5V/+VrBNu6Dr9+IGOtintitwvyrhQu3lX4twOKA53n0eB2nmkhyCec2/IEA5daw1434gxL28ri1wjNn+N0RP3tXGLlHWVS98PoMB8mkw3UUSqDgChTwciGzSupSUff6hztTLovsdBBrC6rpBJEQfIyQ+jmE3FM2UqtylTvENvWHDH726X5K5VkKtb7saCw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e11fa7-541a-4f3f-3695-08d852fff0aa
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 07:30:48.5567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0uUu52MN+EAyQeg7nZxXnmPJsgLHNybdnTCxVybBlUsxc2153IZPB5qlX87J+1nNYlELvuE4bRhswK1ZaPS96SJK9kkO73XQ11XvOkofqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0490
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

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
It is not about the length but rather about easier semantics, so
the prestera_dev() is more easier to remember than sw->dev->dev.

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
This is really makes sense.

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

Not sure if I got this right, but I assume that may be just use
ether_addr_copy() and then just perform the below assignment on the
last byte ?

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
Really!

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
I was not aware of these helpers, thanks.

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
I will use it, thanks.

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
This is done in the prestera_rxtx.c:prestera_sdma_switch_init() caller
which calls the generic rx_uninit() on error path handling.

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
> > +               }
I will think of this, thanks.

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

Thanks a lot!
