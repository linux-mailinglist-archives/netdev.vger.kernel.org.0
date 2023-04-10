Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879F96DC38E
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDJGdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDJGdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:33:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070.outbound.protection.outlook.com [40.107.96.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C8540E0;
        Sun,  9 Apr 2023 23:33:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGKbZ3zcObUHKKDGb9Xw5baj40CrB9/3gS/gH70dzyl3QNmCA7Ff8qfuTXDqdBfGH+8Ok6GYL4RPy5uLBficISV/61icgTnP8TkBtANmgePlOhp3KJQmrgog4M0HP6OLI/oWCCn13sajv2aqieBS9BOqJZeFRxMixRXjlA5pkJNvHYCWh5hC0+Y0Ssd7Up2+TQyOhrBispW5sIqUAVxnOlDkKT0Cw3FEpwIbqt/kOS1BT8TfyUgyZKayhHZBM94yTWHl3ywklCZqQjr9X+uZVeMIygTQNDLwKadSzuSRhdMlFpWpNPVGhEoS4zq41cSB5Pyknc6W8WbvJGLdb/4L/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=to62dQV35H0chhqVGmVPXiRxbvSli/Hnh+xMgdny3tI=;
 b=UVpRqcEoA9uBMreQirH64irIhmX1QNGCGhUx/qBWBeuXQL1XfrvL3OJ+R5Gh+KS5/Hq+oqa41k3ZwK/qTu1J+pzhRjq4qVS1Rr9FKL4sVG11TeKUBeVE1aGADEcpCuU/hl0IROFG7E3GJ6d8JBj2Cusgki5P9SyimQhxFj6Tcu7+eObK/ZFrwVmAbzfD57EcOdiL3mlfVJuxC2WjIVsJxkeNqK5tDPLr6e/8/YO7iY9u687IbmKpD99Fx6H+a/AzDMsblZergiGufXAz/9K/UH1PIPDPLBbN88Sg2LMrNuZAbr3kVbHZqg6bGhJRkUtB2k+Ca+G1lDyx242lxG0/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=to62dQV35H0chhqVGmVPXiRxbvSli/Hnh+xMgdny3tI=;
 b=QQxL1zisCpyNrLsE4GI4cU6Vrc8V+L+Cwo6pZs8Xx4HRYN0cN8v1W84pI3Mi5WBYGkPrOHSSO/KZhVzlLneyXceX7MmXy5Syeu1us+GvqreycY7493CK+LCR8atcuvNJ2XM6MUHZAcHB77jvV6rMFFtqWKEGXcQME8TL16PyPUo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by CH2PR12MB4086.namprd12.prod.outlook.com (2603:10b6:610:7c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 06:33:45 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6fc1:fb89:be1e:b12e]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6fc1:fb89:be1e:b12e%6]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 06:33:45 +0000
