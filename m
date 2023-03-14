Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0EA6B9D3D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCNRnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCNRnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:43:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4910E1CAD8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:43:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2EqKDDLumqrB/ZIfks/hw1DwLz1YXtCwnA/qrEw8i5bmXeC3Nk1qBcqPVlNu3StJQcVezwwAY1C8+LHl/p/POYuV1Y+t5LrdoPRZ8gf9aayskLrEgSXI1ZrFlvbKknvG7aEtuZ7oPxmCxVeMlU1NoYz0GycGHB/BbkPx2yuRvv+NO7eJC/zqf89Jnrv7sD8p3zyJEY6AQ2Rguqk809DCU/EvLz/zb9uX8ETOLcdKZHLbEGMEy1NbZ1k5TnlhpfUPgnF4M4uXSVRpW6lSHQXI0YwYEnviuuvahrclLMcCd641KyYk7nOuGL8J4wK8K1ZLSFHxXZfh6phNBKo/e2qug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWLy9GrldtWBVddR5RclCODuSi7IDlM3TbSKl8S3xeU=;
 b=JaAoD4otDWvXOZcmooWqX53j50CDuYPPGmuWqJ/pNCm2wRYmJwOjDs8UoANr/PaojisCHvRdovgVHF8nGlbfF9dj4RTWxXzlT019FgwjKJX/dMgmMd5mB8SgkFi/EIHLJwXlAhntlJ2Rq6oKeZPQQS7sXRK7rRa/7l+zXqJfqkvZYK3gcUsdTwlMtRzACmsrAj1Z1RMPdbtKt9DJRupHu6cEiQ0ZmVkvV/qcYYEoheWJc8WBy23osyGVquD8MS75DMISSgOrQVUIsSRSRThoZD+54lOJvxlGiW1wVSHprNGarlRNBHSar8igtr+zYPVcHVDAfr9DM4qUlUefiDp68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWLy9GrldtWBVddR5RclCODuSi7IDlM3TbSKl8S3xeU=;
 b=seAjGCProI4biXON8epaubFv1xjAk8I9pkEiwRfaA1CtZmnn0kmb1i7dXg1VVX9mT5PWLEdElOVI3WFKkBILxpRwzGIKh7IQ3R0AVdnzk7MFCcpMfOr9QFp/0vu8yzrPoxh6AaTMPQ5tScdsqYIhUhO3T7BTcEvVpMAVWH/57DLotEQh3bT7a0XcLTSfkmXoXxS1nZsE9hv9fhl8pRkRCSlA9mfGNR4hz3g2AO7vHaNtHh7neDdVmyJGXrN/Ra4dl2FsuPW0zHtB7UXyIvig84o9o2Xp6AUSVBsVGBDH8gLLR0yktDrqkjxcXa8Cv5IfV4PcNtosSB+ewniO12MgPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:43:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 17:43:13 +0000
Date:   Tue, 14 Mar 2023 19:43:06 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Message-ID: <ZBCyKtdDBkkECB3I@shredder>
References: <cover.1678448186.git.petrm@nvidia.com>
 <20230310171257.0127e74c@kernel.org>
 <87sfe8sniw.fsf@nvidia.com>
 <20230313151028.78fdfec6@kernel.org>
 <87a60fs2kp.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a60fs2kp.fsf@nvidia.com>
