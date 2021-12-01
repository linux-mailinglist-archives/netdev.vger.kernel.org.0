Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D70C46504F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351136AbhLAOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:49:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5982 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351268AbhLAOtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:49:01 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1EZbGF010062;
        Wed, 1 Dec 2021 14:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DBbB0fp+px1Opa22QW3LznUzW8Dd+yoxa7MigIkmiIo=;
 b=RFy93HKXloh2Ns/hcbCZiMWa/qimpIHf71/Q1Wu7O/CfSsIQ6TLkXCCEDbT6WVzF0G6u
 3eI6k1Z+0mPldf76ZAtD4G8PCVk2QTJ/NqUI9INBX2diYIUtBHAQDkNFa/LqEXznPnr3
 o4SdULmb1kgE7STYBriCq4FTaWiJK3AAzhG07fogjZfwNTaK5Ofa6Ew5EGe7ehk2XxUQ
 eKYJ5yRSQGCXR2VPGWO6p2QdwDoXhEe77Bo0kmsG3NU6w/FlTMa+OTO+tjfjJJURp9pm
 m4z6Jbl2i7gz80MRbMVpZhkGrE2OF5XBbahSnMUkb/vzVwjY5dHTStDrg2W1sr5XcQyw zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp9r50h3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 14:45:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B1Efnhk160170;
        Wed, 1 Dec 2021 14:45:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 3ck9t1vx5t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 14:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gl2A99MA8/XI2ix7bnySjJ7OB74QtEis1DYau8wUjcSJvzB2Lv3eGWPqiYhv5X3y3/G13pArLo01erNHeVfxG7ah+g/U2347EUrLLnkxNJg5whmqSyVeg+/wELyfgna00jHoPN+2KDCHk82A/v5h3YDgbSRQd2Wzy5BkeN8rZgtAF71aZ7wpcGQHSVqmPbCrHs5mSfgrmIFzbvQ/EcN21TkdXlux2TnEXpCF0uIuuGC1WGC+UfVESVDjyUNPoCFT9G2tnERz+ocDD4GnTn3M1g2wtjxl0RkDgGN5UXxo4w3sRQGIXmcvxYB+ADw9WzBzBE1PIrkTZwZh2BOMmMIvEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBbB0fp+px1Opa22QW3LznUzW8Dd+yoxa7MigIkmiIo=;
 b=ePPgYG4teQxOH6wZl6+3tzKuOM6ViEbTHkwaVzzMgXWL6qyeDU5fdMWEhm5rMVOzsJoWfUOrs6ntL7MMXhHbY+hYxAk3qKCtVSE3AKPcWBulqNIVy09rDdeFkkbobW9AB8sJxjTpRF/2nANp9QH9buksUlAnWsCdgzXoaoeq18EseXYUjATZ5xdqRFybbPoO/gANeCAZgMsyuolON1WFksIfz9SLMR+S8829Ilj4h57Zd58ZE/IySH/0hMzAzFToKr8sXRlotDGLv3F2wY5XPLAktw7ReJuULDbUmP/Kh33D8QHZ0lgeoGCQOBQBt1S1f3JVJ/YwEpyzZuLh48h14w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBbB0fp+px1Opa22QW3LznUzW8Dd+yoxa7MigIkmiIo=;
 b=P3sAPQD1N3I1MV3+cCV0lTUJ0mZmnoULFg10dBJOlmXNEoENjc3ZazXRk+NXviyw+FUkR0oQiZ2jmXvvUEJSIUxbHmMnghNhfGmc4b1GBsPZxi/W14vjuX3evtk62cW/iL4s4rNBBYLrVrqvH0L8nq7JlIqW1MF4rfpFKtcaG7Q=
Received: from SN4PR10MB5559.namprd10.prod.outlook.com (2603:10b6:806:202::16)
 by SN6PR10MB2815.namprd10.prod.outlook.com (2603:10b6:805:d1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14; Wed, 1 Dec
 2021 14:45:30 +0000
Received: from SN4PR10MB5559.namprd10.prod.outlook.com
 ([fe80::7514:eec6:460d:a074]) by SN4PR10MB5559.namprd10.prod.outlook.com
 ([fe80::7514:eec6:460d:a074%5]) with mapi id 15.20.4755.015; Wed, 1 Dec 2021
 14:45:30 +0000
From:   William Kucharski <william.kucharski@oracle.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH V2] net/rds: correct socket tunable error in rds_tcp_tune()
Date:   Wed,  1 Dec 2021 07:45:22 -0700
Message-Id: <20211201144522.557669-1-william.kucharski@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY4PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:903:152::30) To SN4PR10MB5559.namprd10.prod.outlook.com
 (2603:10b6:806:202::16)
