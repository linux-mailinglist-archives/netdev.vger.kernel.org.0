Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9320357C9EF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 13:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiGULuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 07:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGULum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 07:50:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B46A2A400;
        Thu, 21 Jul 2022 04:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4lnkksOxRFVaMJNrICoQkb3cqCfjrMTHkcTQmfm797h90SzUkdA/w887X2JRrV/IrEdHp8Rd8kpL6mvEudXf3QyWZUCqYgC0gaB0aU0ODkDwvGgLyVAFsS0YXRfo9U1+0/Qwh6OyfqqWFP8N4ukqkiwiI1vLmaV03GWynaWTc3ksWC6NmkbZ6LWvsKEq5A1JEPmT+Xj+bV3/idLmfjKw6XJR4+2Xfht9mPoxLWbra7jsGvOLKuhby2MZsxRe+lPlq1p2DDk0EMXZeqwwcqKluPz6qr+whIqq4CkG29cXGoCmTU97WWDwcGH/tGEqjZftod55MqjTR4CaCkZxIA3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TzOuzfsfDz8jvQl74Es/QYDD6mbPQ51m4iN7k0p1lI=;
 b=hkkpKcAGOewgZp4DMAiaiFSycXYAZZ1z7qAYF/xKeL1lZk0/tZsGh/YQyvdU5u08F+c7c/OamwhK7T9SxrO2zganZLlwNYcOHAt7/lNPa7inQJW2o/xFmv1j8xVEDIm2OAsIrGslxE18XVAB5YvBzsN4Re9AiQkKoe7F/d5aInNZ5DammEQMA9/JlNR2KyFvWkC3ZMzNb8v4xUpGnTWuSzRhJUvfSQqq7EUVs4WbHdpEMyR6XSSWRUS+dp7Rx21G2iW5zrSQuUx2bku+/rZTYnMEgC2MDG/lb7zIpqyKnsJmuW4CLozIoNfmrxW+sgD1+861/riGImQtrPjs4nTeUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TzOuzfsfDz8jvQl74Es/QYDD6mbPQ51m4iN7k0p1lI=;
 b=Zop68F7zAB5v0af/8MqvQG6gK38zHi1Dius/gpAIINFRfoFAlfMA3ZVWoaWB6qSPZs1JrU2HkGfoOGscXVWbfOEySVZv1D3XH2Ajx4LDKtzKomvR3LUlhCbv9/F+soT8VCeTCnDgOJPSxhPb7VJB7W0ZR5n3/QyHuBnERbjVg5nA+P/7TZxed9iALmG+kZCmSgOgQgLbCYVwERdLb47jxfkXRqSgxwC4Yd0mBp3zj0dTeAepAh9pFaAtPodfl0JIcDob+XDFbMtoMdkU/435eskYaxH7JvfaEHzIERK0rI6Pd/+1qSCqjcs03b5tK50AlaKp5qTWyBpEcFk+ww7aGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5187.namprd12.prod.outlook.com (2603:10b6:610:ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 11:50:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 11:50:39 +0000
Date:   Thu, 21 Jul 2022 08:50:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220721115038.GX4609@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
 <20220719200825.GK4609@nvidia.com>
 <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0198.namprd13.prod.outlook.com
 (2603:10b6:208:2be::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a02b6f0d-e2f5-41a3-1ac8-08da6b0f3b45
X-MS-TrafficTypeDiagnostic: CH0PR12MB5187:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zHi9uwqoYrfSwPUYdX6xSxnhQgE4JRsMUscApvwLu4RpiaW2F1RYaUrMfYIYV5rR2JlcGGcD9sllHkaBzVhZ2CsBYgUec1T35NhTeB9xfxO2ksENeiqDDAZDHhCZEv5Et7MtsPlpkA90nsk/E9UnzNcJDqzM3a1NtZcOuy4RU1HyvJrpi7h7WnV58XwqpUrNvFR0T3XwCLbt1RvMDaY/5ytPAFoOTHi5QCC85FlDJzLGJhWrqFA/UyhUFjHBRZEY9e7v1vC76MV2pJJDGcEsgvI20OlbT9o9REGZpqjE2YMgcX8+n3Ltp7TA2ela8DKUOyb/M/6BnkDFyEVaH5WnbJ2TebFfTNcAGIlzOio8eMd+mGzrqkM6KvFYmdZtBNtSY+nzCU72Dfeyp1oXbOd0bV4lbhY9egKrsYPOwTeyUZsZF/P7sxhsUqdjMFgmNY0NoHpXovB7aJSkO5JetuyK9gEBJ8v2Vmw5rUcfZmj3LiJe3k6AXKXbS36FAhJH4qIRrfBQXzt9yrMSpEy1UM2Ed60+ZV9T52oS+PnKEUyIQiDkV39TuJbRZl+XYRrzqcT5VMiBGhnUl8HswcYH0c3Crbv96eC7bmj4ET8iBxrnX5spKIIFc5KlzAHP7/iX8SlguQHWcq05VyRv++G1oqkPgEmcQmFi5B+MaxiFYyXZoytQqG2D987HtFb8f75DwnnnbVPoB4Y3w6XVaiepagkRsFXJ8efARgFgm/dkXNCxNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(54906003)(6862004)(36756003)(4326008)(8676002)(66946007)(66476007)(83380400001)(478600001)(86362001)(8936002)(66556008)(5660300002)(33656002)(26005)(6512007)(41300700001)(38100700002)(186003)(6506007)(316002)(6486002)(2906002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ze+6V9SibxH/ZawesA8spifOmyaHjGKgz5USGVgVUN8VgOxLIof5pE8fzuaJ?=
 =?us-ascii?Q?/AiARFBx+1yPOazYU5Phvw9Oea/of+vARap83mUZT50d7wrE3HqFWq3Z7PXl?=
 =?us-ascii?Q?g6mntXe/uBs0pYzhVDwpz7fIpDL1xaXXibmcVvGctg/WnSYnMVL4kvOZ+qZH?=
 =?us-ascii?Q?tYW3tZcwQpq5PJSXa6HRzuNvMsCWxIyoY2NckL7Z1AwqLB6Wxj5Bl2diY8SO?=
 =?us-ascii?Q?z5yl2FXq+S+XJaYOaY3qKGduoL2C0LLCTPyban4HNHd9Ufxm1QTZY8X1gS8N?=
 =?us-ascii?Q?dS/m7vmpCHELsOY05ANAzkEb4LARXD/WT5uuuOThnZmBBEMgi3ZjZ/CVxM4H?=
 =?us-ascii?Q?rKEbbNWBjReqowCjYrYjOjffro3FkXSYzGLgPgclaLkl/Fp/CfOQF7Ru2Vfc?=
 =?us-ascii?Q?K8+tfQw664nXNF/jtbkTrEcmB6Bj+CD5oZKoB/nGsn+pE2kBX9qGqNo1Q7L7?=
 =?us-ascii?Q?v+mjuJRoXzH8cvVUWnpfVA8NPXVvchy67kqX3kEX194U/MYNlc4IviNQ47tv?=
 =?us-ascii?Q?DYzKHSUTn1SVNGW0jXrythO5YcB5QcZOKA9IGhxg1kN1xYD3keZYKUfugiFL?=
 =?us-ascii?Q?85lbrqxMl8MPA/J4e7lH9tiqyzXJPw1A5964eue2prnOKl9KRL9Gy4pq8iGO?=
 =?us-ascii?Q?8gtdHNJS6NbAxAJ1rygWAbTY8tK6yx/56xqtf71SiVRWqnlysL5eMm79J33w?=
 =?us-ascii?Q?XeWCnSXSATvxucPtO+CrVlDKIiEy5nN1PVL7qi5Irt+rdkPnTB+FZc6pXorX?=
 =?us-ascii?Q?8elvillMC6ygGypAljiS0ktdEwEZXY4NP8mCw010nldlGHHVkvNgltO1weii?=
 =?us-ascii?Q?3vNpGx7a/VgM+jdMQ7q/kFivdmwRC7GK38Nc/ppWUc2uJYLHs5niscKtX+DP?=
 =?us-ascii?Q?RqhNrW+M0tgyBbqta8pgWJIyONCgFATbgJ6WNSCNbOFiDvsFzIiYolT3rgn/?=
 =?us-ascii?Q?EPUyI/qVso33bzYo8x8lXZKNIMOiRJuVaJSvEmH5VK5qE7nd+C7aVLH8c0qx?=
 =?us-ascii?Q?cSG94vhtJmHKjn7m5Krdl7y3RxLCTsHdOEsZgtAEM38GPlfC8ITUQf2gnqhZ?=
 =?us-ascii?Q?2jNJ0Mc19ntpaxhK3fi0WUVtFuqgGRjBrzuvLVACwbgFS4dQQSfN6M3EY3EU?=
 =?us-ascii?Q?RmcIJeDpenrp6mESZ9JHYKM/wpYUOi1n8/5mef0xxfiHuu9gE7DGi7Zb8tjG?=
 =?us-ascii?Q?XrVc1Fy6sYjlkI2hWZHQrZOVuvhhmpE+gAUQRa3pP8Kod9pmkbWNrMgixxG8?=
 =?us-ascii?Q?U+s1wqc9Kkf0eCeeRTE/wgf09KvIw2BQw26E4eCsbn6jNEnwi/MZq+lPBfJ9?=
 =?us-ascii?Q?OoHDocxxbiq8nTXlLem73ySgCOZbdIdTuC5D0jreRTyKThrtdzpsh9z5tY9E?=
 =?us-ascii?Q?p79JJv3k20zKi4rnUB3+TKEztgC3UZ/8TZhImhJoiNPESAFpsYuN0kFj3aFY?=
 =?us-ascii?Q?xShLTDv7GEurahOHJ3dIMqSFxIR2ohc02Z12zpRkVQf+HisqExpNbg6vD//y?=
 =?us-ascii?Q?6Etm/G5flASHEGf3JmY9A1zh0BIYTTOn4yHaS1E9UfQ7dYWIeqMJhG6wNbux?=
 =?us-ascii?Q?xLp6Okjrdom4PcL1KxdXXZt0bE9Oz25pVhModa6W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02b6f0d-e2f5-41a3-1ac8-08da6b0f3b45
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 11:50:39.0662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4CebTF2DbrA0UWurloSYX2TbIXGdDl+wK0N8XNvwoMqFv013gZn/b5ZxaoFeEX1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5187
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 08:54:39AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, July 20, 2022 4:08 AM
> > 
> > On Tue, Jul 19, 2022 at 01:25:14PM -0600, Alex Williamson wrote:
> > 
> > > > We don't really expect user space to hit this limit, the RAM in QEMU is
> > > > divided today to around ~12 ranges as we saw so far in our evaluation.
> > >
> > > There can be far more for vIOMMU use cases or non-QEMU drivers.
> > 
> > Not really, it isn't dynamic so vIOMMU has to decide what it wants to
> > track up front. It would never make sense to track based on what is
> > currently mapped. So it will be some small list, probably a big linear
> > chunk of the IOVA space.
> 
> How would vIOMMU make such decision when the address space 
> is managed by the guest? it is dynamic and could be sparse. I'm
> curious about any example a vIOMMU can use to generate such small
> list. Would it be a single range based on aperture reported from the
> kernel?

Yes. qemu has to select a static aperture at start.

 The entire aperture is best, if that fails

 A smaller aperture and hope the guest doesn't use the whole space, if
 that fails,

 The entire guest physical map and hope the guest is in PT mode

All of these options are small lists.

Any vIOMMU maps that are created outside of what was asked to be
tracked have to be made permanently dirty by qemu.

Jason 
