Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECD4369AF5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 21:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhDWTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 15:33:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2538 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhDWTdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 15:33:43 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NJOruX014541;
        Fri, 23 Apr 2021 12:32:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CyJT3ECez29ynNNqvBtwxuqI73Q9ZiWfhXqu5BexR3I=;
 b=mLR+8d0H9/JZm4htw4n/bPkyZxZQF8Ru78gi4NtgdGSgOsIhxQQ+2iqT7/qM6wmgtEtD
 3pxY5EbHX35Yxsc/jhaSwcPjLtmYuIcVmhtBQwbjM+Cm1ic36vJ86oKJlVG7/XJuFfD1
 1g4WPaxwLHBMFrHnqAoskpo4kzS2o6LJhkc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839uss0jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 12:32:52 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 12:32:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoCkQRA0gro1W7FJQ0bvP8rQTJeI9jxvVOAfB6gnkWigX6hJT6u4aLfyu/rmkqAd4Kb7Io5hn45PE9phXj/CQIS3gGbajV6MJsCW03f13WVnwH5nNCC5eG7VFMUWEuDJLpq/ePVZtdplEkbCQpSxRQLxOuaXm1RxMnjUTEgu3eHXWyGiaLDZYv64UnTanezmqM4aAuE8h49CBZfks7mMPk86xpih5djdLT/7KfPBCc1ba9LfMxWxdNjr70GaETVG2QqZMUIyI5xS0zpMNqDyeqlY+E7M73MLQMlf37KcLxEnQlsa07b6/J2eXWDFiuoN6SkYkTl1KtGnefJ0nE3wcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyJT3ECez29ynNNqvBtwxuqI73Q9ZiWfhXqu5BexR3I=;
 b=TXai+B8vc4BrphiWOvmxsIchJYtz9OWP2qwMm5FODomZQl7/lQOGp3MJWL3aAp1wavK6IZiteJRyN+gfDbIauUlC1N4BjEGxuTRHzdNTRtnBJhLFfsq5QkZfUcne2Scaeio3jkGOrSJkguvM9ryZ369Q4C5vaxkZpBWpUM1ZxztjSaaaIzpfITX4JBY0tqMkBA/r5VprQh7/r7fOE0TXmIroJuuojHWXI1jIDKBfTckWNt1oW/1HTxr1Hkm56DRwehWBYVorhggJMn35+dg+3H13b6gN8bG1yhdkiDBnYAEZvqtN7DBNqLqzx1YvcXkuKMPQQ/LgTOarsXTVYezsVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2208.namprd15.prod.outlook.com (2603:10b6:805:1b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 23 Apr
 2021 19:32:48 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 19:32:48 +0000
Subject: Re: [PATCH v2 bpf-next 01/16] bpf: Introduce bpf_sys_bpf() helper and
 program type.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-2-alexei.starovoitov@gmail.com>
 <75b1c0b2-12f6-57f3-0cd0-2a59285b6aa5@fb.com>
 <CAADnVQLCUrQUknQf12fHSHe1-VwV9Nkh_tbyR=zoXGrXWmzEhA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cdf6701b-aa3c-09a2-10b0-748fcacb3187@fb.com>
Date:   Fri, 23 Apr 2021 12:32:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAADnVQLCUrQUknQf12fHSHe1-VwV9Nkh_tbyR=zoXGrXWmzEhA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW4PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:303:dc::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW4PR03CA0346.namprd03.prod.outlook.com (2603:10b6:303:dc::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 19:32:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871bb156-214a-4dd8-6270-08d9068e939a
X-MS-TrafficTypeDiagnostic: SN6PR15MB2208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB220871877B4FC3FEEFCF7FE0D3459@SN6PR15MB2208.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJaV8A/nfIMDDxY6xdIPNZDzK3ZeQn5rieeD9LwpprSkRVg9c44Jm3xbPwTRfn4gln3e/bgIP6hJ9LfrBb6V+wwVibiHhrjH/VcLodjYlBHIaXZWkP2T35Ic5IOkoNN8nF2LCqstQJrvunLl20bElJjCQBbALAE3Di5v+rNt9sZQUsVgDDHdDWRRDHk3rVU5RvvmFJvltxG6R79StOeqgTVu2VtmCzKIvpeF+x1Wsvo2UTgIksLv3yOiBACelSkb1cIoX77SWZTQ98NTL0/5jPONlk+O99lkMV3mtHPrC5pkP7lfzy9iCchXjlvS2Z7t9imSjgbZGwehkU7OdiYlR6S/9DA/hhjb3hcXhs3nMxwg0rL1PRvCrfTPyjQXLJN+og6I+c9dBjbQ/tHaYDaG62E6qzH1jTl/S1kKC1xVp9XjAMA2MSu0oBkCa9QPg0PgLN1e3V6YC3VhC2iqvpjy/z92Ceu/VWGx+bd8F4MV0Re9PyIbB79dNRTXUfzVPBWGJyBYUHM5ixF+jy4Jn8kC0OVdJIGQbB6ZcJaD9C6nTZ+BJavPfRy52uZPbG6hGTCIHLK96K1T6vcHT3KOCrGgX2k1YJHAFQ15q87NL6NLZfMaPfXV/PJ46RFPEvZm5kWSzZzUot+xgFfu8TWa0vVrjABnnKxVMeJ9/3+d/+OJdvnB2fowzjorscwFFxHGjg3W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(2616005)(66556008)(6666004)(186003)(16526019)(5660300002)(6486002)(38100700002)(31696002)(6916009)(66946007)(66476007)(83380400001)(36756003)(86362001)(478600001)(53546011)(8936002)(2906002)(52116002)(31686004)(8676002)(316002)(4326008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHg4SHNNRGc0YWRUSG5ZYmtWeDhmRHRmRmovbVZwVVZ0MDBvdFpqQUdSR2FC?=
 =?utf-8?B?aWQxTVllSnNHVHVZa1djSzVlL09yUXYrN3Nob3dQckx2UElMRmhTSFpWQTlM?=
 =?utf-8?B?WWdwZEZJSUMySVlHMzI2NHNRMHBxQWFKZGVqUjN4Vko2UjlSOXNiUmdMWFlJ?=
 =?utf-8?B?NGt2NDNwb1pnbXJhUFJSdCsrSUFQWml4N29VZkEzSVJRdjZ2ZDRTZmpLSUln?=
 =?utf-8?B?SkFaZ3lFcVNLOU1pWGpDOERZTlRXWDZqSVdOZ2VlRGdnN0xSbmRqR1g2eFhs?=
 =?utf-8?B?UmxKczNza1dielBRM091UHh3VlhIZmg5MGZOZEhyYi9BbTBzRGxMSzYyc0hs?=
 =?utf-8?B?bUEvYjlpM0sxRC81VUo4Zi9kWXkrcW4vckplQnVKVnMrRlJqZGUxdU5NV1F0?=
 =?utf-8?B?eFRHRU9PcWh4aWFheXRVdlJpd0x0bHhNd0d2eWRCaERPekIxUWRtaDFHSTFa?=
 =?utf-8?B?UU1EOTBqSmRUci9CM3VYUnRhZkNVbXlnTEc2UFl4RjI3WjFDQ0dtUUNMajdm?=
 =?utf-8?B?eHkxVDBwWGlxRWJoMEgrVEV5a0xBcjBtQUk4RzJ0aHB6bndiVlk4QjQ5THRY?=
 =?utf-8?B?YjRYdU9UcFlPMGZMcTVlc3VHRFVCM1I1akhsckUyTjVXSnhudCtPUnZsZUtY?=
 =?utf-8?B?MzN5MXNyUlp2OWNOTUpTU0VBc1VSMkdhWmJwY1VDOTJoVURFSmNTQXEwWUdJ?=
 =?utf-8?B?UzRlWjAvam5ETlFneWo5QnNGMVBXazg5MjNPYlVIRW9Oc1gzeDM1Z2NIQlRJ?=
 =?utf-8?B?RW43VW1pTFA5dkgycTF1M21oT3JPQlo2VSs2eTFiODdqbGhTTnpLRXBtUGc1?=
 =?utf-8?B?cW5QZ0VZNlcxRmxtZ3ZmZmdHaFY2a0VxdFNNbmVMdTVuOE8velpNZ04xaXdx?=
 =?utf-8?B?b3NIS01TU1NJWXhJZkFTWWdyMmZmWlpKL0Evc2NnelZERWNhRXBaaW5PMGZl?=
 =?utf-8?B?dGhONWdtYlFNcStkVHZxdnJ5eFliSmd3b05aQldOZmhSVnRCcE9XVFFERmw2?=
 =?utf-8?B?dUMrUHlmeTNJRWZpcEZhaXljcG42aXNKL3FUdlJJRFphcE1WQTQrVkZ0cDdT?=
 =?utf-8?B?TWtqa3lORkNjaGN4dmNGWlllVWNMcktFY3puOFZ5N1dCMXRRWTZ5SDZ1ajR4?=
 =?utf-8?B?dml6V2RreHdob3IxZDZzcHdmb0hOYVdPY3JSbXZ3VE9lem51TVFUQ09DbWVt?=
 =?utf-8?B?N2hBOERzd3M1RFE2cUFLM1czUWg2ZlZnak5zV04rSFEwYXFFQk9oZThHSlhJ?=
 =?utf-8?B?TXpiUzF3RmVWN0ZFZnpoc1pHSU40SktHdDc5MjV1dFBkU1R0TnZRRmlTQi8v?=
 =?utf-8?B?bWszZGVOU1l3RG5NK2syVmNSaTB6MURYcUg4UFA1N0RDQ1o1RDVQQVZSK09p?=
 =?utf-8?B?OGJIUWZBazZEZHRYVFlnMUNNVXlMc0crRHgzY3lXVjllMG9ZVVBqTGpPTkpt?=
 =?utf-8?B?VkFWZmZCV2N3WU9mNURSR2NJL2hUekowb1l3bndIWjV6QlMzQURZRXBCTjQ4?=
 =?utf-8?B?MG5xb3ErbWZtdEsxN3F5WEdMOEEzTU9WN29JVVVpM2ZRVGJZNTBidVBDRitE?=
 =?utf-8?B?VGZGRStTZmY0QVJKaXBKTTBtcDZ6cE9lc1FZbkZCSW9uZGtRYWlYQ1hvWEJK?=
 =?utf-8?B?RXBiM0kxRVhQcFg0STdjZTJnd1A0QnoyNUlUOWF4a2JSU2prbFNkZ3VYRGE1?=
 =?utf-8?B?bVBwVTdoaFdoNnZBNWovV01TQWF3QmdqNGdNTVVpVm52SlpocjV0MW1jYkg5?=
 =?utf-8?B?QUFlcGtSSHJ1SFNtSzNIR3NFRzFxM2RlL0pKOWpQYUJJUE4rWDVQQXJJN203?=
 =?utf-8?Q?OygZjW9tHxqys6omSZkWnztE8fxmD9sssMR8c=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 871bb156-214a-4dd8-6270-08d9068e939a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 19:32:48.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYfW65hIoSORnqyFIdQ/Ay62YhqNzAjBSPLr2j19rb5vpozDdUt3T0WXiiT2/Voi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2208
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: yirNqg98yX3mLIcI8_afJd1SRpoHtKVs
X-Proofpoint-ORIG-GUID: yirNqg98yX3mLIcI8_afJd1SRpoHtKVs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_10:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:28 AM, Alexei Starovoitov wrote:
> On Fri, Apr 23, 2021 at 11:16 AM Yonghong Song <yhs@fb.com> wrote:
>>> +
>>> +static bool syscall_prog_is_valid_access(int off, int size,
>>> +                                      enum bpf_access_type type,
>>> +                                      const struct bpf_prog *prog,
>>> +                                      struct bpf_insn_access_aux *info)
>>> +{
>>> +     if (off < 0 || off >= U16_MAX)
>>> +             return false;
>>
>> Is this enough? If I understand correctly, the new program type
>> allows any arbitrary context data from user as long as its size
>> meets the following constraints:
>>      if (ctx_size_in < prog->aux->max_ctx_offset ||
>>              ctx_size_in > U16_MAX)
>>                  return -EINVAL;
>>
>> So if user provides a ctx with size say 40 and inside the program looks
>> it is still able to read/write to say offset 400.
>> Should we be a little more restrictive on this?
> 
> At the load time the program can have a read/write at offset 400,
> but it will be rejected at prog_test_run time.
> That's similar to tp and raw_tp test_run-s and attach-es.
> That's why test_run has that check you've quoted.
> It's a two step verification.
> The verifier rejects <0 || > u16_max right away and
> keeps the track of max_ctx_offset.
> Then at attach/test_run the final check is done with an actual ctx_size_in.

Thanks! That is indeed the case. Somehow although I copy-pasted it,
I missed the code "ctx_size_in < prog->aux->max_ctx_offset"...
