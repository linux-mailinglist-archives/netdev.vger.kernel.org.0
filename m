Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BDE2F5303
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbhAMTDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:03:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728245AbhAMTDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:03:09 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DIsJFh016276;
        Wed, 13 Jan 2021 11:02:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=n6m0dwhnWuAvnKgtCMWR+jBjfbokM0KajJOmEFj46gI=;
 b=F1dZd7tycW4W6pVxurK1OzmiZ2JDm4VM6zznxOCpCdNMImLl7LpjEeaymgqzSNJJkKrC
 nZ3dLm+96ZyoWOqgPqw4OuUg9LI68I80r+GFRCMwv5DBvzqd9gHcR5GdBcVdTB/jynJS
 mvzjU8pGb7A1xWjduochYoGTzgRUsmbYiPA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fppeu62-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 11:02:08 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 11:02:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIhW7l+xPnh91W4cRJst5mTkD/EYz+1gh9TfLIluyI311EWPN/h3bjv6ZoZ1kanw/bGDkEG+nVfsYk7Isy6k3KvmLzd8NYQE1bHiL5+HTYDmDJXrdf3WikfZvuhTVMUDRJEC1Z2fxcJUqCVe2l8sDn1OfYzENetJOvODBoyt6qJJ7zRESgWj3mlFQIIUW/dbazdfpBscuSzoNDBkkSpG08Ebmt4+E3CC6Wq47QXwbNw2w/MBUb00fl78JPJtT8Y83K01B+a13pMmyeFFKQCydsa7JxAi9a3KeT2B7oqIAKFQt1N1opXtiPuR0ec4HsUx/ykbqOzpPy2gOeQzIx2Eog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6m0dwhnWuAvnKgtCMWR+jBjfbokM0KajJOmEFj46gI=;
 b=nAJYre/SUQ8320hjKkBxn1I5E7MgtiPiS43VYIbHhl7NR1GYR0fp8+VPASvy7eZjfHx18CmreuUO0pbL4eNOu4x/fgwb18OiDVxr/LqOKLuXz10B4+IcTYGAf2BH38wd8Hu0ItvYCvm0dC2lzSuEQneQbENLdcfsGp8df9ZNIPxEDcJsQOrHxzCW4vp244/7g1U9TIrgL8lSu1eyaFg0qAPBWEcmqdGUiREtv9YWA37AQ1OG2zigDm4wfykM5zeZrkAAIawjbsUZi62RcRNXVTxPgS8CTlbBcBqD61/VoYo0du0jwUfBDB7lLNvzWmmln++VHvpCTZ9HwCZI4/45Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6m0dwhnWuAvnKgtCMWR+jBjfbokM0KajJOmEFj46gI=;
 b=iGEy9kfwhmCAOU++D6I0kjt2JWPDXkfrEFlD19GiqgjgsUjXnAkfn39des9u5d3gWMNbY5bdxhX0gJuAgw1Ei91U2ejtCWTLtWOpqYNtrn3AGm3yGVKlbr6JD0CATsYhXeWe5XhLGMNNrS3w5UXxP2ra+etksLg3U8BRP4aFyhw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Wed, 13 Jan
 2021 19:02:06 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 19:02:06 +0000
Date:   Wed, 13 Jan 2021 11:01:58 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v7 2/4] tools, bpf: add tcp.h to tools/uapi
Message-ID: <20210113190158.ordxwkywagrrmqpt@kafai-mbp.dhcp.thefacebook.com>
References: <20210112223847.1915615-1-sdf@google.com>
 <20210112223847.1915615-3-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112223847.1915615-3-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:55b1]
