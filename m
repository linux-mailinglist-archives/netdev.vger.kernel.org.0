Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B174E45325C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbhKPMrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:47:46 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:25793
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234318AbhKPMrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 07:47:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWy7KuhizoH4p0qAG9KL/7q/4krV2WZ/mMhdg++bLxgkjS4VWDbLOYn8LBgoxTb1uoPqwRf4H3FvQ6iYm03SDHfNLegIMS0mepiXhSl9by/IewL4m5C5psxX72AtTEFbL/qP77MHvJMvwtT29eaD0NttfDRpmtsj1pjOUqETmo7fuZtL3CY2itmafcPIT1iOe0CTUY29nk9ia9ZSPBWK3h28jCmfjBm7j9yij/M4+UkqwN13ABwJ6Jz5r5paDGL2vihlZVgFKoGfcUDt4ns5yjH8msY2VRCnapTlBThLIKWGOjiuHO1+fTV5X0ffeRnGHdrtHnR+FGz/5KEm9E2wLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jEnXAcBqfr8HD8qnwTbhn+6/Y6odnDfu5vHqlMV6oA=;
 b=cUwUxA0FhH75Yh3K+kTRG3sAK3l3vDxacXRrxP05+x/Z1lklTCCy1kHX+gGNo+m8yfuDU08bHYo13DiQ9BldbaJNxk56zRpsrsyiJXIv+S6l8BMOffOWqhEW/JWGmvR1L0eNvItun/jniGpfemWZhkl4hzuhGtC+ydRIpcNCO66kXJbMRLpomKZp5gMFm6qWRnwF+LHNeazwH1QKkpzVA95vTIJBQy0W8wSNys6Ug+CGqYcoXUqNZQna0pxSctDvDo9PT+RmaLeK857ZV2bUanCA1shfdlzUCaJD66l2P/UiQp75IhOGkjz267nmiNc4EfKNCAhQpfJU14klXkFujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jEnXAcBqfr8HD8qnwTbhn+6/Y6odnDfu5vHqlMV6oA=;
 b=sLeFn7dNm9/FAK1vr/Ktqx6VZta3UgXC9OpGyIzvrQERIdInwAIqugeTmfpCRrNqKJbqd+E3+Et0xjIsNlpxGlq56b5PKMHztUQ8z1REhsUBFakZCKWSOyk7iH59uO/vmwyKnxAL0pVZ2vRWPp9iYa+RdfiglmMPNIQt5pWYCVDKmJaLhy8ujjRparv6LOILW6n4Q8CZNiuIwAtKj8vXIz0/tiY+VmunYopEhv/gqqGnVMkpxNf3KXIEY2cJRHRwAVGDEaiwvJo7s7WFM453JUq4oEJ7JUVDPbgsOJoLDtMI77wadZXoYV3Zg16qrNhINpXAg7XyqbomljvW2SgQjQ==
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 16 Nov
 2021 12:44:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 12:44:44 +0000
Date:   Tue, 16 Nov 2021 08:44:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211116124442.GX2105516@nvidia.com>
References: <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
 <YZCqVig9GQi/o1iz@unreal>
 <YZJCdSy+wzqlwrE2@nanopsycho>
 <20211115125359.GM2105516@nvidia.com>
 <YZJx8raQt+FkKaeY@nanopsycho>
 <20211115150931.GA2386342@nvidia.com>
 <YZNWRXzzRYMNhUEO@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZNWRXzzRYMNhUEO@nanopsycho>
