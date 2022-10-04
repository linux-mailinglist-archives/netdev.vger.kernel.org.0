Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223005F3B19
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 04:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiJDCEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 22:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJDCEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 22:04:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2102.outbound.protection.outlook.com [40.107.237.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E007C49
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 19:04:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGSN305AMPuhOReXmUlBYFSI8HCFeqEZgkdrZ7LsXknuW59BqjkfkPdmvLLmldWMt4k5L4Wq3B62RG+r9JrwIZqhGyrAipIC+2u05f/j+I6f7fmmxiwCkcWKRjsK+/YdP1ncHvuT6Qw9fPDwcUIldq8w30iS+XJmEeo1HpmQ0cRzSqamOVFccp/2UCSOCCVnHnAJWAptqx30ekL+zIVC+ECS9Ta7gPDNIEHzwuX1oZebp00Q8houNjbBHiGGzS1NKCF5SRaey77Vf0OjczWJ1i6pMtLSPL/xS2C0U1qWU1whUQIaWm9ATQoUtQg3WYgj5NASXBVMHwZ7VODVrBgvbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ec4+3FsyZJ0pC18O812wEthebgi9JJu2X8QQNWnCHMI=;
 b=Sqcgan6lwW8DkTt5ijGlT3hUxlEaNpMvLBqcL/loM4O70t+CEsmeuFCtTGgyQTdrGPno7QEXxYXwmsip1W6scOxmckQMt6+8lhh4vQxnK+aHtpe5i6gD4YNekPxvhNu6CHe59ny8mseORm4gw33em7L5+k/wxtwFtwXOMGtnABOKw9VakqX9HZPqz4tQwvqenGYnMaFaA0v+ojkH4VKskxLm7J/XWYi922pVx9NFeY5F8D4WmQZ24dThA0epdflzvPqG4LQ8U+bSf57Rgl8M+p1+9AIgXPkg04du/dVoSYtpL85U8m5ud+rFoqUlkAVEei0eaCjcwXAldaFylybmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ec4+3FsyZJ0pC18O812wEthebgi9JJu2X8QQNWnCHMI=;
 b=iq5QD4sbEsftYnCe1O8Q2nKDxY0UzZnQK2vLuQeEwnjPt2JhTdvJxJAJtpMUrdhw6bfuN2b++gMvDjWoQkIub8azCBAVR6S1nUXWV/kPkpqClIUV8XY6qjBiTIUs6igGCi0rqtqPtLCdCK/hzczlS/WStO9O1Wlyxn/OK4gnA3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SA1PR13MB4814.namprd13.prod.outlook.com (2603:10b6:806:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.9; Tue, 4 Oct
 2022 02:04:32 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::f43e:63de:d7be:513c]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::f43e:63de:d7be:513c%5]) with mapi id 15.20.5709.008; Tue, 4 Oct 2022
 02:04:31 +0000
Date:   Tue, 4 Oct 2022 10:04:23 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next v2 0/5] nfp: support FEC mode reporting and
 auto-neg
Message-ID: <20221004020423.GA27082@nj-rack01-04.nji.corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
 <20220930184735.62aa0781@kernel.org>
 <20221003084111.GA39850@nj-rack01-04.nji.corigine.com>
 <20221003130149.07f38aaf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003130149.07f38aaf@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|SA1PR13MB4814:EE_
