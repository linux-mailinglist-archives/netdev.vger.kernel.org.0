Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE23A24E3CF
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgHUXPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 19:15:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgHUXPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 19:15:46 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LN3rDc013022;
        Fri, 21 Aug 2020 16:15:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AWxuG3EEpWUx3cAh5FdtpomLgxG4jrXstXSQwdBcMx4=;
 b=Ax4QdSBwfSBjm7E6hXmqy48rPQpnR0buCTP3TIXrP8rLPdKJXdQfhbRBl93rkXCHyOu+
 BxOd8DJ/mspGjM045cV8ZRs17acx/5aaCvQvElkbwokiCv9nv+ckIGWZIFUSeiF/Tg82
 /mtQX/KOtBF/6//2RDMu5b2yKIBApx1IFUw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m3fu0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 16:15:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 16:15:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yrk5+vkxsjzwX7bWfPTvClWw1nRHgP3wQTUsPXoSFFWt44GfFekC1w1tOEb/Yw4ywDA3LrGcELVMTlvLUgHItGDfUJsDncbxutBbanTmA7xzbyN9JPKNmC7XlwDZ98pLk+JdaImzEwiC8n/HR95cJnM7TRBNVBV3/91Tk2QJA9IsTShKAZ4zXhjvPeNz3xiH++p0HGf2z61zfTPmpVsmyEjC/udVquKInCXwpYAMT2ZZKskl+qzoxxuDTSMi0PEMe/php2UcN9WPLaaiICOopmTKe4tPrM9Do+Uq2KR5rr8OdM7U//XmM596c8Tim1GB1CsGGKlaGlaGwt4cmCuPVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWxuG3EEpWUx3cAh5FdtpomLgxG4jrXstXSQwdBcMx4=;
 b=N1ciCeR+L2P8YonA+ixbJA2wi+IS0eS1/crTBJhN8DoPVyqRP2w1VHIMxeliD8eqHZ5F+U18uNdLYtZe2tDCk+gqflGazbjhShg0QscuDhVlTgAyk0eHwrnB4DtUB5jIYxIDwiYqBEv+PF2VLrlmyL3TncYelOJFnDMnxzKCMoxSZDDu+1Oo0WPrrGun9SJ1rsVPWcYi1jInvrU02Kz5pwKtodXrn5BLGUvcc7UWWm5CH1ahGp0D6srcHmSbe2z0+FnlaqRds1BXABkxYngcy99gY3UZsLDs+L9GTJR96DOF7Rdo64qOKrOi2R27iLs3R75QGj2ypED2Mirjlq0EuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWxuG3EEpWUx3cAh5FdtpomLgxG4jrXstXSQwdBcMx4=;
 b=glfnkne8CgDnR+9JeH9jBjUQmtyFg8Jn8fTrBCpzrZNcu/kUwcbBKOq1qpCPK0uO5jlWCFVjYGiAyK8zcjCJUyMYUGBsMIdNubD/+wavgYJmMLvC2S1ZiIsRI9/d3c4oTjWcFpwIX7wwbYI3BRLc9CvtakiMO1/XMpREPD/el0Q=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN6PR1501MB4127.namprd15.prod.outlook.com
 (2603:10b6:805:63::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Fri, 21 Aug
 2020 23:15:23 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::e1a8:24c:73df:fe9a]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::e1a8:24c:73df:fe9a%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 23:15:23 +0000
