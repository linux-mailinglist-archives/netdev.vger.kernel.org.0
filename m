Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AAC4AE6B6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 03:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241607AbiBICkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 21:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238188AbiBICjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 21:39:22 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CC4C0612C1;
        Tue,  8 Feb 2022 18:39:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJR8RqZdhNgP6g2S9JNXy6Os9YHxuY4j/4Kv6fdwTkv1o6SnmFjfUILMob+UFzbY477RGoeEMb5H/n+jB/lXLOObndIErlYxSnEWeTwnZOWRce0x99x12Y8uKT6Uktjyu5OAM46xFvjABsQpM70rRF9HsW6fICxGzhI4nkXYoxiOtqzQX81oMnDDWOP2Xw6Jsvx9wwlmpEHihnL4H9MGTPa0IlJf5f8yqhHDxWRz3fwKJVOdxQ/1ZCVvmhZ2C1PYrdgr/QR90PfrKI0ewFFRWQWqYL+SfkgylqId47Tadhv1269bpUPBwTJfymmjbCOiue18CeLczcJS7Ngpbgn0iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIUsMe8Yv7SUafm8LCbXILwkah7adCVu7OEnrx1R0y0=;
 b=NGWHs2R+qqTx3ag6DioqB3x/G8rKsaIOr9o6MNji/6qR7qm1wRuue9gCkPTvmFFdBJNbmO7ZZJYuSTouuY70W+kBcZGQi9AOWjHViTYNir42S0eChdF4ljXtXK1rW84aS9GNCj4rMmZNXIcrd6jgbdCp97Qs4eOLc/CUqy5cu81OLu24ZksI7dr41DEIVHTbr1CR17fXUp64+Ker2wiy5y50MT07qB48OtJF1xvwrVQASTzq4hjFZwHG6eLszGRH1oqVsgRwb6ocvadcsmp+IF5Vi7YjjVrDuEIPwdcOYjHoj0n8KWk5aPgwWM/HaGJFigLXVNIk0ZYIvhfdsVN/hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIUsMe8Yv7SUafm8LCbXILwkah7adCVu7OEnrx1R0y0=;
 b=Rs4uXoyBGZjwAy7BpXfu9iwAaKpJbH/aqnytDgOIQOH2YENz/Qq90BYvLVZ1T5mFLr9L28Wkex6YMi6odT5f+0Aah/X6q4hT37cOf66ms8PNcrNbqeL4o/ziU1nHxh7CyNgidih3FAdMikaire+QogWYNA3QVDRntrIxAuuuTekphKaasqJeVARwwLY1JO8t/2aCpyyfnflM7AIZiR2QylrsBmnSAnyY5qbePXifhVRM9aqClQryQzTbNX8x1sO0EGycseLi3SsluxshG5W89HbIkqGoka/dt1U/MF29Fvn95ttUE9SM7kDStoBLVVQvlWYaluUi9IIeRWiFDMjM6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1704.namprd12.prod.outlook.com (2603:10b6:903:11d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 02:39:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 02:39:19 +0000
Date:   Tue, 8 Feb 2022 22:39:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V7 mlx5-next 14/15] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20220209023918.GO4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-15-yishaih@nvidia.com>
 <20220208170801.39dab353.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208170801.39dab353.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e2ba54b-527c-4f8e-5c16-08d9eb755f47
