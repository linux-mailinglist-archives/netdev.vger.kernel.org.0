Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216151D7017
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 07:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgERFGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 01:06:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63726 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgERFGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 01:06:15 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04I54iaJ000874;
        Sun, 17 May 2020 22:06:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : subject : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=K6zbOT8Wn4rlhT9ZaWYw+cP5U0h1xgr1GGqtUk2UnHA=;
 b=p6f7n9p0lvf0Gw2cHW5fqRKWUUkmSs2SR+Yy/EwOt8OoNTxP0PT/iaw1d67yBZq1HT7U
 OsqzubRIQIpuKrEtx4F63bbHxGTuMnWa9ZDmow38qPEoGH+E86sRLWJrZqApnoo/mE7s
 LaBX4uPsOZjEacst78CUIMA+R3gcLpW5TXw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 312bp0y680-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 17 May 2020 22:06:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 17 May 2020 22:05:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQ2dfeDhKNb7URAKEfEh9ryIgDSRkqPeNmJKnxj+qUdlhxj3gtbCCbF/yGgYHShEEpG2jbcJDHAb2EzD7mKrlaZfm/A7VxNZ+dBZrxFBtZkqxBrV9C/dyXZEe5C9rWTeLJ2xToFO2ZNddgNLmooVAUeokSxJm12Qf9s22SWTWeyW1g0IFHMM30XKW9T8Vy+GTDVsPaq4u5JlgAxhmRntH/Ut/jUgtSaIprrYViyzL18rf0e2VcQO51osXyCRM96N6Y58vHZ3yDquSwZsKSYOgDxWgqdDQ6HrhYn8rCeDueMSZ6Fj2jKsA9CLqhqFYVryRhy/ucownLwm7hHI/4xyew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6zbOT8Wn4rlhT9ZaWYw+cP5U0h1xgr1GGqtUk2UnHA=;
 b=XfuuZolDLL37Ei0UFFRwXYLg8V4Rd40cv+UEBXp7YfvWUcQB/m1Mh5O69+tPEnGDCVbG3iVeEDDrHWJaW3nZMJWxDTaLIMoYZsXjuOxog3+ZnNlt1TNq9f8cJnzAXXYXd64oDVrVZf5j9CMm/mdcluqTWxaC7AQYZ4DKTX2qGAGZY+ZihQPbnD94x6hOJVkRTAITF6juYwm7luDHtQY1Rw+JwECYEe6MqbVDvwvnOi90ogi/jtNvI32iugMQke5zlMeIrUdmQcPFS5RfVum92jxvOF5aoS/RQAoAukYBEmhe3tm/GHEaUlMgqiXKgEDqKPEelCsALY9wNkP/Bhz4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6zbOT8Wn4rlhT9ZaWYw+cP5U0h1xgr1GGqtUk2UnHA=;
 b=I8FfaVL/XwcMfpRCxIVy20sZsfwy5RPqS3+mc/jiwOMaw4e6Vl7XBpcB2yHGs6Q4g9E3754IIRg0d7WhKNgF+KUwbJrC2jurm9IdyhH9LeVsRP3zEgFuMJ57QTCAuQZym3u3S0nJP+Ns3uOZIiIWx+qhcNz9Oh0V+yhlbV9gtdk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2199.namprd15.prod.outlook.com (2603:10b6:a02:83::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Mon, 18 May
 2020 05:05:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 05:05:53 +0000
From:   Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 0/5] samples: bpf: refactor kprobe tracing
 progs with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200516040608.1377876-1-danieltimlee@gmail.com>
