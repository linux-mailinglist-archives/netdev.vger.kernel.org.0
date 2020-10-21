Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1D2953A2
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 22:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505512AbgJUUuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 16:50:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26830 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505507AbgJUUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 16:50:09 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 09LKdNOd022228;
        Wed, 21 Oct 2020 13:49:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fR7YRDBvqj5sAMQSNJxX7/xzURBeqKhrEOiQ2BHqEjo=;
 b=ErsDrD6OhHLtN1BS4jtFTvm8h0I2AbyG1ioqv5smesZ+bTJnF0QTOyintP1D0VOCrs7H
 vA+U0xKsWfGQq7vZLtQ4z9h/0E7ssukncLOm4fz2wdk4uDUNdTQWg3zgzIrXfDB5JGhp
 Ia2ePXKGV152vyeswSfW7kAShopiWDEB7UM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 349s0m2ema-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Oct 2020 13:49:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 21 Oct 2020 13:49:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HT0ARRm4p7NEN29kCkhFk+Lje2ESeyopo0O7HZeweKF1l3qNv/s6w/IFlqkC4ImoccOJ7iMUPo7qvRyzFOqajbCms718Y6LZhMLyrd8On1peULIl4Hg7+etDlCCytUkVZbQMFj9VovDZMPVHF+J47PTyWMFI6WqD5qsHKkJqL8taep50yX4IjdBQx4QJLXSc6MOQykyjU+MbpvPzFIbj384r0ItLL2h6Tg0lpl7jQvTeUjw0eM35jiVLf1BLt1zx5j+LKylAjTZDNSO/+s9Iq7FjsTUiPyUGhi+e2oPImsbDUP3XeNpctHSD86ev+dsgwBsFV+QZ+sNSBh0PtC67Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fR7YRDBvqj5sAMQSNJxX7/xzURBeqKhrEOiQ2BHqEjo=;
 b=L2327h3QPTbNNa3fDv1O1XXylpOqHg7LxBVYkr9o44ojmMJOj8kEFaD18u6/wH1YCD3MBzuDCzh9Qatg0j6VSydhEM/nGKnNA79BRO73SGVDpRdo002AWmWRyCwMqVCgeTJbKxlH5hwhx20nye9lbrSF55HPHdXlI6hD9mYDDQMumz9Uo7QezqAnM4BdohGJm5HN57Hcujkr3t0rWclKNhUyDa5XYrfTpwMakc4teSH3NKKEtBDxxHePSgNW1/Cix6yuQYgN5dGvU00xXV+ii2SBS5IfyiKlePXdNPUqD485ZmOHWQ7cQ4CSBg0BSSzMu96hKgWqudMu6aQpana9Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fR7YRDBvqj5sAMQSNJxX7/xzURBeqKhrEOiQ2BHqEjo=;
 b=kuaw2bNxijMscdHEohIHqZUMtbMwq7nKQA0zRj+OXMMU83ebDt8ONpri2iZ+CmbGvXZh/DT9+w22nh5IZ+6b5V+cjcUFFMc0KdgLocN/4b57NN8m/iUZN7k6u55gAn/mVKv04Aj9YPbJebJpFKszGRd/z2nRAJ3+JT60Ah/pw2Y=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 20:49:51 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 20:49:51 +0000
Subject: Re: [PATCH bpf] bpf, libbpf: guard bpf inline asm from
 bpf_tail_call_static
To:     Daniel Borkmann <daniel@iogearbox.net>,
        <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <yanivagman@gmail.com>, <andrii.nakryiko@gmail.com>
