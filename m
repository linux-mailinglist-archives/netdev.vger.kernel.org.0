Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A026562D25E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbiKQEkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbiKQEk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:40:29 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51FC627DF;
        Wed, 16 Nov 2022 20:40:28 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH4cdrF022370;
        Wed, 16 Nov 2022 20:40:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=eEJewprslytyhxioTa3ktE24ELHZdzw56eOdG46cvj8=;
 b=dH9CTzdxvQka+r4lNUoYNgpeFwKGwS4JAoj5FyXvjK0A1Rmouzhx1RwaT2BUuDrhizrP
 sUQuR3zcQ2e/keI4R60sr1fv4i2Nq6u8ZAO90F5WlPKrgJv1uLtMQ4clTeRqPG0Sdv1y
 zWLUDlZttUPOqpGHOZ2c4fGy0rRLUFGe5P8+S1s4uU7dcfhVwU6WUg01bPUm4gc82cAQ
 qJCCb/Wf52+GV59jt+5t0SPCTeqQw1Nip7/rv3WzkQmo9dpiqgz1Xcelzoa0xRX0WYsu
 xVKiqjOxMjyrBsq83z6wCgiEYgvhFNS3hdCrg6pf69NJHkaA7kgGKDU8DpAYF6kUECy9 kA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kwbxvr2kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 20:40:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nu+4rGqWUFgp3F9Q/EoKDcwc3Mv/pyz7T7csj9bjFPRv0CWh3iJKB++MpEN4sEGJF6rOAQFj8R3/tdgVZGBb4g+RqTdVnHBK6Muizwpy15DSasLBMfHmhYVUALdImKbmhetV1pFiUZQzD7389rMdVOUnbaCoKtIxC1xwL+XqRcV/fNNQWubM3bhy/rVUGQ75GgB8FgCOC3KvtIGbHptg9Z9kVQMTnhITlrwF6DeXnGrpA+KrhBRATzEvTLGWwh5jxpjiEpLDgAfEsYdxISFOEBFcK4YKlNBWUBm8xtpQjznRE3zQOYnLRkWz3XiZDXkVsWyIwiEuUIfTU1F1tmAV2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEJewprslytyhxioTa3ktE24ELHZdzw56eOdG46cvj8=;
 b=Xw5bcKuxr0PyLHMg8yLmpOvlLakNwF1ON4FjJ0lBs5xkHe/y9mCaArdcBwhvz79RNa3ygNba3/xQmOkhLKIIrEfFvqcl8vT/6GqgpZxGrIIrxYbY8b8vOdL5jj/xf1vzfB1EMXeuqql6SQJSxMuXFfPYg52yImeOhCeeX3I5ce9KbsE/rFIhvxIXho5sOZ+g0Qx3cRWSWMzBsNlWpzbRD7+IC3p+HfrN8zIeR0oRXCkTwfEKPrUaVm9mujfi+6Q4WYY3AWNTpM0eu7BQviFieYoJqr27sguKhRDfaiAp+ce5JDictNOOhK/xQzDUeAvxT/9HVVZHbrmCqL2o+nt/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by PH7PR11MB7028.namprd11.prod.outlook.com (2603:10b6:510:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 04:40:13 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 04:40:12 +0000
Message-ID: <6dca5756-cee2-6921-d5d0-2d36a6023355@windriver.com>
Date:   Thu, 17 Nov 2022 12:40:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] net: fec: Create device link between phy dev and mac
 dev
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-3-xiaolei.wang@windriver.com>
 <Y3T8wliAKdl/paS6@lunn.ch>
