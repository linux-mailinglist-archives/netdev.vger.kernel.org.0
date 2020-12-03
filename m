Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC112CCD4D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgLCD14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:27:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbgLCD1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:27:55 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33QQRQ023036;
        Wed, 2 Dec 2020 19:26:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=liyh3+Vbhgs8GG5T4noSuLf4U1siMAZu0cl7ln2HpHE=;
 b=YQJ6CguI3NOiGpFCo3UGnjQ6QBuO25voj+5pml7HG7pZ1PubStiFyC8jyVkoYLfRO4zi
 cLoz47H1WWDrqA0dJPbAQruGD3jZyT98SqsoZudOUBu1cwNgZawxp6x7Jv3UfXs8t4Mw
 dmM7oZ49hNkGG26gKj8Z6J/uBGdBn3l0xUQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35615fgm42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Dec 2020 19:26:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 19:26:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chpOWLHEWWatHlfJ/S06DB5C/672tCGKfuZDkQG0FAfwepCsHvmZnCThUDcHDnIpGX/bxENz9jLhr61xlhnOvIcaWMBf6Pw7INXQCzriPtp63tIbiEDPUnVSVWsSDGsSd9qnp6bYCw7DWYDIPSwyNUkH3JW1l9v94fTP8yz1y/BjgAZXnqOwO6qcuba0e+3yem/bKNNRyK4QXgrZrc+5Jy5VHbyjKodtN7qvNuI/YUiJPzBjVJQoyxlmKMhUL2Eh7otNwrkU7RrsNYknX5Aj4wZX8sgGb+XQPA5fBbiYBY3ycnnYpF2OEUEs6miVBlDnFQ4+Nmt9/ulm6QYMpmaRtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liyh3+Vbhgs8GG5T4noSuLf4U1siMAZu0cl7ln2HpHE=;
 b=oUfCn0r5DYyFoFHvrp6z0qiujg0W1RRM3nnFZub6f0afTc7zoWXvqpMMtk6j2+8mQAeHxTcUNfJ5iXjchyAWMb1Lw75/hWxfAXAOs7X0xPTPiNwzpb4j39U6Of3m33O2wXD2j5nD+oaERB6pS6ykMKQhyJ65CWYS3ntTguV76/TysDn5wolLlfuOAdxAnn6z7hiLwQ4igacGepDwx1WUKHYOITLPmScWUSX0tus7O91PicTuEGie4kJeljKYj0XAyqJ6N5b4zcSzVYmCpF/OGTH8lCDOO4lWaOby6hL4ymKWfv0frvBg9vL7d4uAC8NqpEj6C1+JwbPoork28UX5zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liyh3+Vbhgs8GG5T4noSuLf4U1siMAZu0cl7ln2HpHE=;
 b=DRoHkfv4dKbvsSqhnSo6gwaj8iQuxac5AXsN+IqKP9cihRXkGYlZAZvqwx4vE/9Jyx76yAclPbwIdoRg9oWXBM3xEJwj6marsthdPuzEvHVWZ4X7049BhMjdvRxKXS3SRx6ZEWjbTt7B1jDKTvnJdEnCaMxRSYeoQx+avzMX2d8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3601.namprd15.prod.outlook.com (2603:10b6:a03:1fb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 03:26:55 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3632.019; Thu, 3 Dec 2020
 03:26:55 +0000
Date:   Wed, 2 Dec 2020 19:26:45 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v9 00/34] bpf: switch to memcg-based memory
 accounting
Message-ID: <20201203032645.GB1568874@carbon.DHCP.thefacebook.com>
References: <20201201215900.3569844-1-guro@fb.com>
 <CAADnVQJThW0_5jJ=0ejjc3jh+w9_qzctqfZ-GvJrNQcKiaGYEQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJThW0_5jJ=0ejjc3jh+w9_qzctqfZ-GvJrNQcKiaGYEQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:2545]
