Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFD94B7716
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbiBORsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:48:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiBORsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:48:09 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7D0AB459;
        Tue, 15 Feb 2022 09:47:59 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21FHPEma022786;
        Tue, 15 Feb 2022 09:47:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AUwOuSTywyU4nPUnTnZcvaXNroNFgjALDWCZcbACFaQ=;
 b=dja1bNrbv7CX8qbmiIEcvhfYUUg+KiC6o7K7Hqk4E7bbzVCCJ/SUwooyHj2vMUVnIo+I
 MNaVJRoe2wUA/7CSubvmSco9IJoXEYfVjwFIuA7sqixdfR+hqVs0PKVVf+cp96onoY0W
 LecDx1xMigCpgYy9PZsctbiCy8gzZN+5Bws= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7py4tg7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 09:47:36 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:47:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyH3GKLURb9ixcghkDkzdgnMO7dPiBJ7Gi2tQMYj9zMMB05w4hLPZClLqNdm/TuzyBKMWZ/GXdaEUf4wy99N6UmuDp3o70PgCqH3luoOoK16EmIoPu4Lxj6LVBT2t82Sngcp895lnTswq7JVLv0WiIPCCugA7P4wv2GCCp4ZBH5i5lmfk8RNfFUPzfNXPnwqm/LgYCgkqrfrEZ7xiyAuC6zkogfBuXuePA22RGLtMvdkWMOULZ2bxNmjpT7mdJFjQ/sZjDqKZZRgo5bIKOpUIf6tAaBy0tvpy9cZSq8rs6QKbGThr87wmamQb5cggwqq1Fade9VuH42owtGG898/AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUwOuSTywyU4nPUnTnZcvaXNroNFgjALDWCZcbACFaQ=;
 b=WeEPB191X/1kyMhWhBQUambrwvv0k/PiakBOW4Ynkz/TL83maFPKTSUcFSHwHD2surePNg34P2acBSdiTkzdC3k+xYu+c/JDSsMv8Mz7CsXuKyUygKqeW/8IR/xv8vOGavaLxbAv2PEiEPPl/gB4VFyEDaGxDM6phBKKhT7jWIH0oRWVSrQ+biisEwy/sEBl+yP/dGyEQS2U7p6c/G7uTjlt/BbMGV+Y6+hYhYwig6SMSqP0IdsR0ptdrxC9/U14/rcRjrZtPPBema6rJOfptF+QymilbnvH+JsmcnHPi7wrzyUM13v8e0j0Gww+e2SHB/KQO57ssMYJnbu4rB09PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4234.namprd15.prod.outlook.com (2603:10b6:a03:2c9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Tue, 15 Feb
 2022 17:47:26 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.4975.015; Tue, 15 Feb 2022
 17:47:25 +0000
Message-ID: <0867c12a-9aa3-418d-9102-3103cb784e99@fb.com>
Date:   Tue, 15 Feb 2022 09:47:22 -0800
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
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com> <YgwBN8WeJvZ597/j@syu-laptop>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YgwBN8WeJvZ597/j@syu-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:300:6c::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97ca2d4a-42ee-45da-4f4c-08d9f0ab3a3b
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4234:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4234E10E597E54E8CB17C564D3349@SJ0PR15MB4234.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JflZ7AAy7G443rTHAzLezCUexBqtoCG1oWNNY1phtR/+kgqjvGZzo/1in7aMozDwplDVj8XL/TZxZqE14pTmCr9tSzv/j8EWBXbI0mENy++2gQDFCkYIfTEo7wlvVKzCbFiAAJd+1x9SUNFz8jRnz1iHtdJljIOeTSsbYD/j5hb07yEQbK2kMvsEshG7UfHbv4Hwv1Z0C2EvgjRMNlJVI2OWo6aOznuihkg+6b1z/L6IaRXqlrBMBjjbVUVTzFcv80HDJt1IYsVwIHLflJHkxGyZXVPk4eRW7swceAg+67SHu256HYlyzAcST7wE2+T1CN535vNi/AQrvuoxCymnuQ1NXcr6NrCzvNw88CjDEkAi8mgqXdJLYDkkr/rIWEdWwNg8s8/eYGNHxjQ46epROFovEdqUtf7TAdcqhQhIRlOLaDuBzzXJGRZLfHSUKYEWsZqboKzpHjyYfnaJM81WtuW+DVDOmoODs9yo71cvgX7OHyxW93NVNHBV/ypljsVi1Zv6KfJRQRUI7QseSNMuQDRRbc8ajCO72jIBrvTXa0nSu5edX3Vyt1dB/hOAlAkWLlQycuU+FMOSOAKb/Sr7i5JfmoyNWbLUHyLUx5nZxj44d/iMBNTmbyHYLg7YKR3ayP5543y6QR9OLquZWQ21d7/53ST+ZeyWPTAV2+J0Hm2wWNV8d6tbmqqdf4HqR0zI5yosCix+LJTuWleRG3vHUPpaHkoSS03xla8+WF7nHrqdobZiGASEfHLlO88yE579K3htSmWRsyQlL3ZC/IfqtdJFjUcMJh/5DDiE7BDF5Ao6MtuRu0DXOVpFQ2ptYTQ/dldVnTiplCrVomh3bkoZzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(66574015)(38100700002)(8936002)(966005)(6486002)(508600001)(5660300002)(8676002)(66476007)(66556008)(54906003)(316002)(186003)(2616005)(2906002)(66946007)(4326008)(6666004)(6512007)(52116002)(6506007)(53546011)(31696002)(86362001)(6916009)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEFvdnloaU1JakVVVGJlRzRSNWYzOEJCNnRRSEkwRS9kVU5oYWdzaUdhL1hH?=
 =?utf-8?B?WVovcnV6RCs2TEQrNVFiZHJpZnByL0hCblpraDhTaEpDRUhUWXM3QVZRblJj?=
 =?utf-8?B?UFRZTTEwVFBucVJudEg4ZE0zMWc0NkFVdTh3NzlmaDRnNUtsc1VDQzI4UXZn?=
 =?utf-8?B?aWptNTg2cVZiVXVYMjUyQnZJZTRDZEIzMmRqUkdDQWFtMldOYVVKVmRaVDJ5?=
 =?utf-8?B?aTVZbTFmMzFsMDkyODFmdEhKQXJ0NmJmUGo5MEdpeVppQkVCYzcvUUpJOUxw?=
 =?utf-8?B?Q3V5UjZ5anhIM2N1QUR3eVdLdUJyME9vcHJVVXZMeSsweE9IZXpHbGJydEtG?=
 =?utf-8?B?ZUJJbFdZSzVvajB3b3hnWlVBVjRmRkhGQjYweENJMnBaSnJHaEUyZnR0SFM1?=
 =?utf-8?B?VWsyNDFSRll0WTlPdUJaQXlkY00xOElpT0N6cUVrc1RnV0VWVm1MczdncWk2?=
 =?utf-8?B?R1JYNkNWMmZZVUJ0OW8zL2hpSTd5WFpFQVN5cTcrdEpkeEg2VHRXK3dva044?=
 =?utf-8?B?NnkvYmhkNU5tZWh0UHB1VENzcWhFbkxzZEhtZUFUNTFaeHpVRUx4WHMvSlJD?=
 =?utf-8?B?dEluWXVsM29KM0hrdm5XYjk3Z3BiQWdSREhrUkRlMTZXS1JjTG1ZNmEzWUdN?=
 =?utf-8?B?QmFQYzVUZjBzL2xlbGQ1aWZFWW5kRmZrY2NIaTVaZktBU2RBODAwUkhVaXky?=
 =?utf-8?B?Sy9EOHgrdGRTTGFoRFo3a1V1cGpjeGtUdE9YZzNiMjdMcWQzZWYvOUNXMUNP?=
 =?utf-8?B?SXpmdTdyMnRWa0podGg4V2d2S0pHcytjd2NjN203b2JSOTZ6TUx0azlkR2kv?=
 =?utf-8?B?UlVZNlYxMmNiNUdVZHAvaHhqWFlVYVA5Mlo5R20zS0FuMWhoaDEyNWg1WVJW?=
 =?utf-8?B?WnFUTWkyR2IxYVJjV1lWWC9JdlNVZ0pJUXZJVFlybUxaZSsyd2hOd3ZLa2R1?=
 =?utf-8?B?UWR1NFFOQ2pCU1hXc01SL1BtWXJYSHZ6TUNOU1EwaXhXN0MwempjQ2R4d0o1?=
 =?utf-8?B?VWJvUSt5cnF3dEFGSmlFek9HZmFaTHVFMlhDSGZObUoxYUdyVXArYUdLUERm?=
 =?utf-8?B?M2IzOGNwSGhMTEZUTFBXa3ZWSU9Pa3cxNkVUTisybmEwcnhMejYvTjdNU3pE?=
 =?utf-8?B?YTg0Q09MUTU3WDdDREhPNlFpNW9Mek5vMmdWcVBWMGxENkhjQW9RQ3ZieVps?=
 =?utf-8?B?Tk4xTWJoK0F5UVFMUlFVWE9LbDZ0Yklwbi96Y0p6a0k4Z21QazU4T1dmY0ts?=
 =?utf-8?B?Q2RQVzNrSzl6bWUwa1ByNGhsdFl6VmNKbGlqM1dsbDlUVlpDbFdzMjd1N2Fj?=
 =?utf-8?B?UkxMcGh3YTY2RFV5RHVaelFBYkl0RGlQckdBLzFkWkVia0NUWjhXWFFwcHlJ?=
 =?utf-8?B?Nng2Mm84a3orSkhQaGNkYmczVzNPd3VTRXIyYmlaQkhRb2FCZENZMndJcytt?=
 =?utf-8?B?Z3JteEZNSTE1UG5Nckx6a1VJYnZLM2JUeVZIZ1N4WDZqcXNCSHBDcFpRN01a?=
 =?utf-8?B?MG85dDdYUWIwUTR1T1YvK29CUzVpR3J4M016NE40Mnc1M2laMXMyU0lzeU5p?=
 =?utf-8?B?L25wZ2VOM0x5b1hrOGdKTDgzaUgyeGZSckZjRmJwdk9ML25mdFFTU3JBeVp6?=
 =?utf-8?B?bjFFSFdqM0syVEl6QVRuaTNjdjJrb0doNjhNYVhiSEwwaFR4dXp2bVQ4YUNt?=
 =?utf-8?B?NWliNURoOE5LRFR1TzNzVEl5WER6cXJYUFM1TUlpamhhdHFyYnJDUzBGbnRm?=
 =?utf-8?B?NG1SQkZBNU01QzJDZmhiQkQvWHVySHd3aElKQlNZNURjZnd3TGY5MnR2WElh?=
 =?utf-8?B?dkcrTG90WGxPeTM5S3ZidnNYWTFXUDQ3TG9CSFUvTWVBRHFzN2s1akkwTXBB?=
 =?utf-8?B?NGlZVm0vZjJxb01oM2JTVFpuTitiMnlkOXhWejJKVWpSWVQ3c0RNcG9ScjBW?=
 =?utf-8?B?eWMxcFpyWUFVTE9ML0sweDA1amJiQVBrdDA2WGN5NGZsZGd6U01UOVg5dFh6?=
 =?utf-8?B?bndRWEVWNzh2cFJSZXQvY1ppMjE0SzhHN1lhUVhSejI1eTVDakRweDVlZWRJ?=
 =?utf-8?B?eURWMXhuYUtPZnBjM1BKU2xiRXFwNmdBUHpFek1TUVExaWEzZUxlUHEzNjdC?=
 =?utf-8?B?WE1JNkp3Y2EyZzZwZW1KQnZibXVPS0NWSnJ0dFBEK0s1MEVaYjY5VWg4S0Fz?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ca2d4a-42ee-45da-4f4c-08d9f0ab3a3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:47:25.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DuaUXqRJbBv/D7a6xIZXrr7Ptod0YKzr0gIC45MicHsZJ8ZpLbO2pwULS72Z9PCc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4234
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: OOYA-ngGtIr9K9nPVTspnsmxvIcFScuZ
X-Proofpoint-GUID: OOYA-ngGtIr9K9nPVTspnsmxvIcFScuZ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150103
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/22 11:38 AM, Shung-Hsi Yu wrote:
> On Fri, Feb 11, 2022 at 10:36:28PM -0800, Yonghong Song wrote:
>> On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
>>> On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
>>>> On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
>>>>> On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
>>>>>> On 2/10/22 2:01 AM, Michal Suchánek wrote:
>>>>>>> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>>>>>>>> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> We recently run into module load failure related to split BTF on openSUSE
>>>>>>>>> Tumbleweed[1], which I believe is something that may also happen on other
>>>>>>>>> rolling distros.
>>>>>>>>>
>>>>>>>>> The error looks like the follow (though failure is not limited to ipheth)
>>>>>>>>>
>>>>>>>>>          BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
>>>>>>>>>
>>>>>>>>>          failed to validate module [ipheth] BTF: -22
>>>>>>>>>
>>>>>>>>> The error comes down to trying to load BTF of *kernel modules from a
>>>>>>>>> different build* than the runtime kernel (but the source is the same), where
>>>>>>>>> the base BTF of the two build is different.
>>>>>>>>>
>>>>>>>>> While it may be too far stretched to call this a bug, solving this might
>>>>>>>>> make BTF adoption easier. I'd natively think that we could further split
>>>>>>>>> base BTF into two part to avoid this issue, where .BTF only contain exported
>>>>>>>>> types, and the other (still residing in vmlinux) holds the unexported types.
>>>>>>>>
>>>>>>>> What is the exported types? The types used by export symbols?
>>>>>>>> This for sure will increase btf handling complexity.
>>>>>>>
>>>>>>> And it will not actually help.
>>>>>>>
>>>>>>> We have modversion ABI which checks the checksum of the symbols that the
>>>>>>> module imports and fails the load if the checksum for these symbols does
>>>>>>> not match. It's not concerned with symbols not exported, it's not
>>>>>>> concerned with symbols not used by the module. This is something that is
>>>>>>> sustainable across kernel rebuilds with minor fixes/features and what
>>>>>>> distributions watch for.
>>>>>>>
>>>>>>> Now with BTF the situation is vastly different. There are at least three
>>>>>>> bugs:
>>>>>>>
>>>>>>>      - The BTF check is global for all symbols, not for the symbols the
>>>>>>>        module uses. This is not sustainable. Given the BTF is supposed to
>>>>>>>        allow linking BPF programs that were built in completely different
>>>>>>>        environment with the kernel it is completely within the scope of BTF
>>>>>>>        to solve this problem, it's just neglected.
>>>>>>>      - It is possible to load modules with no BTF but not modules with
>>>>>>>        non-matching BTF. Surely the non-matching BTF could be discarded.
>>>>>>>      - BTF is part of vermagic. This is completely pointless since modules
>>>>>>>        without BTF can be loaded on BTF kernel. Surely it would not be too
>>>>>>>        difficult to do the reverse as well. Given BTF must pass extra check
>>>>>>>        to be used having it in vermagic is just useless moise.
>>>>>>>
>>>>>>>>> Does that sound like something reasonable to work on?
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> ## Root case (in case anyone is interested in a verbose version)
>>>>>>>>>
>>>>>>>>> On openSUSE Tumbleweed there can be several builds of the same source. Since
>>>>>>>>> the source is the same, the binaries are simply replaced when a package with
>>>>>>>>> a larger build number is installed during upgrade.
>>>>>>>>>
>>>>>>>>> In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
>>>>>>>>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
>>>>>>>>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
>>>>>>>>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
>>>>>>>>> are previously missing in base BTF of 5.15.12-1.1.
>>>>>>>>
>>>>>>>> As stated in [2] below, I think we should understand why rebuild is
>>>>>>>> triggered. If the rebuild for vmlinux is triggered, why the modules cannot
>>>>>>>> be rebuild at the same time?
>>>>>>>
>>>>>>> They do get rebuilt. However, if you are running the kernel and install
>>>>>>> the update you get the new modules with the old kernel. If the install
>>>>>>> script fails to copy the kernel to your EFI partition based on the fact
>>>>>>> a kernel with the same filename is alreasy there you get the same.
>>>>>>>
>>>>>>> If you have 'stable' distribution adding new symbols is normal and it
>>>>>>> does not break module loading without BTF but it breaks BTF.
>>>>>>
>>>>>> Okay, I see. One possible solution is that if kernel module btf
>>>>>> does not match vmlinux btf, the kernel module btf will be ignored
>>>>>> with a dmesg warning but kernel module load will proceed as normal.
>>>>>> I think this might be also useful for bpf lskel kernel modules as
>>>>>> well which tries to be portable (with CO-RE) for different kernels.
>>>>>
>>>>> That sounds like #2 that Michal is proposing:
>>>>> "It is possible to load modules with no BTF but not modules with
>>>>>     non-matching BTF. Surely the non-matching BTF could be discarded."
>>>
>>> Since we're talking about matching check, I'd like bring up another issue.
>>>
>>> AFAICT with current form of BTF, checking whether BTF on kernel module
>>> matches cannot be made entirely robust without a new version of btf_header
>>> that contain info about the base BTF.
>>
>> The base BTF is always the one associated with running kernel and typically
>> the BTF is under /sys/kernel/btf/vmlinux. Did I miss
>> anything here?
>>
>>> As effective as the checks are in this case, by detecting a type name being
>>> an empty string and thus conclude it's non-matching, with some (bad) luck a
>>> non-matching BTF could pass these checks a gets loaded.
>>
>> Could you be a little bit more specific about the 'bad luck' a
>> non-matching BTF could get loaded? An example will be great.
> 
> Let me try take a jab at it. Say here's a hypothetical BTF for a kernel
> module which only type information for `struct something *`:
> 
>    [5] PTR '(anon)' type_id=4
> 
> Which is built upon the follow base BTF:
> 
>    [1] INT 'unsigned char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
>    [2] PTR '(anon)' type_id=3
>    [3] STRUCT 'list_head' size=16 vlen=2
>          'next' type_id=2 bits_offset=0
>          'prev' type_id=2 bits_offset=64
>    [4] STRUCT 'something' size=2 vlen=2
>          'locked' type_id=1 bits_offset=0
>          'pending' type_id=1 bits_offset=8
> 
> Due to the situation mentioned in the beginning of the thread, the *runtime*
> kernel have a different base BTF, in this case type IDs are offset by 1 due
> to an additional typedef entry:
> 
>    [1] TYPEDEF 'u8' type_id=1
>    [2] INT 'unsigned char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
>    [3] PTR '(anon)' type_id=3
>    [4] STRUCT 'list_head' size=16 vlen=2
>          'next' type_id=2 bits_offset=0
>          'prev' type_id=2 bits_offset=64
>    [5] STRUCT 'something' size=2 vlen=2
>          'locked' type_id=1 bits_offset=0
>          'pending' type_id=1 bits_offset=8
> 
> Then when loading the BTF on kernel module on the runtime, the kernel will
> mistakenly interprets "PTR '(anon)' type_id=4" as `struct list_head *`
> rather than `struct something *`.
> 
> Does this should possible? (at least theoretically)

Thanks for explanation. Yes, from BTF type resolution point of view,
yes it is possible.

> 
>>>>> That's probably the simplest way forward.
>>>>>
>>>>> The patch
>>>>> https://patchwork.kernel.org/project/netdevbpf/patch/20220209052141.140063-1-connoro@google.com/
>>>>> shouldn't be necessary too.
>>>>
>>>> Right the patch tried to address this issue and if we allow
>>>> non-matching BTF is ignored and then treaking DEBUG_INFO_BTF_MODULES
>>>> is not necessary.
>>>
>>> Not being able to load kernel module with non-matching BTF and the absence
>>> of robust matching check are the two reasons that lead us to the same path
>>> of disabling DEBUG_INFO_BTF_MODULES a while back.
>>>
>>> Ignoring non-matching BTF will solve the former, but not the latter, so I'd
>>> hope that the above patch get's taken (though I'm obviously biased).
> 
