Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1643B0CA0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhFVSOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:14:51 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:25889
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230146AbhFVSOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKvL+jPnDoXNMXEXbHQVtSPu1FMPz90MVoZS3xK7abMS2EdJPaLXp5pfjW1BcR/+arr9u+Kk2Eoq03vND2P+yKHK8OjoLr09wZ4JRo6XJ8oAPancNnB/bYliiOoKNdB5JYHDVi5NWOnIxNxHw4kdSwvjtbm1fVbcpekyXjO1dc9IC+ecumKIVrfHc651kpYPyBNoK7oB9RPIWhwnir8x058kmVNfqD2k6uvqzqOyK42x+QMdD7f8Aze2+QPzU1sh55NYpm0VixLeg0WqB9/0KQLu3OxcIijagTPAQjRHSmSUCNyec0IrQZO1KX2G3R2fG2pkh8fRJAqfsYz2jhWg3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9Mn5Ntd1Xi50Rb26fOJXSKWgVOe6FnlcWsrTWtJucs=;
 b=f1a+8oKdz6jf3RNSqTn3cH++iSz1LeKICbInlyQJMCmpwdljFDtzibjx4re17zUN7QwnBnWmtXrycVJx4mZnu8wY0Qshbl08xl716n/5liprNCnm80wKjQgnOtCoKnK6br1aWx9N4Apvfy32JrrsuD3jA90oQZ0gokaRxKa7gnR8fz4OclHebtHzYhO751FfBtOWjpWRStF+HwG3D0poBh6I0aeNYj1Zo6zcOVJDuyv/+Kk2kgYK+CEo8Au5mOVW/38VpapTjo0v3NE1qv+Lcmk1GTqKaoOWkSs6CAlS+kHgr8NFw092YtEqqp2iSTO+B/UwgF10L4tNKh40onNS7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9Mn5Ntd1Xi50Rb26fOJXSKWgVOe6FnlcWsrTWtJucs=;
 b=KQZus1G5HENbXJgm+YM1NRb5KqrUVVzIbKDHhJEKdYCWFnocp18wL3m1QQUAsq/bCZ5qlP8/XAw+cKs/MaKlsrBa0lDICpC4unTJoQ2C209uqMzJtiHQoM04lwW/zqeSXasou987ebkuI48oW7grs9mHAoTNFsiiO3/Y+VuvCh02wUyuvMvbsTJCqxJjIL8mC7vOzt5XRuy2Eqq5IpbZh558RphWmNpRHDHX1wA8Y2P4EZ1Gh6FLxLbv16z7+rsB8wmEbxnllZC4JRRI3mhdRybAmE1u9+G3JO9WTwMP+Rz5yHoJ9OryLLgVnANDwJ7qx7br44KJSE2uhTCdoChltg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 22 Jun
 2021 18:12:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.018; Tue, 22 Jun 2021
 18:12:32 +0000
Date:   Tue, 22 Jun 2021 15:12:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Provide already supported real-time
 timestamp
