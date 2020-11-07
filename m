Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3FB2AA30B
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 08:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgKGHhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 02:37:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727830AbgKGHhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 02:37:08 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A77aG1b021905;
        Fri, 6 Nov 2020 23:36:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XA69khMjchqbJ2Ab1MhoLFY2TiQhDgPj0w0ILc/qrkw=;
 b=B+wBVDc/tQCcyfqf8v0yZvt6LpJN3M8Ncq4vNgtqgS6bv+C27Ggrsse//XvmkN+J8zud
 Gjn5bm7b1c43r08/5gF8ddzwBfiVtZPiRyhtraTUWoC4TcrTvMoO+L6CzMUWHR/2h108
 mcfk8Cuh0n8rNLmtFFnS20lPCvkG/NWNMaI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34nmmf0f49-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 23:36:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 23:36:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DayG+HvBGO9+zc37Y1OjGZFVpa/En4tU0JyYWZTD7O+uHHuL9KrNBfM2A11zQ0NlaHs/1CED5Zd4TydiyFlf7x34iXL6GBP0EsSmln+aRql1FRolSflcZcye6K+uiHQYz9PEu9lZu7S6kGldeUjJJ3af/KYogsBI2LMZF2AKysw2aLrI9FUdn12ZGwrfQ7QIepuNj72udy0aq7bRIM2duZJAkTu4Zt6LRhouitsiW2dvEA5Y2w7pIRQQ3AS2Jrs+/xWxBwEwge76sfoCtjZpTr9XVCvcBVI2ykCRUljeaFk8HysXB1jGOAszH//zW3ULquGsLUo40y8Ya/F+zMYwFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA69khMjchqbJ2Ab1MhoLFY2TiQhDgPj0w0ILc/qrkw=;
 b=ioyBDEqeND+IKs4G0CMrCIkPA/+fC+7hKQSPBHZCWUte2GDPoETOXpj7kpqa5HLXy36UvJu1IViF9WoOVajY0v/HRKzhrbosHr9bg6mV7i+VCWgo28hUUh87sm4DCMjFTzRbbI08RoBm5OSPE2pX2h7fqUmZU9pe5KyiyRHIla1VurinHaOE8d+Tcjt/wv4/1HMPWW6gB3H9ZwmnONm5hL6nvC5oYuvf/7M3df1JGjJDxqLw/RoA/6TR+WGv8gAbtMULoqFh/OVv5DirNgccDe0PizcvdS/PWbJvaDPCA5gahkaVXBZsStRfnS83jzXZMpV+VRrsgZTRCjkGLI/NZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA69khMjchqbJ2Ab1MhoLFY2TiQhDgPj0w0ILc/qrkw=;
 b=bDIdZVCDXq2t1H7HDtF8evCB7/1doZes2jMMK9MBvy2KiSzvKGbh9QOV4F0heZK0OkvdzQzLj6UyesIOFX/XxY+mHZXDAvYARofUBpNhds+ndKHNs3yD43ARwUUyA43jQpryAPCc1ucRX8pY8HoOJ/uUk6y7U5LWdlvDTczcYIw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22; Sat, 7 Nov
 2020 07:36:20 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3541.021; Sat, 7 Nov 2020
 07:36:20 +0000