X-ClientProxiedBy: CO2PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:104:4::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:55b1) by CO2PR04CA0172.namprd04.prod.outlook.com (2603:10b6:104:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 19:02:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64dffd1d-6c55-4e6c-a950-08d8b7f5b86e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2647950C6E6F5A7A8C8E2214D5A90@BYAPR15MB2647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fA5z6tJ9pmGizLxGLagRDNO4SgRH94hWPJtbFl6jJw1srCAGX9z/u57C1pfYeADFtewTjg4Tgq5VoCMcJzHZiZJnRuBo+NfJMQRIFUHdDDYSjSC+yCXxhR+q+1DLlxiwuu7q6+7DJqUomguv5qcKXjbwwFDsVzFsJgR0SIAAaVWUu8RnQ4qSqprhO+n+T8R1AAGs11DGusVz/NKJoUOHT++jgHIf47u3PXHU8znzfStb/8g5UBjTPGKeWDotdOxqycyRiDBifslIQbax8DZgrIdFQGNHhPfxKKux1AB1lTlt4s8SaUDHj839mA2E3OKtsvdiCkk62V2v1cqqM2PrkBWntub2POYO9Iu1Z6Y5hcOFHiqI12Zua1JWCBKwrE+y5+77FIS+JyIlUBbr1EERvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39860400002)(376002)(4744005)(66556008)(1076003)(5660300002)(6506007)(16526019)(186003)(66476007)(2906002)(316002)(6666004)(55016002)(86362001)(9686003)(52116002)(8936002)(66946007)(8676002)(7696005)(3716004)(478600001)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Edfqvlwy79oVzCSSTiRT3d5ghDJm5K5VgKncWnQuT8vvjWk0/7Ri/KC3Lr3n?=
 =?us-ascii?Q?5w5/CyZOGoKWy+YJ+47IrgptVG5VjGbsu+ThoIID2CUJJwTVF8VoU/PFOKA0?=
 =?us-ascii?Q?qRX/lzq9SEUpWeuXMxrC/CBOVpyTFcvYk5x/oiso3hvB7n08rNixto6aqq0c?=
 =?us-ascii?Q?kzrHfaV407BAbVjN525JArpXp8qlwQNjRBI3ICBPqWZA41hh/XV7KsjKnUib?=
 =?us-ascii?Q?xYSJhhWpUTFVFm3ubvr3ifIGpbG9RgHanWmSrgU84RB4kVUPkjoo4c8kWTPp?=
 =?us-ascii?Q?be7zASKj0Tp2Pdqo5VAYrLQfpK88aCGVlIqZaFLjcrRaBJGWK53HRXfcWRwj?=
 =?us-ascii?Q?0EkSg77Z6lmuhj/Zm7ADjnaW5UszaJNG7395pxbJIRmPVVTfPrv04IpNqj6c?=
 =?us-ascii?Q?m10v64fzycI8ykOdDD6wS7gI35kdiKWMULW6xV4y3CNydvxsgrwSurd836Ux?=
 =?us-ascii?Q?Z4YCiAjJx2ien14A84I7Bs2DnR6nXNwqDetiDsrxwVJd+avV8C0BwwLSr0aq?=
 =?us-ascii?Q?KqWgEhEcRjaXXQn2yelsuIubXsdvCgzR9pjiiffJw+zW4dCBPTyaw9G7blhe?=
 =?us-ascii?Q?dOLkW9pnGGmm6VVBl85+TrQCCv+M1PWaTRm/VF8kg9z1FehWnAGiqX73QV5t?=
 =?us-ascii?Q?hmOWQy5Yt2OlY59PHZGGz2PH4Mszg4pWa9TEDU1zIElUHySftxBNMWKp2I/N?=
 =?us-ascii?Q?I7erzNn3Nz0AOzcMFuQXFtMFaHiem6xOMY1d80rWZZEmuIrSF3UTxFI39CGE?=
 =?us-ascii?Q?7LCcpGZY8Sgbmf0jGqpbajSxmhK182V595pXhPBlWVvmzZxw1Ay3a8KB5MPD?=
 =?us-ascii?Q?LbOrnHJAFfGpFPqhD4rsBEO7wh4ErEdkVjC9vEySdH4HKpEJu/XsZBAEoAru?=
 =?us-ascii?Q?8nHAHja7qcVEvCCq7DgHHAlOz8p7A0eKqVwSdDS7obaL2scWy1Ck5P/x6j9V?=
 =?us-ascii?Q?N/pYfm6qtNmRZqBSgeOfpmqWsXsZCfPdmM8ZNPI1l7RXqBPzDazaElA09QNG?=
 =?us-ascii?Q?rLMknaGxIRdJf5UtrUOXsTx1qA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 19:02:06.1086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 64dffd1d-6c55-4e6c-a950-08d8b7f5b86e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5RD84L/AVQfb17grM7tYFWzz0W28OZnm0jURrx0V3an6P+Dd643iNHWBuwMSM1T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_09:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=899
 mlxscore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101130112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 02:38:45PM -0800, Stanislav Fomichev wrote:
> Next test is using struct tcp_zerocopy_receive which was added in v4.18.
Instead of "Next", it is the test in the previous patch.

Instead of having patch 2 fixing patch 1, 
the changes in testing/selftests/bpf/* in patch 1 make more sense
to merge it with this patch.  With this change, for patch 1 and 2:

Acked-by: Martin KaFai Lau
