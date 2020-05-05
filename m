Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F821C5FB6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgEESKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:10:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6878 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729315AbgEESKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:10:30 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045I5LrC032037;
        Tue, 5 May 2020 11:10:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZL23tsEVV0Ez9AK+nbbfyZ1ZIIsJ+COn87xR/bqQIjc=;
 b=rrhnM3iXGa6VRYYt9FLFL1rimQ5bVpgBu4HbKMX7A5Pf6n+iN6ieeG2q9XKgFn9KE/NR
 KHmqzbKPRFF8/GUIYadp5OCeuFbIjewuZYtB3EpoLqew/iPF+sYbE54+beLViS2kogVR
 ZDmnoe8JezReQl6z5WevxvG7guGVSkttetI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6cmqvkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 11:10:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 11:09:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQALre1mULPPw1kocngR/RGa+KuYmaXYUIA6uZgRxgBIA8n/CjHhSBZVNxteWnOyFMsbq+Pj0VfQYSTWQCb0h94OIRqtLr6iwwbzk7DJEIV8dzpvVWjp/PSSsLWSYNsE5bEt02n2TJZT9MTmxMM4EGJ/JNnjl0idVzKU9A0ihpz2vDfYa5n66xH9IeuQNkb2324zntc8K2rvw8O+TokZEjakqtAXzzMmE/hJGs82r5Q/PasArl6LSwRiMghFf2ZAt09Zv7qOSsBVou6XShIGRtC3t62uOJhw+1+YgKE6/2R/mKgRzQCluzI9OAaMjrPXcqXvArLJKM0rHzfb6xAWdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZL23tsEVV0Ez9AK+nbbfyZ1ZIIsJ+COn87xR/bqQIjc=;
 b=OyvnqTqIIdy2opDO/VRnHd7bO12+hsZmJud3PqlxtnEGdUbSvS0Cf88EpGeHI93TjYI83Qfi4pgpRjdgG8EOtqXOwRKBM7Mb3YQ0O4hAMwSn+Am/K/3tW9evjOsI6dHI44vRUYmpn0PKAKwCIYIFPU6E/crf8rsnNgk2b4xotARQWjAiVE0wcX14UK9J9/ptDWIxlZZJY59ss8fgL4VqAIQ204esJA82hvMqW8ufDHiCGdQ+RmeAe3LeoaDIj252v0mPKMNR5I42RDsw0bnsFIab1Kp6OzNHehwhevqgBo4K4BHh+IntTFYr+czjlmjrrJfdfAfEqeX77AU4zYl7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZL23tsEVV0Ez9AK+nbbfyZ1ZIIsJ+COn87xR/bqQIjc=;
 b=fZ5DnuDlnfQA/zTxlZCZKIlQnsOOz1jviImk+sOwtWbrqAJNqO7CSDbXAw3/h2DYaoqWZ4Y8peEkwgf0JjOMOHmHmjeAtjObOIHFuJUQUilV0YQC6Svamr3YfWWY8r2FTDd1OPLgQBncPgeYg/j2Js2cjUuDezPxH+SXOpD2QB8=
