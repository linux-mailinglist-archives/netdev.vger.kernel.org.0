Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AEE2B248B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKMTdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:33:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53998 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbgKMTdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:33:37 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADJTeGr009134;
        Fri, 13 Nov 2020 11:33:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kpJad9UlSRCsI4F4IMwHO8OjYApT5G4xo9MbSlW/pKA=;
 b=oHMvd1KKRpBtxpgROh0IUnSiAWIAe0RFrbPNXSUY8GegkZx/I7zk2MFoLUtoN6KmWcBu
 PeiLojaTerXDkBW5Gyn+5qqlDT3Ibnv2FnZ8eAzPP9/W1MLqpjLhCwzmRceS5925F+M2
 Nefes4S0jQi6uoQ9OG8f658rPvrXOfKUPNM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34snu2b8te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 11:33:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 11:33:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WacsGNKsOVBSedan8jjvlRUkl/0NaV99mhXKc8nnPKOTP3iNnuQd/VzcIymV/dTx8KRQ07W+90DMG5YxwoyzlKd5YIH7VQbESFhw2bJZ5eC7odXa+o/5MHu8Qd5UsnPX55nu7pigaOaFKfhWrW8bAFpFQ6/HUuE4XYDO18Ulez8tHQfbjXfhkeZWvL9qcOeYGdoqHy5Dd0n6plq5UDc2O3LL4ucO4FcE6knaFCaj2r/oSjtJBgPJLPOIF6xkxx7mFYdbzN3yZRBZ1p1IFGSQhHuUUgcZ63ZfVD3PpKFlAmYFkA1vNpEpfevMPife1Baasvae9L5IQx3gjSZVuU/vGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpJad9UlSRCsI4F4IMwHO8OjYApT5G4xo9MbSlW/pKA=;
 b=IclVlp/7foEoyDGMl2BoN6PHCX28qzbZgS6YM3eKi/7JLRxV43/w1L5D5h8HER5iMQytFcHGH/wN4vBxw2Y1MefMQ6xSmdg6WfkGYRMY1Yf1VDy0je2wLh+0DySUqJZ9qO+/zMX+yPUTfdSuXgOzlxvzW2Xu0IEEFzPhR712YfdTyKRBWQ6+Y1G1/VVArgYwxsybXAxlH7qNpUDZSRG3/2lali94+zKH3c9C5FimRYp0AtA751YXwMF9LtjHub/K81FJKZstMnwioNentbeBaJshrabBdt3fug2v47X3tHU2Hv982101/7JLAWOQUm+ENUfWiN3aSl9DH5O6fOwg4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpJad9UlSRCsI4F4IMwHO8OjYApT5G4xo9MbSlW/pKA=;
 b=IrAtHevvwnPUNLAXJQHemzKDeRcYJuijcZFlmCRRJV7SaZMIMPSaf2G/KS0RzB5PObm8JU6wZF2JBMxoWgqRyr1NMnhu5+GmhcuUBupK1U9Tgf5+WnsGTg+Y3TGD7Z0Ec7dtYT/7nu9ahDTOSvRitCX3fxXsYJqMKbuJFKvHpN4=
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SA0PR15MB3901.namprd15.prod.outlook.com
 (2603:10b6:806:8f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Fri, 13 Nov
 2020 19:33:15 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 19:33:15 +0000
Date:   Fri, 13 Nov 2020 11:33:05 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 31/34] bpf: eliminate rlimit-based memory
 accounting for bpf local storage maps
Message-ID: <20201113193305.GC2955309@carbon.dhcp.thefacebook.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-32-guro@fb.com>
 <4270B214-010E-4554-89E8-3FD279C44B7A@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4270B214-010E-4554-89E8-3FD279C44B7A@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:e0d0]
