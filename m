Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E94AB9C6
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352032AbiBGLGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 06:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241460AbiBGLDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 06:03:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D16C043181;
        Mon,  7 Feb 2022 03:03:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217AxJWY031975;
        Mon, 7 Feb 2022 11:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=iwcJjUz5WAgvnxjkxK+k8iHnqIwbbLgqZiGcrBB/Qmg=;
 b=jAyQdFcCkUugh8J1mr1eA19gryCv7uU+ea6duq7glLthg7kFoh55l/iqGE36cXrsuyKw
 wiwJq5GOCZFGTgpWyXvUZwnKnKFntmSh/4e2BfF9WTinq9GtDKeZ8VnaSfaP09UDrwxO
 IivmoYHFArw1okue2Io/gvhQrE4DGg4uVjNbZa7qlef8eGpBCIi52jtb7pEjGlA2A3Qa
 0hAyAOKZPLgpxgLOgGu4alxDK9BlUaOkjFYYbmlTqA3esq2WxmaQh9jKhZ0wt911PCuK
 9puurLodLQ/6RD4+83eWW2BhWYIm6osmdzfSO7sIDwBXKYVrfHR05Hk6JAVH4963Veqd Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1h4b5eut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 11:03:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 217B22vq110606;
        Mon, 7 Feb 2022 11:03:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3e1f9d7ct5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 11:03:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzQiaMkhCfwM8ZivAHVrERXURn6kGZR1Mguf6MvZfvuzbgABAGgYwyXMmKlAYJhBDiyxaCF4OWwU3itzpnpXf/7VvKX0QqUo39SYOfj8sCdo/bAlfWdFHET6nvyRt5IK5sZyS5Ik/55TebOlZFu17tGixvydm6LxHxfODQkocQ4kpWNezOlCi7ULlx2zVwpDLN4Vo9UwbyKTQnz1N2rTx3PN40Gpimq/z0w0S3Tb6vCEwkHineAkOe/7P7HS1nP6GsVaONmDaHH2U23j528uD2cibh5gCDu3cvT9zktB+kQrCuax86s1MyVTikYbcxkoTVKsmQVh+nzcBXx/e/e3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwcJjUz5WAgvnxjkxK+k8iHnqIwbbLgqZiGcrBB/Qmg=;
 b=OB0G2/IsriGWIU7ZVuqBcpLzgTBFZvRWTkAXGJIuUZecX7PGD1DUMY7Kl3O9+OoygfEUc7BlZAKGtYlodtz88F7zzJSO5WAOV+mRfm5XXbk2JXUvs9ZM2NyPfqvS+nVCgBGPdM5uL3pmMs+cldHVhjxRyuJch48k81nGJPiziDtU1g9gtNem8MR/wmyKRVfNJ0mp+hLsYZdnGkTf6ZAI3QBA/O2a4cc7MArPlIKCnYEwXsqY0XDwlgEYbJ7kAJOOnhzKVfXZBPkhlNr/BvkfW2T2Cs5oJRMKzGWOcj9YfgknQjjyBYJUSxaqHrMgETfLQN09k1ij8B8iIcQAWuKuVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwcJjUz5WAgvnxjkxK+k8iHnqIwbbLgqZiGcrBB/Qmg=;
 b=xg9R5A66dY9GHZtkF7VSlOZvUkydOnnvkyCyjxkNwCNOdNzslstAW0czy8JsGOr8mSQareR9KVvnnf7Iwk7iqt6OUSNGs+XqPcPyJYieX2EWjrM4InOMsjsCknv+BMonSGu9FB7XBS4T2x+jo9ftQl0QGeR8IBBJHvNXwCKQ1T0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR1001MB2153.namprd10.prod.outlook.com
 (2603:10b6:4:2c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 11:03:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 11:03:37 +0000
Date:   Mon, 7 Feb 2022 14:03:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ayan Choudhary <ayanchoudhary1025@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix checkpatch errors in the module
Message-ID: <20220207110318.GG1951@kadam>
References: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60d34237-bec5-4bc1-ffac-08d9ea297d5a
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB215396225026DF283244D6738E2C9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySXP79HRlVhu6tFFDX+b5qeSKBqQI3DmQZRsjqbpp1c7IPqvUV6A12OA1W8Ovg0R5/VZYU5KHmyivBDeo7GWW/IVFLp2nw/HNF3YePO/Tim/7j/lAyGL58NW4crJbbPpwuDYbFIXD3bpPBnFcXnF9oYcALIpfSbQmUfD1f+VksP7aDVrlk5wWdWvRopbW4TnKAoGrqotvY4MHzxQBL/cJoE9uydd7HyLogDV6JvzAyPvzlOxzbkP4qdxQ9pUoPPF8q6+vCBS/prdpyMGxZ3fa4mOB8z4VwqPJ7syJJU/HLLRhV94CqW9K9CbVgp4yClqtSoI/i6/3upGADy2IV9MbriV2kbv/WQ8ReMaBAYN66/0vOjUB/pD7u7fACt4LfFlWA/z/Kh/dosLMjSyy+2gUbuWA1PtWqQwZpmcFwXvs0BdEcMSZU2AG5bX6O5RYCvei+LtoBhJCaBJCad7IKoY0TrD9jQc+fBhqJ6NnUhYe7gHxqTni/5WSlzYDlk5EfuLNhaYcq8KDTYDC6QwLZD1iMOT7MEpcBmsaqRAfNLH7hQoZKKURGt0ufIbytceuP/kJVSaTewlbpM7gSkQH7twLm3zg4WA1kTxigL6OVeEBpStXg1u6sqO6BmtdPLb5FtWiEgLvk6Xuj50b9QoOeSVgBl40kcxTmIwppnqneFLKHoLZZK3ZmcE5voaKbtd20uNcbzUfx3+fz75rMx+GMeApw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(9686003)(6512007)(38350700002)(508600001)(6506007)(6666004)(66946007)(83380400001)(8676002)(8936002)(1076003)(4326008)(66556008)(66476007)(6916009)(86362001)(316002)(186003)(26005)(38100700002)(6486002)(2906002)(33716001)(33656002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cK4m0yqBRzKcfpxA3KHS17QmTPi8dNiLH0tdy9hONM0ndEurJcOLI5Ti2aY0?=
 =?us-ascii?Q?m4UOo5XEiMHaTJr/SsVHyrOdhxxfQ7UHfbZD4ytbCqN59KOGgeo5L69+H41v?=
 =?us-ascii?Q?HZUjI8BOr+Hr9OajJLpH/FwrUyQbX/FIjNkYo2BcUCL2mE8RWMQaTWLd2x81?=
 =?us-ascii?Q?zqWrt7T/Gno34zB6d/0WG3WWlHRsCIubiM0brhFTlaMx+O5EJGQrvtPgj8rs?=
 =?us-ascii?Q?rED1xNPWVrQoi5DDRM8lsIvt0/I1yd31hnF74PujW/0Byh21NK8fyxKM8pr5?=
 =?us-ascii?Q?XT4mpyuP7+KZiZgM3wGVoi3/SUsYn07p5Z2ZngNXYbtaATuu6LE0lL1tzzI+?=
 =?us-ascii?Q?mjV97amOSFVSWtcp6okEPNHWdItJmKfgYChit0vC/0ukDDcj5h55jql2qLZX?=
 =?us-ascii?Q?dc8uONypRynqIztUBeIt1Lg6lNAH+oMy3OFrOdc3B1v8XZvQRnbq+p60SNAE?=
 =?us-ascii?Q?WJhQ6LwS4x/J31pWaG54F8SzgGFediXkCaCRAf3i23YDPHfVndw5jdiVmbu4?=
 =?us-ascii?Q?CI7pm8qB1BTgxwI8yeWSDajRKCzZjbNhMFXvBwV+aZo7nF3hFf5EQsPLQTNY?=
 =?us-ascii?Q?xAOrW3DWmEg9wgzcDBiz0rGdq9ptIPuBo9j5diLvbFm9CoezNyTQs59ZTIjr?=
 =?us-ascii?Q?2+XXNegQwmmzKA+MYUqSDPIdUAfl/1AGn+EGbrxPipZ/j9DBRkyWEkymv5V/?=
 =?us-ascii?Q?HjdQmCjTU8LPqZtEiRwv23gTSYe4+bMBd9iCPfCiG5sE4BB12CAxzbduTeb7?=
 =?us-ascii?Q?QUL0c8Nck6BHGTqeB+LUNIRraIrYMhuTrZlvtr9V5fYygD1XYM3JySK4a5CH?=
 =?us-ascii?Q?/Yea6o3JA4HdyAEdndyzVn1B4FtclC8U9fDQUFMYnpZ78EMQQw8LDuTz+O2m?=
 =?us-ascii?Q?hdlVy4d6cUVNWVAmgOXVZuLDk0j3ipuiD+ZArrfxMv8+Wnyjyai+B6lLD+Nt?=
 =?us-ascii?Q?sVxRokOqUDWFpatNSaQzIJk8CVRBaRo82D0lldeQ7Ef9AI26mIo7+yHVrJan?=
 =?us-ascii?Q?EnCr6JmkdT+GV5l1vr0iv3ptLYQzOF0likwzkXGtpBw9FFCVoWXCDThcRXo9?=
 =?us-ascii?Q?PKriT0UjujWpizl5TXXVSho/gZ6tH+nRbRlwIVHRCnZh3V41z/O5wNDgpal/?=
 =?us-ascii?Q?Lp45QdklUaMFyNq9/yD/n/ejF8PbqvFIp09o+HHrsQiZcMli3lefFMHctulo?=
 =?us-ascii?Q?uptALz3gZ+u6fmJ7OkFeMSqE6/+5GYXS3VRDGrSpQW2x2aKvYw5SnyZg9EVU?=
 =?us-ascii?Q?dVwfbYGMsLaShe0rErRc7I5YTHtyJWBcLaMJj2ju2DK3XjbEVl491KE2pyG4?=
 =?us-ascii?Q?t9SpPgrS3kxDIhS/Tg6s9Hi6fvYDpunQGZ25GLzEMW7gKipMaeHnnwiE7hAa?=
 =?us-ascii?Q?Xhi6BmZWpL8FbRJJj52h7SCVl/N5mXqHt2e3raBTzlmjvJJJWrW281Kups6v?=
 =?us-ascii?Q?sWZJrhyh+9xNU0QbxE22UGzmaDB+ujs2Ykey2Sm5XHbVZp5LPa6xZxWihsck?=
 =?us-ascii?Q?zhULu4qcxLW4GUBqvcoaSFxm9hot6gNbN9+AtnA3chJj0f0jNyaDTWFyaBj6?=
 =?us-ascii?Q?meE4X1VoDT6EJZ2c3iZ6jBHggP5IygckeUCE25lt/rU1sz2wIomponO+El1m?=
 =?us-ascii?Q?9iZk2ed0vCW95IyrZxub1s7Fh6Mu7egOy+IkTSO0ojblQnMfQduAdQzv8bNb?=
 =?us-ascii?Q?MSlsfA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d34237-bec5-4bc1-ffac-08d9ea297d5a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 11:03:37.1841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgzVjKyRNs7S2WLCNgI0aUV5WKvJn8sgyDo5QHd7vkeqxSXO4M9AYNC2g6a/PCjFaU/uw2Z1qb3rk1WMtX5M6pNZNJTuGL9Ty8EoU3iseFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2153
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070072
X-Proofpoint-GUID: nZGhlbmScnGMoicd7HpDsqYiwNftvgpz
X-Proofpoint-ORIG-GUID: nZGhlbmScnGMoicd7HpDsqYiwNftvgpz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 06, 2022 at 11:15:00PM -0800, Ayan Choudhary wrote:
> The qlge module had many checkpatch errors, this patch fixes most of them.
> The errors which presently remain are either false positives or
> introduce unncessary comments in the code.
> 
> Signed-off-by: Ayan Choudhary <ayanchoudhary1025@gmail.com>

Your patch does a ton of different stuff and a lot of the changes are
bad.  This patch introduces a bug.  Moves code around for no reason.
Introduces false information into the comments and hurts readability.

> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index 55e0ad759250..7de71bcdb928 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -45,9 +45,8 @@
>  /* Calculate the number of (4k) pages required to
>   * contain a buffer queue of the given length.
>   */
> -#define MAX_DB_PAGES_PER_BQ(x) \
> -		(((x * sizeof(u64)) / DB_PAGE_SIZE) + \
> -		(((x * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))
> +#define MAX_DB_PAGES_PER_BQ(x) ((((x) * sizeof(u64)) / DB_PAGE_SIZE) + \
> +		((((x) * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))

Why did you shift the lines around?  It looks ugly and checkpatch still
complains about side effects of re-using x.

>  
>  #define RX_RING_SHADOW_SPACE	(sizeof(u64) + \
>  		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64) + \
> @@ -1273,7 +1272,7 @@ struct qlge_net_req_iocb {
>   */
>  struct wqicb {
>  	__le16 len;
> -#define Q_LEN_V		(1 << 4)
> +#define Q_LEN_V		BIT(4)

I'm pretty sure this is deliberate.  LEN suggests length.  It's not a
bit flag.  Anyway, if you're correct please justify your thinking in
the commit messages.

>  #define Q_LEN_CPP_CONT	0x0000
>  #define Q_LEN_CPP_16	0x0001
>  #define Q_LEN_CPP_32	0x0002
> @@ -1308,7 +1307,7 @@ struct cqicb {
>  #define FLAGS_LI	0x40
>  #define FLAGS_LC	0x80
>  	__le16 len;
> -#define LEN_V		(1 << 4)
> +#define LEN_V		BIT(4)
>  #define LEN_CPP_CONT	0x0000
>  #define LEN_CPP_32	0x0001
>  #define LEN_CPP_64	0x0002
> @@ -1365,7 +1364,7 @@ struct tx_ring_desc {
>  	struct tx_ring_desc *next;
>  };
>  
> -#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % (qdev->tx_ring_count))
> +#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % ((qdev)->tx_ring_count))
>  
>  struct tx_ring {
>  	/*
> @@ -2030,9 +2029,9 @@ enum {
>  	STS_PAUSE_STD = 0x00000040,
>  	STS_PAUSE_PRI = 0x00000080,
>  	STS_SPEED_MASK = 0x00000038,
> -	STS_SPEED_100Mb = 0x00000000,
> -	STS_SPEED_1Gb = 0x00000008,
> -	STS_SPEED_10Gb = 0x00000010,
> +	STS_SPEED_100MB = 0x00000000,

b stands for bit.  B stands for byte.

> +	STS_SPEED_1GB = 0x00000008,
> +	STS_SPEED_10GB = 0x00000010,
>  	STS_LINK_TYPE_MASK = 0x00000007,
>  	STS_LINK_TYPE_XFI = 0x00000001,
>  	STS_LINK_TYPE_XAUI = 0x00000002,
> @@ -2072,6 +2071,7 @@ struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
>  
>  	return ndev_priv->qdev;
>  }
> +
>  /*
>   * The main Adapter structure definition.
>   * This structure has all fields relevant to the hardware.
> @@ -2097,8 +2097,8 @@ struct qlge_adapter {
>  	u32 alt_func;		/* PCI function for alternate adapter */
>  	u32 port;		/* Port number this adapter */
>  
> -	spinlock_t adapter_lock;
> -	spinlock_t stats_lock;
> +	spinlock_t adapter_lock; /* Spinlock for adapter */
> +	spinlock_t stats_lock; /* Spinlock for stats */

These comments are not useful.

>  
>  	/* PCI Bus Relative Register Addresses */
>  	void __iomem *reg_base;
> @@ -2116,7 +2116,7 @@ struct qlge_adapter {
>  	u32 mailbox_in;
>  	u32 mailbox_out;
>  	struct mbox_params idc_mbc;
> -	struct mutex	mpi_mutex;
> +	struct mutex	mpi_mutex; /* Mutex for mpi */

Nope.

>  
>  	int tx_ring_size;
>  	int rx_ring_size;
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 9873bb2a9ee4..6e4639237334 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3890,7 +3890,7 @@ static int qlge_close(struct net_device *ndev)
>  	 * (Rarely happens, but possible.)
>  	 */
>  	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
> -		msleep(1);
> +		usleep_range(100, 1000);

We don't accept this sort of patch without more testing.

>  
>  	/* Make sure refill_work doesn't re-enable napi */
>  	for (i = 0; i < qdev->rss_ring_count; i++)
> @@ -4085,7 +4085,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
>  	int i;
>  
>  	/* Get RX stats. */
> -	pkts = mcast = dropped = errors = bytes = 0;
> +	pkts = 0;
> +	mcast = 0;
> +	dropped = 0;
> +	errors = 0;
> +	bytes = 0;

It was basically fine before.  Leave it.

>  	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
>  		pkts += rx_ring->rx_packets;
>  		bytes += rx_ring->rx_bytes;
> @@ -4100,7 +4104,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
>  	ndev->stats.multicast = mcast;
>  
>  	/* Get TX stats. */
> -	pkts = errors = bytes = 0;
> +	pkts = 0;
> +	errors = 0;
> +	bytes = 0;
>  	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
>  		pkts += tx_ring->tx_packets;
>  		bytes += tx_ring->tx_bytes;
> diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> index 96a4de6d2b34..6020e337fc0d 100644
> --- a/drivers/staging/qlge/qlge_mpi.c
> +++ b/drivers/staging/qlge/qlge_mpi.c
> @@ -935,13 +935,12 @@ static int qlge_idc_wait(struct qlge_adapter *qdev)
>  			netif_err(qdev, drv, qdev->ndev, "IDC Success.\n");
>  			status = 0;
>  			break;
> -		} else {
> -			netif_err(qdev, drv, qdev->ndev,
> -				  "IDC: Invalid State 0x%.04x.\n",
> -				  mbcp->mbox_out[0]);
> -			status = -EIO;
> -			break;
>  		}
> +		netif_err(qdev, drv, qdev->ndev,
> +			  "IDC: Invalid State 0x%.04x.\n",
> +			  mbcp->mbox_out[0]);
> +		status = -EIO;
> +		break;

No, this breaks the driver.  Please think about what you are doing.

regards,
dan carpenter