MIME-Version: 1.0
Received: from localhost.localdomain (2601:285:8200:efd:34b9:1074:928e:e052) by CY4PR13CA0092.namprd13.prod.outlook.com (2603:10b6:903:152::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7 via Frontend Transport; Wed, 1 Dec 2021 14:45:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb19cfdc-f8c7-4b45-9b6d-08d9b4d93860
X-MS-TrafficTypeDiagnostic: SN6PR10MB2815:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2815632E07C9DA3557D025EE81689@SN6PR10MB2815.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uOlqPP+0Vrlcoi6XWS0mjelrBpZnmj+Ws9X6ft9nKx9JwinjZNFLQcjH8+yuK8a3hOPiGHuigaevQQP0jDr2CCdtV2O2q1YSmpaEoFeNcg3UN4qkYMH6fiWjkmaWl5FovJcqU/I0NFCXZ1M7qEKTxQWJZumxd4xGmj/TB8PSNeUwfIkNVZQMbTEHwCk71U5CEmeqDCzNlSCXcIC1sQVWWDvJleV+Ya0N71H0CeZPaNkDZl6itoKqIMUwXUpz/xoVUtHp5f+T8uGEMxmxvmhHsbOmmOXJmeVDe+bVbkzZRd+4yuzGFne+rjpiZPY4LLLDx6/yhGKPG1j7YrVLolMSSGET+TlamEX/S9ged4pBnibr9b5mvvLTPoyQT2qFycXgZS5R8CWBXwrWI8ObyP6hsdYFiCtNX9r+DgHbuxt5mYc7ZGzH85AGu7FbqTqpycdoKK5uoGn3BTWMtBiD8XbIbvY1kL8ssTUvr66xeQ3T6fIYAfw2DANKZTKbd3UPDmgIrdvx/2M3De3S/iMf+QfDBIkizgkfhnZAeg//ooaBQx//BJWAqQxJI6jnX2g8gTuRAI03/fM4IObwz96OZhmJEm/1CubYoxQKhWTh5TKwB+QqSR7uybS5cIE1JO+7kIdGGjM0ro73AFGwkoMmszJw6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5559.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(5660300002)(52116002)(6666004)(83380400001)(38100700002)(2616005)(2906002)(508600001)(4326008)(4744005)(86362001)(186003)(54906003)(1076003)(6486002)(6512007)(36756003)(6506007)(66946007)(8936002)(44832011)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+03QgnIzcJ/AyPoDfK17BSzoCVKTSyNcH7/klxj1FUStAruwXn1DBEsHpCRE?=
 =?us-ascii?Q?IrrKgalflWmjB/0pQhZBFVYsNBzcIquSUEx+r6ebTNrfS8Se5C7PgH43Dhux?=
 =?us-ascii?Q?DxyFaFl7BBwm3vK0TXkQpeh8guGE8r6cMfXYq6Vxdf0VxGB/2jQIvOtkbKNZ?=
 =?us-ascii?Q?qmWz4+dE4KBMO7cbx8XEQJVNTc5lCvcZZmdx2Wo9aZkzQZVGb4yW7lrmAEA4?=
 =?us-ascii?Q?eq1YcrTaLTwy+4GnpiEoe/1NVSQAqTCXhk+tbKTIgZ1lsC0k9wYg7ueuTyV/?=
 =?us-ascii?Q?I7hT/RoFUG0kRSUxtpI8imKuEeLzUM66GFpnVxJnRi4AKuJbaytTAi6H3Eih?=
 =?us-ascii?Q?9o3HYg/b5SHEyRhX58AJ1A9bHDFpPNQPOWY6KgeYBg3Za2XWW1F+7mDHO3y1?=
 =?us-ascii?Q?lTbSU1ObG617G+wfeJxPnlMxhFiu55RagGiKOd+DhIeMPXqhmbwr/cxfDmZ3?=
 =?us-ascii?Q?KzyuiYAMuw+mqgYToErCun7qh9njg3CeMtrG+aJ3YG1oP8UxS0Tcf5pEXC4I?=
 =?us-ascii?Q?LbTtyfNJADg+/agIRIzTxMuhczdGLGjRbJb0JZkiqP2dd9SD44oAsVQUquu5?=
 =?us-ascii?Q?s8Df841eJxn0W3XypxWhfyQOC4DgTz4q4xpKkCtWmwbXr7BcGxpf0f/Pq7Zn?=
 =?us-ascii?Q?G/SOnCTbX+conqbCaFVMYJbTrwnHbBlViRayIctyNvD/j6RlnBLgyY+F/uXZ?=
 =?us-ascii?Q?c39rHbQ/TWWNrsTRbE2sEVkbDLyALPwm/xSJeLU8xTyakYb7RAeBJ4bJ3LCp?=
 =?us-ascii?Q?SFQqIndoQHp8wt4F1t3f6fThGP/YTlCWWx6mDSn1DtCzHB3ur8wcVOqaqv06?=
 =?us-ascii?Q?L6cIMTocsIvuE8r9mFsZxeJGRw+G8HMG66/pbxFgzm1TvvEO8LrmBsHvCGVj?=
 =?us-ascii?Q?qlGmY465loeZYkOJQOmPAH/szes3opW/QUg5Z67yAkA2/LJh7WqtMx22eD89?=
 =?us-ascii?Q?E0+ethBS5hTsnV2fSFad2uzG7hmmahx8SFXmBkPIav1U9eoSDz3k9DKItvp9?=
 =?us-ascii?Q?Jsn6AtQEf8yurW33mRZf/0N7tW2fS0kuZZAf1yMS+LPeoczEzpsx+wRyO+QH?=
 =?us-ascii?Q?S5uGU+0U7kMVIF2gQEthVINDBW8v9o3XyR96T0R+WDK7mzkiQBIEYK+EJjJH?=
 =?us-ascii?Q?i8hMgh1THPe4Cvo5e79FOYv41kDcWeHVjt0NZ/2/yO55eY43vtNDGqYSaceE?=
 =?us-ascii?Q?hBool3dWv4aWsOcKWoHA1WozGKjRfXRoIAe1NLayZ6/8nt8gpa0RKIn0Ta+Q?=
 =?us-ascii?Q?K9GgV5q1QOrscMHmmI/rs+HAGe8oF3JCJD1viGZLuwZvVwQEWBymX0AKgD3h?=
 =?us-ascii?Q?jG6bJk9TEZEjytW0aY2gk3cPNkZmngDZMxJb3PigjX8YvL8YTN0VLbhHN01y?=
 =?us-ascii?Q?am1tOMVrAq7i0XBqZuq1/RULhiwhZeCfa4c35E3akISv8B85NrsCZeQ6nbuR?=
 =?us-ascii?Q?mHof0YxMSi2dEezIhUSMZGz89HLQvdjTSnUp/C/Nu1aGAKSbNevRMwvGIpqx?=
 =?us-ascii?Q?yZHz+ndw91GN7dtqVAvYBWtW611mcV2rhj4QgVeBez2ZwcBOn87bhl86ss3E?=
 =?us-ascii?Q?41M9dNkX2Pp4p+adfkTfVO53ZCvoBile+Dxo7KKUGLNdI0DeLPSj5WaDZpSM?=
 =?us-ascii?Q?bzbVqv6jPFai0xUBSIMP20++/2iExqp0/jYgAIuTdu0NtTdH6QhV3vSL/LKC?=
 =?us-ascii?Q?qrU1G6+f/DLrvGx0VCcU4tfPPOlcUZYwaoeSQ+wSS/QyPxW3LYQvyDMBAbNw?=
 =?us-ascii?Q?sB6UwMNdhg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb19cfdc-f8c7-4b45-9b6d-08d9b4d93860
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5559.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 14:45:29.8624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6bKMaYHHC2ovzdLFuKQA2EjRglMoHafhNj/Y4IesDgr3Nfjtzzgc0b0G5aHHS7VIieUzOodTH60iQyh9zHMamGvkf0aghN7WVwHIz9x02o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2815
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010083
X-Proofpoint-ORIG-GUID: 7q0Zu--BxEV1bFbVpX8JRt4eASXe0uF_
X-Proofpoint-GUID: 7q0Zu--BxEV1bFbVpX8JRt4eASXe0uF_
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct an error where setting /proc/sys/net/rds/tcp/rds_tcp_rcvbuf would
instead modify the socket's sk_sndbuf and would leave sk_rcvbuf untouched.

Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
---
V2: Add Fixes tag to refer to original commit that introduced the issue

 net/rds/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index abf19c0e3ba0..5327d130c4b5 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -500,7 +500,7 @@ void rds_tcp_tune(struct socket *sock)
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	}
 	if (rtn->rcvbuf_size > 0) {
-		sk->sk_sndbuf = rtn->rcvbuf_size;
+		sk->sk_rcvbuf = rtn->rcvbuf_size;
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
 	release_sock(sk);
-- 
2.33.1

