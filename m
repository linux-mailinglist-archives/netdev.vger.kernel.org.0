Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5E01AF783
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 08:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgDSGMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 02:12:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgDSGMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 02:12:08 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03J69HUK021638;
        Sat, 18 Apr 2020 23:11:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tWsiE05lXpcYEKGVezsKZEWX1mbmXZIiXcmTbfBhxS0=;
 b=W3zvujo1WUGPMYFYOcMC/e044Zdf4RRSa+lPRNFvlZrkRMqEGOxKR8TkD/6n854/spVi
 sa8egev0S5XXtVwysnU38OyE908T/xjHmTAFLQLGb4SmFldJoBA7cGdPoFYOTea+8OyA
 TDVpnWTG3prwZFaYOjfXsfPz5AC9ClehfLw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30g0ut378m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 18 Apr 2020 23:11:52 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 18 Apr 2020 23:11:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyDk5zNA0MAZfb7c6K7sZ5sNAMgl826MUMbCAWtiX6VEYem0diRqce5lgYuQprHE7BNds7CNPo3FxafCHnRK+rZWtYyoro08XSM7+RDEZLxDd1KycpC03muRLTQCHINEUH9pvhD4OqAUwo76cS9VYDBRwRjOb/UzUo1tdF3NHhUtUHNQPtqlft4geK377UMabYNZvb80SLGybdDAxT4ALZ9g4pOmHhdJV6usAzezRdduLvO0UD1IYp6b0qvaYkoOwpV0yRYJiCPOg32geby5ncszsVE6154y2jD1ptiwV0wTZFFaCHr9MVL/Ppw0o+Oh0n4HVCOlPXaKHMWH54r4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWsiE05lXpcYEKGVezsKZEWX1mbmXZIiXcmTbfBhxS0=;
 b=jBIVoTQ3hUlsXr4wA/N4FiCYSbeMS5Y4Mls0yngYsX4Wy4GwL9efKpg7/wiFp8S4JlfcbuD1mdrOs1kCfIGJ6DVk7kJ2McWhBt4XS6YS1uSKW87kL+zNPEogFP122GMWPKvZNuyQq8LPOgKRClV9eRU/vwCT8AtPu7nVVWqHxpr/dUljgu+TE5c5rQSSXiYpCyVMU+ba0thCnt8+oJFT3QSuK/mev107kBI74kPf/OYJBBiPeT11mzM8JSccOylj2q9iAj3jVKVCAnmoZ/Jz8s4ZmZsEDV2ePucDXsOKNRdo6xvOrXoXmQl/B6pfkopUxpIQ5j90XGFdd2fbns0O8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWsiE05lXpcYEKGVezsKZEWX1mbmXZIiXcmTbfBhxS0=;
 b=hzzO0aEWuUe+KSS5N3GcGJ8+aNHGfR+ZWOQwIo1wmvP3KCmDSKAuLQ8nGh9S3/gciEa9kAN7HdRZL7inM0gbFxkzDtXktoaAg17cxrf5rCrNgxiFExfRMwawljfxQ61ZyyJ7acJPVEEg84LQhVyoM+nRu49pFsv/l9OW7AULgoo=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3868.namprd15.prod.outlook.com (2603:10b6:303:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 06:11:51 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 06:11:51 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
 <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp>
 <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
 <20200416170414.ds3hcb3bgfetjt4v@ast-mbp>
 <CAEf4BzY0a_Rzt8vtLLSz3+xAhx0CWhetxcUNdyK7ZygMms7srA@mail.gmail.com>
 <20200416231829.o4yngurm5nzrakoj@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzb7tr3GCxN_WtE2RVD7j3NA7w_pJQ25Sz87tVDL1j4e1g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dae57f57-22df-9bca-47a6-bdfb557ac9e2@fb.com>
Date:   Sat, 18 Apr 2020 23:11:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzb7tr3GCxN_WtE2RVD7j3NA7w_pJQ25Sz87tVDL1j4e1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:301:2::18) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wongal-imac.dhcp.thefacebook.com (2620:10d:c090:400::5:7ab3) by MWHPR12CA0032.namprd12.prod.outlook.com (2603:10b6:301:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Sun, 19 Apr 2020 06:11:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:7ab3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36bfc1ea-1875-48b1-72a7-08d7e4288cc1
X-MS-TrafficTypeDiagnostic: MW3PR15MB3868:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38683C9C862D3D0566E7EB03D3D70@MW3PR15MB3868.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(396003)(136003)(39860400002)(346002)(376002)(53546011)(6506007)(110136005)(52116002)(54906003)(31686004)(316002)(6486002)(6512007)(36756003)(66556008)(66476007)(66946007)(30864003)(5660300002)(86362001)(8936002)(2906002)(81156014)(8676002)(2616005)(4326008)(478600001)(186003)(16526019)(31696002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K4FbtP1YoZtt6J/l9NoIxmnATPhJ8vPjMwlyP5xAViY91Y44MzJVRktC6Nbd5f/SW0bTpoxrzCmh3lqnyZkv0Bm3sOAgwrUyzls/oQagH0aoUXaVvGr1SLOvWnpXzMg8z/EZYThEKIX1kgQZl4Nf+addpsrWFbAbK5LsQshwL7tjnI9VHmCObmg0Isnm1JtVzzJ69hlQZ4oSiKosYXPfOxab7M7YLG8yd9RfDiWK5Kmw6eoYZ3VVJsERbyQUKjVl7p4xfS6GSxE814kDyy4RgokdWfFO//fT9WNBsg7p8TrOxkZrDynbzJ5qNhD5AnY6zcRpoNvyif2zmlRmH4fPa0K9qpZkkTxgI1hVS3xR0H3Cm9vfjtZUv05z6cLGiqhXHWhC0oK2Bn4MhLZYGUf9oBKZvDp5YJqJCgQxa7CBRdiuy/ZaaSv1IqyNiiSnu3YR
X-MS-Exchange-AntiSpam-MessageData: 8wznaVe/E7PllnCTvOdQqCGwGyUjN32qgzaS2uTJ3FodHM/p2yoaWIQfVmCb0DolE5eOP+q5QcG1bbJ4zHMAL7n0SUCqqUwcXSr56oVNSNr1zOBSlT7JnFCpwPnb6HUrFecuNkCrT1996HZ2ClCoyXTapomj80blAw1irthFehepL1YkQ8EJ83d6FNuLNZ5I79SBi7V7Tn4gEExO0ny9VItIkXU8gy2ted+rx0r33SvMKa53qxjx0lgWn0rQvJg+LQx2L3WlybSm+Wu91r2M0cMEsi+5hxfungCqRhoyUfCDa12pRmNho8zJ8knf6SFdxpzFD7QHR+dJH5eEcLbEDodLBU5n7o56zIdn/maCeKylrj59MqBkBA/CuZgNzB5N/j6IU5LTMpQbUuP9PA2crJAb+NzcaP9Io5NtFv6jLZ4obW7B+a2GW5CyD5DQhnglJLVhqUgG7WofXwXPWHq2ubFmKTMQtooBfKSobtNr1G5KYJA+bqO1GwGB9wYdov3ZUr6/t+Fhn4n9tS0LWmlf+DefSKZufBo8SPydpnqhwzgeeaLMLscHm5C4gCEH/SwOg2a3GBEpQoJvPuOk7ZQceVogseH8t2bCHduFeSiiRuoTZcHWX67ou5leZtUUK3A3NrD1HKXBDrdDb8Z3rQX70uIkla3hzDGm58zXYf43+nPbiAUs9BhbV9NtE1dhd4tstoTdUfmCEYfSdr/p3O3szl7jzrGHgYlIzYpBZjR8Ks75JhuVQURT3/H0ydxYPEiYq7SqZCaLcVNLooE9zORDFy5qERXMGe4FbEkFtBU2vwngxrMQ4CS5N8fHYtI3iw+/KjqXiV/qE1rMe6hQ/T1l0w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bfc1ea-1875-48b1-72a7-08d7e4288cc1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 06:11:50.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ciJD99jlBx8USZWDVEI7ipGKmoJjXBhm4Cj0KcWp8Ddzhps0xdmDKJraJNwylf5z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3868
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_10:2020-04-17,2020-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004190055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/20 10:11 PM, Andrii Nakryiko wrote:
> On Thu, Apr 16, 2020 at 4:18 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Thu, Apr 16, 2020 at 12:35:07PM -0700, Andrii Nakryiko wrote:
>>>>
>>>> I slept on it and still fundamentally disagree that seq_file + bpf_prog
>>>> is a derivative of link. Or in OoO terms it's not a child class of bpf_link.
>>>> seq_file is its own class that should contain bpf_link as one of its
>>>> members, but it shouldn't be derived from 'class bpf_link'.
>>>
>>> Referring to inheritance here doesn't seem necessary or helpful, I'd
>>> rather not confuse and complicate all this further.
>>>
>>> bpfdump provider/target + bpf_prog = bpf_link. bpf_link is "a factory"
>>> of seq_files. That's it, no inheritance.
>>
>> named seq_file in bpfdumpfs does indeed look like "factory" pattern.
>> And yes, there is no inheritance between named seq_file and given seq_file after open().
>>
>>>> In that sense Yonghong proposed api (raw_tp_open to create anon seq_file+prog
>>>> and obj_pin to create a template of named seq_file+prog) are the best fit.
>>>> Implementation wise his 'struct extra_priv_data' needs to include
>>>> 'struct bpf_link' instead of 'struct bpf_prog *prog;' directly.
>>>>
>>>> So evertime 'cat' opens named seq_file there is bpf_link registered in IDR.
>>>> Anon seq_file should have another bpf_link as well.
>>>
>>> So that's where I disagree and don't see the point of having all those
>>> short-lived bpf_links. cat opening seq_file doesn't create a bpf_link,
>>> it creates a seq_file. If we want to associate some ID with it, it's
>>> fine, but it's not a bpf_link ID (in my opinion, of course).
>>
>> I thought we're on the same page with the definition of bpf_link ;)
>> Let's recap. To make it easier I'll keep using object oriented analogy
>> since I think it's the most appropriate to internalize all the concepts.
>> - first what is file descriptor? It's nothing but std::shared_ptr<> to some kernel object.
> 
> I agree overall, but if I may be 100% pedantic, FD and kernel objects
> topology can be quite a bit more complicated:
> 
> FD ---> struct file --(private_data)----> kernel object
>       /                                 /
> FD --                                 /
>                                       /
> FD ---> struct file --(private_data)/
> 
> I'll refer to this a bit further down.
> 
>> - then there is a key class == struct bpf_link
>> - for raw tracepoints raw_tp_open() returns an FD to child class of bpf_link
>>    which is 'struct bpf_raw_tp_link'.
>>    In other words it returns std::shared_ptr<struct bpf_raw_tp_link>.
>> - for fentry/fexit/freplace/lsm raw_tp_open() returns an FD to a different child
>>    class of bpf_link which is "struct bpf_tracing_link".
>>    This is std::share_ptr<struct bpf_trace_link>.
>> - for cgroup-bpf progs bpf_link_create() returns an FD to child class of bpf_link
>>    which is 'struct bpf_cgroup_link'.
>>    This is std::share_ptr<struct bpf_cgroup_link>.
>>
>> In all those cases three different shared pointers are seen as file descriptors
>> from the process pov but they point to different children of bpf_link base class.
>> link_update() is a method of base class bpf_link and it has to work for
>> all children classes.
>> Similarly your future get_obj_info_by_fd() from any of these three shared pointers
>> will return information specific to that child class.
>> In all those cases one link attaches one program to one kernel object.
>>
> 
> Thank you for a nice recap! :)
> 
>> Now back to bpfdumpfs.
>> In the latest Yonghong's patches raw_tp_open() returns an FD that is a pointer
>> to seq_file. This is existing kernel base class. It has its own seq_operations
>> virtual methods that are defined for bpfdumpfs_seq_file which is a child class
>> of seq_file that keeps start/stop/next methods as-is and overrides show()
>> method to be able to call bpf prog for every iteratable kernel object.
>>
>> What you're proposing is to make bpfdump_seq_file class to be a child of two
>> base classes (seq_file and bpf_link) whereas I'm saying that it should be
>> a child of seq_file only, since bpf_link methods do not apply to it.
>> Like there is no sensible behavior for link_update() on such dual parent object.
>>
>> In my proposal bpfdump_seq_file class keeps cat-ability and all methods of seq_file
>> and no extra methods from bpf_link that don't belong in seq_file.
>> But I'm arguing that bpfdump_seq_file class should have a member bpf_link
>> instead of simply holding bpf_prog via refcnt.
>> Let's call this child class of bpf_link the bpf_seq_file_link class. Having
>> bpf_seq_file_link as member would mean that such link is discoverable via IDR,
>> the user process can get an FD to it and can do get_obj_info_by_fd().
>> The information returned for such link will be a pair (bpfdump_prog, bpfdump_seq_file).
>> Meaning that at any given time 'bpftool link show' will show where every bpf
>> prog in the system is attached to.
>> Say named bpfdump_seq_file exists in /sys/kernel/bpfdump/tasks/foo.
>> No one is doing a 'cat' on it yet.
>> "bpftool link show" will show one link which is a pair (bpfdump_prog, "tasks/foo").
>> Now two humans are doing 'cat' of that file.
>> The bpfdump_prog refcnt is now 3 and there are two additional seq_files created
>> by the kernel when user said open("/sys/kernel/bpfdump/tasks/foo").
>> If these two humans are slow somebody could have done "rm /sys/kernel/bpfdump/tasks/foo"
>> and that bpfdump_seq_file and it's member bpf_seq_file_link would be gone,
>> but two other bpdump_seq_file-s are still active and they are different.
>> "bpftool link show" should be showing two pairs (bpfdump_prog, seq_file_A) and
>> (bpfdump_prog, seq_file_B).
>> The users could have been in different pid namespaces. What seq_file_A is
>> iterating could be completely different from seq_file_B, but I think it's
>> useful for admin to know where all bpf progs in the system are attached and
>> what kind of things are triggering them.
> 
> How exactly bpf_link is implemented for bpfdumper is not all that
> important to me. It can be a separate struct, a field, a pointer to a
> separate struct -- not that different.
> 
> I didn't mean for this thread to be just another endless discussion,
> so I'll try to wrap it up in this email. I really like bpfdumper idea
> and usability overall. Getting call for end of iteration is a big deal
> and I'm glad I got at least that :)
> 
> But let me try to just point out few things you proposed above that I
> disagree on the high-level with, as well as provide few supporting
> point to the scheme I proposed previously. If all that is not
> convincing, I rest my case and I won't object to bpfdumper to go in in
> any form, as long as I can use it anonymously with extra call at the
> end to do post-aggregation.
> 
> So, first. I do not see a point of treating each instance of seq_file
> as if it was an new bpf_link:
> 1. It's a bit like saying that each inherited cgroup bpf program in
> effective_prog_array should has a new bpf_link created. It's not how
> it's done for cgroups and I think for a good reason.
> 2. Further, each seq_file, when created from "seq_file template",
> should take a refcnt on bpf_prog, not bpf_link. Because seq_file
> expects bpf_prog itself to be exactly the same throughout entire
> iteration process. Bpf_link, on the other hand, allows to do in-place
> update of bpf_program, which would ruin seq_file iteration,
> potentially. I know we can disable that, but it just feels like
> arbitrary restrictions.
> 3. Suppose each seq_file is/has bpf_link and one can iterate over each
> active seq_file (what I've been calling a session, but whatever). What
> kind of info user-facing info you can get from get_obj_info? prog_id,
> prog_tag, provider ID/name (i.e., /sys/fs/bpfdump/task). Is that
> useful? Yes! Is that enough to do anything actionable? No! Immediately
> you'd need to know PIDs of all processes that have FD open to that
> seq_file (and see diagram above, there could be many processes with
> many FDs for the same seq_file). bpf_link doesn't know all PIDs. So
> it's this generic "who has this file opened" problem all over again,
> which I'm already pretty tired to talk about :) Except now we have at
> least 3 ways to answer such questions: iterate procfs+fdinfo, drgn
> scripts, now also bpfdump program for task/file provider.
> 
> So even if you can enumerate active bpfdump seq_files in the system,
> you still need extra info and iterate over task/file items to be able
> to do anything about that. Which is one of the reasons I think
> auto-creating bpf_links for each seq_file is useless and will just
> pollute the view of the system (from bpf_link standpoint).
> 
> Now, second. Getting back what I proposed with 3-4 step process (load
> --> attach (create_link) --> (pin in bpfdumpds + open() |
> BPF_NEW_DUMP_SESSION)). I realize now that attach might seem
> superficial here, because it doesn't provide any extra information (FD
> of provider was specified at prog load time). It does feel a bit
> weird, but:
> 
> 1. It's not that weird, because fentry/fexit/freplace and tp_btf also
> don't provide anything extra: all the info was specified at load time.
> 2. This attach step is a good point to provide some sort of
> "parametrization" to narrow down behavior of providers. I'll give two
> examples that I think are going to be very useful and we'll eventually
> add support for them in one way or another.
> 
> Example A. task/file provider. Instead of iterating over all tasks,
> the simplest extension would be to specify **one** specific task PID
> to iterate all files of. Attach time would be the place to specify
> this PID. We don't need to know PID at load time, because that doesn't
> change anything about BPF program validation and verified just doesn't
> need to know. So now, once attached, bpf_link is created that can be
> pinned in bpfdumpfs or BPF_NEW_DUMP_SESSION can be used to create
> potentially many seq_files (e.g., poll every second) to see all open
> files from a specific task. We can keep generalizing to, say, having
> all tasks in a given cgroup. All that can be implemented by filtering
> out inside BPF program, of course, but having narrower scope from the
> beginning could save tons of time and resources.
> 
> Example B. Iterating BPF map items. We already have bpf_map provider,
> next could be bpf_map/items, which would call BPF program for each
> key/value pair, something like:
> 
> int BPF_PROG(for_each_map_kv, struct seq_file *seq, struct bpf_map *map,
>               void *key, size_t key_size, void *value, size_t value_size)
> {
>      ...
> }
> 
> Now, once you have that, a natural next desire is to say "only dump
> items of map with ID 123", instead of iterating over all BPF maps in
> the system. That map ID could be specified at attachment time, when
> bpf_link with these parameters are going to be created. Again, at load
> time BPF verifier doesn't need to know specific BPF map we are going
> to iterate, if we stick to generic key/value blobs semantics.

Thanks for bringing out this use case. I have not thought this carefully 
before, just thinking bpf filtering even for second-level data structure 
should be enough for most cases. But I do agree in certain cases, this 
is not good e.g., every map has millions of elements and you only want 
to scan through a particular map id.

But I think fixed parameterization at kernel interface might not be good 
enough. For example,
     - we want to filter only for files for this pid
       pid is passed to the kernel
     - we want to filter only for files for tasks in a particular cgroup
       cgroup id passed to the kernel and target need to check
       whether a particular task belongs to this cgroup
     - this is a hypothetical case.
       suppose you want to traverse the nh_list for a certain route
       with src1 and dst1
       src1 and dst1 need to be passed to the kernel and target.

Maybe a bpf based filter is a good choice here.

For a dumper program prog3 at foo1/foo2/foo3,
two filter programs can exist:
    prog1: target foo1
    prog2: target foo1/foo2
prog1/prog2 returns 1 means skip that object and 0 means not skipping

For dump prog3, return value 1 means stopping the dump and 0 means not
    stopping.

Note here, I did not put any further restriction to prog1/prog2, they
can use bpf_seq_printf() or any other tracing prog helpers.

So when to create a dumper (anonymous or file), multiple bpf programs
*can* be present:
    - all programs must be in the same hierarchy
      foo1/, foo1/foo3 are good
      foo1/, bar1/ will be rejected
    - each hierarchy can only have 0 or 1 program
    - the deepest hierarchy program is the one to do dumper,
      all early hierarchy programs, if present, are filter programs.
      if the filter program does not exist for a particular hierarchy,
      assumes a program always returns not skipping

I have not thought about kernel API yet. Not 100% LINK_CREATE is
the right choice here or not.

Any thoughts?

> 
> So with such possibility considered, I hope having explicit
> LINK_CREATE step starts making much more sense. This, plus not having
> to distinguish between named and anonymous dumpers (just like we don't
> distinguish pinned, i.e. "named", bpf_link from anonymous one), makes
> me still believe that this is a better approach.
> 
> But alas, my goal here is to bring different perspectives, not to
> obstruct or delay progress. So I'm going to spend some more time
> reviewing v2 and will provide feedback on relevant patches, but if my
> arguments were not convincing, I'm fine with that. I managed to
> convince you guys that "anonymous" bpfdumper without bpfdumpfs pinning
> and post-aggregation callback are a good thing and I'm happy about
> that already. Can't get 100% of what I want, right? :)
> 
