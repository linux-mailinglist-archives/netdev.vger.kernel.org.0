Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0865B8F91
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiINUL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiINULM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:11:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456981F2E8;
        Wed, 14 Sep 2022 13:11:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ef1G0I/ZeGF/QzkLxPgTTZzZf5enCJSBFH6AAw4vHSPKOsxviue5Ss47E1KDKd345XjAh3EmTSrQ74tvUAOm2fPFm1pWRjs+euX3I66aCalRvpwruJqGqr9ChaKyTJmylAXymrVR4IPjAxJFuHsBs8Czz0SU1Ns+gvBYfzw/O0xfbwlZYBI1ibYikaIF2b/Y8LayRSJhuf1r4KlBvK7WjETm4Q7T8+bpRci1vuytLcyeHat+2/4e9ZIDgHPNnFblePoy6yJXC3/4L4wuP7LqQpGQc7nX2phOhIcP9g4TBkSXQ7O9dptHU804h7m+G5tYroLe7SfTx1O2UEArY6xaVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dDyZEQ30NlA/FfMNm8SOXygbF49WsSq1QsMqVBksxQ=;
 b=IcFCtU7EcYcFHeL6pe1rNS2dc7g61gjXOQU/1YUXZ8wcmDdWx/hbuLMlJ5/8mgsAwJs5/d9ZJpKVny6dHnxB1PYNu6lG32I5CJ0sLNkON/Qnue7wMZWMj3PBdRNnTNWpOgBC9Ix/jlDHwVJYAeD/uteW4x+QJIhuLl+/CqRuyvmLnaD8LQIumacElIjlt1RwwihvaVjFknbQIvhElryHwgcjm4tDP34IKUK/2OtTZ9XZoH7n5ba0XP6f8T766046npRBiw9bFjOu9l1rr1cAVYe2rJk7MEeZB4TC7jWmjx9GpP48F7dvGOpSXT8XzxCQtkqdmQDpcZLUKL8L6HbfgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dDyZEQ30NlA/FfMNm8SOXygbF49WsSq1QsMqVBksxQ=;
 b=LnSoQB+kLNHDQKP5FbPhMpRI65UsYhUaLAEih7f+93TFm9PnAL8hon3FwsLGUAvfRIyCT2ZYg1Mmeo/IPCLwr+K1tz8FJb+3huLpbWjn0ADLt6umN8WH4BXTg9UoW8c4IfSiUd8Ai2L5bwpkqDHjCpCV/YepHrVeXsoHZFmsd4yXvAQijdWI1tdMmLSR4qfK945OuSiNAaHELFfvO3EVpudRXM/6JruIluEWM2tix4kFqIPQwBMRHMLLjkatjXdhzlQMfo0RGByb5WYYUxRboi7MhczHBaVC2rOpii4b9Wm1ayK/Kr8UZlXIozbqBi9cJ+RXN2NhlHMEg3giqPNiug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by SJ0PR12MB7065.namprd12.prod.outlook.com (2603:10b6:a03:4ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Wed, 14 Sep
 2022 20:11:03 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 20:11:03 +0000
Date:   Wed, 14 Sep 2022 21:10:59 +0100
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        liorna@nvidia.com, raeds@nvidia.com, davem@davemloft.net
Subject: Re: [PATCH -next v2 2/2] net/mlx5e: Switch to kmemdup() when
 allocate dev_addr
Message-ID: <20220914201059.vuwrllkdojkt32lc@sx1>
References: <20220914140100.3795545-1-yangyingliang@huawei.com>
 <20220914140100.3795545-2-yangyingliang@huawei.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220914140100.3795545-2-yangyingliang@huawei.com>
X-ClientProxiedBy: SJ0PR13CA0193.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::18) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|SJ0PR12MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: e43176d4-ca7c-49ba-4dae-08da968d3fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ebMvk5YREsFCKhseTgmwxPTBPRdXcfHcc8dBxCRWBfBPnPF/X8/8cy6sJKbL+OCjJkWCKAxsRN/fP38NHcWoz9tyRc2xWR8aHMP1nIupV40JuGmFLlWpo97lYpu9yNQ4jGHTNm1fjQiacnIOB35vgBnHEF5x6ydthoJ9ebuu0sZi9logNBZl38XwpBB1wPbRgyuxkFvltgFO24SbZ+b19XhSAyVAJsf4jh+9GpqMfgyDGVFlxE5yIZZp+dzAnQCdJrqNAvA5G9vwu/0VkpcyusobKEeIet0+MKArRsyPO9I09RRAHvZ4/IDydGZW1pnph8lsNSPWm49lp1ZVMwbczJxkVN1fLKVizz1pngyU18EnGAqEp6Xt4Ixz0qmQYPX5+Xslpix0d8mGSYFHHCHwhrBXsDVtMaETCYiwqO7H4f69H5/iTccCTC6TjIArElmo4twiVYi1k2OKSnvqJyYGz3+nH5FSMjRjpWLGO/H/r6lTUOWP+V1Vj1RUzbJDuGRLrvVlVxpqCSHC2oze6wqLnjHGc57gZuVxuCmUH6tkkExWPKH2Qc6xMlkW5UzT2h15XLhKfCvZF9VU/xHGmnfrdKDSx69yCHQiNQAoECHsk9Ojd0Qr93GIzHK/woDFvw4QX1kDpg+yO8XnB1pkoAPH61xFw7cWW888ops5Cb91uqTdh773n3Wh4SWC7/SCcKlZiGEGHm0GRdU2EpEvvoCtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(9686003)(8676002)(8936002)(26005)(478600001)(41300700001)(186003)(6486002)(66476007)(66946007)(6666004)(86362001)(1076003)(5660300002)(38100700002)(6512007)(6506007)(33716001)(2906002)(4744005)(66556008)(4326008)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3VWZs/HxKk4wdHSojpwbKjQhdOr0LGZTjcLudtNj7GAr0SKbU0nT1f08JPpp?=
 =?us-ascii?Q?LIlJ0iWHELp10dbGGMNKb5H13Hp4khGYVwIpxsOHR//pMsJEpEP2MkQlBJaN?=
 =?us-ascii?Q?X5IoSZsQYVzMQggjAzt/S5au979xQIxcVWQ51PwkGGPR87DKTtl0xu/aYRiT?=
 =?us-ascii?Q?UnwGlHtk4DrlI563iaWwxtt4mER7lKV+Vfm+g0FoMv7HbzsehSkKpwGkgwhj?=
 =?us-ascii?Q?GV8TWHILyx6NIdRio3SIrZJN133KwHG3r2cv1RXC9h9iD8m4H3PEjPdtjs34?=
 =?us-ascii?Q?khmhkfrWrcRUUdCNOlLaV0ugkTiZyOhwZoW2a5dSvFL9Non6Iz8hULNIIazz?=
 =?us-ascii?Q?Eiatra2PpECaFJE1lUiegpOuIbbX6fGRVuBERjSyH5O0vc7q+gUB3LiCMAJe?=
 =?us-ascii?Q?yrp7Ntf+Sbvt/2Ij6bfVRNbUDNpVoAgheP6+mJceUE3JxfYvP1nRZbkFFEmc?=
 =?us-ascii?Q?+a2sve/Uy6fkT/Ew5wXe4HA1+v4MlpC+WTYHpzDfcgkLTKO/YD7y2SVprpVf?=
 =?us-ascii?Q?rSDgRRoWoaq+wbnIoydBz0dRkIhkYFdq7tlv92m9UX3q41gyLm5Dhu4FLlob?=
 =?us-ascii?Q?llHG4zPMwr14T1QKTlA0upyooIyrY2yRZCif0SFZgWxpi77Arl80tyMoXCXw?=
 =?us-ascii?Q?eKrgS5GtTYWrDowCIiBynzrn8LMpbJUi8bIX/+8tHrqF/g/hBSy6cThgOCcH?=
 =?us-ascii?Q?TGJOTltu+ENrUrXyN3g5nXyKj60LmG1pvdYb30+VIP/mxdFesj4QNTwQ3pcK?=
 =?us-ascii?Q?9aqIebNo62eztJmWrpZGaUBg11t7lBt4UWXQcfFuNSX+4keRg9fss3voe6xs?=
 =?us-ascii?Q?PNRXtmRm+11KzR3ltD+jKpFGSkIPZUXeWkImFSDx3qCO0xrnuNaHxF1GzV0t?=
 =?us-ascii?Q?9kGBLaY2pK9TqxkGsRHKEWdBU8LcH9Q/nSTj+IedaafYedJPqeFsZ8OjJp2z?=
 =?us-ascii?Q?KSFxg1T7o2qQHsNGzEP1BXPkBhNvTs6bFDhaoRdS6REOveHEq3TNmxwGXnIt?=
 =?us-ascii?Q?zhXIM7Z1HU2V35wF20ZRPDCL+20w6LuxNkSOIRRgBWMn0v2Zj0GNj5X+7KL0?=
 =?us-ascii?Q?dezFR3wQZwzKLO0cuWqRKgqt7s1T/5P02erWzki7GwVVtpI4Q5twqZAnI26F?=
 =?us-ascii?Q?hFA0Zcmeac3jl9XQzLcl1iaXGgTPmSfCquePL7CDgDD2hePnYmF2DOiwUEQ/?=
 =?us-ascii?Q?X+B8W6c2Sa9ZN5+sDEAAHe6SRTFdfz6ClKxeeaVIjUfszZmlP0yeBuiZZGAA?=
 =?us-ascii?Q?JxBvDdGHyju8flq0K5x9ZrGMRRBXa+ZNqzJeWIflAo2k+xJhzKE1iD+P6Ksp?=
 =?us-ascii?Q?jj3hTlW1DfzO4LmVtom2q5Z7F+64KiLjGVm9UE6fdU76MiqhbRbMTwAR/rOW?=
 =?us-ascii?Q?y+X99RqzqRQksGkn/fA+BNhSrJHNiZdl7DjvQhaxwpE/RxaoKvD3I+imvU9+?=
 =?us-ascii?Q?I6juOBnovj8K48mapiapISkpjrNlYKiaXsB0szKDjA4DnxXFjoe5pKygy/eq?=
 =?us-ascii?Q?bgtPUEPFQV+TjD8Yl0GnToCino6cfIesmPMjLremTtm9HOV6Ec+PWxmv+iGG?=
 =?us-ascii?Q?xNLPQRQLlAVKyXeVXZNGRz43wW9rGt+E4D0fRaa1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e43176d4-ca7c-49ba-4dae-08da968d3fa5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 20:11:03.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CdR4njWEoL9TCx0nIn9XzjSXIO+ZY+GOGeb0HsM04EEoAulZBhnNMQ2FNycXIIi4YoTvTqqYa3MurolgbGJqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7065
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Sep 22:01, Yang Yingliang wrote:
>Use kmemdup() helper instead of open-coding to
>simplify the code when allocate dev_addr.
>
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>---
>v2:
> Make kmemdup() fit in one line.
>---

Acked-by: Saeed Mahameed <saeedm@nvidia.com>                                    
                                                                                 
netdev maintainers please apply directly.                                       
                                                                                 
Thanks.                                                                         
            
