Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD164B337A
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 07:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiBLGhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 01:37:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiBLGg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 01:36:58 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BDE275CB;
        Fri, 11 Feb 2022 22:36:55 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21C401ot014448;
        Fri, 11 Feb 2022 22:36:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UoCwrk0chj8cQ/P0ZH5yf9dnbE+ygO1FoC2OgVVQn/s=;
 b=OXOE2Yk9n8OmW7yI6riOXBtD0kbqXVuV8yJCKhZWW1vjaCtd/kbzZgNKfU3yRoDYLh2M
 9R8IbpeUYmLV4nltBJhDwgu9mx0dElSdbR/g+O7QUw85IUKPvlERYNxbdOFGv64yrGtM
 fnUrngPehYlK7OKBxoTusQ1CWVD5GGcw3p8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e5sug59kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Feb 2022 22:36:34 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 22:36:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLjgEyC2vKqCbqeKQHf4uKKyKyjzy527ztn73HWrBwh5HOrujKfEmR7AZR/+2VjkZV6+6emlblLZQkEGeC2LFXAW/LjeODi5vmzcjh4YXP9eliBgv6SBh2vAcXjrWQRFknQIRyMFzFwfmMtNTpkQKKUfiHdhfbjjMsDU/90Uily0nzzquvu+JohzWcKatQ+7vl/RAcJ4m273jao42SuBnWHH8n5jxBdasw8oWbrypyn40J6HcLDEb7INHUVIe/QHv48Xs7CUx9Q4JTWQaPyRRIi/pjRL1CdsLXC8C44tS+Qxhqx10ksZ3SiblZob7Qu5nu4umijdLFjbkJ9wrenpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoCwrk0chj8cQ/P0ZH5yf9dnbE+ygO1FoC2OgVVQn/s=;
 b=MprfnugcbHpYxA/Q+yfzebFgyX+TFxDeOiPDFUVA24ry2JL8V9piWPehpv8sXbRCE9TIOPk5ulclr/kDcXznWW7IRvmwM1lgt3Y1tYbX/sHsvmptnKyMXm0/wejXphF1DFFDuTdsQP34mocZZOY8/A0sz3qnQSJ/J7so04NaL6Z2PXjtoG1rXmwuCJPozYRsQ6HYiX00Sdf2HDAx3WDZeiJr7fCMkgZXtG34hLYXE3PrLZ8Y0KM6LQw18sX/GPy7vuBum0Q8bxhpNwWeQycpvnSTUu3Xf01yjr03wD/VvBUCJPEnLFgv7o2gNLTK4IGDJJzH/u2D2NCuCOH1FAR7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by BN6PR15MB1251.namprd15.prod.outlook.com (2603:10b6:404:ec::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sat, 12 Feb
 2022 06:36:32 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c5d8:3f44:f36d:1d4b]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c5d8:3f44:f36d:1d4b%6]) with mapi id 15.20.4975.011; Sat, 12 Feb 2022
 06:36:31 +0000
Message-ID: <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com>
Date:   Fri, 11 Feb 2022 22:36:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: BTF compatibility issue across builds
Content-Language: en-US
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>,
        =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
 <YgdIWvNsc0254yiv@syu-laptop.lan>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YgdIWvNsc0254yiv@syu-laptop.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MW4PR04CA0064.namprd04.prod.outlook.com
 (2603:10b6:303:6b::9) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fb8fdae-c50b-4cef-5c3c-08d9edf201aa
