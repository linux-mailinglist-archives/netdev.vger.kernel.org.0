Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C0666AF6
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbjALFtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbjALFts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:49:48 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D391A182
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:49:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls8+pSwVIw2hZSLQCp8jFwI6ScmgLx5aGp0akfZJ7LJMP/5YLkoYh37zzICMnNK7jEZRrX8sthaWp8mgCLBFFi/tdasLYpmyJUphBGLwj1Zbcn3RdTmVNZGpxBAZmBOcra7K/q3kf4ox0KqUleiCLC2wji8ahRwT/6oOAgLduqa/D/qhsEHUiyk+MSbfuZowzlKS1hRHgO17gHb8PPe5yZiiZmnckIaaLCG9DrMpSzLnlXK04tDHK+9Fy2LUfAcIz0QAkasNYhIvm9G16T4YG230Gf25FuTirYTc4+JAqaaF39gH4nXncmFmkC2mmfaJVCIYI21mmGWAb792plfnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/O6kU9t68lkuQb2FJydOE0RmD+9v4qD5PPoOQYPU2o=;
 b=O4adCeHAMcm2op6Js4sUHgsyWN9PgE1cLW9+61mbzfPo4fUIM0M88HQUL63g+EYgQRjK5/jah/KCQjSi8SqVmJjeK+mgtajUTtQdKMn9CnYLSH+ZxYNrJUmudRX4zBg4HrbFQBoqBUsy5JZ2m85ztF6v2FOPww0qefepYNKzOA+Twwz9877mGdLVE+ejhNU7DY5Kysf1NHO+Ui7LNOcET0/OX1T0HCg2eKnNu7Aoh5fMDeSG4UwkXua5s3xWjTesyKEGADJ6Zqt0qxZ9RxE1zjzwbU1Q/oBQvY76/+/OFTJY8i4+8xurL8zP/ebt70y3izRMKJwEZ1UUax6z2YuGfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/O6kU9t68lkuQb2FJydOE0RmD+9v4qD5PPoOQYPU2o=;
 b=eKXu7uk57ildUpUHBs/LGMQSRDF5jawODkIZ2MmCo3FBiRBnJSUiKk/V0ffBsGzA7+JTtLQp4+2lo2s7QeqOgDd08ew6PHTFY29ZF+DILlr3YtAjei/fx8eaGZ4qArTcWR5/k7mcBosTlhNd0EvQbS3ufPQont8PojIvCgiSf0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by MW4PR12MB7239.namprd12.prod.outlook.com (2603:10b6:303:228::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 05:49:45 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0%9]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 05:49:45 +0000
Message-ID: <822b51ba-3012-6084-b4eb-39e21f2c066a@amd.com>
Date:   Thu, 12 Jan 2023 11:19:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 0/2] amd-xgbe: PFC and KR-Training fixes
To:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Tom Lendacky <thomas.lendacky@amd.com>
References: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
 <20230111214254.4e5644a4@kernel.org>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20230111214254.4e5644a4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0195.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::20) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|MW4PR12MB7239:EE_