X-MS-TrafficTypeDiagnostic: CY4PR12MB1704:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1704C9D9EA94AE7A7CF64163C22E9@CY4PR12MB1704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I1iZnmXAOkfjFTPUNLAzLBxBnr6H5Xr6Fal8H8rgo3eVmjId5CXGFFo/wjj7bIOWKJMSOCxA94/aVA++s88Xujz/5iAuaUrPO0zykkT7AD5Ue7GtXjdyRecB6Z0otiIzuICmDnCszX3VGPWqtTQJ5eJ560WZ8x7EacXgA04fYxY0Q596JvPm0Ksy56YYVIFH25tUTqZCB9uWsXRNbNoCabAdlSFCjEL2C+3ffmekK/Wd8rjc1ogfyrYAnG1+WZrFAKgaB7v5W+CpAw+pqnAmbvK7vQ/z5A25Jg0buQdmvAHdvXXUOZfqD+4fiJnUxqedVF/l+kOl9NH0OHpeVz+Vhv2czW7LbnhPZoeV0DlWLsuSYg2J5oZCSqnXXGAz9Cm4Vl92TwdPis5yKwV312QhN7IICpnd60tJF1wktMeM2KFGlZx76i1FxCcXLRgbuWxR3j45wYaP1UQcbvNlwk1yDI40ANVG8bv0B61qLk5shEJmW3RA33lTxjlBWyztHFji50X6b7rOmaQ0hqmR19RTCBRTKtQGqXcx/75xdhaEpAWxicwZuSVkv6c7jKJEkE/Lq+xW2k/xp4XxzL+Oj2S2EQrXY1KW+4B9t2s1tKWbHwFKOOB7jGVCXHTfB1cquU+iSqylP39WweZVoEU/8kBMcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(33656002)(8676002)(8936002)(508600001)(6486002)(26005)(66946007)(186003)(6512007)(316002)(1076003)(2616005)(6506007)(4326008)(66476007)(36756003)(2906002)(86362001)(4744005)(5660300002)(83380400001)(66556008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1zEVp6/1xp+kOG5sxRoFctjCB82kgs1ISSuNKY1euwEWXSGMUhOAmkFcTeEt?=
 =?us-ascii?Q?CM8y7Yl77XpJvwOlJTI0irS+5UqsmSE51KjUir6/1xRwbhWeOKfio2u7OaIS?=
 =?us-ascii?Q?mg6+ysUQcx44iEx/i52C1vuOAHRHVLcrwwYrlU2Nq1Ue2nPHCZwNC5qPqpmh?=
 =?us-ascii?Q?sRsvaxP1tPpqNqNXU3a3TqcMNu1Qfq5jj/XKp0cnLiYZEpQJT9/PVpjAvXjx?=
 =?us-ascii?Q?k1x+7ldOnVhzqk7oqZ0zQZx1oCTNgX8RkKUpVhqOOBv8bj4a+hkDhiGXYJg0?=
 =?us-ascii?Q?bP5uGBq/1x6rgloTb8jR3Vn91TuY5S2nF1OEEWHo9y78vgpAK9AE8tgZLE5g?=
 =?us-ascii?Q?UCxSx5lRtAc78Z/J/U8r7qWk5LahYBrAv8ht29jiHLVtRyV6WaC+ixOOtzL6?=
 =?us-ascii?Q?/qDOn83Q+lMufO/xFUpXoPubLHTqpjRuCgw8RXqxSPq3NneL2vNWzrnF/R04?=
 =?us-ascii?Q?+shxPbjg8QYGnaGsYCr6i1lnZ7/C9sJWjGWCMVRmwkbWJ8w7aeSJxCGNLojg?=
 =?us-ascii?Q?vqxp2pYeJqomug/Twoyj6KS1sCCNuob2pUD1erm3eIVUv9+dM0yGMOj4LDr+?=
 =?us-ascii?Q?3yWB357gHt13yutu+X4e8WSY8L5+0i0FYKw33gaGAq+JBOS/GAltOXJAIY9d?=
 =?us-ascii?Q?IWtZvV5kSWM4422IPFTO3Qoks2vnh5Fz2nKM/6lc9xojTZ+tW56AQvQw/IXq?=
 =?us-ascii?Q?aAEWxoJL0wd9QLOYp+CF+SScXPn+oGL75HW/kg0MicsxrzbTImBPro7rlBoL?=
 =?us-ascii?Q?TMsYuGuMSkueGYpbRMfjHRK6zo/XyPsGwXMSHiOT91/Hzxs7+EPQiZmxSM2n?=
 =?us-ascii?Q?4jp4gGbumChEZahpMZiAh28ge6NOTuODTnRCZSaRRhP+wab9vowq+UF1Y+gc?=
 =?us-ascii?Q?UdaWcq4jaUG5uRhIcaMctcbZOeea1dyiHOJ+oS6r14WnvaE/4fMRI7Mx5oNj?=
 =?us-ascii?Q?Hb4fOSxedzMlyWNb0w1IhcKlmlR0lIqQv2SnL2hd96x9QJ3qgimsFSJtwx1/?=
 =?us-ascii?Q?FkQmyk0rK0PulLhCw5U1esBzz6Zrdd1qs9JYUnsRheH0NkL8RO2jHEVbj85f?=
 =?us-ascii?Q?PDdil1fSaok5QkcfwjLQEsIoxJKVGk/tTsVuPZlNSk9c0ZhWYe/2ETNT2eYB?=
 =?us-ascii?Q?KYcFrjNK2kv+X/ZLh6IFqoS5xdVzLnHITMBo0gxX8YQSDznlYc7T3hXijRnL?=
 =?us-ascii?Q?8bel/NEigICJL9WyRPJ3y3eqE4siUsODWINnoq6TMnX57o+kfn0DDuZsDU+2?=
 =?us-ascii?Q?Xd8Xt+bwn7yfoUAmrT6kMyiv1UWJV8ompcEDycLkonXgf1PK4bql8Q9nW/Z/?=
 =?us-ascii?Q?BPU5NVpV40MyYIqcSWTassWOPYXldTmeqZRuqFQEiUlRp7P3aYd/Etv+3ANI?=
 =?us-ascii?Q?KFQY+1zcSGuyTl5BKBeniFV3MAUECREpgOttyYJLPFxrtoFhsN+/UTy68qet?=
 =?us-ascii?Q?KOgI9w3/aidEaLJkHSB6OTuTVmoy8qUkXqADRVxkaDupJkjAX2JZsrtoH2ME?=
 =?us-ascii?Q?Csw3TRivkV6gZo1cfYrAgkX97m0ucdld9zs44k5exLCD/CusXjhvizfL6sRt?=
 =?us-ascii?Q?UvyVOETmZZc6LWhxMGY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2ba54b-527c-4f8e-5c16-08d9eb755f47
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 02:39:19.3567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCKz4HW4A52f1Ne/3X4en/TkdcK0uoly1WhGJrBYpMuCqqb6mERTxNb3XajQmr7O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1704
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 05:08:01PM -0700, Alex Williamson wrote:
> > @@ -477,10 +499,34 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
> >  
> >  	mutex_lock(&mvdev->state_mutex);
> >  	*curr_state = mvdev->mig_state;
> > -	mutex_unlock(&mvdev->state_mutex);
> > +	mlx5vf_state_mutex_unlock(mvdev);
> >  	return 0;
> 
> I still can't see why it wouldn't be a both fairly trivial to implement
> and a usability improvement if the unlock wrapper returned -EAGAIN on a
> deferred reset so we could avoid returning a stale state to the user
> and a dead fd in the former case.  Thanks,

It simply is not useful - again, we always resolve this race that
should never happen as though the two events happened consecutively,
which is what would normally happen if we could use a simple mutex. We
do not need to add any more complexity to deal with this already
troublesome thing..

Jason
