Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3023F6E2347
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjDNMbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDNMbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:31:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C4B1B3;
        Fri, 14 Apr 2023 05:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qlh3DCDG+tCs73eioeWnWZUV5PtVuemyrknKjcag2+B0qoEVPGUfrAmcDpdwwUt/V5J0b5YZWrBriBn/FnHmgPSzb9+fV+wmha7oC5jmKrftBIxHLjmAgBa+4X5OS9Q+72o7dLRZXK5Y8yIs71x83fewdOhe2PBRgnlIh9T9q7e1EdlhMOe4dr6xAGMdTr4viLJi+ddD649ejFKMStYRDSupR5Z71lUHJJ86sj11fRdN4WJKgKQCin5kwKItuUCcBO0b/2xBmRGcx7bHtGKTIcyhomQuBVp0Ep/zjHEz3C+3Z2pErATum1cprvTA8ltnM+i111VCEhzwxBT9QIpbuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GlahPL+SRFF/dQJ+ZQ9dbEiFFp27DJFpFi4pOv7FD0=;
 b=nlfeA6YYHiDjhok48tHoWgTcr4j4WEYPCYbLAJFf2FVPAO0D6rKtF+J632bjioTwmU4x//hDOXc6LtQt6TJdIRLSObhX7WquJrd1EsTInVOadfGqKVqnC+fLyW1OVj2jFQeEyLZfmWASzXybcP5lBZyCg9Ucmt8rEIQ6sc+OstqxRopGXux/N8GJ9Li2FD14eN6EtCEHIHcj/wTEB7sj9AE9auSbttEcL8dMkv7PeQe2eiIX55H87BwXMMpf8szHx6STrskdbQ7OJT0/cSLyNjsv/I0uhU/Q0OIbXp97UhjLp6bHvsSZZLwmhq45s/6ok4mDq12s8PLtPuP45+Xi5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GlahPL+SRFF/dQJ+ZQ9dbEiFFp27DJFpFi4pOv7FD0=;
 b=CgxFUoHbuIoJlP8dKIwQF1VoILeeP2ukjoH8W/JMKAuDRa+a/rBct8GlYytBQYlCgQ6OEOXR5gyUodTk4SeHjH61nxlSQFrlJMMr1bhEXcjdXmd5gwNx39o76+Y6KPTwUiLNs6MAc+WAO6UfCEdA6DAWCK5ruVjdIzacW8ovPUsmOVW+Dq95wG5tKGMHtmeRyIbg6bn/PVFNJQofMWYXl6usbpLJ2soqo7mjoLGnjbDD/eRHX0suSqAa0ulNb0kK7hi1UyKRi0WDxZTwR/5P3p38eBlLAULfwnlJHu1eRNZXUtZjWz2eqaXyAcShnen0lRmwoBgMtiqmp0ExxbM9og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7494.namprd12.prod.outlook.com (2603:10b6:208:41a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 14 Apr
 2023 12:31:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 12:31:09 +0000
Date:   Fri, 14 Apr 2023 09:31:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
Subject: Re: [PATCH v8 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Message-ID: <ZDlHing2lP2TNUo7@nvidia.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-2-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404190141.57762-2-brett.creeley@amd.com>
X-ClientProxiedBy: SJ0PR13CA0143.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: 56e50a59-c43b-4db6-cd4a-08db3ce4200b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fb2aMLtHdPRe6+e9DFAAoFFbwRMglDnPXXIwCA+rokZ3cMKBZCodZJaVkjxaGLMB9zALllgfb6lRl3X1kzxtCsGjgGkz/Pt+UI1umhxrHKJc7+B+U6xVujfVcAowHioEL/0beirYE/XzgMp47PU2+0sjmdU2JyRfPU85uY4meXElCw0FmZz0lQA6ECfM9ywRgVYT+JLjD5b/pxfrd5Fpx5yTOb5zp6Qx6K6eoeIgpBsQCE3dWw+G6C8BgAXrJ7fG5maCwab7iibEl1tt3p2ytxUU9DaCdfmorlnsWcL680QMAKzLeHiwfdisq8SFmIW5LK7g185KzawahCGJ/i7/fSn7ecdurqeMNzB29rYrhTYlaT2LgzEXaoTfZrj5ajx4OHGrBTAvL0E43nV2h3d1d6q1qZYN9MgWzNpbxQAA/O+BEyK1MDPuW3P2HOGKrlsK668mAMYroQwTfvXkzQ8obNrEgn2tdi+SqZZZMcKwpIRjKGhHnk9SC4eoj583b2paKz2nS/AUttsKzOwX8xu8aVE7Pcemkho3uSz92bT7X87BR0KQ/4tlKnv4OnLmQA1I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199021)(36756003)(41300700001)(316002)(66946007)(8676002)(6916009)(4326008)(478600001)(66556008)(66476007)(6486002)(4744005)(2906002)(8936002)(38100700002)(5660300002)(186003)(6512007)(26005)(6506007)(2616005)(6666004)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/xw7PiqYv5X05RmumyB7/+uAzuxQSlzSBVISwc9Jarw3qi8QkVUgt0chpCJZ?=
 =?us-ascii?Q?cF1McM3eAtVin5CPXK7yFgQgFc8JB1K05nATIBOixqv2iMaMEU8XCN4aKxrO?=
 =?us-ascii?Q?ZIrS89QMXo0WjEt0xI0FOf9I5KrYF59+ktMeudMrnhoM9/ZIaTaFIJApNnRv?=
 =?us-ascii?Q?oII8169gHqa2Lao0Gt90o38YMsllN/fPcp+lt5Xjjfm2WXQTzVX7jwOBdWGG?=
 =?us-ascii?Q?2ZaaY16Ynqfu8eEKXCqnu3pnT/uaItSVgzOSRBrgpja5OhG63RXMgLypD35N?=
 =?us-ascii?Q?d4WRx/3uMZqBtxsnN69Orvs4+2IGw+ZNFiqZ5fOAQHWeXTNkNcua6oRpMjaF?=
 =?us-ascii?Q?ul6bvMdaEZCtSoq2Ktjk2DVoZuBWewvULtzYZxCCz2cZp3LjEm460Tij1z8O?=
 =?us-ascii?Q?IGHilnsGUgkyEwa9KmGNzk7NfGxIlyaL8eELBYVTxDu2kXjPz/tgIli9jeA9?=
 =?us-ascii?Q?fBfzrCNK9kghFh/TmZD9+Bd3sGsDWF2TBLygtd89qNlE7UF3Hj/OsmM0xSVz?=
 =?us-ascii?Q?VJSoHKD5RZOSsKSwcjDG2AFsrWKoVHNsQsd6lvELHIlbuPau3i8PlBi3Iywf?=
 =?us-ascii?Q?Egw7es2EYDyZN07T2vYHFQ6QvPax+WK7PyARVLmMwKUshQj+gZPgyzY0kHdx?=
 =?us-ascii?Q?OP5cyFz/qZerb3575OWhtA6EsQCXwOInhoYc8Nxz+gf9po1OqHrtuQHXvisL?=
 =?us-ascii?Q?+SDI2WZsH3cz9yadqjRnSf7Gns+bKYlaMvwHa7yGTuju4RNjnr4CKLE5QJOz?=
 =?us-ascii?Q?LptbNIdRVC2KGQg34POMgQpA7CM3VtixgOCxdg2OTVpYzypCngZkuCspwZJ+?=
 =?us-ascii?Q?pWskpy3Jmivc7Iy3LUqirdbIauPYAL1H9opJVRbC+CZAVipAjNvvbqGvr1Vq?=
 =?us-ascii?Q?Y/rMc+J0vNDuSVc+74Erq5wK3OCqSWUre8uhbbp1yx93wJ8XVZZJ+rH1ysjo?=
 =?us-ascii?Q?Um8/KudenbkZ6wd98qdCd74lOHeOocyiEoLxJVmJuneh44Aai66vuv2yN7Bw?=
 =?us-ascii?Q?5cWkY0uWwc67txrPqvdFsaZWiMpa2iNw3QfPasEDOearx8ToFbSMwvHGKL+t?=
 =?us-ascii?Q?6H6gIsUCsB2lLNetfZAnZCvdPYVzjRYxwo/EZLvPh9Ems+ShAPsPgJwaHPc3?=
 =?us-ascii?Q?EFhKvhYYDIo1DfaZpt3AYV+szjCMh7nay9SV1HfjzPhq8g+XBWfHnnFMG+Bh?=
 =?us-ascii?Q?4gMQ1hXeVTGAtTBVYIOYXP90Wsi/yNlGmFY+IscMYKWDbnkchQYJ0n0Q1VHQ?=
 =?us-ascii?Q?+0vQ1JIR+GNT+A+fasrDXTS678rKetpQ7OVuPT9/mi6g5MLTVIaLnhSwse60?=
 =?us-ascii?Q?n5YxiBelZMqv46TZE1pRZGVUnk5ac+jRbfZz4oB2PP0BcKunpJLbRyPEG6mw?=
 =?us-ascii?Q?tMoLhLRnBrYG+6OBdj3k0RgGbp8d5ME6IJgJsK8HBSkBR9ZWKRRSnJy9GxrS?=
 =?us-ascii?Q?ogwXQutf88BLhsqZ/a7lKySvU/w1DLkWn7Cwq6UPR1bb10kJ6tsmZDsVV+OC?=
 =?us-ascii?Q?PfYLKpddJFtKvGS1goPYtyaNGbb8NNYHCCQ/f7tYTTF7czbs0p5R9uyV5zL8?=
 =?us-ascii?Q?Qjw28iml7PdIO5Jgl0Rf9CB33oMy41Ga/94zDR2Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e50a59-c43b-4db6-cd4a-08db3ce4200b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:31:09.3024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZkk49vaFhw6TO5it1YORp5fnrWt3NRyxdlGJFeBlDSaGBtaXEcaMqq9Vkt/e9WV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7494
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:01:35PM -0700, Brett Creeley wrote:
> Currently only Mellanox uses the combine_ranges function. The
> new pds_vfio driver also needs this function. So, move it to
> a common location for other vendor drivers to use.
> 
> Also, Simon Horman noticed that RCT ordering was not followed
> for vfio_combin_iova_ranges(), so fix that.
> 
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 48 +------------------------------------
>  drivers/vfio/vfio_main.c    | 47 ++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h        |  3 +++
>  3 files changed, 51 insertions(+), 47 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
