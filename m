Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FE7387370
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 09:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347232AbhERHpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 03:45:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38284 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239746AbhERHpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 03:45:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14I7YrOJ194741;
        Tue, 18 May 2021 07:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3/Lemjh3GNztbMfZritdQcQEjPG/zvuY2VSF+TTIYT4=;
 b=LqUgfmase9XqaStJKYXMWR0x6lAf0aK3YY8I0wVdhy/fE5dFgn8WJ5U+TJmKcbdiExi0
 SmrPx28Qdv6aMSXcnxyulxnpdgi4isQU4+rJrVjgjYvL+XfbkwY5NCTCABZmxXdhtW43
 hx0zbR+t5ou/4+8xhZ+IpTqi3gmkz6qMtWbiONxl6Q/qDAx5AxGXT6JVbUV+VmEV8NdU
 2pw4jf5BMWbYWh5nRaZqp1UWT0a4cnkD+tmUKCmOrUydyv/B4Qd8YLGqk93Nb8Ejn9b3
 QVkdLTnnxY87v8klJwGbcaMRI1aaV2amYwPpc0XlbQdX2wzUy5btRW4lQRZoCUExISN8 uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38j68mdd2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 07:43:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14I7eONx155427;
        Tue, 18 May 2021 07:43:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 38kb37pgy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 07:43:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW/YolgYCOVJ7UYLyJL4DkFo0qvG/0TpW/+yQokHhWU5SgHFwyq/cQAXGcoQMTcDgAjH2+8oSSo19qmmU6BI7wmRYcbqlu/qtkhe3DrdWc/GlPObGufPTw+c5ZvZHN7PAQMWt3kgCvzCTi880pS+47sxtuUuP8VZ47peGOl4NC9ln5XadPNCSPeIzmCbuCrM5/McDdYIZJfGDdHGvmVv7kM+ceVAeikdVhapBQ40hQ1hDiTGl2w7vgLu7/ZKFs+jogZtDOIDtrYYqsITgL7w76Mhdb4jIUe/w7Qzd1m6Q4xFhCwrTqq/q/yzFWuhmG7y6H4QpAWJ+1DTLbMonT8Aeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/Lemjh3GNztbMfZritdQcQEjPG/zvuY2VSF+TTIYT4=;
 b=X19N4ps6oC6FkD+0fJHf5dwCfK3EcygA+vJSqW1/WQvi1FyeNTheeXB38H7dVkv4AU14EXUpw9riuUukSY1/pzuho7TqqScbqY8i2fJqGmdo9fRv1OrGNE9wOnnsjaTukTfme/pWCeanqkKkBVu7Uau0YnIn18/TLXwSOu4Umi4gbXoKgyaI0BPP3oMSxJim3M2yeXPMrnDu48L4XNINHwTX5TAi8Mu5vS2O8b+bO9Dm5INNmj9LAwlA5vcBii1ScpPSu7s9OVisWox1KRO96Q3Bw6izqlfBnA0pFZfv1uAEuJegc8su2Jn3H85ejV//scjHHtTpR91giRwKD46goA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/Lemjh3GNztbMfZritdQcQEjPG/zvuY2VSF+TTIYT4=;
 b=kt4GPF32YsSeul1Y/npOwqailSXZJZzGrfaGQCPqj5i6dAR/Ue9FD4zukXNIaOoZcAJnZ+rI2vv0QEwgmt+eelBwlT1v/9aDOdig1MllDv+pOZC8tjY3ydmXKpgqemuGBl+s+DO5kOVGmUhWJVRjDATFgwOtoJUKCLpBNmvwRTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3717.namprd10.prod.outlook.com (2603:10b6:a03:11a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 07:43:51 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b%7]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 07:43:51 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        matthew.wilcox@oracle.com, rao.shoaib@oracle.com
