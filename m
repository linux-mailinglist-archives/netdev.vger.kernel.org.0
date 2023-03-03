Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6429E6A9A54
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 16:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjCCPNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 10:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjCCPNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 10:13:14 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2109.outbound.protection.outlook.com [40.107.96.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8711F49C;
        Fri,  3 Mar 2023 07:13:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOR7PqX2OfOyiT40qGF3NJ1XF/ghNCcRsWBSbTaavRoozXKSEwx7KUHYvlxSczSlAJPQ517B46iJFUNGj3GoEB1CpppBCyYxuWiZyrvz/hwY0Fa/7ZElxTPhpSnhHdUnvDhtf48QrMzf8LS7PG38WB1WpqLgaRXcHPVXAcBV55CnanZNu6vMP6/QtYg3CR2G9mwk1nKJwtjD5ItqR6U2+6jVP5RTrHWQ3UHZJQBYvHQ2Gpkj62J61bot+auKJi7BljB6igGpjaTgkkoUkS5BKN7rmLtwvXNeaBpk8iWSl6RYeIBKURcwZzcZnlObV+Ewdp9uPv7tYuKJVXxd7k7CeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AUdj7kRsWbVlP7GQYjhRyZr9HdaWsYzqV8wiaBIoy8=;
 b=HInoh0/zsYWyn6C/mKAXHhFDBRZBvU6rINomGa+bJxaGW6FtN0lPE/RqL/6AnKGIzniBNvYxz7XGj2hxasCkwCEnMglWedwOJOiXZ56nC1hhKjjBSPDYpMXCm7tlcVKKv4lRrRsX85vh/rLlILL7EpYMFEyajezW3Vb4jI30wbhrZTXDHlZ4gKofabTsZW6OYOpV4Cj+3CwUml1LJ3JixAtjkU4n1LOSRtE9gtdWbYk5cJMracQQooV5iOq7wYYZq/mVK8PLRJ8hznzYA2KoaorbaKFvttPwIG7R8fe3yLT7Tm3JsfgwhUHX/cp/km2/CLNSMYAU4BRqxM6ADvoEfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AUdj7kRsWbVlP7GQYjhRyZr9HdaWsYzqV8wiaBIoy8=;
 b=OV8ArPEyeCNa460+uEz9v1lA2w+s/cWM2lVgRUTdUCNi6k9dcMbrYJhBEQ60j5d6ziepNVcClXoq7TjAq8/MyiCFvJUEmPaRwoRrcZg/eOsIsMwSlDeFCbrX5aH2iK6KqHMUOA2fyV2Trr3LCCXd3A33LqscaGBkTibmV7rUL7E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB6805.namprd10.prod.outlook.com
 (2603:10b6:208:42b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Fri, 3 Mar
 2023 15:13:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6156.016; Fri, 3 Mar 2023
 15:13:00 +0000
Date:   Fri, 3 Mar 2023 09:12:53 -0600
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee@kernel.org>
Cc:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v1 net-next 2/7] mfd: ocelot: add ocelot-serdes capability
Message-ID: <ZAIOddFw//0VDoyw@MSI.localdomain>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <20230216075321.2898003-3-colin.foster@in-advantage.com>
 <20230303104807.GW2303077@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303104807.GW2303077@google.com>
X-ClientProxiedBy: CH0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:610:e7::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b5fe39-3d97-4fa7-3993-08db1bf9c64a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNDNPvodgNF0URzI5hbecwVNKwAlRhtjBifwaekeHGfB3ium5yfcZP7rdqiaOruZCAMXvUz4FqKugpM4DfLUkww1ZB3ETWYOGrxgkR+uDk2O1Ym1o3GgS25fdkiWwaGk7tttcLMH1XGZFnEChvwDjBw+AMl8aEmJrb9osKs2iYMzYEZQAEwd9InNzv6qAKVWgeA5e1kPsnPWk4ueOUhKnnkm53c8mHocH1XQ2nuN8g4ZPTzNUvvbcTeMQo82VbSstq1PZ4K3LKDJLQQDvRT1iWST7JUpCWqE+RbbsTxnNCSBeOKfcGL+rTEqr8PgtE/9shAT+u6UzX1knY5n01SSCMjvLx9R9Obf0h2S7fkDrewaa0uNWkYLlMIfVlh6oxUtw8PBCCbOrpwjO0vSSGoKRopZu2nAQZkfkjMN3MRNArJhOqgdjoFdfBrjfexJ28BzWeQiizq1wxiURFl0Qu3t0p/HSrG95sqlEgL07kJOhb5qjB+WBDNBgM8gTw9cBKKnybLIEgBJqNwGDXEuMNUgCMt2C0zMBYumyZ6F5Q+CeAhpbMvCddWALy1AvyNPSNUdMLFcblDk7dz6jN9Me6WMYQgnJI4CbgPWzxCZU0FZyysmQld+HqaaaJx0VlMnWkE4Xkvt2FMg+lt/aUqqzyWJyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39830400003)(366004)(136003)(396003)(376002)(346002)(451199018)(66556008)(6666004)(38100700002)(8936002)(5660300002)(478600001)(7416002)(66476007)(86362001)(26005)(9686003)(186003)(6486002)(6506007)(6512007)(8676002)(44832011)(4326008)(6916009)(66946007)(4744005)(2906002)(316002)(41300700001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZnqbeXAznGjr5j5DvxS8i9y/LuaX2xvXABRTt2gylikCS2RZ71AyDSy9x76Y?=
 =?us-ascii?Q?dhQMhgPt+E/tM/vy48TB/jeWXTDtu4XZP8qe67BMY3GwrWfFhODWhBQ1ALcC?=
 =?us-ascii?Q?0VxGxG2qgBJfzEcTw/cJuxXOsutS6tGl9tUch+TtSQomAvW2Ue0kpOFCnuKy?=
 =?us-ascii?Q?mMs18k7PfEVlfp9/h7IgZyzSGnLFqA/suncXCoXDXvXq0asS171GA0Sz5GQ7?=
 =?us-ascii?Q?CH0XhaKdh81L2PoWxz/bLsRuIwPoRHCC4cNRSbdRRLL6My1EQskin7gP7+Fr?=
 =?us-ascii?Q?cxnmMtZRWCAyXiQzQiW4Bgvu2tLAIhLPmz+lKYyFcHbpaKMc+BKWXMm8O4X0?=
 =?us-ascii?Q?+jLvKch0fsaDAAnceyd71JuvZrwcU0nAhakaFHD0yY7A8JcoHWIEB98uHh2z?=
 =?us-ascii?Q?fesYuZI7ACJ61s3SWOg3xHJx1lvu/gka4/kGD5C5fi1Rxr8T/4mEf7+KyL+V?=
 =?us-ascii?Q?hF27DVzTivaxIkEw+KFYS+/VKyxh7rb9TCRhR/c1cdT6tUsQlHuUyOwwD/b3?=
 =?us-ascii?Q?Qg5dws46PSHXawMt9vcUs6vHfShd/pwGGykhwNXCuUYvjn9uBv8Bs9xmQObu?=
 =?us-ascii?Q?0uxKoMOKC9+NWL6ywTxtuRUrO3hGhHdtDLHUGJrqep1PIuOKZlR7S+5IJ2ra?=
 =?us-ascii?Q?nyhzTN4hRQ9lg831qArHh6B+u6+EVqUtG3m5SMHkHNK3XgXmM00ZaW2JP8AI?=
 =?us-ascii?Q?TZ8tvGDpRNbJb7RUz4JMOh52LXL3qpqIdH7VJd/1dNVE4BI4GYzI8jb7KUn0?=
 =?us-ascii?Q?HyegScbRvyq015xXmIkTLEqkTSWnNCQom3eTY6BLqPYEcJNNhWkwdXcseSzr?=
 =?us-ascii?Q?0nTkKy1LjI0Szobi8pkiM7wn2lyZgwv7b4PLq+lBZjyra0VdZXwuBKhdqTny?=
 =?us-ascii?Q?BH9CX6g6FUaXTiKVa+w+oeRP6128nokELW+O2RH53du60lFESv1+22sXtQ4A?=
 =?us-ascii?Q?i3gj4nY1NN6VCgpOsIRVoabz23vw58xY2XYhfnGeSZuYfCNt3KvORxU6ia4d?=
 =?us-ascii?Q?eF7sbnFlf7bQqW/qA1dhDRKIJ/AGYuTb6gwx6nR2wuBVs63ly1sCVESynNyD?=
 =?us-ascii?Q?Hj6pz2Sa4xnlA3RtdIEbF1jQY4FdH8ywkf1Hsb34SGtZdFxvHHUicxDmqHgS?=
 =?us-ascii?Q?I2p7A+UQau+zSILnBKxKS7zJeteaKBq+cKQkoM93Mza0ULheNk+W57sx889K?=
 =?us-ascii?Q?XLikA5qaFRDfk1DVcT/LLiKdmS2hllBI9JGq7cck0zKNLysGiQbOSPXaAite?=
 =?us-ascii?Q?PFxUDwccUAYxm+6Tpjcyc7EwI15bBrVl9iRxykos/P+tFGrWyHZ+oYFFyt/E?=
 =?us-ascii?Q?22Wu5neIUrpALDhJk8rs7O7GdyxU3ZrLTj3kpPO9Kh/bAOwiI5mjOntoM68o?=
 =?us-ascii?Q?onStIK+V3IDLhTkH1j05GRe6dcxrVGh1nEReYVpIeOxC20eJnt02iKRldVhq?=
 =?us-ascii?Q?Ky6wnE2wMmMsWXSbndgN+4zyvkKUF2vEHEQhXSIw4F50Lu6YX4oUeh51BwnF?=
 =?us-ascii?Q?bWMEohhKHXDZuOi84H1OEJCn0PusBLL3D2/mGdyeQdsvSoG7pOAZMfWPTKsd?=
 =?us-ascii?Q?iDjK9gLG5rcd5oy8lF5WbKpYSPXc/i9Zyhmvd2HsfD+sYLnEi4W/aaX5BY3i?=
 =?us-ascii?Q?sWXdeg2C7c1Px2xvpH3z/58=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b5fe39-3d97-4fa7-3993-08db1bf9c64a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 15:13:00.6865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLuoU027SD4d58W6YJ/ZB3xvM0opkEgQ9JsVo1MKtbQNmoqBdPVo+vYtuIckwjBODJcEZolbnNu8rL+ZAI5oUD1BclZGL6kFZpgxVs70FQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6805
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 10:48:07AM +0000, Lee Jones wrote:
> On Wed, 15 Feb 2023, Colin Foster wrote:
> 
> > Add support for the Ocelot SERDES module to support functionality of all
> > non-internal phy ports.
> 
> Looks non-controversial.
> 
> Please provide some explanation of what SERDES means / is.

Will do.

>  
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/ocelot-core.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> 
> I'd expect this to go in via MFD once it comes out of RFC.

Understood. I'll be sure to make it clear that some sync will be needed
between MFD and net-next in the cover letter this time.

Thanks Lee!
