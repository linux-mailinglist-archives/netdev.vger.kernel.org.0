Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921DE1A5D18
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 08:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgDLGvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 02:51:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55814 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbgDLGvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 02:51:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03C6oEcR028411;
        Sat, 11 Apr 2020 23:51:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JBvYqZ0Qshj4s0EHg18TX6TPRqSTFI+vUmcG4qF3uzo=;
 b=ie6Sc3oWkze4I5C9YT82E3D86WR6fTW9e95JIpSO4ZkNV0GVJSDqvOOPq4QDHnqLsz7I
 UXEYn/8zdoHk7Ce7HFqMmKTyzL3TdbQmeuJKeY0ZFikDYWKv4c+nfLoCLXBOHqEbrgYL
 s0NdERjVRtrqBPOXbC235plNzuWh/JT+60c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30bbqh36dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Apr 2020 23:51:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 11 Apr 2020 23:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4IwQpfJ2VZq/BYRQYyhd9cGjgcCcWeeV/gB4S3z//ghrmIoVYFmopBh9sh1ACtKGhsrrI1sMXDX+1QnFWvUHhxV9Sf6NnVDQI1V6eh6GCIauxqXOxcw8CcIcz25RuB/XIGr9fdecY//XSU0Jv5VEKC+znyATn3Q+hm/HGXueSm81DvYLmV6yVOrBZDHPKEKQKRQ1Uzxe79VX8XWbdBpMXlollFL4BbHtun1Tcfi7e7bz/MF8hQDmp7LCaX9kreOh2eYZI81M70OTVIJrNsHyI+Q2Mxx6vs8taLAweotQET+fQqKvsLeVPhoY1ZJRnB1UHE4Rb5KAk1CI+AWHsnIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBvYqZ0Qshj4s0EHg18TX6TPRqSTFI+vUmcG4qF3uzo=;
 b=BHNc4eUe8bVaCzgSM32t4t8pJG3qi3WyJ+OWu5O1u5Jv1DTJP0cKeZQPh9JMLF34/EEksxEh7/EZ+yL1B3XgWiKepbwLHD3nTrlDhF96rg32ELRyP7tmQcB3DXeq3jjeZwdoukmF5wrQdSAqpSp7HCDfHC6uzClJl+c+3aggsS86mSp+k+i0p/MMihQWmPKscDfuNiQzf2XEROXdc7NHYn29AqBK0TuMEcO7fHr/z3jw68T6SivV7wmpCdtTIzTOoykUIEbLSFrHkOjuvpVy9CmbbqhEakE3V9yfrfWrvLAdV85qRcjhOH3y5lNtMv0fkR+QFX6COXW6bfJLWwUeLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBvYqZ0Qshj4s0EHg18TX6TPRqSTFI+vUmcG4qF3uzo=;
 b=Y4jxGZa10//GaXa4BH6v7zJH4V42BUGKlz7DdP0FKc90w9bctUP+LRzYYr1rU50y1C/2vgp3GEVKPN/1+uvAA1sg3WjPwUyWO6PtcgCrFzoxaC7R7Fju5VBGtogTnuxKR0T+8VcrXqjm72U03IGi+Q8ljrUHlOghtASzKootpdA=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3979.namprd15.prod.outlook.com (2603:10b6:303:4b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Sun, 12 Apr
 2020 06:51:25 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2900.026; Sun, 12 Apr 2020
 06:51:25 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
 <c34e8f08-c727-1006-e389-633f762106ab@fb.com>
 <CAEf4BzYM3fPUGVmRJOArbxgDg-xMpLxyKPxyiH5RQUbKVMPFvA@mail.gmail.com>
 <2d941e43-72de-b641-22b8-b9ec970ccf52@fb.com>
 <20200411231125.haqk5by4p34wudn7@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <de2afb7a-40f1-0dbd-0bd1-7e5f90de1338@fb.com>