X-MS-TrafficTypeDiagnostic: BN6PR15MB1251:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB12519A96F1DB0845B359054DD3319@BN6PR15MB1251.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jxb8RbnpcbWYEbdjMKKhOLM5Einw3kKwBRFtivXbkyXl4uPMosmgxK+HkKiFPF6YHhptrR5xiVPXNcdfnF40HdpHW0O1eZzkG6EYTfAT2i0Dqq7c3M1M5GINRbM/a2udzZ7mofxjJheOqzHxINP5lENdUVR7ItR7/aAUIIlM6Luvz6hWddSNFdO3WLKwUtbFBJUCLPxUT1P8HymZ6q98w5P09hvjBjedcPTys3WCWmIepXEnVRHIwx9jor6zs3sJKfiaIf1+iKgcBpGMPaABpCaKqACQEGrjd5Nqm3lmnYsUiK3pPBWnIVGd8MrwhnZ+LNXFxQfN+O/AtyvsfNym2VCfSFzn4t+BAKLW7JMiRi64FBFtdTDBrC75RV/z8W7ez0qzUrIEo9XOzA2yhIx31LZCMkwVIaDeXJgi2RrTNVjAsVvUKWIUxvyLJbfYP5suDp4piS7UALmiZPHM47srJB1zDrWdmXYW9ox/831fKbfzR/O5qSE9Ea9op+fNnfPCWarz54QefoYUDLeAYZkXAmgzCKXkoe2QY6q31XhNsaB2If0zUgujKwlPFrLcOa5nNg4LGAMYrjkjIIJapqNASxyCnHvYQ8NoWL+D0ZRNsVRXZCHYG8CD2WkzxWGVKYDSCTm7PWchuf+bcAE4X8iJjSUcRp/hBbWvR4RJaAXbQ7+IqjqAycccOiuzxZwEXdwAijTMh3RtSw6IP5L2zpAp2z4VmOGiGuY5EzF/Gk60V5AX9Re4D/iIlkZgnJs5w3b48yeBzys21wfSo+EMUQnlrV1u6lM44yvY/yPnImyrkUmEuoIfT2+KiRAlwOsKRau0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(4326008)(66556008)(31696002)(186003)(66946007)(66476007)(66574015)(8676002)(83380400001)(2906002)(5660300002)(38100700002)(6666004)(6512007)(508600001)(2616005)(6506007)(36756003)(8936002)(52116002)(6486002)(31686004)(966005)(6916009)(316002)(54906003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDVGY2k5aHVlRlZMd3lIbkdSTVBiR2JBVkphNlFzVEh3K2hpL0xXMEt0Sk9v?=
 =?utf-8?B?SDRZTDNnei8yRC9pK01SUjJGNit6cFNwSHVoNXBxNFdmS3RGaTM5ZWlwSTJn?=
 =?utf-8?B?TlJua0FMYkxXVE95SStvUmhxNVZmOUJhRUR1c0VWYWVuUDRhRDJWTTRJRXpG?=
 =?utf-8?B?R3liSEM3em1QODlFY0dSK0dUSWVMbWhKRUxNbUZYYk9NL1RvWUcvTExSREJH?=
 =?utf-8?B?WkEySHBlUzd4VHljdWQ0VVQzZnAyRHVjSGpxL2NlNXpGVFRLcmVrR29EN1p0?=
 =?utf-8?B?NnhET0o4YW90MDhhazNwTndQM29NZ1FJa3Z1MWF4RHppTml1d09ueFpGc2lW?=
 =?utf-8?B?V256c3psbHlhUFlXU09sM0ZnMUJVSlArenhLK0JXdENLUWR1elZZU2NkNW40?=
 =?utf-8?B?NFhZR3hzTjlsS1B3cFg4U29wQmp4OFMrVkxzRFI4akZ4ZTJFM2FKRnhmSG1x?=
 =?utf-8?B?UkpwSVp1YmUwQU5qSUQxdGxueWRpMjhHdU9DZ3hLamI4cFhEQ1h6RGVUV1k0?=
 =?utf-8?B?cHJmUUpwRS9TR2lMc045TUpYNzJoK2F3OWYvOHJycGJkN1d6UGFyWkw2dXdP?=
 =?utf-8?B?T3RqYTh5OVNqR1pFajV5K0M5cDFIMU1HdUZ3NGdFdmpoL0NIeDNKbDZqOXhi?=
 =?utf-8?B?ZHhEMTM1V3RCZHdNbGpkaVdReDJKZzF6TzA5YnlOd0l4Q0VxMEtSQXE3UHNK?=
 =?utf-8?B?TUQ0K2Vrc0pWdWJiMEtjNG1rOEVKL3Nva3NjMWpWTEhaaHRGSDZXSUR2MEl2?=
 =?utf-8?B?dS9IK25oMXF0RWZUUXN4UG8vZ2NFd0oyd1FsdmFLZTFyb044enJIcWxZL1dm?=
 =?utf-8?B?a3lGUHUydjh2UWhBRU9yWFg2MmEwWGc2T0hEWXFzdFlKWHF0RVZOMGwrZGg2?=
 =?utf-8?B?SytGNFV4ajJ3ZytYcWdUWFdFcWpKSjh0NDk0VzkxdmI4S2tBYkcwcG90Si84?=
 =?utf-8?B?bGN1S042SHNETndMZFpHT1pBK3NSZjcrWm52ZmtveE1QOTZrSXQ0V1VDem5a?=
 =?utf-8?B?UlRWSXdwb0kxTkd0UjBQT2RDWmZVVmtKN2pLNmRjZEZnS1JkbCtCWUpQUFAy?=
 =?utf-8?B?UFVndGxVVnVUdzhkU2ZDcHpkT2VaNk9FZlVuYnFweGFUYjR5M1lGRGdaRWt1?=
 =?utf-8?B?b2xScjZja2dEVThQS2RzTzRVUy9uK28yaWNER2J2VUdUUVhHNnVkMHFvM1BQ?=
 =?utf-8?B?VktwaVY0dzdDNEROV1dYTjdsbi9jd2hQTEFmT1l4WGVrQUhVcjh6bUI5M3JG?=
 =?utf-8?B?M1pDY0FEcC8yelBKSi81dUk1anNuZWtObUk0WjBucmFmbzd2S2RDM3RCTE51?=
 =?utf-8?B?d3FVZENTdm42VDR2WjVxRXFNS2lXbC9ZYXNoU21XQnFQV2NvTHB6V1AxNmli?=
 =?utf-8?B?RW1tRUF1RGNiQUd2N3NwRWY4Y2tBRytxL2tIOXVrbHlDYVpPSURVNjUxdEt4?=
 =?utf-8?B?R0xkYUNYV25XNUgrWUF1N291L0N3S1V4Z3ZoNS9MVFNld3hnOUgwQUdYUldi?=
 =?utf-8?B?ZWIxZUhUbFVRUHJhYWpwdmN0cVV2Q0UrcW5uYW0zVDZDTFBQM2ZVaWdVU0J0?=
 =?utf-8?B?eHZ6SGZMNGJjWVpBVUpUL3BYdklmWk9EVVBobG5xUGZDeTNMd2I2UWpyaDN2?=
 =?utf-8?B?YkxZTjdBUit4MmIvL1k4dlN3eUQ4MEw3UHNYeGYvVmRCaGJOcHhFZkdZb1BE?=
 =?utf-8?B?SmpXTStzSTJOSWlCZWRpeUs3TWliVm4yanhhcXhpazdwQzNKanZmNWhaTUZW?=
 =?utf-8?B?Ry9Vak1yakFMU1hOSTM5emFuVG4wbzIwYW55cHhCMTB6ajlzVWlhd3dCYWZE?=
 =?utf-8?B?TnFicXpkUm1KM1hYellJeFJWblpWMFB6bGtSK3ZHNERwRThybkhrK1YvRHV0?=
 =?utf-8?B?TnBwdGRWRjYySXZnVlpWTkJVNERRL3J1dHowQ3BhTEgycU5XbVNSdU1LV1ZD?=
 =?utf-8?B?cm8vbzN0NGIraW5HbjRzWE5WNktXdFE4WW9UUWxEMk0xWHJhTjlTYnVnelNJ?=
 =?utf-8?B?K3hNcFBMVlM0ZFNpNHlLdHlNVVZjeS9oK3llQ0kyRzNOVm9DeHFJcmpWbnor?=
 =?utf-8?B?M0hsV3BpKzBWS3pUV0t0U3hUN2EvN0pTc2c1aTlhU2IySm51YnBmZWtOWVZH?=
 =?utf-8?Q?6MztvHAOAQYeQ8ocZHW07jG6U?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb8fdae-c50b-4cef-5c3c-08d9edf201aa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 06:36:31.9039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBByrpHvL5TuTh6D4S2+7aZAe1TAL1Y7/c/SgaHqseP1aWeQmN77Up6w4D5DG9ro
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1251
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Z0K9AbvmMcEejyPmh_uAEAtvUf_wCF5M
X-Proofpoint-GUID: Z0K9AbvmMcEejyPmh_uAEAtvUf_wCF5M
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-12_02,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202120040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
> On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
>> On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
>>> On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
>>>> On 2/10/22 2:01 AM, Michal Suchánek wrote:
>>>>> Hello,
>>>>>
>>>>> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> We recently run into module load failure related to split BTF on openSUSE
>>>>>>> Tumbleweed[1], which I believe is something that may also happen on other
>>>>>>> rolling distros.
>>>>>>>
>>>>>>> The error looks like the follow (though failure is not limited to ipheth)
>>>>>>>
>>>>>>>         BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
>>>>>>>
>>>>>>>         failed to validate module [ipheth] BTF: -22
>>>>>>>
>>>>>>> The error comes down to trying to load BTF of *kernel modules from a
>>>>>>> different build* than the runtime kernel (but the source is the same), where
>>>>>>> the base BTF of the two build is different.
>>>>>>>
>>>>>>> While it may be too far stretched to call this a bug, solving this might
>>>>>>> make BTF adoption easier. I'd natively think that we could further split
>>>>>>> base BTF into two part to avoid this issue, where .BTF only contain exported
>>>>>>> types, and the other (still residing in vmlinux) holds the unexported types.
>>>>>>
>>>>>> What is the exported types? The types used by export symbols?
>>>>>> This for sure will increase btf handling complexity.
>>>>>
>>>>> And it will not actually help.
>>>>>
>>>>> We have modversion ABI which checks the checksum of the symbols that the
>>>>> module imports and fails the load if the checksum for these symbols does
>>>>> not match. It's not concerned with symbols not exported, it's not
>>>>> concerned with symbols not used by the module. This is something that is
>>>>> sustainable across kernel rebuilds with minor fixes/features and what
>>>>> distributions watch for.
>>>>>
>>>>> Now with BTF the situation is vastly different. There are at least three
>>>>> bugs:
>>>>>
>>>>>     - The BTF check is global for all symbols, not for the symbols the
>>>>>       module uses. This is not sustainable. Given the BTF is supposed to
>>>>>       allow linking BPF programs that were built in completely different
>>>>>       environment with the kernel it is completely within the scope of BTF
>>>>>       to solve this problem, it's just neglected.
>>>>>     - It is possible to load modules with no BTF but not modules with
>>>>>       non-matching BTF. Surely the non-matching BTF could be discarded.
>>>>>     - BTF is part of vermagic. This is completely pointless since modules
>>>>>       without BTF can be loaded on BTF kernel. Surely it would not be too
>>>>>       difficult to do the reverse as well. Given BTF must pass extra check
>>>>>       to be used having it in vermagic is just useless moise.
>>>>>
>>>>>>> Does that sound like something reasonable to work on?
>>>>>>>
>>>>>>>
>>>>>>> ## Root case (in case anyone is interested in a verbose version)
>>>>>>>
>>>>>>> On openSUSE Tumbleweed there can be several builds of the same source. Since
>>>>>>> the source is the same, the binaries are simply replaced when a package with
>>>>>>> a larger build number is installed during upgrade.
>>>>>>>
>>>>>>> In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
>>>>>>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
>>>>>>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
>>>>>>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
>>>>>>> are previously missing in base BTF of 5.15.12-1.1.
>>>>>>
>>>>>> As stated in [2] below, I think we should understand why rebuild is
>>>>>> triggered. If the rebuild for vmlinux is triggered, why the modules cannot
>>>>>> be rebuild at the same time?
>>>>>
>>>>> They do get rebuilt. However, if you are running the kernel and install
>>>>> the update you get the new modules with the old kernel. If the install
>>>>> script fails to copy the kernel to your EFI partition based on the fact
>>>>> a kernel with the same filename is alreasy there you get the same.
>>>>>
>>>>> If you have 'stable' distribution adding new symbols is normal and it
>>>>> does not break module loading without BTF but it breaks BTF.
>>>>
>>>> Okay, I see. One possible solution is that if kernel module btf
>>>> does not match vmlinux btf, the kernel module btf will be ignored
>>>> with a dmesg warning but kernel module load will proceed as normal.
>>>> I think this might be also useful for bpf lskel kernel modules as
>>>> well which tries to be portable (with CO-RE) for different kernels.
>>>
>>> That sounds like #2 that Michal is proposing:
>>> "It is possible to load modules with no BTF but not modules with
>>>    non-matching BTF. Surely the non-matching BTF could be discarded."
> 
> Since we're talking about matching check, I'd like bring up another issue.
> 
> AFAICT with current form of BTF, checking whether BTF on kernel module
> matches cannot be made entirely robust without a new version of btf_header
> that contain info about the base BTF.

The base BTF is always the one associated with running kernel and 
typically the BTF is under /sys/kernel/btf/vmlinux. Did I miss
anything here?

> 
> As effective as the checks are in this case, by detecting a type name being
> an empty string and thus conclude it's non-matching, with some (bad) luck a
> non-matching BTF could pass these checks a gets loaded.

Could you be a little bit more specific about the 'bad luck' a
non-matching BTF could get loaded? An example will be great.


> 
>>> That's probably the simplest way forward.
>>>
>>> The patch
>>> https://patchwork.kernel.org/project/netdevbpf/patch/20220209052141.140063-1-connoro@google.com/
>>> shouldn't be necessary too.
>>
>> Right the patch tried to address this issue and if we allow
>> non-matching BTF is ignored and then treaking DEBUG_INFO_BTF_MODULES
>> is not necessary.
> 
> Not being able to load kernel module with non-matching BTF and the absence
> of robust matching check are the two reasons that lead us to the same path
> of disabling DEBUG_INFO_BTF_MODULES a while back.
> 
> Ignoring non-matching BTF will solve the former, but not the latter, so I'd
> hope that the above patch get's taken (though I'm obviously biased).
> 
