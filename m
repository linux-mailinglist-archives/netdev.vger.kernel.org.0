Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF0525D52F
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgIDJeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:34:17 -0400
Received: from mail-eopbgr10125.outbound.protection.outlook.com ([40.107.1.125]:19430
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbgIDJeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 05:34:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ede2PnbJXDbpjeGhroWRyd+h42hfOs2jWxS3jIujGGvA7XOW8RBrXv8WBcMVIU2q5ZhwKMl0nn0iqLrZoYNWYTQspayR/PMdEGMac9emnGEtJLnq+9g+hHyVVOfY06efLoRyZRFb4uswIUtXAVmk1luydFDvQBdH/qhoBIYnH9vc+rVtpmC8fbRLWYcKcVqUlcK23l0B/26nU5Q9A1Dsce5V6tm5vxSpvb3MHGlH6x8+qu414Xlryl7nY50XasZWbabl/0T7TKHX8KRJc27JsEP1yxhihLerzEhUqd+JkyOL7CmFGeYLMmeWNsMR9MqA0ZgTmwe55bnI++Wnp5RAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsEX8W4d1vxJ6NVkNe4T2aGgnfpDjoxV1dKyYwQOl0c=;
 b=i1M5i1iVoGF+bXJBJWgM9eYkGPfT6ePrJV5tNyFg0VaxfyHTtOyYqauEiO6EsptOn72n19gOcdbtgdrQvETJtsDfLT7W+fwdqu2b8lMMXUFA0VCzJ5s2dG0psBxyLKP+WYE1g9ijEP98ktGPEe47oR2YZxCTfKbVI5buCTQtfPu1Pi8f2+TpPSOg6vM3bbIB5raeASDd5KL2mDt4WgspdsCWOB6aEXnIMfS/ZdCwqt4QEANgW6zW1+BXCYH4sW134h7JwynU6X06yui819+Dntz6sgq2qCsqQDpRgcFlRgMKvVzsRVqhU5JEjBKq3YBR+P6J1urFEV78E1NpeynZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsEX8W4d1vxJ6NVkNe4T2aGgnfpDjoxV1dKyYwQOl0c=;
 b=LKz4TaTGjl7HN+lRBoH8ryUqANbD/d8IrfHbl6YemkS3b6MBuXRjRWngaGsSGlJ/aDfg17THAsoHNA+SYe5c+mh/YzZZ2XVO1nKiBl2dT/0p/bh1rUN4M6p0JbunTWaySs9jMrWjsDDkGIet2j+QmT8RGmAX5y+ObFUFovvtlNA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB6P190MB0117.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:87::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Fri, 4 Sep 2020 09:34:12 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 09:34:12 +0000
Date:   Fri, 4 Sep 2020 12:34:09 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
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
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net v6 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200904093409.GB10654@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
 <20200902150442.2779-2-vadym.kochan@plvision.eu>
 <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
 <CAHp75VcmPnmgxgE+NCTN71Wq17LQjjx8cJOR34AmuLuRFQ4cRg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcmPnmgxgE+NCTN71Wq17LQjjx8cJOR34AmuLuRFQ4cRg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P192CA0107.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::48) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P192CA0107.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 09:34:11 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e26d871-4e27-4985-5a99-08d850b5aed2
