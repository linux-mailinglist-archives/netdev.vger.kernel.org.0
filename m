Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC5220BA06
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgFZULs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:11:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45080 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgFZULr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:11:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QKAi56004206;
        Fri, 26 Jun 2020 13:11:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Mfd+f/ti4Fc/IrEojXUd/H6Hsolv21ozDq6OI7+ZSWk=;
 b=prTIJT/rUiVY1aUKNpoiNmX6afgtDzB5kZZUHlyVOJ82IWfFLvo/wqpJxHhaxH+ac11H
 JHtlqwEHk6lFyrVSTXSPmwPmuNkb0Iip+587GbDsijxj6xgtLrglVl6IrCvIm613ieLs
 Zc+0HZsmaNLKsbblpH9VTxH5Khkj8AVKaCk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1ey8jh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 13:11:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 13:11:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPlwR1gxeVonV2qjMn68gY/6ezzGKdZR5eVqQunJHRrj/Jzx9WQPwjb10Ahi4DgeZZhUcCzT9fCu+pELvuUFy3mxIet8hqjS7PeGYAQy/aZIEEbzyAHxj7UMEX0v2T2IvAM7KAZOkHuL32ByJaRMYq9wd93hOl+OvApuXcjQ13vM+Xg9fBzN7DfsCD10n0EYZIObZ18K3iQ0407FxpdTaMTLCN7JBMS7NJ5EYkfWGgz5rVBzQvphP09sH2GDp3k12kFPsy0JR9UrOp3dOiEimDARC7gYVh4m1izjox9DFEFX208KDvMdPbW3bqu3CY1kCP5NLYpfjqsk/MZ4d1yG8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mfd+f/ti4Fc/IrEojXUd/H6Hsolv21ozDq6OI7+ZSWk=;
 b=Xn9mIn/IHGJixUJy+/mVYJSn8LbGH7HRJirlMaJtYJS5wRuea17FhoPn96DUz51t0VOcGWj0mQyh/nWoglq5fYh8utV/9NWnSQsM1R5dgdkqti1x4HoqkE1uiT/WEA2Ejjj6JlrkHQRO6G26BoA+e3xAnWRkF6B4JNGOu1vQA7xeLooamQo6BOhFKrWYZugLG5o7h8fhmHNTzLDcYS+Sm8i/1ZJPuMlt9g1O4tr2fSIZPL5kzAKFQI0a4Bf/1sPipYruymekKNxS93QJQjUx4Fh+rtYfXixnQrtlQSmOzSw5PEr2e6KUl2sNz8PZo7UnjZrJtfaizAtqy5XDN2t/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mfd+f/ti4Fc/IrEojXUd/H6Hsolv21ozDq6OI7+ZSWk=;
 b=J7Q3wqnkTDI7Dq5pOUEEMgsT5QmS0iIrWLajUK1PE20RBSIPmKPLyoF+xHXDJkPhCYbypqGvjvKQ2cm0LU77NfajxD77VTINMnHlashb1/aJ5oG6tTMndw7ma028SN//lA2lbU7z5sdFQDWF4nMBNHYLuKsVRnEMiKXBUM6A2cg=
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB2714.namprd15.prod.outlook.com (2603:10b6:5:1ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Fri, 26 Jun
 2020 20:11:15 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 20:11:15 +0000
Date:   Fri, 26 Jun 2020 13:11:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 0/2] Support disabling
 auto-loading of BPF programs
Message-ID: <20200626201113.vzkhhqov4zzdrrnn@kafai-mbp.dhcp.thefacebook.com>
References: <20200625232629.3444003-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625232629.3444003-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR11CA0077.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::18) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:9ad7) by BYAPR11CA0077.namprd11.prod.outlook.com (2603:10b6:a03:f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 20:11:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:9ad7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 704a11e1-d304-4b97-e440-08d81a0d1468
X-MS-TrafficTypeDiagnostic: DM6PR15MB2714:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2714BBABB30AAA555A222D06D5930@DM6PR15MB2714.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J47jsPXHHXMr9qxv306BNmV2WtEkT0swp3brR9pNcL0f1WcA72NuvVK0Sz2B6253uF6WferVy3JrhCYcEwFaKNAIzsBSIY/SB4Q5Ec6fiEaTD4Qawls4Z1q7GrFAU+fm07VzszPrDgTA3Lv33ZUTp2dBg/RQUDtwrrUCM252gG88UyZWy0JKE5ZDgTIq7u+fqmFGDTRJ9uEsyy2Sx4BO88FQqucRU4J8ypa3XT4Kui/+tiSiaH+jsQ5SYukP8CfseJXwXAR79cR0NGjHsF4mnJSDqKk1/vNlh30siHA6+xFiqGXk1/vgcreOuTy73LKx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(346002)(136003)(39860400002)(1076003)(8676002)(8936002)(186003)(16526019)(2906002)(6636002)(55016002)(5660300002)(6506007)(4744005)(9686003)(86362001)(52116002)(66946007)(478600001)(6862004)(7696005)(66556008)(66476007)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WNtdNVyHp4RI2Wh6cJWXips9CMuf8vfenp3z1YwIJRv8W/6xypr+QaIsrYjpjeiotCLDklGyFSFsEeIDYtYoUqLs3aQXcecyB3xXJogpJZYm/NpXXVSI3VUWW4bVXnO70EtkIkLsIyOmlX3ex/JUEw2J+TvVtIlb1DgOBj/HELLJfbtZF8GyxkL4L3gi7OnC3Tn9xVWr3Bk9qqnuwOtzP0VHJ+avdktiokMKFB5p9HppUA7tB6uDyj5KfVmZ4O8qtBbTWEytGaFgby1uLVgK24/rxlqIjZfKN0Fd2bMGKq4l1DZuLdnx733EkM6lhNkCr5HylsTKTAi+1pc/QxDtRnYDcIhnvXo1ETxNRoPMW/7EuNkZzqZskwsz7hDJA9h7/w/+8zejYRNlEZfunwQo2Ni8Vwlv79kPVUVgGMeMsmVtoWbwIwv0dUvDJqKezJEifuf0roAJf4XBNQ8MMZYGfFsJhs+UYyMK4CSF5Bt7Eei7EyUJ5/JcOeJ2YaKrhwfppdsyQ9ls9+IWK2mEe2ryAw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 704a11e1-d304-4b97-e440-08d81a0d1468
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 20:11:15.5158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7FpJEKzMRb/aQwlX5RnbR7MYtEMpEhhNeJzG62Cd9PVPLT6luJ6h39CbYJxqcN6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2714
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:26:27PM -0700, Andrii Nakryiko wrote:
> Add ability to turn off default auto-loading of each BPF program by libbpf on
> BPF object load. This is the feature that allows BPF applications to have
> optional functionality, which is only excercised on kernel that support
> necessary features, while falling back to reduced/less performant
> functionality, if kernel is outdated.
Acked-by: Martin KaFai Lau <kafai@fb.com>
