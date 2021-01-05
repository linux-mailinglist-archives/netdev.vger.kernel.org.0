Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C07F2EB482
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbhAEUuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:50:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728714AbhAEUup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:50:45 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 105KmHal028540;
        Tue, 5 Jan 2021 12:49:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bS8EPV6VBMiIMq60nR0A8DPtlpy/w/ZvBdywojDU7hA=;
 b=Le+g2pgiJSL/Gv/5RJqtmP4etxVS7nBC3o+FEbAOrN9Trd89CLFzxxG5EkMytrt9Wbg+
 IrvA9WwPaYYGYfd0aiB5uW/47N3aVnz74PHo4rxo96qnxJMAwe5+ixAXpJUgSHAhNxAG
 gC+4LIvtdeBSacepKU2FpjwMSZFDuFHyBpg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35tncudra8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 Jan 2021 12:49:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 12:49:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbuwPtO614dOUyeJjI9lStlM4Wan6sKMZT9KFLse92N6bARfuW6ou6Y3j6mqYfHTWh7wTvOc01qOWVD94+iaW3rFL8bsnmK49XinYtpecjYm9Eyn3MBGel7WAe2hmtI24jxtR4pjYIDGVqkfu7BkHQ6+VYnMXF6+li2SP9AUpcTrwQ+UzGYhcR0hpeRKa46GDTmnNS5e/xzmniCs2Ch2ao3zbRGoWWzp7VHCALK8VCbmriWN53hLA8hjGlnQ9b2Wp+31mIEwLke/9VXeWMEj5cb4bUpqqNMKYJiQ2fvFez1UzcNlO70V88hpzFAVbRNW6PA/kR0HTFS8x1/7HxhGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bS8EPV6VBMiIMq60nR0A8DPtlpy/w/ZvBdywojDU7hA=;
 b=hYel8+LLKsSpuL3nsxTs6p2stn7Jnz9HTusXilq79fgaoAetOjAxRHMOmOAubnC25BHADeVBVLbM7lgDTGTQbT1AHIjzSTofKnMXtoBIp9sQSxjExLUR8xFAtdseop+2bGTlG9vlH6Z29qBJd+ag3axIkOUi37HbxCU1S1ZSts3oiyjNm44FudTlS1ls2qLsqf8o1ndrav2RyOzRJ5eMRSFLglmTZac29rwY89sXckSfMamWt8DrnDRmhy9k3H35o9HKqTwW6ljsa4VI7051MhrpAh3xMW69+982+r3yD1hFr/9eqbdLre7y96hO1H60BtHD9RJgJEJ/9cj2hS/TFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bS8EPV6VBMiIMq60nR0A8DPtlpy/w/ZvBdywojDU7hA=;
 b=jNRzdsCgv38Bt5Arh/GVl/3r/NFKMrKGCu3G6IRKPcN6scUAGwobMVsZ2+bNTyQAEArn4WN3V6AjjggwFZu+kO9K/nPYGEH/3xpKKNGAegVp4y77av8fgL3k21oRCtuiPSy+Q2zld1GonduO811CP8/LyGQJAjZ0sx6U4dIt7XY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 5 Jan
 2021 20:49:46 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 20:49:46 +0000