X-ClientProxiedBy: YT3PR01CA0003.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:86::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 12:44:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmxpK-00AwdV-Ae; Tue, 16 Nov 2021 08:44:42 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd5d21dd-4f77-405b-2eb9-08d9a8fedda1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5141:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5141A3C718D1E95053ABC110C2999@BL1PR12MB5141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60b9uBOTGP+oSMb4JhPy5ymixLO4W+ouXkWqCbcnlGhUJwuy1mDIlrfCMdfDLeEE4fdxFNE8djFEXu/ejxCtZqfbTs41bPSzGyjor71Q5a6oxhGLPCzHY0afa0O8CGnX1XBdsE4GAl8BzMSLuKExDlUCHfEOBGnBOvJ12LoXQZhRKn1jmAiruR/G0acJi5tI36AIdhQSFxgz2roTx8JX75Q9QqD0PhU5uzuvFg441Q0oJl0Yol3YovEapC+K0Tr0Vw4rgVdpzCFGQIphAEG2w7ucZRp59MsvmZCn3limTnHr/O1z6umc6U7TFAXND6zKk0xgjEw4E/9ATjizu3a/cbDczVXSb2qA8abhMe5mezCsfBp8EmkNAoyTqMLi6nDGxk+JOx76kCx/+u9SNpA0SuosyoopVAY3DyraHJFCjWjEWYVYACCT5LvYoHd3lTH6AMNgEd4EVtbCQBk76Ivx0sZAZHcPYzxj8WEFcQs2RSLKNo3TbRHytO2vSTj1SY+Jciq7BQP4No7w4j7rHhbMqJZMknUqKC0olZ1daWopR4ZtNPItTScDb1nxv/ZEtM/huDJkqh+4TYTqffSB7bSsYlF1sGGgeerbAKAoooXbWLGmnXj8JVUah91CG1VaDn9BWtorBXRFfqSX8xqAgUl0oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(38100700002)(316002)(1076003)(9746002)(66946007)(9786002)(83380400001)(54906003)(8676002)(5660300002)(186003)(2616005)(508600001)(4326008)(86362001)(2906002)(426003)(66476007)(36756003)(6916009)(33656002)(26005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wdsloqoW7au7Fyx5HY3rByGYSjYk5vGwYzRR/Zw/zZ0RAXQyx7z5RkSoQvdC?=
 =?us-ascii?Q?qbqeEeJk8pdkdqkzz2HaCcl3cUIVTJbOnK7h3WdJ9HR4G2p+aXPEyK5I9HdZ?=
 =?us-ascii?Q?yp7h82Z0YaDZw2uuVZuk7g7w+zR+wR3g9IisQhGOjIo4I4sZwZzJVaQOgxR4?=
 =?us-ascii?Q?Onh6c8Hu9GEf2D9BRoiOJ1NXJHSPNgm4KQlsvwnThimMysutPBUyTfsFwpN7?=
 =?us-ascii?Q?qu9w7LDMyIlVf7fQk8QBSxVI4FVJrnK3ql7VCA2CaX4CcTuT50TdBL2YdZBB?=
 =?us-ascii?Q?VWPTOp3YxJNXfmkfzxWGFh8vk0T8b4rX/Aac3kw5DAyQ9JflZ+++Lp7UhOk0?=
 =?us-ascii?Q?9t2s4aEIce2M77tZQbE+TBvv/fMe5d9LhNO13/WQ20GUuJnWvbNZuBH66j9h?=
 =?us-ascii?Q?wd15PZxKgfpyNSJtmbgwKsntf5DNTUXNCFSa8uk2oF0+dxxHB0iP7LO/ilBn?=
 =?us-ascii?Q?9swZRK9jmlBPpTxnV+SG3fiNxxva32JFdUazJbDzzHtsOGOTW3ummckI1Eea?=
 =?us-ascii?Q?c+egrb8eUFxNiHa1JrzTPe2TBaPFuCFqUnW9Tn3Ecc1stGpZzmuQ+PpvX1Uw?=
 =?us-ascii?Q?8TrpQYE201SW/FDGHJISA5wRDK8Ct4n/9d91iFQ2Va+YfaCvaNTgkTGiJizH?=
 =?us-ascii?Q?3sXy0Q/iu9iTvweZf+j4JJYmipRPDQVoRTNUUKAR7dm6yfsNplYxX0jkWcaD?=
 =?us-ascii?Q?FVPUmyfbCevAUs2Sv62NyvtUHRJbnO15VkcX2uOKFPQQSfoj33QZwp4+yGCa?=
 =?us-ascii?Q?rTNohX1W42UuTxSHH162fYMxykYUAh4J7WJ6xqk01jBAcRde6UDNZdd9LL3E?=
 =?us-ascii?Q?Tu25morYpQCNBkvYKChjegnFOT+3H8rDV13PdENYVjkI5IIZacPCUqNNc8VO?=
 =?us-ascii?Q?6/+oxvn7afmBkJIfG7b4bagGYxWvfWrlidflBhUNiAtT+TCRO9bvhjrnraP5?=
 =?us-ascii?Q?f3q8BEX7/SgticIBsy4NSk75LPg0sryWNHKFkigl5iktKu/YUHlcO7t5xCxr?=
 =?us-ascii?Q?AcYs3SoiH/VjGgTREaZVY5OmtmD3YrRuUBrmzths3HbeSUemJxFnUV2PdU3I?=
 =?us-ascii?Q?O6YzGO76HypTh/SOAZA1gaiCBRXp1DGqC16U5GUMAiobCLlckwb5iqYsEbKv?=
 =?us-ascii?Q?3+DbUvemIeXurbOWwxnYLKeQy/OJzYD7r0zWwdeLRaHZKKXaIsC6HlwFxmPR?=
 =?us-ascii?Q?E38Dy9c1T/74LC4FBNDY1A5c1+OHL8ZaDuxAR+cWKhmYfpKuZBZiMrqPTSn/?=
 =?us-ascii?Q?zdwcCZiaiRNOaFXmHvOyTCEHUvbdfA8mKF0sUmTsgT/t6o7F/9zJFZAWVt56?=
 =?us-ascii?Q?74sx6+4FK3q5cvQEFJJ0CXbItZhfo+CuA2bKdOLml2PpMC2fQeKyvT+Gitme?=
 =?us-ascii?Q?SOu1Uee5pT+mnJUsULOduPr1msIMrQ8AfOFJRvqYyJIOvsZNUF6ABU6/pdPi?=
 =?us-ascii?Q?7plE4Cm56uKMHAvH594S4Ko70g4Adks51ZFazHkDLJS+akwLY0Gj0gWB3IM9?=
 =?us-ascii?Q?romTPQ9xnAnZIbsfOzNNE2PNzwYrw5hhtR7AsxEtVzmzPoFhcObsiksLK+0v?=
 =?us-ascii?Q?40dEnEbVi+XcprD6SXM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5d21dd-4f77-405b-2eb9-08d9a8fedda1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 12:44:44.5224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NE9qY5qOIH622hNmRKdKBv2opqsq8atJB6301GFwpTftePX9R4L+NHLlzb4tR6ae
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 07:57:09AM +0100, Jiri Pirko wrote:

> >There is only one place in the entire kernel calling the per-ns
> >register_netdevice_notifier_dev_net() and it is burred inside another
> >part of mlx5 for some reason..
> 
> Yep. I added it there to solve this deadlock.

I wonder how it can work safely inside a driver, since when are
drivers NS aware?

        uplink_priv->bond->nb.notifier_call = mlx5e_rep_esw_bond_netevent;
        ret = register_netdevice_notifier_dev_net(netdev,
                                                  &uplink_priv->bond->nb,
                                                  &uplink_priv->bond->nn);

Doesn't that just loose events when the user moves netdev to another
namespace?

> >I believe Parav already looked at using that in rdma and it didn't
> >work for some reason I've forgotten. 
> >
> >It is not that we care about events in different namespaces, it is
> >that rdma, like everything else, doesn't care about namespaces and
> >wants events from the netdev no matter where it is located.
> 
> Wait, so there is no notion of netnamespaces in rdma? I was under
> impression rdma supports netnamespaces...

It does, but that doesn't change things, when it is attached to a
netdev it needs events, without any loss, no matter what NS that
netdev is in.

Jason