References: <20201021203257.26223-1-daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0c4af0f3-2aee-52f3-e294-cfe047d017f7@fb.com>
Date:   Wed, 21 Oct 2020 13:49:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201021203257.26223-1-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:224c]
X-ClientProxiedBy: MWHPR2001CA0002.namprd20.prod.outlook.com
 (2603:10b6:301:15::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::163e] (2620:10d:c090:400::5:224c) by MWHPR2001CA0002.namprd20.prod.outlook.com (2603:10b6:301:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22 via Frontend Transport; Wed, 21 Oct 2020 20:49:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a65b3e6-ddb4-4c54-c081-08d87602daec
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-Microsoft-Antispam-PRVS: <BYAPR15MB22452D1338DF2DA7C457751ED31C0@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4n+JVW7kBRNBNj/OhQrePb4+0Sda/qgPfhIkNhPSRH5g/IRPHydfYsMd1GzPbzttxv1iEbRF7STRnLJFeD9cRZD/HG9vd5EqFPRZRS6atN3KmsqUnfYRsGg2Miy/9bDLBuUvTH1XFTYDSPOcq8i2S7d/Z9uxNAtPt+phDJnC7hY6vxVNi0E8hvpYsMbEQGhL8r9ZrC+DA/5hv63DY+jc3ospm11L3PpozEzT5O0KO/kpfdNIJCgZ43g/yUqTpkQroxP2xmqwvRxfQcL4hnagyxmjcBkDIhIbjb8cYc591qh2fPzcrhz8WPFrR4Ygg2HvbI4ZQ806OUSq3mEMcjXuAOIbsLoE9nAdTiBwLGB7gYPT8dY0oR7fbGAljzkAb77zyupyfjx8QNOhKADCo5o5Fv9ZxTJDAgyeI0onUbMPEM4EVhw/qqjfZcV7q5BkB5yMIodWCy3Yn4686QjqJlF7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(396003)(346002)(36756003)(86362001)(186003)(31686004)(66556008)(16526019)(66476007)(2616005)(8936002)(4326008)(66946007)(2906002)(83380400001)(8676002)(316002)(5660300002)(52116002)(6486002)(31696002)(478600001)(966005)(53546011)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rwfIvKn1R8N7I/aGf408cUx8eXyX8y8N/Na+FCDFOH3rwt0H/mY2wTWcGX2WMENPF7fBaTMOFX8ylCFSMlXf5tu36q95D10sxAfm5ouZt7OT+PoKwlWKvCAZpVXFuYcchhEhH5fRzGIutZz1HdH5ZgXQHOR/DHxTXI1oXLKoUA3bLk6iieyDCIzfKUxTgp+WHKVPEEzpxNPpozwojdQ4RR7Njqvzn+fykW6KWCIHUYKl5SdhBPsMY+vdS+BsuJXTWNgj98IrQB9qOObyxQ2wR4vxilRN8/eTZzD5SQEEuGYcvbFCZtLFDdZNhg3axWz9KiPxfyx786fJr8DFDUGe1aQjg4jSQ6IQy03UtmWMPJVu9eYSziddseSg9n8iwrsxfcs7vp3k+zvQUs5zda6+ji3Qjg41c1vugFNwfyK8vQ4p2oIsSEdieRRrJblEoT0Eh2oIMxEzwMngGALSS+ldc3L5trlI7E9hRyfQgkKWFUVkVcHAkLX8rHGie47iwakCxfe9qZCz6GoaCVt+CqGWdDZyro98MDY+i7IxR4wo8hyIKA9NoSyI/1UC9B0kUwPPS9DkYQpYpss3//OPZOdsnU+4Vq7onug7moqtNAxlgDXF7N8ke+bxWLrN9O3Z63GuBf1Y2hATTdlo0yvhBT14ef6LwTFFKfOhKlWfEQ58Vh57U89Z4n+V2IWTI5YleOWk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a65b3e6-ddb4-4c54-c081-08d87602daec
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 20:49:50.8925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19yVm1ApWhuQVF6WqoYjzCtx7C9uEw0vsoKhcyjKxwCxxwHkiy1c76/601Xe2ICJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_12:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/20 1:32 PM, Daniel Borkmann wrote:
> Yaniv reported a compilation error after pulling latest libbpf:
> 
>    [...]
>    ../libbpf/src/root/usr/include/bpf/bpf_helpers.h:99:10: error:
>    unknown register name 'r0' in asm
>                       : "r0", "r1", "r2", "r3", "r4", "r5");
>    [...]
> 
> The issue got triggered given Yaniv was compiling tracing programs with native
> target (e.g. x86) instead of BPF target, hence no BTF generated vmlinux.h nor
> CO-RE used, and later llc with -march=bpf was invoked to compile from LLVM IR
> to BPF object file. Given that clang was expecting x86 inline asm and not BPF
> one the error complained that these regs don't exist on the former.
> 
> Guard bpf_tail_call_static() with defined(__bpf__) where BPF inline asm is valid
> to use. BPF tracing programs on more modern kernels use BPF target anyway and
> thus the bpf_tail_call_static() function will be available for them. BPF inline
> asm is supported since clang 7 (clang <= 6 otherwise throws same above error),
> and __bpf_unreachable() since clang 8, therefore include the latter condition
> in order to prevent compilation errors for older clang versions. Given even an
> old Ubuntu 18.04 LTS has official LLVM packages all the way up to llvm-10, I did
> not bother to special case the __bpf_unreachable() inside bpf_tail_call_static()
> further.
> 
> Fixes: 0e9f6841f664 ("bpf, libbpf: Add bpf_tail_call_static helper for bpf programs")
> Reported-by: Yaniv Agman <yanivagman@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Link: https://lore.kernel.org/bpf/CAMy7=ZUk08w5Gc2Z-EKi4JFtuUCaZYmE4yzhJjrExXpYKR4L8w@mail.gmail.com

Acked-by: Yonghong Song <yhs@fb.com>