X-ClientProxiedBy: MW2PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:907:1::24) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:e0d0) by MW2PR16CA0047.namprd16.prod.outlook.com (2603:10b6:907:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Fri, 13 Nov 2020 19:33:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 085b77dd-83ff-448b-e153-08d8880af77d
X-MS-TrafficTypeDiagnostic: SA0PR15MB3901:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB39017A16D21DBCDB2C493CDBBEE60@SA0PR15MB3901.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /LdcY2fSm9+r1tre8Tf2ryNt5m1mKQpyJ04rIYmlftsra2zWLWbZO/hYyY08fHUjKnRayFThiYhC0HiyvFYekq2p3WEcAavAif+u1wYBOZK5cjj6O/UbdeCzWpbCcnUMD6dDOgd6O4koa5secEMcCOZ6L6C4xgTtCcVGTeIM+QJHQs0MhbIC8HyiNePyjP4Fh95De67q0Oz2q40HAM+FOo/yoIvJPlZkJm0+tALZ0IQVUFf+qf1h5jXiXYSyPTVw2ckUPI2G8VEffkpxCQNEAtf3asOF8dWomtFiXjyHHNL43hUGQaWfhrzDtamE0iW8nRYLuB3/rdGm2+HJL8aM4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(366004)(376002)(136003)(316002)(33656002)(66556008)(7696005)(54906003)(66476007)(15650500001)(4326008)(55016002)(478600001)(8676002)(6506007)(4744005)(16526019)(52116002)(186003)(83380400001)(53546011)(86362001)(66946007)(8936002)(1076003)(6636002)(6862004)(2906002)(6666004)(9686003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sbMOB+KO7bol659/wq12g456GNgGQeeKVdJ4yb7npGCSrQB2WWXY3maoEFo0Xco6TVxrz6dp0iAhaPN6wvXQ09ou5/1GLrFWw87cOWU8dCWWELTnZay0JvMm8KBuYowh8brRsmpCzD8SwGRkASFLYFhpvZfz9dSXv7saROU6xg6UgilZPrrUvGOojy+LQG6tIFDQDnMLtycUBJf8WToVz3SLuYuCjXUaxLZYF+l0boWrv488QcsInh4KKKjQipVtZHVPfg5nwUoYBbBnzWHJZI/aF9d05lNeUyffRI3KOQX7I2+UpgHeV6/Q6y8n0v/abFe7ZJT4rp0gxZTeEkNF/qqxkNn4+2biAasU4CDSeFWaIKUKASrXlZMuNAHKCWDsmK2qS9PyW0DXth7OarmUsC/vGOBL3r8gOetKla66Pn7ly4WeZaez4JNHT8zOlhtTWY2+3la5DSzjZDcTLgXmMxdTTb4CjcG0L5nq7CET25TcERTHzDM7chlEJ2yQISmxPJZxdBf8VpHZhajTNDvY3F+yl+FKZ/kD3s+Km2W6GHVtqaXAg+s4IfptrrWZP0S4taUYksP3sdN8+3YwZ7psLpFLJ0p8qPrLthRgBzngfkjo+JrMITeJ0QZYd1xWHnx6uLN0RVEC+brBZ8oZcA/iR0BAfGI9CRROJlDfSsnBgGDrFe94x3qUlJDXiyFqcYFIvZayVJ52/cvigHRLFxYLM+cyjCdqHAsr8n4F2gztqzDHbDPtu7Xk8Jx2yVfd2eCugYYGuesEbp1WBoArd//xDaIsb4lS+QfMlpJ4p/g6ffQORAvXLpQykl3FLHldgMHA+TrK41ZsoeZZZOsfE32mto+1fi+GXpWXRx3ux0Tf2BkvpgwJ/7JhqnlM8Hov0aGI5a3n+pIOVgdzqh782F35MSXk3IBrbND62bfX0gz8ki4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 085b77dd-83ff-448b-e153-08d8880af77d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 19:33:15.8266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayEyYgJYPtFl/3rKfiqMn3NkL6wKpjINXBcfKCqK0Jin3QfIoVXzVvJOtOdHoRL0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3901
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_17:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 mlxlogscore=895 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 10:14:48AM -0800, Song Liu wrote:
> 
> 
> > On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
> > 
> > Do not use rlimit-based memory accounting for bpf local storage maps.
> > It has been replaced with the memcg-based memory accounting.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> > kernel/bpf/bpf_local_storage.c | 11 -----------
> > 1 file changed, 11 deletions(-)
> > 
> > diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> > index fd4f9ac1d042..3b0da5a04d55 100644
> > --- a/kernel/bpf/bpf_local_storage.c
> > +++ b/kernel/bpf/bpf_local_storage.c
> 
> Do we need to change/remove mem_charge() and mem_uncharge() in 
> bpf_local_storage.c? I didn't find that in the set.

No, those are used for per-socket memory limits (see sk_storage_charge()
and omem_charge()).

Btw, thanks for looking into the patchset!