X-MS-Office365-Filtering-Correlation-Id: 557bf2d8-6840-483c-f7a1-08daa5acc6e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: joF99Ux+6jhAI+zWjaUhRqoeV0YkiY+Y4GsycukmiOKQZPWcRPc26fJlKgRSuchSvcVDQbax7EW/DoF7QVK+RMuv1wk6OiYAwIFRN3a51xqCI6gv7WZA2CjJr9oddyIpwL2UB9cbS+eWmxla0AzUzx9xQHgWLv9vM/YHZmoZGaF1HSzkemy9vTCHvUtkMkCCPuktKTZTAw/DwyYrQM8NE87NevxirOB3zhsXK05qb4vyr/QIx7LaNPTQR9iGX3DhABlxDwA1ZMGfzMC6ZUy1/TU1W8xvC10VCHL1Ft6Z/tucIybmiPAlimyN3h9Edg0e+l9Pgr0fMfGRYq7wxu7pWqZ7/s3NI2XRX7LNcX4wahdPUSmFoeMKIHYUEV2Z5UbI8i8apJfTbI0fjqDaHwRIXthOyFSZx8JCu9FK32IRY0hQTtPuZGBmxgn/uilBQam98P1dNYBS8obYXh0i76n+OfVKkVf+TlKxEbDGb5FztW9X6c99Mpvm5SzxnN85ExqI+Lehelmd7c12HnEEeo603TSndxjPHa4Btj7AvPQWKakZi8hQMSw8FxW7sQgSMxvXi0Fv07NESxAe7pOhe4rxsK99tJ0HIC1X9kdasOQ5S2KerT8m6u12mqKmMg9JPb2qQAZ+L/AwYkRU2RAXHFCDU/198p/XODKw8gN4U0KMcJvbQJYEIR6XhFz4+W8Wsku0Md5vohCVjvZMEwgJqopAD1S8i01u2vzZFSGpJrFPsc7iACNkxtkPu2XvbO1BRs8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39830400003)(396003)(366004)(136003)(346002)(451199015)(66946007)(6666004)(107886003)(4326008)(66476007)(66556008)(8676002)(6506007)(52116002)(26005)(316002)(6512007)(6916009)(186003)(5660300002)(2906002)(33656002)(8936002)(44832011)(4744005)(38350700002)(38100700002)(41300700001)(86362001)(1076003)(54906003)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zpjtqtsh4pOPbtnAgvXqdN4bjC5XxK3zQc2ynpQAzaCrA/vCyx5Zk9c8woHM?=
 =?us-ascii?Q?M2v9fZR4KIqwVxFIPYW9RpaxsszSdIaVAGcI6dTmmpKjC+wWH728LGVqSEo7?=
 =?us-ascii?Q?sF/Kz/kf0KPFv0RHVfgbmJu75r0EC5Ra9RF8dKX6qkB0PMjX59g3spFtdljJ?=
 =?us-ascii?Q?c+eB+VrKr/2yAwMX7OSY2O+q1zt5CwgXOlgvXnTbU2UELrmSSUFB+BjJTkSx?=
 =?us-ascii?Q?iC+hJJvtgrZjl/MFU5eXpgrLNp7lDmpMq1nEJ+o0tbcdgCrVMv9WrekJ6Mz9?=
 =?us-ascii?Q?4PMFekmvhKvL5vNeinq9AyrIVNIEXJs4wpfsn8QtLX/YyqVffI66QAcbmCUl?=
 =?us-ascii?Q?nSbHq7Vb92y8gUD8xzIuUMD+FhG0D/zVBhlzaYvjbjGMtTgsM+vZXmVbl/z1?=
 =?us-ascii?Q?xg6zkDd7aNzYuGl5nIvyUIetjDSJr4nNQSl9TmpHCSLkpUdVOJ8DEjzaaa19?=
 =?us-ascii?Q?GRrWb4yrVeUwvBf67Vevb4jEXR4/02C7c2F+8Lo5N8gj0+LOa5816wZgXsx4?=
 =?us-ascii?Q?ei6K2lZoUhYS+yCPz9Q7DY/2H4GBytMiZgzB0W/lGBiBrvLbmnC/JhvFJI7d?=
 =?us-ascii?Q?lM1/77ZJQoJCgsq9DYOJUtsDZxa+zPkYeQAnkHv1yaeBbv9FTi+9h9ETHHZc?=
 =?us-ascii?Q?YKU3JrToJ+DgT7tb4qO6ukfALM8DMC/dGvRTwNtvjAAVMzx+wrlELef1Gg97?=
 =?us-ascii?Q?cD7qt9ynH3dBNSWqJKnObdR+cU45LeTq6LBBANvXC3xxu+CpAjZPIV88LEdl?=
 =?us-ascii?Q?+sx7ZjMfsljjMiA4m2MCBUAaz1DS40BdM2rlSsXjCUV5lTa3eabB4tAYxgfT?=
 =?us-ascii?Q?aWAcURmN6nxGJHBGIFuZeUV1+zLpgze3IsN4N8P2uzkgKMY6PM6b7Nuy5ah/?=
 =?us-ascii?Q?z2Rz5stjlv9k6JVXk/2qATXw8wn4PJckRdzkUrLKbJcyZH/K4+MffbmUuqIs?=
 =?us-ascii?Q?d2vuqECMx+koCpB5ytZVZ2Uo79agwqqoWsUpRBOEhbBtMWL/vu0BBhYxEioL?=
 =?us-ascii?Q?UyT98qrOHdhtNEQB+PuVJFCLg6u9JIH25bmti9gfj/rYtxXziXcVTxfVidwD?=
 =?us-ascii?Q?6Tnl8C5lri5oxfOdfc8Fj2pSDLnuVF9NfCK0e4xr3WRE9llcsiQy+fB57ByR?=
 =?us-ascii?Q?X0Ajc2mIwK85JcaeJfyJOYHQriqVSP6T80vkWHswY1yWivkLIefe11DWQOZF?=
 =?us-ascii?Q?wLk5b6dLMfJdj8e+nzYE79c1PxdtFTZTz20TLZD66CpFfIhTfbmafebwy2Sm?=
 =?us-ascii?Q?wtXbRrGlQAEX+b/2GHISdLrwzPXGAxi0yaGLrCNqssu+5toIrgRvAiois1yX?=
 =?us-ascii?Q?NFjStRL5uECVWiUAmyOv/58TqZOAso91khi6BgIIWS720vJrdMvy6zlX30F4?=
 =?us-ascii?Q?hR5UUBFpt/KM28Nk9uXjPw5vOEN38RX8hKP+iewcsLti0T9sEPTCRqV3bdQl?=
 =?us-ascii?Q?v5JHI85JGRlRACKhf3j8z4GaUEMTEyXx4oZN4kUvGO6QCSQbJpu9fnPKF1XU?=
 =?us-ascii?Q?q4vUDBV6c2ZpoKUb9Bd+56mUMYBO3MiBOA5ODhFY56DiQJt3BVZ7lxEITRv+?=
 =?us-ascii?Q?kaZrLEg24yK1kc3/ER0jdzaqQtjy1e7+izIABut4lEGF1LKdgg2KMDmBuWvj?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557bf2d8-6840-483c-f7a1-08daa5acc6e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 02:04:31.7317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhVyVke0yfNFncyg1w4VzUQh+pUY//wBJs8qDzwUk8RCDts1q6d/uFizDQYv1KZgmbJIjJqOrn1kyUtnTfIRNMubUeqzLF0alp4S2OMdigI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4814
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 01:01:49PM -0700, Jakub Kicinski wrote:
> On Mon, 3 Oct 2022 16:41:11 +0800 Yinjun Zhang wrote:
> > Thanks for your advice. Although sp_indiff is exposed by per-PF rtsym
> > _pf%u_net_app_cap, which can be used for per-PF capabilities in future,
> > I think sp_indiff won't be inconsistent among PFs. We'll adjust it if
> > it happens.
> 
> It's not about inconsistencies but about the fact that in multi-host
> systems there are multiple driver instances which come and go.
> The driver seems to set sp_indiff to one at load and to zero when it
> unloads. IDK what that actually does to the FW but if it does anything
> it's not gonna work reliably in MH.

I see, it's indeed a problem, not only in MH case, but also in
single-host-multi-PF case. Instead of renaming sp_indiff, I'll use
`unload_fw_on_remove` to decide if need clean sp_indiff when unloading.
I think it makes more sense. Will fix it.
