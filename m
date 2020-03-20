Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B517F18C533
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgCTCN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:13:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbgCTCN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:13:57 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K28RqM028836;
        Thu, 19 Mar 2020 19:13:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=e5YMeTnTy/eu8rZIQ2p6YPfwMwIErSDsVz1PledXskE=;
 b=Yus2FTYA2x2pQZ9NzN8oE9z8e+/JcRlUZftjE4kgPVhRF9kS6/BUZUFYl8mDqRnTruvz
 sPbhmn0MpOqtg911eQWsiYjiEcISBAhDzYmbQVg3SoeTLyZwAixHhdN3bvNBDGueLNtq
 K2IAvTPFadeg1Oz8KQGVZQ3ZnuH4xbnK4bc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu9avun0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 19:13:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 19:13:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZ+hyjR9hCwqbi2El7NNPr4EEQWvgUajCsJ5Hk+JA2TT1wcFR2nAvno0pG3c6OysIUB+3+QbUCpyMe5AuvZEuRXQn9glGJzQG+9fCiyuDpnPpdKjK8zV91qECDfK14IKbrKMHLfBlN3dsCfEVegzc1f7LYocomeYHHAWaEny9PSoa1pif8eSG45ZE73dy4eSO2dqZUcjDNCnPP+2dMnT7apLU3hM0f8AM0IS0D/UH4ejqZXQtxhLD1+lIsRTRKBt3eRyhA3hmA+riWw7GHC+SA/IS0kWl9ZAQb7UM5ESMQtDdJFusiUY1AR1fPBnsaUQFelFwk/bAiTEoO66TkNBAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5YMeTnTy/eu8rZIQ2p6YPfwMwIErSDsVz1PledXskE=;
 b=PCH5O4Uw7xSRoJDkHgDuqinLdB6Xnx56o4rPW05y6C2AR2m+xZEuy4ylkZ6pShZBT8QmxAbfKNCvkCfXU+laTq5uWa20OIggap5jB0IaPqlPj/03zmJe8PW4aKBRNGcAg1ZBUMDcLlbK7E1ER9SW6WYUcYLpiMRgLrdmCCuUtGGAkSd3WSZB0+8UV9AieNJFTIpu2B7n5DuPtmleDdapQiBZQ8oV3fUZYiGEa9Uzuh7Eyu8S0kda1QKnDmXNlfMA1mWXhveJEihH9+GpRfAZPoEHx85/FmngZtbvI1PaxxcmhCQcJvDhP1/LclN7DLgSKBwjqrbarw8tZ2TAQ4apMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5YMeTnTy/eu8rZIQ2p6YPfwMwIErSDsVz1PledXskE=;
 b=VSv2xdCm4KX01yGhWk8073XTXF5VLEnRhqadZ8gTbduJ8/ylnAaIBVDHoAw8BjzWDie8daDfuYY49i62NFTfTaRDqxspmC/RZlz0tr+591yz15rq33wDeO0n16xeHy+mUIFrjfdus3J0wjd8I8duTTk38fm1mdhrRw0kvGnez5Y=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3865.namprd15.prod.outlook.com (2603:10b6:303:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 02:13:37 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 02:13:36 +0000
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8bfc64a1-f673-51d3-6721-7e8596e6295f@fb.com>
Date:   Thu, 19 Mar 2020 19:13:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <158462359315.164779.13931660750493121404.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR04CA0192.namprd04.prod.outlook.com
 (2603:10b6:104:5::22) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:c5b) by CO2PR04CA0192.namprd04.prod.outlook.com (2603:10b6:104:5::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Fri, 20 Mar 2020 02:13:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae71e552-ff4d-45db-a0d9-08d7cc744c5f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3865E8128072342FB3A62011D3F50@MW3PR15MB3865.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(5660300002)(81166006)(81156014)(66574012)(8936002)(6506007)(2906002)(7416002)(2616005)(110136005)(316002)(52116002)(4326008)(53546011)(54906003)(86362001)(36756003)(31686004)(8676002)(31696002)(6666004)(16526019)(186003)(66946007)(66476007)(6486002)(66556008)(6512007)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3865;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5tIvc4i2MIfBMd7BS2KzsoRuYaM5VGs1CUwnseKFd9KQN0evfHNdFL0pyug4Tro8q3qHUrJEziitc+TLbbyuqPfCXeOcWcHI2jcYxsTXm2F2+xc4tcK5P+zZcmD/9CAMF5qVBQHRmatV1I61WDssjlwoDNbI6jSMrxaxr7YjITyXPvutSEq+/9StU7VpEHw45/psXk2UEGISovqLRHmblNM4b4H+UmUev2zG1HQyUGDMpRfzsdR74S5MpXkbsgsIjzuGzQYf5ob/+EaAzrf3UHJZKPr/6aogfPw9CawAxS0y/CHi+DbMgZH+GtPsQLWEXwAZMRZL3V1Xlq74DBClU9iqQ5UU7crWpNvy+4UDf/4Zcpd3MH3x7TndEphw72o9WS3IH13Fn8mOnSfkmwd4HsgY2dXDMe1/Ki1hWODk+9yOusqDuusutSayHiqpCdS
X-MS-Exchange-AntiSpam-MessageData: MOLpY8XTcFpBSNYMzJqzRLY9FFZykqOF0lN2AYWaTf96sGFZ/1C4Y3+jF0KKZCefS14TfXxEPl6yDurEfPzTBPyPyO8x3ZmqQyNLC3ZS5I28Dp+ZuCgzIBTOS/u3PgbAhWlSIdMkVGv9crgOVask40L6xZlHgAwmcJi6bZuryZBe1JhDYVoY3j7Am3FIvJgi
X-MS-Exchange-CrossTenant-Network-Message-Id: ae71e552-ff4d-45db-a0d9-08d7cc744c5f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 02:13:36.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwy3sshY5eGqWtagIbrZri+GyAtEGO9kntkEZeyiEwE4aP+V4vu97bbg5XQXicgb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3865
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1011 adultscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 6:13 AM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> While it is currently possible for userspace to specify that an existing
> XDP program should not be replaced when attaching to an interface, there is
> no mechanism to safely replace a specific XDP program with another.
> 
> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which can be
> set along with IFLA_XDP_FD. If set, the kernel will check that the program
> currently loaded on the interface matches the expected one, and fail the
> operation if it does not. This corresponds to a 'cmpxchg' memory operation.

The patch set itself looks good to me. But previously there is a
discussion regarding a potential similar functionality through bpf_link.
I guess maintainers (Alexei and Daniel) need to weigh in as some
future vision is involved.

> 
> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
> request checking of the EXPECTED_FD attribute. This is needed for userspace
> to discover whether the kernel supports the new attribute.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   include/linux/netdevice.h    |    2 +-
>   include/uapi/linux/if_link.h |    4 +++-
>   net/core/dev.c               |   25 ++++++++++++++++++++-----
>   net/core/rtnetlink.c         |   11 +++++++++++
>   4 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b6fedd54cd8e..40b12bd93913 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3767,7 +3767,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
>   
>   typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
>   int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> -		      int fd, u32 flags);
> +		      int fd, int expected_fd, u32 flags);
>   u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
>   		    enum bpf_netdev_command cmd);
>   int xdp_umem_query(struct net_device *dev, u16 queue_id);
[...]
