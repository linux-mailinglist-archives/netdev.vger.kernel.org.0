Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9E5679BFF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjAXOea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjAXOe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:34:29 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2065.outbound.protection.outlook.com [40.107.101.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAEF2680;
        Tue, 24 Jan 2023 06:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsNDUO9CXOEugGVYlr5zi6RkWebAFy6m6nL5+52IYu11ANPp7zzKNbbdaPy3d+xC389pFysmcg1mZrxUbFuI92IG6nwbRIGhw1+HMKa2NyAro6WlknGsz2RhDFZsuI5uTTuxPdqxQIa1et0Cwmue0hTrux9gHNTQyS7hfPOYQ4T6+YFGLJ49hGUmID74yWa41z+zAQVB+eg/E6CLAfu3dlVDG87RMCf+3pYQ/uFGveygto6tq81x+G3iix3Qy8HUWGY6qIGcRgfrXFCwi4wQ7SWQOl1IeblbjTU6Er8cXjtLYSfqct2olu49jJ6/8IQiJRA+SKfqxmJaE6oPEY5f4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Nb+m5UlpQ87pZNKMXBesdYeexw+krH9tx/p0ltBTvk=;
 b=ewuPBKkzuQX1v/lwbRwJ/QGqAqUjyH9dIMed3Gv+ctgAk10QzndJkrIuucW3X2CcicWt1aTJL6BByM3Krc0syD+KRGfj4Av6e9kjobQQ1+4TEe2rzR356SxYUtKbUzyTfErJkWMn50hpdLKg/2Rgh0amGnzts/Toiu+3TlKi8ITBPaaPjPkkUDou1J6+BAjSf8sbkS8QMrnnaqku+96Erlh9xhKHVYxZqJ97XQjqdq6Wt9Ld6EctOeF6cmXPXGh4v59KoMZ1aOJ7Cw3TiiY7ljz9cyd/ymfNAW2m4aK2lIKDsx4akyeYxIPfBji6Y+Mlb9yTp/WKAfL413qZAAam1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Nb+m5UlpQ87pZNKMXBesdYeexw+krH9tx/p0ltBTvk=;
 b=lHs1gCWG920Ac22lyz/4Js9V94UGYXmQxq0/otZeFUi0RdT8SRFnDbZdyZCGWetWNd9zPNwO7rDcG5CivFK28G2jtF1Gfrt+wnqZKS3imqZXEJSPtZn7ccA6ItgrFwL27QhfHjA+6fDxLjqF9pK8tIjWTz0VsknkJpzWTtwby5Yc7DMTp11lVHRlkoiNb8eSTpwpzOqgTSlEpvhJVluZXOXErCGlAwpEbvv4ALAB9RZGYXHAjE7vqsn/DZjb024ieBrqdlceqfQf54Nv3zyS7oyv0NLnMv8TcJX3S8pKNCLeVb++xtpLf3F5nc36ResQRv21nHNCIvu53EfbrRVJnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5194.namprd12.prod.outlook.com (2603:10b6:408:11b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 14:34:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:34:25 +0000
Date:   Tue, 24 Jan 2023 10:34:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Message-ID: <Y8/scE3jhEQ+d69C@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:208:329::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b97d29c-831d-4dab-3716-08dafe18178a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8b/eY0vGTIk76GJIX4KF3OUPcwXIBclQTsyqdF6I273JrSUbLvgjZgDwMPJbW6AjvKVte7cgcs/gTk5gDNNpQgCMJRjLxmv9PFIhY9JIXg2PQXe/oLt+mSS6vBfPzdaCvOcOAxAP3+1NqpeDt05i13H/rxFB0hnm221GDNw4oYIy5muBriuM6F7IiI890k7s/uEF5ZCkNIK8PSwR+PJ02l5h1PcAYA6icVW9aVfX0cvsf102RaUSc99QfYSdJ1KTrdtg4C6R95e9PUmoJpjNB2tU9DRm5tlIo9OhE417RVqs54DQQ7voujx86tl+NHpiZXuAJ2qbGX9rjFHnTINcpt+R8/wxJ6HQmcWSwcC/bmFafjY5bJci/R5DrwN0QkABdu6u/WS3XShaa82IQL1TaTppz8c2psy2My2CFQdlRYQTE8yDEd9QciIlFu6iwURjtYGsp7zedvhZcMPE9IXsZEmph6LjFlj3O9Lnb5dSqnSL0359r+VKlt6iIwV3clDjNTn01Qg+Gfy1+cA35pls6jRfskawHegR/rPzgY4SHlRdKLZcdxPILVvZj+87Us6LbQAmcGENi8zVIX6jGaWJzgz6b4PPG0s0BUnZgZHqd+yy7ayz6MnKF0cpGV+kyhBg4EipQmBot8dQ8HfsoVw0WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(86362001)(2906002)(4744005)(478600001)(8676002)(41300700001)(6512007)(66556008)(186003)(2616005)(66476007)(4326008)(66946007)(6486002)(54906003)(6506007)(37006003)(6862004)(5660300002)(38100700002)(8936002)(316002)(6636002)(7416002)(83380400001)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kf1c/3Ps6YU59bxM1o3hWp8xLGKU6VRy79nGLg3P6Ee0gauqmJsjapCmDdnl?=
 =?us-ascii?Q?JXr0H1Vx/nUdWMoOssnbcJ6WMXoXqAP4ycip+tBxhLNEZkJm9xlOjObkoYcq?=
 =?us-ascii?Q?eJNQjd0sioyyE7hv4alPdr38VSbonmURw3przwvuZ5yKzXkc4ao8CvtdqQwb?=
 =?us-ascii?Q?ck0JXxB8pLk3B9MHcku5pAzv42DU+u+IABqaEncqvNwp9YrKErIpGwNOQ2Bz?=
 =?us-ascii?Q?gQ3u71XTtZXtSZ6E7C2kWyDDG8MHWxI71ZpWkxQhxS+g7C0RpzHq4Jui1NhK?=
 =?us-ascii?Q?GNJTjT2okg69hk6YhhaIRp0iCKdZZaD5Zx57p4V+XurJ9T2uEF8gq4NKF1Kg?=
 =?us-ascii?Q?cj2vWPcvpA7sphjOFut8qWqm3dGdkdnY6lIvXPTEPrk2ld4Vx0qG2L0XKuVE?=
 =?us-ascii?Q?FSYmmh8ZtR0YapyTgBQZOcaaC3uiuMFIskjN28zGraMgP8ub5DNNEM+9j18F?=
 =?us-ascii?Q?ZiAnPP4HsAU4L+JrqsV98xAtR9KQa+7yuZsEy/+dfKqPfs8F40iGNWO5U1ti?=
 =?us-ascii?Q?Mg0qAk+bgmjyX4Bbh/Uei4iWdS93ANgQC2z+Sha3Kqp+cuxtcjEvd8/VeV2F?=
 =?us-ascii?Q?0d9W01KQ0rrXH7WKlBagDK+AAN7+J9SFw1Yq08K3DKELPvFAuADCvx3tqhNL?=
 =?us-ascii?Q?Fi0KUoA3XG+3UMA2BEmJ7I5s068Jghfy+A9wrB583ubteyOERHLzVYl+6JjX?=
 =?us-ascii?Q?d3lsOMU+rU6VSWLNTD7VgEyZ7g0QXjH9Rw6LStiDnsMvOIqLKnJhbqUxqm/L?=
 =?us-ascii?Q?hq5XD1M/OT9onRx//gLe+pISSz3Tn6L24aS9HcJKe+7En8/j06xnRFtRrox/?=
 =?us-ascii?Q?DCQNqa2+ecEKVfL4QY8S3KURoLcfUKsaosoQ9LljMRJ6L1NH7daBeqkuvwpS?=
 =?us-ascii?Q?UzKzc3eb8+IxPB7EMVWiz7sI6CY2w3+8CAv91NT2usxwUa2H5uVYZaNMnyRz?=
 =?us-ascii?Q?x21LoTjyctpJZaSAFZ9CPWfUidbfEZJU+MzJzJVAmEbK5hcmtkoJ8qZ2fl1J?=
 =?us-ascii?Q?TASdAlU70w7q2OrT4Nw0ms/YkJFlX0x9KmObz+XnMi4YV86bBBE7GwCO6omE?=
 =?us-ascii?Q?UgDQ6M18Yl+6lxg0HU8mUxCYGHfRumVe0ooeAMLLkhUKbGPRS31tbeUOj7Ri?=
 =?us-ascii?Q?3fkgNtDNtWUIsSZF0zUHHBlu07N8qHijh8J/R7qf56vVmuLVEn3qbecN5ice?=
 =?us-ascii?Q?2mEKPsvGZDG1q0P4PXGCY7xNfaRRBOGtpIlUwm0Ol4mO1SSnmIt7YVbQmWU7?=
 =?us-ascii?Q?l0FzdXJnr20YaiCSF7LgDrdDDJ/2o1ZN81EqZaxxdrijg0sNH/ZBM5c3HN+k?=
 =?us-ascii?Q?pFLkfHwXpIpv3nfm7SAgLZxuG0BKt5L58mNNvQ2urrCAEkLufisqRlLMFcCm?=
 =?us-ascii?Q?Kwx+G89IjIPPK6aPn+ybLgEpjKlSqCaWj2Z7+n2GYluWsWuT1dx7B0RjIp0B?=
 =?us-ascii?Q?FWnEP58E0NBWLJuaWglMF08l0asPGX1wxM9rwv1yKXd0hUl9YTG0xlhoBxgj?=
 =?us-ascii?Q?Os4LxytujWrz46Ew335MlNPYFlpwC7ZwWugS+CxpppnsPiD2EQslmoNKe30z?=
 =?us-ascii?Q?p5QFMwMM9s+j7dhx9A2ThfZcdsaXhC9nsrtPMmys?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b97d29c-831d-4dab-3716-08dafe18178a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:34:25.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vg6saZF9PaAW9bpjOQs6gXgwtFnz52+SInkvfU7NgHW/zuNMvJ6w+GcRKIbp4BKY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5194
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:31PM +1100, Alistair Popple wrote:

> @@ -799,9 +803,6 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  		return r;
>  	}
>  
> -	if (!vdpa->use_va)
> -		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);

Mention in the commit message this fixes a "bug" where vhost didn't
respect the limits

Jason