Date:   Sat, 11 Apr 2020 23:51:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200411231125.haqk5by4p34wudn7@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR2001CA0010.namprd20.prod.outlook.com
 (2603:10b6:301:15::20) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:55c6) by MWHPR2001CA0010.namprd20.prod.outlook.com (2603:10b6:301:15::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Sun, 12 Apr 2020 06:51:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:55c6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f66bcba-f8e4-4c4d-a9f8-08d7deadeb01
X-MS-TrafficTypeDiagnostic: MW3PR15MB3979:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3979E22A5FF8C4631462CB71D3DC0@MW3PR15MB3979.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0371762FE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(396003)(39860400002)(366004)(346002)(136003)(81156014)(66946007)(52116002)(2906002)(316002)(36756003)(8676002)(86362001)(66556008)(66476007)(6512007)(6506007)(31696002)(478600001)(53546011)(4326008)(6916009)(2616005)(186003)(5660300002)(54906003)(8936002)(16526019)(31686004)(6486002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fMyW6uysOnv7tY/qFMVYnblO6N8bhQby5xVkGvWKLUCeaX8uINaLw40e7O7DdVSTfexkNaxyYvuaEiKoxHyUgREMQUBx2LdG0rvFW/DKpdz5c+QZNrel4IvkzkKZD4ejmWYrtNHbvNipwwa0+/K2qbtvu9P+fLF0fIfCiyOq0D/p6AxAEuAOqiwrjUHxTVLoVWgweK7tQmTIXf83Lm4dBelpUboEdMoRf80MrXswaMUDZ5bfxbyA7Own4Co0gKMKi4zbL7rlf7Bouix+Yj5tBKuVRnJw2KL0qnvKUk3YmkRgdqHzh6u/qrdKqQMe+R66e8J1zWK4wXENOlswUhe0atQIOKTXa9MpD2Y55C12pNDKi0nrRL48/x3XxUJB+sZAUDHM3JmYle7H4M15BQ/hePd8SJgQ8PrQkdragSdHlZ9qI1uB+XUxHvbWkKQXTTRy
X-MS-Exchange-AntiSpam-MessageData: sB+vrEdBy27UQxr9Xw5p5qnS0SiKcgprMiXEAori2GbEnWoTkfxp+9Y2tSXdFcmvUwWeuGDCkFnywuRD21DZzi0QbvBxSaQJ4pFXVBs2veiCp1lNAl5CwM5vTNCPDX6FLYEhv8SvEOMcfjiA9Sc3UC4oDRNZuNLZuzSTIhgOomwaPzEGdBTm5yqCFwtREOe8
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f66bcba-f8e4-4c4d-a9f8-08d7deadeb01
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2020 06:51:25.2694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtaNr7YDXge/TchttxgPCd8pvuTjfBEM95p2RiiTBng369iSnTIxSULdjVfvs8cg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3979
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-11_06:2020-04-11,2020-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004120062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/20 4:11 PM, Alexei Starovoitov wrote:
> On Fri, Apr 10, 2020 at 04:47:36PM -0700, Yonghong Song wrote:
>>>
>>> Instead of special-casing dumper_name, can we require specifying full
>>> path, and then check whether it is in BPF FS vs BPFDUMP FS? If the
>>> latter, additionally check that it is in the right sub-directory
>>> matching its intended target type.
>>
>> We could. I just think specifying full path for bpfdump is not necessary
>> since it is a single user mount...
>>
>>>
>>> But honestly, just doing everything within BPF FS starts to seem
>>> cleaner at this point...
>>
>> bpffs is multi mount, which is not a perfect fit for bpfdump,
>> considering mounting inside namespace, etc, all dumpers are gone.
> 
> As Yonghong pointed out reusing bpffs for dumpers doesn't look possible
> from implementation perspective.
> Even if it was possible the files in such mix-and-match file system
> would be of different kinds with different semantics. I think that
> will lead to mediocre user experience when file 'foo' is cat-able
> with nice human output, but file 'bar' isn't cat-able at all because
> it's just a pinned map. imo having all dumpers in one fixed location
> in /sys/kernel/bpfdump makes it easy to discover for folks who might
> not even know what bpf is.
> For example when I'm trying to learn some new area of the kernel I might go
> poke around /proc and /sys directory looking for a file name that could be
> interesting to 'cat'. This is how I discovered /sys/kernel/slab/ :)
> I think keeping all dumpers in /sys/kernel/bpfdump/ will make them
> similarly discoverable.
> 
> re: f_dump flag...
> May be it's a sign that pinning is not the right name for such operation?
> If kernel cannot distinguish pinning dumper prog into bpffs as a vanilla
> pinning operation vs pinning into bpfdumpfs to make it cat-able then something
> isn't right about api. Either it needs to be a new bpf syscall command (like
> install_dumper_in_dumpfs) or reuse pinning command, but make libbpf specify the
> full path. From bpf prog point of view it may still specify only the final
> name, but libbpf can prepend the /sys/kernel/bpfdump/.../. May be there is a
> third option. Extra flag for pinning just doesn't look right. What if we do
> another specialized file system later? It would need yet another flag to pin
> there?

For the 2nd option,
    - user still just specifying the dumper name, and
    - bpftool will prepend /sys/kernel/bpfdump/...
this should work. In this case, the kernel API
to create bpf dumper will be
    BPF_OBJ_PIN with a file path
this is fine only with one following annoyance.
Suppose somehow:
    - bpfdump is mounted at /sys/kernel/bpfdump and somewhere else say
      /root/tmp/bpfdump/
      [
        I checked do_mount in namespace.c, and did not find a flag
        to prevent multi mounting, maybe I missed something. I will be
        glad if somebody knows and let me know.
      ]
    - user call BPF_OBJ_PIN to path /root/tmp/bpfdump/task/my_task.
    - But actually the file will also appear in
      /sys/kernel/bpfdump/task/my_task.
there is a little confusion here based on kernel API.
That is exactly why I supplied with only filename. Conceptually, it
will be clear that the dumper will appear in all mount points.

Maybe a new bpf subcommand is warranted.
maybe BPF_DUMPER_INSTALL?





