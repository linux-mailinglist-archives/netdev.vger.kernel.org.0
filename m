Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5550E68BD93
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjBFNOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBFNOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:14:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C81715C8A;
        Mon,  6 Feb 2023 05:14:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6qrWkyVkRXEfSJI355YMvj6QKUfVowgu0FitirkJYHVNJZiNTNdmcX57gySjF5XbvRSGqhjm+KlmsZHhmemRnupSThzpSHZiFBcpfpkDGYIbpNFqT5FoUsRRfjLpnIA4fW/CSK7c2BqfEPwBTLGqiyHHkc5wYQuSGC69nTqLwHXplEgwm76lcJ/eYXLxSmjEMm6YzU/vUDfZw1afAAMScOoFghNIbh/Bx2Uqzxjs4QhFhK0uiS1DiSZ9/ok0oXkQFkWsTIT9LiXV3q8019IjC3qyPiHWUSgpafiS3taTVFJFInJ7PVSmdD1m+vL7L2pPxqy/vjJjE2oEYPlSFWnuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCVb2MCW9ACGLt45F4faDfRuz+QD/Q3J00b9Ajq9X/0=;
 b=FaQKDFqtA0EDETSSmF9rV31SwFzdWbmFk6a68DZoKYIPy2nzN9Lv8wvQeGNEyuJVZ2bXoy66FEMpztXKqcOJBASglmMZd1PgmfsPn4zeG0n1bGC4h8iwLWlKFceXDk4TBWDCBZ2Fa3eq2Ru/CBO4arO5QObX3AIKihiMLZGht3VApze0AVlMv03sWmzC+JLJnTbtN0GVct0ZRKV8Vzgml1BZN0zB3v9zYRnzGUc1s/JLDv2JHKAevzaNk85oSix1jmIxAoYFAYSp4gb81PK3ji6bqr6t0rbUur3SO76KotzZrkno50Z30y+cY0dipHAccT/NfC6YdM375HxLCajX+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCVb2MCW9ACGLt45F4faDfRuz+QD/Q3J00b9Ajq9X/0=;
 b=WN3W9culXiSgH8Hi9GEOn2N4O9/VA9C8nSbibbgf9Uh6fHfM5Bj9Yj2qG/8BGJMbr2jOgaMMWtOCYgMXJcSbd47VDwnRi0G4cquOd0ALyNwM7c4iv9gKq1lmgPlzY7B4713jz4fVjT27kWdllX78/rP+1HbRMZbA562ZKAZgHIJZQqeKcdNYSWJyiK460SdPeIMmGPjtxXUt+bG1UUUrZOllqfYRhQSZs1Oe5IpobxA6wpAl9pnICrfQkr2NLwNbhGsej7f9wTAWRmwHanCPbNl4b2202MYZFyqHsBfPm7O1m9eGSRCBpCE3e6IWhFKLwMEKRK1RbTVt9SwPsahGrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4380.namprd12.prod.outlook.com (2603:10b6:303:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 13:14:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 13:14:05 +0000
Date:   Mon, 6 Feb 2023 09:14:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Message-ID: <Y+D9Gkuo1/l0Ty9W@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
 <Y8/wWTOOjyfGBrP0@nvidia.com>
 <87pmawz2ma.fsf@nvidia.com>
 <878rhbflcs.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rhbflcs.fsf@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0341.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4380:EE_
X-MS-Office365-Filtering-Correlation-Id: ca40b878-b154-48d8-979b-08db084405cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNBVoCCCi5jSi4H30z9pXZFC3y4dkGRNyndVAVsZkfJkJbddijMZFYOYxpCHbzVqOF+jC9olmbBAL+XEA4GKcZqi20qJSKlhft8FbDkNPlOZHLHypfnxqK8EzEbigAdRSUWrVblqiSiWdLq0J0VwrRgaTgUhHgAcncOsgAwlhznlIWmHjAAyqbS6FaGQ4MnA945+1++j/wAxiqvPwTB2utoHbHFTpmnwfdoRqPRFOw5FByypiScKYlCH83L8oK5Hf/4KMWn7JLHp8XD4JIwyepiIDYEJkgUtAo1zgQXrVDiCnr6VwywnZcRS76kLHOQKqwY1cECo7ZdiNlc+dJrm3fW1M7y6smBORYXv6MsdZjgSmMbhmFyJX00VOxc/iFDxALg/L5MLHD+k6fOsl6JGXA0kOp+FW23JQ6FSQwoYMZQJ0DNImH4JSZegwfV/ddD9rDlDwTF+ZUZFYUZdS+7GA1nf+8oYtks+nBOEuIQ0+Y7UVUSBdeu0IkB8c4zi+0dcoTIe51ZS8RjQJ4IDuCB6nRJ15xxlMF8vZuA3KGhOzuyxNAq1phSZUBeZu00TT20uMxKSa7OCONqsfY4TrTLEFDQ7ziXLztKG2Mv9zSFO0pEa/baN4ekeii7p1i0li64iBo4Q9b3FQJA241Tzj9lM+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(66946007)(83380400001)(38100700002)(8936002)(66556008)(41300700001)(66476007)(6862004)(4326008)(8676002)(2906002)(7416002)(6506007)(186003)(6512007)(26005)(6666004)(2616005)(6636002)(316002)(37006003)(478600001)(6486002)(36756003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8mHaLS4zGeYb37aoHdj4xT8M3Pb27KE5URaoNqfGsujMlNEE4dIuKiRC50v5?=
 =?us-ascii?Q?GTuaSFWugosaxbdBhHXbthnlDtkInlD8fDH4AOouirzAxtQbxE8TyFW89Brm?=
 =?us-ascii?Q?dDSZq3SLBCKVuud6ad7ivA24MW9ZXtqHbZcsV/t6crfqsqndi8yQZs9N++AX?=
 =?us-ascii?Q?3hv60wlP4dKgMyDR7APYUMeKXDEHWFuhnzHILoqaJK0bTYJ9libCMnM1N3Wb?=
 =?us-ascii?Q?PyJg7iuAFiZZ7fdb68uhtzQ0aIcWhrN5fef75RHRbH+y4TIkcPedTbHXigE5?=
 =?us-ascii?Q?4904/wnxreHBfkOJ4FcpdRZEkDt7PxTwYXN+eOZE4Cg8p6Fxx9FYUicAbCMd?=
 =?us-ascii?Q?HnneB7zUzgDPk+hKBOJEl8fGQ3oBenvho088PduQlnYFP3KVXoTQAeY49Unl?=
 =?us-ascii?Q?dsMclQ7B4GXyDtVfUJGlbs/KprlrXHsqCv+s8QWN4oyv299S1BL4zCguW7hk?=
 =?us-ascii?Q?9XlJqix/HlEu+Or8326rhN6uJrXpgoL1B+38kHeyDjikuXbz1Ew5q0MNUOZ0?=
 =?us-ascii?Q?0YTcePCkPdQ7enRJdHPNLnyTJxS6KG/Q/YxRoN9aehYCz3grtKTvO3SBY0xP?=
 =?us-ascii?Q?qG1B1EhpAUoU/hh5CTFSSYNfbznsWRvSCAz8U1tGVRsiBjBSQfhwm+55XPlt?=
 =?us-ascii?Q?aUYxy73b4sCdsi2LYl2fe5dZE/Aj8xd0Yaow7W6Qt67qty22dVEoa6M5vduw?=
 =?us-ascii?Q?iHV4d8XZBurgDFCs5Nl7ffCrnDM6W0kTihj9LOGP5tAXFWK81k/MVyDsoKrs?=
 =?us-ascii?Q?/X/uUXQNFLjd/fCoMRG7KQsTSvSt0RqNSdgTf2FPaLbMRMSMiesR5xKuDsXy?=
 =?us-ascii?Q?1xakDJ/ZkKKA0tUIG8uf+5zvBLN2IRWjr2MtoGvUCyrGaFxw26nj8q9fi5ud?=
 =?us-ascii?Q?OwZzOigydHXvhjxRXsrqLsMm0Cktwf7ohCzvR7j+dSoaLJ8lMNiwPFJEFUJo?=
 =?us-ascii?Q?Glyo/+JFKbKAJPGwt15IDhYodQGSCGOODpsPxjBfEM1h1ohG6r5fwhTIXABS?=
 =?us-ascii?Q?b7TCjW8XUNft4wsmGfE1VQFoqJOOckC8Qcx1P2TtEyyP+0B0F7x0OcvEQpg1?=
 =?us-ascii?Q?ygceKdM3pfQdBAmXOeldjyH1XViS6w7Ff9DwlRHUMGVce0/oj8d4aC8rVp1C?=
 =?us-ascii?Q?GOpmnvZLnEa8SBVDe6AoYDfizvgWADpIB/CxaYDZyC8dPNS0Yk6rd21rcH7n?=
 =?us-ascii?Q?D7LMbVPvw/txpo4RvA5OwGWla1e4L+pZu0dyVbNmtY7mKUE7WRq8Ot8YzGAF?=
 =?us-ascii?Q?pVQfgspnrU4qb8WYpfplaifOpAGNlnIvnJQQtAqYegjtgBC77qXBab4lQFh8?=
 =?us-ascii?Q?gHnmM46NqbqWWncv093af8xmkQn29KTrU4cF4IEAbnAOUkIigdocxyolm0iN?=
 =?us-ascii?Q?CArjSigb4AaL/0x7QiSu0Y2eh5c+1Nn+0C0130RTiNfmg5nMvVhLEmcTqlKx?=
 =?us-ascii?Q?tXctmsTtXEBQXzMy4Bfj926qfQpimQ7lBSrgcst2KaLtwU957jDWEUCs4w+s?=
 =?us-ascii?Q?2j5oDm60Fr5ClfeV2OcdSBQ1i+YpI+s7Kg2I5WsbHGs3sHdWqPuNbmiPw7zs?=
 =?us-ascii?Q?dHWcAPSUue8KXWjrPVGoG1TwCCGvyJVy0MZgYchB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca40b878-b154-48d8-979b-08db084405cb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 13:14:05.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Zg0nTuywuEszodc7W1RRE1ELc/IUvyF3AqNYnX0bRTZieM6djzHUHIgTKKq76Ls
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4380
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:36:49PM +1100, Alistair Popple wrote:

> >> But then I don't really know how RDS works, Santos?
> >>
> >> Regardless, maybe the vm_account should be stored in the
> >> rds_msg_zcopy_info ?
> >
> > On first glance that looks like a better spot. Thanks for the
> > idea.
> 
> That works fine for RDS but not for skbuff. 

I would definately put the RDS stuff like that..

> We still need a vm_account in the struct sock or somewhere else for
> that. For example in msg_zerocopy_realloc() we only have a struct
> ubuf_info_msgzc available. We can't add a struct vm_account field to
> that because ultimately it is stored in struct sk_buff->ck[] which
> is not large enough to contain ubuf_info_msgzc + vm_account.

Well, AFAICT this is using iov_iter to get the pages and in general
iov_iter - eg as used for O_DIRECT - doesn't charge anything.

If this does somehow allow a userspace to hold pin a page for a long
time then it is already technically wrong because it doesn't use
FOLL_LONGTERM.

Arguably FOLL_LONGTERM should be the key precondition to require
accounting.

So I wonder if it should just be deleted?

Jason
