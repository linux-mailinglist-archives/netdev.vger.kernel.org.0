Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BDA3D15D6
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhGURWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:22:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237549AbhGURV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:21:56 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16LHuSR5012361;
        Wed, 21 Jul 2021 11:02:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=14aQEGZceoLqvQo1mhLspgQ9mRU8tz/xeITvEPjJGNg=;
 b=h7yvFBMg3FzAhFLF7fZO8YbU7HXCcw2Ed5dAEZf8+mmQPitiXp/7/CHDO1QtAWIfuEAP
 Q3VzfRPe/p+RbBFWKiJWYRwmccmuFjwX9Z5vAIoo/PCMV5Gn3G+hCeUbBgQgdWxNsytp
 KXCNcbaX1FlvF/RgPgMHTv1lWen7qGM/o04= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39x1xdqfve-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Jul 2021 11:02:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Jul 2021 11:02:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWqG/ZUHuUt6iswr62pFKYsulrGkTaZfmSoZqdFIeZCWJh7hrUijgxkf1gBB9SLyCghluw1R6+BPZUx9qPPK8FntDEryCwFKk2wpYoVydWINx6Ll0OAb0DP0IEctBA5aof3nVbGzRT79ULC8Vjj9qoMvwDIxv1ntQazBcF9LmGJtgulq8AKRU1Cpx/wnA5MMeGXBWbs49T83vJpre+jEKf0gIQArgsU8/VCHFoWyqE0D5q40u6s3F4TdPk+x+Nmoxkuj75njJTZCycOkDsHBk3MkpNrxn2yWdX+7mjLF8TRmzDBnLh5ervefBoqKT4ClTBEMkA2tgXONynCfNvLuxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14aQEGZceoLqvQo1mhLspgQ9mRU8tz/xeITvEPjJGNg=;
 b=BhIoymIAmQDENkvqsERpbwxIdkO3BXl0UZOc9EM5w9O/nP2ZN9mtsyu7d63BmXxDZN9Ow2yKi6YG7FmggwcKeY8kXeeWz1k5P09R97ZYVRpOGBkYpfJI9Auns6b4gOwC9dOOsSTW12xg2sbbRbbWvSip40cHLkO7iXNww6Q4hX6NhpwN6KGNzBXSjxo2I9x28cgznFYHu/pX7kFzIj9qIDzn6K/WoZnH7FkPy2srD5u8mStyABLfBU1iKSHdjBaMYLOQj6c7MRtu6fBYNKwk+9vnc9vLq739w1DUXeIS3fpjhRJGuuhjBuEiYSW3R0I8hGbeNK7/Qp/LwUkEyLVlKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4173.namprd15.prod.outlook.com (2603:10b6:806:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Wed, 21 Jul
 2021 18:02:15 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 18:02:15 +0000
Date:   Wed, 21 Jul 2021 11:02:11 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>,
        <xiyou.wangcong@gmail.com>, <alexei.starovoitov@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 3/3] bpf, sockmap: fix memleak on ingress msg enqueue
Message-ID: <20210721180211.xvdxuhmb56scmag2@kafai-mbp.dhcp.thefacebook.com>
References: <20210719214834.125484-1-john.fastabend@gmail.com>
 <20210719214834.125484-4-john.fastabend@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210719214834.125484-4-john.fastabend@gmail.com>