Date:   Tue, 5 Jan 2021 12:49:38 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <menglong8.dong@gmail.com>
CC:     <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <jamorris@linux.microsoft.com>, <dong.menglong@zte.com.cn>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/bpf: remove duplicate include in test_lsm
Message-ID: <20210105204938.owgrphakjvwp6l6y@kafai-mbp>
References: <20210105152047.6070-1-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105152047.6070-1-dong.menglong@zte.com.cn>
X-Originating-IP: [2620:10d:c090:400::5:66db]
X-ClientProxiedBy: MW2PR16CA0048.namprd16.prod.outlook.com
 (2603:10b6:907:1::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:66db) by MW2PR16CA0048.namprd16.prod.outlook.com (2603:10b6:907:1::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 20:49:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc8e7333-c40c-4d17-971d-08d8b1bb6ff5
X-MS-TrafficTypeDiagnostic: BYAPR15MB4119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4119E127800959E575F08F51D5D10@BYAPR15MB4119.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6h7nSfph4Z6McdT0wIf1pFS/M9y1lSMjKQGvjEuAciaCFDPB88Ao6z6nosjfxrsZLVtXLVxNt1PDhLlmuu48XzE8AEeQXWwaS7UmN6aFalWdg2SRmc7fRWKo0owF9SVkbyaNLR2vrDZpA+X/04pY+r1RA2mqr3pGp/P1XGPmphfBKYqfgPkY4JTrk8xmJVjRjdlopau4clR2ewA1gL8pAoeQBAzynerdPkzBhx/q+lPjMWa+ztncdOIOqpZk9q1HkknPeBQl4mI9mPhqkAE5mQoOuirOjbczq2kk3agvnVB3PKtUN8Q0W4ncmDoU1/0LVdBo38SpTICipnNT+D16WefCSseLkdvQWhDUuHd8Dk5whHeJEWiB/ecYKa20tKM5kIJ3ugZruO2Ai4b7HHYmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(39860400002)(366004)(66476007)(66556008)(86362001)(66946007)(6666004)(16526019)(55016002)(6496006)(9686003)(5660300002)(6916009)(186003)(8676002)(2906002)(8936002)(33716001)(1076003)(52116002)(478600001)(7416002)(558084003)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FhoTt9lJflcLVkMWyqKIPiGqaeN7Q9lhFKHDujy4tq7EwtzbO65OhhfLUwPj?=
 =?us-ascii?Q?8O0jPnc+3T6DxnFqQOHByrHvB8jZ56chUZcTAD1aeTBaSCMgDqeJTkcS1RQP?=
 =?us-ascii?Q?rUyB95TurtKCy2egXDa7IU9aV+unG6N1WFZzHeyJkbuXS8RWoUEyTsHjv06W?=
 =?us-ascii?Q?IggXndnDIi+W17dHrAwMAScOx/5dpA5XpOEN+3vFkbKfMtj3eLxBL8MUxoLN?=
 =?us-ascii?Q?6kVlb4VuvnOLDEAQNOEd7FiT8oI9w31cZx4bgoWJW48WBmGyhQQtP+rtMuHq?=
 =?us-ascii?Q?m8q5HCijoSrx9yj7X2ibSiEl0fPREFgGJoQr8y3BPXV78GDekXHdDbY5G6Ip?=
 =?us-ascii?Q?pmu6YZybf0CqK54LSybA++Wf35qKVZg/B/U5WuftoNQY1pF5OWdNb0Jrhmoh?=
 =?us-ascii?Q?VRS+JZkpyMekiLg4DvWh1lNjA62OW11R/k+77WANrohr9D+om1Qb8mL/Qo0z?=
 =?us-ascii?Q?JQnaiej4UsYxGk0fqwV6lR9ABBuxSuPo7NCQAvfE6aNzAjOal+sXqgj7d0Tt?=
 =?us-ascii?Q?4gQFRMUN+zA+MOR1sYNlVzLrCnRiYZoAm+TjgBH2u374s7bOs9SDzpgYYrRE?=
 =?us-ascii?Q?mFmupM6ibtNtB+iWt5G95DsiW+ZwIeIx/BtVvZUjzeNis0ES7u6MClGG6JWV?=
 =?us-ascii?Q?MHvkKUoVgy0WzvtFVTdNKWlXLiJclAs9Ayt6DP9wUYh37wq/f3Y6UV07UHQq?=
 =?us-ascii?Q?QKG8KqIDBkPWR/+ZG/FDuzK08tAfwLwRF+6q4KPbBk210VqX6IBqWdi/ZlMO?=
 =?us-ascii?Q?8FpNq1JrmkR7HqEvn0yoyf1nChj7hEVu5q47QfOy8F/bKb4P0e9Mra7kINFF?=
 =?us-ascii?Q?SkgveUQRmsSgGKIp4MNqS6/J7IG5JQwXWsYCJSqvnYnKTOXKD1Xf9T8MmvEh?=
 =?us-ascii?Q?sGzqYMTQsNrdYy1OsgwxrhQ+5QvJ7q3ss3AGFlvBjB+UuBzSg+EhHD/6IkMH?=
 =?us-ascii?Q?sv8XIItQXFDb29pw4Jk8J0s+z2TBakQSN8EB+Sf8F0Ksgjx9jyg58J4PNAVh?=
 =?us-ascii?Q?o3bECFOJ4LXHqPYQh2OcTI7hdA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 20:49:46.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8e7333-c40c-4d17-971d-08d8b1bb6ff5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEgq32VBHisExRHKIcudRftqCwdUqJVe9EHOYadK7I5wK1JYmHVuV98haieOpBev
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_06:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=911 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 07:20:47AM -0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> 'unistd.h' included in 'selftests/bpf/prog_tests/test_lsm.c' is
> duplicated.
It is for bpf-next.  Please put a proper tag next time.

Acked-by: Martin KaFai Lau <kafai@fb.com>
