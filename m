Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD39263FCE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgIJIaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:30:30 -0400
Received: from mail-eopbgr150110.outbound.protection.outlook.com ([40.107.15.110]:7436
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728443AbgIJIZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 04:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/fefeqz/ZxfhsMYMxWd6ETk7N/X41RDAxHdFPjc1pTKbKsuxpbgix7URzNrhFVoNdZDT/bP3H3K+bmURmVNVgO8Q6lqxz6CkBNKJE7zcLMsaesOwU/l2A/fdemywGPOkx3b2fr9MGaQEwGcEkFX2NLfIyhXa/57nEjFNmYNnsADt79OofQNClr6XYapFnGKNU0V+UXJ/xT7jDddS9WC+UioLmmi/YuefTG8SWwH4exyJqONQuZX2MMpNnWhX20pg6F1pAkHLWEfjDBs6Rt1aWpwo7Cq1btA0KCUl5eXUbHEun6tOg0CsAvcHnhxegn85kocJNVCq1At9Rzd3o5flA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTW8Oh/w6GwgN7togwyX59eIyhrtQIxFpRV1KBLMrUU=;
 b=cAHZBRNznpaPAXNMMbRHe5E01BNKeXWdPTu2FN+QUKq/eUMaRUOIDW3sLzoL+/E0GLAzG72Ib8IAP6JWT+GL0cd1Fd6yx4hAUrlnts+fht8E6j4XP1h/r51CePOmJu0rc91TQ1Rc5cbCMBZw5IRBFX8rSUYBRF2He9FidK4rJKe5AgD0wqdhGBwERYJ6T98FgYA0x+qxLbWA7bZzt7p5cGgCVk+iMrMFKjiOJxGl0S5ZDMyU7ZHPsVvUTXxGxqnIgnZHZ+k/a53JS9yxXoAs0H9RJ7rY02AnZwp58IA5xF38Egz1zUKbYAgqvFI+ps0GCbyiXQqxMK7aqRzxX8eBcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTW8Oh/w6GwgN7togwyX59eIyhrtQIxFpRV1KBLMrUU=;
 b=iCPs4WtHF9atrvUskTxP87DDodxUZGOa5LVxpevCuk5TqJteCXjpAtwPMGaLFZxaCKndaFwOIGo9gQbvWvzshVhzAlI0weFLs3Ba4ai950DkB/Q2GdzlZrIjPYFjuPCye5XNjxwA3XC2ekO88elg5s9qTVEO81/JXG7t62M9w+4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0362.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5f::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Thu, 10 Sep 2020 08:25:17 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 08:25:17 +0000
Date:   Thu, 10 Sep 2020 11:25:12 +0300
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
Message-ID: <20200910082512.GE20411@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu>
 <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR04CA0055.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR04CA0055.eurprd04.prod.outlook.com (2603:10a6:20b:f0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 08:25:15 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2e9f0d4-401f-4ba8-82dd-08d855630bed
X-MS-TrafficTypeDiagnostic: HE1P190MB0362:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03626968F05E11E178E4CC8995270@HE1P190MB0362.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7BYRvg91eJbBf9T+QNGr2v2weHL7S+neZJRw/j07DCEsY+QTFQt8wYTWnnTksoANy/H7hy7yFbEjxaNTA0H/KeoVqalMZT6GW0OFb/JGtk82/K0wOnKj4Qpb+TzE9YY4bGEJIm6worue0dKunqUeCWjbm/50WuSM77+c6mlc0JbHRzIANiz+HtCguFGLwREsiwzGWiHyAp5GqKlF2UkRmW1HGcPmILcffLHWNyAPF92q0chHbPTcW0EFcEUWCPwPIvxOCFN2DywGU740gaQW6o9qaa0UIP62PatuYgeHU8nbjPXdRwgNf7DainEykkPAy84/J1WSTYwxXHkhBqpoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(39830400003)(346002)(376002)(136003)(5660300002)(36756003)(4326008)(316002)(2906002)(8886007)(1076003)(8676002)(44832011)(53546011)(478600001)(66556008)(66476007)(26005)(86362001)(66946007)(83380400001)(33656002)(956004)(2616005)(54906003)(55016002)(6666004)(52116002)(8936002)(16526019)(6916009)(7696005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: W1J39bN+mrZzNR+thg3XCZ/wBs8xbz+LM8fy0NUdRnM+eg5zGR8qL86ilIEW8Qhx0NRLi7r4qUqqn7aoypdz9F5EWSMaD2wXwwu2oB+1jqrzEgWhGTyi1k+98jHLFNoEkXHm/Fincc72wIzdgC32agR+JRf/OyH5NleOymmck4b5Vgl1CYfOEE7+BtI3jLhqKBfav2DCJQhbtr9uVT1QDgQu7w+T0qED5CG2BBUe0bb3LCczgBeWgFrpwR2PaJy5yQ/A90+cHW7D7PvN5GmmS0A4IgLTBHDjBwo3Ocv7Rqq9DNXJnmXVq6CBa1kN7NVoTZOES2pSh6Uqj4tgEkDTd/R5VIya6lRH7AyTYd+TuaZV/JWEx0vnnhVL2nAzNAxSuA+k8aP0k5F517+KfHlDDaKRvTAsi0Ziu1JRa8VZQ9Mc5jxYXBpaYEhbqD00p4c6Vuyp2NgGFXOBzHN/cgeJ1JwTLr52ZlOBfRhGpnU44K1A/3/EotdBl7OeLe6/fAsijBGFgp8wjFAJZV8930kEuC+nnxxIoqLsRUNR5XSpaG7tzHcY0GlXrgSYQ2quqK+9lZ//gVpHyHnexOfzFAa7xAHOSqzr4eilJIU/CgXU9ZvrPyouKAVr8mBSrJ9RPt5xCL0L8zERIINkcgAhfl7AZw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e9f0d4-401f-4ba8-82dd-08d855630bed
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 08:25:16.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvfVfvSK5PHIlmL6Tcltp/I9GMim5JEx9Tn3d797Citx1qJdfnVxAlT1W37JRtNUshnqiONjnT5XGFv0p6dZQ6tADxpo2tv5CxH3DygDxIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0362
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
[SNIP]
> ...
> 
> > +               .param = {.admin_state = admin_state}
> 
> + white spaces? Whatever you choose, just be consistent among all
> similar definitions.
> 

Can I use following format for one-liner embedded struct ?

	.param = {
		.admin_state = admin_state,
	}
> ...
> 

I think it looks better when all of the members filled looks similar
(even if it requires 2 additional lines) instead of having:

    .member = { E } ?

[SNIP]