X-MS-TrafficTypeDiagnostic: DB6P190MB0117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB01177561345E310B0B962D4C952D0@DB6P190MB0117.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GjwqnQqOmDRPnOqMg50ArjS1RwptluDEts7KVw3V4YEeKK59ag288+fC7I1lS53TDzHRfkuDldA7xr/tkKE7khJOxwCF15khiKRSJ/vE1DPN6nA2zvbwfdfsz76cgcbSj7ufjq69l77DJskKUKrf1Y8d2tXM2Oyal5SUPc3U9brdCizshWMO/6zVtdcbSmFhciJVUye76HfewUh2RykdRC4ir+YEJdtGyJvmOrjtxcFdNmqZbeFV1amRpcYGvP7kMLYJp8s9NDpEXd7sUKYgeDzW/wmx6CSq9n3qebxdOko7i+wuIOpr7+vbr5VnlDVpyxLX2mbfwHjinrVhk3asAil+HQ3ZTLk/nm0MjPwQXTXXm4pvVLF4cFeOGn5WVvi+gOeSaIQmv/uzQLUS+s333Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(376002)(396003)(346002)(366004)(478600001)(966005)(186003)(54906003)(55016002)(316002)(1076003)(7416002)(6916009)(52116002)(8676002)(44832011)(956004)(7696005)(2616005)(8936002)(36756003)(86362001)(33656002)(53546011)(2906002)(4326008)(66476007)(16526019)(26005)(5660300002)(8886007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Bq0gp6iVd9PkhPpQ6G4Qx2bqZWaTqGtp1is4rWZ5LpZpUq6+H8D88fm0ta4V6EJRlLVTaL99CbypMUcS07QN2jKCJ5irXCTTa8ttO+EhDmQ8CgU66I9EXBMjTz0LORGQntGoJI4t8zd6K3ZXW+OQaTC5ugKzXBuDg5uU0V77SafKGcnjJ++rUa5V0zh3wb32JswffFW4uZ43Go7+rcav/e8b02Wh+FXomNO9BMWchw/op3JhsAyF61oCSesTDt7upVOK+ECDikdEkHRJ2y++XUS4a1ppkwQtIwpNhQoRI6W1Uoyp26h5drRjhBAkZxYEBs5dS/ARj6AaNTAhmERpKMk9JQBhJX8QY4HJzkA4jObHTqMIeGxvne2dbviRk83K2J6/JY0muoLig3CPhuwBPNlrhCeBL+LlfVJZUja347nhrIvEQUPx9EsUf/aXhZxBECq4/XJfdsAtWznJSSHpgNoJL0erFW8wthvZOzMGhQtw8+sHGh/3DIkjYh3cpVHgbSMMYkjWe/ejJg1ffWszL5Ifddd4HFsum6jk33lpLgPDcTtcd4Yv6WfS9gL4gqe6RywiQRBOeAsXLRGFUN3i58u0+ScZBmflMiINEuWkgGA1lpoT2V2Xlk0SGn5+yBFlrU62vllxzJCbiJQlV+p9gg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e26d871-4e27-4985-5a99-08d850b5aed2
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 09:34:12.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mva3MasasJap/Cn/FRNF/fOLDYfArLauRM07PM+HsEqfv/mWk+VyKIfbCSTYYCUe7nF+zrGQd97P2kDqwjO2Dvy+z4/yQnBtDliYVSAWKQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 06:35:34PM +0300, Andy Shevchenko wrote:
> On Thu, Sep 3, 2020 at 6:23 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> > On Wed, Sep 2, 2020 at 5:37 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> 
> ...
> 
> > > +static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> > > +{
> > > +       if (!is_valid_ether_addr(addr))
> > > +               return -EADDRNOTAVAIL;
> > > +
> > > +       if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
> >
> > Why ETH_ALEN - 1?
> 
> We even have a lot of helpers specifically for ethernet MACs.
> Starting from [1] till almost the end of the file. Here [2] can be
> used (or its unaligned counterpart).
> 
> [1]: https://elixir.bootlin.com/linux/latest/source/include/linux/etherdevice.h#L67
> [2]: https://elixir.bootlin.com/linux/latest/source/include/linux/etherdevice.h#L67
> 
> > > +               return -EINVAL;
> > > +
> > > +       return 0;
> > > +}
> 
> > > +       memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
> >
> > Is addr_len ever not ETH_ALEN for this device?
> 
> And if it is ETH_ALEN, here is [3].
> [3]: https://elixir.bootlin.com/linux/latest/source/include/linux/etherdevice.h#L287

Thanks Andy, I missed this one to replace with ether_addr_copy().

> 
> -- 
> With Best Regards,
> Andy Shevchenko
