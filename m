Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191B22D936F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 08:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394492AbgLNHBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 02:01:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51086 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733073AbgLNHBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 02:01:19 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BE6uvLt000571;
        Sun, 13 Dec 2020 23:00:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vS/NUF1H04v4R9GUU3eC5OItWgKT4kjE/qlAcPZLPG4=;
 b=KqW7zrxIau20a1wdkyMF7CYgTdAdpNR7yPLu+5XkDZ6HIsOWdpr0tSv9Y2Z4O2D08hwR
 ZhR/tJV3XXNba6ZomkJG6DS1rFnMSMBMN+398FutcgBlaj+dPZ4XTw4RGkVNA8XO7r37
 LJA8jof9/JKpYJJY34fG6QVAE0yY2KeOndE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35df0e36hg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 13 Dec 2020 23:00:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 13 Dec 2020 23:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ki6O3LW/k/UdG5ptsXMYRL0pfLGJwsd1kWWy93+Fv4ouFLoeM6SO2kFsQ3vZ4J5tt/hdpMOI/PAwHO2L74Qy8t+c+SgRZy89GzwnBUIQTOIvZljZAHkccoYmmssNknGmDkmXUjPsvK1dGIKSUKb2JqKRhuuHeff+j/SkWvDOxR/j0wrkjPEnEITZtwdNGAB458UzMknbMa5z8H1aL93jKqu2+12gZPuKGVdYA3uZuHi26QXu+EDeXfWqSfrD7NpbqNA8giDAeuvO92YjW/OAPZGZaVPbL76dTxSQO4/v1b61/xDtSq8YPww2dGWrRQOZB344xSZfAM3xtxs80t0B9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS/NUF1H04v4R9GUU3eC5OItWgKT4kjE/qlAcPZLPG4=;
 b=fKlDO9NyPKNNIba0cABS+/6stghk+7Maj5N+QC6runcYdvJKuUYBGLKlj/5MWUs0XiPBGmSU0lGf2nOdydPLVAoPjEG8C1CFctxX+BZuzczpzERypgg2/YuUoVhM0qeN1v1CKXl98DiXXYPqKBMTYdYdJFVLVbjb20Uc22Q2Dg11K+xUmlWs8JbrACWZaA1K7sY9ahwGigtUDj5VkJgiDA2PAGNUxd6RGJBXpyCwg1yZ+UsbCTr5XBZRhhJaskpJJhTcGUaIeeSTYq4WyVEuYyle2ZSERUK38Obkdd+1k80EUVZ6Ok9zFZ7dUvbZrsMCnKxtLrZX8ZzkWY/T8/ghcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS/NUF1H04v4R9GUU3eC5OItWgKT4kjE/qlAcPZLPG4=;
 b=NttwWmaDjZ29ld4fKnMLZLq0b4dpAkpzOxPEd8eQvIbYVwMVE6AcyVYKfgU4ZYtSTQbDHwVrMtz0Jb3Z8WCcVVRfHu7V1FdNmIJqtPcuK+tTAZmZe4bliU1d+Zz5j3AsWy3sgoB3UQKWOpLV/Jp/Vvu5WL6FlGb8VtcWptpQrEA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 07:00:11 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 07:00:11 +0000