Message-ID: <13f1ba03-b3d7-891f-157b-09940eeb5279@fb.com>
Date:   Sun, 17 May 2020 22:05:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200516040608.1377876-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0101.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::42) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:39c9) by BYAPR07CA0101.namprd07.prod.outlook.com (2603:10b6:a03:12b::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Mon, 18 May 2020 05:05:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:39c9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a312e84-65d6-4ab6-f8a2-08d7fae92428
X-MS-TrafficTypeDiagnostic: BYAPR15MB2199:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2199BCBB067003F78522BAACD3B80@BYAPR15MB2199.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQ+p4nHcYbwU0dr0948ExoYJhg5+QNE/d+YpUcmY/Gd1pv1xsri+HXtUMPcHIK/0FMOTSXnk9gCjDWzHqDHxsnUDqCEOxE0oNoy/ho1DUCAY/OFWIlFBKPv9uPYJIes4KREVB4KK4MQLuTrbVFwoILmkP5Q/WXpmJEyIHjHzmVneJGhIrsl+1UWV1E20sTSGka2puEGueiuSmQ+WuDQZFciBrILzXOcTR0lfDAIRHktBAseQJ5Dc1tWABK3PqyFXr50viFwWBOALUVcPLQBVOGevu+TbEdN356STpp71w5SZKQRPB/USIUX0KE5KWBXUU+COunor18D/ov07mATuTUcJbFmvKfvN3Ia7X5L1swkka1XLQIfcp4DFLwz6Obt0L5xec1bwoPOpwy1BiQgHBSCy/u0hYFEMw8BM/twG/1IOVnJeVCrsvVBWZTlO7OM9J294rQ/lcWai1YnxKH0vaCX2zt/amFcQnxnNAd+rB+DXklOrv7O0IQBuIGcFDh1V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(66556008)(66476007)(66946007)(6512007)(31696002)(86362001)(4326008)(6486002)(478600001)(6666004)(16526019)(2616005)(5660300002)(8936002)(110136005)(54906003)(186003)(31686004)(36756003)(53546011)(8676002)(52116002)(316002)(6506007)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IlvzqH7whmsBjDpFWVI84Oe2lIeNK4X+s63H8pbjFE/c/BmllS7SAsWrK0ZASavGd7/0nelWf/dlz5WLjgIP/sLsXRoDzFutZ36IuE6TireYG/IDEJw56YxfLAkU72lmotD783GU/bTaRmvfIoumwZOQ/US0UmYywZoS2JAU229g2zNZW8i8QCkfEFAHpAp3/vlzt+ll0mJ4Z1JL/UGDJApQhtoUDBUCNLblcr9usaGhol19yDukOE56/64SZoQtC+Qqx4CIs6o42PaE3C1cPVQl/4I7DAPrCKU5tlWU8cAidlGH/MghwxC8q+LdxWGYrsymmJQScw0xZIVp/MuBJvNa5ckdQueYv5ITpQdN/RtVlmfDZ3ivvpXWSdg4nuvBABqmB4YmIPLSV6dvP0Fxa0wnsaWb3LyjRGWky60BgDW+7EuybzQWIlms6zFBGl93ajFPYAEmbX6pckCjFIMz0jM47+DNGtkzqVcKonnC8ZjxLI3IimqDWunDUsCQx/UO14oRNNJwrlnAqv50VlXr0Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a312e84-65d6-4ab6-f8a2-08d7fae92428
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 05:05:53.8442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loWsMIQRjTWaFk7/aMjFYhvUyAGmTczqfgFoLLhUPSOVjUUonwmnDqWEmpxGTdoa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_01:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 cotscore=-2147483648
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 spamscore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/20 9:06 PM, Daniel T. Lee wrote:
> Currently, the kprobe BPF program attachment method for bpf_load is
> pretty outdated. The implementation of bpf_load "directly" controls and
> manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
> using using the libbpf automatically manages the kprobe event.
> (under bpf_link interface)
> 
> This patchset refactors kprobe tracing programs with using libbpf API
> for loading bpf program instead of previous bpf_load implementation.
> 
> ---
> Changes in V2:
>   - refactor pointer error check with libbpf_get_error
>   - on bpf object open failure, return instead jump to cleanup
>   - add macro for adding architecture prefix to system calls (sys_*)
> 
> Daniel T. Lee (5):
>    samples: bpf: refactor pointer error check with libbpf
>    samples: bpf: refactor kprobe tracing user progs with libbpf
>    samples: bpf: refactor tail call user progs with libbpf
>    samples: bpf: add tracex7 test file to .gitignore
>    samples: bpf: refactor kprobe, tail call kern progs map definition
> 
>   samples/bpf/.gitignore              |  1 +
>   samples/bpf/Makefile                | 16 +++---- >   samples/bpf/sampleip_kern.c         | 12 +++---
>   samples/bpf/sampleip_user.c         |  7 +--
>   samples/bpf/sockex3_kern.c          | 36 ++++++++--------
>   samples/bpf/sockex3_user.c          | 64 +++++++++++++++++++---------
>   samples/bpf/trace_common.h          | 13 ++++++
>   samples/bpf/trace_event_kern.c      | 24 +++++------
>   samples/bpf/trace_event_user.c      |  9 ++--
>   samples/bpf/tracex1_user.c          | 37 +++++++++++++---
>   samples/bpf/tracex2_kern.c          | 27 ++++++------
>   samples/bpf/tracex2_user.c          | 51 ++++++++++++++++++----
>   samples/bpf/tracex3_kern.c          | 24 +++++------
>   samples/bpf/tracex3_user.c          | 61 +++++++++++++++++++-------
>   samples/bpf/tracex4_kern.c          | 12 +++---
>   samples/bpf/tracex4_user.c          | 51 +++++++++++++++++-----
>   samples/bpf/tracex5_kern.c          | 14 +++---
>   samples/bpf/tracex5_user.c          | 66 +++++++++++++++++++++++++----
>   samples/bpf/tracex6_kern.c          | 38 +++++++++--------
>   samples/bpf/tracex6_user.c          | 49 ++++++++++++++++++---
>   samples/bpf/tracex7_user.c          | 39 +++++++++++++----
>   samples/bpf/xdp_redirect_cpu_user.c |  5 +--
>   22 files changed, 455 insertions(+), 201 deletions(-)
>   create mode 100644 samples/bpf/trace_common.h

Thanks! LGTM. Ack for the whole series:
Acked-by: Yonghong Song <yhs@fb.com>
