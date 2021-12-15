Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FB94758E5
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242528AbhLOMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:32:02 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:34656
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242501AbhLOMcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 07:32:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtGYndl4LY9Owuc3FNM6oLMTKM2rH1ojBKe1f5NBdf4DhdRZrYmrotcTSpQYVpL9XDdhLcKlguuqrVS9CtEkQ8a6XiC15tG2tQZXjmHohToaLgG02szmK0nCHK7bb26ebzdPvqtRPk1GuMwVs5lOk4e1i/EsCmBPqBjsi4aikRwzma8mXvtYBWVjL1e9mggbqKjx4fVZLIX37znnDdQAMaBSqMmFuE/qA8GPgw6b+bCLBrbEBbfZkQjWL7JxhnSEdqPU8KxvbcC+av3ZvXI5VbSI7v6cBpBfd09+etPvalSjtcVbJc2o6ZdFFUqiDTD+RvShi4vJHAgQO+WzhUzM4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnejhOx3Xiqg4CkDnajxKdF1zrplMLUZTiQmrkwbwPc=;
 b=jK0SgUlbB2Bw95+EZ9IDob6uz97aUHsQiDGvVGklRJZ0ImFkUyce8dtNIiI8Yg1lDiItQ7zgGvGobIzv7Yi9l+v+mULIIj/qHR8mCrcOCvZ92/93gn5d8xD4F7fqJmeAvEsaP5u1ujNLJf4/vMWMEsWi2kj5VXLXTOtxH4IYk4aG/kddU2/eBDSzB+OjZkqKNQhTTb+lSO7AIH/W2jkIl0l2rUUIowARMPqwXcJXUf10Fpn+fHFbGbyn/8YiMNcvFNGkupG58rCNfKP84RWU3Lrxk4xiIbzDln288kXHe5qXjh3cfyl3BsJMN9BnT92UKYfgZDY0lfa1mcE0NxntQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnejhOx3Xiqg4CkDnajxKdF1zrplMLUZTiQmrkwbwPc=;
 b=jOSjpBJYBFW7aWlF3rDR9vZAlGUPLnSFS5Gi41PZGagMbe6E7koBA2Q0urPOV5WT2BZws2QPKjrWpvRzKlNdFfJtyHgtEOaLJcr2lWk3hE7q9N+hHAWDIp1teypHGpFlJ5+ywFlDpPVS1cyPdNVVAUbO4nZEZSgGo/jJhQLwIBMUjWLyPK0XcaDLulwW88P0XA1waqm6r03ZDtUcB0FBmJqSLMQhkPC3yfwounKGy2mvq8+IV64olD2L9VQEUREIrLSfzObUbw/oKMjni3a7W9J9USDVJRoH7uPFqIWasMdqmpGeC+xq1aaxusuQMsRH+jdaEJXsu91LZL/VZUq4+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 12:31:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%8]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 12:31:59 +0000
Date:   Wed, 15 Dec 2021 08:31:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/4] Add support to multiple RDMA priorities
 for FDB rules
Message-ID: <20211215123157.GT6385@nvidia.com>
References: <20211201193621.9129-1-saeed@kernel.org>
 <20211207185849.GA119105@nvidia.com>
 <6559a3845b34fcfd75f1b7ecd08ad5e0508a9fe5.camel@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6559a3845b34fcfd75f1b7ecd08ad5e0508a9fe5.camel@nvidia.com>
