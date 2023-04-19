Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D746E7D97
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjDSPE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDSPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:04:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E801310EB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJR/vjdn2XPmAnGoZNJ/6Vy5rrV82b6gtLhkUlEBXC9dPToJMuG9GDXX7lAwRacdu5tZeC6ePWrluAvKGQSW10ncFHYsMWNqacHizUbtqWdH/JHnT+kNVE9foB0VQkFtZoPDwKGICQ6ZsGRuL37hC7rsK+8pgMQbgmkRqmhXRX53l3rcr8ohSiN4kxcwgxRA354Bu/nI+zQhfAcwvMs9uM36jI8zJeJyU3+XgUe3lWYit4WkjLCaraghdkTZcr1F+Dk+Kq9W44mnYk68+1k6FRLYc+dn5xm+i+0bPGExDoytydRFpnqlVjTjW6i2hsjwkfcq5nKwgpc2neN4toe/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfvsBaIqWwoqOvoXo00aYLq0SVQd4NSeURZBvjDErCc=;
 b=O2j+8HobGrUaYA2k8HrPIC4WMz50a2nKMFEd0F9tOEOvbQrPGtpddpoD9zl8dO7zmp3bBXx2D36sZY1ohLk3MKSzzx+mRJnp6hONLtvjnvLJhe9cD6SqJ5FsCGzb40/agDbO7KzDQrw+P7PJ+lF71mPQjDcZzmQQCf51bqDOgWX3SlXP9WlAs4rRw7YXgqX83cmDr8hQNfYG1UjmNamnFBYqbAZkLOLZcU9tzkzqHGCnqzeMOlrueOV52hvdievI4+QEx/VfgWPHZt/uglMewIzYxRweVnulx2iYYM6eTfZYQwWFu6YUIF+u2jnyuiY5pYBWcp1AEoxnGKV8TBSIAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfvsBaIqWwoqOvoXo00aYLq0SVQd4NSeURZBvjDErCc=;
 b=gGKDHrt49O5Jxk0akclaptH306cBEtbWKExwC7ju5XEn8cF6zVojgXRV7Dck0SR6RyNtuXqAHvJKehDSaSNaanBImpZw8teAfrhVj5ORD0Pjl2cMBJlMfMp/hocU5i+o5LP41GucGZzsmKJ2tHCXKIDXOiBL3ealksMtjLHD61dMZumccDSeNowSRbjqnEMfU7CeHLCb1YYacSHwPLyYGGrLo+GOnra/IpBtHLI09o+bTsXPowQ2K0qCNSt+A/8vjm9apWZKRiFxlxe4RrOLCm6Qs4V8Y+i0SKanc+wEVndEXwmVfoaYTazwds5qE1stKhhFyb8IZRs1rhC1BBcm4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 15:04:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:04:18 +0000
Date:   Wed, 19 Apr 2023 18:04:11 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        roopa@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 0/9] bridge: Add per-{Port, VLAN} neighbor
 suppression
Message-ID: <ZEAC6y6vIL37Gk2Q@shredder>
References: <20230413095830.2182382-1-idosch@nvidia.com>
 <95a773f6-5f88-712e-c494-9414d7090144@blackwall.org>
 <ZD/z2vI5ab0zPdRf@shredder>
 <20230419145124.5z47v2p62nbskqr2@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419145124.5z47v2p62nbskqr2@skbuf>
