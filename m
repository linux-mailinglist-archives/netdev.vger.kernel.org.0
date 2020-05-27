Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D61E4B56
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgE0RDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:03:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728883AbgE0RDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:03:12 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04RH37T4023301;
        Wed, 27 May 2020 10:03:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NTM0qa7M097oTKEFNDFu8B8ukDLXO1qR2oZ5BBPrAUY=;
 b=jp7MqC8P7fOpbZnbGy02fpMVIVoIFF4P5K6V5RXV76MH8B01qErP+rIh5dHjgh0Pk3d2
 KkSMMqAEeGYHWL1jg8QVdYODiFjcHgz9GpBGWb8t0T6Ur8jwZ5jrwiUpGu2NZGqBuQJ1
 28U6y5mAyv/bP//zWTDKYYSvcu+5eo2Xp38= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 317ktsqdr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 May 2020 10:03:11 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 May 2020 10:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIZ2mlADj5BNu771mqG7fYxpZk5X2w/GzSNkvsN6bUKY53cucweiPikJDUeS6NDE3fGuDYckfgiQPor75BKfrbuBBvf7xCWpK6jkyyNv8WE8Pb67ZxMNGrhvS46BDIkctNl4FCLSxn6bIGtkc8FBXEt96eMir1saSxeJm+S8prSCV9maQuJJHpc2152tIz/6TMMTUFpF8D+Cp2tqXm0UwC+8JG4tE8yFLTKwNJHGdGgGt26c5Fmbv4d7b2AnYPTWEdCzHxmMMU83eepOe/oJ9MX3WulR5pHhe005AkUlMRmddIgnzSyRSFg596yPxJFLvkSozpKp+4oMnfPxUvc1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTM0qa7M097oTKEFNDFu8B8ukDLXO1qR2oZ5BBPrAUY=;
 b=Ca49uF5iTRf35H6ZuxDDqlXbM5ld0+OLeXxeGzJ37pUXdtdxCBGXQkz9WyRi/ofpwoII62Glo+Sc8gkzgQqtF2i7ZaTVcFpQGjnLnKZtd0vGZBJpkc7kkSgyHnFwziJR6fVk3nATG1uuiNLCYit/tubugL4y7Ntyd7cHb/EbFoP1LVt76t/ViNWiGg249CxoiW8acK78jJfB2hSA2Dgk1PbGlD31bmbMWwNVICj9BSb65iQzh7Z2WZeUOSSMTuuJbwvxKo/6gCGF8RzbhLUks9tZ6YKLujX/Y/3W3jM7wuCIScmuL6pkxGBx4NrauZEP0gbkfWR7HyoqBeeW8SX1XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTM0qa7M097oTKEFNDFu8B8ukDLXO1qR2oZ5BBPrAUY=;
 b=f7GPLs7jvLsK5XOSmbWmPld9yHp7Y9e6PEwI1JznHSEvNN2l/7Houvkt9c+YdDqpIoxrynohGdWfCGiaQqHNR/jLIxkSpqFSE51590p6SybU6g79q/U4lzlBPrHABRYaU3tnHqFLwdSy33rY2zIXptfnEF/Q9mmBdn3aaORObP0=
Authentication-Results: yandex-team.ru; dkim=none (message not signed)
 header.d=none;yandex-team.ru; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 17:02:28 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.3021.030; Wed, 27 May 2020
 17:02:28 +0000
Date:   Wed, 27 May 2020 10:02:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
CC:     <davem@davemloft.net>, <brakmo@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to
 bpf_setsockopt
Message-ID: <20200527170221.iutwmch6sim35bkt@kafai-mbp>
References: <20200527150543.93335-1-zeil@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527150543.93335-1-zeil@yandex-team.ru>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR11CA0058.namprd11.prod.outlook.com
 (2603:10b6:a03:80::35) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:30fa) by BYAPR11CA0058.namprd11.prod.outlook.com (2603:10b6:a03:80::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 17:02:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:30fa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a5bcfb6-5073-4211-421c-08d8025fbc7f
X-MS-TrafficTypeDiagnostic: BY5PR15MB3666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB366658B7650BFEAD75F56384D5B10@BY5PR15MB3666.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ov89Zwzs6RN0ZTN3vu9poc+imyOldqIRkvofDLt05Az3B8R0a0nL/rVOxczuiYGmXbGugQPaM2+WijoFLIuJYsXoAcC/1MomRTDZRYSfiotsMKNkfaKnUKnkFjU3KBh2iSzECFNNIhKBH9HJp8Z8eKAkeQ8NHl+r+MYf7aNkxd3wJghaLBTeHBEF5Etajd0KwKhdm1c+Bybv95HtqD6Smp8VgT6EcMkhJrsaYNC1z9pfpibFFWUffHscXg1iUWFjR+9FfmYpBxgCTzv1/UhTIiNnwI5jiOS1LvFMnzv4Gl7r7XD23wkzVZ1egtC3D1tn3hTAuL97mWbT6tqrZCb5tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(6496006)(66556008)(66476007)(4744005)(4326008)(8676002)(1076003)(8936002)(316002)(52116002)(66946007)(478600001)(9686003)(55016002)(16526019)(186003)(33716001)(86362001)(6666004)(83380400001)(2906002)(5660300002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rLsojpqiK5LgK10feyv1BvRI9vRFY2lxdWjFysArwRiR14rdiNmJGfB87mxYiqHeOten6lazhtx/yJdC3E2/eWSlc3Dd/lB/zAQm2qmkFyFQ9G7DKPDBD1apcrTsGuJMTGfRd3QEo+lD2lIgwpI5R6gXQqsHAcaOFa77ivxBoydl20ieRpuXHiaxLkPO0bp4FHDdNNF8mdtobiiAb/l7zfLMWRC4hBU4TEjDJTadfyDkjWvHXC50W7Qid6BNyEdNoNfatPbNVRznB6PxWvaaDdUWK7NXsa+53L0JeVGJ5ael7e3lj9dfKilXaaCj76i53XS6XwafeWCKuYLxWTIdx/dDFTU160QKcBvFf5VAmU3fTuCRqq+4bsiGo84K7nN7Z5YAVC9BTJYDS58sAf9v2VIl4rO1x00ht5/+oqVqh8CHtvnC6XMEq2WNqK4KTMeHCTc7n/zzDoC/h4Uq/9RKoJsOJ83eKaCyE7kw2awP5Rl4dC3AwyJ7IRmomh6iqV+/Zn5RG7jzaTC0QBGA29JhZA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5bcfb6-5073-4211-421c-08d8025fbc7f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 17:02:28.3738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWJ0PRYs+NKU2MSN/dEC0PAP3o1LEE3YCaEYG6jWgtyDo0iC9VofJzNe49sqel7F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 cotscore=-2147483648 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=741 clxscore=1011 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=18 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 06:05:43PM +0300, Dmitry Yakunin wrote:
> This patch adds support of SO_KEEPALIVE flag and TCP related options
> to bpf_setsockopt() routine. This is helpful if we want to enable or tune
> TCP keepalive for applications which don't do it in the userspace code.
> In order to avoid copy-paste, common code from classic setsockopt was moved
> to auxiliary functions in the headers.
Thanks for refatoring some of the pieces.  I suspect some more can be done.
In the long run, I don't think this copy-and-paste is scalable.
For most of the options (integer value and do not need ns_capable()),
do_tcp_setsockopt() and sock_setsockopt() can be directly called with
some refactoring.


The change looks good.  For this patch,

Acked-by: Martin KaFai Lau <kafai@fb.com>