X-MS-Office365-Filtering-Correlation-Id: 60dc1077-c4d9-4acb-f600-08daf460cec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKDUa/d6cFHGhwu0RiBAmDka0+uGUXdEo57STLZ0R8W9Z4tD5+OK5LHv89Xq36LPA15dMTao0lXsgDK8tvcPm4FnPh7508U6vPONY5XFc048swDETCDRclEdkUPjWSEEXHbI4R/u2verUb/zN6Js7cogSGzSof/ZTOB90nM4Ek/+K51shG4q+IEkzw543KFirh2cwxNQrUOEP1dtGXH2asvr/T8RiWXsSTnA7UHJchf2mg6WgEQhYxl0cvX3gCnT0cbTIblsrmDDSANsPnZDhpwN0fJoK1fxaUab10x8veBZtsJTR4ZqoBP90k3n7tlZyb8uWq2STdt7dt1lS72942YHC50axGu17MfH6GAg7k/MvPO/yLhcNPpddcsLVZNRuuLYpltK2S+H3a3K2oYbQUm98CYaSqshNadEkBQsQTJQBIkM2SuNDrSPdU/C8mdJN+gUEKSxTMsbMHbacReacEgin+h0y12FdaYg/Pra2O/6BPGWV1Tynq2bTtiUWhPH2IULIwO2F1aNH8JsWX8AFDvpw+mMBw6oHGCUGp8nuTv1ZzJ96Ust9wQffHveIvlc6L73G/Er9GAlyubIZW6/ZC2SrmFF5ULgEgcl0oUnNAdsWDp44aj4Lk5e5QT5BYDzie0kX049wC6QE6RKWl4skiZFaJpcaNZGNJVoK9zgW8+uX1Kb8LmCsloWQXMczNb8EuGW324n41QvU8jf9J+If1oKWsQQAEnlzrW/ZCNr43c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199015)(5660300002)(6636002)(6666004)(2616005)(36756003)(2906002)(6506007)(31696002)(38100700002)(83380400001)(86362001)(6486002)(53546011)(316002)(6512007)(110136005)(186003)(478600001)(26005)(31686004)(8936002)(66946007)(4326008)(8676002)(66476007)(41300700001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVlIeExmcHh3YnFLdlZsNENZUlNaK2pIbnY3SDdZcGFyTjcxeituVis3Z1kr?=
 =?utf-8?B?ckc5Y3lrNG1aQlpvYlhrb0hRbnNHajBjRDlGd3R2LzhWWWJZUVVmdUNIdjdB?=
 =?utf-8?B?dTZ6RTdYd3E4YWFLb004N1VlOTMrU1FjbFhlOFFETEoycXFmNWtLbllWVVhR?=
 =?utf-8?B?bzdWY2ozNlE0djM5MkVzbVdVUW5nRkYrV1NQa0dhSXZ2RzVTQ0hLUjhCQWtj?=
 =?utf-8?B?a1YzQjNmdkxrWnZFWlZwMUxzNkQzai9RdEdod0lRczliTFpqSjZ0Z2hNalZy?=
 =?utf-8?B?L0VIM2Zoc2xOWW9ER0tTN1dhZEVHd2Z3TDhsSUhaOThya3VQcmJxQ0grcWVM?=
 =?utf-8?B?QjZJREhIOFA4R04rYndYT1JMdUNnV1VaYmprb2p5S21nMmtKV3libWJMQnlT?=
 =?utf-8?B?b245UDJUNFpoUGYyZDNEOURSeWd4MTNVeGE0d3o4LzZpdFk2c3FVdjdlSzdK?=
 =?utf-8?B?TlFCaEJyQ0ZVZHJLTGh4Ync1bUZLbDd0ZWNIZ0tENk4xMSswYi9DaVFmZ1d4?=
 =?utf-8?B?YTRYT3F0dmlVMllzYkJYUDRjemllenMvODFlRXpTQzFxbDFyVjRobHdPR3A0?=
 =?utf-8?B?VUhzQ2xHK3F0Rjc4VmZ0REl3ME4zS1lEVzljc1VpVEl3YVNWUzlGTEs2ckxm?=
 =?utf-8?B?bU5GVWQxSU5aNk1Pdy9CZUEwaW5mcEJoUnNGLzBGM2dQSmwrM2hhcTFZZUZK?=
 =?utf-8?B?T01XNnFITXZCanlUQjVYdVlhYlR2M2JtaEk3WVlEKzhYOGxXV0JST25HNlpF?=
 =?utf-8?B?dVlsQjRTRXVFdFVKeldCN1JTMlVsK0gxaS9vQWF5RVlOTFpuR0VPaHFlcVVa?=
 =?utf-8?B?QmlpR1Q5akYzSVZSMjFaODEyWW9sMmZhdTFpRlNwOHk3YmZMOUpQS1ZGd3Zh?=
 =?utf-8?B?VzgwZHZoK2tWUUtSeHNndS9vMy9PN0FGU2dwUTMvbVJpRkJyYkpzdnFtb3Rp?=
 =?utf-8?B?N2xVYVRadVF6UFkwOUFZTnBqWE9FdmtGV2h4QWFtR2NhNEtZMEhmOWh2SS9S?=
 =?utf-8?B?aUZRM1htYzlwTGpyMWRjSDZSR2w0RWxMWlRWNms0RXduNkFQdUcrUU1nczhk?=
 =?utf-8?B?ajA0eWErQzRqRWk1NzZIMWl1Y0MrUXE5UFJGRVNzaHJ5WFZCOXBFTGZ3MEJa?=
 =?utf-8?B?MXpBa25ucUlxcTF0Vnp0bGlidXdkTmpqVU5obGpZYWlFVTRET09lM09Pc29h?=
 =?utf-8?B?WmN2Yjl6eTh3WVlZMklOSzVEMi9YQVcxY3hROExnMWM1RktYTTVyT3pZN1lY?=
 =?utf-8?B?alBVYlc5ZWxXdldwR3A5VkFFQ0lBeFJSa2Erc0pIRW1OZDJ4UFdxT1hRTGJW?=
 =?utf-8?B?K0lzVGdFc2NZdFVuMlVoUGlwZE8rTXU0dkF1VU9iRDlkV2RsVzM2VUJaQ005?=
 =?utf-8?B?L1pOVkUvZlgwbERZVkF6TUNVWExEcHl1SVlWeEtudGJrRlEybGR0NitsekRG?=
 =?utf-8?B?MHFuY2liRXUzQjJBSUYrQVdHT1FoeUVzbndTWDhTSkUza294Q2pONDdlK3NB?=
 =?utf-8?B?cURXY0lrVHZ3djJjQXdXYmUzR2xaUnQ2RkgzOXVJT0wyakVOcHpSQ0lEWjlN?=
 =?utf-8?B?ZnBnR3RrUVIxMUhnemd6d0tSMmpJQjUxTDFmelh2TjFBNzNWSVAyazcwYW9F?=
 =?utf-8?B?cGpBd1dPQ2FRNkFnMkU2K1N3Q0lLbUVTOUpaMXhoUmxOV2ozUXpuS1dRb0t4?=
 =?utf-8?B?QTczY2RzSUZZQTlvcWZkTTJpcEdKTUd0UlBaR3N6Zld3cmR2cnZ6cElmVzkw?=
 =?utf-8?B?T09EdTNmWlpSWWxHRWJhbEUrWFNEcW8xTzlNR1lJcTd3MHRscWZtaTJPR3Jr?=
 =?utf-8?B?U3lmUnp5RVlJbVRtTjNHQkVncDNkS3FPK24veHA2d0tQZ1JUZ0lWc24yQmFr?=
 =?utf-8?B?dlJvZ2VkSDZlZlNvblJORERrQjVhVlRFbmY5Z1A4dUtkNFRGeFJyb1NXVXRI?=
 =?utf-8?B?Y1ZGa3NjVFpHUHg3eG1KNWZOMUx5WTBwU0MvMHl4SlpBMURETUFiS1FoQUJE?=
 =?utf-8?B?cGJreXcxVUJQM2dMM1p5MmJLR1EwU2t0Ly9waldGOVRNelo1RVJ2ZUVCN3Rh?=
 =?utf-8?B?UVQyN0NQYjc4ejgvWDdnSjJLMXh5VnhTcXpkQjBwS1cxajNhVjd0TTIxUFZz?=
 =?utf-8?Q?MjuOaH3WO9zZgyO6DTW5DcmRa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60dc1077-c4d9-4acb-f600-08daf460cec2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 05:49:45.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xu+1yhBdMrYdyAu8Rohe/ma96n4gHTvv08hXrkvhg/jNI2ihvmIDOvA30nFTSKLvEUNaAAZzjL7YNxHyP5XB9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7239
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/2023 11:12 AM, Jakub Kicinski wrote:
> On Wed, 11 Jan 2023 22:58:50 +0530 Raju Rangoju wrote:
>> 0001 - There is difference in the TX Flow Control registers (TFCR)
>> between the revisions of the hardware. Update the driver to use the
>> TFCR based on the reported version of the hardware.
>>
>> 0002 - AN restart triggered during KR training not only aborts the KR
>> training process but also move the HW to unstable state. Add the
>> necessary changes to fix kr-taining.
> 
> Please err on the side of CCing people. Here the patches under Fixes
> have Tom's sign off which makes our automation complain that he's not
> CCed. No tag from him either.
> 

I have put an Ack tag to the patches in the series, being the additional
maintainer for this driver. As Tom is busy working on other areas, I
shall be a single maintainer for this driver going forward.

I can submit a patch for the change to the MAINTAINERS file.

But would you mind pulling this series for now? Or would you like to see
the MAINTAINERS file getting updated first?

Thanks,
Shyam
