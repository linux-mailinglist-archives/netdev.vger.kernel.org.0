Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8B5578D3
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 13:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiFWLii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 07:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiFWLih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 07:38:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EAF49F81;
        Thu, 23 Jun 2022 04:38:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvfocXfBWS+BvSZop8ByxDNJpJimaWFNHvB3Kv5weecgCkVkPtmcDdL9VtSvos44A3PIeIYtXZmUiLtpT9oxIrgCLe0QFt10n2Qx8E6eGoD+vsFWKCSujvGWXHORas3HZV/KdSFkQ6O4gxfSRHLPv9u1TSvX7KOMNcdf4nbsomdVYcC3Do7/aPnmR37mT9kJEHqL8pDQDuMhjI+/e+a2kmMLXeNYsO3pjqXHW8EhMdQr2nOhI9k3UiA25GurSs6jBTWnkzShfFzwVi7TEnbPAS9DxlQS9+VcVHtTubgc+TEF6euHWwCVUUSojm0YcS/5Zm+x3rlNaIVKAGv/S4wYqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZnTtJFplFu5UwUYp7KDaX9bi1S+5rCZh9xW0VWixyc=;
 b=A4C9MOFOTnFx5+0eppHGEI50TTiBae1NuxtPaTBkWbXe6mIktlFgwlTAkISNc6eivE5i/xc4MtqbFu8yqz7CpDXguDkl6Nnan4z+Zuv0XxYLEgur0u2jTHKPtZTMprqSNEMudRktlRoQ14G4xaLAHQL9qeOJ94sHP/n4M9LWugZV4LYr4eTxejG3B/pxZ7oQEnPdv+LDj+4h39ep3fzgDrQH6pi1O4jEWTMrzgbDgBMETRYWjZXZQAdbVWgYpx/4whRCK4flwv/2DWzskBqMy+4FJXJTo9q93QCu45x5jEu5KwHJ5OCQZwC3XlejW853eisXBahn4wgRhgBIN1cJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZnTtJFplFu5UwUYp7KDaX9bi1S+5rCZh9xW0VWixyc=;
 b=LRqHbsTLbrMequNa/wnx5z7h8Wh/tdfh8Ajx505nVrfanzSK7nyYG/rWJdsCQdFN54tTvE8d955CaJkzDJ7PBMYN/G8bv4W3LYJvUgLNvOOvw4wp3z4jWJYeGechu16JLAtnhuI3MsgN26OGKNlqPEoRDmHOIFY4voUdlUsMJ4jsGSybmeInpzSEc/NiHA34WOCyhG5S6ve4Sw9Xx+G/opMdADckTZY+e7c2OVZWiSBGXHxt1aBvz4i2zjLhu591Plc8nLzGwfWgOTZiL3eBoGCTS3fVkp40GokHZOf9sgxEORc1jkgwHvu5iIJp/bDfJtOmfb0QmIaVCqJSJabnGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SA0PR12MB4368.namprd12.prod.outlook.com (2603:10b6:806:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 11:38:32 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 11:38:32 +0000
Date:   Thu, 23 Jun 2022 14:38:26 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: drop unexpected word 'for' in comments
Message-ID: <YrRQssdIkiIalC2r@shredder>
References: <20220623104601.48149-1-jiangjian@cdjrlc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623104601.48149-1-jiangjian@cdjrlc.com>
X-ClientProxiedBy: VI1P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::44) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb556de-d7c9-4302-44c7-08da550ce66f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4368:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB43682925638B0417B71A95F4B2B59@SA0PR12MB4368.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WvEO+yRBeVGglf4MbhRETskBVobso3vkqwinIwB+1sNIHhFGQfPKt3sNJoe9IIWn39nvhbdzSOgAk2BemjZoFGtqLxKV/nBoW3aGNkngY9Ym6kBVKjIMA3PfcUR1/0mimuyzHTN7aW4ytpapTUKzbCGnYKbwm1FMfJWi20vhZZO2AyARndLe8jTRkFZAiZJcnMoU2Ju4c6LrHh4IWNJKeuQkldKrWrqpgke6EY41lcWDfhmP4kXR509t33NmMKEy1ndnHGPqFwYA3DXBn/+NJhoVj8qf558zkiLXL7cDPF5ONcf5H7tMGHQzRsmQWvfqNoth7O2hI4ChsPxZlkGsD5nlvA+M00Ife+HGcatSCLZ0Qfz+hbIz9rXG9/RERvtRTL+cIEAPYtq7X5laCFmPBIMZxRxMUvy0AxWFD9e7Cv0s2cb3MkKdBTGgoNsiDj/EViYhiox2j15duKOw2AlsaLq3hYGit4ETw5LzjBj8ujIEtDNWz3uY35DYICIJcwjmf5HBAlL06C6cf0T2gEMlFIjAlyCW1isi2+EPyQkoJGKGrkyHh2CMB8MtoRkNIrTz44PzqigqPQ0yuXbOZ0mEa45BbLMZXyM3sM7A/EA2wLikjHnKJ4IO5msmGP0ncnIPk31jOPIhneSY007v64iJ0DQ62d0f4pOcK22oQ5kHNVLBvEpxb0/PuTSJsbEJSs91bhv1FQ6oxioFGwrXJSQZ8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(5660300002)(478600001)(8936002)(6486002)(4744005)(33716001)(6506007)(9686003)(26005)(6512007)(186003)(86362001)(2906002)(316002)(8676002)(4326008)(66556008)(66946007)(66476007)(38100700002)(41300700001)(6916009)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4wgU2tG7jGs7LHu4SAptK8LF7DIxVC02TZfAVQ6kRAF3wOnYxwlSFiZ0KDIQ?=
 =?us-ascii?Q?jrhSwfmheOM7qXUVlBnD+PZBd9wMtVZLW/gbkzttpPpXHb7dzu+UWBtLgxTD?=
 =?us-ascii?Q?0/PzK4avF+H4vX2Lf9YiQP/CVvnOmI2pFcB5OPKHh89BJ/HaghtRsJJqCR/r?=
 =?us-ascii?Q?xo4AuA9TVC0xYV+Uy169/E90NoLZfHzKhBTvrf+0ANT6NGsTV5uecDaTPZb+?=
 =?us-ascii?Q?J239HY0wZRhB/T0mUY1qwt6x+0dp4OKgKFHcKXTBmtlBaiUmN3UxjjZbEGnw?=
 =?us-ascii?Q?X25mAE+HPooQ6rbx867ZOeXNDf2mMrpxUgoH97lVoqSn5asUJPAH/8VeLO54?=
 =?us-ascii?Q?9IUS1hLDL5+yeo2OeLpv4b+MXhGIT1+snh5WcGUAOP4TwxZS6U462yI8NCvT?=
 =?us-ascii?Q?migk9yYlgRCnUzTd/VrvzmY3DSLrb9IENj8TuZiavWRvuNlN6MPhGL8xddza?=
 =?us-ascii?Q?WPRAGOp9jeAu8/a6O/41Ih03NGhTo1j9cpyd2DuWPfk71b1BQxGD56Iy+u7Q?=
 =?us-ascii?Q?NvL1n7UC8JIxyfBZAkdc4Kuorpps6u8T8UlX8KGdPQmeocKkTqC/8BxuRJ/R?=
 =?us-ascii?Q?dzqc6seuGVFeEidiBjK6AXJBLxg2EIhTdA9bWDyjsr4xccXZe0LNAnNM3vWY?=
 =?us-ascii?Q?cBhDURFxZaIqbueSFUosX9t34jeWUOSl5qZXUhcnPsLvM8PerWLuPEgkH9XX?=
 =?us-ascii?Q?FyttKI5KpEkZlBgTIF1aHIpHbOFchIqDJL7WSN5UQ8arR3c7KuUKYgn7l5pq?=
 =?us-ascii?Q?Az53jOVu//auzLJSFILIBBThbPtkZ9rq2yvljMx/eQYjr6scki/0scRMwqKx?=
 =?us-ascii?Q?hAlEenIUxyaLU4Cveei9WcAHVsjozZMA6UhA2+TQGGO9YzTNsSkgSJQ1wd7i?=
 =?us-ascii?Q?nlRIx2PI5Wv7ZzgLTGqrH946Bhym5sC2S6obW34eq3UaV9aYT8Y0w2V+2ZOT?=
 =?us-ascii?Q?pFhl1HEQzryS1SNnlTcQXaRJD7O2F7c72tqGnwn3IGpCYmPJfAA/EMQyP5Gw?=
 =?us-ascii?Q?nIDPm1yQXpjNNTQlqFZr4VLcxt/2t2Oh0fyyZJBA5Pm7K5FRCkjIM0EJD8sb?=
 =?us-ascii?Q?YiiW4VyFfOfcu8s7VVyTX6SJtaz6aRvLho4hnptbY5ATLg0bsgbigRwFbgeh?=
 =?us-ascii?Q?6jZLsGd58ujPP4UmERio5vckq7a6iXA/2l14a5e2VeU7CNkVSOFTuAuvD1jQ?=
 =?us-ascii?Q?DQ6fgeXGFXNjImEfcclMrw1hIvDW7/0WM9obYdqMJ8T9NleNXx8rD2FsEXNv?=
 =?us-ascii?Q?3Fy5gvEGtIaCdkKme2EASTZMnlYlhlrKp17xEDyMrdzwzZOVVMe1BQ/QtbFu?=
 =?us-ascii?Q?4UQ5YOIVQQUsFoH+rrtK+kY5vf99RMwsp8B89bAl/uUq1JiLBAkc/LOM5pUY?=
 =?us-ascii?Q?Vyb5gtjV9xh81CQw3bNjnmOE8WuhRwlQLTBxR7zcOycCNywsyqAcHcrwn06Y?=
 =?us-ascii?Q?r1LgMZDw1sNxtn6sONzea/gQRktYJDz/kbEqMINrt0nBF7BuBHBlJ9p3iCmT?=
 =?us-ascii?Q?/5suim08Zu8YE8INl/6KLcqLyKgWRyfZsKgrr1TfBq19/+ryPPnrUDz/CP9q?=
 =?us-ascii?Q?SypFrRR73cBWYocZQ2hQUTYAI83M7JNuh3WpBKg+30uqFxHxtC2otogH8OBg?=
 =?us-ascii?Q?4nO13TIDiNA7Pt2g7afecPMa20/KLWZZ9Fft6Z2qsbytE9uMh0DuqOufZStU?=
 =?us-ascii?Q?cMB4BN46kPuqIxWiD6qbQVXFgpoiScCxnNqiNO7Uo7MdY/SagTK7Duuj+AAx?=
 =?us-ascii?Q?vsoi2pkwMQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb556de-d7c9-4302-44c7-08da550ce66f
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 11:38:32.1162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uv2exCj2gGncqswB/Wd5uUvNrktPMJbA5rNGWXBBKFvjjyrsac71CVNIbvimKT4SEiMvRdF6bqx72OdZbR0cyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4368
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 06:46:01PM +0800, Jiang Jian wrote:
> there is an unexpected word 'for' in the comments that need to be dropped
> 
> file - drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
> line - 18
> 
> 	 * ids for for this purpose in partition definition.
> changed to:
> 
> 	 * ids for this purpose in partition definition.
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>

For for net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

:)
