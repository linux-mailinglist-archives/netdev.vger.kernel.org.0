Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A3197602
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgC3HwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:52:20 -0400
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:57681
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728766AbgC3HwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:52:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLugNphxtPWqqUTjV/ZS+gQ8SBwTQKUKrJTpH3Uugv9V3Q6LL94z2JvoHYXU6aoqDDBqVvgTYPFzTPp1mqgme/vuGJEnjIl1yOqd77VUIceTduqF/cXp8Ae7eJbz15YnRFnUPDAhJ3v3cIkzd9XWWJSLRGmJZC3607qBzYLwBCi5HDnFL3TdygXJCRfe4GZPOyP/cYlt9VWBsDZuqfZeOBL/CKpciSrrv7jHP4YHXpL1XiXs+PwD0JnQwG82q52159YASjaz5c99a/2++xHYLnS7LJgawpkHDOgWbWXOppoFosZGcjTd3l3djtBcTYCACvYUfT+t+RcVHzI8hI8Qmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reEli7mj2SJZ5DivoPlUiZY8DVAkjARajVt4Wc3S7zw=;
 b=Lc2M7Ypcfv6Qg1R2BPYD0m8NiUXoqLOODlr8B5tUXXHUa+FDQrjng1R+QvWF3Rn5AYghU0iXBOrXV44lUr1hOIftToRfW+1erb+g1wmOAnHrPGanf79kM2HWCodnso2UJwC0QQKvNdUG3SzWx5lqAz+MxzzJwr+L2nQX6ShHF1STD0RrS7HNAL5aTsOiR+jaJEtUJhFOkuKCboucVKo57uFXL4A8Hb+ticBxGrhDyQhtpuTxFoDlVQKF0Ve+3q5vRmU5Qp9kxVsP7oxLdDY6lf12FrBZPwX8s0VhrBAs0QV43Li3qM44HN+D1TKlHCfeCnPfg23kD+/lVdcPaLJ4eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reEli7mj2SJZ5DivoPlUiZY8DVAkjARajVt4Wc3S7zw=;
 b=NkU4e3vaDkjOUcHh4arnMPA4uiUTb6o2pLa1SKj2StkIOmXW3l9uEv0ukXgezBzHFSJnYewPas9Qr9bUBj7PyWaYBDPeWLwKnxtG3jki1Yj/Jfwp0M3A3cGV0MBG6CiCFIAoLMnFO65rMkwTr/JnZioVyDA2Il/KaHpJAWDcs5g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3214.eurprd05.prod.outlook.com (10.175.243.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Mon, 30 Mar 2020 07:52:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:52:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next] bpf: tcp: Fix unused-function warnings
Date:   Mon, 30 Mar 2020 00:49:09 -0700
Message-Id: <20200330074909.174753-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0015.namprd04.prod.outlook.com (2603:10b6:a03:1d0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 07:52:13 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb15a3fe-5ff0-4ddf-14e9-08d7d47f4372
X-MS-TrafficTypeDiagnostic: VI1PR05MB3214:|VI1PR05MB3214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32141EB05BCE65D8B4570B1ABECB0@VI1PR05MB3214.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:63;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(6506007)(66946007)(66556008)(86362001)(66476007)(316002)(478600001)(52116002)(54906003)(1076003)(5660300002)(2906002)(6512007)(6486002)(4326008)(6666004)(956004)(186003)(6916009)(36756003)(8676002)(2616005)(81156014)(16526019)(8936002)(26005)(81166006)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +e64T2/kvw/TCwN8boxTtU51lZUTw3zWVdOMS19cKqYCffU9nJedyj76jtkLTdc1WwOfoKdYYoWqfSvPkkqzKxxVxIKU8sGBqS1NJuy3/6HpYmuxP9AsDwag1QhLCZg7M432M68Dud/ttqUaxYSIdlG5Ixe0jVc+1Ev0NVi2bvL21CbW26p5TRY6n88+Idah3+DAUtCEBR89MNsYcciZPmehuEfjnln4a8o4Oo9gcq6KwvZsxpFDdcwrEcR6lxI5nHyEc9eEMDo2zt589Sk0qozWQFIa8cOcMJU9UfSmzPV/lsZAT14Sfs7YbHyzrV1hurSJWjyXw+FGxfUzZSNxwofYWSxDMcqTfZqVVgwvfk36GSSdD7ceRoCxwROQ8Z3eXR9f/Ni8kQ87AjFdz0AzOJIZlxMkna5Xl6ERQWbC/niFVa/b8Xhyqh7X/RvHcHURssfJ7+nlUPcaniCyjGniI69KamowPIawG0efzGdzhmlzWyY96QA/Y19vDnDa9r7h
X-MS-Exchange-AntiSpam-MessageData: QriBwtMpOeVIE9bWIuFVjbWzZSlk0K0mn+3DXNGN9Z+SxP/6vvH2mLlXsxMSdA6eQwv2Fc3r8vmzWu05oDmiJL8bOF3wta7MUXrgE4U4nh8KBUADYWSox+wffrneGIFYXg2HMooT+5+CP4OPu9eczg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb15a3fe-5ff0-4ddf-14e9-08d7d47f4372
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 07:52:15.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8E6ojp2RkXjTNMnQCKMcIogyxetEgdahcy7aPMZ6UMYlCYyM8PPSsO0cftC1DtdqwCFlqBuTvHckGBQLMxq1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_bpf_sendpage, tcp_bpf_sendmsg, tcp_bpf_send_verdict and
tcp_bpf_stream_read are only used when CONFIG_BPF_STREAM_PARSER is ON,
make sure they are defined under this flag as well.

Fixed compiler warnings:

net/ipv4/tcp_bpf.c:483:12:
warning: ‘tcp_bpf_sendpage’ defined but not used [-Wunused-function]
 static int tcp_bpf_sendpage(struct sock *sk, struct page *page, ...
            ^~~~~~~~~~~~~~~~
net/ipv4/tcp_bpf.c:395:12:
warning: ‘tcp_bpf_sendmsg’ defined but not used [-Wunused-function]
 static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr, ...
            ^~~~~~~~~~~~~~~
net/ipv4/tcp_bpf.c:13:13:
warning: ‘tcp_bpf_stream_read’ defined but not used [-Wunused-function]
 static bool tcp_bpf_stream_read(const struct sock *sk)

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/ipv4/tcp_bpf.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index fe7b4fbc31c1..2a7efc5dab96 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,19 +10,6 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
-static bool tcp_bpf_stream_read(const struct sock *sk)
-{
-	struct sk_psock *psock;
-	bool empty = true;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (likely(psock))
-		empty = list_empty(&psock->ingress_msg);
-	rcu_read_unlock();
-	return !empty;
-}
-
 static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 			     int flags, long timeo, int *err)
 {
@@ -298,6 +285,21 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
+#ifdef CONFIG_BPF_STREAM_PARSER
+
+static bool tcp_bpf_stream_read(const struct sock *sk)
+{
+	struct sk_psock *psock;
+	bool empty = true;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (likely(psock))
+		empty = list_empty(&psock->ingress_msg);
+	rcu_read_unlock();
+	return !empty;
+}
+
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
@@ -528,7 +530,6 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
 	return copied ? copied : err;
 }
 
-#ifdef CONFIG_BPF_STREAM_PARSER
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
-- 
2.25.1

