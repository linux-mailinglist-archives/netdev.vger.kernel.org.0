Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF2234C8A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgGaUzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:55:48 -0400
Received: from mail-eopbgr140104.outbound.protection.outlook.com ([40.107.14.104]:39529
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbgGaUzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 16:55:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEEcgSqkN9T0dZ6nb1j4SFtq5b4rXFdbIBOpQ3LicC34uOqytQ3SEHvY4xL5vsh2loFfm/SGoZUvvzxvvaCiBoR8tFHYX0bUNxi0rZqziXDSrlrz6P2OA7r6q+DgLkndfrYMFpdzJvTJ39HgzZAghwRiOWZSRtNxOjnQ4P3Zu3AAvv9xSRwjtg/IBRjHe0CJtBs1T9q6niUT6W0ujmeV1HBMqSRTlqqaGp9GKDErKDQL1cX0U34SyoFtMFJ5AnHkHF65CSsFHH5Uzx9tRxJwcqoMb/7Sl8kMdYRLLE0HsiL5hAf3vrLOklaOziY9vUPp18DgWF3bwvrYlQSIYNCYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqF5Kxy3S3vmJlX3V5Hit/Wg0PKguKPFdln2bT9fmyA=;
 b=j4tk9EzOb15TeO9jIhAstmsMADiYbwm4+vyRk8vLkMZlTNQgYEvG/GyDldH9nojsHb6KHcxu+b4uAGBH7IbHnkyTRIaF2R8/A1GyHlhhfVhv/v4VOjNJPrKmHJFKDP7RLFWs314UJK6uG7y2Bwy4Iv/lIVl4VLGK5CjiZEwkGuQ0zED0BA5VjrCOkEl16v616Bb+gbyRtA2YxqUpnt2aCjRNzjAT9QG0pCxvWvMKmLOUqlOLzF1sKjc7ZQbOy/DWKAbbwzJdYe/OgA7vNjWRjOw+Z5kYvPPC+R+OXVSXszVgQLrOuDs5mYFnrrCCsuzwf/JnVq+dF6wf5r97hTI5Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqF5Kxy3S3vmJlX3V5Hit/Wg0PKguKPFdln2bT9fmyA=;
 b=JLkaCVpXYoiR1SO5mLnzoGXqpV203FXfNXjOae39JT3U+54UWNl4lV5dVzWmc1CuW37RGTHOSYaQ7hFH5HEa07uQyRZxUIfReOZn86/R32WyJN6Da1lkRGgGKZB1h97uzHGb9daKiLHjvwnmIQiTnX2o2QbNx/Ch/dIwZwTtd1I=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.16; Fri, 31 Jul 2020 20:55:42 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3239.018; Fri, 31 Jul 2020
 20:55:41 +0000
Date:   Fri, 31 Jul 2020 23:55:33 +0300
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
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200731205533.GA1159@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <CAHp75Ve-MyFg5QqHjywGk6X+v_F77HkRBuQsJ0Cx3WLJ5ZV43w@mail.gmail.com>
 <20200731152201.GB10391@plvision.eu>
 <CAHp75VcS4fEak3z0exODErs5FbDwf+Di1RJmf7JfMgnD8xgXOA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcS4fEak3z0exODErs5FbDwf+Di1RJmf7JfMgnD8xgXOA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR10CA0106.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::47) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR10CA0106.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 20:55:39 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbc2c13b-10b6-4879-d16f-08d8359415e6
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0459F4260A2845F44C8A10B9954E0@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9jqFuX5eLS9mewNhHFafeqERqt3TiWT5/HJ8zn+XRUnn+9+4YAi1x29r0KGo/XU7lCilvZtWdrcQVDrydeo7ppJq3uXMKq1pxVQ4ATRWNARJ+FqYcI0OafWRMFwX6slELxXI1ATlC+gp3rcVSH8YbLQJGiM7MW+aUn8+BBtZpL0P5RDncXtIfKdg6Ia4i3cV/dVuTXrI9KK1KPzm160BgHwZiyGYFVigJwp7Q6Nahuw10yYwyJ0/yshBfIr5JinCf9mW025D5ofjDm1PeTlr18l4Kw2UqijEy9jQWlJ47ZWQezSawTsuinicPqvMZnmA1NwKlbxgOaPMkoqWwLnAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(44832011)(66556008)(66946007)(52116002)(53546011)(26005)(2616005)(956004)(5660300002)(7696005)(33656002)(55016002)(66476007)(83380400001)(86362001)(186003)(16526019)(2906002)(6666004)(4326008)(8676002)(6916009)(8936002)(1076003)(36756003)(8886007)(508600001)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2cVQz0DfWgRWCBgA5NtG2S9bM3hxLebh/+pPnVNMC+5FJUSSvN6FYHAXpFmkVjsoGGuOEW4j76Oyxaytx+HnJyadr0N4W3W4LX+mFCW/9YEuQVrdQOOJpEQ2H7gP+leJG8RDLia8tdJ8d9AbmWcR6PDnyQH1VJo98Vx1Zoi3T4r3cRG3sys/Tthj12rFBw/FUzLQsVUGAXrFQ2di5AP4gDEFtfC5pkKyAkkRGd76DfFRyN7PxOm6+o0gyBU9//tutsccpzg/AfVvCAuGL5baQDv9hbiergzEt3O8sp+RMyr0PAKz12bPrJWuiPPDKj34VMBhFkPpIIMQw7zb2c0V9UXVHunMPkeugcJaf5fK3qMEsycNpeANlYx6kGoiPZjlfAv8/3ASH3L04SNGIlKOjSEDXOkbMC6NqTw2bQB9u3/RChMEDbf1ZNKpw4/7q6/M6dMSNbTzL7KAsDFsiuQRHKkc57hc/BD/XVB510Igc8fvpGte1U2BzFQAZsKcIcpTfJ70k9MfIvrPQ85JrEZD55JbLzlWgdmeI2pgmi2qS/9/y3lShDiCF7w5V9mGzuaxVxHCgHpTOZ0opvG9wQuTqsZyjtBJnOoN8M/DlZctPAdSIIYZJrA5yBQaSQaR9PVy0Es5QSIno9ajJLbOQYFV/w==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc2c13b-10b6-4879-d16f-08d8359415e6
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 20:55:41.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: giIoQyYUWLotbd+mkbropBRc8+O36GiJLdfgh8NzcbElPY+RhE8R/13JpLQZZp3DYqNqsLjHVtWo6H39uV7sd6xx82No1Tw+mrRfzWKJNvc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Fri, Jul 31, 2020 at 07:02:47PM +0300, Andy Shevchenko wrote:
> On Fri, Jul 31, 2020 at 6:22 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> > On Mon, Jul 27, 2020 at 03:59:13PM +0300, Andy Shevchenko wrote:
> > > On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> 
> ...
> 
> > > > Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> > > > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > > > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > > > Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > > > Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > > > Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> > > > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> > >
> > > This needs more work. You have to really understand the role of each
> > > person in the above list.
> > > I highly recommend (re-)read sections 11-13 of Submitting Patches.
> > >
> > At least looks like I need to add these persons as Co-author's.
> 
> I don't know, you are!
> And I think you meant Co-developer's
> 
> ...
> 
> > > > +#include <linux/string.h>
> > > > +#include <linux/bitops.h>
> > > > +#include <linux/bitfield.h>
> > > > +#include <linux/errno.h>
> > >
> > > Perhaps ordered?
> > >
> > alphabetical ?
> 
> Yes.
> 
> ...
> 
> > > > +       struct prestera_msg_event_port *hw_evt;
> > > > +
> > > > +       hw_evt = (struct prestera_msg_event_port *)msg;
> > >
> > > Can be one line I suppose.
> > >
> > Yes, but I am trying to avoid line-breaking because of 80 chars
> > limitation.
> 
> We have 100, but okay.
> 
> ...
> 
> > > > +       if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
> > > > +               evt->port_evt.data.oper_state = hw_evt->param.oper_state;
> > > > +       else
> > > > +               return -EINVAL;
> > > > +
> > > > +       return 0;
> > >
> > > Perhaps traditional pattern, i.e.
> > >
> > >   if (...)
> > >     return -EINVAL;
> > >   ...
> > >   return 0;
> > >
> > I am not sure if it is applicable here, because the error state here
> > is if 'evt->id' did not matched after all checks. Actually this is
> > simply a 'switch', but I use 'if' to have shorter code.
> 
> Then do it a switch-case. I can see that other reviewers/contributors
> may stumble over this.
> 
> ...
> 
> > > > +       /* Only 0xFF mac addrs are supported */
> > > > +       if (port->fp_id >= 0xFF)
> > > > +               goto err_port_init;
> > >
> > > You meant 255, right?
> > > Otherwise you have to mentioned is it byte limitation or what?
> > >
> > > ...
> > Yes, 255 is a limitation because of max byte value.
> 
> But 255 itself is some kind of error value? Perhaps it deserves a definition.
> 
> ...
> 
> > > > +       np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
> > > > +       if (np) {
> > > > +               base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
> > > > +               if (base_mac_np) {
> > > > +                       const char *base_mac;
> > > > +
> > > > +                       base_mac = of_get_mac_address(base_mac_np);
> > > > +                       of_node_put(base_mac_np);
> > > > +                       if (!IS_ERR(base_mac))
> > > > +                               ether_addr_copy(sw->base_mac, base_mac);
> > > > +               }
> > > > +       }
> > > > +
> > > > +       if (!is_valid_ether_addr(sw->base_mac)) {
> > > > +               eth_random_addr(sw->base_mac);
> > > > +               dev_info(sw->dev->dev, "using random base mac address\n");
> > > > +       }
> > >
> > > Isn't it device_get_mac_address() reimplementation?
> > >
> > device_get_mac_address() just tries to get mac via fwnode.
> 
> Yes, and how is it different from here? (consider
> fwnode_get_mac_address() if it suits better).
> 
In this case of_get_mac_address() tries to get mac address from
different sources:

    1) device-tree - if it is defined here

    2) nvmem device (eeprom) - if nvmem ref node was pointed in device-tree
       and nvmem provider has the mac address cell.

otherwise the driver will just use the random one.

> ...
> 
> > > > +       new_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);
> > >
> > > Atomic? Why?
> > >
> > TX path might be called from net_tx_action which is softirq.
> 
> Okay, but GFP_DMA is quite a limitation to the memory region. Can't  be 32-bit?
> 
Yes in this case there are a limitation when the device supports only
30bit (this dma mask is used in prestera_pci.c), physical address range
even on 64bit platform.

And thankfully few months ago someone added such ability for RaspberryPI
(aarch64) to support ZONE_DMA.

> ...
> 
> > > > +       int tx_retry_num = 10 * tx_ring->max_burst;
> > >
> > > Magic!
> > You mean the code is magic ? Yes, I am trying to relax the
> > calling of SDMA engine.
> 
> Usually when reviewers tell you about magic it assumes magic numbers
> whose meaning is not clear.
> (Requires either to be defined or commented)
> 
> -- 
> With Best Regards,
> Andy Shevchenko
