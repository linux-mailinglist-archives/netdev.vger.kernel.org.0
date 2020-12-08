Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE242D23F5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgLHGz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:55:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgLHGz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 01:55:26 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B86mAu1007509;
        Mon, 7 Dec 2020 22:54:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lxOHuvlJohy0YiEC+M4Og9XSdkRLXfBTqY79j0eXfUU=;
 b=i91u2CTDzxGRgObkZ6xkezpSt+9YNo1d0Jm1luigegEQcYSeKH8ILCT/JtIHWuSJG2jC
 cJePlzKVx/oIJudYHuYy/vBNSNh+XVM1y3MLw0+ZREg6LxDELijoBdGlCWKyRG+TifS5
 WeaZmGMYO9lsTDStolsqLU79FJGztUKJikU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 358u5avd8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 22:54:27 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 22:54:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZspG8eWd475h7j2wtFfPF+5DlyHAcaUk6TSF5ixRKFhRr9cbo4PHkQFn7d1cNzOqsZQS0hpLquTREiGvPrvgPN1mTxOkRwJoyRCA6V9jzmGEqOoZF/8Ee/qKitH5lcB8P7udB6NTLVY1RbL9WSWS0lC52F6g3d3dJUz4bJLUr3I6wC4ujcZLNzS+zzELAiG9LebW/521QD96rPK4ducBOqj+H3LL0DYyiAncIbjI3b2q6upZ++Lliaqzcv5PVhQe42cYrv8tJmKhRXRquU9IzK6Ucey1Pcix4HHAk6Rj6QNc9cczIU8eyOreMAW6AFbl82X6/5iqNQV+H5GUQB3Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxOHuvlJohy0YiEC+M4Og9XSdkRLXfBTqY79j0eXfUU=;
 b=hS3ro6lDUEcxxZhJvKNwW4ehFejjkrD/GiUbhY7uxOAvtLg1ZO2p/5A+np1OqC047DYxk77tWrttdqHYnXo1GLWj65u/hjIiLeQdBpZb+Q5+Q0YeGMOOEpvxzp/ZjpmfXVlNzYksB+fR6c/UUWY2WptNmt9ak4YNZXDWijFrQ3hlO42LHUdHH5atsxmFc9cQj5ieUyq8iBCK+aYo6OzV4o3sMxZ6RsgIOmXk1Zdu8ibh48D8WebdV9r1jvr5oKcTMBIptJFfKUIhVn2ponlK/3xkJU3HXt9HveNMJS2MOHpeIVWvaJ05fua03CsTVD9VCIbtrkDQnL6bBGh0rRPbbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxOHuvlJohy0YiEC+M4Og9XSdkRLXfBTqY79j0eXfUU=;
 b=dNyc5jImGWwhEpETId4hXe7jn6Vxq2fyeNz4DsNkVWBPlsefZUQQue4j3mwhmjPtBnG/Y5U/ekrT8nrWxDmS7EnEdAg1onFjBaBNnfLNFNnu89q8G1nlMg8Ahsd3hoxD+Gni3SKL4RGOZ1RNq7L7ncwTKI6PSWRYtCSMmP14N18=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Tue, 8 Dec
 2020 06:54:25 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 06:54:25 +0000
