Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60364EF844
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349414AbiDAQq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349612AbiDAQqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:46:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A46103B8A;
        Fri,  1 Apr 2022 09:29:00 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 231EgN5o010779;
        Fri, 1 Apr 2022 09:28:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Hc1oJWiKnujbT5SQlh3qfrEjIjJYWRzWKvtTbpcVgaA=;
 b=aAgv/7+kRvM8/gQ+99TzvikvVKwrFUhvSxexGtkKiw7i0NKtKkzBl/cQMU/VMOQueYWc
 Dwc7Ft/PhLdVq1J/hikDraTpzWAQvwbRhWqrp8DkdQX36cCMZp9izK2sscv5lLLiUV+P
 OYv0Obc+HarjzcUxlqxo9n8TOTU8JZHyxZc= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f5gpcqput-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 09:28:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k++trdicUz8HWAhEUz1gBIUJ35CihbIO7PdH/6BXPDm3MgdCBqgqhQo8iAkNYig4sCV1Jw36rqflqMhwdOIC37mZ8krNa1aIpOoyPbzwCGkMqYwmaH/I6YUJt2/lHYtylUHowPBdNnM7/RKmeHnUlscuPExsPwWAQei6Gf8YpKX9Ef3vdE9x174m6Cj0MvqTlPASKSqWPUC0owNKnUO1Idy0OpSW5vtNS6Awfl4eHdlW+B1BdPRkoDHNkXA2pEGsd8CqWdYlJky3M4+KxNcEqUdaOeVd19WyZyFgJK5/dJVIkAe3/J7Z8mw2siPh7PqnjPissY1+KcB3lvVpInGiLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hc1oJWiKnujbT5SQlh3qfrEjIjJYWRzWKvtTbpcVgaA=;
 b=Yqi2HIPc7c5BdaH6wNV7woYBjX58dVSg7EiU13jw3EXsVAgNrVo+hbN+MZ/1ELv/ljAaY2J3BLiS8/MjiH4jWpLBqUZhz2UqaZnTb0FJCJ9NWK0/gVwu2z7NYOy/FTHAOSOYcPZXp+AIiDPqw9+A+47QSCh0xfKj4Yf5OkbzRXuNk3V4NvsGG3dyQki4AGLDmy/B8g0kIXHYgMTfFXSVtXYWJoJmjeqWlsimkF7/aXuUCWHrRS0qAuCR1GUCovlfdfD2UnKm2SNlRQHlbPaAqP8FVHs5HwZSwbFvLz5+mGFj4mi54FGRcngWmnQjrDlSiQBt5qUObTY8hsYDzGy2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB4604.namprd15.prod.outlook.com (2603:10b6:303:10d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.26; Fri, 1 Apr
 2022 16:28:39 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2%7]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 16:28:39 +0000
Message-ID: <b0b8be03-04e7-eb87-474d-b1584ebe2060@fb.com>
Date:   Fri, 1 Apr 2022 09:28:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] sample: bpf: syscall_tp_user: print result of verify_map
Content-Language: en-US
To:     Song Chen <chensong_2000@189.cn>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1648777272-21473-1-git-send-email-chensong_2000@189.cn>
 <882349c0-123d-3deb-88e8-d400ec702d1f@fb.com>
 <306ab457-9f3d-4d90-bb31-e6fb08b6a5ad@189.cn>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <306ab457-9f3d-4d90-bb31-e6fb08b6a5ad@189.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ae88981-6eb9-4086-4c96-08da13fcad93