X-ClientProxiedBy: MN2PR20CA0016.namprd20.prod.outlook.com
 (2603:10b6:208:e8::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ed14) by MN2PR20CA0016.namprd20.prod.outlook.com (2603:10b6:208:e8::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 18:02:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35e71bdb-2ae8-4cf5-8d2c-08d94c71ac4e
X-MS-TrafficTypeDiagnostic: SN7PR15MB4173:
X-Microsoft-Antispam-PRVS: <SN7PR15MB4173CDAAC0908FE763C061DAD5E39@SN7PR15MB4173.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+YPR2C3C8nw+zFL/nxmi2NCs9K8F3UeHCUlNxcEpcALfDiPGeTLK3+7Jxi/sTCAmutVA1YbbHdTlYq8Y1UpWEDz3kWht2tzU59n4tQ2ax1OUjlt0+fhLv+P0ohMfOttVRzw4Aq0GuqwT4qvzZWI2Yl4KHFS6g3azrad6YmcdrZ7+HQV1QZZkNpNectDXp+z5e8/FQ8Bn0ZSgpqgV81+Pb4PsMm5mchTa6BMKYA9XUarh5N2mgan76QpTaXFcMTqAIsJkeyjt/wHVRZAxDyU0g5dchoY7edQRwfrDmeAesu9L30GT3p+EcZB66WbrfUInjN5sp4AWr8Q+FZC+H/i5AOzCCaM/fs+/uyevZ14JiRC57dPtJxHH6diBKjMG79+ehcRDwTyt6K44gRn8gyHuKe40QYNS4lHSf/TW+Ino+xk167fLzq/rx7wkAxgGcfpm/FK3Aio4mVso4Im8nxUcnezGKsYv/am29z3ORjzZFOB01Sgi1meaBeYq4V6NwDE6VcRii6e96UMvzbDtDODrOLIRgZlximIhG6wrao9QVYWXvE68BXYIA7+gZ8pqWREp9bFP2vKmJvp0H15sj2gqsO32PJMYBWktox4zHXCe1Ydf279gEqpiXjEeoBRDEHJL9XXD2n8XuIwBgrG2xOOTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(8936002)(6666004)(4326008)(5660300002)(6916009)(9686003)(2906002)(1076003)(55016002)(8676002)(38100700002)(66556008)(66946007)(316002)(86362001)(66476007)(7696005)(186003)(52116002)(83380400001)(6506007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uoh0Ecxpu2h0zZef0+ewI/nw8Xmy5qT60L2z+C/XsbeclHo44hWWfApW9DbC?=
 =?us-ascii?Q?cWRo6isFXyuqmmskaz4ZU043x11fo9A0OeKtvTQrXG50txeS/h2atJqGcds7?=
 =?us-ascii?Q?X3KDfa0eFTvISurJeJCCOgM46Ej+wr9pJMDwzyY0rwUArf3ijz1cwFgeoUqu?=
 =?us-ascii?Q?LqUnIUMigB6PwyOA/zTta/AZmabj1xzfZ7lJ4VoJk+7xMydgYLVqP2GK+t+9?=
 =?us-ascii?Q?w4S/QR4XYlr4jaQqN18eE7fL3Y3yjczEPysQqTqGUSMyCJNMgQtu2GQ7SVdJ?=
 =?us-ascii?Q?PaV6sdWcn1rglgjWyIAQPgvg54cs67R3xGwoLg8myRQTZqdd0s7YSYTvKVhl?=
 =?us-ascii?Q?YG8fEY7lmQrGnmFwbi1W7fUdxVFNntLRHQB2BFxRx4dxauk86FLqtuD/nrRe?=
 =?us-ascii?Q?ao84bHHYnLNJ8+oUHnFJB64jvMm98SE703DOQz31l34pXWiEyEUux/YP1SfN?=
 =?us-ascii?Q?WzpfK5KrgGYGxtIBjthq76L/YvPQBfb4PMrS6i3WVMfXHMzaIVhGKlQ5slIZ?=
 =?us-ascii?Q?XXBUIjv77JQg51r2sKVIMQdioEV5KwGyUxEbODZxbp9afOddK7IZyH6y3vcZ?=
 =?us-ascii?Q?G/nKzUP+EzPYReJb+c3hqrNXzwffIl8YWj+ZSIg9B7v2VdurgulQ5nB1xikf?=
 =?us-ascii?Q?VjKsKneH7DheCjXF03auOrbCouMWPDQXR9NU5Qm1/By4qfJx2fWIBzV/GAmb?=
 =?us-ascii?Q?xeF3qYSX3kdsR9t6cB4DK44GSMkMvXu1Z0VZvB1zbkwcdMex+umDpfOnWLN/?=
 =?us-ascii?Q?yAcZjwPP3N9+x55cV/USEGPOSZAj13Uic0i42HTCGLyHf2AhwAAtZigLcFGn?=
 =?us-ascii?Q?FS3F0i0jbA1gcFl/FvVNE2T+XKDhUneFgFV6M/r8UQvoU4kOxuC7r2kq3mmR?=
 =?us-ascii?Q?pHIBI8otn6E/EosgFhceEwoEf644Zbj5IqYuPZlpCQu/lcEw/m9p5O6BExqT?=
 =?us-ascii?Q?hVTvo4CSiuq/yyvnonn5LLmmKv7D69rZ0KXorzW05SQ3AG2oAGHgAUeSMHfN?=
 =?us-ascii?Q?Oi7ZSJ/ZrBobr/PgbqNFEmCDEeTC8I5Rj7puXn3Fdu2WFu7KzU+EaDzo6xJB?=
 =?us-ascii?Q?u8z0Og8uP9PQbODwpEcRVcjthZ1e93rmg36B3D3HA72JyJSX3jAeR01qtrcn?=
 =?us-ascii?Q?lBagTGC6KIcS5BN/+poWLZAk2DyTpeMjZGDQ3tzPbMphTwaL4uTRy5zht5ju?=
 =?us-ascii?Q?dITI4picZyBbAawQZ/TWCoQY9WtbWTQzL5widjlYETyjta6DPf22c1PHkNHC?=
 =?us-ascii?Q?bXGnsXTpD/yvTQg4ACAjamPPFnZcKE3VYXR4n9WaMdMOr5ATJHVZh19BfIqC?=
 =?us-ascii?Q?o11L408McyvoJFERCzkhrr8PoFEeK06PUd1FA4ntQ7b80w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e71bdb-2ae8-4cf5-8d2c-08d94c71ac4e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 18:02:15.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5qR4NB+f0iaoA9CB/IHvXjrT6LpvlVTAnABwwHN69fMtUvWmAkDVqjc1vlnBfsE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4173
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: tfk3YsTzjVnFHFDU7Nev2SjJqrCk4xeG
X-Proofpoint-GUID: tfk3YsTzjVnFHFDU7Nev2SjJqrCk4xeG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-21_10:2021-07-21,2021-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107210106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 02:48:34PM -0700, John Fastabend wrote:
> If backlog handler is running during a tear down operation we may enqueue
> data on the ingress msg queue while tear down is trying to free it.
> 
>  sk_psock_backlog()
>    sk_psock_handle_skb()
>      skb_psock_skb_ingress()
>        sk_psock_skb_ingress_enqueue()
>          sk_psock_queue_msg(psock,msg)
>                                            spin_lock(ingress_lock)
>                                             sk_psock_zap_ingress()
>                                              _sk_psock_purge_ingerss_msg()
>                                               _sk_psock_purge_ingress_msg()
>                                             -- free ingress_msg list --
>                                            spin_unlock(ingress_lock)
>            spin_lock(ingress_lock)
>            list_add_tail(msg,ingress_msg) <- entry on list with no on
s/on/one/

>                                              left to free it.
>            spin_unlock(ingress_lock)
> 
> To fix we only enqueue from backlog if the ENABLED bit is set. The tear
> down logic clears the bit with ingress_lock set so we wont enqueue the
> msg in the last step.
> 
> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h | 54 ++++++++++++++++++++++++++++---------------
>  net/core/skmsg.c      |  6 -----
>  2 files changed, 35 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 96f319099744..883638888f93 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -285,11 +285,45 @@ static inline struct sk_psock *sk_psock(const struct sock *sk)
>  	return rcu_dereference_sk_user_data(sk);
>  }
>  
> +static inline void sk_psock_set_state(struct sk_psock *psock,
> +				      enum sk_psock_state_bits bit)
> +{
> +	set_bit(bit, &psock->state);
> +}
> +
> +static inline void sk_psock_clear_state(struct sk_psock *psock,
> +					enum sk_psock_state_bits bit)
> +{
> +	clear_bit(bit, &psock->state);
> +}
> +
> +static inline bool sk_psock_test_state(const struct sk_psock *psock,
> +				       enum sk_psock_state_bits bit)
> +{
> +	return test_bit(bit, &psock->state);
> +}
> +
> +static void sock_drop(struct sock *sk, struct sk_buff *skb)
inline

> +{
> +	sk_drops_add(sk, skb);
> +	kfree_skb(skb);
> +}
> +
> +static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
> +{
> +	if (msg->skb)
> +		sock_drop(psock->sk, msg->skb);
> +	kfree(msg);
> +}
> +
>  static inline void sk_psock_queue_msg(struct sk_psock *psock,
>  				      struct sk_msg *msg)
>  {
>  	spin_lock_bh(&psock->ingress_lock);
> -	list_add_tail(&msg->list, &psock->ingress_msg);
> +        if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
Indentation is off.
