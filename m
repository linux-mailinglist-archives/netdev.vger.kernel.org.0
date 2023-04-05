Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B68B6D8391
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjDEQWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbjDEQWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:22:16 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2106.outbound.protection.outlook.com [40.107.100.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1216E9D;
        Wed,  5 Apr 2023 09:22:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPIzq5ntO//O2c+l3BQrsPo1C5s9eF6Cy1yyGbmfAvaXRTD5VIPbRovlPf1mwraAgq4ze1rKYXBMxjQN2cQt7zpqkYJ8AZqvhwKjMGzUoGMTmCzUuJ8CFdJdavqrwYRou5KTr34lMz8zCxzImKYKL4OJALUIp82DLxO5QcGtoxb+4tjbmkonKAK3m/ILmyL4lBJFWfDExwEaiMk30pRz9fU4WWEFtXvDHVU3J1n7z4eaFbXqN87nDQyefwC6GMHR1k4v+f9NOyRsjZsJLlvI9gorITFbjvyY1qUZO3fpbHS+x4ZyHkzik6d/Qpc2p5dSvzwnMMdtiC5XEXgUj/ha+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqgbOkPttW3kdtDUs3zhRZfoVxXWwNFZ2C7/dzfh35o=;
 b=Eth9n0FG5/eJqkuxoa90WHdJYjHnIVKP0gfWH0+gHtcv+WyWevIpKFzfq4dQIYrHTtPB4y0e3xtOFzSmkQcJM/Fj1SSVk/YQANbMX35bHHp57MQ7kfsZ5ygon7MkkZwj9azRWuGc2TjCzu+AZXy+Cvdo9pUbctQkv+vbq/Wm0kFwUejqKu5PWUyJK2F5xq7Z9y9uA97RzF7f5aAkos++BgXdeFajo+WzYid2XJE5s6u3fmM8zs9Z0QLziC307VtXbpVOJpZQDHqbEyDoapbeuXHETF8dg/tTZrf65uvVO8W1+Fx+CsW5hYy3BDHNmZtdmdKJ2EqEkrS/IS1jNPhXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqgbOkPttW3kdtDUs3zhRZfoVxXWwNFZ2C7/dzfh35o=;
 b=Yk+elDHbhcOrHTzellkq6PdL+9KlQ5ltJQuIdAvvkQsln8nH/KVriwTDgGP2LrpzMpWaZ4zHzviEtN2aQoTbB3HoF2vaWqEyf1gbtx6IZDzQElfEgPMqd+Sa+H34yhG0a0DVrDd/9O+qwta8dLRIBT66ckdR6aoLK7unp2rpZWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4583.namprd13.prod.outlook.com (2603:10b6:408:12f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 16:22:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 16:22:03 +0000
Date:   Wed, 5 Apr 2023 18:21:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove macro FILL_SEG
Message-ID: <ZC2gJdUA6zGOjX4P@corigine.com>
References: <20230405150627.GA227254@sumitra.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405150627.GA227254@sumitra.com>
X-ClientProxiedBy: AM0PR01CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: 62d7cc77-dbf2-4f96-b11e-08db35f1e425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQQuTCabyBgpk8sSFmeLCMrn8bVwfiqsHxMY5hLSeKIcHCJLT0oL5EDEGxQYrIOI8OrEifbIU56GDe2k4kCi3tnJkR9dFkenNGmD2dnTszMfI7Tbi/0wL41MoIxY6aDL12xXRJ2io6GvzIGQ1I2Uq3MtP/xUw0O1KyTY3ONNrw2t1Nv2/Y3xD6kkCG35OsmZkxL4RQJndzOrF3r7GN6OmsC44OqK6Xq5tIJb19w77L7OXNm6m9MbPuXhqzWuH4NZDjbSMdotNIZ1UvMdBe0eU7F6bBr6aTgUxsypx2k+DalgZxy//CgCJgiqdEHyBfgv5Cw2vcPmMHQl9nlLjLwgvvvLaohuKIDsQSLMLVXvn+p+LKMyZezZbhry7JC3WeDDI+9LOACyQeBwhyFj2ooxxYmivTpA25OEC+zO4V/sxzv96+SjmSZ4riDNyIa8RBBMu8juq32PN0HPsdnPoAWTGobQtc68E2pONclzdSW866U+mWJjDfONreaMqZ9xuSmr7Ll43u0yhVmTemnp/eNsSosePvtsizqHYYcwnTqrB80H1OBKMQAL2ZSzM9GoqlRWQZsF4xjW+hW/3BprXUr9ZNmuWBLCGXlTxWwCTmhloeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(396003)(346002)(376002)(451199021)(38100700002)(36756003)(5660300002)(44832011)(8936002)(66946007)(66556008)(41300700001)(8676002)(86362001)(66476007)(4744005)(6916009)(4326008)(2906002)(2616005)(83380400001)(54906003)(478600001)(6506007)(6512007)(316002)(6486002)(6666004)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1oZZqzDolxnjw5e+ZqmIQLqvEyV7DtnVff8KW3h7d7pelRF33W+80mJYWHJ?=
 =?us-ascii?Q?Bi4BSTyRsNjoj0bcSFyi/OpU6rsij+UE6WKqaoRBtAMUmVHH3Ft6Cxu2lvx1?=
 =?us-ascii?Q?NDuTx9MY2/OVG2B6VdmGNx2d14O5Xjc8rKgT0Ktj6izonicODnPGdAoMoImw?=
 =?us-ascii?Q?agPhAZvAt+gNPiZuKYomQmql+JXsFJ9AF0Es7R/nVyPur1LTR2yh7pKwpb81?=
 =?us-ascii?Q?XhFNDGSdNKd7iurYSYsybjncLm1IfdD1N29VTl3WYPqMvgEnQWDAV5MncYck?=
 =?us-ascii?Q?4kx/YxZYLfrjBWjxxIKomqGth+Gh+6aO9YP5Az7JyHsqHaiN4Uu9RZ/s12V1?=
 =?us-ascii?Q?Z2pWtIjlxY5a5fuIirW+U+fo76QcRDqZA7L3eqIJdktdT8PvpqRI46wYv9iX?=
 =?us-ascii?Q?i061tpra4ShKbgYKw6sozwKUFuzDJdW3qJBF0PQdry28T12CQeCTNtrGoXDQ?=
 =?us-ascii?Q?J4YVEBgjTnh8d1umN3JkWrE7Hp1bTUGepn12P60NxZGmqNCMd1W+n8xH2Mfl?=
 =?us-ascii?Q?yblsmC+lTJnc860vgmhTHEb/cdOu5hVs2Oc9bWe8GfEmR/YpqA4usBQBS0di?=
 =?us-ascii?Q?Njq8zB5GhEhaHAJ9U5cGsD9/rFPBxpNF9KKahcJTfDoip1Kqvrd271N08+Z4?=
 =?us-ascii?Q?27HIQ5RggPnZdBmyi4T3N9gNcAh+TUnMiZYAydl66fNexSwYy8R1cR2rGKAC?=
 =?us-ascii?Q?TTzZ6ujLjKFG5Khnxvs7MMxB98xRc5jTr/zQYQ60WOh9hzJbsn1zmHYmxlGa?=
 =?us-ascii?Q?gAo1qhddbqdPvUZPLl9PC7BibBLfTRJyimCIGWLE3bKEuTBspfCneLtDbCBZ?=
 =?us-ascii?Q?s2SWe1a9bqtaF/duB3RdKKZq9kGySYPV2r0bKXw3DpkUs+QgFpwySPhhTA/5?=
 =?us-ascii?Q?nOl8MmvE1eknV0HAaMEC7h2fWr1iYkYyExN/jVkC3MyYUjmeJ9ZG/ESZxieb?=
 =?us-ascii?Q?REc2Qea89PWJT3TNIWRI2iE3OoLMYrDdUeUvo/8Rnq+RubdjzOIxAItijQEA?=
 =?us-ascii?Q?C+/S/9K8sS3HHssFDTpQfGXpCjAQa1ZtecZcAFad1PDYk4QsMa4IFn+01rZX?=
 =?us-ascii?Q?iqkkks8j4aBasEKqE/B0wKK6Iwt4zHE0eVNRpQ7kGN1wZ0Ch2eaP33wqIAFq?=
 =?us-ascii?Q?024Huphin+BJj7LxKm7V5RFLVWZbxvS3vWSo1INASZrS1b9DTjzL+cWgHzA1?=
 =?us-ascii?Q?5be4Q6DPQ6UWqI1dezJv4eNGbo6uFKoZK6zCG77xCc+TKp/jqinXo+9jSamq?=
 =?us-ascii?Q?wloKs7z1knrx33jXPh1Gw69TSACfNYBN5p9vWhCMexsHLa/5cyvJ2asaTHwt?=
 =?us-ascii?Q?ERUdL6xTofj6Vncu41NfVrmISTBsz3DmYbgCJC+8Pf3ZjKd97bMh9N3VD6vN?=
 =?us-ascii?Q?wqsc69yLmFHy1Byl7pGhqdaKd0zYlRGWlE6u4YNQ53HWtdQpmPRSMPk2hGWN?=
 =?us-ascii?Q?y98nmPQHOWxzyCFmSjpmmrUN3fGl+A7/KVyQu5brCmIv/N/hyvxzxpSbDZTo?=
 =?us-ascii?Q?8o0+mROtkP5tSdzAOcmXAUCex7uwfjHqdkMDPDGoHjzJmd30dsNMU33iwxzd?=
 =?us-ascii?Q?jNlE9hrEyRjbHjf0dPzWyy7Z7mnjTEa78lw07T2bZgjSdQWTkIMiYHJewdlT?=
 =?us-ascii?Q?ZPFVOoyiZyjdevPOpRfLaguSaYKUlT1S+vn7rjdAQwIuK9mWDFDJCtMIrWGv?=
 =?us-ascii?Q?V0w5NA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d7cc77-dbf2-4f96-b11e-08db35f1e425
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:22:03.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXJ3DYvH5/pvT2VP5kVPUE4qyvrq37qiTVW4/PX5zbLzjTbxFnz7ulI1HiPZam/AagtPuNsqXAVuRR8phiXB16AWh4kUHDKJDSEEKtrII0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4583
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 08:06:27AM -0700, Sumitra Sharma wrote:
> Remove macro FILL_SEG to fix the checkpatch warning:
> 
> WARNING: Macros with flow control statements should be avoided
> 
> Macros with flow control statements must be avoided as they
> break the flow of the calling function and make it harder to
> test the code.
> 
> Replace all FILL_SEG() macro calls with:
> 
> err = err || qlge_fill_seg_(...);

Perhaps I'm missing the point here.
But won't this lead to err always either being true or false (1 or 0).
Rather than the current arrangement where err can be
either 0 or a negative error value, such as -EINVAL.

...
