Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48ED606047
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJTMfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJTMfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:35:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB46611CB61;
        Thu, 20 Oct 2022 05:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwxyD1EZTu8oXYheR9EDJwhPX3+2Ysevy7O/0cBs3BP90i9xQoheSme3HEHTtMGN/EdvMxEHieVXGd5BL2yDFzZrpj+s+QiWhdd3Ng3fmYurNvNoWWCSTfTSZXzzUoPqQHZvuiKV9XZFQFEraRNV6YfrVBEVp2zu9gMZrInRIuZ7WnUnqtuKMH9auB/Lh/ujBl/7fLiAMfQ8e4bzuCtRrtJwb2+vh3naPevqdFBMXholYqTdZmCIyD6yNGHcHpMnu+iKwRt8R33EJzl5T70Csb2UVzloRKmV5e5BeAzIbNl8MhW7DYBOJgabj+vibL9c13CL/lP59mqWdEffZjdilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/YiibZtt8oIPE19OVwC3YZXd2YUXxWN5oRvk2v2Dqk=;
 b=TeZsBpFZtv7Qe5YQxIBBPK02IBIPIp21eiSIf5PmsBBhcuEPdNyO3EWnHLiP4IyiqCeLxQ9reskkS2Fgv7jOHviz2HkgMrRMGcQSYNjCjHf2/KWO3F3n5yVB1VjLg+XNHAWdycgSPove1vgcAwKAO7ikSeEAZJ7vrkY435qog1TjUUGVQgrBORihlSBSqduoNGjS6Zb0hKOI2dWY/vxzkBzlZjNGeGkhAcVeUFunTcu+QrBpEYmsYF3XD2SN8K+U4o2GEYk4Prisxz9WAJuoQHj8iuZC0ouWyJTBFGJRp6KKMeXRfcjGn1453bnQszWLLLdq5b2v0ALFMb2fbsvnkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/YiibZtt8oIPE19OVwC3YZXd2YUXxWN5oRvk2v2Dqk=;
 b=oSzow6Qji37ce+/huy5q0r0gc1ZpcltIGcfb0F/r0dAhM0UoYhQk0QBmePWT6Q5lOXcBGM3slpkEOsNJ2f4lU1DHeDeJNE6zuHr+cEYpbE/gg1NTL1ppDjHfRDEEYde4vd0W79k6egBwC7zuIAS9xWLI/BIDHkese9b50Aj5VxF8tQe0/kEVKBpytb45QDUOehmLFM32p+73zi8PhGsAt4gOAwBeg3auy2VtWMPpTF8vlke0v1JK94FardnT99T3vlJ5Tg7bjHeaQA/0vc67rx/FTmhKPG3wrrntUgjBnBQRQfPgxCyxd3QdCKHr4YeIidodwnWu0jsjkxfV7d3D3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5087.namprd12.prod.outlook.com (2603:10b6:5:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 12:35:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 12:35:28 +0000
Date:   Thu, 20 Oct 2022 15:35:22 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 12/12] selftests: forwarding: add MAB tests
 to locked port tests