X-ClientProxiedBy: CH2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:610:5a::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0437ecf2-ec13-468d-024a-08d9bfc6e34f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB514305BB5D63154003C395C6C2769@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Id6IsRIHpp5FMbUkXBeo3nnAqIMD8Hrxw9acaGVOFz7B7i5y1jfrec4nthq6lp9DomHWWTBT0zguKdLW6REtIKxpxK7EChE40EPfC9dt238GbptmqfCyINTPUIq4woqmq2RbAdFJBCAjjaugGaC1PP2bZlOpB+98g7KalVeFYDPckEzUXUvgO33mIo0zhsO6KCT7KmugM9D3DokkLoRncdPHYWyNkmyRorR2I334eC65bnA4n5Dleq/YQp9VmDtCYwi54oOdrluyswXOLjn/X9F/IPcoEnXI6nSq+iOOZGHWXKTMvwwP62YNX9Z1ECvwvYOhR7cFpwcpLrV1fc2102DCqOfLXnZfuJQsFFbcA3b+Cun4zUaE+VBMnXmx6RYa7p5Sm8SubgBTd/bZE/4oW0C0RnpbzgWau+JZ7c/Tb4w1R0T/6ME+qpKZgryEkMHm+wGbAdnaAz22Res4Ps+WfsRb1CqSVwP4AUN6W+lZxBTXURpQ1n2DKDuhSgnfzeUPyiLHSwOY/MtpLhD2tS+JE58W7URMjReXqVtd199ea79nxTgGQ5VfwqxXqwGtZIVt/M792RVWDuLvnLKI/DK5G1MG3mbMZXzdC5foyYM+pEcGIXvkfWDroNSVssWFQs9+iygVN6484LHuBuoLXYFG/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(508600001)(6862004)(6486002)(316002)(8676002)(1076003)(6506007)(2906002)(4326008)(37006003)(66946007)(66556008)(66476007)(2616005)(33656002)(6512007)(36756003)(6636002)(86362001)(54906003)(83380400001)(38100700002)(26005)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXdBS29oaDFPT3B1b25DK0dzT1pmc2FsUjNPSEFSSmNZY1l2YWkrTFdac2Vi?=
 =?utf-8?B?cXAvMmU2K0pub2x3SWFjcVJmNGM3d241bExlMXJpZkJjcVhURElIZnh6eUp5?=
 =?utf-8?B?ZHpwdVhVdnViSWU5bG9TTlV0SFkweEZObTVLL1lxeEZJQ1NENDI4Ym9PQnI4?=
 =?utf-8?B?OEowUUM3ajk1bVAxTWQvVGl5ZVBXQmw5YmZNVy9UM3R0eFRkUDFlTFN2c2M5?=
 =?utf-8?B?VWxFeXlmK3Nlb3FXTXpNL2FOeldnY2RjaWl3MWZrbnJvZUVhdWtRQ0NNV29a?=
 =?utf-8?B?UlJaQmFFelUrejhkNXQySDZoNURZRXRHTHlXTjFTMkU3dUt5cVRxclFVVC9n?=
 =?utf-8?B?Mm9EN3JZSmw4WUYwSDVpdDdES3ZYU1d3UUZjUkRTMzBvOFRZREpjN2pVNVAx?=
 =?utf-8?B?QThvaXBvODZJM2JhdWF5eXpQKzlSK0xMTFBPeUQ0V3d1K3ZSOHl4UVJ6cjJ4?=
 =?utf-8?B?d1hJeUJmRWRrdXVYRzRtL0F6Ti9sZEk1K0RLS2FLUmkwMEVCVTFMT3NnTlpN?=
 =?utf-8?B?ckp5d1ljZ2dyWUU1VCtJTktNUUwzZW9qaGQ0azUzRSsyMTV6QXVTODBhT1Zv?=
 =?utf-8?B?QnVXYWcrcGdaelE3WXBoYXVweU5HZWc1SURZOTBMeHp5K1V1TTVzN2FvbjR0?=
 =?utf-8?B?cS8wVEdXS2lVWENMcjRBQXkwZ1FVV251dE5ZdUNza3g1MUVjSkpQVWZneGhh?=
 =?utf-8?B?NWdJck9NMVkwNnozSjZoamZVZDhXZEwxTytUL2Q3aWd3VVNBS0FreWVsd0lq?=
 =?utf-8?B?ajUzRkh4NmJqZTcrQnJPNGpNMmc5L055aEpYbFdpMmV5YjRIN3BjbVVpcDh3?=
 =?utf-8?B?R0l1NmtiajhSNDlnK1djdmZuWVRTMnJOc1FqVjFKdkJoZW5zMUlOQ0VHMitL?=
 =?utf-8?B?ZTBVbFBUVUo2dGFHUmJRMk94U3E5Mk9vUGpyRm8yYTJDRXZwYlNQcG12c2tF?=
 =?utf-8?B?VjRTNnNnYWdQWWxpbTBjOEx4RXFYTEZuQjZHd05WN2VaNHcrTVF6YVJBYjdy?=
 =?utf-8?B?aEZpTXdKVXJkQm5iaWJwRjFNRGxmeGdXUk1hYnhPWVBVWlV3REs3bnhVZVRC?=
 =?utf-8?B?Q0plUlJnUVlBWGdpRFhiNWgwWnUzSlFWQXJpOUpxVTR6bzI3SzJocnhRbWp1?=
 =?utf-8?B?K29OaGJxbDFFL2F1YmJWcnpGVmYrNU13WFNvM0hMdFdZRTVHRklma2lPYU5O?=
 =?utf-8?B?T1pVamxXcHM1R0syMjA4cmVsdllHSnZpOFlBZFd5cy9KVnB0MmVZMXl4b1Iv?=
 =?utf-8?B?aXNGY2xhYjRSWmw5NW5PWmpyck5DUmRGUjVBaXZHc2JtaUJZUWs3WHNSRURw?=
 =?utf-8?B?QUx5MEtMMEFkUzB2OUtCRndIZElwU1N6bElOSDlDSDZjV3A4NWRvdFBGN1FT?=
 =?utf-8?B?aFplRk1YZ2VjMjhPZVJGdnI4akpzUG5uV2FpWW5JaWwzeFhyMG1ta1pzVDdo?=
 =?utf-8?B?T1g3VjZoek1yYTJkQ2p3MEY2VEk5UFNnVWZIMzl2TFNIY1lMdnh3OEx1OGdh?=
 =?utf-8?B?anFGOFJGREdJZFk1SStydUg4YjdMa2htbEpIOUFrdnU0Syt2SWZmSVlkcjBp?=
 =?utf-8?B?ZjFxVXdKbzVoUExRb0MzZVlwS2pnVWFzQjlrUmlVOEN3enlaUW1HTWJwM2pT?=
 =?utf-8?B?bUFQMlloMkY4TDVRTkNNaGc4QnhXS2FpVGthMjB2MEU1bkZkVm81L00zS1po?=
 =?utf-8?B?Z2huNHVXUFF4U2ZzTHQyWEJsdERDUlZlTDg4SlFxQVpCMzlhR3daeTFEejUx?=
 =?utf-8?B?VXh1TGRmQnNxMURpb2g0Mjk1TDVFZS9MMkpSbW1ubTMrNWdSL0NBZXZSY01Y?=
 =?utf-8?B?OVlZLzM5VGhIcVArSENjUy9FRkljYm9CTDgzcWVwVXFtNFg1em9xRDFuek1W?=
 =?utf-8?B?cTVwNXhaeTczRnQyV1ZrTlNaeXgwTEFxVS90dnhueVMxaUVYOW84SG44SzJn?=
 =?utf-8?B?QUcydnZlYVRrUVF1N1lFbW1wbmZyK01iSHpRbXJHOGlwRGh3NHhCWUI3d3NO?=
 =?utf-8?B?cHdCVmQzLzZ3c04vQnVRTk41RXJYNTJpVkhuNG95ekVrbWtLMFdVaVo2N2lw?=
 =?utf-8?B?TUlPZ0hDbmoxekd1enMvNFAvcUdJZ2FlSEtERFJpdG9EOGtkdDJvODhGZVcz?=
 =?utf-8?Q?Lyac=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0437ecf2-ec13-468d-024a-08d9bfc6e34f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 12:31:58.8920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pnAOEMAQPQMYRLNQSNPWsIoauuh/CJ7sy7+EcpqnBXXl8OPYuOITY+A1h7sCaWz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 12:04:09AM +0000, Saeed Mahameed wrote:
> On Tue, 2021-12-07 at 14:58 -0400, Jason Gunthorpe wrote:
> > On Wed, Dec 01, 2021 at 11:36:17AM -0800, Saeed Mahameed wrote:
> > > From: Saeed Mahameed <saeedm@nvidia.com>
> > > 
> > > Currently, the driver ignores the user's priority for flow steering
> > > rules in FDB namespace. Change it and create the rule in the right
> > > priority.
> > > 
> > > It will allow to create FDB steering rules in up to 16 different
> > > priorities.
> > > 
> > > Maor Gottlieb (4):
> > >   net/mlx5: Separate FDB namespace
> > >   net/mlx5: Refactor mlx5_get_flow_namespace
> > >   net/mlx5: Create more priorities for FDB bypass namespace
> > >   RDMA/mlx5: Add support to multiple priorities for FDB rules
> > > 
> > >  drivers/infiniband/hw/mlx5/fs.c               | 18 ++---
> > >  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 +-
> > >  .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +-
> > >  .../net/ethernet/mellanox/mlx5/core/fs_core.c | 76
> > > +++++++++++++++----
> > >  include/linux/mlx5/fs.h                       |  1 +
> > >  5 files changed, 75 insertions(+), 27 deletions(-)
> > 
> > Did you want this to go to the rdma tree? If so it seems fine, please
> > update the shared branch
> > 
> 
> Yes, applied.

Okay, pulled, thanks

Jason
