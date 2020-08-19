Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF424A7C7
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHSUfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:35:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36122 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgHSUfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:35:45 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JKXXgw029653;
        Wed, 19 Aug 2020 13:35:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DwS6bi1miPaNpVggIz4bc3bR7PQ5B5k+R5q0GfiTqFk=;
 b=FqaFQqJzRsODROq1irFeFGb5aXLX53G9izw20X5Q5AnGGXJU+Z70dHic9uT05fAQSnOB
 n6GIN77AccC69V0MJ5iFOValVIckZVa+GMSQ5dtddGS5qLwjmn2djv0JOVz0jDnZsmx6
 Lr2NdvITUtDuHp2VFMYxlK4hMN0e4MUYfEQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m32p5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 13:35:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 13:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JENwwGMIeEnDslwle+ed/Ogs6wLdtC0s/lVVorHC+zfH+RcStxw/U9+9cxBs2i3HM4lg0Sq5/gVn/mTkYwCdurAxFFDHv9T3JLqGP2klwgw9rGwQ3um8RqJGhCKzQPYuidDZki6hiBe8x59wLKxLTeJcfcyLymQbJWe+w3w0SFdRIfqEdT5JxhfF789nzWGE8H/yM7b5YvZuWswG5OVl+zOHvS+7yjrBZH4vMmfWDzSN+kn6k83PhIReZ3u6UXx5QQjZIc91MfsSBEmLK7X64Gtl651klTJUKs4Ee4Am6GgcBJdVG6FyLdYwSYi+t17UQARfX8WDsuZ8Bog8Lmb1uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DwS6bi1miPaNpVggIz4bc3bR7PQ5B5k+R5q0GfiTqFk=;
 b=MztZWk5WwHyrQC3KpdQEdxEF6e4dLmz/UpMQbdvGWR0DlSysUGV/dQ0+7f7xaoRsZUZ2SJkxT6NzFBPTD6kjK3jS/d4CwAnp8uS1ZP8j26DOvApWLOhlT+UaKErs+2ZHHLLulpb1FsdmboqZ6aL82d4JvmHEgItbeganS/a26UiFo1TqWYw6KQmb54RJ6+Ghf6vSZlKUfYZi+JJLnZGUJA11lMlNj3allojZYbNvDvHd7R6/3g28BFVPigptz9kL2dlzXR7ggS8z3kYGYGTizw0DzNawxmEUz1bRwWwrGQk4LSluxJ3hW3ZmKWsnJPugkiuMt8ih8+lrBBNtyrq76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DwS6bi1miPaNpVggIz4bc3bR7PQ5B5k+R5q0GfiTqFk=;
 b=gqZlhSkrLkNiLy9tnEziY/IuG2hgpYnX8pcI7MZSw535y5hEmO4Bqu7I/epc3zEwEYPCVn8Sfwny8ZDjByx8QU993PlGogg8RboP+u882OVXvHRK1IVWZxNVgLJUl2tK+mAhtHsR+bd+cLmL1KOO5sYiORdc3f/nRmAltJSViMI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Wed, 19 Aug
 2020 20:35:27 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 20:35:27 +0000
Subject: Re: [PATCH bpf-next 5/6] bpf: sockmap: allow update from BPF
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-6-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <903adddc-1615-f5cd-ab56-c7c1e2994480@fb.com>
Date:   Wed, 19 Aug 2020 13:35:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092436.58232-6-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0111.namprd02.prod.outlook.com
 (2603:10b6:208:35::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by BL0PR02CA0111.namprd02.prod.outlook.com (2603:10b6:208:35::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 20:35:25 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c38aab23-62a0-4b56-e44a-08d8447f683c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2693D9E4B66D61D4774EBFA9D35D0@BYAPR15MB2693.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URGu+Tj7y9zu24TZfhg5XtGFJqi3N6GG5A4kQU3fHl19uuL09lR059V7MBcQ0KaOP9HudDpl5SlxakQL+7B8lafpV3KN0oQO9PeB1PJBWOAJBNU3SuQzGsbgBX1SEtrmplOZ2U2VV0gC+t/ILywRMcRL/OOK2U6pgRR3LxmHcezjDXBzx7uW7/0VfYVvrUMoMDmFeGksqtlLVeqioqa9UMMmMRCZwLOqsteohz582ZQBsAi6R8ZVCAFCnXEhEMyRH8R3hyUKUi6HaPjWZejjcT00wYF61P/A100gnSo01+Bgw94uSLDtL454qGU0aVaMo1P9fZvt3e5aOGektHxrLi55iIahoT6l4Z61OmKW8w4s6bGmTn1xSTSvyJMv/Uhw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(53546011)(52116002)(66946007)(478600001)(186003)(2906002)(66476007)(110136005)(6486002)(5660300002)(4744005)(86362001)(16526019)(66556008)(31696002)(316002)(4326008)(7416002)(6666004)(31686004)(2616005)(8936002)(36756003)(8676002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lebW+hDkrEufSfmEFNyEmFPFhBh6jBRZoAQpkmVJMTwcxtQ2jxSBZq4InUsBFpe0M/l+ZHpbPFCD/guCluogBgT3g7e81CYaDR0Bm513Av6tnZQdvGq8HVnV5ZoD9z3cu5KidIgwwQXDLJjiOwAATQIF0xVs40pTFe7Qm38tlxhwU3Z0lLbHH6fNHprjRQWTsXPC5afw1I2pIphdvvndsDe/YdcgUlNI6WtB1L1T8TvIYOu6YiR5o0vix7Ur+9qhYBWnqqRQ4a9px1Q1cGjU4EZINyvxly1XJDn7qa4THb+1bk0AN/eA1ewUiSDCxRdbvmr+qomTvKM/zKIwwsmtPQT1J8ThLqiGv1BfPCDWb6+x6K+M43nsGDO9krhOtzC118kYQ7rGEk7BLLdkoR7jXTAUKdIxW+V7mNZk8uOCP03bOo67C7BNpIq6CWe63VMOvTindlosnxK8PGT8Kl460THsq3oh17gnM8fTNXDIPGo9yJplVxgZdSw93z7JTSj8CUUA5cMneAECeey8WcERFh+4k5VSD8EORWpp9B3pC9zdtY5PqVApm3cgTgOoL07qKyKRQdbwVDv6i9QXXxGVxDXDSUpFPCyCoY4XoMxtJADl1PxiuooUUCvLfBqVy6hNkPJ9eiYTWKMjHtyDzOwJnuA71OczZfoP8mzYc8hlV6Vf5aqAEkt4PzKDl9WIhjSl
X-MS-Exchange-CrossTenant-Network-Message-Id: c38aab23-62a0-4b56-e44a-08d8447f683c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 20:35:27.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FLUH61p/lQ8wvtuF1+2W6bRd3Pn+/lPCz8UQl8DhykDsUXyHjUIgtA5YjRMUC+h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:24 AM, Lorenz Bauer wrote:
> Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
> context. The synchronization required for this is a bit fiddly: we
> need to prevent the socket from changing it's state while we add it
> to the sockmap, since we rely on getting a callback via
> sk_prot->unhash. However, we can't just lock_sock like in
> sock_map_sk_acquire because that might sleep. So instead we disable
> softirq processing and use bh_lock_sock to prevent further
> modification.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>
