Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2A527F070
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbgI3RYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:24:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731337AbgI3RYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:24:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UHOFxP014724;
        Wed, 30 Sep 2020 10:24:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TCTMHo4QC01TdwgziCyXtO2soos/bOmvE/3kxFrO0oQ=;
 b=ApwD1RkAQFt5hRVubXQ7dP8YHnkJlSrwXfpbEksS2W3WYSO8Hw67CovErOR1+fckxDuW
 j4Yq7On0o+FXA0tAuAVw7uQRyTg8l+TF5xSEEmJSaxZPbWkt4jfwUiBampIWhbTHGU58
 JFmEc0Kth2RC0sLJwy4Fl/wfQxDNd9bJxFk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33v1ndgmew-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 10:24:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 10:23:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj5zvZ63jHrh4pkPO6VB4dCJrFin04xssriWGq4RqHj57/rAOVsIE8bsY8iiBHJinAiBH3JbJvLYowPdH4k36BHQqsyL68xdprT9l1n31xpcAe4mLNLJdBC5miPMnZhzHpg5a8lKu08O0mF2g7EZDMDTDx1djP5rJHqMOlbX0ns6uAYFRwSV91C9ARvAE1N8XPTGyimviKdt/1jiGDW/vOq2xERVGKiH0uwNo0TRIhUX1k4YRyte616NzmcMH1X7GTgMInlCSmuNiNudSdWFlPwsJWI/V7Bp0lowGENNZEJ1ZFUr8RzY0bZLg8FMupVrDc2ZCIvfKjziMRAzMaVFMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCTMHo4QC01TdwgziCyXtO2soos/bOmvE/3kxFrO0oQ=;
 b=PS3Kvyn1R4OwNiYTK8rI8BSyeXtchROI6Gx5C60xRKBP/YaR076qgI3wEcPgI43jK+1hCDUenNUC0UscbEnk/csqEurTQjFwbAvNnIM/El/L2HIUnkbhNwKVrTaidfYWvlrpgcoIr+XeIVz42O23PUl9F62106XYKvXXZMh8TgvwMSX7nSO7hkLJGw72dCHHEqC+cyBron5cJW4WJPvjx+IaJWBylXWxSegn1r1kMQxcUDRxEjw7oG+q5mlduNRyP3Tlfwe3Bee3hDEtF/X1BHqaFbZFpvhps/XkUd34yiz79Tn6bfIzvo5oGVpsez4n9fTsd0NrPLqGvMsfToHLIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCTMHo4QC01TdwgziCyXtO2soos/bOmvE/3kxFrO0oQ=;
 b=W7JnOGXtwUq2dXkEfuXs+flmX2ajftroANARl7jtAWP1PhFVaOKgUxWukktP6Tnyohl4+sdoMxwsqvJlaK9iT2n5+SDp2ulHNw6Ug1P0lbzryrfuV1zAnpsyEhbAXaiQ4K5n+Hw2y8LkAIOuC/Zwclmni1H/ZREf1/zsB0+rjCw=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 17:23:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 17:23:48 +0000
Date:   Wed, 30 Sep 2020 10:23:41 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 5/6] bpf, selftests: use bpf_tail_call_static
 where appropriate
Message-ID: <20200930172341.mh6afteekniku5ws@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <3cfb2b799a62d22c6e7ae5897c23940bdcc24cbc.1601477936.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cfb2b799a62d22c6e7ae5897c23940bdcc24cbc.1601477936.git.daniel@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR1401CA0017.namprd14.prod.outlook.com
 (2603:10b6:301:4b::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR1401CA0017.namprd14.prod.outlook.com (2603:10b6:301:4b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 30 Sep 2020 17:23:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a6a212b-5694-436d-02b5-08d8656597b6
X-MS-TrafficTypeDiagnostic: BYAPR15MB4119:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4119E6D7D879F35EDA587429D5330@BYAPR15MB4119.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2zLzFF5+Of7EJQqPSp8aU/89QdqnXJLZPu4GoA23uJEFUAC1d0B6yrl3FSTnkYdFIaEHl7rnHi0DB0VpJe01eIxjWV1PYAaqWg00Mw3SQ6eZ9utcpnk6ETdVuR6Fffs3ECTyJC3RtalT8ozogb1dtB5iVSS6+NNM+H2WRTd538LQWa1GoaLwD82qMzdhvbz3tPrktv6UjC6o4BK3rVJnLiq2fmmuNNxyAddHOdH2jMS+Ha9wKdU2KaPykY5DHeKfTnLVsQvi4J5ie7mE+PrR8xaNou1MgzcQxzik0NuT5n0p/8LxeWWQ9QWhcIbg0v0cWRdf6o5rcdfUyxtzIBcSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(376002)(366004)(8676002)(316002)(86362001)(478600001)(66946007)(1076003)(66556008)(66476007)(6666004)(52116002)(7696005)(186003)(6916009)(6506007)(5660300002)(16526019)(2906002)(4326008)(9686003)(55016002)(8936002)(558084003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 42RFIE0IqvZkwIPXAxSVLSr0mluB47gkZ7putOLZmKyvE7rZrQvP4afLSVSFdVAeknmrAhXRH0SBdnsTqRZ2GYTu/muIuKYVF/NTUmO++p3z90/sDoD9GmFhjWBfRL7kVViIHHkJ+dDmNnGJ6n/Fxb+EeMmyKrWd+PR62j42npgotjzUFCnaWPLV/QM1ISs0q2gwnA3TakKJtrrFY9IfwoF7S0yV9wasl8xKjth8kAqTMQLNhtjtMQe2Brtr+1FXpLhRrquDRz2N0p8rOvMppH+7AQM0RiiuJ0d4fh1fF0RRIcOJQtatCuI+uOkgUT5wQcz31y/ISi4q0Sl/HPTrZ/zCDHSh03RowoRhSBPB4zXWRBJzPeemBN1+cFK4NqzbF+Qvyfpx3rSOU/oEF3fc7A9drS30sHuOF5eIzXosOfk1Z8DVrEH1rNJZ2f3whhBpKgiHuva2TJ0mRpveivCPA8KWg5INWagI3WMMFZls7c6NMmVovrCW8Q5l5GAJtsTNqyoVtJhhqVwGIGodubShU6D1GKMYQnuvrNX1PrnGNbNcVrjwWpSckBp1bdNUDdFj2a1ClLpg3oSsybordh0Jl005glchRNLCc9dERCFoXUX2LjoIA8B4A8ZyBmg178X6h50iyRNcdf02VDsp4CMdkqZhM3EapsGCUDtOZ1dMTgo=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6a212b-5694-436d-02b5-08d8656597b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 17:23:48.6634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6GgpN5K28VwYqs1vtgzi7uB4PGX62wCFRGU9cFffeKVxn1+4RMwttfxycQTeKt8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=868 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=1 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:18:19PM +0200, Daniel Borkmann wrote:
> For those locations where we use an immediate tail call map index use the
> newly added bpf_tail_call_static() helper.
Acked-by: Martin KaFai Lau <kafai@fb.com>