Subject: Re: [PATCH 1/1 v3 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20201211171138.63819-1-jonathan.lemon@gmail.com>
 <20201211171138.63819-2-jonathan.lemon@gmail.com>
 <CAEf4BzYswHcuQNdqyOymB5MTFDKJy0xkG4+Yo_CpUGH4BVqjzg@mail.gmail.com>
 <20201211230134.qswet7pfrda23ooa@bsd-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7774ab85-ef6d-8928-0374-ae037f495cab@fb.com>
Date:   Sun, 13 Dec 2020 23:00:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201211230134.qswet7pfrda23ooa@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:c9f6]
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::112b] (2620:10d:c090:400::5:c9f6) by SJ0PR05CA0081.namprd05.prod.outlook.com (2603:10b6:a03:332::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Mon, 14 Dec 2020 07:00:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 937e8c14-d7ab-49d5-cd08-08d89ffde643
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26961DF5CC0583DD65FE9CEBD3C70@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ON9LACoFkbcGnOJptvuSKQoLSeSUgyAwsHhBz12BuY3l0TdbipOZyfeTK3sskrJe4IKzfoPw8Xv1Rp5M0HkLH/Aaqb6wF16fBy1XCA7RGpsXBzDjjR5Z5fNFEq7RCEmKuhM0LKj+XgRGs0ESfAizimW3sRLcT3DfRU/KmSTk+T48prMlTEkkv/dScfz+IPmmjtqMdtNeiyFmlNwCRy3kUL5XQb/dFp0LQVbIgGVLZPG2U7Yggg6/f54CXRjWs+veDe32WlWXpxqC0ceXrmXhjY//VgRI5XMG0J9KjGhMvD93G6GViDY0rOgk2vbwQc6rnNZoSO9QwSpw47jJcIqxvIPBRFL38vhQRa5dZ6nznlUzYvYJQtfHxp494Sj/BHjKTMwKWAxBUkZ1rxvgZ7uw6Y7qrY0YuP9+sbrj2WUcGk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(5660300002)(66476007)(4326008)(8676002)(36756003)(66946007)(8936002)(2616005)(508600001)(31696002)(66556008)(186003)(86362001)(2906002)(52116002)(31686004)(110136005)(53546011)(6486002)(54906003)(83380400001)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cURXRzBhcG80dmhEWnREblFJamRoWmhJaUVXMEVndWRmZUEwb3M1TnN2cjRh?=
 =?utf-8?B?L3JkbWpaRm1SeS9vRkk5bmdQSytOcnl6clJsUjk5bzVJQWY4TmI5akNXOVJp?=
 =?utf-8?B?ci9jVEx5cnRJUm5GbUFMWWxzTmJLQkNYN1Y5bWpQRUZTdHljcHFpVm40bHhX?=
 =?utf-8?B?THZjK0R0a2FPU0dsQWM4eDhlZmlmMVd2RU5hSVFhUWY2MytmSHh1UWU0Ykhp?=
 =?utf-8?B?TDRTZldxOWx2R1VvVW41amVXN2I0aG1MYlU0L0JxY1B4U0gvMEtoOFRXamxX?=
 =?utf-8?B?SkRHVVFOeXhVWis5M2hCR2hDVFI0cmNFVlBzOGg3aHdmbEdmTHFFTGowRFg3?=
 =?utf-8?B?K0dGK1BPTitKdENkei9wV2YwcmdsNWFkY2N5ZVk4VEJuVnhYZGdQTFBPV1Fw?=
 =?utf-8?B?VkI0NFgzQ01wZW5YVEdaQzZHc2FpVlpTVk1NMkd2c0FqV24xSFpBVTNaYUJH?=
 =?utf-8?B?TmRIRmh4MkhOV1BxVzI2aTc1MzlQNWFFSnJ3NjErZFJwLy9NUG01VVVxc0Rv?=
 =?utf-8?B?MElKVFlrVGhOSmtKMnA1RGRlQkxvZGM0akdCNzgvVUhYTWpGSTMzQ0Y0Y29I?=
 =?utf-8?B?Tnd3eS9TT2t1OEs0UHE5bDVua012R2l4RTJlVmdJWFRPeFBqUXU0endmcDhN?=
 =?utf-8?B?aXhrYWtEL1NQa2VmNlQ5R0x6a3hFQXJIcnBNbHZuZkZodHdOS3U4ekYza21V?=
 =?utf-8?B?S1EzRERscVovdGVWWTJBdEF3a0YzbEw4cEtJS2FSN0JjNkNydzljc3JzN2lT?=
 =?utf-8?B?ZVgxeDBTVFpDL1BKNkRqNGNGd2gxeWRIV2lmaXhPRjlBMzU0QTUzN295dmU1?=
 =?utf-8?B?NjV0YXN1R0duU1ZTWjA0elFLV0tPOTROZDRid2lCYTRRR2RnYWJYbm04eWtI?=
 =?utf-8?B?UjVCT0hkVXVrNkRoS2xnZExwUFp6Qk5PcFQvZm4rb2ZSbzJCNnVUNi9oLzNv?=
 =?utf-8?B?Q2tLQjRIMVR0bndDUjZzTXJJSjY3Ni9pcXZVMVRDbjFRalRoa0E0L0pqbloy?=
 =?utf-8?B?a1dlbUJCVFBZcFphUk1KL1F1RExVQXlEU25xc3FkT0dvRG4vMmtzT2NHTGJI?=
 =?utf-8?B?YUVld0tUUkRINmFEL2F0N0F5M1RCeHlkZXRDSVBYVW9oSitpSkwzTXNJQ3hE?=
 =?utf-8?B?MHhoaWM2c0E4NDZlVitRYXlNNnUrbmUvTS9xZGM5Q3Aza2lFM0x5aVpTV3ZP?=
 =?utf-8?B?bDcyYUtaMW5JWENFOFNvNVFVcy9yY3RoYzhiWHEwbElxL2xBRnpkUFBHb1Yv?=
 =?utf-8?B?TTVGdHAzVUU1ek5LVGMyMllEbWJJd0VjZzVmOC93bnU0ekpnTFRZYnYyN3A4?=
 =?utf-8?B?MjNleEV1ZVNMcWErRlpTSFFvOUp1dW5HdW53amhrT1Fjd3d3UnlRR3d6TCtp?=
 =?utf-8?B?TlNYVkxxT1Y5dVE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 07:00:11.0431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 937e8c14-d7ab-49d5-cd08-08d89ffde643
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8qu+MvQbSR7lLKyyUfzFflIPcPwfRwzm48Vuo7sL7tj159hj5D6rW0Ux3eX0HM1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_03:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=684 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140052
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/20 3:01 PM, Jonathan Lemon wrote:
> On Fri, Dec 11, 2020 at 12:23:34PM -0800, Andrii Nakryiko wrote:
>>> @@ -164,7 +164,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
>>>                  curr_files = get_files_struct(curr_task);
>>>                  if (!curr_files) {
>>>                          put_task_struct(curr_task);
>>> -                       curr_tid = ++(info->tid);
>>> +                       curr_tid = curr_tid + 1;
>>
>> Yonghong might know definitively, but it seems like we need to update
>> info->tid here as well:
>>
>> info->tid = curr_tid;
>>
>> If the search eventually yields no task, then info->tid will stay at
>> some potentially much smaller value, and we'll keep re-searching tasks
>> from the same TID on each subsequent read (if user keeps reading the
>> file). So corner case, but good to have covered.
> 
> That applies earlier as well:
> 
>                  curr_task = task_seq_get_next(ns, &curr_tid, true);
>                  if (!curr_task) {
>                          info->task = NULL;
>                          info->files = NULL;
>                          return NULL;
>                  }
> 
> The logic seems to be "if task == NULL, then return NULL and stop".
> Is the seq_iterator allowed to continue/restart if seq_next returns NULL?

If seq_next() returns NULL, bpf_seq_read() will end and the control
will return to user space. There are two cases here:
    - there are something in the buffer and user will get non-zero-length
      return data and after this typically user will call read() syscall
      again. In such cases case, the search will be from last info->tid.
    - the buffer is empty and user will get a "0" return value for read()
      system. Typically, user will not call read() syscall any more.
      But if it does, the search will start from last info->tid.

Agree with Andrii, in general, this should not be a big problem.
But it is good to get this fixed too.

> --
> Jonathan
> 