X-ClientProxiedBy: VI1PR09CA0151.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: d7280bb5-5ca6-450c-ba28-08db40e7596c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGdaj8DTLFQozbrHwrBZRIdDm9hCQW0T1WKs2JA4UgfDy2GkNTdDa02mngew83kLQl1vmWVyVQaGU1cTc9hqxWzr4cPkZwZR6oOtUZtb70MTxdlGLfnRtooCfFJP0alZGBzgp41lLbN+TD4Td7d5O9eTsYYaca0MwWtoHHGP5GE+zxGM3Qp/q7JMeYsDHOn0s0hbEnsJws4xo71LsB924egdwIfvkb9NOh7zKHgKzZ1CG7r/B0UKl8CEDRbsaaX13f+FcTRyJeRaxpkyY7UQwWs4Hr9NpKBYzUwecU3cNVvNjBi+lO+DksB87K2kkTwddncbw7D51jbfI1Sv3zRszoZJEkUwgwFNzJ4C5d7WK76DF3JW2k+VEN+MmWxqYlwkdRtjm4F/MeJ35b8c0ppswVzL+0YlV/ZZg43SP+FeVKffXnR0+JRfcGTcD+ESJaSbOeuF5bKDuvgrMYzmfS3rVGBOXjY0d5F4Z7oEIc71U3QY5zAtHwJMoYunGuGDiEUp8HDkStW8QJeQvW9wfFxW7xmIJ8+ijHx6t5h/h9yJIWSHLumennzQ6WH+ngwLoz9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(66476007)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(41300700001)(6916009)(4326008)(66946007)(66556008)(186003)(107886003)(4744005)(2906002)(6512007)(26005)(9686003)(6506007)(86362001)(33716001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cQIo+TASY86dkVZHVzbfXPfuDux3hEXLyFm9fI8+EHgmcKnMF9fHq+xqNBGf?=
 =?us-ascii?Q?1o/UNgd1FDu2HsEPOQlJFdun4btKx8KmG9AovfPv2qgvTPrp3KKWm33QZ5If?=
 =?us-ascii?Q?JHymFYz6Cd+WNMrumc8kbNHLwZPfNuWgnlGq6J5tf5NsSCsTet+9vGsP5cEm?=
 =?us-ascii?Q?NVJ+sf40JhWvBijsGP22vfXKDojuQ8tH8D26XyyUgqMgrK90HMBjSTgzfdA2?=
 =?us-ascii?Q?jwmIyPMawLIIET/NxRo034DhL6R5vwRmsJXf78218IV8x76/0s1YbHTZ4xlV?=
 =?us-ascii?Q?rxJLBC6fKIZS38EJyUA9owcpqkCb/KKBupRecopDC9UU6bp84l7lj7GcJUF2?=
 =?us-ascii?Q?tdwzUf3kDOhy26iKULDxTuA4JqXeMtIPYwvFRE9PvPN759Vp7ugvFh3H3ArD?=
 =?us-ascii?Q?qMXr69ioxW0VhBSLUf2owOiroV0UImsAvdI5xd++N98dvfJeuydufWZhM7Yf?=
 =?us-ascii?Q?x64XvSnMCrzN8yCyb6hwVCyFnmcxw52aiy5q3N5dCbjETglTqP/wHvM5v1tT?=
 =?us-ascii?Q?PUbHMc1FiLzIw1tO+q+dP5i202lZXDx4GoQ9e0lpEZsp42iyPtuRbNkp9D8q?=
 =?us-ascii?Q?4NpgHOC0mP/lwGvhhphm03Cehj3ddlsSJulJxq9dd8uWfOZKu0wuROXUuA9M?=
 =?us-ascii?Q?EglIQTr1Pu0A89Nipv1igKbem0ZMKuF9mEoUqNVCu3HasDWPcQuM2LaQSWzr?=
 =?us-ascii?Q?gMrFKGEX7eSfMhaI56rUfwFTVDft3OahEUVecu6Wx2JMCcBFOLBnqKJHhzgC?=
 =?us-ascii?Q?POZgA1vGYYiUOyzNQdUiRGVa7vHUpr3GAkrEoSqJPGBxZibD4VYwjuhLR3Ih?=
 =?us-ascii?Q?iuKi97+j3AnVUsT9peDJo3szDqudCHjRzcXb4YgpS9vnA8Uk4XcWty5nAiz3?=
 =?us-ascii?Q?TY+beb4ikLx8MojPm5nOU/3fQA3LjgFhhjp6YYMqT5qRaVoM7BJUbIOvrPsL?=
 =?us-ascii?Q?YWlca8ZrLBw9QkeT9RFCyA4Me5L+XSZSsR5yAzVXnGHYytaOG2z0kEt800BJ?=
 =?us-ascii?Q?5dNMwrCMP7dSJGSVQjoecpfZCUNv0KSDJ3s+2DNvTHQeffe1QUgZ7rBPAsGo?=
 =?us-ascii?Q?ZgGUUTwaxGcKFmbqaTmRLV4p3EEHlcjKcHGXiPTqO3k5YYhrUPQICWKTurzb?=
 =?us-ascii?Q?iasV+CVCBHCNoFNGuHdpx5pCouLP1ZUqFmUY8iSFBVPZInDdLHdMmvGdWhnq?=
 =?us-ascii?Q?DgxEXz6YftEtLZoN+yAEaKRbs8F7V8o/c0Gy0yhAoQ67yFUeT8XDwMrqMfdi?=
 =?us-ascii?Q?SKaVTWpXAzd5vcMQxM4Jx8czltG9VhWwhRAWldCEjrb5lca3JOVvZYIFaz7r?=
 =?us-ascii?Q?S0vDyWL1M+j4qCLTiLPShCzj8ljNMeKuf1K3IEzoZncHzxrhFhIuKMNzWZBe?=
 =?us-ascii?Q?M/S88/JRVgL1TD1/mFdgj6dDcZM1eHbOCCYFm4dP9zmo1m13vkgFg2OcbKvD?=
 =?us-ascii?Q?GcZpRw1M/vACvozDOgWCAwVT1sTSXJDkrhBS7p6b8kGeOVUx2LESV856w75f?=
 =?us-ascii?Q?hJjzVXzXyooZzmCBJKDaZqYpH2XzwsH93q81XP3kxZLYB1aW31jxGVhtmfZ/?=
 =?us-ascii?Q?zQdj4shKGdPJ35nUDeeDZJXf2KH4beMKJFIdPGs8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7280bb5-5ca6-450c-ba28-08db40e7596c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:04:18.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gUzBXHyuta7U/F/z+aSKuE8Pm/hJkGIImhG1XA/LCKGQPVCnUMTSXZ1IGF2zoO8oG/ujnlK/o4EEJhGBslhPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 05:51:24PM +0300, Vladimir Oltean wrote:
> On Wed, Apr 19, 2023 at 04:59:54PM +0300, Ido Schimmel wrote:
> > On Wed, Apr 19, 2023 at 03:30:07PM +0300, Nikolay Aleksandrov wrote:
> > > For the set:
> > > Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> > 
> > Thanks! Will rebase, retest and submit v1
> 
> Shouldn't the version numbers be independent of the RFC/PATCH
> designation (and thus this would be a v2)? I know I was extremely
> confused when I had to review a series by Colin Foster which jumped back
> and forth between PATCH v6, RFC v3, PATCH v7, etc.

Makes sense. Will mark it v2
