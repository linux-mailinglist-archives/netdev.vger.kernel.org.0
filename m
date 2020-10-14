Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7B728E942
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbgJNXuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:50:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31852 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729327AbgJNXuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 19:50:17 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09ENj8V3011371;
        Wed, 14 Oct 2020 16:50:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AqNoZwDDORsiJRveirr4WO9UHLTuRLsiMjzTFHoxfv0=;
 b=ApbmndnCTLKlcVzS4ZOLEr3JV0WsL1Q5IRSJBDffU5UPJGneTVS9Fn/E06htHy7gtYg8
 4wmLiSfWp3+qe0qBYQSkn90NMPKAsVr1bq3hgwPVndDPddyg8G+LCvTEax8ksyCNXH8b
 hLI+QK3kSp/p4TQ3u9SbN1aKjA3PQbSWd8s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 345pwsp1b1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 16:50:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 16:50:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDNrhbwXhX8Bzb4uQhql4m3SX4GWtMsugmyTeVwfuxldl9zaRdHoqHptMyD+jEs3HIZBGBnu9Eo0JSqHizf6cRfIGcQxC8KnXzyFNCICK1QJPCqIpKzkJ5maxzla5s7jeh0x9QhGmkWvSwRiXiu67L722w+9HseXTUqKI8x4bR7Usv/pNA/bJaHgYyUWM988t3AwR6tYLu82nnamDF3wzdRXAsen6VqgImxuKjOpzww3YU8fzbzkeTbpk5nF9uQXIspJ5+Bqg3ZVto5n0mzlwg/IHyxsgXev9oNyNODeZXi1jKA5IWZJiS/RUNN+sy88cl7zgiBByubDiqunEUAPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqNoZwDDORsiJRveirr4WO9UHLTuRLsiMjzTFHoxfv0=;
 b=kLVY4Rc4mcZjExxbfW+fB+7Sm6khgNinV+hb4ulIk5gnobIcL3zn3JboC5/17lNHi0FsYTeFmrhOosU6FKR5mlKbRWYf1l6pOZKYmIrRX315bzOnU6mvBliaGxuN1Bjll2pZBsRD91wutuJlWOgoxKMm9aj0VbKZVk+Mz2P1oymrQHVwCmIMKmfBRuVEywS6ed+SsO4HKwxHiaIu6rhzeD6d8MUOOFREf5VaZ7VJg/Gdqgr6pssvmxUoa9gvskZGeQz+Y4AQFcm0wPdpl9x8y5MrxccjopW0INvWMsxYp1boDclS0zOySNyXE0RxukqtgZrUdI4SsYI9SN6Ut8FXcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqNoZwDDORsiJRveirr4WO9UHLTuRLsiMjzTFHoxfv0=;
 b=MYJyvpTOQwPRZ7bfKjnAdY0EBmlD4TWU2+MFllOeKh3SdG2YaUOgi4PnVXxxdNauR6y6zITq/6FyZM13LjGjRo8yMDVHqWsn7Im95O8juDO2Hsk+kCE92girWyv/CfYj5JUHFHnp5WTC6zUsDdQ95mgPC9d/q5B3XVhfgeS1abI=