Date:   Fri, 21 Aug 2020 16:15:18 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v4 28/30] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Message-ID: <20200821231518.GC2250889@carbon.dhcp.thefacebook.com>
References: <20200821150134.2581465-1-guro@fb.com>
 <20200821150134.2581465-29-guro@fb.com>
 <20200821182321.dtkf5wpi4pukbq3w@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821182321.dtkf5wpi4pukbq3w@ast-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: BY5PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::14) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BY5PR03CA0004.namprd03.prod.outlook.com (2603:10b6:a03:1e0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 23:15:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:6674]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 051fe9b9-f145-44e6-2387-08d846281471
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB412743C5B26DAA7730E051A6BE5B0@SN6PR1501MB4127.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QxD+tcxeHSGaFyOtXLaJV0knMKxfEwLAM2lZwrvattB6BkMSmgbLQczt4VdKkzXi/rPrMwXQjC93MLIRkmitpo2cksXZ5XRfUtx20jzDtb3QTM+WJfJW3wpi0+LhPS10lbh6RiezGY6roCsZF5jkgOfllROE10A00Sp2PL5d1wHmfLHM4/O5f2FrvffeWvQxP8/7ZxB09vKeEcZzalHF4aO26tFgi17DAWqfWZndXi7iGv5kNFTT0g6ap224N6k+IGirpdRkfvuO1HzrBdTtsO4yBaPDJQ7vlmyt5HAZZEgMfzFZGDD2U8w8nb1yHyj3qUcrzUGFrMR+vga7K2g2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(136003)(366004)(376002)(16576012)(478600001)(54906003)(66556008)(5660300002)(4326008)(6916009)(66946007)(2906002)(6486002)(66476007)(8676002)(15650500001)(33656002)(316002)(186003)(52116002)(83380400001)(86362001)(956004)(9686003)(8936002)(6666004)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qo5LyJHS/CZvoLBgUx10+SjFg8Vn3bVdAMW72Y9gBOLHx8oR8W1LkKN/aI5DjKkwkzYL88YXWO3VUeun5UdNM27dTzaVHa5y/vMpVklJo7LJWsG6+Fve5rNvJCJGQfUPKjSv34YIuxcmfBzLAVAePlnGtQOPtUEUIkVKd6x7Pl/7oB3eqFTpaiF+Wrv5S3nIx2ExlcHMQD6JoUs4Jpt8F9PLzr9f2YijEc8c4c9kSfz2WaWWgu74cvj/+QLWfVGLWE+yVqgNqnEpPun0ByE9gAfnjY6b+q5HOZ6mlzz6amicL5XZo4mRXYDPsz6Ee3oBA9NS8LLZ9olHJgfACyoMvs87A64UV6pLV2E/j+Z2Z3oGTj69hd7lGg5FACiP1S8TcW5NPZU4FLiTusR3ayD8XCHs7g/En52sv5DlRYr7rFRxWM/SmRjEu2TSsafdU17b1gNRPqnIiJP16eqSaUwIVIKj+A25Y3+itocwsc0RtFeYxnvDghMOrFHkLGalHSjcYMCcMSpljc4MV6YxilglP4B6TVeUTGIdk6WuLVJC2ebA/nzoW1SUgWmeNNaKun8oDFivtGhaWbaYKfnS4NZgqooKAMKAfH7Qqn3qotcIyOejd1tOpq96LwuHQd3PX2noz16NscH9rXEkhMuJV1KqA/IXlzOr7tNRDNr+ow2L37c=
X-MS-Exchange-CrossTenant-Network-Message-Id: 051fe9b9-f145-44e6-2387-08d846281471
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 23:15:23.1878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MR2EjrVenaBG7xDnYFCAgDjpKWK/E175SxIlr6R8bWx+iEuQxxNd+4BzF2FWmSn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4127
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_10:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 11:23:21AM -0700, Alexei Starovoitov wrote:
> On Fri, Aug 21, 2020 at 08:01:32AM -0700, Roman Gushchin wrote:
> >  
> > diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> > index 473665cac67e..49d1dcaf7999 100644
> > --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> > +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> > @@ -26,17 +26,12 @@ __u32 g_line = 0;
> >  		return 0;	\
> >  })
> >  
> > -struct bpf_map_memory {
> > -	__u32 pages;
> > -} __attribute__((preserve_access_index));
> > -
> >  struct bpf_map {
> >  	enum bpf_map_type map_type;
> >  	__u32 key_size;
> >  	__u32 value_size;
> >  	__u32 max_entries;
> >  	__u32 id;
> > -	struct bpf_map_memory memory;
> >  } __attribute__((preserve_access_index));
> 
> hmm. Did you build selftests?
> 
> progs/map_ptr_kern.c:45:14: error: no member named 'memory' in 'struct bpf_map'
>         VERIFY(map->memory.pages > 0);
>                ~~~  ^
> progs/map_ptr_kern.c:25:8: note: expanded from macro 'VERIFY'

Oops, thanks, will fix in v5.
