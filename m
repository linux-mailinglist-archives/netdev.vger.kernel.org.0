Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01249D640
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiAZXiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:38:54 -0500
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:12197
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229565AbiAZXix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 18:38:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuzhqCxgmZuwKBEh2K3ZVrbo1xKaExRvprRW/C1sGhHK1vKETXJRhzmK3dKIrxaIdCH5x1GxzSDWSxnjb1FNegUmKcjYzVWiWZlmU6lwqdLGSYFi3c/7TioezAaGL64QhZEkfFxNFMsJxvuuHCxp6Gw2RfSi+1Rgl7m/H/tCdg0UB7TMwWQVVOeRBpkhc8EEFeCI/IxUiqJkrrHrIwQDMilAmWl+qBp16c0je5bOec4LOUjcwRNOsAjLjv90AsnpZMKaVFBjCMe+PdjzPn1bp35uy6S3aZhOS5JSrpzByQMaxQvI/K39ETPJVSfTpaXCb4iu8B8e9Zq2lWFUWPIgKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+4cs3KjPvyhfWqs5JY4D1/qfZiDokXylAkTGmyY0qA=;
 b=GaSGgIiRe7FJ/2EfgebS3Hl0hrOhhhcTN9fNTjUide43NJHSlj2J0o7fn/GmNhEMTbGwlrM016LvRlmlhFilYbNLcUN7RptukcAA99ddHI0IGAMFslqKhJdflhmnm8K4O2Bg3j4aBYsEuUmQv5fGHtnE8a1kFcYdiQGAXJfeVIv8lSt1un1WB1bM0tJcr+VhANrD+I4XRMjfcvD0+ubAOMIrR4cdG+nXfmoTwArQM8wgsjl2eNceYmwyoHsEooMwdK8q7/Wmvr2K3uAESw937xHBI37OSm3rUiGguqtB8JDf1SifLgjA4JshWBXstQYFbyYiSbid09/Z+upu7xfkXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+4cs3KjPvyhfWqs5JY4D1/qfZiDokXylAkTGmyY0qA=;
 b=C9E3eOx6jtvyonq1uhdMUiLhQKFvQe/f554AFjDEP8Uh4uTNoJE4M8hYWLePlvm43dcisR3WneXijbnrHNoFTDcQzVNyXAFY1YUBbsxVgYAVscXckUfn+Vh3qslJ1j9Sv7Vh5C5euagUTBQB7FHlsx1UvIbOD7CpPjEP9Jje8gnkkpkvLfJbO8UU+WjwH+5GHJk22jjXYzj7s6J6UICjvRByJp2J8n76iNhfZkSwv9FhciyaqpeXR8Xsjs7WJrWU91wvLDK7T3G5UT1h7ZzpJKk/O+lOTuN5pbrgO/wPACqt8IwzkmZxucFTJs5MtNg+z0Gf8q+UKyTOBb3T0+fhOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB3312.namprd12.prod.outlook.com (2603:10b6:208:ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Wed, 26 Jan
 2022 23:38:51 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 23:38:51 +0000
Date:   Wed, 26 Jan 2022 15:38:49 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND] net/mlx5e: Use struct_group() for memcpy() region
Message-ID: <20220126233849.3vrmx4n4jy5fzu72@sx1>
References: <20220124172242.2410996-1-keescook@chromium.org>
 <20220126212854.6gxffia7vj6cbtbh@sx1>
 <202201261452.97A809BE9C@keescook>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202201261452.97A809BE9C@keescook>
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d64b28c0-3f59-4d3c-13b6-08d9e12501ba
X-MS-TrafficTypeDiagnostic: MN2PR12MB3312:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3312C65DB3091816F7472E8EB3209@MN2PR12MB3312.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7dsPC3tBj35j4wsDAj7psCIu6PRHJN6sO9DpZ6/+DZLJxU5Ixh//g+EXa4nN67u49isPhFAtUfv3yLnX91mnQaVP7V90KdLq9NadKwStmYSjCbZFpJrej984lDw7Q1XSnkPe2RAEpig8NwJB9rcpxpdrgL5aLMBc/7c8DReKxXQSp0EZ8NkApIR6iQrdhPAlMaqv5qp4Qsbs6YJ0+zN1SOiDk8hR+jBMU6b26T0hpb1gBG6uF+ZyI+HqtTKxzwNDpOu2uufdWNnqQoM9CHTaklrOwtlFLFdGmxS8b+69mgWNreFS9yGeBQwEvWb1Hrjk6nZF4vg5/iQ1DKsxP+kdFcyt1dTVv9RxRoCm9uSyM3Hard8Y2hW7YzXb3ww5CIfupgi+izlQJk+0KCcBd6P6MYKb9RSEMIxqYbj8FDYN+ohkIgisbZObGGk8rajAyJV+FQBcek5T8yP8hHdorVh7GjyDWkKVM5mJFl4+jaOTwoukYh1Zcrq+TWMdWwv2FiP6ZoLfcEfWqbfkndzRVG8fcL9S0uHlCcbqASbVI6wZUDCamQ0BgqBYUcIgRNjkMvfRRCKE4vS9npic0G97/YjYDXhJmQOsGXpXZktszKREZ8WPEnU/GmRyWGWBPtGmLfhMgNVE57AvnftVAzuDiI/5vtLmIP/aO+vSuv0sx+lgsffvF9bCRaGsnk+3AW6txwpjNkGCdOgl/itIoSd605nGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(4326008)(66556008)(66946007)(316002)(9686003)(6512007)(26005)(54906003)(38350700002)(66476007)(38100700002)(52116002)(2906002)(8936002)(6486002)(6506007)(33716001)(8676002)(558084003)(508600001)(1076003)(186003)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x7UHcsvBO/0Qj7HatnlsBDZ6SB47PSCBRL8M4NIVnCjilRlHBmQluUgt798w?=
 =?us-ascii?Q?cFUQVPgyw0m+cGRdZxtd5zI74xfWdrwfQSficOvpQ2wGBXyI4NgZh1IBU+Ye?=
 =?us-ascii?Q?rDMNHRSLcmeIiKqBEDeUWckYKnnKkW30dp2yb+FzmOvuYyMMCNDXnrh66iWL?=
 =?us-ascii?Q?9NkOaIKBlPYQ0qEhEybfxZwCwE7ewFEgEVsGGjqc5kammYa9VC16LR89hl28?=
 =?us-ascii?Q?1NcGlHX96Q4BPwB8LlLdjFjvt0DAzShr/ipZjASyxuJeY4Zb6scXtYIXJeB5?=
 =?us-ascii?Q?kfH45RXl97rrL5zkllImIjHzSyNloTNSTr+3jgk81quOHyl7wjKk4JE+HRfR?=
 =?us-ascii?Q?cxbDE2Mhc60Rk2cec9spsL+xVE3hFNoK/GaQai6GCKAkJyWy2igcbNaoayc3?=
 =?us-ascii?Q?pehel6yYo1DmEl7TvhkSpjnZqgXJ0dgXRdf6y1EX+Hc6InRIcEZGgsPJ3Hid?=
 =?us-ascii?Q?AOBuuqaUuamQw/dXsmb7BFU/OaG0fSUnbiDnc9O33jnycArBjYky75BjNQAu?=
 =?us-ascii?Q?gaQX8OJ+sq37+QlGTOpLKFfvzArZnEdj/0TS5cAOyZ3ZCcVJG/G0SoF+umD2?=
 =?us-ascii?Q?yoeO3WRJYe+2lQre+ZMmpqkIt9VoC11lAgfipXnkEb++iUCSLqlNW1mtsJKG?=
 =?us-ascii?Q?ja5QESFDE+4pAK5ZUhvNrZyKrHLdWdqtnO32QDXpt8PoyD8vJSedbpyvtj5J?=
 =?us-ascii?Q?EG3oRIvqbnhkm52/o7xdUt9TUSTpyB/TUdiSo3xff8GGEXusUBqY0ejME1Sa?=
 =?us-ascii?Q?hJKQJmi1TQRKdDwcxx2pL968isXdbY8MQPMOD9L60ZyNoc67wpTYpfe8R3Lj?=
 =?us-ascii?Q?Or5HkgAzu1kD+rHi5f7J2S/0A9FVg6O7dq1IgLn06KdjRtPK1KlEuDE+rN9S?=
 =?us-ascii?Q?puYFjToUtuNn9daCkHHGdesok3PYdM432CdyXnGHIE2+9pkgVrAmfQpChCXU?=
 =?us-ascii?Q?oXLXEThXV2HUt7b9JJ0MgJo/YF0N5D+TkUn0FVwF4AiI/qhhdGNwrzQbkj5j?=
 =?us-ascii?Q?lR8s1PvN3FahG45JwbXJ5Jdm55tTvUyqICytUnEG99hepl0hED9ucsqtK5pO?=
 =?us-ascii?Q?hT+IQp7CUkUhSX87qQzNsfkXKxpGwkK6S0Rz70ZSMlL9iIiETPi5HiOEEoig?=
 =?us-ascii?Q?Yn5gTw6MvGl+vBNsWmPEKO/IoIKFaeDN0A2EtZIGOAzJLcRDAWFeBA+JqBIM?=
 =?us-ascii?Q?25oZ0Aw+KGsbregJ6smCupgIJGf5tJZCx2eAwinYrLLzW+70VQ/EgFAfX90t?=
 =?us-ascii?Q?1l1EhO/ZAWQu624eqTq+ZrXA037Mq/06pdKBr66cn0AI7fGLQ3PW5Jari5gE?=
 =?us-ascii?Q?NKgTGURuSJ58OzSCDT79UdwSZj0ne5B4Mr1c0ULKwhRJ3GQPRz9Qq4sXpIqn?=
 =?us-ascii?Q?SRf08FX5mkEs2qEHOA54t8L0TZGl2MUpMXjHMHa02wRptKvCLSFFqiIw3Bu7?=
 =?us-ascii?Q?qVs3WZ6aT+qccCG4Y4ClRAk6FXHhsYlu4eCgxGV53rcT8vaOla86MAamK/N0?=
 =?us-ascii?Q?goCJ9a8IzRuY3xKaQC3oaP3i56P/h2EvUSToIZb8ZaGoZGaw9DtT49AkWG4t?=
 =?us-ascii?Q?IVaa37hDydLlxEvERTWNjHCF9ncOZsZMSrrn3J7u/H5V4MoS0RHnwGppRKo3?=
 =?us-ascii?Q?ldrYeJw4rl6RxYRoxy3YQFU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64b28c0-3f59-4d3c-13b6-08d9e12501ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 23:38:51.0365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C20Ii9jZuM/JXlTr00Psl3tD2XBDoTrqC71RLVVdm0gFmOxuzfV5OinAJCPRSolL/g55r7hmT+BRSPCj0JOdRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3312
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Jan 14:53, Kees Cook wrote:
>On Wed, Jan 26, 2022 at 01:28:54PM -0800, Saeed Mahameed wrote:
[...]
>> applied to net-next-mlx5
>
>Thanks! How often does net-next-mlx5 flush into net-next?

every couple of days.

