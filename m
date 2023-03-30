Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7E66D0D9E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjC3STA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3SS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:18:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FD7E3BD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/K6ks5CjtuyOa+YP9tuDKE2Tkse62knqINLzb7zs8+3XsjVhs1oIn1meoNhAf2GuTpNn+QyahncsB+H8oDFyqPyl2UqmHXeiZtTmM3BNU1SF5fbWUnhyjvBFuc10xRFhQ6bdQmWMQ6ndhLOMxdJKTKP0bWN5UaT7c8I+498GUXi0seTt2i3HTnbl7UhfipM861atexb98Ixcmn1PyV7G9vxgVnmKMuVLdNqbqsAXYiScuQtgcBmMUue4fdcYxeEagyxz2K4RSdpK1X0judFzLPxE9IFv7YCTtmmLVNbgROpBfrCR9n3P2glSRREtLCLs3VGACDkXh8j+XA0V7peBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXGeslU2PmLb42aju5gM6H8NEPOb0XF5cLsC+uVMzjU=;
 b=ZUxsLa/dEMpSz/X6n+kehJ8oia+R0MP/ZP8ULTf1EnFP0FhQW06Tdcos21x44wo0h0hEtSBVEUybZkFMXjo8KqI/zJE7Fyvd50xrcBMYpPy+flA88ENqyY2mFoArBi4Wx1SuMXQWf0qLk/0ayFrAzVkCACo1Lkd884og8eEI6z0J4s1yIYtsm/Of350Hy2R4nskj7b88QDvEmTEZd9B61vGJdhTBLlNCD1OrS7j0BYqssybjjRAZUgmQgo4BZbdEm/+rfINm89bvQVUIHIvWsLJ4uf2IUsVgc+8RIHxRvHiGkv7CeFmuWdcWnBPyM2OH+peILuAeWpYJT+GlLPOdLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXGeslU2PmLb42aju5gM6H8NEPOb0XF5cLsC+uVMzjU=;
 b=lixik5ey9U1At80LRsyv+MRwBv+0PXoNQmnx4YpWbbDyggtdgWED9EuAShLf5u/LomwYyJApJW43mQRWjsEhPA+sZI+Mdtm5LY2CfPyqW9tJnqtjeWAFEPiJ5nrF3Ft7Y16xHNhVbq7fsmc2IdInFG3v1QIQLsCrN54OgU8ADmgBokTOGd+yqvJJwI9OGlFHl0uvxYuqjDuRN2RTmEd8yTbqDslk18U2M8YphyGuZZVoxqEXMRpJDX9bfF3lNeWayfz4cK3izJIcgAoDTndM9nmqqxbiV5S2915jSgWFfNGdo4KGNZ3y7NwRC2aJIgXP9ajrCOwPU1rHFrZkXLJSaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by DM6PR12MB4313.namprd12.prod.outlook.com (2603:10b6:5:21e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 18:18:55 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5%4]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 18:18:55 +0000
Message-ID: <60bd2658-2bf6-0091-1dfa-171ab4fea3c2@nvidia.com>
Date:   Thu, 30 Mar 2023 11:18:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] ethtool: reset #lanes when lanes is omitted
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
References: <6e02aaab-18fe-692d-52cb-71212db44ade@nvidia.com>
 <20230330103856.4f725998@kernel.org>
From:   Andy Roulin <aroulin@nvidia.com>
In-Reply-To: <20230330103856.4f725998@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0062.namprd11.prod.outlook.com
 (2603:10b6:a03:80::39) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3127:EE_|DM6PR12MB4313:EE_
