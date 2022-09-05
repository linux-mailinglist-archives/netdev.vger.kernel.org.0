Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6DF5ACEB8
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiIEJTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbiIEJTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:19:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236BD5594;
        Mon,  5 Sep 2022 02:19:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNt18qRtQ/CfkRHFxpsAVTC+Ow5zep0AZfcAPrVqYIgntygVQ8em1/LsuQUL/gNERwDKPaGpiGsXH5Dqn3yxMbRhM7DquX/AcfKvo7jgS/Dnxxeg1tDgE/l5f/toRpwCc6khSZQmFR3lZtSF8uwNk1grGutAdzJDLvBvtbMf410kADjt2kDyBhLYubjBHlk/bi5NTdYQrSXaG77t4A7O89u8rTx0KoGSjkWJCdZ6sVCeQOeSWoFXCOfPo0YXdkxIJmBC/rBe/OfyVQW6GnOA8B+C3hc4CH8gG5Cb6pm8vJBmma8Eo8Hp9feshZRJpmX6mxGSWPv+T5PlV1/8+Tzqtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSnlDnrmocEzMHR16bndPmDjBRuDaRg5dDQZidhFj0M=;
 b=I9twFxvdjl+F3uy5KEai2OjsAZjC0bUAdCUABGm5F2skayuifKgxa9jjG64IyAoHqNsPx2C2VHrJuJVq8bszWkeCfD9O+K59oXZ8kGoUMx2wHmCpD7hED5L/0Vi64wGUzmLn0lJxRNDTzC0civTL1fBTRuuOa2782Z0U0h3KPLBtYACLsG9XGhjLJrH/irHrsluh/g1CitvZTmyvd+Oe2yO3Iy/kxJZVtlztLPRCI6BG1col4kry56/JTV/R2J4W9pkVaclHmEgVwbVnwTb6c2fPGpzbX2w3uJU9bAjVq7F6hnlDycqne/sI7joCr2Q4fsJzK7kDp36rO4Fbc67Z7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSnlDnrmocEzMHR16bndPmDjBRuDaRg5dDQZidhFj0M=;
 b=E0BJaKlZubmKIEYqmw91AS4FRgKkH2rhb0b6cJ40oU1Y4jlNakvltOXg4JAssdaC44WIVtI9ARI3jfbgO2tZC4J8CdJNuI6zMCDsbt+Rwhn60oFaO6rfRK0uqaxnNVl1AfmnzWR10stV3BaMH+phTgzSpbUu6ZCXPQ5GlbN0+UFUHhTHzXNmzFGiGR1joeLxhsBKFDmPtViCqZbSdkcpBkHL2mg6V0i8qqf423svA0nYzgtyNyxVa0m9oJhxT3v+1PGnLQ0z9ACu7dj+fVbHLFZdNodOkBGOZ+LTNbwkwWMdX4RPYN9RByRrH526tnjVYcCrit46Ssvv5rh07o6Qbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by BY5PR12MB4308.namprd12.prod.outlook.com (2603:10b6:a03:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 09:19:40 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 09:19:40 +0000
Date:   Mon, 5 Sep 2022 18:19:35 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: bonding: Unsync device addresses on
 ndo_stop
Message-ID: <YxW/J+1GX4iN0bfU@d3>
References: <20220902014516.184930-1-bpoirier@nvidia.com>
 <20220902014516.184930-2-bpoirier@nvidia.com>
 <27922.1662143320@famine>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27922.1662143320@famine>
X-ClientProxiedBy: TYWPR01CA0012.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::17) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 284e479b-cb96-40b3-cec8-08da8f1fc2e7
X-MS-TrafficTypeDiagnostic: BY5PR12MB4308:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Svteeuw0JSSoOto5s2+t2NF2kX0l2aRhF9NG42ToWDPMapS9Pf7K9S2DxQlQ1j8Ppv4mO98EPstEdyNG5WLJUE5GnxljfgLwhAt2Sh1wvUG2oIz7inueLUgm0Q4FoBbqO63MfibowR4JUfzr14hvhuiadzVye0fLgtIURKJ9Y66MwOtHBR94x8Z7ukVo7HUbcBWCMwgMJeUJV3gj7qVleRfnxjAaMGgJ7MiG/y2qfty1knWaASLRqqFcppnIAs43ZJOLjmJeJyjkPPKf/FolakNERNVh2gJj1ACz6mFyTWaceNWYfmGLpspv/GJ1RighcU4rJFOmoPeBZsHKWTofjM2GcPGFCAubJwC3JplLsEPap1p6GIfwmQYvb68GxWs+qPDyemMpLEUJ6ZgB4MOrYCJ7McKYOF7ofVEdfWgi4lSvlGp6wkoKuVPW3Up0UojA38vZhoTpz6O5gz7RaMYP1gSk6cwOJ870s6gzaoW/YXcjGtzK7gZzrS3gzf/Vud3C3EA5515ix8mmdlC7pAxrIulTqyEJzSbz/MQWquSnIyKmuGQYK04CxO07Yw+H41sSwqm3VKRoy48Kc1z0DIhPuun+qPuURuz7ScvGiXsboeej3x294i89apXzJWwzEe+OlPbh10PXh+Nmsa2xUTTlo1XYthkIBUeWDqkhX1c5Osinj/YGJ5kLa2V2j7Kk9P4N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(136003)(366004)(346002)(39860400002)(8936002)(2906002)(7416002)(53546011)(41300700001)(33716001)(6506007)(83380400001)(9686003)(26005)(186003)(6512007)(6666004)(5660300002)(86362001)(478600001)(8676002)(4326008)(66476007)(6486002)(66946007)(66556008)(316002)(6916009)(38100700002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UC+7Cmf3emZKdmP9T2hQCs208UAybqiB1Wo4rE9oraE7BeNaRzcXuCeCg3GI?=
 =?us-ascii?Q?/KlHUvCtDMIBW74UqBUY41aoX6Wod5l7i+YrVI9RboDvMXs+WqdN2Dhkbd2Y?=
 =?us-ascii?Q?8pjMbCNV8BcuknKJed76gXnnaqI564VVSkEd6G8FylN9AaeNvkdYP4EdTJGJ?=
 =?us-ascii?Q?wFW/3TY5IzF+C2U3N1bbO6OCT7Jp2kShJ2TCWdDhUc7pbalOYeMJIHeA/Yy9?=
 =?us-ascii?Q?ewyX1vSmhc2BnkSNRKKphD/CAOFtESZoXbFn2KcRKog3zoGu0ra/kB9RWzb7?=
 =?us-ascii?Q?TEpOWT5QbZF+hkEsuBKc059Vw5lDL76qooiRIgx8atju0k1LzPJvktGXOnM2?=
 =?us-ascii?Q?wRxu/sIFkz8XXLZHOd5hz6hURwhgEcxHDLJD87+rSdahOdKB9t7ACk7pMGZW?=
 =?us-ascii?Q?VxxD6ORAFjiPAWc0baGqmKU8HpQ3Ka2tYC61nDq8s+LmCTZw3kMNaOrQsdYW?=
 =?us-ascii?Q?U+W5mWRL3tBClSvEj/pCy39FVuZdYIWmrsaByvEHLWu3dkUbUnHOD/vaJe5E?=
 =?us-ascii?Q?O5i4iKG1So62OdHh5CY80iQL32gg5OIVD2m6sxye5CJDzURdcoDDf/1JdzKA?=
 =?us-ascii?Q?1g1hS8cNWDACP6XXSgMNHM+LKKop2k6N1r0Z8qJokP0ZujaTh8bpNfRckoSE?=
 =?us-ascii?Q?Ye8SjfgdUEb0t+6XzKwb3SSAhV1lP51TX4b9l3drTU6ZPtqItPswV4zl55Zm?=
 =?us-ascii?Q?dZmYaX20mQF3CbR4X+AyGm/2il5yvF1nRuM7kBbD5gMKRHvMalPsQaz1ApGD?=
 =?us-ascii?Q?4VKgN7CdXYW2ZDTQulv+aGS4/2CTkRbpuSgwQIs63E5+7ynstKGOv2z6DeLo?=
 =?us-ascii?Q?fqVQ/ioYgVCx2Q0N0Q16N97azi2F7XMtNFZXfGPPmvFUcHqknU7eSeBo6bmu?=
 =?us-ascii?Q?lMBXOguQGHfzmrv6yXdcile5sK3WisEAArE7NNQmF7VPNpN5++5aexlzaPpX?=
 =?us-ascii?Q?tc/KmM9rYGp66cQdACmfGBagRVB4f0meRJKzjHCIf6A1kvcf/QWqqaHIY+Xa?=
 =?us-ascii?Q?Iwiy4k7VNgIevUzofwOSkPDSCseOG0r29qa+4pvqNKseJejeQdUnEWmip6ad?=
 =?us-ascii?Q?wdmUSDn0wVEza1fDzMAXBn+5IlogPKn4YLf9atsLdyKS0zleGpPDBmVPKTwW?=
 =?us-ascii?Q?9ReExWwUsnBlEnBmvOdncHBIIH7jOYcFt+hHm8IU2VquFJRPFcTxiLi94QGv?=
 =?us-ascii?Q?R2H9hFkI9nKFLDEja2qGvbJU9FGFHyi1ye+aKppJW7Rn1w5zPEPR7nNBTedD?=
 =?us-ascii?Q?ZyK2JSuwoXEfYrN3XeFdG50CCWTY47V8O2hmAvPcO0XWSDDvIq/S4+SO+O3O?=
 =?us-ascii?Q?n91bQjEPYk3PfEI3PS6i4X7yhrD0Skh6ILv5WCXwFWz51m1adRj5ooW5/g8m?=
 =?us-ascii?Q?rfaJ9qn3VlZcHit3GtOmV84p/jp+wahfVhgyUsB3fCM+qH6jkJgZmZSa3AyY?=
 =?us-ascii?Q?OJsRp3dqwSIAG4mYxNAc4eTE04/ZD14WdwS0fTNaVyltC+pYOUTuJkilPCby?=
 =?us-ascii?Q?CQsHYa+1vy4dEM3qU+Hjtjev7+d4udU2nZNxI7khjedyE3wOCQ7pXaGi+gmQ?=
 =?us-ascii?Q?5nQQSqYx2WFxP2uZQD56b6gDfBlKZHljJuyOsY0q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 284e479b-cb96-40b3-cec8-08da8f1fc2e7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 09:19:40.4326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UQLFR56T6grGX+5jjxc2ljY2Pd61mr+JB+s3Dg68Aft2zz5XzIp4PHeqNA/Ok62lUB1r0bvqUW5qrn70iYSMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-02 11:28 -0700, Jay Vosburgh wrote:
> Benjamin Poirier <bpoirier@nvidia.com> wrote:
> 
> 	Repeating a couple of questions that I suspect were missed the
> first time around:

Thanks for repeating, I did miss the other questions, sorry.

[...]
> >@@ -2171,12 +2169,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> > 		dev_uc_sync_multiple(slave_dev, bond_dev);
> > 		netif_addr_unlock_bh(bond_dev);
> > 
> >-		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
> >-			/* add lacpdu mc addr to mc list */
> >-			u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
> >-
> >+		if (BOND_MODE(bond) == BOND_MODE_8023AD)
> > 			dev_mc_add(slave_dev, lacpdu_multicast);
> >-		}
> > 	}
> 
> 	Just to make sure I'm clear (not missing something in the
> churn), the above changes regarding lacpdu_multicast have no functional
> impact, correct?  They appear to move lacpdu_multicast to global scope
> for use in the change just below.

Yes, that's right - no functional impact. I'll split that to a separate
patch to make it clearer.

> > 	bond->slave_cnt++;
> >@@ -4211,6 +4205,9 @@ static int bond_open(struct net_device *bond_dev)
> > 		/* register to receive LACPDUs */
> > 		bond->recv_probe = bond_3ad_lacpdu_recv;
> > 		bond_3ad_initiate_agg_selection(bond, 1);
> >+
> >+		bond_for_each_slave(bond, slave, iter)
> >+			dev_mc_add(slave->dev, lacpdu_multicast);
> > 	}
> 
> 	After this change, am I understanding correctly that both
> bond_enslave() and bond_open() will call dev_mc_add() for
> lacpdu_multicast?  Since dev_mc_add() -> __dev_mc_add() calls
> __hw_addr_add_ex() with sync=false and exclusive=false, could that allow
> us to end up with two references for lacpdu_multicast?

You are correct once again. When enslaving to an up bond (case in the
selftest), it is ok, but when enslaving to a down bond and then setting
it up, there is a double add.

Thanks for the review. I'll send a v3.
