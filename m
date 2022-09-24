Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804585E8EE9
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiIXRYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 13:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiIXRYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 13:24:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52C53E755
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 10:24:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsUaYZ07gZnQJeLmcuKT8dvVjWBJFgJmR+njI5qHt8e++oHbj/V80sTxbxvadBKu4cByp2MZbcL/cRXG/O4S2mQN2OnomR9vPXkYK3jUMc66qYLc92BmUAd1WnDIdKVfP6MYzLaStoQHy8e+G+rVPQo9+4RutcLDIA1TkngNX+EtLzQqQgTfuEju87SSLTP0zyq8WhnHUyY58+SqnRaBh4mcy+9ViwQV3OI43Tyv35Y8nK4WaBB00yyJNLb+R7l+Kv8WCuAjiIlesUmZD+mHeEFoUZpMNUIPXT42gC4hmnj15Yfj1A2C8OYwxmp9VVUh03V39bUO1Qd2z17sT8YoTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ut+/26mdsCTvQrY3UNEgkrl0pCY3hVGaLcHrm6KJ76w=;
 b=a1T24VTXkrsmc9gaWJtCSPWBake3XSrrfygwZnLdC1gdELkmBfkImWHrMsvLXTDLqFOyYIENPP7ChE/Xw1oUfVOP6TXZ34cL4ucW6KMhhKud81enTa1CzzQ9vfzpzq48hsLGIIKTiSW4K/gZ5W07NwsnXzvQvKLlaRLgnuXjlLT1XaBFvluzNYvpV0uHfR/a2k6jvbrpHwiBR+UWmmhc2qDWHtO0NDwe5qCEkfqPPE31FJvcuDe3kocFS4b+BX4s4hRFyAQLmwabLzOFOA9TkVnO2hfLuTFYr71Tu2q0PF5MYe/WbNpE3yuw274bbFmnDTF+Ypazq/ayKRqU20FevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ut+/26mdsCTvQrY3UNEgkrl0pCY3hVGaLcHrm6KJ76w=;
 b=rKrna7OWO09zf2l75AIhDgs7uPSTSjMwi4Tj4GSGrccviKXGf3TYS4hK/PqNlgTSmzjdRHMNrgpSqriYIsjxtdZHT4isWeEh3wLfBebItUNj/jm9tjwxncfPXx/wupc/wIJs/iz6hYATj4DTUdd2xXV7IjwXFEulM/kS9UeU3Eo5SFGd8B7yTnoW5qjtbDsvI/U58hQjYPAOUtbxw2T+XvxnQJpWDcG6k66H7CHfMBjjTaqSu4Id7pMj7DO2ZDUpGomAG1ivXkpRPkcuOlBXF9+bzMP3ndpTRHrj6mw2CtBX/8mqvVOESDoj3xJb6qyFgJ4melI0U+k7M8fDuCPs4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by SA0PR12MB7004.namprd12.prod.outlook.com (2603:10b6:806:2c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.23; Sat, 24 Sep
 2022 17:24:27 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383%5]) with mapi id 15.20.5654.023; Sat, 24 Sep 2022
 17:24:26 +0000
Date:   Sat, 24 Sep 2022 10:24:25 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net/mlx5: Make ASO poll CQ usable in atomic
 context
