Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D35B8FB4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiINUi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiINUiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:38:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C354082753
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 13:38:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwmoKAt/JAObeHitrEvnvOMWCgOh4c8Xb2Lrb8J4KO2/JjZfUeA+ZR3KHFSf0HZx2RQBK0e4xfEA4YxJs4X+rwbGMVAQs+2w1wDITJ2GHsaj2CYINsaP2jpcQIW/Gvsx/4J39AJqcSF6YGQoKVcEQCNAGGCl5VkoqCuYckOQc3tcEwQ7pTy2+JpMnIwbv51cLeAm6oiC9K+IdRdulyserrGccRO2GEkYyesUSVoSWTQM9YwP7M9n9wSWhkadHBKfmxzohnY8k35EcOdDlBIaFe1UoqmRwpzDEjqCtWE1Rb9eHLwnSL9bHCwYg+ymqjjQwE9h7MC2crXfHQ+vbjGgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yo3nslQPDvm6KNk2xg4syHzQNKKhdfa7AycDCxEc2E=;
 b=Lx3PFCozVoogMnY0FH20anOHquteiJXOeBv6nec6ybH9ozbxSKnNSlwf12JZSTZ8MDYFJWxhwo/L/ekO+bkHvfu3Wn6BVcHN88bIOlzJHT7J0Fx/zfg6holp3mAjjIER03GL1Zt5lSLT36/Tqr7oS4iZXXglpuH6hDgCfNbxb4dszQqozOCtwqX5ckWfqlKTPNGMX588R8i/ThthzyBkJzesRPvrWEpDzMWoWt2JEAChUVYszPzmBio3O+oOnjDFNcq9H8pBDK1OA3arHR4RT4ifncsFqNV5HkmG1jiuZj7YgTHgr1F5bDm7/rb8nDxVCVBBQpoqARBXRiMQ5rbQIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yo3nslQPDvm6KNk2xg4syHzQNKKhdfa7AycDCxEc2E=;
 b=tWZVsV7fo5KVy2vfdwqDGwZYXduhc91TcFJ4vjA+8rJ53M80tFNRCqMtudKeX7vrHFupKhKs/1WJrvCLffhYfk32RYwIVbX79gY70lpsEPk0IE51b6BFT1mIn9UIE43KyGYZOXieAxzqLvQshBTiJp/X+Zemluwl1Dusb6eLAhv4kKBcH/lbjy0HPWTkOYJ788mSRVFFhQsEVwzmC3y/bw8HFkk9BGU3AuCDPcBCvYYgqNMET4AN/3pbowvm7v1NT/qc70w6g4PKOeDxKeJPeuzm6mz/noWapAfHRNtMcX4Ze/Cep33qp/LKHWv4AxJtnhoroLKuhJEC/bLpnnpa8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB5952.namprd12.prod.outlook.com (2603:10b6:510:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 20:38:53 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 20:38:53 +0000
Date:   Wed, 14 Sep 2022 21:38:49 +0100
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, liorna@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx
 command support
Message-ID: <20220914203849.fn45bvuem2l3ppqq@sx1>
References: <20220906052129.104507-1-saeed@kernel.org>
 <20220906052129.104507-8-saeed@kernel.org>
 <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:a03:60::33) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|PH7PR12MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef9a7e5-3657-489b-f133-08da96912301
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9j9gFqlAGzPePcozrcYck2XlgWJAU4vx6/g3782yJiPp5MV2XRJG7elEQBbBHLsXLRpHwekD+nNW7bTBGSP2eTc6QFkHrRrDZXcPRo7Z56yQ3d2J9Vt/9OSS5EKc6esQ68CbVivoCq4BOgREYAEE6oNRy2u7+NwrDaTfbsEm/M4jZu7CENSfivbD/k8xtVUzVgsRHAipHZa0aNeZeV9r2A2c6ZTNP2UNyrIgMRxUolfXaYVX8rcL8aBh0Zhtf1MMxgAmXz6aZOQpZBoJDIt8UWAUYGQR9gC7A4sbuCxfpN/euSoTPqzunpNNihz9cvTtDhytau5TiXYV9jYuF9BvU3SwM6citTh/u84pv+Nxp+lTTTSS/PLMrX7hqrdYgJYWxNonX2+KcjunAOKnXNXiMlOBdMaZTzMKEzeh+L6jx58HUPHoi7y2Aom4p4AWKbMbwqUvGUXSJmQHtV8Ptjmt89nnwIzphYa+rAIC8MnygMblFmQXxYkZI5YvaUcn6rfxsUQVIJ0eOwECqHkjngzVKBFKFvWRQXm50rjpi4D4iV77HJRQFc/XjJFn5WO0Y45yb/EvCdFQg9u6bqFyjEGEC5xhkpFDAJopXhR4wE5scFJxBPGaRUBDhVt1/7o757jdhwqBno0fSu+/nXvYQThb6USeJP1gmeEOngqZmyiEK7Jd4IOlBeLilXryliurfrNvbbXW0Z2inPuVsI2Am8CMgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(8676002)(86362001)(5660300002)(9686003)(41300700001)(4326008)(26005)(6666004)(478600001)(66476007)(6486002)(2906002)(66556008)(6506007)(186003)(316002)(1076003)(38100700002)(6512007)(83380400001)(33716001)(54906003)(6916009)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QWaH2R2DqoPiuTZOOYkAn2Kk95QM6ZjkZLYxhk//p6xUn4aP7k2SJ8p0753f?=
 =?us-ascii?Q?TeEHU6C4m90pJsqEzA8kZTfspmsdgbAeAw/WVALU+Ognm10R374NM+jZ86Cv?=
 =?us-ascii?Q?/bvKtF8pSaAcfID4v0j9cYrTQtWWcAIQ0Bezu3Prsup/+wwSNjROceh1BOOM?=
 =?us-ascii?Q?y7g+Oo0GIfOirik49QYwOLFlvRkVQejIfEpGfjiD+uvJNmy3otmHKcl4YeCg?=
 =?us-ascii?Q?BBlViV1pUqqaKLb4zwu1QoH40/wefgDNstRhgKM5oVarTDxhl7FkETb/cFPs?=
 =?us-ascii?Q?8HKXqHaVYqDlrAliJWUOSR1ofZPWnojGU/v0dKmYiET74PEmK15ORH5c8LWg?=
 =?us-ascii?Q?4t9oUFt3dZl3SnmIdsp7Tpf9V+spqz+vMEY09KAiObkx6ruaEBMz97s+EiIW?=
 =?us-ascii?Q?1aSk2nRx0AVWHefbJzkbOUd3FrPtSIjZWZoDyfUJHb7KZw6tLs3YQ1bIElPK?=
 =?us-ascii?Q?dFk5vWllb9EGysRVtHDpTqeYuHwDmwv3+ITGrqfPo8WmNHgjMasFbKl7UDr6?=
 =?us-ascii?Q?NoPCLE1Go1uDzwfe4SWMoJ69A6VU30wmgPkztqOv5JONxyZICsmM9R4z/8XQ?=
 =?us-ascii?Q?sT3CFVAadSrxxFFRFtb2dIXp0lBThLLmIrjf9zLvNzsDl1ayClL/Qj8A2JxL?=
 =?us-ascii?Q?0JtYTfkEhnreK9f/h6JpV1nZdF1L91Dh56ZeNjmwUG+sqekEDtyYVQrFrcKf?=
 =?us-ascii?Q?lc44KZDBVzHsVO6nhiRRdyjIDS86A+qD+d9ndXPCdVZkYt+/PxZN2A4YL2EU?=
 =?us-ascii?Q?V9/tEDTOCn0O4Llu2udgftt3dI6AC5XpYnGBbSA3CPT7gomyx12wGkYwiy16?=
 =?us-ascii?Q?+NAA8POO6e7CzrYS7V3pt99NEfbrwXbbbYY1v+vB0V+NEEAUCGNcZX7oznHC?=
 =?us-ascii?Q?xGjCQZ1xu5GLBxzu1BhWe/qHA7YddyyRwkTOvxLlmvFy1FWJodQ8PyDBRZ4K?=
 =?us-ascii?Q?wBFuYcny3IYecYF2PC0/9JzWidHL13uQn9J4NrVpr/ZjQC8tyP2EJTHLzZUl?=
 =?us-ascii?Q?LFU2CGTD3sTTTeVBTlQQYwePFy0fq2H7yp2ax19x1qB2V76ClrxjVjuqBc5g?=
 =?us-ascii?Q?cziyKIvPh4FAfwWBoFiFyDeISjX5ptilCwVTLg5IC59lRpVEhOmbFh6wH6Gd?=
 =?us-ascii?Q?JAhjrtw6ZwCz4DXE4UfDJXDa9vei2s6UHlrbytgBIl5ot6SwcDufXeFZ0p6k?=
 =?us-ascii?Q?YCMNc7MmFQPrHIeZuAU3rtKmkE6FK2rmXIz9INVYOBGFSg4tndTyoSPtZqCw?=
 =?us-ascii?Q?oH/uth0W/B5Q7hT95EeDj8n6EZN3+GKjqi5oWflF4MlUkX4m2Ju9/7BOBrYe?=
 =?us-ascii?Q?uEN6Vq8Zpl8Le+hiVFO6GPu1iW6a8NvBfezSI5zs0ce9B5UxUfqnAMvDIxJ9?=
 =?us-ascii?Q?4aDH6qXGDkqhSs1rv0qBzj2HRf6dM0XG9mJr1Asjf/Ez8RqRdso+cEHUJtMY?=
 =?us-ascii?Q?9cY+fTfd0LinQbk7gNRpU9BpMErfhxsN3HTUGVMB/pb3QExsvwlzd/KV5N9M?=
 =?us-ascii?Q?6akMbOETy2dPdJshLlRUjM9mNn5RnSl1siqLBqxMoQrLy1jSWOhE7Oc4iqZb?=
 =?us-ascii?Q?L2YvN1EE6vRLaZnbD+UBkanGSZb4RDTTL+IRsDyv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef9a7e5-3657-489b-f133-08da96912301
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 20:38:52.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCVKiUt9+/2LyNuhJ98dNX1O1TgeZmplyCeKySJ163MDdadpQ5vWmcxzKD2f9jb2GBDBvBzFQuSGJEXSpIK73w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5952
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Sep 20:09, sundeep subbaraya wrote:
>Hi Saeed and Lior,
>
>Your mdo_ops can fail in the commit phase and do not validate input
>params in the prepare phase.
>Is that okay? I am developing MACSEC offload driver for Marvell CN10K

It's ok since i think there is no reason to have the two steps system ! it
doesn't make any sense to me ! prepare and commit are invoked consecutively 
one after the other for all mdo_ops and in every offload flow, with no extra
step in between! so it's totally redundant.

when i reviewed the series initially i was hesitant to check params 
on prepare step but i didn't see any reason since commit can still fail in
the firmware anyways and there is nothing we can do about it !
so we've decide to keep all the flows in one context for better readability
and since the prepare/commit phases are confusing.  

>and I had to write some clever code
>to honour that :). Please someone help me understand why two phase
>init was needed for offloading.
>

I don't know, let's ask the original author, Antoine ?
CC: Antoine Tenart <atenart@kernel.org>