Message-ID: <Y1FAikA8uhjz9hED@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-13-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018165619.134535-13-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1PR07CA0276.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::43) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5087:EE_
X-MS-Office365-Filtering-Correlation-Id: f31413da-fd82-4c25-6411-08dab29791e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0f1+dWRwi4ZecfE6SglapvhH+CpKQAR/ReDxo4v/+D1nXC6MNbEN+6FOBJ1n5xtR77urAu1mZHViY7FHNfG/EBhIf4I9t87f1EB5olN6TCuIxwzXRn66mA59DsJugtB8TQH25HIr8tgQ0eba/1XnYje4kB/6eGRhATFjhoLn1a2WT9MDy6+rvyR4j6qD2WjM/O7I+W1pE/PKCAReIvmlWNY/+X3TLxdkwQWUxvmL0OqLaxOWHFJSp6r3D47Wapod21TtML4/jYZw0J8Yly0ueQbGXaX7Hu/j7WQfSunV4Xl/Y42at7TmiXoxSRn+CmXMtfEO4zo5U68ZCOsmg5KUby0KvORCGtjticV7zehr3DVgcaoxL/lxXuTZcrMJMwRoJO6Pvn2g4SVgKA5SgtNvUrypy9jJxSaGYwg5hqbg5Kuw47lhHxhWINjCnDB2znz2A/ZJy3fnLhEiMPyRCmKlsLNxeruBRhbcYJvNPhl7NIBi0cpAokQV8IC6yzD5HuFGrqd22mhlpPs1tW+wazcBiMlC8PK7LYn0Rf5lPutQh8OA9YsYQvL5iWui51qu/ZCKDN7JyEBiw1DU60Lo9UkW95Dp/r9kUhiyhqTI4cBu5rQmTkr2JBDN/ifcp1sODjWhWPe2k2mtjA56YtIEsbgNStz2y5mgEt/dOCPb+Y4srHOEM5eKwDenQ8CvWsylMJnIAcm8vBr26/uHWEcnlAFEnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(346002)(39860400002)(396003)(136003)(376002)(451199015)(7416002)(4326008)(6916009)(4744005)(7406005)(54906003)(6666004)(6506007)(8676002)(26005)(66556008)(66476007)(9686003)(8936002)(41300700001)(316002)(33716001)(5660300002)(66946007)(38100700002)(186003)(2906002)(86362001)(83380400001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SiPIcSJBN9jMyeat3c5XRcHFtJGoPH3fBd1lMCvuBRLDaSMqP6cR6ie2bo1E?=
 =?us-ascii?Q?ljlagT56UXi4bAvCvp/k5bj+ByBjN8+mjouaeQSM36jwJJQVoy2ARnbQQiwQ?=
 =?us-ascii?Q?8KbrHulc1xGQ+rW6hw2ele93jfq6yB8JvxkzmXXPjvftJlD4YJAAHfD9tpem?=
 =?us-ascii?Q?sIx6MRsmLSsGCtudZ9zGSAvyXKzLVrqeln7FNAEBsPDdNhNa0tTYT5l/qraB?=
 =?us-ascii?Q?fOJlmdhnRtFApuxu4TArIpo8itgkXpSGMaw3tMvuOvDGUKx8noo1ywlLQS+l?=
 =?us-ascii?Q?gRtEm1hzK6fkp/5RhkYSqJG6GWKqXP+9mGqUh1pg8xta6nhiOKOkrY2qKsEU?=
 =?us-ascii?Q?/pMPvE3456p4SOWJWxfOWn2RHaAIZmQd/I+B3mKHs6eMvCAgxr5c52CVRH0m?=
 =?us-ascii?Q?L6NoGnSldRcQIge5A0PDAc+ZZNBEGmrQaJFF+vsU3eXHarZ2I6BJ/wA8bHhH?=
 =?us-ascii?Q?g4f0Ai6UxVWggFfD2JNOhPnghKFzPeYTZ4KV+2pf6AQ1WMtcsN1fIXBCIzK+?=
 =?us-ascii?Q?EV5aQzwNU5TfZbt2Hnv8g9LyevHC/uW+SYG7FiyYlB69MqYzieA6hbnM2HQh?=
 =?us-ascii?Q?6aMPvYY0LlODjqlSVlYy8KzG63WmpgygEmKyWJFr4ydGp6X4c1AFOquGVaS4?=
 =?us-ascii?Q?6r9+WAfEf/LekzsPbzZAbW0f4SFMuCAmE0Ug8aIr7doOTkb6pHnFxnvHAzfN?=
 =?us-ascii?Q?XC3F8ry46qWurqBHpyTRt5BYjG5lJ5C1dxCYy+ID4kpBhsyWpUY8iMvixv5e?=
 =?us-ascii?Q?JMZAxCWoU+3cH6nlLfMo4cBWgg+3VsMMxvWbWsObfyH1nqL4TpKnA1bHSLm9?=
 =?us-ascii?Q?y/GNz8MddMpv6WwSZHHj9cMyYg5CQyJTabQ0OzK7x46gEGt/oAUZ2CAlpPhs?=
 =?us-ascii?Q?95e8v8qNLoACFrVOnjTDYd9dv0l5OSuO1Ocv0b2cRcsIuttPa1tDU7KapVws?=
 =?us-ascii?Q?OMmyZN7DbxkEVXp25fD//GWe8i9nW+w7CxRPmN0bDIEbVxH195OmAZXOcRfX?=
 =?us-ascii?Q?3oGnrVuFD6sWPQOFe54wteFPoKk9od72AqGKw9XMfQgmUas8ezPlgvGXoVFP?=
 =?us-ascii?Q?XO8/S1YDZQ7nMC1ICJ2g0+UiDbAqoBYdlVarFWg877UOAmtANEOCnWjzKPU5?=
 =?us-ascii?Q?wHxJ7KzqYmyxiR6ezQgXB/ucunbQLljL5oOy/bboBVbMqPlxfhqc4DGXaz6R?=
 =?us-ascii?Q?r07+jqHoTBnuwB8CjlTE3QkbKzX7VMUSx4pG7QDFzMpDfLz0xsiiU5OvQ1nq?=
 =?us-ascii?Q?AG5dC2ajHIWg2AS6xZBwYiPPc6mEHBvlPJ27k11cXXhm603PYUsoFWKLi5j9?=
 =?us-ascii?Q?C4s5D/2S+KaNQUh1isM6GQSYW7ZhOUHA1dlj51PZ/rx279RRag3lF9Sgqjb4?=
 =?us-ascii?Q?O7U5u2iYWzvVcCFHwVWb47Bs9eNu2KNamL0JZWcP92QbUXmiaLZ1YrjglL1d?=
 =?us-ascii?Q?efS4qcwgQhhfcXaGm74uK+8t1LcJy2IAyHI8x3s08ow8LefR/7IKVVvFhRry?=
 =?us-ascii?Q?FcDoIKEzZ8fA8Dz1kn7Z6/6AMCfjTQn/EuJR1x3iDBH5vSN4+V1Smg9VWXaG?=
 =?us-ascii?Q?ZOjUc1bM1jDIYVeGyhcpoEat1NO97MDROoMTEVQP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31413da-fd82-4c25-6411-08dab29791e0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 12:35:28.8397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zn8/kXIdVphxZzi1toyCkqGQeocCYCnarjEJtZXoKWN5lBts5FTmbiwRQh/A3eTryBZEqHbwVBUny/vldZY6yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5087
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:56:19PM +0200, Hans J. Schultz wrote:
> Verify that the MacAuth/MAB mechanism works by adding a FDB entry with
> the locked flag set, denying access until the FDB entry is replaced with
> a FDB entry without the locked flag set. Also verify that FDB entries
> cannot roam from an unlocked port to a locked port.
> 
> Add test of blackhole fdb entries, verifying that there is no forwarding
> to a blackhole entry from any port, and that the blackhole entry can be
> replaced.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