Authentication-Results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3930.namprd15.prod.outlook.com (2603:10b6:303:46::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 5 May
 2020 18:09:17 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 18:09:17 +0000
Date:   Tue, 5 May 2020 11:09:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH] sysctl: fix unused function warning
Message-ID: <20200505180913.dse5itmbzjsf2nou@kafai-mbp>
References: <20200505140734.503701-1-arnd@arndb.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505140734.503701-1-arnd@arndb.de>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:300:4b::11) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:3100) by MWHPR02CA0001.namprd02.prod.outlook.com (2603:10b6:300:4b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 18:09:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:3100]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 305763cc-5ebe-4993-e283-08d7f11f6cd7
X-MS-TrafficTypeDiagnostic: MW3PR15MB3930:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB393002EA8DD397A2E7D440E3D5A70@MW3PR15MB3930.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1y9NyMJN6DJwWlzZrGKam4znYwmBBJ6wY+P0POsQGy3gzzzIJG3jlR2L+wHRuxfmo6kPm0ssqzy76BYZ6c2ny6MdmRI01vACMuYMM05YZUktkTdFjpVKRpephxqhaVP7wK95tpMnXHSK6QCIvXYAahQruJqbolLIyRjsIbwu8AVg8rE0vHFAHUlKQgECTzl3qZidRXTFYERmNoQi+C1fjrNY73Sdb2dAOY1Mnl8OjCNWSDYFQSepY7zizv13LxTzLFKAIO4EWbbcO/NB0amOduGgMnlmxquswxb+nUEoQEqLe/wvmuV6m9DZkFpHlDybYfBbX77HB60Ucx74bfQsC/mJCo5HiFP9DvPrW9jypfhpY5kwfbxE2zW0ZW71IeLwWcR/JQLrVGjcAxUfXuIMY5J7eu3HEIelq56GVE+jYcvdFHPFz6MhrLBcUg9y3s9FMANNm+x+fJgI9VQvlaUyFJ59HXA2qsxIUWHrkbPqGdcsh3K+Jf09u46Rtq+MJUUqEhGpRSpioj/rVaICcq4nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(1076003)(9686003)(6916009)(7416002)(55016002)(2906002)(33440700001)(4744005)(4326008)(33716001)(186003)(16526019)(52116002)(498600001)(8936002)(8676002)(66946007)(66556008)(66476007)(86362001)(6496006)(54906003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: q154qlvsjE6Q0P91e8MmYSiLqQYQfH8oFBUuYuxL001IO4T7zVbFseEtggy0BvI7q2BrGS/Vsa9qopCKQv6lek/hEuUc0NwrzB47Z563EZg1uGINrr7z6aaCnZo8wGJ973UQ05lAyvkyuvbubCign/JSibUjjRMlfJaUJf2DVw/b0cPvsbgwXSXKq62nr1uPndhJ2ughDxDwc6l5ggM1t8KgNIEBu3EVTVbio9RgE1Z/m9phdC+8zQ/pCDu4P0wMTTZbU9IZt7qjPNA3/A9aK+GsbD9/b5tUy+ovloV54m4GR9/2a7w9xo/b9h8kZO9UuKnOcG8Zq2peYmc3E5aBVgtHD3+Io1p/l1kpZwGXcG/SsW5Dsns1V4PBbWi984YWHWqpINXbT14EAHuxC9audXKR3c6g858Xx/5Ji0vsxR6jcG6+M8EK+W/qUMjN5FDWy+uluNygr+jYDLFceRraAjRqpi/G3th7tgFOrekYh3D++dtvSw8ixLuuiDjBL4/BrZH0avnyLyD/E4DBY9hGxcJtctLwzZKbFm1wKGWnWHbBPOQUG33EFRLXjf9tZwKVjXEDXy+AasNNc3DOI2BbjII3t53SOTGgs7O7tQ0y0DVLW8EPK/tvr5Fcn0SIsk/utsPyBlUmaczgKkSOOg8Jqv6Qay0yh1LwgE+IXrhF1lv72ot6q3w+/rGlvTC6YFq8Oz2HOSQ7d95qu0tdl6HPT/mPABsAgxrqG80WMh7ek436r4n2Qus+/TXZGfqa0lWL9MODA7+bwVZecLNRyLWnUJ9QoA6HK0ZD2/vl62yznA9+9mbkit7TSPTaav7BxFFwU6txCqrrY2USfJyjAIQtHQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 305763cc-5ebe-4993-e283-08d7f11f6cd7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 18:09:17.0483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ikT9er0shgm3N6DwSLMb4zS1FdGlM4wIztqEpeAi5U2Ww6xCsHWjH4eB2NolV22
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3930
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=540 spamscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005050138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:07:12PM +0200, Arnd Bergmann wrote:
> The newly added bpf_stats_handler function has the wrong #ifdef
> check around it, leading to an unused-function warning when
> CONFIG_SYSCTL is disabled:
> 
> kernel/sysctl.c:205:12: error: unused function 'bpf_stats_handler' [-Werror,-Wunused-function]
> static int bpf_stats_handler(struct ctl_table *table, int write,
> 
> Fix the check to match the reference.
> 
> Fixes: d46edd671a14 ("bpf: Sharing bpf runtime stats with BPF_ENABLE_STATS")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Martin KaFai Lau <kafai@fb.com>