X-ClientProxiedBy: VI1PR08CA0148.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5141:EE_
X-MS-Office365-Filtering-Correlation-Id: 494e723e-9e77-41b2-b599-08db24b39569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YiLZLElxaCOBEuEqb3nTXfDSELM2KErel+icmqrf3rJD8012BO339/tKdgDIg5ao+t725DKXhn75fd58PFUp+k18KSbJNFqH7mRpBNcC1cwcM+1HKwX8NlB9gY0NSFjyC/GbTDjr19+WNAEwF5/9qBQjQWAJnjaB0O+McSDAmADtEm8B6e+XPS6cxA34DM2f0fYEkAZRRt5gxdmedXtq2MhRlm4pEwoKTSKJYoyALKJtlcEshEhJRTdGNc5cdKHfwY7D8+awoNzb8gDIiu0NqSdojL6r/13TzFuF9QjHH4U+XgvQdhDVS+JVSyB4IXy2INaUGLajXzZqdYlr27OjTj8hJ2k7mvT4xHisr8rtpyhSFfiU8FTsXsYT5dN2wQpEDfBHUcSEmh3TDRR8D13BqW7zh24y8jHcKHwmmu6XkGH5QW9EJdtXN3eeRgoXP9ryeIECqQPcoQ8pvVKDQIQQFr1hJCtKSGKJQPbQaM7PcEK590BoJmHo+QRgiAt3T0gy3HxjWXPKT9wNWnvBv3PyXEx/7S/49tzR95kgVK8C2BtW80km6zMmA7EgsKe0QuRYSnwmI+6nVCN7LnOdsomABOfzk4U79C0C46yZMFgjLSjjZMBWLRLf1e1cSqGCMjA7kKuiay0hFz3oxvwb/oqwGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(186003)(9686003)(26005)(6512007)(6506007)(33716001)(83380400001)(8936002)(6862004)(6666004)(107886003)(38100700002)(6486002)(4744005)(5660300002)(66556008)(66476007)(2906002)(8676002)(66946007)(41300700001)(4326008)(316002)(6636002)(54906003)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qMAowK02fP+V7LCB+kvj4MZfE4pDsQ6n+YJ83josTeCdEWFIZfB0y4NQhEyB?=
 =?us-ascii?Q?wYO/rBt8NoO950PFRL+ZVNa83SyEmpCf6W0NAUJ29iDxFU+uNpJG4cL2gXH2?=
 =?us-ascii?Q?k2bjvekgsSfWudvsS/Nyrny2r1YqtLvF2BTYRXkhdvi9+fTh3zr6SNlfYoSU?=
 =?us-ascii?Q?Ab6D6bocQjF/PO7pMcuj2wW+PCtqWhr5R8eq54WcHAzgUDhwVBr5XGHKDWqd?=
 =?us-ascii?Q?mYs9NDxer51r1khHJvXiO+xIOtTMt+lwiVGMKsdRXW0+7njloWED5vk0NDs4?=
 =?us-ascii?Q?c18eNLfkecd/kCLtZthShvIGR4QP5RBFfDIIRz5UvzEh2Q84IMPw6Dz5iolo?=
 =?us-ascii?Q?weq5++EdjNuIF9EjxdGBUc51LLClKKuZM95cMsJ1qoUvViVbLGDQcTU/12o7?=
 =?us-ascii?Q?sNXDC+bM4E/TxUyU6yQ9NqWDlvkOr49DI1e+tmgdMVFMW8Izx0No5CWma552?=
 =?us-ascii?Q?0WiwfHhO1Xfk++RKXPJGUR4n2a4HlrbmFbw90HlsVhCuq+JLGbeHT+2rWOPe?=
 =?us-ascii?Q?BDMNAg/Z+zX4WFLopcTLFBAG/MrI2yos+Hw8xrzplt3FM0ImUpmZD7S+azRT?=
 =?us-ascii?Q?wTrJJ3cBfzzcHjvK/2QwzOLoU2Cz7nqyf7f/wT0KqEGTlBeaVbh9fsCJg6RC?=
 =?us-ascii?Q?C/glo47stnGcMcbcso1aEPU1MfwW3kDFmJzPumK6OixCowz6PbM5Js+NL7HO?=
 =?us-ascii?Q?lUfdjAVIi1H2R+CjlG+wfh5N7MKsTg1S4duTxVcxDQbJHYQRMHoiUNqShpI2?=
 =?us-ascii?Q?vr8vM2uHh9pN0oIs0RcBrbrWMZEDVuDsxwwcJe7kv6tH1krYzaxj50i2A1xz?=
 =?us-ascii?Q?lcv0QWkl+qOzMev/TUdeOV7sOyGL7wqJnCMJoNhluwteq47aOorc9EXI5q8h?=
 =?us-ascii?Q?BqAwpYgXhU3z/kuNEo2rUU3upN7kInIFJtXMKR3pX8rV9k8n3lj1I6YmyRox?=
 =?us-ascii?Q?YTn6qez2ZMe1jBjjlPfNA5WNV6HCNkJSqKudxNTopHFO2yaKEh/dQPEqxZhE?=
 =?us-ascii?Q?GdZ5Zh3VbYjwNDo7bnR0MbkjoVw4xnkCRJKfeONHPKoKtKXa7H6LSWu5e693?=
 =?us-ascii?Q?sWrhHGcg2YdrZhhBU8uGFOr7+0UrohzuYGrI7CPTN70rWhhqfp0dzQF/ej5X?=
 =?us-ascii?Q?8uLsnrSSxfafecHHWQCThC/FkNbChDVVE0LMwF00296HNuws/ur0jiaDeN4T?=
 =?us-ascii?Q?6mN4nIHwraIxUVR/iHbezfr9AWbI+4Rxma9ccAfV0NIwCYRcOK1GlUH0I14A?=
 =?us-ascii?Q?9nI0urmtByYqYGAgGwGj7ZD9/qLnHf5gcKdIcXiqzyQtk3GtgtL6OFx3Nu4z?=
 =?us-ascii?Q?7OlQSNLyZcjjZ1Q5a9wSBViu34Ow47egZYpxdgrZ6midQQVNLlAsccNosD3C?=
 =?us-ascii?Q?fgWLu92Tf3eQfzE5hztyOtv/w4OmBoKkcU9xS6QMLOX/O8NBnSwwYh4vmevl?=
 =?us-ascii?Q?0Vrp1u/8mwPsw6TCtt1FMh2ZgkuaiwlBABR+YgN9anwQZiQj8ocyr4HnLgs0?=
 =?us-ascii?Q?8/3JXkaBgLOLy7GQweJ6RcGUOdVfeUoPC+wooPV49s1gOybyPDHL6GuFcwCl?=
 =?us-ascii?Q?WwfMMm08cy5DnmCCJJ1TDun1LCyqmThhwlmXuYEl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494e723e-9e77-41b2-b599-08db24b39569
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:43:12.9254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZPgxugC9tDebapLqrFgw+dLDKT+/M2XtosZ+mEowk+hYqx+ccRNaFaTCc0ANV1CaoLMK3o8skI5y8Vu6L4sbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:44:00AM +0100, Petr Machata wrote:
> Like with the labels, address replacement messages with an explicit
> IFA_PROTO are not bounced, they just neglect to actually change the
> protocol. But it makes no sense to me that someone would issue address
> replacement with an explicit proto set which differs from the current
> one, but would still rely on the fact that the proto doesn't change...

Especially when replace does work with IPv6 addresses. Couple that with
the fact that it's a much newer attribute than the labels (added in
5.18) and that it has no support in iproute2, FRR, libnl etc, the
chances of such a change breaking anyone are slim to none...
