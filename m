Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0BB2128E7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgGBQEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:04:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725379AbgGBQEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:04:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 062FuB4B011831;
        Thu, 2 Jul 2020 09:02:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jE0+ohZg3iPxUiUApKg2vMDHQ6fF7g53Id0+LNNplk0=;
 b=RcSlGLnc5zWLJpBT4wNiduwiirg0WwCZ7xjU6XYw0fBNhnU7rdnq64AaPJxkWF9mBXQ5
 FXEAI0whniMPmb2/C2j3iTjvYDW1hDFaFsE8UyqfLsXgBoWJtDBhCni67Kqk+R7StKjn
 WjG0wDS7bhFRjOq+tT0WidbzWX+LJkhk/L8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 320anfa8pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Jul 2020 09:02:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 09:02:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLineKr7uJ4vh7ukTDA3QXpEshjHN23VqEHaPbJProdMgCcDx3zfYMPuUTZTHH6fl8UOCabEl2ts8u/j5h0WvuhahwbOCEs7p5oKSbT1R2M0Bw1/tjMVBzK93bJGktelxxsFKojm9VncVR32SFI8620D8midoOP7B5h4KTI1vGKXtWOgpRAeloihHGwlpRPX3ZNFiQHTdDI6sfoY/1Hzu6XofHIYCZoUFxRQxV4k8aZWlScgwcxJmE4g7brvvDUdUp69vb09w9D1GFIahxXqMnImvNeXRWOsGHUzAmQghVbIVAEotSkJHCjhM51D15NtNqywGAUzdH5Cu0Osp0coGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE0+ohZg3iPxUiUApKg2vMDHQ6fF7g53Id0+LNNplk0=;
 b=f/+ZrxYwog6xktp+ny/twMnHwvKHsriAmnzoompFrDvkw19Fvkn/PTCsGWIoiWQkjWKVp7jds+JTERMNm4TmA3mhkMio4CTNev3sbSmSKGgbB3wPBOWH9Q6ZmkriJx+PRmlLO7s6MGmuwclWN2KdMlXZwIxCDZOH8BF/Lghv5itcB+jmCaimRVM0qKxpCbLd3kD8cgt3bG7thU6HCQSJySJm+9BZEBtOWQGDeLeS5xqK5lIFXdpe2ai3DrSiJWtOV7p60dIL7CjbOJUlRXrAWm4239c43Uhb+4vNkaKwRDNi0/OaIERHAj7ahH+XY8avPqf3K1lc2711cq16j3U2jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE0+ohZg3iPxUiUApKg2vMDHQ6fF7g53Id0+LNNplk0=;
 b=dedrKwEkQ9/27qmrcXVU8IKNq7ZZIxegxzdDE8pUCd2zPlpBbj2nxxpkhZ7UALTf9RGplCJsKYwDvxol0SOrgj+rE2GXVkBln3j4t8mFKjQ1m7xZgtyQEPPqAOO8cGLzfz4kmczzgdbFEQmtkHLSqDCS2dE35sfVJo5z2GEgN4I=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3523.namprd15.prod.outlook.com (2603:10b6:a03:1ff::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 2 Jul
 2020 16:02:44 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3131.034; Thu, 2 Jul 2020
 16:02:44 +0000
Date:   Thu, 2 Jul 2020 09:02:42 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Cameron Berkenpas <cam@neo-zeon.de>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200702160242.GA91667@carbon.dhcp.thefacebook.com>
References: <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
 <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
 <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
 <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
X-ClientProxiedBy: BY5PR20CA0036.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::49) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:b0bf) by BY5PR20CA0036.namprd20.prod.outlook.com (2603:10b6:a03:1f4::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Thu, 2 Jul 2020 16:02:44 +0000
X-Originating-IP: [2620:10d:c090:400::5:b0bf]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e84bbc3-2f34-4c75-7cba-08d81ea15b6f
X-MS-TrafficTypeDiagnostic: BY5PR15MB3523:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3523D6B174E3CA715BDF903CBE6D0@BY5PR15MB3523.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWTAa45XexG5GX6hhXC1e/P1V3zTpmbRT7BRPNqNucDPjNfVTZlukyY/8n40V9DnYz5WUrh48LzEj8YGYUb1XDyx8SUmvQ1Zs8tTPC+NYM61v3gOeTOfVfBx46wH6yvc0teU6YWn98J70gguSopTPYBSXD6diV/KmQCvJfPpBBLdN5jhRM+eAr0MjC7w43EWGdVImzv9JeJDJm1A4gwV7i9hRJ2OIZrKKDe41KFbcRsV02jEuz2LL/pJie96WbmKTRdoaDSsFrK8r06lqexuXfKNlWnEN0Oos0oTLzEYAX35ocl2NzZ3KLO8/j9XGgMA99MY1szfrlGZj0OGmmRKWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(136003)(39860400002)(346002)(366004)(55016002)(66556008)(1076003)(5660300002)(66946007)(8676002)(6916009)(4744005)(66476007)(8936002)(33656002)(2906002)(478600001)(6506007)(53546011)(9686003)(7696005)(52116002)(316002)(16526019)(86362001)(4326008)(54906003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fRa5wZcWUnwcHMGLVeC1vnMSX6nmtVqP2+qycx/pOhYRNm8eXnXkZR1ickwP2/Q9zxyEqo6dDAXOm5bG8UClK1zW8FQbAH/pLsqBkGbArLxdwwqyueywc11EO784/cd9bPMosJQWjtdNLtOg7H5RS05nqcjZOCZtw2Nh/9tz7ONyMkfwM5RhGmivzruoRDgSgVB4CbBiCIHkKiAGsqIprLSqel7a1N3uOWpfBzoPYr0xRGa2skRgiQRm3AGwo0VtQlGIZmFLyWueUdE7uRQJkdFoge6oGwfyScVecAdUXeMuYhzmyl0HXlPOy74mYewwzPQFvRrW2cHKVCKdHollZCxTkXULjzmOOXhXXvB57EiO73GAmxQtgWAkP8RyNOWcKazhb061HHRSE9q3AicH7qL65VP27hLymJ1FKEr7JLYHySh8y36+cwES80XGUqHrMt+AeJ82Lesi9+n4unNoCxjq1uEQHEMMPf/HhuDZoJeUnznKpKGlta6ilpcq/JdEupbiS1hpvkL0dBcvp46NcQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e84bbc3-2f34-4c75-7cba-08d81ea15b6f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 16:02:44.6565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnBfSEXcFCkeOS3t5UQ4UIRFRG6te0JhaKj2FVUUwXru7KBXsdreDDiziPGW3VAL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3523
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 mlxlogscore=795 lowpriorityscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 cotscore=-2147483648 phishscore=0 impostorscore=0
 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 09:48:48PM -0700, Cong Wang wrote:
> On Tue, Jun 30, 2020 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > Btw if we want to backport the problem but can't blame a specific commit,
> > we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".
> 
> Sure, but if we don't know which is the right commit to blame, then how
> do we know which stable version should the patch target? :)
> 
> I am open to all options here, including not backporting to stable at all.

It seems to be that the issue was there from bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup"),
so I'd go with it. Otherwise we can go with 5.4+, as I understand before that it was
hard to reproduce it.

Thanks!
