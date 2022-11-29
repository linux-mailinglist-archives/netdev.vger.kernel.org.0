Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCA63B7C1
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiK2CVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbiK2CU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:57 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2096.outbound.protection.outlook.com [40.107.100.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396E14046A;
        Mon, 28 Nov 2022 18:20:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Huh7pFKVTK3PEYMIsAzKZ1fWnteLQ+08cWFAJS2ojwasDXulETV0Af07UxWQz9gjZgzuiQPNAawc7mb1FBuxoN5+Jc2Ldkfl2/3ZGYJzQYv/S12nPcvmSOR1lcAHqDiGTthqVtDXViIG7EkttXPsPhngeSeYVkZSpjkej5QoPLwiC7NYyiTEkWHwUuKGID7tJwUunhYzPua+ueqEeZbZ7wDhoswAEX4rxFi8Dcfi3pdsfVvcDUA67HMM2HFoyRJAnOuCvasFKGGo0kViO9/BiXYYbo1XEP+/uojy14YpNOqObMZrX5A8EAz/yrhD9xCs92VE9OssJSm0MBCtfarBaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJzpjVWlurb1T3fP4jNHqVCjcg9qz0Jt+CrPLOBWq38=;
 b=ijWY7jiM3bSr6kLF0Rm6Q/jqBRr7uiS10F2YwBYPz/7lE20namLHhCSRfgvzNjM+T4KhaOCAOqiJh6d+A8aaS18cAuxusmz44mpRpF9xedmzmyTFt/wT8UHfjBxjN8PKkdIOubLUplFlx4l49vEgfMKH9Y+wdDMQzfQa0bvWC1VVeo5SnNSiW/LXS1S1SChdJ4Oba/FB1uhkhST6VsN9rku1Z0HlhhdP7lt9o58Z5ODGri7Xnp6QgCW2+Gehn/sZFRefHXI5A93VKbdQX9sH5Fi+6nKqEUvoNBvk15fT4PBjDcoPB9e7mEAtT+KrctQ56a0mu1//vMZlwz3FFrntYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJzpjVWlurb1T3fP4jNHqVCjcg9qz0Jt+CrPLOBWq38=;
 b=MLoJdN8/J2IBl91NrnK3W0CIPgUcYBQ8LPDqkaZuh81pTFek417nBIXWd/LYlOWUjWZSgms6CRJjvPluxGRfpcwWNwaAgYbRhs85ktlSZs/ImIYqpQzbvT2zAJIkEYk1MvBUABl9HjNlPY0HME/7UzHsuA61WcjigHWR4Um0DUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5084.namprd10.prod.outlook.com
 (2603:10b6:610:dc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 02:20:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 02:20:31 +0000
Date:   Tue, 29 Nov 2022 01:20:21 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y4XO1T/M47bXqIBY@COLIN-DESKTOP1.localdomain>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-4-colin.foster@in-advantage.com>
 <CACRpkdYkD-=y0mCnVkkQ9+4m9-nx6jQu=TfL-TPePbps6x+7Xw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYkD-=y0mCnVkkQ9+4m9-nx6jQu=TfL-TPePbps6x+7Xw@mail.gmail.com>
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5084:EE_
X-MS-Office365-Filtering-Correlation-Id: 10df13f4-5c1d-4965-34a6-08dad1b04a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yzfiMXdAFFN2ycWef4vbY2HEKymKzXi2HOo4r8pBdlY4+z2wZ71cE9L0I2+TFxgsYjwpvf/ccHKn3e2OIlfFkxafxlvtr67C7/fDbnS8Y17dXypv5XJPfPFq1mWXrbhEpxdKtn/dbN44bgB/Ng6ucBQEhyYEyZNQwAsidVx2q0PGBaI2vkgcuJ5N714QtqRTQDfD/wa9EoRhbh0ji/rBKDuJzftyb3e0WJ03lXBwQeEkBgCgu6uMWS2vH91SJMb20JS3y7/92JdSGMSObgAUed62djFWalKXcqckXmNlVvprS8JokH+hbHPhiK7sUsoj34X/JQy/z7wWYUhrvxyHr8tsIIu+/0rlLXqazV59Td+8lmRN5aRzpedf47E/MPn3f7RVuD/h+CbNcZsBF1lPdnIokyWXpye/5cJfjwmco79+vp/NjopYPoiJBQ8Euo6BeI1F2o2x5DFpIzPvUlu6iFjGtpP+YaSfhvNR53VXK2d8ucpU7agTywAQJ72H20d5nl6FOnXhEuxk9nkQsAAlRm2YaVZSRoi5pO5dhP5PFn0tnEudpqXRDOfCSUKiVRApa/fFdmtRfDT88Ec+j+R8Wyfjb6RNEjAq+a2hGMiD8aUgoS5FI4DcN8TxioCrexfJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(136003)(396003)(376002)(346002)(451199015)(86362001)(54906003)(6916009)(6666004)(6506007)(6486002)(6512007)(9686003)(38100700002)(26005)(186003)(7406005)(7416002)(8936002)(44832011)(5660300002)(8676002)(53546011)(66476007)(478600001)(41300700001)(66946007)(4326008)(2906002)(66556008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?23tJppmi52bea75EECEjEozSS7pDTpRD6mHdYDaRMlIZNKYwL03BMpDTZZuC?=
 =?us-ascii?Q?OPg+PRty64RdiZRsLll7GnjxMqB8pAaOccR/WMBWtVpSZHGjBy7Tujthh1jU?=
 =?us-ascii?Q?VogbHa3rgCsQxHppldmjalRnWm9PGdR2vByCZiGcyOXuiDWkkcZIUyqcFc+L?=
 =?us-ascii?Q?86021MckFiZriGANsyB4orgC1dn8hpQyAJChg6xjr9QP47qm2vHijkkeFENx?=
 =?us-ascii?Q?tEMzQRZYkfZI15xNAyF/5OqbKj5da1TYgEVydZfOdwoh3hKIkIco4v+oRan4?=
 =?us-ascii?Q?meW59bD2PIiVnRvkRQ44QwkMW8IZzhz4EcwvgudHsuKNjRZaQ91VISirweeq?=
 =?us-ascii?Q?aAIBKPTGSIGNNlTkLMaFCjDSuGGZClv7ebOjydUc7as8EGc4fRoJV/j9w92K?=
 =?us-ascii?Q?l9jWXNM/bD5qw4koS5H7yLI+tSHmcIoMxcIdagB303bX+4dIrSOgWLtp6w5J?=
 =?us-ascii?Q?rFoXzzlkUnQGnI9LqA3KwlSYZDIz9re1MdYTIJ6BFKtdcrdYilVAHAICjGv2?=
 =?us-ascii?Q?l2fcx+eyhAzRt/UuJ3YaqUFqp9EPWKjDWfGyxSCwn2lkdoXnb3bfQZs13KWs?=
 =?us-ascii?Q?siTSm1r/+gFjcYmxstUSpV+KSnLozN3eQs3qEm0o9ab4+hYttzBBZCTsx5Rh?=
 =?us-ascii?Q?REazU6OTQihfMYbkafzr3bYF3iwxJTMo375pHr9IOa6l23Kt7gT1w/In0+By?=
 =?us-ascii?Q?Gm6VvPFj5makDBaotoNH6pia2LAlKq5+5+zy9tDui7J5m8IBsiU7uSMgQKUw?=
 =?us-ascii?Q?7R/P1D2fuL/R2E8dQuJDreWttlcDBLbgSua3bBmuE9NEI1CwSLHNMPAUE1xV?=
 =?us-ascii?Q?wRFG/yI1zgT/hA75IfEyCxSozaydGmtTDVX/MmJJRFHjCkRGp0w9G3BKJQEn?=
 =?us-ascii?Q?48uVV3HX9yd5yvAXj38BJ6ubc08Lse+nKmNGRSHBf65JM44wcygCMvDFp4c+?=
 =?us-ascii?Q?OOI+NUPobDMjMthC6J6vDM+WxVfPkb1bJ6IIXbcY9ZMLx9/wRiD2XOezAPHY?=
 =?us-ascii?Q?zOhe7bfcAs7O4nNn08JtefB4wAY9FH8gOfnVNqAxZPQv+NCKrsfP5GrSGBnk?=
 =?us-ascii?Q?2jMGXcai4sBOEa3ZRPyZjm4k0CcjUiemB5Th59Gm7DkXiW5Wd1Ev63lXt+AY?=
 =?us-ascii?Q?V1jEiK0Zjsdoo6SHARWkga5F0kGJha8Er7Trtr1VKkGJV1OOnxmzsubWAC6u?=
 =?us-ascii?Q?MxhrZst/A91QErSMHYsoSDnQH6QtA7Hot9Q+UMQCUu7hW27R96ORBXcIBDVD?=
 =?us-ascii?Q?0dey3yM9KaWL8Oz/6H33LKnKWdLMADcbq9jYx4prPGTpkWf2yFYzacr898du?=
 =?us-ascii?Q?0NCLEjTr5IJ0n3jfacj93d/V4WWaE7lOcvjCHybzCFGCNcRw9/0pWgwXTZkm?=
 =?us-ascii?Q?h+ZzfYsFRhA8nCU3LyQ5ok01BTfZ4aaj7E3VfMi4XqbCCUt5igxXa4AQlISS?=
 =?us-ascii?Q?kgc1HYHX5V7dniD9K4v0x/Ubn47orDPyvrY13UP5dfo829Ctsj59Lg6MI9c8?=
 =?us-ascii?Q?tNW6iyM6K68E41D7E0rAGU11BVCxp80q4/LdV2zuEpEzpSv5lwItQ+fl7ArT?=
 =?us-ascii?Q?x1wifGhRnI+m9WkoTLsboBS8Nj/PNTn9Knh/W7cJpH3B1AKemi1zdIjKi+xq?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10df13f4-5c1d-4965-34a6-08dad1b04a20
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 02:20:31.6920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QoBaS/uq4o4AlMDkKVgryxisDOfhtlp3gcLajIB2o5qVp0pGiBn8IqIaKrs2nvOEcPZtYPKFOjZ5FnsuCtUHdkdySMmpia/9qv6a3MriSc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5084
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 09:21:26PM +0100, Linus Walleij wrote:
> On Sun, Nov 27, 2022 at 11:47 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> 
> > DSA switches can fall into one of two categories: switches where all ports
> > follow standard '(ethernet-)?port' properties, and switches that have
> > additional properties for the ports.
> >
> > The scenario where DSA ports are all standardized can be handled by
> > swtiches with a reference to 'dsa.yaml#'.
> >
> > The scenario where DSA ports require additional properties can reference
> > the new '$dsa.yaml#/$defs/base'. This will allow switches to reference
> > these base defitions of the DSA switch, but add additional properties under
> > the port nodes.
> >
> > Suggested-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> This is neat.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks. All credit goes to Rob (except the bugs - those are mine)

> 
> Yours,
> Linus Walleij
