Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D0B4C4AC3
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbiBYQbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238673AbiBYQbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:31:46 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EC81D86C7;
        Fri, 25 Feb 2022 08:31:14 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21P6h7MK028118;
        Fri, 25 Feb 2022 08:30:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZrwZCIafGOeQdbWHaxa5GOGuBlRgsVQCspUgd/SbO5U=;
 b=Zxb9iSYVuSyXFK4FxuukskTqpdHSrqd4anVjYRPFHqXfZyAKKIE3+jdEYdk5I4XU1IuN
 qZzDD7RHhqzF+Ro1huQ4swENEIEF4M1Q+8HIakuHgQEyB80hRh7Jeca3zs7330YsvPwk
 2QUYYbNY/Vomyy7/s+K2aBOBMwOipBqBLYo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eet31b3qx-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Feb 2022 08:30:52 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 08:30:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF1yuDcx9xStktchMO/g5W2I3pw9n/lpKQci+rjzrliXDaM4WI4pVq2QjdghF5eeqjYm9JHjGPTPEX0oT3lQ8guCeG/Ep2E7h3AVypPrIKyf7r5cKvMLHW+F6GkykkIeyXWXuNq50Ty5/Z6sdkin7hfj4sTrdQC8R8ZT67iG9lmBAGr1r1cXfHn5ZNi7JZlaWzULQoetCX2tfB/opOVRwswup0pNHk64bg3JdE2cMSKq8fPMkPPEt+mAzJU8IwXCmE65c5b/uc1PfYoIJwfaMyo4tHTztlUOYoLOe4NtDEgN8H9Os/o305WZtdwJa66Fn2E0vlenvyvwyymMxMVQXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrwZCIafGOeQdbWHaxa5GOGuBlRgsVQCspUgd/SbO5U=;
 b=EnNSXZ/oU19pbxXr/MD+1YIIUvJucKMgxQSHJJgzvq/IYL0P2t6USX6Z6zHo3I2inxm8OBz6fPMgSDgcP+d9lfLDehEm8z+3a7cjKj6IV47UEHEgSDVuu4+PpUVRescF9MGlTIGWRP0ERXvlMC8KvegfHE1g4ZYpSeeq7qCrTcqPzMRhqHih1uedV6HJm8OBuEfQglBrS/DjOKtuJBZsrdQnPym7v7T4hNUcV5swV/Ccm7occSE2jw8NbAqBL4xvR8bciHOins3RpnIggvlHxfDdTvnciTvxnvfz/fx4OLo3W99l9VW0E36QSWngMita/Db1lt/je5TYI3sZD63Nnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1886.namprd15.prod.outlook.com (2603:10b6:301:4f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 16:30:49 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 16:30:49 +0000
Message-ID: <f5834588-d1cc-8d88-ea9a-0ae6399dbffc@fb.com>
Date:   Fri, 25 Feb 2022 08:30:45 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Peter Hutterer <peter.hutterer@redhat.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com>
 <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
 <ed97e5e8-f2b8-569f-5319-36cd3d2b79b3@fb.com>
 <CAO-hwJ+CJkPqdOE+OpZHOscMk3HHZb4qVtXjF-bkOweU0QjppA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAO-hwJ+CJkPqdOE+OpZHOscMk3HHZb4qVtXjF-bkOweU0QjppA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:303:b5::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f70d8cbf-95cb-45b3-3a40-08d9f87c2ece
X-MS-TrafficTypeDiagnostic: MWHPR15MB1886:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB18861253C8D91533EF492A65D33E9@MWHPR15MB1886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHzxTV24yd2WrPX8p5WCbtgNVhTnLDQ95FY9zJ7ps1RUuTOAUF+Gjwc4nv7vF4wjX1OlpuHpRK3o99jodkOYQvd2UvjrMewZUNJUQmsWR6z0POxfsJMK3lf5jBtGOmuGn6wOoRATrz7v80jiuOKp477wXD4sSi56zDJYVUTE1ZYthfVpxvfIacX1maIHYpJ1cn9Ng6xrvY3QiKitB1hn546yxZJRfYs2/DLEHlRJg6oDK1vAlM13hUipjk3yW9FGAjU4EFyscjnTggJmWyebWx4UgFkD8hN7eOeemxBXHS4FJhTOnIr3eNe9ltUV/1dw9UzjVjsej/Z3S3xc1mvSd0mqBrL0QoOjvRABgNU3c0cMzP2Tqe3YlAXFsxtiR1jGnHl1qHN52mJcoW2TvoVAz6SWwKgubcMz6bMAkc8R2IC7S8+WdpyXiNszJrr8IjnyeCFetH8k8wNtQeMCpnfa22yls9712zakitj1WC6/jgxxipKqKVYsHNy6k38XXjXEsRXsvh2wCsmJ0MUnxq1if7KXwuqGmLVl5caoc6nmwNk9mjR6pQ+3Pv0xOIT4ybLxwlz/hidACpJE3X/XSVgDF3qtf+Dqw/gboBIfsB/W52/9LK6cmuplRX246x3zm16R2nRGvAev24hHNwBnEkz9Z9ZnCHXrB0Hvjx0MNSIBEVJd3rafxhrXyBGyCNFJO0/r5JNLGgPYTCQRe7Ld0mH1x0GV1cKjwgtuLdEZVnBPifc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(7416002)(6486002)(8676002)(66556008)(5660300002)(186003)(2616005)(4326008)(8936002)(31686004)(83380400001)(2906002)(53546011)(6512007)(6506007)(6666004)(52116002)(31696002)(86362001)(36756003)(38100700002)(54906003)(508600001)(316002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmJnbHI2Y1BCdHpQWitTVjRmNFAxU0o1UlYrbEhVWGVQQ2RIaDZVeGE1ZmVx?=
 =?utf-8?B?blpkWHJsblFaaVBUd2ljUDRVUzB1RGlCdG9nZGZiQ3JOcGdTc0tXWEFqWElT?=
 =?utf-8?B?SUxhd0dDd2s3UUt3cFpkb0I1Nk1yZkZ2bWEzRm05bWwvY1NwN0JmR0ZnUjZl?=
 =?utf-8?B?VzJlYXhKeHlPeHZPQVQ4RmVRc1dFSWNmT3ZqanEzdWx2U1lMY1VybkhSVWlx?=
 =?utf-8?B?Z2s0eEVJdzAvY3hJSnU5VzJUQllRSGU4VHI5Q24rSHpuM0o4YnNtRERRMzZ5?=
 =?utf-8?B?VVFJWSt3U2Y1VkZ5djVGSmlsbFRSYWN2blpweVhJalBtWFowd3dDOEhXbU5O?=
 =?utf-8?B?cjZFSkM1aXorNGZmZkZTTnpTc0xwTFFiWUdFOXJMM3hnWktUMms0NCsrR0E2?=
 =?utf-8?B?TXpBWjlTSVF0MnJ6WUVWTzRVNWZEdEV3alpEQXpkNEswK0J4Q3RNcXh3ckZ3?=
 =?utf-8?B?ZDRLQXZwQUc4SnY4N3VQdnQ5UEszV2cvRCs5Mk1zNnhESWdPbWpoZkpTQ3JU?=
 =?utf-8?B?OHVicU5XdGZpQmtXSG8raTN4bXE4eXpGZE9nbDB3QjN6QVNMSFFIV0szRXJ2?=
 =?utf-8?B?d1FaRVYreEw2VEdBMTdYL0Z3SXFzaFl5Yk5oQUF3OXhiNkkvTmZHTXRJMHNC?=
 =?utf-8?B?anZ3QWlybEZ0cXgrKy9jUHBrVGM3dkZROWNMNVp4MHNuRW82VzJZN0tRR25B?=
 =?utf-8?B?SHduY0V5Q1Yzb3FZUXA4VENZci9yRXI4VlBvUTYxZTFZTE5NS3Nja1ZxTFJI?=
 =?utf-8?B?a2NZTU5ZVTdleDhJWHg3eWw2NHdrZWlHOTlOeE9XRXJPSWJlKy9QUTlUSGhn?=
 =?utf-8?B?MHN0MmQyTnZXUkJ1NU1wdUpLc1kxTktJdE8ybUJxNGhiMFFaQXRNeDI3NktL?=
 =?utf-8?B?YkxKeG5BM2o3TXNWVWo3czJJTDFmV0dnY2RidlE4Y2dEakNlV3lhajk4Wlhn?=
 =?utf-8?B?SVl4dGFycmw2TitxcEw5SHd4cFJ1d0Q0cUF4QUorNUxLSHVMbnRjR0JJcnlW?=
 =?utf-8?B?RmN3WTlKb2hucWZpOVl3bGJDQUxBRFBSTlZUeFZsemJudmNReXA1SVM3WjUw?=
 =?utf-8?B?dVdOeS8vR21pU0FFR1V4QjI2WDUvdm16TVBaaHV6bUN6SWxZSHZTWVJzTlFk?=
 =?utf-8?B?bklYR2t6ZWN3Y2JkMlpGUksvbm9xUjNFei80UW9UNFhtNlVkRkdtMjBvR0Zy?=
 =?utf-8?B?WTJUZllSUmw4YkNmOUxpbHo1Ym53Zy9VR2tPY3NPRUFzaVhldkRsUmhQQnVj?=
 =?utf-8?B?NHQwa1l6RlNXRlFPR1RVOHMrMHBSajBtWjJiWDgvVFBWMFRpYzQ4cnhXZENK?=
 =?utf-8?B?Qk1OYkpmWjFwTFBoVWZWcHBhK0N1aVNZNnVMT0VQQlZzbGtxOWRkcWhtelhY?=
 =?utf-8?B?UUJhQXQzdXhUcjNGWHkramVLZ2Rnd3pRR1Z5cHZzQXhlNVh5aUhjVDJiN0FX?=
 =?utf-8?B?dmVjdjJSMDBHZEowSWVxQjA1ZEE1WGFpZjFMWDdrUUhsMlMvRCt5ZVlFUnRI?=
 =?utf-8?B?cWJBVGxsWTVsVXIwTnZIalF2bTlSQnNmMisrdTE3ZXpNbm9SdUNFZFBXMFhv?=
 =?utf-8?B?VkhCN2tuc2hxL1BJQ05BUG8xUEh1VDNRdmxsLzhNSVN4WWRsR0JBNXc5VW0r?=
 =?utf-8?B?d2RmcDZJcUdETmRlbm4yTXVYblgvT2tDZlVaTjlwQXVLb3VvS2JUNU1HVnBW?=
 =?utf-8?B?NGpLNUlzU1dwMkljZEtvOGpERFFKK3g4Tkc0dDVUY2VkQUdMVTUrelhpUHd2?=
 =?utf-8?B?aTNRYTdmcGV2c2JheDRVZzBpNDU4c0pzQ1kybFlkQ3ZsYTNWR0pXQjBKRFlq?=
 =?utf-8?B?R3VVUGxsS0lMZDltN2VlMlRqbFJOSkJSSFBIODJGU2pBQzhwdnpqa01FeFMy?=
 =?utf-8?B?aktGWE5iU3J0S29PTVRnTkpKWml4UUFza01aWjlob1BERlZxdzlhcUtKSTUv?=
 =?utf-8?B?QTVXU3RRc05CYklzdmFITzJRdE9SZmJwR2s2aVgrSmxsL3hlV05KaXdOVS9l?=
 =?utf-8?B?bllVc0VCWWdFZ1FJd1YvRy93T2p1ZGxETVdDdFNtakVvaWYzYm9ibXA1bm5W?=
 =?utf-8?B?ZWZHVHk4Z20xQnhTZTh6VDVrSHZnTDFvTis5MlFkR2pHc1M4N3I2UzdpbERF?=
 =?utf-8?Q?gUDM0+qdZzYWXhveKtvvk+7Lc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f70d8cbf-95cb-45b3-3a40-08d9f87c2ece
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 16:30:49.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JD/+4HmpWbSFgCexEMXqOLAw8eotkAftjjAID9hVGNKBW6+Kxt/9H4MMiJZBeW71
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1886
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Aip31-KL9q6UVKg4C1Sa7rX_THyuDa-k
X-Proofpoint-GUID: Aip31-KL9q6UVKg4C1Sa7rX_THyuDa-k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_09,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250096
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



On 2/25/22 8:06 AM, Benjamin Tissoires wrote:
> On Thu, Feb 24, 2022 at 6:21 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 2/24/22 5:49 AM, Benjamin Tissoires wrote:
>>> Hi Greg,
>>>
>>> Thanks for the quick answer :)
>>>
>>> On Thu, Feb 24, 2022 at 12:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
>>>>> Hi there,
>>>>>
>>>>> This series introduces support of eBPF for HID devices.
>>>>>
>>>>> I have several use cases where eBPF could be interesting for those
>>>>> input devices:
>>>>>
>>>>> - simple fixup of report descriptor:
>>>>>
>>>>> In the HID tree, we have half of the drivers that are "simple" and
>>>>> that just fix one key or one byte in the report descriptor.
>>>>> Currently, for users of such devices, the process of fixing them
>>>>> is long and painful.
>>>>> With eBPF, we could externalize those fixups in one external repo,
>>>>> ship various CoRe bpf programs and have those programs loaded at boot
>>>>> time without having to install a new kernel (and wait 6 months for the
>>>>> fix to land in the distro kernel)
>>>>
>>>> Why would a distro update such an external repo faster than they update
>>>> the kernel?  Many sane distros update their kernel faster than other
>>>> packages already, how about fixing your distro?  :)
>>>
>>> Heh, I'm going to try to dodge the incoming rhel bullet :)
>>>
>>> It's true that thanks to the work of the stable folks we don't have to
>>> wait 6 months for a fix to come in. However, I think having a single
>>> file to drop in a directory would be easier for development/testing
>>> (and distribution of that file between developers/testers) than
>>> requiring people to recompile their kernel.
>>>
>>> Brain fart: is there any chance we could keep the validated bpf
>>> programs in the kernel tree?
>>
>> Yes, see kernel/bpf/preload/iterators/iterators.bpf.c.
> 
> Thanks. This is indeed interesting.
> I am not sure the exact usage of it though :)
> 
> One thing I wonder too while we are on this topic, is it possible to
> load a bpf program from the kernel directly, in the same way we can
> request firmwares?