Message-ID: <ba8c6139-66c3-a04b-143d-546f9cbccb70@amd.com>
Date:   Mon, 10 Apr 2023 12:03:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v4 00/14] sfc: add vDPA support for EF100 devices
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, Leon Romanovsky <leon@kernel.org>
Cc:     Gautam Dawar <gautam.dawar@amd.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230409091325.GF14869@unreal>
 <CACGkMEur1xkFPxaiVVhnZqHzUdyyqw6a0vw=GHpYKJM7U3cj7Q@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEur1xkFPxaiVVhnZqHzUdyyqw6a0vw=GHpYKJM7U3cj7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|CH2PR12MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: ddca1f9f-8dcb-4b2d-15af-08db398d88ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQdEIOOZ3tOwtV3ztwP8am5eYwuay20ljDJ/5AXiar7ibFClSR8f3N/cwVGCvquMQuwAyGATFVwGGRFARMGzaZeCI/MMLECUxebmXVPzE++OE5n2h7qUnKV4sSyR5ct4OJG3dscKRDvAnxOwAUrHUrmBIEiJ9hheciypoO41pv8hysYK8ogiIUQW0DnCPIJPEfEEMEkaUtDj/2s7mlIEnFAC6ZVT1Qua3A4u89UWuPuNkQK+xjn8w+rIVNgJmsulMPccNuc7z7OhlyP25W04JKfLKsafCPKd6DpIdn7yJ//QuEKHXC9+fhfksjIGAYkStOTIq/Xo2fTsbt0ZdoiwMVvjnIjK1fOkcOxf+jlAwSswFDwbXCUNqI2FT7EkNgY6uBIrM5hHfxyhCyurqiF8Fhv9jWZScamzg/B0WNQM/clvaNF6u5hrXnqQSkmXQAplKFhXy21BqQN1jXa8moBcDypuAUgoF0r83e/AUYcFTdiOyWq76/8x7NGhznpFqlLqwUraPNTTZZnaBEkzSkBRChwtpapGbihVBlhCYHi6P9vlqJKdIHeAaR90LOCOgViJ7GHCSa/3zqhbOIVEzWFLBjgC2NrpLfYZWQ1r2FUOnpmvy+RuwQIh/2WwmEKUvhOiGTPwm0vJx6Wal/frTQuq7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199021)(478600001)(316002)(54906003)(110136005)(6512007)(53546011)(6506007)(26005)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8936002)(8676002)(7416002)(66476007)(66556008)(38100700002)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjZkS2JFb0lZd1hmWUpxeXMrQUVoS3YycGlPSzlmdW42Um54R25odFJrcGNy?=
 =?utf-8?B?ek4yZ3E5MnY5TldIVmIwSFN3WWg0SlI1bmdDSzVPQjRacXRFUFFrVXBySGp6?=
 =?utf-8?B?eTVoZWVsODMwblVqQUtZQlRSbDh5aHNUSWV6S3c5TmtFRTVRSWZQMjhWM1Fo?=
 =?utf-8?B?aEgxTUpVOTVZS1hySkczejh6em1VbGRmM1hUVmZwakdqU2s4SkV3V2VmcGdL?=
 =?utf-8?B?eERVQnNmaVRkUHUyS2NxcHYwMnNGdGJyTTJpS1JLVHNhZzVtY0ZrQkRGYVZa?=
 =?utf-8?B?T3VJSXhoUGp2dzNZUGRMYStrUEVSVlZmZEJFbDdERFJsbmpMTlpPRzVDTk9W?=
 =?utf-8?B?Zkk2U3g2ZGNjTXNaaUo4eG9hc2REYXhFdFgvMG1HMitKbCtBZC82Q2MwSVZ4?=
 =?utf-8?B?K21VcTFNRHZtSHJYRnVieUV6eGJrd0Q4U05QdloxT3pTZjFrTFkrVk5mc3Fs?=
 =?utf-8?B?NlZrOVFUaVdvUHplaXVuWU1UTkJHR1VqWk9ESWF4cnRDRituWU1aRzhJM2tG?=
 =?utf-8?B?WmdxVGRuMkd0Vm5Edmg1YlhOSlZLSlRtSG44dDNWYVIvWDg3R09XZDlhT2tC?=
 =?utf-8?B?SytkS1ozTWxRUGZkdkZKZXRhLyt2Wk1zQWwyVlg2dnFDNk5RUXdLTDFsTzNG?=
 =?utf-8?B?dGtjTnJEMVJCZEQ4d1lxZytNRUViNGlsazdxcHc1YnFyblhQYzl4Q2RNSWpO?=
 =?utf-8?B?cHUzbkphSnZGaDJ5eldGK2RSYkxmaUtCTFNlRjE5dE5ad3BvQ2NkWGdXQWp4?=
 =?utf-8?B?RjRRRFBBNHEwa3k2aWdXbDNSSUErdlVEbXYwM1FscVBaeVhvZ09YVytxSVNR?=
 =?utf-8?B?b0F3d2ZkTmN1QWk4VXhzNitkK1FqU2lpcHcyc0kzbW9hTzNCbmxnbG1abGxQ?=
 =?utf-8?B?OHpDSEhMNnRhS2dyNUtaSE1zVDg0TWoweHVCMUNyV1BQb3AzRVI3RGE2T2VL?=
 =?utf-8?B?ZE9iU0ZkZUtYZStKTlF6RjFsZDJDdDVYTGVvYUcwVVB0NDZTWWltYjFQc1E3?=
 =?utf-8?B?RDFReFJBNHFCVXVLTXY5TEtSSlRwWTN5SUpTOEk0eW5ESlZNZHR1OVlEWHAz?=
 =?utf-8?B?UXNnMWNCV2Nmc0RCaW1EZE05MHBMSXhHeWRBSjRCbFRYMDdRNENhWEpFaTBt?=
 =?utf-8?B?cW43Q2x1TDZld0piM3pyd3ZUdkpBMGR6UzViU24rcCtORGh0Qyt2L09CL1R1?=
 =?utf-8?B?cWZleTZNOGFTOXRvZHBDaEF4eklzWDZYWEdBVlU2YTJGTmZPODdCM0dqMDlw?=
 =?utf-8?B?UDNPRGFkRmxrUk1qQVNiRWZYeGlvN0V5NGRqeThveU5Za3IxeXJOSjFMVTZN?=
 =?utf-8?B?SlZvc3RNZXlyb2JLcFl1R1VpQ3BZcGZRd3hCajBQbkZwMDBicHhyQWovL2Jh?=
 =?utf-8?B?UWMzSG9CTTZlRE1DV284SlVYQ2UxQjh3NHlSSDBSQm01V3YrQ3RiUEw5Qlhw?=
 =?utf-8?B?VFlKbGV6SG5sYkZYb2FjQkU0YXc5a29WZ291dkx4aSs0WHduelZmMGJrYW1S?=
 =?utf-8?B?ZXBJTnR5MXpnWWU2QnNnZlRUcncxRWZubm5jZ3Z6OFFXZFVObXlUdWM3TTRs?=
 =?utf-8?B?YlBic2w4eHlVT2VUNVJ1cWtPbVJWeVdVWVJWa0FxQVpMUmJacW0wbFJLTkY2?=
 =?utf-8?B?K01WODJxL3hiU0FJVVRZY1pUV0VGek1mMWRlUGNRV0ZTbmxXajZLQ3pvMkdt?=
 =?utf-8?B?WXlXQ0crb3gwMkZvbDBaL09DQVkwNVZGdHhML3ZtSDdRU3ExZXY2L3JDSW1q?=
 =?utf-8?B?QXhyU1MwSmRFRnkrRTRPYlpUUnhOVzEydStFSEJNYlZwQnFWWVlGRkd0ZHpX?=
 =?utf-8?B?ZERYeFpqcDh1TnZ2bHFuWTc0WW4yU05kdU51U3hPL0h1RUEwNlJzMVd0WUZq?=
 =?utf-8?B?aTVERWNmbUNTSWkvVjB4WDVmY3M3Z01NUGNOL3dUS0tGbGNZM1NLSVhScUo3?=
 =?utf-8?B?RHlHazdsOUVtaGRZb0pJL3F5ZytGZmplaUhTRjk1N1dhUVpWQlVyY2p6ODI2?=
 =?utf-8?B?Yi9HOXM0aGsvbE9BNUF0S0xWV1MvRUFrZjVDYzczbmZNOEN5eWEzREFSTlUy?=
 =?utf-8?B?MjNUcllGditRdnRPTFZoR2piSjRvZ2lyYjV6MkkxdEJpbXJOVGJEdmJzM0Ux?=
 =?utf-8?Q?qclwAYJccm13BaWw1pvQtvCEv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddca1f9f-8dcb-4b2d-15af-08db398d88ae
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 06:33:45.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRn4EoGzk5eZyNYpisOD5T3VnJqObJwXZSpdsybE2FKm84vw9q2D/yyCg0KhE1Yb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4086
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/10/23 07:09, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Sun, Apr 9, 2023 at 5:13 PM Leon Romanovsky <leon@kernel.org> wrote:
>> On Fri, Apr 07, 2023 at 01:40:01PM +0530, Gautam Dawar wrote:
>>> Hi All,
>>>
>>> This series adds the vdpa support for EF100 devices.
>>> For now, only a network class of vdpa device is supported and
>>> they can be created only on a VF. Each EF100 VF can have one
>>> of the three function personalities (EF100, vDPA & None) at
>>> any time with EF100 being the default. A VF's function personality
>>> is changed to vDPA while creating the vdpa device using vdpa tool.
>> Jakub,
>>
>> I wonder if it is not different approach to something that other drivers
>> already do with devlink enable knobs (DEVLINK_PARAM_GENERIC_ID_ENABLE_*)
>> and auxiliary bus.
> I think the auxiliary bus fits here, and I've proposed to use that in
> V2 of this series.

Yeah, right and you mentioned that are fine with it if this is done 
sometime in future to which Martin responded saying the auxbus approach 
will be considered when re-designing sfc driver for the upcoming 
projects on the roadmap.

Gautam

>
> Thanks
>
>> Thanks
>>