X-MS-TrafficTypeDiagnostic: MW4PR15MB4604:EE_
X-Microsoft-Antispam-PRVS: <MW4PR15MB4604CAC796F5FE496710FCFFD3E09@MW4PR15MB4604.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXruU0rZD3VREAGDY00IKMn0q09umgP25COyPHmXxq0Pc+eLh4XSi/r21BziubA94qtQ7CC3fa95gZyguSJViOTdHh/fGTuWsaHIODVCvMZtbkryPEF2znW5l3cqnMXUL2pL8mGzrFvfisNMH5Je4GbA9r2huWoJphh58GczdmVSAlssBB7FgE/K714PLE3fJk1e1QXz12zvTbB6rQz4XHWanBWy402t9WV0pJbEvjxc3W2qBjyDMJkDqH7z3IT2xRVLzQIHSZF7T+sbtNXRlMMG72f1VM+RWElrXtJrOZg45RekTYuKvpwc+KL3fuoqDwrmgAanAf6KFtPjRGj2CHvh/it2HUg8HyZI5S5lZhGY+71u+5Ut6ctXOtxtqZydl8mVXlLhTVpVKhxGfzjyC85CNKt1FELlihsCdEj+wWcBNHBYNOWgWpPEwQAyEnUEJrBignWBIwTf5Ve+JZ7fLrmYpf/TyS38yD34qm4SOjteE+S24Xlbc2S6I9jdBwXg3vNtBU8I4JYdb7WGexVym64GcYJ+LtYVGqPQy1tRb4SPbH0UX/u7AOJ75V39WkB5OrV43xn2fouTqjxGQo2w61aOzVjJO1Du4/88khEjS32WVC9pip6xdGGicTx2tNKGlTTOqRpF46bk0YtIviGoIbiDdHdHPkRF1owhrP/56SKjqscCaZZo4sEo1n9PcgjQw/ssSBTCccykdVBaO5OHEdHGv4ps7AM4t8bqo7O2DNSqruDe5fiSyMy+ZxnYwrIm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6666004)(52116002)(53546011)(316002)(36756003)(31686004)(2616005)(921005)(2906002)(83380400001)(186003)(66476007)(66556008)(66946007)(5660300002)(8676002)(38100700002)(31696002)(15650500001)(6486002)(6512007)(86362001)(8936002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vndja1pSZ2o5ajVrRVYrSXl5Z25XS25GcGVNYWRhUit2emYyaTVoQWQvaUJJ?=
 =?utf-8?B?NkZOUFc0ZnhKZ3RHSFRIWFhOVXpTQmZtazlUYWw2V1I4blhJSU1pa1RDaUFZ?=
 =?utf-8?B?M2F5NUdwSENqcmxMYmErT0d4amJTbld1Z09PTmQ3ZFJjbXFyU2tJWHhBak16?=
 =?utf-8?B?dmtIRmdKZWd0eFg0OHhJVTBiSjJPSkt5T2l4ZTRhSzN4VW9rQVJ6bXRSaGI3?=
 =?utf-8?B?M0lSOXFxY25lV0xGYUQ3SjlIRjc0aUozS0JBTXEwLyt6SlIwLzVSQWwwT1NM?=
 =?utf-8?B?bEdLK3M4RlhEbE1jRGVIZ3h2NTRhdm9YV0JnNVpSNHQ4c25TbWdVcmRBc1dt?=
 =?utf-8?B?OWFwN2ZFQ2JGY0w2Ym9zMVh3YnF3Wi9pRFdjVjgxK0tuZjQyMFl3WTZnS1lx?=
 =?utf-8?B?MWJ2ZVJSaDNSSy83M29MbUk4d0I3Smk4c1pzWEpVaG50OUh0R3RoK1lvZkNr?=
 =?utf-8?B?TE1LN1VGS2xyVjJvRnFMbFpmZ0xLUlFiNDMyWkJiaWl2VUNDK1FkVE5neTdu?=
 =?utf-8?B?bllJbmJkem5VL3o0WTl6NEJ5QlNBd0oybGNaZzE5VFpRdEtacy8rVmdnUVBM?=
 =?utf-8?B?RU9hYTBSR1pkTDA2Rm93azg4eVlDbHV6SU55dmNVU1VvSVg2WkFCSTVueGZO?=
 =?utf-8?B?RitTU2prN3lMY3JpOUJRZjhhQnNVcGlaMkNmQ2ovSldCQlJ1RlF1YmlqTEli?=
 =?utf-8?B?VmRuK1FJT2pSMk9aMGtBQjJXR0NoTjU2bExxZ1ZoRHpzV1AvNktJWDFEUU8w?=
 =?utf-8?B?QXlwUTVzeTdvanRpcnh3MkY3cXQ0eVlZYWVGN2lnbGNNbWFKYnRRSnR0L2s4?=
 =?utf-8?B?dW1mM2EyUnMzZFhpYWdERlBvUlpNWEVUQUhEN2U0ZzBKK1cvU1ZlY29SYzkv?=
 =?utf-8?B?K0Q2VzQ5d2Z4M21QYnFvb3Q0a0taMjgvYmpHaklVZUthbUd1MGJKZFBKVzVG?=
 =?utf-8?B?NG5LOHJuTW9HaXZMd1VYSjRvM1ptYXBQNmI3WFEweXVDeHQ0R2Fxb1UwUnBW?=
 =?utf-8?B?MktkNldETzU4eFZVRm9nUkg1QytNVFVxMUVxc2tCTGhUR0hRVzFab2pNZ2N3?=
 =?utf-8?B?aEtUbENQSTZNYWhXQzZ4RWxsMFl5VnNqdnFQbU1YOUZmclBmQWN5RlREd0VC?=
 =?utf-8?B?OHZQMVloU0VqR3pIUHpuQVZIU1oyY0VzOUtKeXU3bzlGYVA5ZERwM1FacUU1?=
 =?utf-8?B?NDJQRHpKRDA0TEE2UXRxcFM1WXdUQk1XbU9tSFhCYjdQcDUrNWVoak80V1Mr?=
 =?utf-8?B?bHpMYTdiNHF5Y2VyeTJ3aHNtR2N4bWVNV1VNc1ZiaEc1bGNMYXlpZHd6NFVv?=
 =?utf-8?B?OElHU0I3VU9SZm1EUFpFWUREMVdSd2FLeko5bWZHeU54ek40ZXRjZjdDbjNU?=
 =?utf-8?B?RzF3eUhCSjdyU2x2Zkh3b1c3RjlIUVk0aHlrazcrK3RZV21mMzl4L1plM3Bx?=
 =?utf-8?B?YlErYlROOUlZeG1rOXZhTDhWTlJ5QVh3cVdQalk2V3JnNnVQWWkvVk5aMWhk?=
 =?utf-8?B?cnNiNndIOVlvcUJMWjF1dndWL3dqQk1FT0FzWkFDMlRna0NyNmtFcFV2Yk15?=
 =?utf-8?B?V2oyTTZ3ZlpZN3lyY28xdnR2aDlOR1ZNRThkS2hZOENITW8yK21kcnFyTk9N?=
 =?utf-8?B?cjNJZEZYbTVQVWJpcXUxZmhQTFNVc0V3bkJDdmV5cEF4OHlvbEc2ZVppQVRp?=
 =?utf-8?B?TEVsalkva1ZQalpHTFNWTnhHRndMMVcrWjVReDhtUnZpNFRGRDh6WDV0U21s?=
 =?utf-8?B?Q1Q5a043WlJsRWVSSjRYV3NnVEMwdWxFZ2E1SW5keEhGTkpmY21rTXFSdjB4?=
 =?utf-8?B?RmVnZ0t3dHJuemlMcWlvS1Ayd0grU2E5WDd6VjEydHNqbmpPL2xxbHlMdEds?=
 =?utf-8?B?OW5PS2RHR3NvVFNPZzFKMk5hbzZxQXpSa05RN05VK3ZWWFI4ano5Q3ZYekdx?=
 =?utf-8?B?cTVEc3U2Lzl5M3p4WWl1YmNTN2JnZDc0TlZLTmgwUUVrRkpDY1ZJMTRLM0cy?=
 =?utf-8?B?MWRxMHBUdVdIVTFVZVh5NklZNDFTOHpPcW5wMlB6SytoU1NxdmkxUHU0eWJ3?=
 =?utf-8?B?WllJamlEeUpBNlUyeVJZYThveG5TTS9kOHVFdzg2ZEk0aXBmWG5KNEtPNVRP?=
 =?utf-8?B?Y1NDbk5pVnh1SU1IaFZDWnlleVhwOVBZRnFDNTNnNmdJak8zZnVWdDV0ZlVr?=
 =?utf-8?B?Z0RhcmJpV29xdTBqUGpjR3F4SWJISTNNaVZoZU1wK05wMHU4NzljV3hja3Y3?=
 =?utf-8?B?Ri9nY092eC81SUhiRjVEa25aWks1d0Vhb0lFRWFtY00vdDUzS3RuOHhlRmNK?=
 =?utf-8?B?d3FYdWpmMzVTZFhZVXkya2o4WCttWU5BdzZEQTBsZ2hGQUhITnFhZz09?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae88981-6eb9-4086-4c96-08da13fcad93
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 16:28:39.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZ1l0gtSWd2NlxixpY9PgLKuhfTkmRYedtqoB2Sk9qQsgijBkZSzaL1Y1TxV7zUt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4604
X-Proofpoint-ORIG-GUID: xwvYQZNUzDpPlXr4DJLcDT1tVgwNI7Pw
X-Proofpoint-GUID: xwvYQZNUzDpPlXr4DJLcDT1tVgwNI7Pw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_05,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/22 8:37 PM, Song Chen wrote:
> 
> 
> 在 2022/4/1 11:01, Yonghong Song 写道:
>>
>>
>> On 3/31/22 6:41 PM, Song Chen wrote:
>>> syscall_tp only prints the map id and messages when something goes 
>>> wrong,
>>> but it doesn't print the value passed from bpf map. I think it's better
>>> to show that value to users.
>>>
>>> What's more, i also added a 2-second sleep before calling verify_map,
>>> to make the value more obvious.
>>>
>>> Signed-off-by: Song Chen <chensong_2000@189.cn>
>>> ---
>>>   samples/bpf/syscall_tp_user.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/samples/bpf/syscall_tp_user.c 
>>> b/samples/bpf/syscall_tp_user.c
>>> index a0ebf1833ed3..1faa7f08054e 100644
>>> --- a/samples/bpf/syscall_tp_user.c
>>> +++ b/samples/bpf/syscall_tp_user.c
>>> @@ -36,6 +36,9 @@ static void verify_map(int map_id)
>>>           fprintf(stderr, "failed: map #%d returns value 0\n", map_id);
>>>           return;
>>>       }
>>> +
>>> +    printf("verify map:%d val: %d\n", map_id, val);
>>
>> I am not sure how useful it is or anybody really cares.
>> This is just a sample to demonstrate how bpf tracepoint works.
>> The error path has error print out already.