Message-ID: <20220924172425.bfagbky4h5tbcxf4@fedora>
References: <d941bb44798b938705ca6944d8ee02c97af7ddd5.1664017836.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d941bb44798b938705ca6944d8ee02c97af7ddd5.1664017836.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::18) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|SA0PR12MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: a034372e-11f6-4220-67fd-08da9e51a16d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ivZEc14ymJUpBUEIqii/9Bwb3GuZV7uciVlteAlrJee5pD2HX614jVA8rd7ZYstqJjg4sEyZyrNku/bIEnUq9q8Ah+fQvYgrawRzxe+y22ARQxhfA3qlWb7+wb3EX44LYCm9/fpx27k2afU8Qt2Un2BGkxRPcQ+NlfT03OGfcPGK7N1KFwSsAKW5VRWCL/MVpsBRScNYQVrKwZmOnRTc7nSFP8FJ39MaNoGTL7+xQCDcUItutvc+Z/D3wHZQY4xVRxPmQOn7DGS37O5o59rZBV+lH124GEvWQAv7f/N621cdqP43mjNPMxmIAbxf+WVatn0xPCPvSiza4H03BwMOlvHtNMKDbvT19rA/FF3CIcyDai9THoeq0CKl9z+kTSh/SVG4LzJ7qbkXBA4agDFbGLNPcVtT6+zeU43D2erqRiG1Ieezg04k2L8EILP81944DgvCoXE0mbuMwWWWwvl0/zw9KYRGo76QwYNFCp0GJvwwt+1w0klVhszxwbTAx2s0qMZbqdgGQ2LdeHJDkZoMicbC8gMXSkfMh1oPq8egmyvfMQ6/hkWx/JLBHZmwz3LJMu0I0CvamlaA5NhRizAo7xJK5+/6iUCXuJabDWVTybswZbNy7C1qTrWQyHhqPLq3XpT5RFWEwoZfbLkrOjfTN4+ebQB74k1FFgrgajxXw5zRrxA8ktGqcfSYtYvjLNO6WF21wgOyeATCKYdHRhQlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(6506007)(2906002)(33716001)(86362001)(38100700002)(66556008)(6512007)(26005)(54906003)(9686003)(6916009)(478600001)(316002)(6486002)(4744005)(41300700001)(66946007)(66476007)(5660300002)(8936002)(83380400001)(186003)(4326008)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+O8tmRvgmEOaUTdXGdb4b0AWogCmKP9o2ignukSKIJ2IsKIzQDuiix47J5Kw?=
 =?us-ascii?Q?lLFZHO8D8wmKOZy7i5eDjY65iVGmep/Q4NlaT9rfZv6epaDHQQt5IwPwee7u?=
 =?us-ascii?Q?ge9IjIj5a1IOuPs4vqPOwKfqftHFklM6xvlgHAuznkclUbiKu7sZ01mhUIs1?=
 =?us-ascii?Q?DuO84m1tKGOi7pH/tqLAnHVRzzncOaMJJ31+46o2r8MIcZynyaf8BxE3yYoY?=
 =?us-ascii?Q?JMWYRYXkeYZi2rfPC7EriJt4yFj2RBM5zdRGPAvugIMgGO4+oaV61NiYBkEN?=
 =?us-ascii?Q?iDaVr5xI4aKD5qLfOlICtmGeibpw9o6FCnWRaaRK+HsOllGT+2mqk3e3ycc4?=
 =?us-ascii?Q?SNr49RkNs0gb1bh1enb5n+UWR8MuVprhQenRgQItsu3P5YuBslL46fFXgI5w?=
 =?us-ascii?Q?CmiJxre61/kdWf9Xc76PTPVJqIdZ0UpvxJOzeuElt1Mc7bAJjEsLEW4SCwQ6?=
 =?us-ascii?Q?z9gNBYSOt1Xu6MQAEG/SwKolrHwDcuuaZxqeX4uiHBtc/hODZlO4N3Lq9aWy?=
 =?us-ascii?Q?/XPTuGrvYcVRo1SkA9QoUSAQFj9fRW8/AcUfH/NBaEik7G+p6SBnpoWid24v?=
 =?us-ascii?Q?lcyAvg7ymVqMo9RC0DLUe5z8wyPb93TsacuegmtuNRpT3XIVS3tvLBqBELbS?=
 =?us-ascii?Q?mrgbMPDYqJSXsGeBLZ0Z1lUEdP2sq9DkxWPcuKZ1FRCwMZmvW7IY2NosZB8+?=
 =?us-ascii?Q?HV1WZ/CHsUsLZAvS9LND46HfmAw7/Tv49P4sNO5hDzyoeJ92qqwsXwqQeLK5?=
 =?us-ascii?Q?YUKshMk9hkIc1tmInQMj93JkncnztFkPo04TAyxHIZeXJL+c9AvvZyvnnO4h?=
 =?us-ascii?Q?E1E4eIbzCegi9WYr7BmKF7ab9BBOS4dUluzzltj/g8nHLo/aoZv059z8WeGE?=
 =?us-ascii?Q?DlIIBhGh0dT135Ic5NrrQ88xmSFm1JcAV4GfFhUfoRklYJUc94ATAEFNdaLu?=
 =?us-ascii?Q?AXIodNKLvzxk0qUPg44Jb21h5Il/tpbHxRNdcNdNiWoDr0CnU6TZqcFLQ6kh?=
 =?us-ascii?Q?QpxPv5EQ9HeFWiNlO0fEpq+JuduEzOy6Cbj2Y1lFG77RQ6u6kxlOu4W12ABb?=
 =?us-ascii?Q?fCypBHcXVwAjy4EY2TwSd0iOMn4+rLps8nwJnBUnDVFGziSdq6Affywh9i1x?=
 =?us-ascii?Q?h0MKfMUYzyUyzegvB1AAUt7CT8p93UvRGRKSzwnHlDbXAYUmqrxGANOSqNHH?=
 =?us-ascii?Q?Fl5GfnHYWbEFgHuF4oTzpyc1kppUiRYHQ/3hFFnT0vM4fEG6xE0d6MA3Hy4j?=
 =?us-ascii?Q?xlGBq8bWLZHyWgaBGEV3OopdeQmYJSU+S0gMub9bDNJ10tho5xEWoXlHCunL?=
 =?us-ascii?Q?YNkp9WIDT+qFe8cdWMBhue2YDiwmLp1Psqbg4i8xWJH/kaNttnC3TWN5nuBq?=
 =?us-ascii?Q?IlA2LUWERoFGCQIRFaIqi03rSpaY6ZgV3y/26XbeVI0At71acccBl9eaQ4t7?=
 =?us-ascii?Q?y26AazMBWkP1xaiXFV+Mjv9UhxuCIe7EFOW2g3k5DXbekI63J86t7URiB9Uu?=
 =?us-ascii?Q?zUfQwv0T4RvUbPsNRE65RN8L2gNqE3TfANs7MOusByexz7zJtBPP/9FYQQFt?=
 =?us-ascii?Q?9OGwl937k45raSQIKWM48pa9gJAn6Ykjf4TU84Vh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a034372e-11f6-4220-67fd-08da9e51a16d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 17:24:26.6218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NENT3U8+UWh4mD9bEIqESZLpDX40Ysyt839rVozTUPYdeqCr/1WusskFRoimVCN2gIE6j459B7tdlmjirEkCLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7004
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Sep 14:17, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Poll CQ functions shouldn't sleep as they are called in atomic context.
>The following splat appears once the mlx5_aso_poll_cq() is used in such
>flow.
>
> BUG: scheduling while atomic: swapper/17/0/0x00000100

...

> 	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
>-	err = mlx5_aso_poll_cq(aso, true, 10);
>+	expires = jiffies + msecs_to_jiffies(10);
>+	do {
>+		err = mlx5_aso_poll_cq(aso, true);
>+	} while (err && time_is_after_jiffies(expires));
> 	mutex_unlock(&flow_meters->aso_lock);
         ^^^^
busy poll won't work, this mutex is held and can sleep anyway.
Let's discuss internally and solve this by design.