From:   "Wang, Xiaolei" <xiaolei.wang@windriver.com>
In-Reply-To: <Y3T8wliAKdl/paS6@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0117.KORP216.PROD.OUTLOOK.COM (2603:1096:101::14)
 To MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|PH7PR11MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab52031-301b-406d-2491-08dac855d0c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCl6I6piJMadZK0231ut/pvaGtkUqudxkGBiICzkr+pDN19pGph2liznT1kAMBg/zp7/YNKElKfB6icIcvnP7RTp86qdcwT5rRcSg4UHQJZRMZ3JmAyXhjgUu1zPTrMwkWeeN76VF6VZacPSIuXvzEgvGEpwxagAwuXG2MditRBFg/V7OdN6Jbfv2yKFgSfCcFMoRDkQk6fzTFD/iPELBPFgBPQ1SadccLf7ofmtgJJirwmANSoZAxAYwbOuo8sbBlTZk0LbK0B5LqG8qiqPIl1rFbpkrY7Jhh28PHfIBtb0XeiTFS9fL6PjvWoBJ43MvUNW2b0v/t3v+1LoQyFtKtZJODBslXcPj2AKED3EB0cb/Jb0bP9GyH4KuyGoJEH30rPRnpWD460n+aS8WSyYPlboF4iuF61GZlbevIbv5InatuYM0FZPJWbwqNcZ9aF70FfqVTRhC2AFhq8moeXdODY5gu93L4QdheZWa1oyC+txvBwW/WX0l9BKisfMDg1d9dy7z4esvx1mSFmWib/jToT25jPku4vC4x93VzYJ539lOjcBJg2T/A3OGF0ADRXiXXt6de/Qti8BudyR+8iw4MoToiYTVKM23opy/fwvEfcljk7gFpSV5p64U4ILbyopoPqvTLeGU1T9JLFMtx/ZCwJ9yqm1uN+u0CXIKcdGxYP4UCy9nsVY0N1hdtTt2hAiflBWqrpS//+eWVVIv8reg4us+2YrTovrdDcvdjNi0QdKqnbsA54mYchKgvgCYOXXZGMnYaDV07T0NrCuHadwZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(451199015)(83380400001)(31686004)(2906002)(8936002)(478600001)(38100700002)(186003)(5660300002)(38350700002)(6486002)(2616005)(52116002)(6916009)(53546011)(316002)(86362001)(41300700001)(31696002)(6512007)(26005)(6666004)(36756003)(6506007)(45080400002)(4326008)(8676002)(66476007)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0wzdzg4alJzenUzc1lDMVVCMFl6aGdWeTlCRllhQmlJRWdJS3Bnam1xTHFw?=
 =?utf-8?B?Y1RSVFBxeWFlcFE4eHQvbjE2RE5lL2QxNEZuRnFiVUNON0FhQTJCZFNWWXNm?=
 =?utf-8?B?d2xCUThTTHYyNjhhRVFEd1U1bVFoZWQ5cGJLQTNMdEowTjZuTUEvTkJEZGVS?=
 =?utf-8?B?MjV1Q1VPWVFUajNTQkREZUx6cXh4YjRSQmprQUsxQU9jNkNPcDZMMlZ4T0Nq?=
 =?utf-8?B?Nm9DU0VMMVJaVUhrZjRYUnUzc3E1V29uZUNDc0krNDNBcjlaUTJsWjErWXp6?=
 =?utf-8?B?RFhrNGxvbkNsVjkxSElmekJRclloem1DOHdUam9OVlBVN2pNOGowY1ZaSWJI?=
 =?utf-8?B?UWNYYVh3QkJXWEluc0tCRnBMTzdoZXA1U0dkdjN2NmJUMElCWmhRL09maDFj?=
 =?utf-8?B?M0lISVRVa1FGcEwrWXM0ZGlkZkxBNElXRWwvcjIzSEl2Wml5dm5xTlRtU1Jx?=
 =?utf-8?B?Mm9DcjBTS1hWU1ZpRmJXYTNFZGpLWFI5MnhOSks3Yzdwa2E3OGUwSkJ6cHFr?=
 =?utf-8?B?N0J0U1pOeXRoQWE1cndzVCtnYnhrL3NZY3RLa3ZoYzFmYU9KM1VoajFWNFRk?=
 =?utf-8?B?ZHBYZ2xxa2NsSFdCL1RMYThtU2M4WTRKUVI0WWVpWFlEMTVURFFzZXlWWnhP?=
 =?utf-8?B?Z1hxVmxpazhCZFVUU1VGbm5tWU55bnJBL0tXcm1MZWpOUWxBVjJCSUxHdGNo?=
 =?utf-8?B?Y0lsZkE4MDRyUW1vR0cxWWxrNDl5UGJzVDJWL2tLMm0wazVuZzNiN0gxaXZS?=
 =?utf-8?B?V0VsdzdsVnJmeGkvTDJUWUdldlZTcEpnS2o5VitHeWtQb2RnRm4zaVJuZitU?=
 =?utf-8?B?TFNYV3c5cHY1c2FqYm1vamxVWi8vVTFxT1NodGhYY1hkeExrOC9jR24rMW1R?=
 =?utf-8?B?djYyUlhlOERrZTlNVlVicFRhMHRReDhSWTRvUExLdS9uWGsyaGwyNS9EOXJv?=
 =?utf-8?B?bnJEZ3NPTDcwOEp1MDl1WWdDOWppSGtBUndQRFJ6TDAyYjZ4RVdHck85MzJw?=
 =?utf-8?B?WmlJa2lvN1lhYlN1N2NSaG1WQzZHZlVXZHMyQ09aeDdaNWNEOFRmalVVS3lT?=
 =?utf-8?B?K3RKNGdxT21lZkY2N1dDcVYxQzcyYTBJcGtPeEtTU3kya29XajFjUzFGemxr?=
 =?utf-8?B?SW5vYkc2aXBNbnZNQ1RqVmhncmNRS1gzenhuVjRraVZpcFcyNEd3UmhlSlFM?=
 =?utf-8?B?cWRBWStpUVFBZXJHQ0ZVYnhDblNkUEYyTFFXMWVEcERRbURFTWtPL0JaQm4z?=
 =?utf-8?B?TGM1T1dIU3hvQUFUalBsbGlxeCsrQUgxOUtobUJ2SFkvTzFyZmtYQnlGNS9U?=
 =?utf-8?B?TVpCellNblJiNTYwOExQQStSbXVSMHU5RVRWeGgzeWJsUW5yUHVPNk9Wdlph?=
 =?utf-8?B?bllmdEN4UkxSQ0pkbm83Y3BjdG1iMW44RXNEYTI2NVpXVko0L0xhcGtmYTFx?=
 =?utf-8?B?VVEvcTEyOU5BVE9TSU5ML1RvOW10K2VYdXJUbHdrN3pUTVh1UUM1QUFzaEZw?=
 =?utf-8?B?NzRrNzlFdUtwU2ZoaGxwNXppZHNUeGpuVUZTVFM1RHgvM01GL3NiYzVCbmY1?=
 =?utf-8?B?cWNuUURSWTA2TG9rUThHeEtub2RmeVdMUzBKVHhQYzhoZXRTSTFzUXA5R3Zw?=
 =?utf-8?B?a0wrcEZ3WXYzSS9TYnAzTmovM2dzdHQxMy9hWDUrcXIzaG5PYUttNGErNVNj?=
 =?utf-8?B?a0doWVFWWVdOZU9sdi90M3RqZnh0SW9OQ1IxQ0ZWaExZd0w3em9DMFZtWE1t?=
 =?utf-8?B?YTBIaEUvclNUVysxamd5Q3VOQlNVTFhNL2FNdDl5a0xaajFUQU5jNGNUU29T?=
 =?utf-8?B?L2ZvcXZXRjZSck5YU0tiTzFPZWVWYkYycjEyQXBZTEpaTDl0cS9uYUtrUUR3?=
 =?utf-8?B?b3Q4THpmRmoyODNHWFh5RzhOV21UdUUwaUVFQzJ5THBtRms0MnNsNmt0SWkx?=
 =?utf-8?B?MEwxSmRjYmM3THdOcGovWXRyWUduR1lxc1NWZlU2bDZoQllCaTFNMi9HSjFZ?=
 =?utf-8?B?bFFyeWZQQ2EyeG1UNDhKb1NRcy9maUJzbEVDbXBrdTQxK2k2UkVBeVR3SlV5?=
 =?utf-8?B?c0N4Vm5XZ0pJOFZFZm5ZZUMzSHBxTW44a1BKQnphVlZqOEpVd0NNYVFMMEFK?=
 =?utf-8?B?SEloS3MrQjJoaVNsOGJIakJ5TlpWV2R3eDVwYWk4WG4xZEcxVUJhenJZZENj?=
 =?utf-8?B?L0E9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab52031-301b-406d-2491-08dac855d0c7
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 04:40:12.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NeXGFvqf3pzUKl077rgrr8CLCAxSTjm2c2iOA38U0RXw5lAe5ERcFuqFNGj3JBjPG29CZ6VNAt7tiEA/qihEEVnGdv9nDKWwiHSGe5c9JI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7028
X-Proofpoint-ORIG-GUID: 2qP9wRiZ_Q7tWdCFA9iffbccN9-O938B
X-Proofpoint-GUID: 2qP9wRiZ_Q7tWdCFA9iffbccN9-O938B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_02,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=647 mlxscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/16/2022 11:07 PM, Andrew Lunn wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> On Wed, Nov 16, 2022 at 10:43:05PM +0800, Xiaolei Wang wrote:
>> On imx6sx, there are two fec interfaces, but the external
>> phys can only be configured by fec0 mii_bus. That means
>> the fec1 can't work independently, it only work when the
>> fec0 is active. It is alright in the normal boot since the
>> fec0 will be probed first. But then the fec0 maybe moved
>> behind of fec1 in the dpm_list due to various device link.
>> So in system suspend and resume, we would get the following
>> warning when configuring the external phy of fec1 via the
>> fec0 mii_bus due to the inactive of fec0. In order to fix
>> this issue, we create a device link between phy dev and fec0.
>> This will make sure that fec0 is always active when fec1
>> is in active mode.
>>
>>    WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>>    Modules linked in:
>>    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>>    Hardware name: Freescale i.MX6 SoloX (Device Tree)
>>    Workqueue: events_power_efficient phy_state_machine
>>    unwind_backtrace from show_stack+0x10/0x14
>>    show_stack from dump_stack_lvl+0x68/0x90
>>    dump_stack_lvl from __warn+0xb4/0x24c
>>    __warn from warn_slowpath_fmt+0x5c/0xd8
>>    warn_slowpath_fmt from phy_error+0x20/0x68
>>    phy_error from phy_state_machine+0x22c/0x23c
>>    phy_state_machine from process_one_work+0x288/0x744
>>    process_one_work from worker_thread+0x3c/0x500
>>    worker_thread from kthread+0xf0/0x114
>>    kthread from ret_from_fork+0x14/0x28
>>    Exception stack(0xf0951fb0 to 0xf0951ff8)
> Please add an explanation why you only do this for the FEC? Is this
> not a problem for any board which has the PHY on an MDIO bus not
> direct child of the MAC?

Hi

Oh, my initial idea is to provide such an interface, we can add links 
manually in such cases, if it is to solve this type of problem, my idea 
is to create a link in phy_connect_direct, or is there any better 
suggestion?

thanks

xiaolei

>
>         Andrew
