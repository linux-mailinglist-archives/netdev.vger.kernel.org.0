Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7208858FBBB
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiHKL7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiHKL7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:59:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C87E9674B;
        Thu, 11 Aug 2022 04:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDcKOC3jHfrZ0f6SA21AB7eGsR2cOGHtJ8TU/81IKlO9RHCxD3Lg1HRzQuld9krFYBxDPYdnc9WpHYRfkwOxXDya7AjuQ+N79mcGJQ2iU161X5xbJ2sa2JtE8wOLSvTBYj2Ze7S9kALbWzrlPSCOqCCuzsIy8gx2oqHUfcF+PtwQ14cJfR3yu2dQIxUBnt2jvZR79usJKNZPp0HvJ8eSwE3ahvFS0scf/tyZdFNS8Fzmwl2ufQeqNSri13OaHU28zhiqx/NKtLLwjGbA+GoRqDUCWAMszRlTfIiB9/XPe1MYg3skPz920mTCtNM8Yf2FcJo+j43k+OIOLimRUsyjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63ZaFAYl57H2OV60NwmHxLEKXnuz3rTXPF/mieWyJh8=;
 b=Ra8siTgtKXknJwPKtuwXoWFsk4s2hVKOdWnl0TdRMSDL8Zn3K5kqURMwUBpDUizUtbbPHM1SS8h5LyS9VheLv1/sgnBwzP6aIG6Ht5FHO4PYZawkklxHkLx0LraxyhoYEVME+IDWTpWNruWJjvMSXmNroy+fMYCmgBAD7WT/jpyqLOk1qefazY84LZpaTzi1/DfRPKFIdgxFGvvpexyZs2aF1PcjnlWjI/iVNaAFEkcg7Z0KCCGJfcw1o3jd8VlUvcG0RsBO3XWd8nwTrLb38YILtSrADbuHIu3w/6bm0lamnVV/GvLHN9PaYRSo2Ygzkh1i0my+ceRKVeBlvkkxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ZaFAYl57H2OV60NwmHxLEKXnuz3rTXPF/mieWyJh8=;
 b=jFpmNUCOucW7uzavbkODpBzt6KHIuk+4u9rcE1nlZkD6ylug8KEOk6OsbuQnn73zsWwzdTtgnL3h2vCoBuiSOUfEQ/WT50F0XSD4Xr0EAsqiqk8++5MnsP222eSIhLxoefY1Sq7SFZfMJT1BU8OUUvFNzfNte9VMDY+n2DMRxorq1yt1kPJyNMSKkmVCCUeKtN6Gx1qQHqxG1hzdaKDHUcFxvECBKEAb6O5QZql2h+hkDhRnPhITjaVtiRXcv154c7urt5c3oJyBlKZ5LHrYWF51beDMnMqmXqzBOAaH7BjpodWia46YAnI1BGAkwJjnrbb41aw3Uw8cX2XrXcWrfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by MWHPR12MB1872.namprd12.prod.outlook.com (2603:10b6:300:10d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 11 Aug
 2022 11:59:12 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09%6]) with mapi id 15.20.5525.010; Thu, 11 Aug 2022
 11:59:12 +0000
Date:   Thu, 11 Aug 2022 13:59:07 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] mlxsw: minimal: Fix deadlock in ports creation
Message-ID: <YvTvC1sd15MDoBxp@nanopsycho>
References: <f4afce5ab0318617f3866b85274be52542d59b32.1660211614.git.petrm@nvidia.com>
 <87wnbf57bw.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnbf57bw.fsf@nvidia.com>