Subject: Re: [V2] trace: Fix passing zero to PTR_ERR()
To:     Wang Qing <wangqing@vivo.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1604730896-3335-1-git-send-email-wangqing@vivo.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ca4f252c-ec7f-bd12-fefc-23b12c81865a@fb.com>
Date:   Fri, 6 Nov 2020 23:36:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <1604730896-3335-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:3f2b]
X-ClientProxiedBy: MW3PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:303:2a::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1537] (2620:10d:c090:400::5:3f2b) by MW3PR06CA0022.namprd06.prod.outlook.com (2603:10b6:303:2a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22 via Frontend Transport; Sat, 7 Nov 2020 07:36:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5889c873-e5ea-4320-ec88-08d882efd1c3
X-MS-TrafficTypeDiagnostic: BY5PR15MB3571:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB357101568694C6B413643AA0D3EC0@BY5PR15MB3571.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2EO0LRFrN54KTTTSJZrXczXCENS/+bj10alC6UcuBh2fvTqzLivTHPZYVbdT/lmdoLEdvWWuwT9S5L/XjRBxpsKxr4yHf9Ka1asRRAFV1iMMvKYFrV3aXSaLEiAKuaAiyyqgKlButmbk1MJRf/d9ERRYFjtgrfxlIcJ1+dggN1kA88iEarNyBzIwvUF7ZCjUvp/9IdcYAQ5pBCpYh1ZIC2OMtGwvI5j0Ia0468/NtRCzZKWPVnZ66ufhSYE+EoWJEVb64pP9BY1ZW1bATik7slQugMQEoWK/TPjkYCIqXlSBqDwOWr3ThcTgEoHPmFssRohr3XiQ4tGtpYiLdgUa9M06yzUm4g2RKSjT1/VNQfa94awVITUoj/gWTQQMvZGZNQtYWceJgy8BngcWzJ4Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(136003)(396003)(7416002)(186003)(86362001)(5660300002)(16526019)(6486002)(52116002)(31686004)(36756003)(31696002)(6666004)(66476007)(2906002)(8676002)(8936002)(66946007)(66556008)(83380400001)(110136005)(316002)(2616005)(53546011)(478600001)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kVx9DA48J9e79djAjd7cTMr7IyPVP/nAIYtd1Fyl8EqOKGKol6iQuLfr8TPi/OcDOi154SVO6ESNKq3HfkYZWAlF80GzzEOpV25VaYWf350hDefXN6DNeHzQmw3n+a/1O+3j2cye+BI+CLCNKibbHVyBGIvP7mQbVvOdnpINR4mki6R26nmuwOuEsGsK8LuLBABmtch3q7sGDNecHwz5EI0OvXON2Qr8l9sXPO1atyNTALofE0IPs6cmZU4xaCJmNVhcwKNHGWRK+jJgKmqCANQKEBkKHICWmo1CLRM1uzyEpbQ1TJyH6MPFS+PL1dzuf2hMhOWCQxhRVsl6x3AoZ/Vw7tjD0rW1/DzutFxFCGAqal61Ly32DQ2rtY5wQHo8iujijc9RVGffw5GoIuuXA070rMPyNKSfnHuDl0hqrggHiQbBVXsNM3AZMBxQNbrLnGBPqNsLlQ6Bo43liBiyJXge3Jzj+FFhqNNk1PTpB9lBtdxjtCUfrAjaEu24BLnfo5EnvnmSj13oPvsV4nHmi+l2ZiKgc+WOp8fGCUZ3XFG8vcLouVUlIynIXm0NiDmZCgaFgh9okOsuBhAKDx1HO/8lxohQK5TrpD8SEkqn4/v05Mgk/UXSG8+HqItjpZKkOGe50Rga8YDaw+YSx/320y7N6xBZiC+0wdyFrA9TiY8aEECJVHPGgiosaWtrFWx1
X-MS-Exchange-CrossTenant-Network-Message-Id: 5889c873-e5ea-4320-ec88-08d882efd1c3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 07:36:20.2986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jr55Pcrp2kH3bGIqO49P1J1k4xXwHFlqhko6i4vdY+Mro5YIxnTYu1XW7B3jPEqT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/20 10:34 PM, Wang Qing wrote:
> There is a bug when passing zero to PTR_ERR() and return.
> Fix smatch err.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

For clarity, the subject probably should be
   bpf: Fix passing zero to PTR_ERR()
to indicate this is a bpf related fix. The tag should
be something like
   [PATCH bpf v2] or [PATCH v2 bpf]
depending on your preference, to indicate this is for bpf tree.

If another version is sent, the above "v2" should change to "v3".

> ---
>   kernel/trace/bpf_trace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 4517c8b..5113fd4
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1198,7 +1198,7 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
>   	*btf = bpf_get_btf_vmlinux();
>   
>   	if (IS_ERR_OR_NULL(*btf))
> -		return PTR_ERR(*btf);
> +		return IS_ERR(*btf) ? PTR_ERR(*btf) : -EINVAL;
>   
>   	if (ptr->type_id > 0)
>   		*btf_id = ptr->type_id;
> 
