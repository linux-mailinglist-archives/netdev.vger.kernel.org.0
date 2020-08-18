Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04B248CA8
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgHRROd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:14:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53008 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726836AbgHRROX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 13:14:23 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IHAvl2032707;
        Tue, 18 Aug 2020 10:14:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=x/kXTvP4MgYg32LuLVbcxh4zQZI+qM1klQwBnpQCmBw=;
 b=EdKPltbsMj1MKhcLG2ORyKsVhj0cPsmRJvUfOaRWb2oAyzaRzW7wdAbqWUBWmOtp+4E8
 gcSYl3bb1MrqhXBS053jUTI4kHc8QQ1oTm57355knf4u4xqVuEGmaNquz4C9oZ/PIfsG
 LEseyFMUxbQV/WOShkhOeNIXLc0SXPRYCy4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3bvfx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 10:14:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 10:14:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOLNC8rI7QYBEkvfitfpRoi2amQPrCjzXABzBi8Z0ibLwoLy+2TtRR663iUSQwGZfPGYhKrQrpts7bfcwcVNXOcCDMyuCxkDKUF8ieW82OS63yeM/dkZdb7zhg3aNlHgk1DDTOsVyV4ElB/m0VGK875ijZxdJEHfYjCP1OiRolum99PE3jLnYwUAI+8jmpUxx4ArxIFJy7VMd6k71Bkw5WXwYvIk5NRKxkKPsBaD/uPiuoxa7uTao1f35NAzJ/oY7kS1TehK0KsvkCJK9Ah2YfmFwtPi6VhfGHfSwvRunGhbzUz20YqhsNe0KkGGVMtXv9fi7HXKzvhZbU8NCi1/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/kXTvP4MgYg32LuLVbcxh4zQZI+qM1klQwBnpQCmBw=;
 b=W3rYpsFNqLH6R4ZFbvLIB5BqmYeneMLbk+mdT3gTbmcx9Ogdc4FnyyU/Ub6v6hH0BwRy1s2tDTH8qGs4umVwhFdwj6SVd2BesMyjysCvUcQDwp43wx9Pq9eFZxVck5EOTJjX/qLZlYypiPzSlIdD98j2YGiAofdqFiJPogBlIXwJY5+awqLuvmfVx0M0VIW973fm9pbcnCRz5ksCoOg5Co/wcUEzbom238T/hEGazuWwj5dNcMGHl8bOq0SlF/BLcEVIClVUfbFVJTa2FShsTrqpbW9nabNyLWJrq4rdF9Y2PmgUtstqxVns8ZqxUS44N+vTQbl7H4C+Km/tUOS8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/kXTvP4MgYg32LuLVbcxh4zQZI+qM1klQwBnpQCmBw=;
 b=YHYgXY5PygF6AMlAElShhPiiqJf06uv8IXyOS/sbVJ/1m4rm6QfsFa87TOTCQvr+woRgdP9b33rppN4mGiWdud5hXvc0JdKWssxpR2o53qy/JTLnnA0lV2wrtUF3cG3QsZ1iDH2VBS2T15b0oJnGEAy5XW/qXo7//clsqUIf59I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2488.namprd15.prod.outlook.com (2603:10b6:a02:90::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Tue, 18 Aug
 2020 17:14:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 17:14:03 +0000
Subject: Re: [PATCH bpf 1/2] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20200818162408.836759-1-yhs@fb.com>
 <20200818162408.836816-1-yhs@fb.com>
 <CAADnVQL-2PKh8rzVWjCWCSSO6WkdhS+azFUtcLmNT=1Wj1hH+A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b3d215cd-714f-e801-afae-d68a83acaf2f@fb.com>
