Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1368D0B3
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjBGHjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjBGHjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:39:36 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3690733443
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 23:39:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=You/aH1MpzF3R6b+Tc6EyUzIuprpS0ZsLlRpZUq6nf4GeU1bOh1EoLuL++sTuLktFKd+BIHotGOwhOCVv9Glmmyd6DCY3Q0IMazjHW8O+Gx4iULAzOxFFUr/wvi/uPQ6SXn8DuslNqVSDoJAxxklMMz26u8A+by89/Wp3gcPzKygeiSh0WRAMT2LtlzZW6jE+4zg2tDskmxV3KgFlR91gvz8Wis7FONFg7Nu4bYOiBpj6mrzx42AiqlzzM2jieMJ/pd/EJ39wuDD/XTFDE1B0ymBlIPjVIgd7cOLuOb5CPeTzNqGlFkaAfDJWUZbZJe4LuIpYPB/hnXNUq3Jr7TF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lArfXRG99IjULK2uVls3oeoK0+I6qRm3TVB+m+kc7s=;
 b=GZuA6t2v1eP3WWd+ChDAH9Gi0WDP5+aDDYJTdDFa8ywPnccxzz1RbOj4Yu96IqfsZLHxUiavo2KDTJnFaLoLK0TGjgejuwAJ0NKTvYX8yV6j8zwnZgvbvGXKDtMufU9+G/SCx4cB7ZHENYD0rDK29RMLMQvNx6hVGm8H23oQTLAX8WOAJEvutCQeXayGN89bKalGLNlZJCFDMyVFQyUcdHQYLmuYXpaB+WcO8Z/CbpjaotxnMHLdsSfaMX78z7iiwnxBES2pcnhJHJ6HpvfKYmXNzx9KfzhpDKovBuGrp1ZwXYymQeCd41JnpEW8s6fnEQwfCa+XgKwAuLAPFcFkww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lArfXRG99IjULK2uVls3oeoK0+I6qRm3TVB+m+kc7s=;
 b=RENBAGi9CI96kfAsDYUy+Z07/8OyaCmcBS+PGRqa88+0FPxhrhYm+GskOGmoFvPYWdumRtCsm0LvrGITGizgeFTW6bo7LhiCTZwGmAEVTP4S2GliUZc/Bwwt1kGHATjUVY1P8uCCp2e5dUHkb/JmIw7JklpEUEvz8mR6GR6b0PVWdA2h0EQKIlB1LF4VqBdqX41aBqtelhj669ox1AbmUJ/uLo1RLSrKyAtauuchbaJTAWY9Bc+mZZw4bunVjq4tDSyIuOUzwh1dkupp40hTpi8OALkDlE/pyLpsOyAOq1DKCicLXSCCktyD7078DJD1y66qp3/a3ZG4claGTH18TQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7869.namprd12.prod.outlook.com (2603:10b6:510:27e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 07:39:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.035; Tue, 7 Feb 2023
 07:39:29 +0000
Date:   Tue, 7 Feb 2023 09:39:22 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2-next 2/3] bridge: Add support for
 mcast_n_groups, mcast_max_groups
Message-ID: <Y+IAKgXSFtJvERWt@shredder>
References: <cover.1675705077.git.petrm@nvidia.com>
 <82cb1211d85e02e6247cb9a141aad68027cbefac.1675705077.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82cb1211d85e02e6247cb9a141aad68027cbefac.1675705077.git.petrm@nvidia.com>
