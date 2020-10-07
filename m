Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF0285884
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgJGGMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:12:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2014 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgJGGM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:12:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09769EoO019431;
        Tue, 6 Oct 2020 23:12:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=CCuwuhPUVe0JbLq1Yb86OvZBbtDOI9wc9UKvvmM715g=;
 b=SvTw0xdNfv7jakLyTuIqKC2O8x5LhLBaVAYKKh9EB6RcOnLxzXpa2wB/CenQ7tCmRfOH
 Exs+ymUBU8JzIXuZd7qJVt5qN08zY+Vi7k5y0fMr3r4J/BZA/lTBUSgqQ2ajqg+o8puO
 NEXA9ZYrytbHTgxiFJVFt4KRW4njREqd1y4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 341408rt6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Oct 2020 23:12:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 6 Oct 2020 23:12:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ivhh4qeuB20Nl8lm+odUzmODqQ+JuFriKTpfK02Y84vSzDhETiXyN/ClHAQT+MHS8ahUig1NO9ZCpCI8Dh/Wc9uvGet4ISHm2Yof+5SzfKHa6Fo9glrOkjRZA93mbJIHH9t3UHHswJ+t3x6sWq61wtkUGS3nKUQXxm2N50GKmCDkX9ljQ/2gXi0pPm+qBaChHZiCiwqV07ZOO9gWAAiCBpAUkibWxq93iyLhXE3Uv/aDDDODQ+TJDIPbhVKQcKQy2TIPmHRacPg8OfKkspfwRBa+OMeQd1W1fyxSilNnrNcBMqkcx5/d6QfVVAMYdX41bvQz3QJXsghOFoFbHtgVMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCuwuhPUVe0JbLq1Yb86OvZBbtDOI9wc9UKvvmM715g=;
 b=R+P0iXMBHI3pqZrxONQeL5JVVsK5zdqhFU/WvJ+Qgy7E5b/XBerVZfTa6JEsPjPUwahfr3xKdfrGluby5bpT36qa7w/lHhOS7lLTLhUzUi61nlwr4U3w15RKsOZOdKvwaOB8VdcxvR18NAxjXzCtZbdrmL+DEl6E4ybkIsY09q3GHkhp/Pi1B3VUXMwW1VKd9b9cMroa3y6z0q19eW+DRUbf7AxLrZ9R9XabsVBSSTy1z1u/8S/jR6WRQJomp8EL0oLtRWjN9ijslipFREiRxXEI2UmtMJaCG0Bav24OraQiLKfJ0C8bz18B7oASf3rbvmniyY7xHNIXqgOnHiX+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCuwuhPUVe0JbLq1Yb86OvZBbtDOI9wc9UKvvmM715g=;
 b=Hp/2OncLaZatEiVSgycVWvRctX/I3RdzPz0Zja9tEEh+vExfrXqzcvERG2Vio9JNKFFNumltV8Xsw2oA3lV4r32MY0Sg1kLRmxjsQmUymYtAY0fdlYgwA4veX/AhVgcKKd0990QQT7TTklcsyuUvFyLvWRRgnaL1JTmJ8V/nsTw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2885.namprd15.prod.outlook.com (2603:10b6:a03:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 06:12:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.023; Wed, 7 Oct 2020
 06:12:08 +0000
Subject: Re: [PATCH bpf-next] kernel/bpf/verifier: fix build when NET is not
 enabled
To:     Randy Dunlap <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <linux-next@vger.kernel.org>
References: <20201007021613.13646-1-rdunlap@infradead.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fcf3f659-027e-517f-086d-deb3ad33d953@fb.com>
Date:   Tue, 6 Oct 2020 23:12:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201007021613.13646-1-rdunlap@infradead.org>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:757]
X-ClientProxiedBy: MWHPR1201CA0004.namprd12.prod.outlook.com
 (2603:10b6:301:4a::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::121a] (2620:10d:c090:400::5:757) by MWHPR1201CA0004.namprd12.prod.outlook.com (2603:10b6:301:4a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 7 Oct 2020 06:12:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6b2cadc-d086-4040-60cc-08d86a87ebf7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28859330F640B19B5009DD89D30A0@BYAPR15MB2885.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkbaaBChl8HNdTfFYKI1tOPSpuyJfeHFoehlPem+jGgyteki8MSCQ+P6Ak9/n/j4n/w2FI/pN+BfnLphlnUAhYvWTEMA/2KDteT7u6UuuKw+CQtbjh28wjsVvAMwC0ponLkIiDbM3yaF5hpcItZDg+G95uR/g+FRq6lRXnJARlOV462nx3kihTE7fcT8nrya10y0U9bbgORGKHmtNu6/8G1yelzEUkgrpXn+Gcvf2xplMPAb5uD9aHj7GkOxC7SmrUj+kEcp/m216DAZNE46BlPUPzV0DfHMJguWPC5mFA7r2/yJgLkVDchoYbcXd3a1HZwU/mESB5zePQObjobAZyu3Hti5UnXmcjJVBjk/M5uDt2Aa7TQmvfA64vCR80ZD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(16526019)(4744005)(2616005)(478600001)(66946007)(86362001)(66476007)(66556008)(31686004)(8936002)(52116002)(5660300002)(8676002)(186003)(6486002)(36756003)(316002)(4326008)(2906002)(31696002)(53546011)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fP0bY5l3/aml0LYD+GFwjBje1UOQQ4p0pfPu/YksT0JInrgy+vqU8+coPw/+dJH9XoFvS6W8MUL4zss0PT4leH5GkJCj/iPyHSsGTJl16yYYAvugV9imTSc4nekPczFeFGkPs/grl5BxmjJ0Ak0eF1Dez/7g8gopcgOc+zHXah/vV+HwtfziaiHZNi5ytXX6DmRFWpVdQhjzHS/EykWi2U1A9zM4Gan8SKP0NWIsLiW8hrqyD5O8UOvQuXroZ2Uw3UAMckx0MyB5+6jPTk6yygF4OgOOcmZ3wDFZkuwbkGiszvAW3F7HjSJqeceiji8L0sdIAIhrxKjvEGLK8Livcdo2SCyNmEhjqhLZSBEkACCHXCCd0t7Ky6EOP5yWb8glQHKDFgcb8MtDNH1pAe3JkawMQhCPcjscrFYteQ5f7BgLoFpFz90xgR+2U7imIVwjwWp0QSUtUnQoGTy08RljEEX8WGCafPkVuvc8cLxzzrSjX9baMhjG/kcx2UMLusVmD2FvkxBYOOSEadhLxtL2xtXvNQhY42fX0hMdlO01B1Knw+lFmATePvl1nKszejT5k4m0yoKnut0WolsmReH2qq+cSkwxB798kA6MqYkvknaEsYfOCj3xyJsTWfV4wNf4W8qEBJOnLX9v7ylaPXcDMnJxSUW9TLuhgrGempCdOsA=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b2cadc-d086-4040-60cc-08d86a87ebf7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 06:12:08.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amY895ViZDg8PWByYUaZNlE9Czh9ToVtW/loHRI97pA3e/ngSviU25Ynw090eK/Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_04:2020-10-06,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/6/20 7:16 PM, Randy Dunlap wrote:
> Fix build errors in kernel/bpf/verifier.c when CONFIG_NET is
> not enabled.
> 
> ../kernel/bpf/verifier.c:3995:13: error: ‘btf_sock_ids’ undeclared here (not in a function); did you mean ‘bpf_sock_ops’?
>    .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> 
> ../kernel/bpf/verifier.c:3995:26: error: ‘BTF_SOCK_TYPE_SOCK_COMMON’ undeclared here (not in a function); did you mean ‘PTR_TO_SOCK_COMMON’?
>    .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> 
> Fixes: 1df8f55a37bd ("bpf: Enable bpf_skc_to_* sock casting helper to networking prog type")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: linux-next@vger.kernel.org

Acked-by: Yonghong Song <yhs@fb.com>
