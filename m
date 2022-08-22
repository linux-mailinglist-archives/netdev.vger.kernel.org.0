Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7959C0E0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiHVNqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbiHVNq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:46:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C372931EE9;
        Mon, 22 Aug 2022 06:46:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MDPbks006031;
        Mon, 22 Aug 2022 13:45:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=uBeMS398hCQp/KsuybpY/Gjm+H7aSfZ3cBzEBF1ELcE=;
 b=YStHRJ0X4e+GpI4wYPkuDFfZthuI03z9mVFw+ltylaoiM/4LOKG6pfx9NUAmSHDn/FNI
 Y5aiVzywNh42kzID7sbdwL2ZyF3qDP6uYBgIgqbqZUrGveO6a5S3QkYh5Bo0R+MR5mQy
 RghJakXvLTZxPPtKDQpneyfglMhWdbfoLyCeHWYCVPxMR6fVHIOUMOiuLdmoNMJhoIup
 RDIQ5ENuYaUf2OA78kLGIc3s9lVnVjLi1idXclheX13aGC9xdgMQgGkyWP4SwUOIPz6z
 vn4u0Gs25Bc9rHLD8Mo8yNnZejt5hOGJdcUuVb05nCYufr0J9F5dVWXtCkVPugY+uN7x Tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4anu82sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 13:45:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27MDRONS006361;
        Mon, 22 Aug 2022 13:45:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mjd0qkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 13:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3Da+34+Jb1EogLSUrYcO6vCQJiGfGf1FQMzY1TYLeIhKiGc1aUqLLWPUyq69RqAv5g3kOX7+bb7D0HuMxYbWLidDEaFiXmaY3Od6vsHi2x8lRisdhu1RXk8d6co0roHfuIdCmiaQM8MmWs6HyiYTsuJ+2MmVtw5vTUDHj2abFZiVzFUitU9LWSQ3Rx0peb+u4HOPWAjSU0vAFnVEgqHwPLPIPNVQWD+aqGziNHRwUc+nTDR9YFq0B4M96PmpjXDa/GDw3+5n1UDJfDqfCZ+kfp3hRu1hFj34ExAOVT0Au+5NzvFMIwQivj4R8hvLelxo3njv0f5nO/R0ec3iHYlTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBeMS398hCQp/KsuybpY/Gjm+H7aSfZ3cBzEBF1ELcE=;
 b=lxZ70vnvdqaKVp4eOMQQJqd8Z7Unb7S6sjf62TtfwtZ34F9vP/P2vh/1CkVUHbEJtR6m4Gyh0GAZz1l8+GDX8mLDZttnIk21h6czeYjvo7Glgmefly6Q6cTTrQyYhknsPPPKZU1S5Hx+Dnv5mY6hb17ELMFac2wEm0BcmvCOJObPXyvtTD42e8V9qbRFrwl0ph5eyXxgUrbhL/virSY0DywTEKJmq8TqzKaeie+gD+x5NbKK5oG7FozMSRpOG8bqcE+7o308NRoPIEUa+PFobpkVoowul724FQVrTosHGQqWTsF9BcG+MCpIPet66J7veTzBxLwz+6Mh9RyMMy8cQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBeMS398hCQp/KsuybpY/Gjm+H7aSfZ3cBzEBF1ELcE=;
 b=oDehWaQWEuGH5QWTUYB5bnPGYdqOhOCvCU3/vy1rMoaPB03C2qDCH9KrceE0W+olvgvXppQmEtt6sT6OiCkZGfKZ2MmXq/GickEfbWF4EOtSx9VtnAlYEth9S6vxpfFSo+MsRTsjntdNCZEpvtQBXfKrFXyRLW4Cqqkpzmnc87I=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM4PR10MB5919.namprd10.prod.outlook.com
 (2603:10b6:8:aa::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Mon, 22 Aug
 2022 13:45:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 13:45:06 +0000
Date:   Mon, 22 Aug 2022 16:44:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
Message-ID: <20220822134443.GE2695@kadam>
References: <20220822112952.2961-1-yin31149@gmail.com>
 <20220822130414.28489-1-yin31149@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822130414.28489-1-yin31149@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b750fc-486d-4a68-41b7-08da8444854f
X-MS-TrafficTypeDiagnostic: DM4PR10MB5919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FfHkcXkvmolmSSueDYMK97qNwBcLjxlTWCirNxWvfeEdgwaD8tvAH3g82qVyjc7sVOjinf2jCxmNbFwic9RyC9T3xhptM0KdfBcbHSQpAlPyCN2QYIw41tv2d8MNWWpU/sU1BFK+WWVxColyLx4whUEhOsUXfuLwCluI6xP2/BhngnL4SNNp8n5yYy7OA5Ysa+EEKqLVfe3xQTOZLrj4W+2mG8bw30v2/rO4JMNn5hFf7S/KzIbIPE0ZNtT/3L/x0USn1SIjqUCgeUZsPMgP21pXTtqJc0L2NiLG9j9aRpAjKOZOfG34mvOoilUQvn+drhWkPriacHT4VOXg62GRFYJEPFxsg8i3ID2Jwj0oCrsv1PGq3abVWHuuKZbji+y5T/gnklLARuNK9CPGR3M81/7uUBZEXi37ZRgpdKGo70GGjXglYQxUUQ82J6DCjBf+xJL+DEvjlZEDwIkA3HxfAhkI/vFmegkU9Hcc3t7ehmrK03G0WyHpRThWjzYB9wxieGWuPaJouYbfnf5mEpH9EYmCCCCwcHiEaPKvfmXP+0CXVZlgN1KViAoUTmKRBc9z+klUDGuOrceHVsblvXby1ttSloS8jbnOHzYNpsBREbHcEfPCVa+XThxroAj/uEbrXGPlbqBH4AZeVQNmAWp3rFaUSQDCRdl33XJr3Mtvrd7imbOtqnwmwxFdGtOiNUgJXbFptn2zS/JO9KzNVq6yOQ5lRn6yRCr6egGnWBkRmf86D3krgXF5ZLpJaVjx4JS1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(366004)(136003)(396003)(376002)(346002)(44832011)(6506007)(52116002)(2906002)(6666004)(41300700001)(186003)(26005)(9686003)(33656002)(4744005)(1076003)(6512007)(86362001)(38100700002)(33716001)(7416002)(38350700002)(478600001)(5660300002)(6916009)(83380400001)(8676002)(66946007)(4326008)(6486002)(316002)(66556008)(66476007)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NgdVbkG+NZtPj9FDMM+eH4AnJyX3NKv0ds8/PHHA3jFCjc5nOd7iG+VUZysf?=
 =?us-ascii?Q?wxG9v4QG0OT6Kuw3JsRxO4/DI+ISRfCsS3moVIT/j3U4+djdlrwKgqPP2jYi?=
 =?us-ascii?Q?QKnRO3OAvhnVrt2+vp02q21CEBJE28MXze2Thx8gQvKvKJ93MvXHeBTtEpBk?=
 =?us-ascii?Q?VyR+ZD3dn3KXJOf5eez85/daWxPtpy7sDEju7KCBZUBYtZ1RjYyvoQ1i9MoQ?=
 =?us-ascii?Q?F2Y74gAOMQ0ObpoHcjWRKHwRBh0e086sWmeFrQFt+SRLsT7T0usVtJfjGjhU?=
 =?us-ascii?Q?hEVFKdD0Zxmac55GN6h0RkRir0ou8LkM2mkho4XZNUPnPA4AzNrHDYnmunY7?=
 =?us-ascii?Q?d07T3/cCuHROYzBh23Gok0VdWeDBivEKFbPfsVcoBCTDJtbq0rdMf2hFvq/J?=
 =?us-ascii?Q?x6GqMOKvKdPx0do9VewKn5h8bjurEbnIFFWiUPybspjfiepsd88+ftgK5S1k?=
 =?us-ascii?Q?h/HlBi//cHzdDTJ7hXlFRWlWWOKnetK6FQzZx+YDlp6+y000YhCnKuFW/q4+?=
 =?us-ascii?Q?LL3NR0LYiA435tlb1HhTqCEzI3GxhpExgzUE/gti3WE6LNzSOSoXKhBi+Ooc?=
 =?us-ascii?Q?JN8NH//L7LNuUjydOBmMRlZuudJIeKh17RbtGRoLpaQCCjENlRgnbuSBV9GJ?=
 =?us-ascii?Q?96hOR0MINbRqyVh96wB560qj8Oo4gowrS2vcb95QtbSsT8iUqMVtzt1HREyJ?=
 =?us-ascii?Q?5uH2+iDspXKLF6/iYfvLiMxLB4sfjfYYAeb7UIbG2XvW9Gp7LJWNiwijKbGj?=
 =?us-ascii?Q?8/+eSqGmvzceaBXhIA2TJcIvUzyFYCkOtnmEz+Qo7V+qmrhnfuXI5Rg9/ecZ?=
 =?us-ascii?Q?LqtGzG9u7Mv7Os8XvhfnkjkDE+yRq+TEKGsqM8cvI5ylcg1CsNyP5bhKskeP?=
 =?us-ascii?Q?BIZdt5hhhK+7jQRKlnYMd4IeEkdeZqDmy/r0oBgw1x+azYZLi6tcfj96I9pR?=
 =?us-ascii?Q?hHSNQ3NKrZo/91zFju7u/fd/wbuN6xzQNeWQhBb2EjC/0oOLw3NSk4EQghzk?=
 =?us-ascii?Q?hv9W5slyfD4k7Xey7bylFTSAK+9N1aDbmD2Kojp/CLLGiFU+6NFsww/7pdu5?=
 =?us-ascii?Q?BC05xvvyltrafrXzeHMnSEw0Fz6r/vZcHnjhlRymBGJrP8kKRQJWP2nUzELb?=
 =?us-ascii?Q?cs3BHt9X1VxV/X4y1+UqiZSogAxyGDcCnzmf9cnIuKOD24u6pIbYaqagB02L?=
 =?us-ascii?Q?TjGAZdkNFS3DXQPpNgSOqxQUGmBqLrHL773ugn4Ze0VVaZCKfvMHPGqQBwtL?=
 =?us-ascii?Q?RHehTlokghKF4VePTUyD1Y9oMGYvhr7ILNhTghFoCpKN7gZskS3GrVUSQxXp?=
 =?us-ascii?Q?JCTswSToHz8YjcDL07kBWSbRIHADjZhWclepwQIxES9tR0xh0jO0sx2cEwnp?=
 =?us-ascii?Q?Uy2djeZA/IoV/3EvVYEoQD/FbI5rG+OkhpCd+KZaP7jJYHWWrzJdln4qW9Cb?=
 =?us-ascii?Q?GzryupVkDDJVYUf2zC/wf8UQDqmRHjyIskxVj4YHh9z3ABD73EX9OpMYMYVu?=
 =?us-ascii?Q?/8CfXF2Zx2N/gWRSKvtwQIVens1XOor12bIOudPgHH8HBdNhVEdm2KHp+jYV?=
 =?us-ascii?Q?w1zIBxsa/1zzLoVP86fGka4/bZJsFWMhVYGz9auLvMdrdrtDoD3elbkZ/Qpe?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b750fc-486d-4a68-41b7-08da8444854f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 13:45:06.3052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7LsNld545HPnh2+hHw9G8GJ6OLUkYNSJE5SSuAA+VcLhKAkt7cY3qi30litQpp41cSO/hFkWJVe0f9MUaSqG68zGDclbaSFsCe4Ktvc5+Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5919
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_08,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208220057
X-Proofpoint-ORIG-GUID: VjCqrBwMf7AKAQfUHK_SkbjCfmWIzg8m
X-Proofpoint-GUID: VjCqrBwMf7AKAQfUHK_SkbjCfmWIzg8m
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:04:14PM +0800, Hawkins Jiawei wrote:
>  static int rxrpc_send_data(struct rxrpc_sock *rx,
>  			   struct rxrpc_call *call,
>  			   struct msghdr *msg, size_t len,
> -			   rxrpc_notify_end_tx_t notify_end_tx)
> +			   rxrpc_notify_end_tx_t notify_end_tx,
> +			   bool *holding_mutex)
>  {
>  	struct rxrpc_skb_priv *sp;
>  	struct sk_buff *skb;
> @@ -299,6 +318,13 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
>  	bool more;
>  	int ret, copied;
>  
> +	/*
> +	 * The caller holds the call->user_mutex when calls
> +	 * rxrpc_send_data(), so initial it with True
> +	 */
> +	if (holding_mutex)
> +		*holding_mutex = true;

Don't make this optional.  All callers have to care if we dropped the
lock.

regards,
dan carpenter

