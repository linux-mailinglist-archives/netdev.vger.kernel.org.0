Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B219012F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCWWrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:47:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgCWWrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:47:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02NMknSQ010465;
        Mon, 23 Mar 2020 15:47:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cmmnAhag9s/DBDgpcbnGp3bd8u/UsUmP0s47LrwWdlw=;
 b=nMlIfZ3xk7kzwft5bBi88AQhAVc84q+52jzZPT2MzcLnF2huTYo+NAMtOIO76kmeK00/
 2HW7iokUWRyvUDcgkb5L5/pu6p9VFFcJSfb71Cq1H1kObMPdTYBKgK8Uje775j300QFD
 rwB6fviCqxnqBWDDlEnp4nSMdp7cMPTER/Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yx2xnqmkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Mar 2020 15:47:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 23 Mar 2020 15:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjmEEguYfg4QelT1gh2nht4zvENIx1xMZzR8YLpspEDsyE01n4181GOaWURz/+ks42ny6mkefz+KzUmED7v2fQYEXDYWNQY9IVy0ai6Ge0hRABYQliEkyRFP1t1JMYqRkExvaQWNwxATp8bW5eUlUUoRniNuX2gdn18ZvxtUb8g3nz7/IpM211cNnvmewbO3LicMByVtQTdTAhevc7wf/dvb3BYR97kvrl7y6YcvmRzmzVlZ5xuhcdiWs5Z0Njc1ZikbFLRYfS19GATx5Vi53bnkSHgbFIhUDxv9Ke5/f6JD8BBisfPvx/iCMzCbRUxSz6+u9zODYOpfUhqchdmm6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmmnAhag9s/DBDgpcbnGp3bd8u/UsUmP0s47LrwWdlw=;
 b=NTQgd5v9CCebgTKzOipa8qftkDGWT+UDto2QuZnsNL9Fn+91y1CNQMd6lGrCSDS+olv9c2B6/3sEekJvOtnQSWchARBa+ws/8e8EmlUCUDgA6ceOZ5K9d5o1whha0RLxuJZ8YTzkyKFGi0FrkYRwHbIOeuEJMPCPBWDgeLJk+FaMl2Qc1+/qxunNp/OHZaznU47K7Zy1QK6VNreSyJ/cP3qamMk1Hjz8O8hpPTE1KFxtHF4XcxQrW6XUNZk+o4fhXECLtEMgm9sUAwJIO3le8Az7aja1UiBbKJz0EaZnrY5CTJJACqDS2RWFM4+VJtZ+VRAyTPR6p4Pnfop+4ZgkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmmnAhag9s/DBDgpcbnGp3bd8u/UsUmP0s47LrwWdlw=;
 b=H56eDKPohogmAVxMcwreXogUIiwDv0xn88qd4zr0wWddsO5lxPz0RZjuuD0tGjK4Tms6P9clOYWr05MiX91D3FpVIV+B6Gf2KXIa/ONnSSiSaJVYfrqorxCcTawrGkgTbr7le1ugpuOKs4cr/8W6I4BoQ2rM4nqCWfrUaKlq+JQ=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3914.namprd15.prod.outlook.com (2603:10b6:303:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Mon, 23 Mar
 2020 22:47:23 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 22:47:23 +0000
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
To:     Eelco Chaudron <echaudro@redhat.com>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
Date:   Mon, 23 Mar 2020 15:47:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:104:6::24) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:8ed8) by CO2PR04CA0098.namprd04.prod.outlook.com (2603:10b6:104:6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Mon, 23 Mar 2020 22:47:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:8ed8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c46bedf5-d1a2-4503-5adf-08d7cf7c26c1
X-MS-TrafficTypeDiagnostic: MW3PR15MB3914:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39145E8F29B1C8753D37B50DD3F00@MW3PR15MB3914.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(136003)(376002)(39860400002)(5660300002)(6506007)(8676002)(2906002)(6486002)(8936002)(81166006)(66476007)(52116002)(81156014)(53546011)(31686004)(316002)(6512007)(6666004)(186003)(4326008)(16526019)(478600001)(36756003)(31696002)(66946007)(66556008)(86362001)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3914;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udujm4rgLsCPYt1YxTqekF/h6rVthI/efuXwXH3TEG/VaLG03/qYN8DGF8YwdaAeTOZBO+DGESMRC6j+6N+wotMRvpwnpI+Ra1lo/peZpjvMnblVAsNQ3TY/ztx17TURRk4ZOpdCZusCnofklsDCha/w73e7NpDSBDDtDSiYd9SbU6+P5Kr2Mg2RKeldAoqfqOJKgy2k1+OV3vhSUqaagPCbXsfXJFbnYaBogoGXqD5zsuIjipMfsnfHWWBZk8feqA2uVn3Gu4eSxwJGXLzq02tfq55dhLwZ7yk2sB5EqKB0QHaWM626RPYPmp2CFzGpN6R/oiwgNY6empjaxFZ2t3PDCgo+TCKb14dVJmAbJzq/a+anL23ANsvAiL2mtiV+flQJ4VoWnJqQDR/pJ9YJ9dL7TYk9gour9OCeHazHOA0MjuiFBpTUkTYCPOeawJ/U
X-MS-Exchange-AntiSpam-MessageData: fr3ORv0T4joAcCKbiTc0XSo6NPCe3yzJY2nY7wF8MwMXkSbZbFYN4N6OakBb/kNR8CC8waYngXaqYhUPCsH9jw5zGrImL3a4wNo/6yq85IkHgKfDVsHWUhECMYSk2xsMkOmFHrlv/s4CY25oLz4LNSVOC//eZkdwTZw90QFaP9cSw+ZuhZPsNaeZ8qVGrTua
X-MS-Exchange-CrossTenant-Network-Message-Id: c46bedf5-d1a2-4503-5adf-08d7cf7c26c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 22:47:23.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HwsJpJCAR3QKy4zbBFudQHp70GLVGC9Ea6QFpFVgGyGFHRdeElSLd8BrlCMLYsJf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3914
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1011 adultscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230112
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 6:06 AM, Eelco Chaudron wrote:
> I sent out this RFC to get an idea if the approach suggested here
> would be something other people would also like to see. In addition,
> this cover letter mentions some concerns and questions that need
> answers before we can move to an acceptable implementation.
> 
> This patch adds support for tracing eBPF XDP programs that get
> executed using the __BPF_PROG_RUN syscall. This is done by switching
> from JIT (if enabled) to executing the program using the interpreter
> and record each executed instruction.

Thanks for working on this! I think this is a useful feature
to do semi single step in a safe environment. The initial input,
e.g., packet or some other kernel context, may be captured
in production error path. People can use this to easily
do some post analysis. This feature can also be used for
initial single-step debugging with better bpftool support.

> 
> For now, the execution history is printed to the kernel ring buffer
> using pr_info(), the final version should have enough data stored in a
> user-supplied buffer to reconstruct this output. This should probably
> be part of bpftool, i.e. dump a similar output, and the ability to
> store all this in an elf-like format for dumping/analyzing/replaying
> at a later stage.
> 
> This patch does not dump the XDP packet content before and after
> execution, however, this data is available to the caller of the API.

I would like to see the feature is implemented in a way to apply
to all existing test_run program types and extensible to future
program types.

There are different ways to send data back to user. User buffer
is one way, ring buffer is another way, seq_file can also be used.
Performance is not a concern here, so we can choose the one with best
usability.

> 
> The __bpf_prog_run_trace() interpreter is a copy of __bpf_prog_run()
> and we probably need a smarter way to re-use the code rather than a
> blind copy with some changes.

Yes, reusing the code is a must. Using existing interpreter framework
is the easiest for semi single step support.

> 
> Enabling the interpreter opens up the kernel for spectre variant 2,
> guess that's why the BPF_JIT_ALWAYS_ON option was introduced (commit
> 290af86629b2). Enabling it for debugging in the field does not sound
> like an option (talking to people doing kernel distributions).
> Any idea how to work around this (lfence before any call this will
> slow down, but I guess for debugging this does not matter)? I need to
> research this more as I'm no expert in this area. But I think this
> needs to be solved as I see this as a show stopper. So any input is
> welcome.

lfence for indirect call is okay here for test_run. Just need to be
careful to no introduce any performance penalty for non-test-run
prog run.

> 
> To allow bpf_call support for tracing currently the general
> interpreter is enabled. See the fixup_call_args() function for why
> this is needed. We might need to find a way to fix this (see the above
> section on spectre).
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> 
