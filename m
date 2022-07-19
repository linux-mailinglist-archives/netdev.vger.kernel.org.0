Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6457A805
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiGSUIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiGSUI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:08:28 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2063.outbound.protection.outlook.com [40.107.95.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320812656C;
        Tue, 19 Jul 2022 13:08:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtMsL3vCyXbHqJdb8IHRg+pn6S7udq+TFaehgyLW5GdzvQBT5paI6Wg3DD4swfPKFw6K11RD6lwO+BZ+lviCKUqvtOa+s5kl3FRCYUa9wiTmTUHTKoUv6NddmJ7dgUmACYerxM0DLfjED3qWlorlXBfmTFtixqYUzkOfS3juScqZm6/X269NbFRBVNolSBw8yqP8nyj312A30MYZBq0tAnRnXqr4wE+ZOGNgSIL5FKWkDJ5ph1RmVN/nwWRg/1eWOUWoZ7Yon2jmI4C33TfD9hIpqOtfgLCnkV06fhGdGlb/3yempFjfqXRS6Yg94UaxGAimRNSBeS0i9Mv6CEvKag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/We8H5/O7oST0RBWJtwBLZUriaO+WXGX+LP/M0Kiz4=;
 b=Y7W8ort4yRWnTvV1PTZvOUw5es/JONXgivG5f64iGkPt7GZ7b2t6O9oNmU6ovBgp7AJJ0SYG5E1//wfF0Se/QNZlXTtmMGYK3DaG1beX+9DhuKBxeiXFG6g/W1G/CiwVvOdbXJz7xC/TGAJpElYcSmYYJdmhK/Gh6dd+fIK5mcFDkyreHqPgbSaQfGFfhfRpKYPg+pFM2zBoTVBh56NbsTeoNPZDMAe1I9OSvtvKsygudpFnaOMdZ50xlwQcOL77HmrQiRxFySXannIsYd/1+bDd3jDEPndGjJQtuSpk9VwKqF/4rTsG3aeW6wnVB2c5zWhZQr5buiuqzV8JVru2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/We8H5/O7oST0RBWJtwBLZUriaO+WXGX+LP/M0Kiz4=;
 b=K8c17U41/YNe37DV6xEMpJ174Qa7jph3G+d7xcaBEkJqWGvz68z295hesEVBHEu/WItU0igeAGzqr++UM2M4z/7GWIM6VzWeC4tl3BMlzhfQGKX98+bc1rwSZz5kN6m/3YmzhlHqFvqmi03ub2SvlS4wrXlLHiPX0+FkkvcTaTG6qStz3GtldkJasCo0mR8Ba+jjpTNcMHOGRxV1B7U19QXV6cNFBEG/kJ3IYpNQOy8dVRCnxddW9awcHLwoxlxnTu5o7Jt3k2iss0E8/B5oeyxjPZu6S/Z2ok9NQp87xldXOWMjIaAmXLk2v+lYVioUQeD8uftUUGeUki88e7J5uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3972.namprd12.prod.outlook.com (2603:10b6:a03:1a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 20:08:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 20:08:26 +0000
Date:   Tue, 19 Jul 2022 17:08:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220719200825.GK4609@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719132514.7d21dfaf.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0015.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5813c21-916d-4ef8-7736-08da69c27094
X-MS-TrafficTypeDiagnostic: BY5PR12MB3972:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A4Up01t5jC1qPHLb5VMM/9LsnVK/lkgULn9vYXS7w7E8gllFhtzztHlR1JyYT3Z91c+jZ9OVeyKGCT4eb7Nf05N4U5q1IIjlYCS7k8cVBSi2PL/KKYMGs1NYQTJoeRfpIDW5OPGEziYRw3whi0Xy6Ba6RBAqO7eSWdIQ7VQ5HdMtlDvDEiq0q2iUgduO/eIDHHWy1nAmP5xIfTUS62rROfK3HpSrJ2YG8hxRbTKVh04+theHaoVaB7Kl6r+Ven6LaUtV+dUY7XqwTojXJbLotDwgPrYl5uamIq1fg3AaTrmPaAsYfHdx2SlTtvzMAFSTL2KRyMKa6tm+7uMlpiWgz6tYMCdTL7sOKCcZmWTf2eILcqkkDTWeIai2RitG2mBE6Y7QSc5VglBbh7zp2g1khh1axFKM24WRVX/m71u34FbKrJH49WQrb/MD9tTvZmR80utdcI99puxYf2zc3x6ldDtiNGYJWIzwdntO3K6+jsm6WYtoPt99sfWpB+Kh2nFD97Vu42K4ViuLvF+u7auDh1DNM6HkIsvT+TrLojgHNaWDoxdv9qYAhQuKPETevFziSzGNGj9Zwt5807CPtC/MATCvRsScFSi4PCmDP+f8odDtbDjHm1gQ7U9Lp0gaDao8uvaIG4lp75gAE5LhJp7/fdbGDlnio2h2Lc9NsTDwmfl2lxYhLKNrFI1iDbJja1HIQcN89sytOsFG5/2DmDokb21SJX9H6xmvWV9OPyKBzNPV72MiNSu+7TA4UPcYDj+Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(8936002)(66476007)(5660300002)(8676002)(66946007)(4326008)(66556008)(2906002)(33656002)(36756003)(86362001)(38100700002)(6486002)(478600001)(2616005)(6916009)(186003)(6512007)(1076003)(316002)(83380400001)(41300700001)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pWwv7KmjaeodJKSi417xp9lLAI1ibw/AQOPkoJhN9gjuXSqIkNsWaTqA3Omv?=
 =?us-ascii?Q?uBViLI0oEKYbO7ba4EPSulut7J07GKI1JKqv3spBH3zD2rM1GH5ifzAFbHpn?=
 =?us-ascii?Q?DiO07tVH0nhxRs6ySgP/UnkfDIUY+wEFxjF3W10whOF9zcS8rSJdRtwfA3ah?=
 =?us-ascii?Q?+qLVH7ZsIeeMa4/hx3iJaK52yoSySBbyqpkivBxwTka2LcOidl3q1926xJCU?=
 =?us-ascii?Q?8fJAaMeiUhTvDoaHNN4axUWn08b6sJJKWh1CZ/WIpEjthjZB2746n8GHfGYb?=
 =?us-ascii?Q?Bhx603prxhXiQ/jPBJItnlsLG94TwtgtJdbj648ePc+LFMYVu6D7PJdKsGQ5?=
 =?us-ascii?Q?8wMcAt/7BR7uvwEVQA8Go4ptA+NHb8GNq+0ThB3/sFp5eMbjM/19mfZDr+MF?=
 =?us-ascii?Q?WnmjabiAybgfS5iO7lSRd9+oUDks9f5a6Q+OuhQNS2LXkQV1LeqpI69CAq4n?=
 =?us-ascii?Q?xbXPaF7x8Z4SgodLv2+nYtnsS+rHd3XaGHGOthjvuuayg4llSf78ATBHVDXH?=
 =?us-ascii?Q?Qac2NViHsZrONYeRf/i+UfjRNjS4yXuydFf467ZELKLKg2mayJ6Pn09i18Nh?=
 =?us-ascii?Q?jEW4lBSUFQ3yt/FJUApXDqMSx7HpXTld2B/4Bg1K8EL4VtWggddoJx9m4lPh?=
 =?us-ascii?Q?6kWP4DwRpKJmyyGFb8bBhEaeftP28whEVwjgQQOi9galHejgO5oERidIl7sA?=
 =?us-ascii?Q?5KVO7G14Vsx13GWvOztZz2KXNMIwA5nojwhtc4kG9yWPqA12+BREbGMwwOk8?=
 =?us-ascii?Q?8ckdDt00I9QX+A5IWLvLVLJ9tj1iiUCsxTe68jX1lCH6jIqCi8qSkEoUOls0?=
 =?us-ascii?Q?tGEnlmSVj85327fJzZWjmycwIBvJx5eC6J+R8z8W/9R/cbI76AypLWVbif4a?=
 =?us-ascii?Q?d4sz7o6O7bZX3V6CLBRnDjiP16bkxLjIDL5l0hABnyxbg0DTrrwGgGtGiNzM?=
 =?us-ascii?Q?dPgjLX0yXhEcaR+aTSXc5k5v7paWu1rb8GQdM2qLncVJPU08Qd7h0e1/RmDM?=
 =?us-ascii?Q?n+4n8RtAh3x7GWEjbTSErnHZ87Fl2SF19GbJ3Bgh7XSWhufECQVaGxNwJPW4?=
 =?us-ascii?Q?fXVJmttK7diJoBz2EoG4pQ0JaKl/R78U9AvL3FiJMj0F31Xn07pZdvItXlTT?=
 =?us-ascii?Q?PBhWyMC6LvByoE9gsfXLKQI5684RL178Aq/9mRNHNF+1NDgBXWhOOzUEoikB?=
 =?us-ascii?Q?8PCNsAgju8smto2SszDNC4gLTiAWNqLhWudaEBY+2SwMTtvs8IS8wu1ktwKV?=
 =?us-ascii?Q?Jr/qZcw92Pfq8Op2fMbEj4lYmcL4CefnzbgJiAE6Jy4jgrxZGBsWmjXaNI1D?=
 =?us-ascii?Q?8Z1k34kexyilUke/xZdYM82SLZ+lNa0do5/o/7EvGJJN8WZD2VQLjSi8R+vb?=
 =?us-ascii?Q?Swuy7EXGRCqW41w6HPt+Av5XBCyc7Xpe2Ft4H/Fb//Or0CUd0E7b9WXL4FVG?=
 =?us-ascii?Q?Sz9kbgTks9pARrj5ZVEqb7Sbom1I29FCE+SmcErJPNCmXdAOwCiVcJCyt01s?=
 =?us-ascii?Q?g8+tJKDgtH6eKDx97tlMEkYZnoCQBfcprxcUpXXSFASrOia6ugjmm2U2MrLN?=
 =?us-ascii?Q?8xcMU/bmvfVE7Rs76naIxj215d70e8zHlEpqvJY6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5813c21-916d-4ef8-7736-08da69c27094
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 20:08:26.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LlExHgp7TDLoJxtFaTdgSWsXnM1BSmzsuZCELXJwpD6B89lEIOTFKmyEgSI6n3R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3972
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 01:25:14PM -0600, Alex Williamson wrote:

> > We don't really expect user space to hit this limit, the RAM in QEMU is 
> > divided today to around ~12 ranges as we saw so far in our evaluation.
> 
> There can be far more for vIOMMU use cases or non-QEMU drivers.

Not really, it isn't dynamic so vIOMMU has to decide what it wants to
track up front. It would never make sense to track based on what is
currently mapped. So it will be some small list, probably a big linear
chunk of the IOVA space.

No idea why non-qemu cases would need to be so different?

> We're looking at a very narrow use case with implicit assumptions about
> the behavior of the user driver.  Some of those assumptions need to be
> exposed via the uAPI so that userspace can make reasonable choices.

I think we need to see a clear use case for more than a few 10's of
ranges before we complicate things. I don't see one. If one does crop
up someday it is easy to add a new query, or some other behavior.

Remember, the devices can't handle huge numbers of ranges anyhow, so
any userspace should not be designed to have more than a few tens in
the first place.

Jason
