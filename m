Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DE657874B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiGRQYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbiGRQYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:24:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2095.outbound.protection.outlook.com [40.107.212.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7F32A26D;
        Mon, 18 Jul 2022 09:24:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDkT+blDJ6oTywGNdtD7H7PUl9tPNgK7SFdsMVPznjQzKLwMQ4brnST4R1Sq80rS29bzp3MJBuJYTrjocMQMa8DUPt8LczWDQalEonWrFj9RexTXWPkeIE9KeIMlYD7vaUTvFq3OXkeL+7M4hwuUMQtmKWVSTKQGZ4jj9LztipumiaSx8X9Qs0D/EvMsqHcVgVIQ82juD1M1VDqGXcIsYrh7bGl9pYl7wmnlL4jxCjOnODW3nGb1PvbadlqokC6ZMsHaKarOABBrFe2SrL13AA2L3CnUvsCsHypcoVx29MptOuHHHkvkcddRvMiezwwFIUNVhxX2KqHnZacWamGWYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGpURPtgeQ8adeZTF5nacV0Jj83+vu26sBWqJkOKSPM=;
 b=XEmbFzHt4te8i+2mNDW2tF6eEKaD5E0g0F9G7IWT/Fm1QW47y1KpZ+Hd2LE5OxleNnjj+8vfBOx7Ky/3Wa+3DdVTvGiXnjKtBD9zH53C0btFaG4ZDbro/+ICmAmxcmH9iotqA3wxfnwQd/d0ygfVjVOXC+i6e6Wz6I7nuxquQmjNNNXO6suSQ7v/PMWreAtKHMPFV3mbO5WmL+c9H6UP17HQ80TNbx9H08R2Zh6ffOac6tsgxh288bbaMcrHhSm0qyiClE/65UPgh9+hn9D6+90ebyS/e8vNJTgPPwWPLSP6Pw2KysICTOW+Q6oB1zaKLYScBeNY3xg8b5bMoyGY0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGpURPtgeQ8adeZTF5nacV0Jj83+vu26sBWqJkOKSPM=;
 b=DTh90cEDEhW2WkUfhGe20YB1v+vkxnCd6ICECHK2pfyQMkuGQ2c2DSdFlAmIcNKusiQ6bGH/6fjXu60w1mvKeGzlI3tRbH/LqzvRzN79mnV4GzVjvQeFKEkaDhVkiRN//fuzq1spnBRYJ2uwcSGbHmP5fTaOKBWES2eXcy9C9qY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM5PR10MB1642.namprd10.prod.outlook.com
 (2603:10b6:4:b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Mon, 18 Jul
 2022 16:24:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.020; Mon, 18 Jul 2022
 16:24:18 +0000
Date:   Mon, 18 Jul 2022 09:24:12 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <YtWJLIUepiKA4S4u@COLIN-DESKTOP1.localdomain>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-10-colin.foster@in-advantage.com>
 <YtVrtOHy3lAeKCRH@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVrtOHy3lAeKCRH@google.com>
X-ClientProxiedBy: BYAPR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:74::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5926f836-c665-4490-233b-08da68d9f5c6
X-MS-TrafficTypeDiagnostic: DM5PR10MB1642:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bo64p+qtI5VFfSgnG2oXYkzzjF5VudtfLa3LoRI3XWTJi+5yg0CjWVILtynddHG9WDqBVNNj7VnjxeTRD4CNDjG7ALr9HIM6eqNgPT9MAPTamSvxXSt9v5BmDjbZJptWdMC7iqWWt0v4Vy9XVVre+eZSA4NNPEac23ShI82mJHIwaPNH9ynlBJZPFFBDU8wQ15pZd591WwkPfqNcMgRXuGshWQaPoAk3kw51O9hDPVqv9OhwYVPPXXq/LwQDUAKKPTQ9txCyihm5jRx3nAuO7h2m79cd37FGtSomLn1t4p5vmibi0VAZU0ehNH7ETwlc6EybWfrSISy7lq2Gy/f2bMRDgH69H2K+voSSYb/7mXvZwjslx/1UbsuASvCD+xsHc4SdnnJdsQX5U17vyByXbDzfUY/6x7R+P2WDOua/8tSGBDw4RMjmVdv07i3mLrE4R4kErFgHqiAK53wlVXRxDoPvaarVDWuN5xMGgXW+hBQyg/Bkd1MRUJKjCsKBx3R0MvvU2ksZr6JxH2wxbS7iQsUvH5oJ/aXGsxoea/31YG7vDfl0B1BUr8Oxf471DMYJ+f49OlG2P4+54+CJTJt567Q9VwjVFs+ZtLLe4RRSZmbMUiRipP6V27frSqMoBFLfjopTb0R4w0OsPvL2CUXZC9bs7AXkLkrGWzv9DZ4y+DDarxvi3K1ZehGufDQIFB0u3LMhNWxeTRotuOh+Yc7GWSxtspOG2SiC2q9NqUmk/rGEuoZVOqY+TxzvrOmOJ9fQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(396003)(136003)(346002)(366004)(66556008)(66946007)(4326008)(66476007)(6512007)(478600001)(8676002)(107886003)(186003)(9686003)(6666004)(26005)(6486002)(8936002)(6506007)(41300700001)(316002)(7416002)(44832011)(5660300002)(6916009)(2906002)(38100700002)(54906003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1HHpELiRfpe1edSw9fMcPcLgLcCKCdW13qiqYj9kPAolpCsLconjysTkutja?=
 =?us-ascii?Q?1GocL0iCZi60vdGk/hHgehMFhilcQ++DqozRS7F+rEImAYV7WA1obgw496vG?=
 =?us-ascii?Q?6uvK+fz1Kjb0E8+pOLnZ0xQlzvfnAtdXDDSMWfxiepd0gn3yO/e8fhyLtPRb?=
 =?us-ascii?Q?kEqQNXPwpU/+/T1CnT2veEgbtA3wUo9zhYjRC2PXV6b0FyOinrsgFVp/p/1p?=
 =?us-ascii?Q?aQlsMMQKTSJFQhkF9FU4OXxGLTw5jlZjSr6rlm7FxjXcXehbF/8QRD981GOs?=
 =?us-ascii?Q?X3oFdtbWEJaI5wEe+wBEF/a0qk0YlAfqYX+p7cdpQIfjihY9Mj21vpcBYHnu?=
 =?us-ascii?Q?tIzl/5EBpBsJ15vyUGmoghxRf7K6OR4k5ZwMHPnQjsmdmj21uf5u+Hpxkv/L?=
 =?us-ascii?Q?GtXu6pg710+5nCJqyZyePcsfHRgixEqx6VpOR5UqdWVwoEiLRWXp0x9h6VQu?=
 =?us-ascii?Q?bPXUZNN5W3/ILXAGPEaUP63a68WRNNnh2Hrorsau/VTqmbLlXdJ3ecOQU3rL?=
 =?us-ascii?Q?XXq3FzsKgdB9s1tJ8dvb5g8fNE+Ax/uAdkq7gXKNG7KjasOreThCr6d9nm+L?=
 =?us-ascii?Q?RWt0csWLdECTObYAJeJPOhS5y0gryVfKTD1aBRjBwh+s7EybcIJOHsYzU9GQ?=
 =?us-ascii?Q?hvTjON+V587B+MPmjnIBvcaR+Mnw2WkXDR7R3oRu7+z6FG9r/CEb+bDIiRF4?=
 =?us-ascii?Q?wBudLyZt7LOonk25+zIP8C/lfGXp8vKuEBxSD8+qXaQsmsqufDOTWuAn+SAw?=
 =?us-ascii?Q?j/R3z+LSPuecYiFuNQqlYto2kdfcYSLva6fMl9g+USUPGnK1ZeObdNtmJ5rF?=
 =?us-ascii?Q?8rnG52xZpMFZX4pNbUK0Asmq/3Q/zXZbSojD/xQBYEGPNt4XmtbG6X4ihU2X?=
 =?us-ascii?Q?iy4qvwUObkqf2qPymSCju9SKJCFl7ZSZT8c+F7FayHa5wC3oi3+sjaFxs78a?=
 =?us-ascii?Q?nWm7zhlhXCX0QLF9CajStQt2XOvE4JfWDMNQaHRIXsSAYNAav1YuyoxQtieB?=
 =?us-ascii?Q?6H/m//Oeez1HihtcLII7vtMC1TqxzrAJ6K6Uo6cy7wZvNfwF64DU8M1K9RrC?=
 =?us-ascii?Q?wT4tJDozXhQsUHSvZ7JcNs6D6dJgKXM2npzG7D6/xivz30xLhmgk1ae9g94I?=
 =?us-ascii?Q?NPBT49VaipTruUP259pTXmXruC4iMUTsmh8PWenDycJShB2lNVcpNeO8LtE7?=
 =?us-ascii?Q?QrpgvdkaJFJpAQXClurYLwjaoBob0Ex9x5Lg1uAuzT0to86zAWkM/TBxDBh+?=
 =?us-ascii?Q?4WBLZIEUakaJpV3iMImpkl4CErQKCVKOORUtT9qesFG9azeyplU5aIxMwaXw?=
 =?us-ascii?Q?2NPsWyaOZYFyTT3FNjMtTJWdxsJaGiQHGmKU7rUcIm/xoW/ScyEne96p6ptQ?=
 =?us-ascii?Q?NbOGlU2JZQb1jPLGSgTzv2S3EYQHPV7hRtIfEKyEQTySkgSg3hZOh7CZS8JD?=
 =?us-ascii?Q?U7hovDeTDNDgJbkRG+T8Mkr8n97xNdiLhi/2kdGk1LMHj+xVm/3Ei/hhdK/l?=
 =?us-ascii?Q?YAuCeKlV/m6VH4YtehxMYg8BcnspkmBdEhrRFodUHIoEJyUefIWcKCbM7Zo5?=
 =?us-ascii?Q?dxk/zQUm/ytYwCzQNkYwZzRgtROwSeslHH16wkpfrIlnMNpR3qHghGwaQjJo?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5926f836-c665-4490-233b-08da68d9f5c6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 16:24:18.3971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Lmbpc1cn3nFk/XoCPn+OfXy5vxNr7onseFWu8YfjmdkEDgnp/Y2LE1TqhMHHG6YAlXd5G9rlCGaI0DrO/mloXV8+LJUxZZPv4yoJAr4+sU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1642
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 03:18:28PM +0100, Lee Jones wrote:
> On Tue, 05 Jul 2022, Colin Foster wrote:
> 
> > The VSC7512 is a networking chip that contains several peripherals. Many of
> > these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> > but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> > controlled externally.
> > 
> > Utilize the existing drivers by referencing the chip as an MFD. Add support
> > for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  MAINTAINERS               |   1 +
> >  drivers/mfd/Kconfig       |  21 +++
> >  drivers/mfd/Makefile      |   3 +
> >  drivers/mfd/ocelot-core.c | 169 ++++++++++++++++++++
> >  drivers/mfd/ocelot-spi.c  | 317 ++++++++++++++++++++++++++++++++++++++
> >  drivers/mfd/ocelot.h      |  34 ++++
> >  6 files changed, 545 insertions(+)
> >  create mode 100644 drivers/mfd/ocelot-core.c
> >  create mode 100644 drivers/mfd/ocelot-spi.c
> >  create mode 100644 drivers/mfd/ocelot.h
> 
> Generally this is looking much better.
> 
> Almost ready for inclusion with just a few nits.
> 

Hi Lee,

Thanks for the feedback. I'll get these fixes done this week!