Considering we already have
    printf("prog #%d: map ids %d %d\n", i, map0_fds[i], map1_fds[i]);
I think your proposed additional printout
    printf("verify map:%d val: %d\n", map_id, val);
might be okay. The commit message should be rewritten
to justify this change something like:
    we already print out
      prog <some number>: map ids <..> <...>
    further print out
       verify map: ...
    will help user to understand the program runs successfully.

I think sleep(2) is unnecessary.

>>
>>> +
>>>       val = 0;
>>>       if (bpf_map_update_elem(map_id, &key, &val, BPF_ANY) != 0) {
>>>           fprintf(stderr, "map_update failed: %s\n", strerror(errno));
>>> @@ -98,6 +101,7 @@ static int test(char *filename, int num_progs)
>>>       }
>>>       close(fd);
>>> +    sleep(2);
>>
>> The commit message mentioned this sleep(2) is
>> to make the value more obvious. I don't know what does this mean.
>> sleep(2) can be added only if it fixed a bug.
> 
> The value in bpf map means how many times trace_enter_open_at are 
> triggered with tracepoint,sys_enter_openat. Sleep(2) is to enlarge the 
> result, tell the user how many files are opened in the last 2 seconds.
> 
> It shows like this:
> 
> sudo ./samples/bpf/syscall_tp
> prog #0: map ids 4 5
> verify map:4 val: 253
> verify map:5 val: 252
> 
> If we work harder, we can also print those files' name and opened by 
> which process.
> 
> It's just an improvement instead of a bug fix, i will drop it if 
> reviewers think it's unnecessary.
> 
> Thanks.
> 
> BR
> 
> chensong
>>
>>>       /* verify the map */
>>>       for (i = 0; i < num_progs; i++) {
>>>           verify_map(map0_fds[i]);
>>
