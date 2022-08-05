Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC058ADAF
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbiHEPxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241346AbiHEPvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDA2DEB1;
        Fri,  5 Aug 2022 08:51:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhSA8HYlLsDzctvVmsrYL2bT0gZcdhCOS6RSLtdRsYb2u6l95uIfKqjWZYIDk2vJdhFTnsNdWS4fmL1U/7FRZ6Xc/ga4Bwx0yF4uwuDer1K+fVeNH48kWmL8UdApvpLSrAXUTI6udGi8VJIrjvf28480M2cIWn1RNlz+/k83UQVVYOg5eAt3ki93hp7kenK5l0D/ttZmC1HQr2UUlXoO4n4LqCca82pjPn7/fJhjVmvwVbxFggwaM6/BkKBkQMJUDz2lNByQBQJzwgsQ38i0N6hfRuFNlNxm/t4peGQAx5AtGCJ4XhuwGYBfniLXZWgqRa0b1Da+qNmBIuBGp7XUDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRIWMzXcSf98t5FfeXcXPzZMpP3BIJCzLkiVBroGPaE=;
 b=oORpgfnRvkfFhCmFmBUOKlIXU1u26H0FBpF0hVgwpnfS2sTaNzx/dBe2wah9LdAeVS9daKsKgHPpNyT6vry6o7K1t2t/SNG+lg0FwImdHaAYYyAiktpm5bnTLaMeoML4uid1Gz3ntpwkBzasnQAaqjS9MAk0bPU069NDlKW/zsH8FXyZ+d5TSmUc3IW6+GP5TeGX1w729e/E90KZBuUgZJ3YpzYAuanWx3qNeIlo3ZKpHPRiC941Zr8/YD7MVrlZM8MH+mi2cn7l4ko/eoCeMiR0CEjOqCQFysXcOOVszxUnnJrhgHLKQovxDeGHMHG5LtqiYKhSBY1oj2RoakgcBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRIWMzXcSf98t5FfeXcXPzZMpP3BIJCzLkiVBroGPaE=;
 b=eqaP3DT4ueMm9/Nt4QAomzkoatMCbz5CPA1FQ7v5yfvdRNzwnR0CWoUKt0xoicMrIeF+OXeJXnPYOyqMU1A2BUWQXDhL48gx/pbcEI3Egq2mm1hu0rC6TjBpaP0Y41B3NM8iTyG1Z3O9umywICFDOM2DdBguVpeIWGm8GymuThCyN4Bvf2BMneMxRKQNWmwWpey7Tcz5HKRm/Qxg2BGivOe7+Ige0dqMHhl8jegEfH6dcs5dByR1jPk5QRiDH+xSyMNza8iNv3ihPrriUMx6calu+qKxqjxR8PCk8HXwmMZpHSWY3CMjAiYkV+tOPBxKoq4wl/MeU0jAAz9nCZmQjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0106.namprd12.prod.outlook.com (2603:10b6:4:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Fri, 5 Aug
 2022 15:51:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::1a7:7daa:9230:1372]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::1a7:7daa:9230:1372%7]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 15:51:30 +0000