X-ClientProxiedBy: VI1PR0102CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 621ac33d-a1cf-4aff-edd4-08db08de71cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5jrSU0dZhHvYSFMWkawL1XJ4Yz4pika27+GQ8hckiTrapIPhOncmsuYLN7RTYoM2qVO7fe2Ug8Ta4eFXh8nEU0NlC6Yo777iaeALQZKGoh8r0xrYsiTANQdpc2lTTdSHcm0b7OhnrthWz75CQGjrYUgUwPZ0BwIerbwrGXv3rWiNOQ/eO1MhAwTj6SY+X22fdSoEgrlyYDUdBNlbUQBxyt4Z4gZt47JivDG2N0siIaSKbFYL+9AAt8VgTLoydgT7+/IkqI/KZjGXPtGDnm+9SzI9IPztXyoOg61HcrDZh6bSvaxHHaR61pbCobBRoNo9IZlIE/UFvpo4R9iueS50cj1TL4t//TJZr3PogwS8uwEKUyK6O/P/QNgR589i5siuhmFWJFug3/mCpPTNHJ04Nij9aFu/iYqkiwdM03esvR+HR05gcWOB9xUeZk27dUVomlN4yvhTamqfq1DvSzjdUiJ7o2CEYLTRJ/0bGKdz8sduQljQbrrrx06PniPhkdyjZSB3kqv5I/U4hgASiK1/Vo9pMpKPSR7uRWKjR2efD0/iDkxulO3FYYCCgxYj85Pa5Fk9nu9ghxhBxDZbrQHk083E4vC0acoBgZcoMW3L0P5vKNF02Go5Fl0VDYxX3ZdcdBSO5IFpYvK96ykQjNJRGz+WVj0ct2At+5Rf0suh97FxkjwDexWcVGPYMT23oMe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(86362001)(38100700002)(6512007)(26005)(478600001)(9686003)(186003)(33716001)(6486002)(6506007)(6636002)(4744005)(41300700001)(8676002)(4326008)(8936002)(6666004)(316002)(6862004)(66946007)(66476007)(2906002)(5660300002)(66556008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i6r/KX8Bz7iCr677DVTLF0+Dj4GbLki6EVLxXkGyCfEtxh2YD/alwA2V0okv?=
 =?us-ascii?Q?MvFmUFVT13RiwXe6tkkCGysasP0AMPJbEYSisaMPcr14EU8TdxszndDkaHlW?=
 =?us-ascii?Q?/NH4ghu3/v5rfcBzDOHjyDWf49oRu/aE+ZRzzHWb+5j4sDnq/pLCB6C8uMm4?=
 =?us-ascii?Q?JORqRvxWIfpLqC1Fl9K3vcCYOwNaBGsmSGZ+QG5p5mPoUCmcem2M21MmAzdu?=
 =?us-ascii?Q?fPfLF8LQ8fdo3lpzkRD77WgA6HEstPOZFinbQPDqcW/OSTwwHyJF793yvG4H?=
 =?us-ascii?Q?rWsa2vfBwRsnfDsD6dc97aBGIHLhklART/GNp6/Wi1+stfHs8FQOBo40FIyf?=
 =?us-ascii?Q?UE3sj59+XSgPwSr6K+O2eqqxmDhXl3GPBhcT0Gm8kQA3Ym6uk77qnF4tFerE?=
 =?us-ascii?Q?pdzvnKdFJt471aV6mGN9GZ+tMuNemCHFxXm8XdCJZJBTgWBAfVke569Y1Fhk?=
 =?us-ascii?Q?UP8/oMsGKjhYayvesEdJUVT4HhLHf+Po0qlTOZBCZY/X0HU4naYVopee5V6a?=
 =?us-ascii?Q?f4CKv6py3d+VdCpe1kJUm9E7jab+rqfUQWMVd1W2NjiPN6LEpvrFBq1yw0xc?=
 =?us-ascii?Q?Y+9E7Xa/stzs42wwH0mHDb45QFEPJibTqxi9c8R8qRy31dScSnlnLLGOP66p?=
 =?us-ascii?Q?1OcJOPXolQ3QEblGcYWd2lWVnACb00c35d0/jBHqglxdZ8wkkdPNSGBG6JSa?=
 =?us-ascii?Q?fsRGsEkK22TarikLy/q1oUi1flgI270iC3ASk8zS9qbawvno0eQmAgNXvjHY?=
 =?us-ascii?Q?FOjvuGBbcvsYcKJ3LRkhnkdLTHBxym6WDVXLbC4ZhTFFTP9X/g1DHhBjnxHy?=
 =?us-ascii?Q?Gy9S0t0rHMnoyGF2UvrAyAC9uFd/v2wK8aM7daK7+GPymcUxwOF1tRSUlmeh?=
 =?us-ascii?Q?YXWNoAGOedarKl41JLGfJkmzve/dtYtNRY5gsfNQhVORTlIg6yekW1IEFLoF?=
 =?us-ascii?Q?HT/7sbMnrzqKfBUunlmuR+xHt8Hc1aR/mq2pxkI5et4EPseX0eX+dL36j1um?=
 =?us-ascii?Q?lTMXZU4JlFm7IMHdu3k0rGrQuA8kDRWEWfeELXTA7fhwZrPe92DSjF7ooU+/?=
 =?us-ascii?Q?3nG6IqyHYsqeUgvBB91TzxbHWscW+bSgCILAhy490bvrHv07DENXWxN/TxJT?=
 =?us-ascii?Q?1zxNLxLermwxs/cy6mpjVnCevc1Btyei8Ea/AEPgyC7tda//0nbMidqGGiIP?=
 =?us-ascii?Q?wiazu2BclmO6wJdLLHm7eq2iA5/JmwXDz+swhJFDoPK5AeaO83vKT7JvMq7z?=
 =?us-ascii?Q?9SwWkT69ugp8jhdmp2ugiz+yD2yK7alpVvtJeI6sTH4XRtCaeRtEnXzbfCOW?=
 =?us-ascii?Q?xOQlnHEjeqV9mO+LMPtFFod64VTKd0QHCsVkMXeAwJSxpf+97tal7IewgsnG?=
 =?us-ascii?Q?AA9w8Qk2FmQ6R0xsRvG6N10VYxF36NrYMyMO/FxQTk7+00bxATXx7iXPo7Ky?=
 =?us-ascii?Q?bSADiSVAVhofobgTJLl4cb2sVzaUY4GJhA+7fMfLIzDNo2EjSguAQK1LMSDs?=
 =?us-ascii?Q?85EAIoMvf7AhRRe/ta+2aCQvBwgqfnXlTkmN75N0OoDzgm7kxuml10X6lp09?=
 =?us-ascii?Q?cJQd61QbErA9P6rpeS8YaluDf1M1qrxQBnCWc0zc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621ac33d-a1cf-4aff-edd4-08db08de71cf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 07:39:29.0002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2ve9x4kaPcnTUyEvnhEW/Lptsd2b7TCYl6lVHY5OA5YMvYcIychuGoSA9aKFiHgRoX9pXeXI4UbS1isHfg33g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7869
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:50:26PM +0100, Petr Machata wrote:
> A total of four new bridge attributes are being added to the kernel:
> mcast_n_groups and mcast_max_groups, as link and vlan attributes. Add
> to the bridge tool the support code to enable setting and querying
> these attributes. Example usage:

[...]

> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