X-ClientProxiedBy: MW3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:303:2b::10) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:2545) by MW3PR05CA0005.namprd05.prod.outlook.com (2603:10b6:303:2b::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9 via Frontend Transport; Thu, 3 Dec 2020 03:26:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95b5fa5c-d205-4e88-cc2d-08d8973b48a5
X-MS-TrafficTypeDiagnostic: BY5PR15MB3601:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3601E1EBD16CFEA9E17DD45ABEF20@BY5PR15MB3601.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ulayp96s2uR7io3vY7H4nFP66e+poThUoVzZ2VyyfpidB0hS3p0tIdF2+K0woukVzxaR+nCsUzXJsBvJr+kzVYbTfSJs32UqidTVWDHf0oM9hoQ3vG7xjAZ2xzyMtDWGdGHDwBPOAZbbNJoK//txGC/nxPJ0ZESXt9sNKxs6C4KmX6+MWhngdkQsbosOaBoziUuCkKRaUexm7ha/Dilzh1Ojc+J3s+9Vj0Z+pvHTrHmCHu3mfyztW3YV9vtJfqpRUaorwDW0kJWKk0evUwq/uWqI1b5cyRCi2n0L0dVr9nmtegQlBAMQqFbR2XDZRAjvoya/Mx+GKqh4PADBbovejw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(376002)(346002)(8676002)(4744005)(316002)(54906003)(478600001)(5660300002)(1076003)(66556008)(66946007)(66476007)(83380400001)(186003)(33656002)(2906002)(6506007)(4326008)(53546011)(86362001)(55016002)(52116002)(6666004)(7696005)(9686003)(6916009)(8936002)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QcRikL3Jxg064JZKMpKo5qe1dedjXiZfyfA9NOmiy2Xrer2cF5tzzLSBNx65?=
 =?us-ascii?Q?Wj6Ay/MfX4dkVb+M9o2LQggpmUXkKwaNgOqf0aPRykhYtYabYMONmKUeyZwH?=
 =?us-ascii?Q?qV1R0AFccgBuFR8hjpvB7uwEgeUG8N/8cG0cK3bnpp0k64Zs/Sfy0LWxfX3r?=
 =?us-ascii?Q?hQp7nf/3h9kCtXLpo8XFt4TYsz0ULGoay9RHdFG3ZhegVxYck7LG0rIuY5A+?=
 =?us-ascii?Q?tpy7udNY1sH2n3c5g/tEO1Txk4LApY8lvRvDzTFCECcxtHE17P6GVKP6Ij8I?=
 =?us-ascii?Q?GBi3RD27JJNgvt0C0tqWVFHIc4ovwcaWXdktm/bQCytz1ioeZAyH4c4acPAL?=
 =?us-ascii?Q?0zq8JbFaaFQsJwtcJaEdRB9R/dPvI9FU1VcWMTTNNbT1QZF7ptzm2ZAfMN6o?=
 =?us-ascii?Q?XOWVGV8ipoNR5Tqvd+y3+WRR78DB92QssEqwoDh5HlKSDJOP6M68hQHHzPsB?=
 =?us-ascii?Q?85o3dhOkiwsLWHxyO6QPf0eYMfG+liZFBIBiezLjwQNYzxlnNXVRU3h7bmNw?=
 =?us-ascii?Q?yJ5nrtEEaXTLh9j1omrbNpVPOGoJO/HJp1KiFk1NhUZvjw0tujw9E1EUZP6x?=
 =?us-ascii?Q?18qGLtki/bJ9exPxbXMERPHt4PlACPWRSylZ30p1+fG7j3UFUqMgpYWOgDUb?=
 =?us-ascii?Q?KrphZBy1jMOWFpB2nEWlX7VUIsOTNwGBTlZok+easzOSKeBfG1EU0pVH6pw9?=
 =?us-ascii?Q?JaKhesSX0iYc3U+n5kC72v2y7ZKIX2FPMhieNEDp1HOsOBkt2HeiRYKtZNiy?=
 =?us-ascii?Q?lpB2NxqvK6F8/bylr841GVgW4uQYbyF+hXtW4UR2oQFP8dY9iS0Qywd8WoTW?=
 =?us-ascii?Q?pd6lRWaGzshTM5XSsACsdECwqDhmzPgz3BSM+EoUajxB3IH4toqPqSccyx/g?=
 =?us-ascii?Q?uWgiDCOZWWzQkym6rEln+I21zmv9eqTZFR8C8q7MzkoIfy9Mkkjdj2lBE+TI?=
 =?us-ascii?Q?iipKnWfRaoFNIw+HDbyej68jlBC/GnzbPvhMICXmVMd25tSUOnMZb/fsXnDG?=
 =?us-ascii?Q?AuysZo4H3S/xsF0OYnNCDEOSog=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b5fa5c-d205-4e88-cc2d-08d8973b48a5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 03:26:55.1954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3+Deh7z1DvFWFyiPkn8qRIoefBww3RA2GD3MyDlElReKCwXZLLzS5GyoFYvU97P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3601
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=1 clxscore=1015
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012030019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 06:54:46PM -0800, Alexei Starovoitov wrote:
> On Tue, Dec 1, 2020 at 1:59 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
> >    a function to "explain" this case for users.
> ...
> > v9:
> >   - always charge the saved memory cgroup, by Daniel, Toke and Alexei
> >   - added bpf_map_kzalloc()
> >   - rebase and minor fixes
> 
> This looks great. Applied.

Thanks!

> Please follow up with a change to libbpf's pr_perm_msg().
> That helpful warning should stay for old kernels, but it would be
> misleading for new kernels.
> libbpf probably needs a feature check to make this warning conditional.

I think we've discussed it several months ago and at that time we didn't
find a good way to check this feature. I'll think again, but if somebody
has any ideas here, I'll appreciate a lot.
