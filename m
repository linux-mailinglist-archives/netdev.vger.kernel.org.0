Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A062C25D52A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgIDJdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:33:05 -0400
Received: from mail-eopbgr10118.outbound.protection.outlook.com ([40.107.1.118]:50758
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbgIDJdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 05:33:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWMOz0qNXb7ou3/5Qn5CqylqsJsaUD9YF3UsuD88HUz56jzT0CRcMydgQv+jMuGezgqiul1Z4PHBO+VxPHp7+LfCHX77A3mK2KWv5kXRvpdQLN3r7+VHot8SxVVjn12u/QNJGPR9Z6v3jw6+w3L7ncA574EiqMxg613tVw+FbesH2gxhgXzMKtGQ1GKEX1WpnhokPRSPpOICq3AQb3wMsIcXP/Sp7X3ke0XUUUuSByayecvQ30xfbmqYS8x3Q6K314CIB1Im4+6AWi7zNNlS/TFysyp9LbrtpiAD68WXHxHhX6na1N1+MxteLXjJmZhUYjjhsZstOYqe/jpy31UPnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTC2uNzxfl+7UOm4KahqNp7rrbmfCy3ITt5LIRUmFJ8=;
 b=hwmttt8w/x1U1bN9Odr5JNw99r6DinqwqiPJPjV7G5ay0OdyN/OBJ/jhh78BBe7htMkZsOn9pygENuyKFN/rXJBlCLwQnx5E4wFMab6DH7ljHqBWHmPsayOD08udS7lkToN5MKZp+4fU4Z2En3NlgEo4nGOZlgoKTe8PBKq/p5qjQ0vTTAQN9WWeAtdT4EFAk8/jilhj1rjwUp5HmTjfyMN6mBL7Gm7liKD2Hi4LKZB0Iw5ld110PgFfVuBfbAD9v3PIJI4VmxMkHGXkCjC4PZ5WWp0WQNVeCikuTptFNpHkGZY16zmSdcTDPeSHqN8PbCm6ORA0HmKo6hKuzjNjiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTC2uNzxfl+7UOm4KahqNp7rrbmfCy3ITt5LIRUmFJ8=;
 b=CeV2/IUZXd1u0de+SYD8TDEnTNn1+kzL6y5PMz+DZIPlWq1gRl/LMcMdrofxVUHME6gyOccjUuZT9Pu74Ze2UqjtpKjpMAd7gIEcj8Dd4DKcC/a0wfLbCxGNonRAaiZ8r4npjCGnnHujLR94AGDdACYtQE+JpUqBvAKfq/FNfd4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB6P190MB0117.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:87::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Fri, 4 Sep 2020 09:33:00 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 09:33:00 +0000
Date:   Fri, 4 Sep 2020 12:32:52 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net v6 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200904093252.GA10654@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
 <20200902150442.2779-2-vadym.kochan@plvision.eu>
 <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0701CA0018.eurprd07.prod.outlook.com
 (2603:10a6:203:51::28) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0701CA0018.eurprd07.prod.outlook.com (2603:10a6:203:51::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.8 via Frontend Transport; Fri, 4 Sep 2020 09:32:59 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddb3bfac-e95b-4cdf-30d2-08d850b583c7
X-MS-TrafficTypeDiagnostic: DB6P190MB0117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0117A525D8ADB8C94D6FEB12952D0@DB6P190MB0117.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxbqL7lEmkjlS09bysZI5f9FZh4O9J7MwcCHLNhQ/GYDMITtlaoPYHh87bWE2HpFaHyUipd7poy2SnK8MDUevsnyjce3r0sv74barWt9wgFGoM5hwuJRmDXJs0hrrZvGqqxMxDebVDoZyoE1OlDPrVs219/HBeunZw0ziUldproBED7VHZhpBmEyOHbwEmilcfOQxCJrvYotR1sGTzHoosXPTPyVpokxmufCsae7k98SnqNc6R1TZzKT0gdLmcCq9JbaWnuNAlRt8Te2brlZ1woIuYR5ErfBTWtOtDOdNPXWRhhwQqJy4EdWlvfAwNZWaojhoiap1Yz3CmUBd+FpvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(376002)(396003)(346002)(366004)(478600001)(186003)(54906003)(55016002)(316002)(1076003)(7416002)(6916009)(52116002)(8676002)(44832011)(83380400001)(956004)(7696005)(2616005)(8936002)(36756003)(86362001)(33656002)(53546011)(2906002)(4326008)(66476007)(16526019)(26005)(5660300002)(8886007)(66556008)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: D74c7aFks6UmfDIWTbE8Oip2A0MxkUsJq7gMRNVhHfcsEfSrNdxiYHFlVXJzocSHDI//h7DCNOJSyRlTxVK2LnE9lfWjhLnEeGJpAaucuayKDJWIJUG3KT4T46YI23VlTN2bxor8ytHev8seZtoW6rQwt+B/TJpYR/SPP5X3MYaZVI0tGu8FKJ3my1ufprcuybIoXgX8RzvJ54n7hKtR6bOboLuvs7U9FjI2KKVJpQhfkFt14BSLlYMebqNUkLQcfl7hwMSSxdHLum8wX6Ziaebc28vPpoQCeysOBuE5031/3GPU73Kp3BppZ5OV84M4VKqm3Nm/92kk1Ef0ui2kGvsJpday7T33FTaLLZ1KodgZ6X9aao/e+YHdvmfIxeXDkk7bl+EzcORxB5LfWyilFe07XdDQ0xQE09bqSAdinh5MwGkaaLPIBe8ULdGNsohA8aDjX02sYOzfx9MOMTB5B9dputJ5CI1RFiR6U8yWDwYPYjrn3QU8MTywVxXKQe9kC9+O/gjwyc8twuOsK+ylCeyEDlMdy1NR3/FYXYY3jyIMhCHF724NvknND+Y5Hl/5EfC/tVHLz7NDkyPhIvU8wKs/w4bFX7ZQemyS75IQ2VkRRkL4X0zHJ0qVHSmvDrsA7rKMKZZwC5De/yqoBrSrcQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb3bfac-e95b-4cdf-30d2-08d850b583c7
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 09:33:00.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9T72rnjfSIv7v2N0LUBfaWBStvzmkuUeQ4Gv7i7F8W1JB5lHHmvyjhY8cEBj8D/xhVrkD+3JLKe/JxA6Zcju/rNZI1Uf2PrUxSXRQqxx8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On Thu, Sep 03, 2020 at 05:22:24PM +0200, Willem de Bruijn wrote:
> On Wed, Sep 2, 2020 at 5:37 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
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
> > generated.
> >
> > Co-developed-by: Andrii Savka <andrii.savka@plvision.eu>
> > Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> > Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > Co-developed-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> > Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> 
> > +int prestera_hw_port_cap_get(const struct prestera_port *port,
> > +                            struct prestera_port_caps *caps)
> > +{
> > +       struct prestera_msg_port_attr_resp resp;
> > +       struct prestera_msg_port_attr_req req = {
> > +               .attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
> > +               .port = port->hw_id,
> > +               .dev = port->dev_id
> > +       };
> > +       int err;
> > +
> > +       err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> > +                              &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> 
> Here and elsewhere, why use a pointer to the first field in the struct
> vs the struct itself?
> 
> They are the same address, so it's fine, just a bit confusing as the
> size argument makes clear that the entire struct is to be copied.
> 
Well, initially it was a macro to simplify passing the different kind of
request structure. But after review I changed it to a function. The
struct prestera_msg_cmd is a common for all of the fw requests which
have to include it at the beginning. Eventually __prestera_cmd_ret() is
called to pass request buffer to the fw and struct prestera_msg_cmd is
used to check the response from fw. I can use 'void *' and typecast it
to struct prestera_msg_cmd but I'd like to keep type safety. 

> > +static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> > +{
> > +       if (!is_valid_ether_addr(addr))
> > +               return -EADDRNOTAVAIL;
> > +
> > +       if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
> 
> Why ETH_ALEN - 1?
> 
This is the restriction of the port mac address, it must have base mac
address part at first 5 bytes.

> > +               return -EINVAL;
> > +
> > +       return 0;
> > +}
> > +
> > +static int prestera_port_set_mac_address(struct net_device *dev, void *p)
> > +{
> > +       struct prestera_port *port = netdev_priv(dev);
> > +       struct sockaddr *addr = p;
> > +       int err;
> > +
> > +       err = prestera_is_valid_mac_addr(port, addr->sa_data);
> > +       if (err)
> > +               return err;
> > +
> > +       err = prestera_hw_port_mac_set(port, addr->sa_data);
> > +       if (err)
> > +               return err;
> > +
> > +       memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
> 
> Is addr_len ever not ETH_ALEN for this device?

I will fix it to use ether_addr_copy.

> 
> > +static int prestera_sdma_buf_init(struct prestera_sdma *sdma,
> > +                                 struct prestera_sdma_buf *buf)
> > +{
> > +       struct device *dma_dev = sdma->sw->dev->dev;
> > +       struct prestera_sdma_desc *desc;
> > +       dma_addr_t dma;
> > +
> > +       desc = dma_pool_alloc(sdma->desc_pool, GFP_DMA | GFP_KERNEL, &dma);
> > +       if (!desc)
> > +               return -ENOMEM;
> > +
> > +       if (dma + sizeof(struct prestera_sdma_desc) > sdma->dma_mask) {
> 
> Can this happen? The DMA API should take care of dev->dma_mask constraints.
> 
I will fix it, thanks.

> > +               dma_pool_free(sdma->desc_pool, desc, dma);
> > +               dev_err(dma_dev, "failed to alloc desc\n");
> > +               return -ENOMEM;
> > +       }
> 
> > +static int prestera_sdma_rx_skb_alloc(struct prestera_sdma *sdma,
> > +                                     struct prestera_sdma_buf *buf)
> > +{
> > +       struct device *dev = sdma->sw->dev->dev;
> > +       struct sk_buff *skb;
> > +       dma_addr_t dma;
> > +
> > +       skb = alloc_skb(PRESTERA_SDMA_BUFF_SIZE_MAX, GFP_DMA | GFP_ATOMIC);
> > +       if (!skb)
> > +               return -ENOMEM;
> > +
> > +       dma = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
> > +       if (dma_mapping_error(dev, dma))
> > +               goto err_dma_map;
> > +       if (dma + skb->len > sdma->dma_mask)
> > +               goto err_dma_range;
> 
> Same here

OK.

Regards,
Vadym Kochan