X-MS-Office365-Filtering-Correlation-Id: b96a4af2-fcb7-4e60-d1fb-08db314b392c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTkJdBfjMJmBOLbGXdjdt4cCYGUh92to7BaRHRpAbg30i0AT08MPW8mWHEuPryQcntSlN6XFxtEuAR5d0GEaxl5M4sJZmOv0DRCEjkbodmQa6Pul3YztJRM6HlmRHYf4TUGYP45ZUiQQqnjkUh2eZXFE6zOfcA0Pn3f2zAo7C34ZRbip0DyPIT1k6m21My8Q4NRynQhrm1WMVR+SyArhOY0cukqfBJ+JWrLPf1DaeT4zH7i82jk+0S+fvyG84AAWZCsJJ5JnWm3cO2vBXMc+XCOwCl899w2UXmELPRj/ssA3kW/CN2JonCuKtjzKoi1XqOpg+ddgiyWpapY1sfMig2WXCZVmETzhnJrgIQ7yjHWUnmuOmCOhLekfuuNPgLNtDyREfJru68EeOAlUh9j/w9P+6v1xv3DpdfTwsEiIG6AhO7NIdFdMOjJZDg0VziMtn1THLSRk1LKNqM9UCLEdwsUZos7aqlVRTcCjA3vSLSKejxFXxSJirU2K5kgSgVdesqO5WHoTq0qL4ywzKiBSPhNmNpQHAa4yM67bDs+8cu1eNrAjRulDbJIuMTBGCUnBH1p4fkjoEKDy7DttpNCpfA1Jxa4B4Z78JFuujJM7YEBG9IkoRuT6JscDrB1OCL3FZYk5ndvtjRko+WaSjuZh0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(4744005)(2616005)(26005)(6486002)(478600001)(186003)(316002)(107886003)(6512007)(53546011)(6506007)(2906002)(5660300002)(8936002)(6916009)(38100700002)(66556008)(4326008)(41300700001)(86362001)(31696002)(8676002)(66476007)(36756003)(66946007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkIvbmRPd3laVEJRT2tmajd6L1h6QTIxTVJlVUw3M2N0R3F2NGZqd29WcXNK?=
 =?utf-8?B?ZGVsdXN5U1NiOHpqOVpvV2d3QmVZY0hvSVJobmJFQUxOb1hKSnpkSFdHekdy?=
 =?utf-8?B?VElUYXhncmRzdGY3Vm1JT2ZtL2FwdjAvb2FmYm9ORDd2ZjJFWGxYQmFQLzBG?=
 =?utf-8?B?Yk91bEF5Z1pkdmZaUkhtTlZtN2l1bys4bWF2MFpxaFNRRXBNajRzamF5QTRi?=
 =?utf-8?B?S2w2S3poT1IyVlhiSmYvWnpYdmtlQktyNEVPTWRnT01PMjhmV3NZT1QxeEpi?=
 =?utf-8?B?eWhRWk5BUHB6aG41SE5WWkhVR1Vzdk9kcHRBR0F6L2UxT2xraXZkdjZNVE5L?=
 =?utf-8?B?c0d3MENOVk1ncVlvTlM2d29vQTRkemt3N0Q0V0ZNQ2Q0UWIxaFlaT0xiVEhO?=
 =?utf-8?B?Ty8wWklxY01UdWdoZ2hVeDFpcTQ3WE9Td1RVM0c3L2wwcFVTOVZOMDNQZ3JU?=
 =?utf-8?B?bHZqZzJyNEZDQ3FBNkNBS2lOM2x2NmVQWURXQ20xNmhnSUpNTHhBMm5TTTVK?=
 =?utf-8?B?YmZ5YTlpbHJpTHR5OWIwekVnaW43MDVrVzhWTlZ5TlJkeEticUxFQ2FMZkRW?=
 =?utf-8?B?Y2lXZ29RTGY1bVVwOCtLNnE4UE5IMkZGeGcvRWNnUEVCbVR6a1NRSnlzM2lP?=
 =?utf-8?B?dlIzTEFlQlBTNlE3VUZlTFJJZzlMY2dSZGZtSnJwc2FkUjN6Yk1zdTdHOTBo?=
 =?utf-8?B?clRsYU9mQ2lxT3B3NXFZcy9KM3JuTmRvaTI3K1B2RFNVc1o3YlpqaGtHWTdw?=
 =?utf-8?B?bzVQZjhHUFZkWVRrYmUvQ2ljNHNOK0xOVVl2dnkzMmIxWWo1QUk1anBKL1Zj?=
 =?utf-8?B?NmJwL044Wm1wNUwxanYwT29HK1NSajJwUmpKQXZqWVd4Q09MdlBlR1RFc1Rs?=
 =?utf-8?B?eEI5ck1CK1FDb2ZteDhPZDdibjBDRlRiZmUrbU1Qd0JqeS8vQk56SVpRSHhL?=
 =?utf-8?B?OXFvZjd5Z1NocG4vVm5sRUxtbGJrcXlFc3R1SlJhZk8reU80WnZpeEd3VEFW?=
 =?utf-8?B?V0N1bTJQM1FxR0svZTYvYm01Ni9ZQ2JKR3c0RlVmQ2YvblhHOGJzcWhmQitl?=
 =?utf-8?B?RlNaR3l3dWNaVDRIcEM2TUN0NDJpWGVMVVlDUWliNzdHUm5PbVJVclprNHVj?=
 =?utf-8?B?NEZCTGdyL1hYdkYvb0pBTXpDVU82anV0SSsxZEpXUFpYTDRLQ0tYQjRCejZE?=
 =?utf-8?B?T2lOa3BKS3RHVzdzMjV3SEhNOUVoSjNZdlNKTEo1TklacHp0VVFEOFltaTdq?=
 =?utf-8?B?U2dqWUFtUmlpQTVUalB0R0JIVFpkZzN1akNscnROVHRNdXhBaVNhSlBDL2dr?=
 =?utf-8?B?eGZvYldtVEthdkhIdlJZMDBFV1d4VzdMaG82dUdVWmxnZk1yY0l5MEYrc0x0?=
 =?utf-8?B?MkM1SXA1M0tnQTZmNXVJZ21ibUxEeDNqekhyL2FKKzBmOExpOWlzeUZCdlAy?=
 =?utf-8?B?QjF5bmlacW92NEI0dkFscnM3ZkpUT2ZMQ2h1WnBHV05ORC9raWFnQkRaazE1?=
 =?utf-8?B?amZ5RTdTT2FqdkdFNGQ5RUNnZWN4RnpLMGpaNVFqQ2c2bkQ1NkhFN0lEMFF4?=
 =?utf-8?B?NVlEUGRlWWZkQ2ZlME9YaEdKbngwWU1nNmhTVnU1emdvbFl1d3loRWFCbnVn?=
 =?utf-8?B?UHRKSzY5dzlDa25Mb2VPRFRtVWFEd3dwalpuZlNUa1FsRDkzNXNySTI5UUdl?=
 =?utf-8?B?YzlnbmhyeFlZa0dZb1JPSkpiNVpFN1RDQ0lpL21nSFNjRDQyOTl5czR0cy9E?=
 =?utf-8?B?cldybzNKeTBxMExDYVJGbkZUVU5nSTIwaEU0S3dFVTA3bWROVHdXTXZBTnFv?=
 =?utf-8?B?NCt2OFlJTmNoUU0yRjRNOHMyaU9udHBjVFppbjZlSTkyOHBKeUV6NmJpeFlV?=
 =?utf-8?B?UmllNXRKOFYvSzJhRUdZbytIcHVxZ0pKTXUxWml1blU5WW1Jd3dqRnVsTzBB?=
 =?utf-8?B?U1ZCWGZBL1U4amZTM3FRb0VsZCtXaU1jaEc2TEMwSXAwYXVIRXcweGZuSHA2?=
 =?utf-8?B?QTh3SFoyT3RBdUx5UW50L0lpNFc0RFI5OEtvejNCRTg2OXVQd0dsZytGMVZv?=
 =?utf-8?B?RmNQU3ZTZTJXT21qSnhSL1R6c243MG41YUNQM3JUb3NydnNUQjVYZlIvVUZX?=
 =?utf-8?Q?B87Y3PadOOu3sG8tGM2DQhngS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b96a4af2-fcb7-4e60-d1fb-08db314b392c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 18:18:55.6220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZJYGpWuKqMpT03YG8P4ZLPi2IHLqZAWy4hN1Y9ZTrJWwXsW98PcMg+Hcb1+8ZeDnsD/fHNJBtlZAsLYj5/C3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4313
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/23 10:38 AM, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 09:56:58 -0700 Andy Roulin wrote:
>> Subject: [PATCH net-next] ethtool: reset #lanes when lanes is omitted
> 
> This should have been tagged for net, right?
>

Yes, sorry, I will resend.

>> If the number of lanes was forced and then subsequently the user
>> omits this parameter, the ksettings->lanes is reset. The driver
>> should then reset the number of lanes to the device's default
>> for the specified speed.
>>
>> However, although the ksettings->lanes is set to 0, the mod variable
>> is not set to true to indicate the driver and userspace should be
>> notified of the changes.
>>
>> Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
>> Signed-off-by: Andy Roulin <aroulin@nvidia.com>
>> Reviewed-by: Danielle Ratson <danieller@nvidia.com>

