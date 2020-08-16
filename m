Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA54245628
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 07:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgHPFsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 01:48:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726985AbgHPFsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 01:48:01 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07G5i3OE011887;
        Sat, 15 Aug 2020 22:46:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=V4o1snjal95R00cUfRG4SiYt3+IkzQaFaCqaANmULjs=;
 b=NRka2OgZUkKbMT662lbBa+9GaebK7OxOlUqZAD3H4bg99sm7zl1FLD6eSomtdDjlGBqM
 ppZAHtlutrRH43xttBXxJONWMYEvJAoT+gC08Xaax5boKjPKnS5LSwvQsriCfznjY9To
 BaxL2iOdei/nUz4R5QbhPmryYEWS0IZdYzs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32xb6yjx8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 15 Aug 2020 22:46:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 15 Aug 2020 22:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwZcOMp1Int2l7qGEJ0qBThhmZOgMRLkZVRPmNUYCey3J2uKmcHyeRSNrjEZZjDP9h3gpG/3IYNR7GD6n5u9gjFG00X1V4Q4k1e8aDYu//iyIbnAaD0CQAcfRJiOIb9vOhQEvu5a3ArVW9lf/VUw2p9OMrjJ87MY7gg7Hm9c86xo8NETeMrptdqGpGI1DokDlmpqkr5J2b6Vppnd0TjNqDjaQLKY17mMCdGuxt60wRu7tLgTSPc4o8drovwCymmdd7YiPzDMj4RFIFhhUMW+5sOwwwtVQBT/4WykuQgtK8h5N0dxejDH4uykt6q1kqcqSzJKQpDBtTN3/l++EITwrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4o1snjal95R00cUfRG4SiYt3+IkzQaFaCqaANmULjs=;
 b=DqMCllOqP8cwSrmusFp87FTzrqLD2a7yCh6RCR3B3iiI9QBz7HhA/IvtdZOyZXcPdweJznrx2N6DrUI2ftpDG7nad35sF9e2DIMCSLqPOGF0xcAoAvEym30yWFEVeL7AXdTt0UjKq6cNFkrYK7CpMwbHQsLjC8Ol5HpE33IhLpnGW4Yu//2yOLPKd4rWZ5YTBqcngrreb0QD+5jVfxtCaOy1DxojfrD1Ks5XikXCPHfyX9zUfh7yuUvOCJiQN5K4e+zSuMdNL96SLlURQonyANU/INhMgdF7GFi0wLPMnp6vzj88U/xqH+duAhisMXiYFFsWxDFvL/ujotXn5wHhIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4o1snjal95R00cUfRG4SiYt3+IkzQaFaCqaANmULjs=;
 b=LaVsMh+GD7SKsH+Y/hDwVGY4O2Ztla9T6CxFMGy+9BCX+P7+LjovslKYMxLk6ACJpKWqHfcY7Mf8Iz1A5sH0KDQbLkuv1v2ZWXv0QxR3X9xygdvX0NhNLlApDw5h9J2koCVrrsVE5qYFKcgrDTaHDP3OeZdU/wWrDifMLGR4N9s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Sun, 16 Aug
 2020 05:46:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.027; Sun, 16 Aug 2020
 05:46:38 +0000
Subject: Re: [PATCH v2] bpf: Convert to use the preferred fallthrough macro
To:     Miaohe Lin <linmiaohe@huawei.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200815084745.19291-1-linmiaohe@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <893c196b-661f-cdad-7171-6b7946e179a5@fb.com>
Date:   Sat, 15 Aug 2020 22:46:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200815084745.19291-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0032.namprd10.prod.outlook.com
 (2603:10b6:208:120::45) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11d9::1056] (2620:10d:c091:480::1:df42) by MN2PR10CA0032.namprd10.prod.outlook.com (2603:10b6:208:120::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Sun, 16 Aug 2020 05:46:35 +0000
X-Originating-IP: [2620:10d:c091:480::1:df42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aac91bca-a0ef-4f42-bab5-08d841a7be39
X-MS-TrafficTypeDiagnostic: BY5PR15MB3666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB366625405DFFB1880A096B7BD35E0@BY5PR15MB3666.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4cDo4o/kFp9xrN6acYnBAHemVh66KGp4S9cbwgxlN+aM+vWZ7xOTxc/Q0o9SGFQ3TqMF9rP61DMLm1v6D07XMKQ8Ub+iHXgiBuSEPxolyYCwxgfI0JJ96zOJZOVGIMUWsR8Iz0Fe2c3M0+QFVW9oJInxH21JAxv4umY8wWSSGsx5QAcNmBUKUDPV8x2CUL54MOfpVaKbpTnV+YQuKkmZX43rNnknRb27wX9CnYqgsDPY9pUNcVKdJC46wKr4EdoTcRZkgx+f00AK/aKniv7ryNK3pcrA4UXA2rJacHl247AlAS/0qQzyeYadhDDZffiKymdhNFyw0LvYZixeVNTd7Tr7hC3RC8KiN0Kkm0MLFnzQ+2uWp9z2AXYftq6XPslUK7+/1IgHqhZoqNmMTymp6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(316002)(4326008)(8936002)(8676002)(31686004)(7416002)(478600001)(53546011)(5660300002)(31696002)(16526019)(186003)(4744005)(6486002)(66556008)(66476007)(66946007)(36756003)(52116002)(86362001)(2616005)(2906002)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WaKYJp1uyhtUuI1oVtCYIhuzB95BR20Jj3VXfEuPvMhzeD40eeD1vfLij5i934dXgLfI+bK8uNo7/pf+cJOy6jj6OWwEWhADU+bkChEQvzN6osq5npbc0mP0/OefHaOOztg83vAPDozgTmdb+SHVML/H6H6ZYWkPeA+qaObUgnwZ1sO3YzW1OEmWC5+sOo3EFhePk9Buw3wSw00HizWwL62wyYM/3FetBep96HnSrEZuLrz9VZxsZ2Z0eF4timSxZwxjP0MJiqdM3cScTgB/PB/El2h2QqYVEgtg/5nlVu8xqygGj31GXOa2edgtHbgGi4ipU0vgEJn3WwnQz6fOLiB/lgW7SjZ25Sv84j0jjjkI6ToMpEw9NgPpp4h5iZq7FoT0crJnudLETSpcUJHZUVwwe+9M93un8ScHVC7vmIMLnV0/ecc++XazLFP59OO+/VaN89C/J4RGzjtBloXTswtffgVF15mLJ8/kCZg0jSJYUx/K8wHzLPz+MjrlP2LtignHsms+D7TqLdx9e6s2biFb4VR1gmg344v0xDbU4TYerXebOseMV2ijAkIzwCHWUraiKcGsb6YkgGqWmTS7e+rj+N30EXECbgss5LPqQEkLNQSgcb168xtGudb15uBndPJ1+CAgvmMjQi5zwLBzKyY5Rx/aLKUTip8Z/IbY9u4=
X-MS-Exchange-CrossTenant-Network-Message-Id: aac91bca-a0ef-4f42-bab5-08d841a7be39
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2020 05:46:38.2781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFaRKya6i4i4F3QbbDW4tjrjhWwTTfh/NiXQVfJnPDPiKdEAWqtOE18Vf5TGSBhL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-16_01:2020-08-14,2020-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=851 clxscore=1015 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008160049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/20 1:47 AM, Miaohe Lin wrote:
> Since commit 294f69e662d1 ("compiler_attributes.h: Add 'fallthrough' pseudo
> keyword for switch/case use") introduce fallthrough pseudo keyword, then we
> should convert the uses of fallthrough comments to it.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
