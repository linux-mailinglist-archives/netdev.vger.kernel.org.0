Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9365178239
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbgCCSJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:09:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49146 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731328AbgCCRvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:51:55 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 023Hp8Bl007909;
        Tue, 3 Mar 2020 09:51:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rsD1LdJcb4XeJg2CPYn1NUbbWfj4DFC/7mHXA9v+pbw=;
 b=oZKw7eqzE02H/wabnnEOSoeVbMV4fWs0xZQ9qLymdlfHd6ZPlGKmVSe0ZPX717GVMDBt
 KxjqgGAmdId9JPEKd+gQbsP4tnrzCOY6dOSVeTaDMMAYb6xOoDqYw+h2kjm/4S4g9E6y
 bnFzahlofRJB7GMkfYiG5jC41Trhcnt0gPw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yfmb6y83d-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Mar 2020 09:51:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 09:51:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4ssrtudTioHC2rcLso6oAmx3wdvp8XBZzrZ3/17BTvBTt894l8R6GzeDjq+enRup56di0ohZkphO+hvMgdNCc7nG/K6hZsy7k/jTcIwCybEdXKZH89+EXfnBgZK0zc4uD1J43W6qcRzhU7ekMI2doaIN0T9jqdM6ZWTXzaPzRhJ2HtB71ow9HS3U3o2WNuUIJMOYpnc1frOZvUIhamOlOk2E1upfA5+KwtwMsb35vykQetHSWyCtnkvsScMID2tAO+6V7nsQcVtiOKHAoAN5oZ1jqA3oJiyTvy15rSMhPQiX8DtOZ71yZJ3NuE+qnM/8G02CT4tQJ3bYxQZKfbJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsD1LdJcb4XeJg2CPYn1NUbbWfj4DFC/7mHXA9v+pbw=;
 b=oKV1YfgRF/46xzMENfLd3T1KSS7WfZFi0Ssf8AkAfgpzFhJGIbLL75x9FgP7q3RV+qFjizXN7gjfTz4aC4/5hJs5pg0oh6J8SYYD4J/+1WtALqU92KCACUn98qg8nZ9Ge/SqqaEuPG69blDfjtoEiASvkGOBInvuBIrZJpbZ0ye/1Xc2Mfe6pHEOf852WNdm3Z7MwS87Fv5cdQrN/YK2L+zNhk9JPtm7pbKkbp4cKfLGnsOgOmZ3GVoyqKVfJIIo4bicWp63XK8zJLUwPaSIpNtiW01Ea+fn1MWbDe6KO7Gwglk3DjgyjIJSHcD86rwiqkoCBtrAVf8UV2bhakamuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsD1LdJcb4XeJg2CPYn1NUbbWfj4DFC/7mHXA9v+pbw=;
 b=ZUmG+NQwbAccbTlN91hpkDx/SKEttLhXprFDuQuk9YorasQrvnO7Sl0Yz4DrBPZ20mxB9CACTWVv3eaMGW0AXyjQbqO2aN8CA4H2ajIpB6BwuvUxWEF1Jsfie4aMBEsK1JrNAzbreF1z8khdCBX/a1R19GrTRTZ+7Q+1QH7vC3s=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2454.namprd15.prod.outlook.com (2603:10b6:a02:89::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 17:51:00 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 17:51:00 +0000
Date:   Tue, 3 Mar 2020 09:50:51 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/9] bpf: sockmap: move generic sockmap hooks
 from BPF TCP
Message-ID: <20200303175051.zcxmo3c257pfpj7f@kafai-mbp>
References: <20200228115344.17742-1-lmb@cloudflare.com>
 <20200228115344.17742-4-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228115344.17742-4-lmb@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR21CA0033.namprd21.prod.outlook.com
 (2603:10b6:300:129::19) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::7:521b) by MWHPR21CA0033.namprd21.prod.outlook.com (2603:10b6:300:129::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.2 via Frontend Transport; Tue, 3 Mar 2020 17:50:58 +0000
X-Originating-IP: [2620:10d:c090:500::7:521b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ba4bb87-883b-4550-bc80-08d7bf9b6ec9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2454:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2454AC50E20335088945E9DFD5E40@BYAPR15MB2454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39860400002)(376002)(396003)(136003)(199004)(189003)(4326008)(5660300002)(1076003)(8676002)(81156014)(4744005)(81166006)(7416002)(2906002)(478600001)(186003)(66946007)(66476007)(66556008)(6916009)(16526019)(9686003)(6496006)(55016002)(52116002)(316002)(33716001)(86362001)(8936002)(54906003)(6666004)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2454;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiX9OfwZfrDhQteOm5OO+r/+eHbCZ7UY7eq3w5zK5tLFTPYuXOW+aOmIP0kQABtUGtpMFP1cT3OwdhXBYDAUnx5mrtKncjm1qaXgbMkPF9kJ2k9pM9Z8L3Mnd8JR+y1fDTkJSJsadB87emLHFvfVmF2m6ABJUY/1bt6WKikTOQm6+AVra47oQfQgNgwHLVJGIYPwgxyts+cAvaPJvH5qcGMAWN7U9i3VBuUffNnisd/2LJyo1r52gRbK1slvYuZdJowi0GHog2OMcsgN8EbxjH+Qr7LabyFIKqlZSxCFF1pAeei/c9lt9/Itc8+rx6ul69dHtdADYEG1lpvheIkSr8ik4+lmYnBvFEtDySwI8faCTqRCltFN3YZetH2Ev3deIEPkzrpPUpLtUJ9kAyRUO2NefUN5goOlSB4OKyM+Eaj46oEdj4MjRBk8zlJWcvkAf2CGpZZusCH4AGnAwEfcm1dFJKKCFL1aC7Sa9yD2FG0dmofB5RTWSSr0kUegQ/Ux
X-MS-Exchange-AntiSpam-MessageData: TuiYMCZFYeNrDfsbOreHNk7FusIZ9n4Fz7I/85F7PYHi9gHrQVqHPClx5ekIzeDunIcrhdSCejiVlb+WgX3ywB+15pzJqeax+b5d2qgQ8iYf3zBNcp+FF9uf23mSNCDmS0fq/M77a19cn/mAON9RurGnqyP42YwlMpjrjQEPxVk2iM8DxXoaWDFPyU1OxvvP
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba4bb87-883b-4550-bc80-08d7bf9b6ec9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 17:50:59.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bT2kLkJpFFf6/jGbEHmbitOiuyUFAoXRA1YWqc0ZAMeaXOESHGzX8KIssPKRKdwA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_06:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1011 mlxlogscore=853 suspectscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 11:53:38AM +0000, Lorenz Bauer wrote:
> The close, unhash and clone handlers from TCP sockmap are actually generic,
> and can be reused by UDP sockmap. Move the helpers into the sockmap code
Is clone reused in UDP? 

> base and expose them. This requires tcp_bpf_(re)init and tcp_bpf_clone to
> be conditional on BPF_STREAM_PARSER.
> 

[ ... ]

> @@ -707,3 +659,4 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
>  	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
>  		newsk->sk_prot = sk->sk_prot_creator;
>  }
> +#endif /* CONFIG_BPF_STREAM_PARSER */
> 
