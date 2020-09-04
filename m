Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260EE25DEA3
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgIDPzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:55:05 -0400
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:10237
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726047AbgIDPzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 11:55:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/plkEbCmd7GmJRtm/9JSFVrCwdn87aoh4zG2TsQQPFED/4MTUR+RJQuluj9r7N8IhPM1Xfa2QZyGzSpVXaTz9njpJH98S5gyxrKUuopEVtDMpd3psWSyFWuGjit0FOHDtYTTRpsbBKJHERAzluQk4o86v407BVEJWk4anZTCPIQyvLcff8AMHm5skAuSDGzvld7GSe2XWToIJ8vs7MK3hbzXRvFtNGFyi2tYeLbZ5/Ifk5UWcETaKADPM5zy+mAPK3aoj/5m6jiOVF43eOYUMCjzu89i7HuJLQL5rGMbT6MS9D+WbDlv7H6RQaixIWxzAEUdr0HBrfGzW+JmTEKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkX1N+03UROKdSame0h4JmFYPwUNJfcDC80sBklzqM0=;
 b=A7Al6hA33D1cMpcE9nSwSwua9vZx9FNbmVXoAJnm7ryVM5Yip13b+q9/BohhtxpnCHqVpIKAsaEGCdhwVh1mWjB2q12HSgZ3w/uBjbpJ22+m2VLaqb5Jct7i5k2BT5KN+f3re6Au2TtARti2l3aacM1YQzYFLVNtWV+LGWCxoIBsbQUJEHtvTt9AuFgEYD5Kf9vgwA8k6pChAFHiB7XFb/ze7u1/IejyEbmwP6TvQzXi8XDVE5F+NwJ1jepB+xVykJt+dRvUmdMD5u0G5CMLqBd3i7O9iWJwRFMtGf/BorOV5d6jmTTOdRGD8QaNsKtcojIrL6HCZMG5NO8IokhKLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkX1N+03UROKdSame0h4JmFYPwUNJfcDC80sBklzqM0=;
 b=ndegokk17unYz9iZD95Ja1yO71elcs1DnSoYEL9PpWgBrutFnL3uHWVPRSFZuIgYtni0Fal64KpjT4Y7RP9P/m/K5nFJuFBrnvf0gZZetabrmsNmP25aYTgFvn34/YhNvqVSjOGaO3z8lw86OSEr7n1v7ed0hdzwOY/UlOnHe00=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB6P190MB0438.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:31::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.24; Fri, 4 Sep 2020 15:54:57 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 15:54:57 +0000
Date:   Fri, 4 Sep 2020 18:54:53 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
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
Message-ID: <20200904155453.GB28910@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
 <20200902150442.2779-2-vadym.kochan@plvision.eu>
 <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
 <20200904093252.GA10654@plvision.eu>
 <20200904133217.GJ3112546@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904133217.GJ3112546@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM7PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::23) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM7PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:20b:130::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Fri, 4 Sep 2020 15:54:56 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 921dccf6-159f-4deb-28c5-08d850eadf55
X-MS-TrafficTypeDiagnostic: DB6P190MB0438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB04387A3F47C658E8590812F6952D0@DB6P190MB0438.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u8NMaiW+q3Mn7bLU4xL16TqtJNwhgZZcgdifUPkVKAJ/7GHanfqhQ7omYWZZYVE79Vkr91Qu7tSIsakXK7yUMFlnfF4JJhOSMViRva8ImhiioSis+4KZ9btUoVHX5Rrs8XvVnsmG1bzZde6G5pDjmT5Dn+K9x+8dJGY2WKwo60T+pYS46/pzwfv3nl4pGIorlIqOmswLLu9qvto0Bo3e3q8ra68S1BSgUnyzio6l/mG+HenB2THfn/vSrhiSybihcTdrivIOh6Kweb2bmVw0FWvkrV/kYVxilAi3cFzOPm7Hu6QlNgjf+c/naBiD4/LL5rDOSpaCmdrcpWFyZq/Qhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(366004)(376002)(136003)(396003)(1076003)(54906003)(316002)(4744005)(52116002)(7696005)(478600001)(4326008)(956004)(6666004)(55016002)(2616005)(66476007)(66946007)(66556008)(5660300002)(33656002)(6916009)(7416002)(44832011)(2906002)(36756003)(8676002)(8936002)(8886007)(16526019)(186003)(26005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1SjJler6iTgxepwimHmYzrMxJOeWVTYgVx5uphwtTpsJYtQUfUzk7G/fRWuSnDEuCBF3nR2drpmNTrLVoacZNO1PfnPcNhh4529bFYvEBimLf26Hy46dQfF4xtUdewn4t41LZCo5FEdIh5HuJL3ycCUCmOGz4WuXy4n1MgLeIANigbK6Mk+noZC6yPabF0yN2drG6QjLOu4i6l78aJjHJMlPKPD8uzYAVSg6V5uevc8rIDVHektTb4o/yrQKuVP9WVGTDU3YgKm6dRE5FKT0c2aI1mapgGByhyL0I1VYfp+RTY1JNHGzXp1KB9vxdCIBYQUqG86GzKKai5NMWmG5t6FGXdwqOTHBDdNEcou8ftOZ41BzphJC8T10rkWyffE13wAx74C3+qUfHwTCgahDsDwWzZQubdBKn5ZBqdOQzd52URdsc9ZZ0hAciEuqB+tUht40EegoEuFXNyR6kkmfGLANXfaKklYVoEvDASXonZawg6euC+cyRVQURAYjDXmhuZBIT8Zuo7vGSp08XeFLT8gp3Q5rKh8M3KuwYZl9VMd217xubaIC3SVJ6LYG7WafLVoDnGfNl1FY/ifVS1tvaBueaPex/bLg3rXIHwo5hvyrMs62uhxNM5CfgfT9lMtNBS+WxVzpqro6JBLdfIF7tg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 921dccf6-159f-4deb-28c5-08d850eadf55
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 15:54:57.4583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U10o0OzADIfeATwQmFyrTga3PhAweSCQNdWV6BvMJcfqhDQHFaNf4KrxmHv6sq0q7ajMXYQwZuaFbyAI07Irxl8h1t2K2RvElZoMXgOnkwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0438
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Sep 04, 2020 at 03:32:17PM +0200, Andrew Lunn wrote:
> > > > +static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> > > > +{
> > > > +       if (!is_valid_ether_addr(addr))
> > > > +               return -EADDRNOTAVAIL;
> > > > +
> > > > +       if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
> > > 
> > > Why ETH_ALEN - 1?
> > > 
> > This is the restriction of the port mac address, it must have base mac
> > address part at first 5 bytes.
> 
> You probably want to put a comment here about that.
> 
> And this is particularly user unfriendly. Is this a hardware issue? Or
> firmware? Is this likely to change in the future?
> 
> 	  Andrew

It is required by the firmware, partially it may have relation to the
hardware.

I am not sure if it will be changed in the future. But I will add
a comment as you suggested.

Thanks,