Date:   Tue, 18 Aug 2020 10:13:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAADnVQL-2PKh8rzVWjCWCSSO6WkdhS+azFUtcLmNT=1Wj1hH+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0007.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR15CA0007.namprd15.prod.outlook.com (2603:10b6:208:1b4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Tue, 18 Aug 2020 17:14:01 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26800ad1-5849-4050-a293-08d8439a1ae2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB248870AAC746A3F51A2BEDEBD35C0@BYAPR15MB2488.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+rYV7KibL0l/aYGWXMfmTpjfVt5q3sNwEHYkzSEOPka00cxdCQPSk92QJkLFGdWTBmQZGlf561HHqeZlxWC05P0vyimHs8vsLM3Osa+H3yc/HHebNR3dfjWoQuz7DlGRCq18YLNpxUeZTcMIzaBnjXQjZ/R/udxqDpa4d5DnUVV1ncWl6jXbS/wZ2Ln7yLp2YZJWKkfY2ZVlhYikilSFIW6K0fq6exQGYtWzL4LQi/kJcWEGqO6ba2MzWjn/BWLuyTt/d7gMVZxCgEIRoVBeVYy08AlheafdIvWIRwHnKm8qKuL3KIK9xFfSJt6edJpqtWUkE22gmoQIny14DK6KDnJAGFpgxAm6nUZwH1Xnbj7aoM8GHFvQJiTNkFLVl9I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(39860400002)(376002)(83380400001)(31686004)(36756003)(86362001)(5660300002)(52116002)(2906002)(66946007)(53546011)(66556008)(31696002)(54906003)(66476007)(6916009)(16526019)(6666004)(186003)(8676002)(478600001)(8936002)(6486002)(316002)(2616005)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Cw2tiUcEIVDh8A9DvBY7NujKfdQpF/mT/Xsy/zeBj4c8oHq6VAAZxeUEuvgcwFCQzGKk8fOiniLcSBQ4PScBMEAnUcRtC97Qk/lHqJvIzazlnJeFaBqgctepfozVvjvyeKQbo7+3LRbGdSSWUPUNNjfvj2MWtHffhHsIPU7ksCvFMTNTTc4NPihgOveQsh1osPKzOr8YHP5zkUceIAbpqCLqiJnqoym85KTUBv3sUC6NaANe6IdQG47ij+QnG+/d15npxBlgyOCChNKWcS1jKXkmqCkRggai8ezskm2E2Sr2o+QUaB8HtMousBPurdq2FEuzEEAjEbJtNuUt9W+51caZblyNQkLZ0W4ifdQE9yw8x7Ws/t1CNNANVQwJ7wWo/P4/uwvSNSSwUY4BiQuwnYKiq1tp1XLWmwN/9zZMNSCGQRaaqnsouAssffMn5SBRsAipFzCvTfR3zDX9do6RbDCGhjwo/p1+Pz5ugdJ8hhckRI64sO4Ke1nedPfXkFQQrcwYACoHeQ5Xo6RE6VrlADYOG4EV7Q0c8/myR3V0NGGiTp8L4DGH1bpdW8wgztQ/E/s2ajR9dq3uLYa+GD+wBQf5igc1NVa9VXFjbqeNAYewtStKeJG3gD1eB03DkXgcFIB3PkioOSSSbelPKq4oKZMuqMldHIbHk1aM2NIQ+dAp2EitaTyziB+iR387BIAz
X-MS-Exchange-CrossTenant-Network-Message-Id: 26800ad1-5849-4050-a293-08d8439a1ae2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 17:14:02.9779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlXIxp4A4XFX8hoLTg73rkRQcnPK29uij1SxrpMWquOfLQG41etPTPp7cg1Lh0vQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2488
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_11:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 10:06 AM, Alexei Starovoitov wrote:
> On Tue, Aug 18, 2020 at 9:24 AM Yonghong Song <yhs@fb.com> wrote:
>> index f21b5e1e4540..885b14cab2c0 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -27,6 +27,8 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>>          struct task_struct *task = NULL;
>>          struct pid *pid;
>>
>> +       cond_resched();
>> +
>>          rcu_read_lock();
>>   retry:
>>          pid = idr_get_next(&ns->idr, tid);
>> @@ -137,6 +139,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
>>          struct task_struct *curr_task;
>>          int curr_fd = info->fd;
>>
>> +       cond_resched();
>> +
> 
> Instead of adding it to every *seq_get_next() it probably should be in
> bpf_seq_read().

Yes, we can add cond_resched() to bpf_seq_read(). This should cover both 
cases. Will make the change.

> If cond_resched() is needed in task_file_seq_get_next() it should
> probably be after 'again:'.

We probably do not need here unless all tasks have zero files or each 
file just closed with f->f_count == 0 but the file pointer still there.