Authentication-Results: virtuozzo.com; dkim=none (message not signed)
 header.d=none;virtuozzo.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2198.namprd15.prod.outlook.com (2603:10b6:a02:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Wed, 14 Oct
 2020 23:49:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.030; Wed, 14 Oct 2020
 23:49:59 +0000
Subject: Re: [PATCH net v3] net: fix pos incrementment in ipv6_route_seq_next
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Vasily Averin <vvs@virtuozzo.com>
References: <20201014144612.2245396-1-yhs@fb.com>
 <CAEf4BzZ4J-c-ODnBD3C8NJeeLOdCqLWvFadWXR8t9eFKaGZOvw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3fcfa6c6-9229-7500-df06-64fbb7dfb01d@fb.com>
Date:   Wed, 14 Oct 2020 16:49:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <CAEf4BzZ4J-c-ODnBD3C8NJeeLOdCqLWvFadWXR8t9eFKaGZOvw@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c091:480::1:2a8a]
X-ClientProxiedBy: MN2PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:208:239::31) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11c9::138b] (2620:10d:c091:480::1:2a8a) by MN2PR08CA0026.namprd08.prod.outlook.com (2603:10b6:208:239::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Wed, 14 Oct 2020 23:49:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f4b185e-ad33-4cee-b427-08d8709bdc6e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2198:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB21981153BF8D3A8D6A1FEF5ED3050@BYAPR15MB2198.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdxKfxTk4dU88kNTDNHF6x6LX7+2g7Jk40LhwJPgBAd1XxtAmTnc5YYeSmc48hquRMBvfA/V7qmfrLMtcS6A1JOKMSmfZK7cDemRN4buazmEeJ/51YRCeXJS6tFSMU42iPltS8CpkSVEBd4As7IZu3U1SnjCgdDP8DUaNhTdlX6POvDpZk7r+vKSiQlYaaHbitA5VCz/IWkTPIZxdNkEY3ZpxcsmrKdTufJmD14/DQwi4dbWCh29zwJsFV4drq/kPz34FPDsc3hu0puTcqp62WhixvIPAz0a+rst72OL5diKMcpk7G6jVfrckeLCMhPzX12lzc8lbt/EPT/Z9OPZxcHIWh3cFxSzpC5Z0hlgN03X/UNa9xgKbjLvQrPHVfhBrMr798oQNyY+7GrICrIIARr/O0gNchaiNmXoivoSEFSiSwj17bQ99jpPJkTTXG/3m9/UMj/lonyL0N9OmvCuNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(366004)(376002)(136003)(478600001)(66946007)(66476007)(66556008)(86362001)(4326008)(53546011)(52116002)(6486002)(2906002)(16526019)(186003)(316002)(2616005)(54906003)(966005)(31696002)(8936002)(5660300002)(6666004)(36756003)(6916009)(83080400001)(8676002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yIKvdK6BE/WjNyOK+zCuyDk6aj42447OmRIz+xe2eichbaPjmnKL8lAyFwz6mBnlMUNLwZ0RTWyZTT7rkUG7nGqZej1BG2rV1p+Ai8WMiUXyf3xVyNKXAFJaj6kcH0Y5EHenjEAQSwP6dxSS+kJw0eOuQrDl9ppP43kBpL7cNjLnOgCjxhgr+aaSF1cKTIt6g6Kq0Z5NVaZMdHKilsTa5fXp8KiP+qs/99MQCRR9n1Qra4p69IDOG2Vl4j63U0XwivXzHnw6cqSzJVMkq/YHUXj2+20NmBHDwDSVJ4XoGh48Wiq6sdichVDU++kOAQTT2YyyvJWk5l1oBlkYUp9IGS2dQed8Bk4mJsQh1N+UHBxfTWwaxl8HNcQI2QzAGrIQL+8kBxEolsKYnhGg/J86EF98nPTJChx168Cj6oliewtOvfFleP3i1ptyoo+c9JNpO4bjWjhlKReAbOBySl4ndA+9JeN8komjwjhswOwqd1JK42YQs1v3nrqH25SHgfxfTXycCy1uVHsLG0N9Xak2f1McV96c66MTBRbHIMXlshx3H3XzOJDJlTEfa5ifx9QVEYzPKWTEZ8pWPOw76BXbK+O5yxamI3OEXBTRvFo/SzYhw7cIOs29msIqzwm7Vh2s5YW3f40rjjN01S40FmfEt8ioJGssuDxI8BhsXZQmQiA=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4b185e-ad33-4cee-b427-08d8709bdc6e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2020 23:49:59.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sol8tT4sVFbuMMrkrXw5XILYBVknNq7IrZm6D2jylwtiQU3jNQbXZRJDrLsZSDoX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2198
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_12:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140165
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/20 4:14 PM, Andrii Nakryiko wrote:
> On Wed, Oct 14, 2020 at 2:53 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
>> tried to fix the issue where seq_file pos is not increased
>> if a NULL element is returned with seq_ops->next(). See bug
>>    https://bugzilla.kernel.org/show_bug.cgi?id=206283
>> The commit effectively does:
>>    - increase pos for all seq_ops->start()
>>    - increase pos for all seq_ops->next()
>>
>> For ipv6_route, increasing pos for all seq_ops->next() is correct.
>> But increasing pos for seq_ops->start() is not correct
>> since pos is used to determine how many items to skip during
>> seq_ops->start():
>>    iter->skip = *pos;
>> seq_ops->start() just fetches the *current* pos item.
>> The item can be skipped only after seq_ops->show() which essentially
>> is the beginning of seq_ops->next().
>>
>> For example, I have 7 ipv6 route entries,
>>    root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>>    00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>>    fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    0+1 records in
>>    0+1 records out
>>    1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>>    root@arch-fb-vm1:~/net-next
>>
>> In the above, I specify buffer size 4096, so all records can be returned
>> to user space with a single trip to the kernel.
>>
>> If I use buffer size 128, since each record size is 149, internally
>> kernel seq_read() will read 149 into its internal buffer and return the data
>> to user space in two read() syscalls. Then user read() syscall will trigger
>> next seq_ops->start(). Since the current implementation increased pos even
>> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
>> record is #1.
>>
>>    root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
> 
> Did you test with non-zero skip= parameter as well (to force lseek)?
> To make sure we don't break the scenario that original fix tried to
> fix.

I did with skip=1 and it won't show the last line any more. And I
did not really change that logic (increasing pos even when returning 
NULL for seq_ops->next()).

> 
> If that works:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]
> 
>> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
>> index 141c0a4c569a..605cdd38a919 100644
>> --- a/net/ipv6/ip6_fib.c
>> +++ b/net/ipv6/ip6_fib.c
>> @@ -2622,8 +2622,10 @@ static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
>>          iter->skip = *pos;
>>
>>          if (iter->tbl) {
>> +               loff_t p = 0;
>> +
>>                  ipv6_route_seq_setup_walk(iter, net);
>> -               return ipv6_route_seq_next(seq, NULL, pos);
>> +               return ipv6_route_seq_next(seq, NULL, &p);
> 
> nit: comment here wouldn't hurt for the next guy stumbling upon this
> code and wondering why we ignore p afterwards

Typically you won't increase pos from seq_ops->start(). So I think
we are fine here without comments.

> 
>>          } else {
>>                  return NULL;
>>          }
>> --
>> 2.24.1
>>