X-ClientProxiedBy: FR3P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::15) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d70a371-eb6a-42bf-a702-08da7b90e7ed
X-MS-TrafficTypeDiagnostic: MWHPR12MB1872:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lgZVp1EsNfzLzFWbmeaOJKRYLadw7V9jOY6K1BfYDLANNw+6K4VO4x4lsJqrt9LtnTUDS98yx5ELw11BB262Jn6Wshtpf3YNRjTOmBNBaM3fXJPOHeunSEiI00Z4SonZIvVt1ISZZUP2DagI/Qo5DYqfPMjRvu/3tR38c8pIMNKB/I8FrBzVIUV7KleZRiha6B2tdF2+HzUmnpOfB4MSCI+nhRH0EJVJzXwLnX4Tym5FnyAHpNHCNVNuvp7oBHK43adTy+S/2pFA4rAj4RT+mVjpTXM8ImWkzvf9wJqXkaaAzM3n+CTmbeZiab8YGucZtmXBuRbZjiK6J4O/n0tiJQ9Faos1aWmixvSluPQcbXKhFeHirpxFeocVnX+wz0vD00WO1WgaGFIZzv0kwXkLzDebEGA2Y2qMVu5xX6ylPwuySEc4sx+k456wGX5pIU1/9gtAL+pn7sjpVA2TV5KHUUQspMJ3lEs7h9DsumwcC5KYFQypLdjm1TVArjmTo7eCPymsZoQri//Mc4xGOuzlcsBl9QCkO7j4sasWWkMSt4gXlYdwukDIiymdolCau0b6EQT5gmRFFsdkd09/rhpDjqUNoq2syi5y4l/B2K/bDD6K+92yfXtTft2qdSgBVm8J7EMNRLSd9+Fi3mOObqMpcmn33xl8QfEGN8fLoywKjemKkG/1eQGAuti/36BRZpiTDnVKFFTT+dzhku78nIPghnUPtoNUyJQDgXRPEroks7bpjm0Zh7i7Mlal4tjXyn11
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(136003)(39860400002)(396003)(366004)(376002)(9686003)(33716001)(41300700001)(6506007)(6512007)(26005)(478600001)(6486002)(6666004)(38100700002)(186003)(558084003)(86362001)(107886003)(5660300002)(8676002)(66556008)(66946007)(66476007)(2906002)(6862004)(8936002)(6636002)(54906003)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?45WS3ZL73tFYFP8vUc/cSRvPwXiexTh6TG8z2TwD3oEGznFOgkoRAmIrvBUc?=
 =?us-ascii?Q?a7mUYAx4o4z5ZnvUhJSsijszPDjB/rhI1NEsWRi0dn6rEkbv7M69ZbwlMf1z?=
 =?us-ascii?Q?llzhJnIS5aS+dPevK+1/nOtoGaENMDo4UOCHHu6hJJXmr09SIv8RT0M4bpK2?=
 =?us-ascii?Q?oq7q/SntO1QVZsbGK2TzEggTGBnPbq7ytbpXmz6u0hYh50Kfd7B7AeLXF/xb?=
 =?us-ascii?Q?nDQFqAc2/rhDj8M0Kb67m/EWIrSciQ2eacDqv+hOGcGlqZpnAkM7rUCFJhIg?=
 =?us-ascii?Q?dE78hW5asQ/aUFWVCF+X7Iqe6htavBtbM0DNTpeFwdgqglwVkrKr5SGTWNLU?=
 =?us-ascii?Q?+4SdZlaaqxH8qM74WIX2YV3/I/DA0Yb/ylYE+otrLET/DsiYkQ7I64kguz59?=
 =?us-ascii?Q?f0GGAkKkBuLmF6eAKZoXVacItLsjV6qO3lWax5nQlVVnq3sG15LnIuEN0Ggb?=
 =?us-ascii?Q?NKuiHpI6V2uT1qYNYIyG7uxveLyZbLwnu//SDpTnm5OpsL5h1JkSy0rENdRH?=
 =?us-ascii?Q?OpWMMDFtF30TrqXzrscBfRoiwGbIsJunOXnP3y8UVRBtY0nr+BTsx41O33Z+?=
 =?us-ascii?Q?FomBJNsqhXuNcqENAWna/Op8O0gIuREUcUFm2BGg+75xogn+/7zEyBAUAZNz?=
 =?us-ascii?Q?DBJD/QGwDMNSdokVqPEdMOPHcqtk6+oth3Ss7KtnWMIKM+YpEpbZtAkaW2KT?=
 =?us-ascii?Q?Z/wG6o5oC7Ph6eDFgfmCTtukKnFuNtV2qOGzLtMzQT9VNyu4nV6SEmfOqp+h?=
 =?us-ascii?Q?E0WUptMqKXO/KruQh83v8+Ml8PYo+77cyKMnGSVy+dvFLL8NT06AAtLTMiu2?=
 =?us-ascii?Q?f8JeAd8Sn9mAstqk+1VmgupgTHQbx6PO4+WRNY5P3qLdpVanPGfHV5y4Y8ak?=
 =?us-ascii?Q?aAPCeLnpuQ868kINCxR+J1Rlrus4JBj5lBIVeR47GScSGZcN9mR/KT3C+W9P?=
 =?us-ascii?Q?yAay+j86VmdV3ZRKVjKd4HGbwnOEieFbPS9DQAzNEbHC/0xCNVMVKntnTuhN?=
 =?us-ascii?Q?BrNuBq3vyrZHyLlPPdpsQVjyvmk6gVQi7CnQLMuWgGZOi3NGSZncAczS+yEN?=
 =?us-ascii?Q?Sw/4S5dvG5Y5y2vPyVlh3UL2+jg0RJoAPDlSYgiaN6CKdYLwdHf27hZ6tjOY?=
 =?us-ascii?Q?QbeAbxBQtOBbra3HnU+0+c88ZmHThtUrFWWdOsWChgQRzRQknoCUUG4Nbz/W?=
 =?us-ascii?Q?hZd7B6eowaYxGzBnMrBRtRJ6bRwynl8jC9KNnCzD7ThZWKzZ2Pd7cqtdsQwR?=
 =?us-ascii?Q?kZW6JHSgviz8/ZHEWea/e8DUV/IDGIynCTQqt26h3LPMDBMDKNs6clPaMPsC?=
 =?us-ascii?Q?/XmJ63c2FOheo+BW/S7qd6uWQHoEgYSgtgDfZsSw8PnbmqE0ntuwkmRp9otA?=
 =?us-ascii?Q?SEkSN3MpYlTO2+NjMtEmn/Qd/8uOuAieQW3N61aDZyz13SlocoNVaexy4E9i?=
 =?us-ascii?Q?ersVUDi/5Girf/DsxDjF/RMK6FX9KbT463IfSapmBFT455fCwzaV7qj1Z8Ph?=
 =?us-ascii?Q?067FDK6+RaN/aQtMIKdbGCRRp+fn9ogrwUopIdspfINCDPNu3ZX0aU3IkSam?=
 =?us-ascii?Q?m05OOv8ebkvqwtwZyVE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d70a371-eb6a-42bf-a702-08da7b90e7ed
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 11:59:12.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 167fjlIs8VgBS0uPu34CuxHy+/glWOzZxfpMoi6uLaoRPd0WQE74R+J5g3Jdp4ZL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1872
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 11, 2022 at 01:44:17PM CEST, petrm@nvidia.com wrote:
>CC'ing Jiri, which I forgot to do.

Oups, I forgot the minimal driver. Sorry about that.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

