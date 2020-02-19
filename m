Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C0164ADE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgBSQqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:46:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19146 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbgBSQqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 11:46:20 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01JGiN88021325;
        Wed, 19 Feb 2020 08:45:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Z8LD0V0m8xzVn4KyOauT80/VkLtqtrRpjP4QGf0kBgA=;
 b=GLOPUJ3Cc/Go+4LrA5CCBdIZMWhGq60uejHxdul7mDIJ2q/ECO68dZ5/AtfrExi/VCmp
 G/nVAz6TBNaPWoyWxFXzp80L25KK22D8T0TLq8bzCDbWIjTMWeaejtkUdoGIa0N+Hy0x
 YU2AX5RLSnab50v+8u9/Me/pjH6EaoQdErA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y8ubdudqh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Feb 2020 08:45:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 19 Feb 2020 08:45:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WB2daIsRM66NomE/qsg9Wrc/uOvUN80NqGKEo8WRsthqH6ooKBL+p78KKHNob7/FI8lvC/c/2cD4RDDZx9QHXglI7or8DRQdSOwSvP+Z7bwghc2zWHY5X6HI+vb8JmMCvhAVU6X51aeCHo9nfIeo5+gl+Bl7l7jVCkpQ6cZJ88ovRz+fF1plTcYCBv6cNt/gMsT/f+4LGH/q+K5GNHtCAray0INZbsj8g2Xtl/iSS57GC13XyThA02rXQztmsm+FV728ET8M2h1hTed1IwiqtTSOuF0KYsSEVw4CPpL9D0x5AB7YTSN0GvqneIdqwFZLSWgWIsdly2tl7z14csy3OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8LD0V0m8xzVn4KyOauT80/VkLtqtrRpjP4QGf0kBgA=;
 b=CJkqBPi/qWu3rqVo8JlK+akloVXZN//ITwGXKYKV2TaiMYXYStEnUbZd3dHB47oN+yL2XOPsprf1cnWeYROChJkn+Db5yBzpuJ+3G825pvHeAApcdh/2OuoVjb4rnBP7QEFWoPUcyAbAhD+Y7v/VCV71COgUta/sXktzsxe3nY0hdFBiHwnHE9KkrY+l9gbUtQ50byH0RFiGWagz6Q+mowN/vR46ig/jNQ3mGI2qCNqlWosQYlcSMjmDkKJbj75xL/Nwgga1xZCr5HdKICSPy2dCaDayJ/3PaT4NzjykjCMD8PCoW69VAazD3UDidp5tZazcqKaTgT0BGWy2xEkPUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8LD0V0m8xzVn4KyOauT80/VkLtqtrRpjP4QGf0kBgA=;
 b=jXAxPneO36Qv5hrDP0KeGXamcsdog6mC+fmmp7U4iW/1BAwurclsfGzzdWiOZGTM/SUXv3n2mda7vTBDkyUPxJJRjf9Xj4RdwX4v+DwNU5L8afy1tpTRX0BRoKmTH8ltsUanhugL8V0r3EdRzI9r0yu+AVahdkNpmJEJJO5jM5Q=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3115.namprd15.prod.outlook.com (20.178.230.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Wed, 19 Feb 2020 16:45:48 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.033; Wed, 19 Feb 2020
 16:45:48 +0000
Subject: Re: [PATCH bpf] libbpf: Sanitise internal map names so they are not
 rejected by the kernel
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <ast@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200217171701.215215-1-toke@redhat.com>
 <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net>
 <a0923745-ee34-3eb0-7f9b-31cec99661ec@fb.com> <87sgj7yhif.fsf@toke.dk>
 <e7a1f042-a3d7-ad25-e195-fdd5f8b78680@iogearbox.net> <878skyyipy.fsf@toke.dk>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <75035604-6cf8-515e-c0b0-569758ffa2e1@fb.com>
Date:   Wed, 19 Feb 2020 08:45:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <878skyyipy.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:300:13d::18) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from marksan-mbp.DHCP.thefacebook.com (2620:10d:c090:400::5:99e4) by MWHPR20CA0008.namprd20.prod.outlook.com (2603:10b6:300:13d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 19 Feb 2020 16:45:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:99e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c7d7e3b-7b37-43eb-8b36-08d7b55b2be9
X-MS-TrafficTypeDiagnostic: DM6PR15MB3115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB31155F0CF4F057BDF74FF6BED3100@DM6PR15MB3115.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(39860400002)(366004)(346002)(199004)(189003)(6506007)(31686004)(110136005)(2616005)(86362001)(53546011)(81156014)(31696002)(66946007)(6486002)(66574012)(66476007)(66556008)(186003)(16526019)(6636002)(36756003)(6512007)(316002)(8676002)(8936002)(2906002)(5660300002)(81166006)(4326008)(478600001)(6666004)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3115;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Whi+OPvQkG+Hx4TyONhSm7Lr9bjLU+dph3NXLefU5/NkQ52f0mu8JJGhcRM7ycMc8EXv4SFYDpao8RPPKejAvm0beJRAIuVs4eynD8pXe6hvqIiH+roEgzMhdWhIXRvnMdmofW52V4rWVdxQMyZ3DrtLGptnZ6ewUWGgcfDh2EQE8SESCqwmxrnSNwtKxF7+etb0pGrLmGOqNsmKk9ahv8Nl8jghrS5DwAATY3YwQyO1NxNJpzNv3l+5qqluNTPRW62oQfUkUgMXemt8iJLIzziURFoaGMCnaZt3kf57IaEAo+ldfEGWsV7Sx3apFbgtNbhdtqeOP0hH4fvanbXcTzxsBv/nVkRz8YzDjf/1GuKKbNnWH+i3hnp/Wln9XbUV6Axey78u/ryRGSedWcBu9MT2dGpEEfzeGRR+b80ui3UecJudjO8YaxGVCfrq4t2
X-MS-Exchange-AntiSpam-MessageData: jhW+z+fai4AMhn1ZgUvdMRgjXbc/vnXFouv35B9lbh1TmGErisEVc7PwBEhiMvQ4mUqFuFall1udZrcjdaAlfzMd/qiMdzGeXNgEsHASNYI1J6EF8xLjw+3F2/AuVJA+zFfM8Sil9od+kZpTQXkdspExOCwEsPYPLgh6Tj2FGj1Q2B04tUJjpCENDwYMq18L
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7d7e3b-7b37-43eb-8b36-08d7b55b2be9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 16:45:48.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ra65n/M+RPcLOkPMbbU19AWZQLS9t3E6l6woTseYcwT7bkYxxNDvDCjl2on0H7co
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3115
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_04:2020-02-19,2020-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/20 2:28 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> On 2/18/20 5:42 PM, Toke Høiland-Jørgensen wrote:
>>> Yonghong Song <yhs@fb.com> writes:
>>>> On 2/18/20 6:40 AM, Daniel Borkmann wrote:
>>>>> On 2/17/20 6:17 PM, Toke Høiland-Jørgensen wrote:
>>>>>> The kernel only accepts map names with alphanumeric characters,
>>>>>> underscores
>>>>>> and periods in their name. However, the auto-generated internal map names
>>>>>> used by libbpf takes their prefix from the user-supplied BPF object name,
>>>>>> which has no such restriction. This can lead to "Invalid argument" errors
>>>>>> when trying to load a BPF program using global variables.
>>>>>>
>>>>>> Fix this by sanitising the map names, replacing any non-allowed
>>>>>> characters
>>>>>> with underscores.
>>>>>>
>>>>>> Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata
>>>>>> sections")
>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>
>>>>> Makes sense to me, applied, thanks! I presume you had something like '-'
>>>>> in the
>>>>> global var leading to rejection?
>>>>
>>>> The C global variable cannot have '-'. I saw a complain in bcc mailing
>>>> list sometimes back like: if an object file is a-b.o, then we will
>>>> generate a map name like a-b.bss for the bss ELF section data. The
>>>> map name "a-b.bss" name will be rejected by the kernel. The workaround
>>>> is to change object file name. Not sure whether this is the only
>>>> issue which may introduce non [a-zA-Z0-9_] or not. But this patch indeed
>>>> should fix the issue I just described.
>>
>> Yep, meant object file name, just realized too late after sending. :/
>>
>>> Yes, this was exactly my problem; my object file is called
>>> 'xdp-dispatcher.o'. Fun error to track down :P
>>>
>>> Why doesn't the kernel allow dashes in the name anyway?
>>
>> Commit cb4d2b3f03d8 ("bpf: Add name, load_time, uid and map_ids to bpf_prog_info")
>> doesn't state a specific reason, and we did later extend it via 3e0ddc4f3ff1 ("bpf:
>> allow . char as part of the object name"). My best guess right now is potentially
>> not to confuse BPF's kallsyms handling with dashes etc.
> 
> Right, OK, fair enough I suppose. I was just wondering since this is
> the second time I've run into hard-to-debug problems because of the
> naming restrictions.
> 
> Really, it would be nice to have something like the netlink extack
> mechanism so the kernel can return something more than just an error
> code when a bpf() call fails. Is there any way to do something similar
> for a syscall? Could we invent something?

Currently, BPF_PROG_LOAD and BPF_BTF_LOAD has log_buf as part of syscall 
interface. Esp. for BPF_PROG_LOAD, maybe we could put some non-verifier 
logs here?

Maybe we could introduce log_buf to other syscall commands if there is
a great need in user space to get more details about the error code?
