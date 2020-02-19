Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2D163BC9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 05:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBSEEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 23:04:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbgBSEEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 23:04:11 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01J3vJxX002714;
        Tue, 18 Feb 2020 20:03:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=78CLQtV3QFjxONi3GHvA+o6nUAYD+4y+JiRLaXQRRoY=;
 b=mEerubVRuO/0/buph9k0d7WOdv87S02Z6/6a14jWPby87J19NiLlN7rqeAwFL4o43pna
 nt/yiOFj5tdNZOfAJFp60al9waaW/ISba7PwPzlP1RATZy696vf2FD2tF/9wRXe/BJLI
 AnCDhIyoUTDsp3mCEJ+FzseiWo7Aph2124c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y8ud18ftq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 20:03:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 20:03:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM53FOMDCrbifWFsUCz7360BvfWUNdz5ypbxjkogLfHhx3b55hEB5sgH3HsnZRI9mWU26LsNvogDnXSTNQQC37PhnxdlGAIwiwgS8lgfewKHtiKYRosOAu5A/g6ksT2QoUUqfZOcfDtDa/e1bfVTPv249kyoq0r+OegA7XaGivH35biVZo2yopqQ/SlC3djE/CoFj+hque9tA9PPMFN8G3sJd9HrMyTKpeGrr8ltlphxLqGT/opHk4Ge9Yd5RVK5wm/pUfqMin9OewlwhFNDG7stydAzVdOjwQBwV5nyXWPKom4veIkBtrNM5FPa55M4DbK2X7NWHmYk9latgcHwjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78CLQtV3QFjxONi3GHvA+o6nUAYD+4y+JiRLaXQRRoY=;
 b=E6zSQYhJ90sx1vUrBhhPGovbW6b4liGlvTo4w53HTBJydW/PJi5OuPWlaMrjyHy08Yp85fFf2tW7yycCpejLa1sQe+2rYD/F2m9ayUvUFFWde6wjemQzzjmlqnEY+kk80BF76SV8ZOQGX2JPAs1UGTgB6EeTwiYRbJf1T/llNwk1BEOQLu99ZFj2OgLEOZTOx7WqP/TC1Z9L8afaX3Mx/GNoab0UlZPBBG81zlNHs4gJ9pZJUqqJouJzudKqUr3Sf2UYAnOKEMWGCpgGhcs53OwPLTJMAUNaI5TaAw53vUSBU1GeR1lmjYqcRlYIrSoH9FJ2u+SxppgsoY/wWQqH5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78CLQtV3QFjxONi3GHvA+o6nUAYD+4y+JiRLaXQRRoY=;
 b=c7buKpAE7ZmDLSkqW9ih0BEwsNH1c+ZZBWJjIg1gXiwk67GwXBn23L0UguiKb/yMk1MWdEkIy7mCu4I8tBQWVhtCGIe5F4SqGxSxChq5x3hyBMbKI0uEOAZk/QzzDQo/rug1jLqkz3kkOSCC/O1wgMDSjw0Dn/l1qyZ5x5rEAwE=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3912.namprd15.prod.outlook.com (20.181.5.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Wed, 19 Feb 2020 04:03:28 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 04:03:28 +0000
Subject: Re: possible deadlock in bpf_lru_push_free
To:     Hillf Danton <hdanton@sina.com>
CC:     syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>,
        <andriin@fb.com>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>
References: <20200217052336.5556-1-hdanton@sina.com>
 <dca36c4b-bbf5-b215-faa9-1992240f2b69@fb.com>
 <20200219021542.3304-1-hdanton@sina.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7e8c1cf0-fccf-1ed9-40ed-3a13b2287cf8@fb.com>
Date:   Tue, 18 Feb 2020 20:03:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200219021542.3304-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0085.namprd15.prod.outlook.com
 (2603:10b6:101:20::29) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from marksan-mbp.DHCP.thefacebook.com (2620:10d:c090:400::5:982) by CO1PR15CA0085.namprd15.prod.outlook.com (2603:10b6:101:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Wed, 19 Feb 2020 04:03:26 +0000
X-Originating-IP: [2620:10d:c090:400::5:982]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f46ffc7-35e5-4cd3-fd05-08d7b4f0acbb
X-MS-TrafficTypeDiagnostic: DM6PR15MB3912:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3912AF900235918EC72A9C11D3100@DM6PR15MB3912.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(39860400002)(136003)(346002)(189003)(199004)(66476007)(66556008)(5660300002)(31696002)(16526019)(186003)(2906002)(66946007)(316002)(4326008)(6666004)(6916009)(36756003)(6486002)(6512007)(31686004)(81166006)(81156014)(6506007)(53546011)(8936002)(52116002)(8676002)(478600001)(2616005)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3912;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 17O4NBg10BM+SdzluzwwDZKGBGd9RLflxKr5CYX04RSOkftMDQATc7Fy9I/Pf4VzAiXsO4Uf2HDjOw0kDXg1Fu5JZYVYScyeaxk3xYj3LipISk/wQEmQq3410Tu8JVZGYtKZGE0FB4MaG7uPfyVli8TDnd8s8LjxwAbWEMyhG4kScT+MB3KFbuTsM3aRH3T9RYionXOd+MDFy/ogT39SM3RibiqrcqMeblrn35/Daxuo6Wu6Ts1grdTkkwhxKzMR+31CzFf/5ZY3jV5QeyNc2BFOzAk0jcNXIFu4Ps+48b4SUD3Bvtf01h8rH1P2ss96RJhhkXEB12wS8k/RoZ67/MfpW4xhb7fF9NXenLRIrBx8OQFWCgxUKp0aFe+r0GK383H1qOwXeTA2yWs+qdmYYAq4T+VtbLhvMesEEOk/bMkc6fDIQ/ABiHS2gRjt5BWX
X-MS-Exchange-AntiSpam-MessageData: OcTdcRVNy3W4QyLXP5Xhydx2Jq7W8FKCcA/eKjHZGlzy8kD+LwP4225V/qKx4qJ6ICj5PoOFZL+s6Jxd8zFyY14BrOofvEpjjzJXGKLPsNBkHen/W+9MIFNo/sFxF5owwFj/5BsX6SOfr9qphkPzBnpCs99eKpIXowSL7VLufbmLmwaVFvcOcEKAZA+Ib0eG
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f46ffc7-35e5-4cd3-fd05-08d7b4f0acbb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 04:03:28.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncc4PglXqXvHac/KtZJwSdHBrvuGpoXPfeAIURjFdXGea66VtfcNzUW38fB9XqAf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3912
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_08:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=717
 mlxscore=0 suspectscore=2 lowpriorityscore=0 clxscore=1015 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/20 6:15 PM, Hillf Danton wrote:
> 
> Hey
> 
> On Tue, 18 Feb 2020 15:55:02 -0800 Yonghong Song wrote:
>>
>> Thanks for Martin for explanation! I think changing l->hash_node.next is
>> unsafe here as another thread may execute on a different cpu and
>> traverse the same list. It will see hash_node.next = NULL and it is
> 
> Good catch.
> 
>> unexpected.
>>
>> How about the following patch?
>>
> Looks nicer, thanks :P
> 
>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
>> index 2d182c4ee9d9..246ef0f2e985 100644
>> --- a/kernel/bpf/hashtab.c
>> +++ b/kernel/bpf/hashtab.c
>> @@ -56,6 +56,7 @@ struct htab_elem {
>>                           union {
>>                                   struct bpf_htab *htab;
>>                                   struct pcpu_freelist_node fnode;
>> +                               struct htab_elem *link;
>>                           };
>>                   };
>>           };
>> @@ -1256,6 +1257,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>>           void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
>>           void *ubatch = u64_to_user_ptr(attr->batch.in_batch);
>>           u32 batch, max_count, size, bucket_size;
>> +       struct htab_elem *node_to_free = NULL;
>>           u64 elem_map_flags, map_flags;
>>           struct hlist_nulls_head *head;
>>           struct hlist_nulls_node *n;
>> @@ -1370,9 +1372,14 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>>                   }
>>                   if (do_delete) {
>>                           hlist_nulls_del_rcu(&l->hash_node);
>> -                       if (is_lru_map)
>> -                               bpf_lru_push_free(&htab->lru, &l->lru_node);
>> -                       else
>> +                       if (is_lru_map) {
>> +                               /* l->hnode overlaps with *l->hash_node.pprev
> 
> nit: looks like you mean l->link

Yes, my previous attempt uses "hnode" and later changed to "link" but 
forget to change the comments.

Will post a patch soon.

> 
>> +                                * in memory. l->hash_node.pprev has been
>> +                                * poisoned and nobody should access it.
>> +                                */
>> +                               l->link = node_to_free;
>> +                               node_to_free = l;
>> +                       } else
>>                                   free_htab_elem(htab, l);
>>                   }
>>                   dst_key += key_size;
> 