Date:   Fri, 5 Aug 2022 12:51:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V3 vfio 04/11] vfio: Move vfio.c to vfio_main.c
Message-ID: <Yu08gdx2Py9vAN1n@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
 <20220731125503.142683-5-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220731125503.142683-5-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9210317f-c231-47b9-e04e-08da76fa5d5e
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0106:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/qd567ZoiPgMXewRIJoKLI4ZszBCnJ6qTGjO7jb9pIAE2u8ezP3lrgxD1tH4fgyeemONP+2zreIt+bKawjE4lhvVT9o7D2lcIdr2urdmg3NdO41reHwWK0avNHJVDcj9QokRrs8RHaxOcWY02A90UVwB+4uBXf8BV53QV9kOdgdeW/yZ2D94DvZD9S6ZNwQMm6/6jzRsWVaKgZor8gA1odiU1GJMurAeKN9HECsWpj5B8kNhu0X+CwGdTZi/m2qAu1qJp4Knzirgd+m3tqvfuum+R0hKYxZ6Gctg11zXhQCash0tGWpzW1V3OtNkxYgt7pF9AH5qW37xiwXF6h8mTamzk40KeL5J+O73iCovtH5p0nCQbeLM+n8jKCEiezqYnIUEXj/7nIXUF88wg5gvLiBQxjG5Be9+5BzDz/sXP4NunvJCW43+xjnUvr8rGf+sEuqTmEE1GjbuT/lSAhYCpNepW5cwf2x6zmFAXQnP0Htf4UGF1n4MJoUefgKD6em4aUt0kBWzbPaURkdDldbxvuqvedslWOU8/7IrY9hA1CCaALv2ZD9ExyuE812DDiDQDrW8EzRpAmTZKW+liA5LJk4r9WYgxnCez0rjVZDQhTBzo6iOxwGJV2tnbL8PjVs+X1Q04A/8mRg861DtYHnjJ6XroAdFK9CeeViAx5dBHjPQUJ2dgIJ30UGD+8n8YG0ADbS1hXVjapgC6cSctjbnTLX8j2RQ9XplHb5giYiaxMkvkV9okbLh2LgcCTjNBwIZvuepG5nnmTOk8NZbNzlIZ2R1WPnzOWWY/EtLE5ZIAU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(37006003)(6636002)(2906002)(316002)(66946007)(66476007)(8676002)(38100700002)(4326008)(66556008)(41300700001)(8936002)(6862004)(6506007)(6486002)(478600001)(26005)(6512007)(5660300002)(4744005)(186003)(2616005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MWElNGTURdH2CfMIN8kBDliLC0vL9WYJVWopJz74Aj+kcmTJkDwO5jeXKGk5?=
 =?us-ascii?Q?elOfXi0UDnCarfTVeHxVfAyqEBTh9fzM+PHbrzsOExJXjmIspRdA8lGv86XC?=
 =?us-ascii?Q?Eh5FTBcwwycp5/GnsqZSHApm3Y36ZjuIzw33gB5oHfJ6lmXKibIzzJbG4Yt/?=
 =?us-ascii?Q?W6sG485p1vIRgTsylmXDsBxBHUBy7iqXssvDGkj4bMjrhYAxzuMvqgq5s5US?=
 =?us-ascii?Q?cPgOFTDOf5NKnbqPYXvV0r6fLCfupz9GPiJK+h7tCUG7QaC06AUevk7eIYxy?=
 =?us-ascii?Q?OFzTYNiF2ad4Fx0czls5mQ8vHmgTd227+tdquJFlvUVpvqK17ySsRUsk3mAK?=
 =?us-ascii?Q?uewhbyhDA1FZ7E5fuvYZoLt6oiNXQvpi9E1ykskAJzyYG5B5wZgjTZ6cltrm?=
 =?us-ascii?Q?Eh8+KGq/pKvM2CEnsfUXwU0xX4kCSMQidp9FOqpsNZhY9xCp3o54qc/ZDKHl?=
 =?us-ascii?Q?TYGxcjpj5sxySmeAiU3HLm2zyCHJhp8WIexRoiA0PeZipQ2Zgc+YgTVC2e5k?=
 =?us-ascii?Q?31Y5579FUVnNBKal6ioak8Jxw1eeSSGiN2EnwlVDDAEWm2/QGz6reARipbH0?=
 =?us-ascii?Q?pL3bSvYInLiKlYCgGngxjIFbQlCcLBG24nv4QoyqChpvTEKnwAN2rqeeYGOE?=
 =?us-ascii?Q?O9SqstN6j0PeC3NT5osldpMcs4njgPokGcZ5sFBOJ/LKNexJJN/yRg/NLgBz?=
 =?us-ascii?Q?eyqhN006XrDN+zXvss3QBVe4O2r73wbChadO0/zX5JMaJv83qFWRc/rWgEh6?=
 =?us-ascii?Q?XMOvMhhczAu4xmLZUDteRxLTe4JA+skkAtP+LZoj26Zql/MJ2jPZ6w/xwxMG?=
 =?us-ascii?Q?79fQvfUqSwwbdNJ4LSZvPocz4b7I5OR2Z+4azbPfY93tvDPs5GPN+HT87gr7?=
 =?us-ascii?Q?uM/DWDzS9CHsmBybHgpIddljdKZDwmv83v+TS+ggmWmQDTazEPQhyOgzHCS8?=
 =?us-ascii?Q?e5HbgGoe9aFQvVeNJL/Rl98FByGHrlXHLibCACYtERVUKnmEjm4acWyPYsRA?=
 =?us-ascii?Q?07zbQn/TySEMa1Y3hpV4IWVrfZmKAe89TYN7Vfp0JCTG6AfJvUD9g2IaGizi?=
 =?us-ascii?Q?w//j6ynhsAeCW10381mNARHwx02rlcpPxn9jIE2U/Xcfx/dFbls/SMhtYbSR?=
 =?us-ascii?Q?rilbMBfm1nY/TanFYAYPnMWYNi81BKJOPov1DXC7luosxJCGzZQwv6uHzbha?=
 =?us-ascii?Q?xEu8UScZzkzJEAUXLG3qd8z9KzOKatiHsc49MPA8/W0mRRWkLLGpidncGHjS?=
 =?us-ascii?Q?7XISNm+0YV4ipBL77tcsqBriRPJ3JB6FTdEOFHdMIJB17CtZfU7BRlSlvjde?=
 =?us-ascii?Q?z6TqJf9UOZ9cOoJtMkVkuTnc0LjGfEXaaI4L6qh5RskgeKYXaR2ZJUrp45Lj?=
 =?us-ascii?Q?xJMVNWlWGU2Lz8XB6RLtv3x93p3/h0YA9wbPrL/r3ZOPTro4kQTk0IU5bF+H?=
 =?us-ascii?Q?kxqTFnBibFoXHx8MRREMypReU4WRcrRlGKGo+kj7m1kuuI5IAXqPyy6c+hdj?=
 =?us-ascii?Q?7OsyrkmlkVwbeap1zz2Q56dRVjZ2TSM//Ky3H1HpIdv4cDF7W9lJkT9qMZ6K?=
 =?us-ascii?Q?biwkxgjZqHY/PIMXHsEBtn59qrTQk1PY2n8jj0r5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9210317f-c231-47b9-e04e-08da76fa5d5e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 15:51:30.8152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCE461Avw1zOMZprv88+sOBhLJSsnBKF4CfRfnoOcVF9adSJ1haLF8vDQbhSU2IW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0106
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 31, 2022 at 03:54:56PM +0300, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> If a source file has the same name as a module then kbuild only supports
> a single source file in the module.
> 
> Rename vfio.c to vfio_main.c so that we can have more that one .c file
> in vfio.ko.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> 
> ---
>  drivers/vfio/Makefile                | 2 ++
>  drivers/vfio/{vfio.c => vfio_main.c} | 0
>  2 files changed, 2 insertions(+)
>  rename drivers/vfio/{vfio.c => vfio_main.c} (100%)

Alex, could you grab this patch for the current merge window?

It is a PITA to rebase across, it would be nice to have the rename in
rc1

Thanks,
Jason
