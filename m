Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEB2184DE2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCMRri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:47:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbgCMRrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:47:37 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DHj36p026514;
        Fri, 13 Mar 2020 10:47:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=f5B87lcT+bZfbU14+LI+RI6QBrNf+wHtDhljiJx9Q+0=;
 b=V4lAvpqSnCPrvx4+NCkVNMr1O1W8DQcoNflbD52oTuqKrMrLPCLIZAu22bRBIlsMePe0
 jVqIEeDwkCrtm4jd9pm1KCK8BhvJnmDp9LNMYbvj2x34ab98YeTnuzAdrZEaKtlO9FDM
 WYBuaTAtGKUsedru4RUgSU9kofY8ZNsuTnU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7t5dpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 10:47:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVK6529fHEmnlv0Ad44GIIbdImJ5kYMHuRRdxUGHujSm3NghNNJ9BS8QwodLWihrNIMqLNE/W5eHPLoLdr9ph13mtc4PHLlW8luHAF+Lwd0mdb/MdPl+wqFXZXyHMIvKVqBS8sEy4yF3IkTAnd6SQ6Qc3BFC5n8AhUq+DLYc0/AYGO6A9Vpjw4OZZPcOCwa2nbsxfqVWj8XYZRQOhTShlEQHXn3QwuS5wCEYPt3K809LHoGnbNxMj56YfkLf5DFWahrsT47d1QDq5ThBWGtmB8EXV9GXot9Ho4b/v1lOgXFlnHF0Fxs+s6uMtOvNlm/krYgjzCGVLB6o06PFC6AIHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5B87lcT+bZfbU14+LI+RI6QBrNf+wHtDhljiJx9Q+0=;
 b=WeP+Q5BKkCEGCkQEwibsPvQ7UHFdPa3HCPM8g4qY1JhSZbRr8f+tWQIEg7syJ/+IfqPE/cQ305zjWkYqaxgRD+LftgpUqktXDtjD3KUeUG1E1ba44UK2hOPh7HgjXaLzopc3Ieo1LPeMncNdvPAph/p3RPawajFEqwBLcOA1OPlXtydx5C3VywQufDs1A0cmoBfLtjhcP0mt/HeMuJrIdzH+P6+IZDDHf3glSV8i/2H4XEUf6HqscGPXjCMWTkgpI908w9/O9jdEFPNbAfTG8TQph3Li09IvjoGbhTVEnB/vfa14AgjQ2TRKlqTuRMKm5QLpnQB7VRyyDVbKyfGAVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5B87lcT+bZfbU14+LI+RI6QBrNf+wHtDhljiJx9Q+0=;
 b=ii+rcsQkQeue3PH6X2c41XzngtMZQe9S+JBRoxKSkjLOTbMDS5j35SGjZbv7F0NHubwYmTQZjn8HdzpKF9d5CAHEO4zFRx5Lsyc8K/AVVoLPSKcRYD+dAojtxb+QMcdh4huG8WRo+g5zCcI962ka6fGZ88+bvWpFLQRTiKtQZLk=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2664.namprd15.prod.outlook.com (2603:10b6:a03:15a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 13 Mar
 2020 17:47:23 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 17:47:23 +0000
Date:   Fri, 13 Mar 2020 10:47:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/4] CO-RE candidate matching fix and tracing
 test
Message-ID: <20200313174719.3rgo75kkewunndnl@kafai-mbp>
References: <20200313172336.1879637-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313172336.1879637-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:300:115::32) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR11CA0046.namprd11.prod.outlook.com (2603:10b6:300:115::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Fri, 13 Mar 2020 17:47:21 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e95342ba-eabd-4c10-3e75-08d7c776959c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2664699C78CD7F31309F451ED5FA0@BYAPR15MB2664.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(81166006)(81156014)(478600001)(6496006)(66556008)(66476007)(55016002)(9686003)(4744005)(5660300002)(6862004)(2906002)(66946007)(6636002)(4326008)(16526019)(52116002)(186003)(33716001)(8676002)(1076003)(86362001)(316002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2664;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: or9E/7zDQmtiHbsVucPVa+rDncBOjwXsb9sr110SchdrZNwBuGQF9JsjAwwUyxUivZQTxrXLV676bZbWMN1711E8fboE2M9G0MkW3ohSh1DAyL51DP/Vc3+b+k6u7cat/PhT8VeBrgb3rui0WuZyZ5jAQC/XDOQB0Z9eiyo1NXnslxGyBhy6g69SQW0B3CK6alakpAyp52me+lPGcp57s+/OJyMnjD2UCxvCvDqzSjJTl/EL4RhRDXioRvJwr9/hlCS++w9kBX+6GJ9ezeVqhD+S9BWnHxryARCC/Gt5+DOpowZHUMCzfZ8gfw340ydqOIIK3XxUsT8odvd7zXkFDIaQ+oj6bb9FOywNIJlmcQ60MekO5Qkg2zq/N2Vvbe1kXWREO/2oJcEo1e559HTVdebNB1W3oog/XfSyGbQCUZTOslqm+32wGgvgo91Wva4I
X-MS-Exchange-AntiSpam-MessageData: 0vxtMny0vj0NeiGyKzfmEHGP0VW/3ke4UtW4J0Y1EVjrXGELZwRt+N9QJVbmZ8KbqzgmaOyaJWjy283Clm1bUbpLox1Zf4MMcKefaZFSYrszeTj3pYtZ5ZSbuJ6+F9XsbIBdr2FV/e3zLwT0CVfEm1J6od5UCF4U/o5vnPEVnRHd0JT5oVxaPjAMwIR7grQk
X-MS-Exchange-CrossTenant-Network-Message-Id: e95342ba-eabd-4c10-3e75-08d7c776959c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 17:47:23.2764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBWoAiNGcosOeQJjR+UyjcC9YYnUR1hfCtHfozgjRqfqrI2jIsGwKDWOP9WqgAP4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2664
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130087
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 10:23:32AM -0700, Andrii Nakryiko wrote:
> This patch set fixes bug in CO-RE relocation candidate finding logic, which
> currently allows matching against forward declarations, functions, and other
> named types, even though it makes no sense to even attempt. As part of
> verifying the fix, add test using vmlinux.h with preserve_access_index
> attribute and utilizing struct pt_regs heavily to trace nanosleep syscall
> using 5 different types of tracing BPF programs.
> 
> This test also demonstrated problems using struct pt_regs in syscall
> tracepoints and required a new set of macro, which were added in patch #3 into
> bpf_tracing.h.
> 
> Patch #1 fixes annoying issue with selftest failure messages being out of
> sync.
> 
> v1->v2:
> - drop unused handle__probed() function (Martin).
Acked-by: Martin KaFai Lau <kafai@fb.com>