Date:   Mon, 7 Dec 2020 22:54:18 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201208065418.ne75jprdbpglrgal@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144418.35045-4-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:565a]
X-ClientProxiedBy: MWHPR2201CA0039.namprd22.prod.outlook.com
 (2603:10b6:301:16::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:565a) by MWHPR2201CA0039.namprd22.prod.outlook.com (2603:10b6:301:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 06:54:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6406f7e6-fb96-4425-b208-08d89b4619b8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2376C753669D9DD216F941C0D5CD0@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUmm6ZQMwHpoFQvRFc9reGdHt1dnH805gV4AVUx9szA17vo4y/cr1c6RxuN/uGcj6VsVf7BFQtf+PwZM1gVPumT6bwOkQF/WWnY4/yxXBnoNlOGxZTFyG277xJvdLj2JukB6cVgkE3BBjoG4roou65z80nniR5lgBWyL2AoIMs7SOBZfCNHXR3rU8zuJp+CryaNq6vVYwocnoXJp+h06dwJXzLVj10j9WdYPTU6jA1uQ7/2SlbvsEXQlVmpF//YuVfWGXNMM2HhDkU4muUtTEmtoOcaURz/ZXvq82WYGmdIdmlDqmQmeLuySe3kRks+v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(396003)(136003)(16526019)(7416002)(186003)(2906002)(86362001)(8676002)(66946007)(6666004)(66556008)(6506007)(478600001)(83380400001)(5660300002)(55016002)(9686003)(4326008)(7696005)(6916009)(1076003)(316002)(54906003)(52116002)(8936002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3oppKC/lQd8KNNa2JTgu+0pofBc42PqGwg9O1o5NkLltShFjpbw4R8UCsGHH?=
 =?us-ascii?Q?tcbMd/3ekqx4NeMH6BWUpud54OCjNAPBGjdyS2sh3D49N1NDBWKKNYlMbzWE?=
 =?us-ascii?Q?VoiQlmwRnooUN/pj2lE9/XEYxgimzfobcd8Xoc0+yeOxOXpT2Q+H3GMlSJIY?=
 =?us-ascii?Q?FynP9fCOcvzQLT0KOHwDeH9lsxh+kzexU8aK/p11pM/RZd5U08loHr5bBrVi?=
 =?us-ascii?Q?rSM8+QgjcDoG/uBenQqkRRnZSIG7lHT8H9iF62GfBqnmyzNtIGC0Itnv5lFW?=
 =?us-ascii?Q?HBCo5p5ea9WLJLaCnHZGMirl8hgMskOvdOIfeaai2nMmfOoZAXyZkycqx5i+?=
 =?us-ascii?Q?GU9TIIPZXz0wFrWFq6af4KwfmCYAElkMjOTPMgQi0NHJwQ2rHek26AXKhyiw?=
 =?us-ascii?Q?exwvi60AUVwspqaK6vMIRci7PBMpEils4thM6viriJ6KeOUVFoPO6o7ffaIi?=
 =?us-ascii?Q?uoTwv+46pvNLKZtS49Mcr88ngvHBxPhmyW1PprYmBCTVtb+G8qkCBdKj2Rzr?=
 =?us-ascii?Q?yvpwxazticn36UZfzhYw/25JUme2B3vCCd3u+Pay1u1MxL8Y/hO5MARwul44?=
 =?us-ascii?Q?etT8qP22DAYB2l4k3xihhRgAs6sbQF0o07+vQtd5kmBHSaqOAbvWAD0XjKQY?=
 =?us-ascii?Q?DBfZgLMuyBfqwFggYZsoFMSxFwow61Zt/TRHgRYI7zh/zByrklXeb1j9b2Mf?=
 =?us-ascii?Q?Ebhz/MkzmkTwxU3Nsn71WRNydXCfeoYWR1foaiSMmQyD1Q0+GjiMzGTAlEkv?=
 =?us-ascii?Q?CNm2KblpwukvRcNaPPvO3kiMQB28NhNNsPrRrvUO4kejd2aU7y6upgyMZQkp?=
 =?us-ascii?Q?MA4sGskP/sePEaWSOpLytARS8bQbSRfw3hLv3uKFv3KVjXXzMqf+6yW75+ob?=
 =?us-ascii?Q?hWgSD1zqQBM6148uNC+npLEwYPaeAKcGsKOP36MimjB6jCVPJ6HQ9J9LlXiy?=
 =?us-ascii?Q?vljjnHoTLjgeL0eOhCBpKUnpE/I2G8vbPsTUtKJANYtsMEgdFxY8kuS4s2ym?=
 =?us-ascii?Q?4lx4Z++QdDBCPeimU21CrCmuNw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 06:54:25.3506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 6406f7e6-fb96-4425-b208-08d89b4619b8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Au1FKFtsUuJlt5CMrSUJkVmywEX1oYxH93K9kaZQbTM/EzOFpawFvrYqeF5+wb1x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-04,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=5
 malwarescore=0 adultscore=0 mlxlogscore=528 bulkscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:

> @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
>  
>  		reuse->num_socks--;
>  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> +		prog = rcu_dereference(reuse->prog);
>  
>  		if (sk->sk_protocol == IPPROTO_TCP) {
> +			if (reuse->num_socks && !prog)
> +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
I asked in the earlier thread if the primary use case is to only
use the bpf prog to pick.  That thread did not come to
a solid answer but did conclude that the sysctl should not
control the behavior of the BPF_SK_REUSEPORT_SELECT_OR_MIGRATE prog.

From this change here, it seems it is still desired to only depend
on the kernel to random pick even when no bpf prog is attached.
If that is the case, a sysctl to guard here for not changing
the current behavior makes sense.
It should still only control the non-bpf-pick behavior:
when the sysctl is on, the kernel will still do a random pick
when there is no bpf prog attached to the reuseport group.
Thoughts?

> +
>  			reuse->num_closed_socks++;
>  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
>  		} else {
> @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
>  		call_rcu(&reuse->rcu, reuseport_free_rcu);
>  out:
>  	spin_unlock_bh(&reuseport_lock);
> +
> +	return nsk;
>  }
>  EXPORT_SYMBOL(reuseport_detach_sock);