Yes. You can. See the example at kernel/bpf/preload directory.
The example will pin the link (holding a reference to the program)
into bpffs (implemented in kernel/bpf/inode.c).

Later on, in userspace, you can grab a fd from bpffs pinned link and use
BPF_LINK_UPDATE to update the program if you want. This way,
if your driver uses the link to get the program, they will
automatically get the new program in the next run.

> 
> Because if we can do that, in my HID use case we could replace simple
> drivers with bpf programs entirely and reduce the development cycle to
> a bare minimum. >
> Cheers,
> Benjamin
> 
> 
>>
>>>
>>>>
>>>> I'm all for the idea of using ebpf for HID devices, but now we have to
>>>> keep track of multiple packages to be in sync here.  Is this making
>>>> things harder overall?
>>>
>>> Probably, and this is also maybe opening a can of worms. Vendors will
>>> be able to say "use that bpf program for my HID device because the
>>> firmware is bogus".
>>>
>>> OTOH, as far as I understand, you can not load a BPF program in the
>>> kernel that uses GPL-declared functions if your BPF program is not
>>> GPL. Which means that if firmware vendors want to distribute blobs
>>> through BPF, either it's GPL and they have to provide the sources, or
>>> it's not happening.
>>>
>>> I am not entirely clear on which plan I want to have for userspace.
>>> I'd like to have libinput on board, but right now, Peter's stance is
>>> "not in my garden" (and he has good reasons for it).
>>> So my initial plan is to cook and hold the bpf programs in hid-tools,
>>> which is the repo I am using for the regression tests on HID.
>>>
>>> I plan on building a systemd intrinsic that would detect the HID
>>> VID/PID and then load the various BPF programs associated with the
>>> small fixes.
>>> Note that everything can not be fixed through eBPF, simply because at
>>> boot we don't always have the root partition mounted.
>> [...]
>>
> 