Message-ID: <20210622181231.GG2371267@nvidia.com>
References: <cover.1623829775.git.leonro@nvidia.com>
 <20210621233734.GA2363796@nvidia.com>
 <YNGGP3KMwYJ5lFz5@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNGGP3KMwYJ5lFz5@unreal>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0420.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0420.namprd13.prod.outlook.com (2603:10b6:208:2c2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Tue, 22 Jun 2021 18:12:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lvksx-00AdGd-NO; Tue, 22 Jun 2021 15:12:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ecdc905-06b1-48e0-52d6-08d935a94e02
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50616B432F1F570487E0BF34C2099@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJTAsKztRxrgLK9CjI6IQXbg2fzRs/JW2BhLuyu5Z3xcEEiHFjyZqg+IWdOGByu26lLTpY5PysCaH3I9DL1vpMkh8X/X3eZ4Brq53R7bZJj5N2TpwYyW2GvwfDTdnciKRt63KuSKwtZig1EZoshJKWrudHd7Pkna9uINg5X5ghc0AxNwO9PRDYDIVLlO+X2HneEYR3oPlnbjDBTfK2WT5ryfrRZaEvfTTMJGz++1/Zn9JH9gqj8hqc+UrVkGldYK8CFYkbeVhF8Ujfv6Tj3vuAp2zf8FbbHYs59roSs14RnB1c37XUEdLMm1sxwxZ3L0xffx+8B3hAKcvk7x6KlhoHV2lityRIB5a55qL7D5dfxsBneGYXSagr3MfugML68PMaFo41h8fr6AFSfZuoxtqexf72T3s4YYvalEBoUspxELuLnMrTk+W6WQP8ZxxSV+enN8sop5FfplHYkWXBsLmnNole5xAZlVgrxWhmjm/3L1HqJ0fbMscmWPhVYp9+AyGt9mqK4PLMUqoj02HjqSHJGnQzF3d6aR4w0PUB4ZtARXnuMMtT+dBkMdfOTGY6ldTcwaMx7aV3p96sezx7HC7fFRqni/MT+nHJD9iMtTkCI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(1076003)(86362001)(426003)(2616005)(33656002)(107886003)(4744005)(9786002)(316002)(4326008)(5660300002)(9746002)(54906003)(8936002)(8676002)(66476007)(36756003)(83380400001)(2906002)(26005)(186003)(38100700002)(66556008)(6916009)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8fRy4yKO5Wgun+LXr0E64ok79EIq/sKMH8WWTyEitWHlTaigMClH5God0OeJ?=
 =?us-ascii?Q?v5qtJLCGbUo6DdM4OMg2pAxsIfUGcxQqFfaZ3fIcSJUlCSrAW2q0zMQViEOo?=
 =?us-ascii?Q?y9a7GduwLQzuej1H9QCUmJdO9euBM8xouQnrfRVxEl0QdV6UZCA9m1CXlEKi?=
 =?us-ascii?Q?MsakiZKWS3Y7zIIHBihtXjrxQ7T/vgVMCdCuCd4myeMlMHOzsDH/5nchsTOE?=
 =?us-ascii?Q?E8aRGKAYczZdeY+sN/O9MKb6TXkyYEFFp+JyXIcVor6Fym6yVXR5bxbXOvuX?=
 =?us-ascii?Q?YRwzlOkXw/Vey7doIipxJX5w2D0wjnR8J0zcI0P0x6hw1TEIRq2RPDMYayVn?=
 =?us-ascii?Q?cG9b6Nv07zamsq8N8f+h0bqCtGEGPQUqZbTfRI3YxaK4k+H2wklBz96b4VY8?=
 =?us-ascii?Q?aZiU5ZM/qNOL6dvPX/ofYAH5vbDsv+hVveAzVnqL5zJ6uJK8BrSdJvEbpuPt?=
 =?us-ascii?Q?/Zn98vI6D/sC9Px7nMWdpoJZE1LjHUPGhi7a/7XbMF4OBkHEIUox+hBky3Iv?=
 =?us-ascii?Q?PHfRQ3kTxdVKs4L1524ry6nz/7uTCv09iYcgLloxRDxy6OWq+mtDiYzsE55S?=
 =?us-ascii?Q?86RH10qAWbjxDsbn/faxb3EvMVu1Do8WYSNRnYqpcYkzTzAOh0bFTQQALI9u?=
 =?us-ascii?Q?1Aex/o155bXP3zqOo/jt24UlEU+Svs5c//JEbKQpxZlk41TEI9TyTBTTiL/4?=
 =?us-ascii?Q?oznOwoezjYTqCPupcxppvjdstHWgcmd27+mReI8xqttKTQI23dW7ggc6Q57m?=
 =?us-ascii?Q?8PMDECcQ1yac6offszpVJi+Fb2A3gdwKa6rsIoLFh/pFyRkTXRaWWxi0JUt0?=
 =?us-ascii?Q?Isz6jjfmJcpZHlcIePIlEra2rlkZIOgxFMaAc0zRj8FQ6ATp63aSMcrim8fq?=
 =?us-ascii?Q?6O4RKM15+VEWjPLIoSyo8W/H40IOMkhgryhl7sP5baNprfdUFqSz0duEtGW/?=
 =?us-ascii?Q?F8y5K17Ii+cCmkl76hI9DsKdFe9yqLWgtVw0Y7tVYFiR03ECibFU2mdk9fyH?=
 =?us-ascii?Q?Le2FxyzZVyTnzKAvq/UdXPzifTM9/bCkQRbRrd5HBk55CRUxO7TUTMd2dTvo?=
 =?us-ascii?Q?KvP5tumCwTlfRsNRWyodASnmpXM5zgPbrRd46gkGF/YAl1z4JuJ6IQ231vte?=
 =?us-ascii?Q?Y9bPNggvhC3Q7YbPaUzYq84T14Z02YK/5VYUzxWnWzegqzndsGvq+3amZgFS?=
 =?us-ascii?Q?w8/11xyJ+AS0Anhh8xIEt4kvz3j+SiwCS5yBIIlxe/HKP3oNayZYRIfWVD86?=
 =?us-ascii?Q?hczqTpOKRABxmbwO2/q8GjuZ3Em0Fg+7Kw8OzlTWK6TbbEMcOnnFcn/3Db2o?=
 =?us-ascii?Q?JmywfyYtmP8eMjryKi4F4lN2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecdc905-06b1-48e0-52d6-08d935a94e02
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 18:12:32.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT0I94mQXIYV/VdeGuZ1utFDdGrH4Ws2CGaVkYQq2/pAB5FzZBbKxDdn7xQ/VPva
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 09:42:07AM +0300, Leon Romanovsky wrote:
> On Mon, Jun 21, 2021 at 08:37:34PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 16, 2021 at 10:57:37AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > In case device supports only real-time timestamp, the kernel will
> > > fail to create QP despite rdma-core requested such timestamp type.
> > > 
> > > It is because device returns free-running timestamp, and the conversion
> > > from free-running to real-time is performed in the user space.
> > > 
> > > This series fixes it, by returning real-time timestamp.
> > > 
> > > Thanks
> > > 
> > > Aharon Landau (2):
> > >   RDMA/mlx5: Refactor get_ts_format functions to simplify code
> > >   RDMA/mlx5: Support real-time timestamp directly from the device
> > 
> > This looks fine, can you update the shared branch please
> 
> 9a1ac95a59d0 RDMA/mlx5: Refactor get_ts_format functions to simplify code
> 
> Applied, thanks

Done, thanks

Jason
