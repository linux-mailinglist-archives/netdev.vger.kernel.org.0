Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FBC162A41
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBRQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:19:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43288 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbgBRQT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:19:28 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01IGHijZ014623;
        Tue, 18 Feb 2020 08:19:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rleMcoIwphusmxQ5DE3DZ0lYTC8HG23lw9diZbQ9Dlw=;
 b=Ak2AHltc6pgcfRhe/ZoizzjAqGrZaj19dLRShhfg4UXVFLnnBOe5MJXiSIthdfVFvHWs
 aaC/tLNov4g6AVEQg0S6NaBmd0pJvYLOFvSFm24I9PN9dX2ai44ciVRpfhOtlf6iIt1r
 85ZNVR5JkQWuU/sohXCLGlnDCyIJNU+n9yw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2y8fdyh7gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 08:19:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 08:19:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTEiKhdEOETitSo5VWLT3dQtr/U5XHOwa8b7sfTXZX55KbBl0TosOj8/Ssxxy7CTDp/EkBUhNHK7aCB3vAl5xnQJ238PaPgiQKLoP1sEyUCeqrpQamXuQu5PeOVgf6trZSG/3D7wP8niQDmLLaN9EDbI5UFhruAFld4IAeRZeB+fdZiqq+repemA5yqVHr772dmIwoBFC0zz8F5FK/izEsh+Fbkfh/E9x1yxlEpl4Vt1uDrHOf7fBN+Q738ZcQxFdOBGU5mWoqG0DV2TIFDLIOGbcQKrpcRlmJxQqfbfGD6zOhJz41S5loUAVko0+j4I0RBeHJ/wQeMjSI/+7X1L+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rleMcoIwphusmxQ5DE3DZ0lYTC8HG23lw9diZbQ9Dlw=;
 b=mUyv62ZCtEj/guF6DQeseYgf8MmNO5omFp6+dr5qPbJWexg+oDmNVN7oc7HWJ2OK5affTdw/x42pVyigcS4tHgrev/V+8hnnsoQcGDtBGid9+j2osmsY6oT4i7DNGvNmc+AfvhjnRB8iSRsdZznB/4eNeGI7dArEf1gbOeuhYRHY4XCddltVVjNa844+9RToND9PxoSHfMiWpc3hMAlqJeOiKtdDPBKbtog6spqbRHj5gnjrsM6n+zwJ9OK3hNHyWXdlqrfITZvLt17RLcBnKiGRaHvef7JnjWqLNKduJ+Et3Lkj+gfuSR8P2hVtGlG62JekFwmnVkyOU+zdYfM30w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rleMcoIwphusmxQ5DE3DZ0lYTC8HG23lw9diZbQ9Dlw=;
 b=XMLlWudqXRQfrV3f+wrY4r4Am19WNwlNedU5QOrjBuzgNf+wchnqWm2OQVPOJUiukkzbBxPgkNFNizn/iM/QfWSqEHcALPsey1G5vdxDpXFoonLn6/FJf13D3we70IdoKZuKPTiCTFWBTBf9NrD1YQkyZpNJbTftbvnex29uBDM=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3990.namprd15.prod.outlook.com (20.181.4.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Tue, 18 Feb 2020 16:19:07 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 16:19:07 +0000
Subject: Re: [PATCH bpf] libbpf: Sanitise internal map names so they are not
 rejected by the kernel
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <ast@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200217171701.215215-1-toke@redhat.com>
 <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a0923745-ee34-3eb0-7f9b-31cec99661ec@fb.com>
Date:   Tue, 18 Feb 2020 08:19:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR19CA0091.namprd19.prod.outlook.com
 (2603:10b6:320:1f::29) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::5:fd19) by MWHPR19CA0091.namprd19.prod.outlook.com (2603:10b6:320:1f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Tue, 18 Feb 2020 16:19:06 +0000
X-Originating-IP: [2620:10d:c090:500::5:fd19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78aaca0b-ff30-4be2-9497-08d7b48e4776
X-MS-TrafficTypeDiagnostic: DM6PR15MB3990:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB39904F09B8ED971069328BF4D3110@DM6PR15MB3990.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(39860400002)(376002)(199004)(189003)(6636002)(86362001)(52116002)(31686004)(478600001)(53546011)(110136005)(2906002)(6506007)(66574012)(66476007)(66556008)(186003)(4326008)(31696002)(6486002)(8936002)(6512007)(81156014)(36756003)(5660300002)(8676002)(2616005)(316002)(16526019)(81166006)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3990;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlitK5Oj9DT2xl6eS1bmfW9oMAqUuP2ZoAmkKRi9kJe9jD+a2s5WZOSAGp/STjcXjgQ4XN2IU0LWCa3pRAoWR0dq/I9a6MXhZGc6XBLPGH9Bx2/YY1PJi/kLGRQXDkOCxQOq0L28rXp5UmBBrjCYaN633Z2ZzPKPLpprcZuCSjA1HtIxR3skBHF3TEXRsijRHmQfn6OK/+Ol3cWYTZZtCYUdr5nVPQa4aQsAoXM6mOBzYXniS+gMMZj1yPrCt8BB2/K0nu5vCbwDAGwODf00xI85K6hbbV+0PIm7+4aPypKptQzjKKOQU0oSiZUp0XXNjOCy9pA/YZCf942L7aX1ESXrj9ZBQ0FhASRc6JI487nPPfiPfIsH/CSZ88KjmY8a/Fggk0Ng3H3qwbXyzZylL7hNolFg9GnZdlbtJGidy6Y3efivCm0bv6QZ3TN/qnus
X-MS-Exchange-AntiSpam-MessageData: QbkYPuVWcVuuE+DztuVB0UsGMvJEYZIK5bB9v1HFY4DMcyFyjkZBfkDodD2z7iEyNZTstyrII9Q11A/q7soI7hpX5S7KjCSFCczTrzRXKaagcZjaiuj2WMcSSW/S7VcQd6Efj8qBO2/jPqLXMzKGuAbt8ZKJ1l8KuXuaS8dL2L2wtPgzaznI7w+amb6ha0rS
X-MS-Exchange-CrossTenant-Network-Message-Id: 78aaca0b-ff30-4be2-9497-08d7b48e4776
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 16:19:07.4693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdqRTISvMGvMdzTGlj7ueYt+NzJT/9HX1D4BeL2M8bXYrxD62oB85N3fuStsfloc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3990
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_04:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/20 6:40 AM, Daniel Borkmann wrote:
> On 2/17/20 6:17 PM, Toke Høiland-Jørgensen wrote:
>> The kernel only accepts map names with alphanumeric characters, 
>> underscores
>> and periods in their name. However, the auto-generated internal map names
>> used by libbpf takes their prefix from the user-supplied BPF object name,
>> which has no such restriction. This can lead to "Invalid argument" errors
>> when trying to load a BPF program using global variables.
>>
>> Fix this by sanitising the map names, replacing any non-allowed 
>> characters
>> with underscores.
>>
>> Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata 
>> sections")
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Makes sense to me, applied, thanks! I presume you had something like '-' 
> in the
> global var leading to rejection?

The C global variable cannot have '-'. I saw a complain in bcc mailing 
list sometimes back like: if an object file is a-b.o, then we will 
generate a map name like a-b.bss for the bss ELF section data. The
map name "a-b.bss" name will be rejected by the kernel. The workaround
is to change object file name. Not sure whether this is the only
issue which may introduce non [a-zA-Z0-9_] or not. But this patch indeed 
should fix the issue I just described.
