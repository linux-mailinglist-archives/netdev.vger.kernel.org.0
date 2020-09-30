Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3623027DD3A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgI3AFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:05:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47374 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728192AbgI3AFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:05:12 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U01fIO030345;
        Tue, 29 Sep 2020 17:04:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=IKQ0BM+WpRFHn16c3r8/KGMgjz56U+iQr3/jfD7E2Pw=;
 b=bXCJQSWyYyfLapGqx8K+t550QLDoJ4IS5IYCdL9kHqQSXpBsjiEyEArUABLRSH0ZILXP
 lDqvndGcZi0U+g1QkvI3stQVSGiRuRXkvRh3Y4HC6Fbea3Fh6go+82PISiGWOUIotPzX
 ZqdpW+6ZL+O2/KD/GriuvUyhZQL3NSqyoY4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33tn4tnqjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 17:04:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 17:04:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bl4Mttp8KmtnW4lk7XOzDrOl3+MDLNbLITNz3gp3tuq666ZTBAbYbI3cAa9NJPJZnBXya94w/JRVIwpv7issBW86uwaRKqvM/LpyTC2bctaViEUBu7TjysElSENXR6UaqihMhDlTUKd0UA+YV9rresXOpyWPY3HwrxZ/jVA88f+j7SuKYR/D2j+4qq3NfRCyShJRuqjF5kU0On+6I+J7dVIaHdJzWZkOaJRsUPKkJ6OTBIblOUacvmaCgkrwcJy0+CueRqzZ3cmG2tBEVxGbtmvJgHxXa+rrfpcdMnxr07t3bwu9K2lVOTFfdU0yogjzMc2MxTa0HvQTfdMyFKS9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKQ0BM+WpRFHn16c3r8/KGMgjz56U+iQr3/jfD7E2Pw=;
 b=M0Qj/tUf8pk8zXwa2LjZ8Xax4JhPKJNFlUpI/sLdUuZBk/7NDzKeJikg6Xgb0sMJ/YG6/23FFSLd0N+44b3d5TzZnoNSoTMDEdVUHMOvLl5nH9ZC75K3V/8G40LSoTMKnSn7WT7yG+9NwTxS7WXQckJBcdXNFEFvkBmrCM57k/1DdYlezPLoX8RAa7+p0Zcnab2A3HrQLsAvLIIz8Pbz3t51QagihoRid0dOt8PXtNI8UHRomm2OEqUwzP1XtKla0RwT/myPrahKIMhFD0iZVFk43bI1rzlyyfRTsxgEP4yFqjnKOu6tyjpxr/9PwNxj6wONsCtQEDGZB3jWZC/BYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKQ0BM+WpRFHn16c3r8/KGMgjz56U+iQr3/jfD7E2Pw=;
 b=U1GYQgEFFp+gD3qors1V0ZT0Y4+fMbQzf1DHD0QUe1v5NnHxzFO5/Fusmi/JFB6Vp3GfYkKVO70fFcTbMFoWVMbnIA4YS11fV09+DX3UbS6xSPoQuvyqZRalkLDZoRVb+jGXioZ1efbzAOsQO1De6uD9sbXDRsRkmjdNKmhcfIg=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4117.namprd15.prod.outlook.com (2603:10b6:a02:c1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 00:04:56 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 00:04:56 +0000
Date:   Tue, 29 Sep 2020 17:04:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: compile in PIC mode only for shared
 library case
Message-ID: <20200930000450.zruatcbzfbdfxv5m@kafai-mbp.dhcp.thefacebook.com>
References: <20200929220604.833631-1-andriin@fb.com>
 <20200929220604.833631-3-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929220604.833631-3-andriin@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR04CA0037.namprd04.prod.outlook.com
 (2603:10b6:300:ee::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR04CA0037.namprd04.prod.outlook.com (2603:10b6:300:ee::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 30 Sep 2020 00:04:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54cdc792-e98a-4276-891c-08d864d476f3
X-MS-TrafficTypeDiagnostic: BYAPR15MB4117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4117428F09ECF64ACA5D3216D5330@BYAPR15MB4117.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJLSuRlw1bopZDsxR4TRB0NuCSQhg4Ts9vaRt5O3e1IhUbNlsfQ4U8nkOCqof4HPu+Wv9+gyLEwkhxk9bLjAmNJHeJbqse9N29WAS/WMNOIVkIl0ZBSAOMFjh2ebvVd9OB3E8rvX7LdeQ7jpVluIU975I7S1HoDNeacRMxrTdWC4UVLPvY8gZaccNSq1FINO6bCwbMrHapN8GU2ST/Jo5FIGNaxVg5pKcITPr5d6X0uisOJsK1nCCt7xzJBMPL4lvku1PDvYKlqJuOaHN562K0vx0ts4lK40UQOCGLkgc3RlUXAiQHKm70epecT3BYknN/GqbdJY1wvzeUjSCoIThD71Qkxj1zHwo0i4iglRqiJKEA3psthcvbwGLGVjJqbS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(478600001)(9686003)(6636002)(316002)(186003)(16526019)(86362001)(6506007)(66556008)(66476007)(4326008)(5660300002)(1076003)(8936002)(7696005)(52116002)(6666004)(66946007)(6862004)(8676002)(2906002)(558084003)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 19s6+mn/88XUFNKpPxQ32BSA39kqlrwkHenL/pfM66ZK9cH6oebXne0nqdV0PuzdxsgEtqncgpNedGF0OZYBGzuExUlE+4VLG0K6JWVjlS7zOJTBxBUmqTuuQFOwgXtQAf325ivLYE2dAXabgIKf7LiUiWGTZRZhYH1gd4UzBb9Utb+o7FXDERKgys/vB4ifvVCQVXaUJRwdwigcdtFeTaSexUQKAPenxeHOyoqeIIb34TKu4y3uMJl/MYBx9G7eNFmgj3WtNNBk0sIic6s7Mp00ON8rPZ2BBOdDDjA1OIjoYua/cJNxy5w11aKFD2NWKYU+WFRbqgDLovrabzoB7HjeYvwmIK5PHSzfq4M/5LVYqrsSu8AAKCMGD0rpbCI2yt0nMpoKjhwaVIWU2iOWm8iqaDYbOH/lRZBxo66qK2o/GjzqqTPObRj3gFe1RFPcKYuATpq4zrbPPkEHa2qEania8hhdTbz359vaeTaRULCeBTbT0vSqUGX+2jg7wHGl3qVc0E8P8PneSYADhQqxIERzdOrUGtOiwRNY+IcV3H7Ot7TaW2TQkAVDX4um2+A4etSaBq/GkLOB/WRw4hJnrKsI+zmcIli4fIvzFMHEvQY6cINl3+bI6EfM+KgUgoqo2mlUptG96/ciyaIaFe3iZV3vGQP+Jw5iBpmdLECVJITzaqpe0Owsi7UIgEtmo3Ec
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cdc792-e98a-4276-891c-08d864d476f3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 00:04:56.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGoS/gntWZ83h269dUNFo9X7/j5pzVHLgUFFKg8+l4Cb87hF5I5y8z1UW3jYtIvg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4117
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 suspectscore=1 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 mlxlogscore=980 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290204
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:06:04PM -0700, Andrii Nakryiko wrote:
> Libbpf compiles .o's for static and shared library modes separately, so no
> need to specify -fPIC for both. Keep it only for shared library mode.
Acked-by: Martin KaFai Lau <kafai@fb.com>