Subject: [RFC net-next af_unix v1 1/1] net:af_unix: Allow unix sockets to raise SIGURG
Date:   Tue, 18 May 2021 00:43:43 -0700
Message-Id: <20210518074343.980438-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SA9PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:806:21::8) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SA9PR13CA0003.namprd13.prod.outlook.com (2603:10b6:806:21::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Tue, 18 May 2021 07:43:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 014a99d6-f73e-40ad-6ad5-08d919d0adcc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3717365DBA73C2F0D6D36E4FEF2C9@BYAPR10MB3717.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dPaF69XeouZW/iY+pFdHw8sjicyNW13bjECfBCvFaCYoT7Z8Oe3G+HPK3XRVoe4OzJHxIskhZDiWUIHXTAx0XhTc92b7/3qpbeuQf4YdZU2/7uWJOk2h4QM9xWrDJvJSfM4W///KW+YPGkr+sW0HIYwtLED1cQwYN7JgLr1066UpEA/H3E5SIO4K8Cb+lpQX77Y1h4YRnk/Jvi7QFgmqq1Cd0x7/PBdKjjNXXzf1I8oDAKGz8BQXPRNw755O5Kd8dusw5sAoLj2OkLCDwuCWbrt1mDxj5Vo13kR/rK54wlXYk+2wcalFnlht1Y/XLGFa23o34hOE8CH5jvN8+RxiH22r34bW1ujR7Xz/PO8/lLuHGXtDsXxMqKcfyHdJ1OkyBblwybWxFxnVh9I/cgON61lgOobMbbgSzs3wuUzw9A4+DTCPUI2Cs3eWMOAQJXqzK4DrTuhJCkwEwLRTei0kaZNBgnaz8BCCClQqBAf/DMusgkeYE+Tt7jFn642Q4lr7L/p15e3PyjAutcjX05ry20govucDeXsGym3ETZzzHTeQDl7gCUDqjPhK8J+YrzSwauof4VtmdEne6CgDDAKW0cFb/h5Im4QLrHAmIb+FW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(2616005)(316002)(107886003)(66476007)(66556008)(66946007)(8936002)(36756003)(8676002)(6916009)(52116002)(5660300002)(86362001)(6666004)(1076003)(38100700002)(2906002)(4326008)(7696005)(186003)(83380400001)(6486002)(16526019)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IFS2v1/jbBqq5dduhqq+MGUDO+f5gyksRDZ8N13cvUJFwvsEl7j8LvheG6dS?=
 =?us-ascii?Q?LclCsOrYvfTMm02yVrwVe7sY9ERxluxMKxXF4/i1NisDYGv7Keo6YQiTEGM/?=
 =?us-ascii?Q?WnraHl9XqT+mpIviK0vqEkMPZ5mjClhlbTr3AINYOxljNtb47fiZ+L11kGlf?=
 =?us-ascii?Q?XldMSSo6ialTQEnr5AxSGIbBwiFaxc7S5FRgQtc2YJ3ahgDj4qZwrGrszRv3?=
 =?us-ascii?Q?k2pH/jjDdsgeytqqVUHvDAKZYRaXXJfTjV2FMKSeXfnt5rbK0n8SIFlACgJB?=
 =?us-ascii?Q?CfEeRcGoakIeu95b4n0uHBLPZFo0d7LQkvZ5FQpveAv6ywIL1rq6sc3WZf3U?=
 =?us-ascii?Q?YgK5kW9RZ5T4XazNw3vjcJp6BBW5ZQ+/KRa8MnIgH9J/0E1FGOIBhRpVYanA?=
 =?us-ascii?Q?8ESU7pjLve364XcRr5dnGqy6YJivJb+YSUvOj+WvoCaO3tG9+Otp7CQny99F?=
 =?us-ascii?Q?zzvN46kG1/ybdNyfN5qGUER4gPBVPzUMuHg7HYXGkws+7s+rSXtMcc6FEZ1+?=
 =?us-ascii?Q?F6LXv3aI8L75O2vBZ9fd38vKLafiNxTO5Ia+SdNVTflvLJkVWornNG8tRXG5?=
 =?us-ascii?Q?xviUA0ZFll7VvcA5zYPZGQNnvFJ78sFcEnIRx6XuJ+YOeZxOliwguoTMi3ns?=
 =?us-ascii?Q?QxMGCM7fy0FxQnGBCvXvKr6Qt1kPt7W6JOgekmGmd9l9W3/CkhuyedGTBn5R?=
 =?us-ascii?Q?3gQ1DG8rKVcfRTrILUTkXoKL60mpw4kxJAuELEwhrxVr42Jz+pNdHQPbJk0d?=
 =?us-ascii?Q?c7IT9ERVi96adu6jXPjOPfYj8jItLp+YG4wZabT5Ssvp48nJZFgc7ypu3t4a?=
 =?us-ascii?Q?5xK6/sjPexE3oWRIOLISh7i5iXf293OOCcN3bkqcwqXrYuMegOS7hPl5ddld?=
 =?us-ascii?Q?ZyB+9sRRkia+xbK/smmvM8VqrbdLwQtmCpE1iQZEy2wqkdSL4WM4qBlM4rmX?=
 =?us-ascii?Q?eO6yX0Rt+WTmS+Mvx7HwxC09m1PcJP7VGv0/BkR0XDarf2b+IWyPJRA0gH/S?=
 =?us-ascii?Q?NhpokDp7nDN4fzpov18m7MzqyYw1/VtHcjsY3h9Y3h/U2wRbhn2YqRrad9Ki?=
 =?us-ascii?Q?uGk+aW9Y74uOz/jCnmE3YzFvNeVdETl+YIuRFXa0aLmVhXxRgJVLe9kfBK/E?=
 =?us-ascii?Q?4Tnl0P8ZiDTxXQfphZgSSZYC3IamdsTSb1cEOsKvFPZK9X6u2xy9ZxlV+z+T?=
 =?us-ascii?Q?f3TFkbMv02z3fpxZ2AkzLmzrZx3+AADkzHROz6icAjvO5LBS1obBIC14opF0?=
 =?us-ascii?Q?acubNjTw0w8MsH57Jo/LD/UIY+Dw2uczEqAEAUbjs1Tncl2TQ3jFr9uXQtYe?=
 =?us-ascii?Q?GbW+QxHb5vrlrFt5FeoatwUYbfbtTDI1bZrVgSl9OP5X4w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 014a99d6-f73e-40ad-6ad5-08d919d0adcc
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 07:43:51.0955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35878THLTdlB3PiQIMV5Wuu90liisEKli6fviP+y4Q8nuhTnPB9yy/au0DmQtdGgbiWGqk1jyYVNTW2MGDZOkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3717
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9987 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105180054
X-Proofpoint-ORIG-GUID: XgBvNntRkGa_bIGs07Yn2oXX0ybUZUP9
X-Proofpoint-GUID: XgBvNntRkGa_bIGs07Yn2oXX0ybUZUP9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9987 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1011
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

TCP sockets allow SIGURG to be sent to the process holding the other
end of the socket.  Extend Unix sockets to have the same ability.

The API is the same in that the sender uses sendmsg() with MSG_OOB to
raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
SO_OOBINLINE set.

SIGURG is ignored by default, so applications which do not know about this
feature will be unaffected.  In addition to installing a SIGURG handler,
the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
which process or thread should receive the signal.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
Signed-off-by: Matthew Wilcox <matthew.wilcox@oracle.com>
---
 net/unix/af_unix.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76..c8400c002882 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1838,8 +1838,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		return err;
 
 	err = -EOPNOTSUPP;
-	if (msg->msg_flags&MSG_OOB)
-		goto out_err;
 
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
@@ -1904,6 +1902,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
+	if (msg->msg_flags & MSG_OOB)
+		sk_send_sigurg(other);
+
 	scm_destroy(&scm);
 
 	return sent;
-- 
2.31.1

