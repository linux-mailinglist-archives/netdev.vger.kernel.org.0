Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0312D1C8254
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 08:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEGGP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 02:15:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25424 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgEGGP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 02:15:58 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04769YYQ012462;
        Wed, 6 May 2020 23:15:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=q6xuPyMzHeHXJvdFFgpISmcJABYdgOaOON/IHfWjb7c=;
 b=K9qsgACmFgM05c0c6VF+V7TiAlUQ64zpP+QzAs0h/b1NcD8adgt3Kxe5nSbz3qSnEzCJ
 /7O/KVTYsEa+tBQRqr0Wt86SrqcP6uwg3/J7KzX3X4wQLdGPtJOM08fNSQjeh6MX7KYV
 4VQdxR+kAq9E+8wA0V2N30yuoOYxfmjvvtE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30v9588urj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 23:15:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 23:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZabFOStC2F0R47ySfFjPwQFrePaGN36LgPIz6D9F6CWpIZ4Y3FPXpgrTQsdn1NuazZlVbgjwRVxW+7awWnZgBNJf0/YfZI/6+6VhkYjdf26lJnac0ru0QD122/Kn94+LRWKHl4CzXzQ1TbKiqx3oN4oksWiLxgSKLKT0qVHWCjWq4SPvTpZSrBguBn66pTRs+zZgh2cUrZFSr9nTPCjPR42Y/8FGBhl4rnk0WLrAra2dcr+6vfnCm/UpdkUA1F/093dpgrB7jjlIln0mkxbfArhkekGtFGEvr9DBiA3ow2zfNCo8ynB64VABmY3wvrEOJ/DmAfCLf8vj5uyxcxXXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6xuPyMzHeHXJvdFFgpISmcJABYdgOaOON/IHfWjb7c=;
 b=LKaGqxPEspusc497OZkGZRh+xG97zgacVDAem8yieCSt+YegN65FY5w3q/zRL7gh+oBBLPwvfuN0S8f4a6r7CasQZXjqrWKyqJIhACBXlPRkpgE7b4quAhOCYeneyQX1AUJhRRYdkc8vR7gKaF/80sEpyAx9PGqlxtl6+Ov/m2KMKhUSCQiCLYqPsTnzZGubLUKVjO1uv7yEguOAHfJNabcTG//ZRZZHc4EPMXPNIUfkpOdjdTI+w3adH04h1sb8jQ0v20TElEqPrrlmo+ycYH2xqmCqaeNl+9sHm1m/WgblvnWnYI+Mt4m/gx3YpKHJjCil0QKK8hkYK3mEAsyVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6xuPyMzHeHXJvdFFgpISmcJABYdgOaOON/IHfWjb7c=;
 b=Td/TrmTsVEPNP3Lh8XXUsF7yxE+32uHQBJZ2KCzLSdHjm0Co+RGNFy4a4HnPBezFr8vKT3B2ZIJS7K4Q6LohrsNVlXHQS+1KF5u59RsVoVQW1opJOqRW7sxa3zLOp9arPgKLdGTODjp+TwYoYpsVrCyFFweyHqrVA3YOpo4H6qE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3915.namprd15.prod.outlook.com (2603:10b6:303:4a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Thu, 7 May
 2020 06:15:41 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 06:15:41 +0000
Date:   Wed, 6 May 2020 23:15:39 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 4/5] net: refactor arguments of inet{,6}_bind
Message-ID: <20200507061539.76tgr5t3weldmu26@kafai-mbp>
References: <20200506223210.93595-1-sdf@google.com>
 <20200506223210.93595-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506223210.93595-5-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::22) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bdb8) by BYAPR03CA0009.namprd03.prod.outlook.com (2603:10b6:a02:a8::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Thu, 7 May 2020 06:15:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:bdb8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a9cba71-ac0a-4e98-b8f7-08d7f24e117d
X-MS-TrafficTypeDiagnostic: MW3PR15MB3915:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39159591B3AA0BC5840D77B5D5A50@MW3PR15MB3915.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPWuTWVtWe1FxDMA1sio3txt31+LbFAkA3ulSFMvfCOLIFrUiSfYB8zCFs5ouDS3Vv0ags+PH3i3NC5chrf13FYGFPyiT79eK/Hs1N9YMMlZUA9tw1+wCHe3uAcLX8xhxXGdwXfRbypWdDx2G/21z+T0f+hdyIE5ESsU2dF/XWUE4uqLtW06MujskewVedYlQm7BBoSek+LyNN0TJ0jwm3bhf30hrRprUsv04MsYAwBsu3GPkir7C/WK1TaIpFbHYNVt8b3Pee0pgmsT6Uz3e3IOOVpsgwgMya6JwTBA91B2sJEc6+DEHUtI6SzP6b1moOPPEltQ/PYQxT1m+61BaDihh2gzc6r182/WqUsfJrNdP41oUAxz4aSd8Jb06mCKjp0TWDRe0KV4Nt6/F5o4nk6N3yHF+beACfSULhD+B322rhpoLr0FvJadcZ3TSrEsTkbJLPTO7nc3SMRTd6tfCfI2y3Ios9lUCZ5y+iVVNeMI7JJuwo+ko5OGvY+Ar4lVApUbLqH1q8X7JYwkqEo46w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(33430700001)(33440700001)(66556008)(478600001)(9686003)(1076003)(66476007)(8676002)(6496006)(55016002)(6916009)(66946007)(8936002)(316002)(86362001)(5660300002)(52116002)(4744005)(33716001)(2906002)(16526019)(4326008)(83320400001)(83280400001)(83300400001)(83310400001)(186003)(83290400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: xw/WLpP78qKo7ch35rHDB5LswnGsrf9AiFEiF5Jvc9uWXx1h1Wj9xnTx5wkkqMV6SVwzuDoeHPd+GmoORTW1CEOhbBpa5Pj2LM3Ul04q/RMw1j8JWbxXsPJ0Nbwb0YPGAt/hih0g0vgUV6tex6MEYw4Bso5dhHpqWuRKDjNJITTs9veFm1uEcZWHVUfxdbYrvwiNDSf2O4Vkjq3DPX0ffVZG6tTdAnylFfDC6xiWG0U1j+O05zMDwZ79olHH2jE+OD5dQuYAZgOTQj0xqMtiI8bgKmKsTHL4mIf9Y/5I5hnHkBjkkYYHsOSMlfoxVvgjJ0pKszhJYDyiYi+Tsven7VaHWuXb9ds8HlBQiRouMuBUXF51O5qEA5Zs75/vL7yhNyL9h1jJ/3MuiuGm7TygghqvuTGVD5R/2n4ZmZ9MxlopUvtZ//2uH/h5FG8Q2ArTk1eIZhtBU+TYvMjxe3xpi2h04ZcwqK8NVY3So6AyPkvfdjmzRJJoeNkxB6/4IGhoyX6o/TIjokZHuQz0oMfaLqyJ27pB9sI1bD8KhmBAyF10kVBLJownHoDeobscOjNUXVk2P/K+SdMVWg4Z41bSloI5x9cXO3p89Y4l7v+Lj0TfM5lERd184EE3J0bDVN0GEPwoThHfU0cBXclDsCTT/be9Htx5bq8MYNdpf9cU2z2Xsav0K/n8rdJ7k7cIuBM9UkfP23E5XjXmDrMxqTWlITNik/r6yUMngrHiMe8qnRcu09vwSrNjncGMZh8u45cYqd2daL7GNsmj/9JIe8S5XTA411bhAhObsHVNwDzzpVmOQGAhz57ffS0Sm5nKeaWa1FdoBHdzMH6SZhJUqC+5JQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9cba71-ac0a-4e98-b8f7-08d7f24e117d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 06:15:41.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/wENQvfJvMFUELXn5TNN3yJ8pjZlnHaF9lmDonMZeamaJ8d66vuXkdQu30tfKby
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3915
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0
 mlxlogscore=796 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:32:09PM -0700, Stanislav Fomichev wrote:
> The intent is to add an additional bind parameter in the next commit.
> Instead of adding another argument, let's convert all existing
> flag arguments into an extendable bit field.
> 
> No functional changes.
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
