Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A041A429E
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgDJGmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:42:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgDJGmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 02:42:08 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A6ewKT019957;
        Thu, 9 Apr 2020 23:41:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=S2Sag/vr2DmJ9UpWt3BBbJEXJJk8ivg64hnnE12PR3I=;
 b=TPYZl4c4E48NqoSDTEz/cKvv7oQhfU8Jqlb/dKgLQtZoieyn2rzm6A7zSu/YwEeEnuBq
 x/YlrDgU3nqIzEcF04Mh3+GU/tPot0WOkSfMVJWHC2OWFgm83Gx/HT7LRpxYecla+i0o
 jaenC3vtbTIsGHlTp2NSc5PPk/WjuQw4EHU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3091ksxugn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Apr 2020 23:41:56 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 23:41:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2mFpDM3IdkxJ8Vns2V2nM0fUMtZrRqI+BES9a9Dp/e0ibMj3t2KgYPjEo75lHYQfpcCotLawLhOtyYSlQXXJu1uZJ4nDuxqFSXwz1bCt2F1DFrj6N8ZrngdOL+2Dkdq4WJG1w2UoG8JUP/HWwR8j2ndhHnWLqyMegVO6fDZsMaqzTAsFJS6F0AMVFZmAdX6F8pZEVSDpS/LsatVKjXjTS1CBNQD1FdsmWeRSClmx/pzTva7ph1dXhRL85JC0jJZTQk/vWaTOxwc+tWc5F3qAW/T27bwOf3Mr9LY2zttjDhGZHur0gUORoUmE3ywhiaCBHMxkjrI7KSAxGrel2XMuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2Sag/vr2DmJ9UpWt3BBbJEXJJk8ivg64hnnE12PR3I=;
 b=Pj9tAnTXMBulLZ938juOTvHiOL471z/YUwdpK66K8OM2381PyhOXicMTR9naxjrzCM5mNT3rP5Lt39/KtsuRfMLitR2ndulKnFMXw0Brro7nasgY2rDwSU6fcBwP1bQqfYm/O+VUvAHqRatOZFBXnbwYIewgz4U8011CDKDbreAjsFmcfnVuspm6uHWnS9mb7q3D18DXnbTasPNRLa3bBMJSUBV30iTRI6uyMxQTQJIeKgaVFbFQ7Lta462msUvwJJG1iQkSAUlH1KPnPG3ZrzVZUgFSyXwf9r+92IOXRrIxIHE/6BHjtQoGK1wiEVoh2SOEtn5r1CF3P3bqlqMAhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2Sag/vr2DmJ9UpWt3BBbJEXJJk8ivg64hnnE12PR3I=;
 b=Q5+vhchGpxaoQNrWT8+p0OyVbvVyxoOlklTfkCOR5N6Qo5VNMK1oU99Yc0AHkxQ8ef/rC5+fPiOaTkWQh55p00YwekB4t51J5/6BLCpLNVfMGiJT8joMl3z2T+ULOpH5h0PFEq3bovDfvJw01Ia+SgiIPdNnqQ6oiZI0i5K5gks=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3833.namprd15.prod.outlook.com (2603:10b6:303:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20; Fri, 10 Apr
 2020 06:41:54 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 06:41:54 +0000
Subject: Re: [RFC PATCH bpf-next 15/16] tools/bpf: selftests: add dumper progs
 for bpf_map/task/task_file
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232538.2676626-1-yhs@fb.com>
 <20200410033351.kuzndr2oovjz5xln@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <75985227-01a9-3ca6-6a72-3f50dd3f1a45@fb.com>
Date:   Thu, 9 Apr 2020 23:41:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200410033351.kuzndr2oovjz5xln@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR18CA0047.namprd18.prod.outlook.com
 (2603:10b6:320:31::33) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rutu-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75b7) by MWHPR18CA0047.namprd18.prod.outlook.com (2603:10b6:320:31::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.19 via Frontend Transport; Fri, 10 Apr 2020 06:41:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:75b7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34e0f394-5e97-437e-b62c-08d7dd1a41b5
X-MS-TrafficTypeDiagnostic: MW3PR15MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3833AD2BB31988CA22D48A01D3DE0@MW3PR15MB3833.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(136003)(376002)(39860400002)(346002)(396003)(31686004)(5660300002)(2616005)(478600001)(16526019)(186003)(52116002)(8676002)(8936002)(86362001)(6506007)(53546011)(36756003)(31696002)(81156014)(54906003)(2906002)(4326008)(6512007)(316002)(6486002)(66476007)(66556008)(6916009)(66946007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtDZQL4/1GZki67TUtn9ym22yNMa6U20qw3OI+b1AXvS8Xp/vUDIo/laLnmuXupMpSHuYOMlJvJ+P/I40TjTpFHPEUwZV0eIX/pTByiypGkJWVwEC0tUJOkQP3KVAOwBEYq3MP1Lq+LRjUl03vPsrYGioOTwAm/PFhqOlLxXiW+TizObZPb8xuDiAAbYe1s5XflI/njjLg2v3lfVJT+ag2cQghjASYAE12PzprIUYRNBk02Cd729tRWGzo0jYO4IcGIEBGY+8/J1gio8tEKzh3rGRYB3zCtEIurrrMFkjRjJSK9R3/oT1LGP65JDTv+CIFB17W80L4/MeriHkDvBUh596Y+OvaDhgGS4y7w0cCPHK4W/ZOrXk+X95n6NpVzjh1JJQL0eC2jcAtYFrPKbzGtHhBZbU9GLkyMEt1K57P12ijOt5C/YYrkAzPDuZCw0
X-MS-Exchange-AntiSpam-MessageData: f6eXjB4npiw3vYobU6XpRBUVxk3PqBTt1kp+3HWSz5iTC/GK6QjhBrRye4QKpYZEwCMdAENX6F5gI3v/Gzr0x/iXnHV6KySh6mqZ9cowc7IIzAZL/zteEK4nTTGmaV1KXhkFZ4pTB9q2QK5h25dIVA12BaKXp1HuFyVhd+xFVxnz0iPrDxmapDNpKMSVgZCe
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e0f394-5e97-437e-b62c-08d7dd1a41b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 06:41:53.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LL9JL+mpK05oTUJ8sj282+J47Px0T4wWM4DwtvrNxoHEQxeiBuxAVhCi9uBhnuFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3833
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_02:2020-04-07,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004100055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/20 8:33 PM, Alexei Starovoitov wrote:
> On Wed, Apr 08, 2020 at 04:25:38PM -0700, Yonghong Song wrote:
>> For task/file, the dumper prints out:
>>    $ cat /sys/kernel/bpfdump/task/file/my1
>>      tgid      gid       fd      file
>>         1        1        0 ffffffff95c97600
>>         1        1        1 ffffffff95c97600
>>         1        1        2 ffffffff95c97600
>>      ....
>>      1895     1895      255 ffffffff95c8fe00
>>      1932     1932        0 ffffffff95c8fe00
>>      1932     1932        1 ffffffff95c8fe00
>>      1932     1932        2 ffffffff95c8fe00
>>      1932     1932        3 ffffffff95c185c0
> ...
>> +SEC("dump//sys/kernel/bpfdump/task/file")
>> +int BPF_PROG(dump_tasks, struct task_struct *task, __u32 fd, struct file *file,
>> +	     struct seq_file *seq, u64 seq_num)
>> +{
>> +	static char const banner[] = "    tgid      gid       fd      file\n";
>> +	static char const fmt1[] = "%8d %8d";
>> +	static char const fmt2[] = " %8d %lx\n";
>> +
>> +	if (seq_num == 0)
>> +		bpf_seq_printf(seq, banner, sizeof(banner));
>> +
>> +	bpf_seq_printf(seq, fmt1, sizeof(fmt1), task->tgid, task->pid);
>> +	bpf_seq_printf(seq, fmt2, sizeof(fmt2), fd, (long)file->f_op);
>> +	return 0;
>> +}
> 
> I wonder what is the speed of walking all files in all tasks with an empty
> program? If it's fast I can imagine a million use cases for such searching bpf
> prog. Like finding which task owns particular socket. This could be a massive
> feature.
> 
> With one redundant spin_lock removed it seems it will be one spin_lock per prog
> invocation? May be eventually it can be amortized within seq_file iterating
> logic. Would be really awesome if the cost is just refcnt ++/-- per call and
> rcu_read_lock.

The main seq_read() loop is below:
         while (1) {
                 size_t offs = m->count;
                 loff_t pos = m->index;

                 p = m->op->next(m, p, &m->index);
                 if (pos == m->index)
                         /* Buggy ->next function */
                         m->index++;
                 if (!p || IS_ERR(p)) {
                         err = PTR_ERR(p);
                         break;
                 }
                 if (m->count >= size)
                         break;
                 err = m->op->show(m, p);
                 if (seq_has_overflowed(m) || err) {
                         m->count = offs;
                         if (likely(err <= 0))
                                 break;
                 }
         }

If we remove the spin_lock() as in another email comment,
we won't have spin_lock() in seq_ops->next() function, only
refcnt ++/-- and rcu_read_{lock, unlock}s. The seq_ops->show() does
not have any spin_lock() either.

I have not got time to do a perf measurement yet.
Will do in the next revision.

