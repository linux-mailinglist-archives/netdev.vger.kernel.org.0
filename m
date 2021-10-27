Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D0B43D629
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhJ0WC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:02:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37792 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229830AbhJ0WC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:02:26 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RKWVBr028933;
        Wed, 27 Oct 2021 21:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cLH/fEZDRGa1Ssej5YhuVGwi//eD5IH6a6cU91dxRqc=;
 b=j2dUYE1a1uRt4ubUTtE1Ru/cBOVqGX7xEDopOvmoIPCYpx27q5gEjwazGm78J981o50I
 CdXY01pJa4fmnjZcmOtxoQ/orQMIYgvKfWYvlZGT9N3RVPoxg+NRk+7Y1KVbeZ0Tfu5I
 H0rbEpuwX+GOgNKRd4sS+ZYc8H4rTto9ShIu4ldLf0y9tXLOsctjZy98i7J0gj7ldw33
 LKeh6L8BwjN+b/ij/0ztjQrZ4rr3FYHxZQOE/+/vPzEBSgzKVkMmDScMirn28cc/Aay9
 Ya4pBtX8L8ryf2u2go1rEr3oATu7kPBbPHzwZTw2xWYalked9tVG1I8CoNw3GSPTpbcJ Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fjnxgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 21:59:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RLtJdM084040;
        Wed, 27 Oct 2021 21:59:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 3bx4gaktjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 21:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/aLsOoVOYJ4RxeqIcXRv2ODis1WZYCRC60WMfJaY27/XAotxfv0hNcc3raHyK+ruqC1bacBWybmajhO6cAYixixMcINmv4epPimgy/rJ8XCmgCPIXBjgNbloUucm4pkX1BcvBlE5AA+ITu862LM95zHMPnAwufnrVxfoZ2UNAfg3SiEtKBMejnZ8MQb+tKhuMbYhTevYAITCZFw/Y3Jng3OMczXoA/id3dlfcI3AzurZieDrWBT34L4GFxmvYl5bsk8wwZOl3Daz/f0alFOyUPmQ8ZephIuCn+C/drUf7FCDe+Bm4V4AcWYDCFeWSGy7tiiXprT7eT7kIuiCjthWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLH/fEZDRGa1Ssej5YhuVGwi//eD5IH6a6cU91dxRqc=;
 b=im5iZDdnRq93vCeOBZZpEM7edpraHZG9UrJ5d9jhKzyVrG3AXLnFYtgvHUBhr3YoKC3cKyx4r9ZIfpzSa6J0OHFGtakJ2sT7fgB9e+e/2uyLY6+MAQm6Wfvy826ldxvmBVYc6mkbWPutdpfiXLjTB9+z8wD8/p7KdGJnn7yJsxNeoU+ArDSWtcapOEmGRqr5xyY8BaIoMPf7RmiiYjnHFUycdtIt4bWHCjm0EZkHME2E9OUtV8aj7ySU8ZQsd8bxr/aEHHXPlQ61nU2AcP+IFUln/NVWhpQg3PAoJUjKU+iZoNCeTKCt+52bgjZDpdbhTPkGw7tShB3KBJQEpZ8RUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLH/fEZDRGa1Ssej5YhuVGwi//eD5IH6a6cU91dxRqc=;
 b=s+YV23zECLI/U+aWPpzGEnr5dTAeY52OkDOkhwaA7JZ5t8ucbzAswosrfm3nvii33LAMimlJ59OiLxhcL736pGw8p4ywYqLXsPx9bjouXpmmVcTdJOZvhMoGuOuDY5nMNP9rdc4tok+AXQ8h/8HCaz4V8xdATw1Y000u5dnNWG4=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by SJ0PR10MB4558.namprd10.prod.outlook.com (2603:10b6:a03:2d8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 21:59:36 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03%6]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 21:59:36 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Vakul Garg <vakul.garg@nxp.com>
Cc:     netdev@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH net v2 1/2] net/tls: Fix flipped sign in tls_err_abort() calls
Date:   Wed, 27 Oct 2021 17:59:20 -0400
Message-Id: <20211027215921.1187090-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0386.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::31) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0386.namprd13.prod.outlook.com (2603:10b6:208:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Wed, 27 Oct 2021 21:59:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7565acfb-5ec6-4db0-e2d1-08d999951095
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4558:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45584E71C72B7BB0049BB810D9859@SJ0PR10MB4558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUSb1VP+yVwt+0SwG9PCdZrDkLpgfgz4unYWkVE2/qog06kag5duOcD1aIzCUX+mYZrU3lervksUSONVWwa15v7oMY7WEqzaWOGdiL5BxmUAg6j3Jo2JzWfCUR2tuQZwOCCO9hFI8CyWeJxLQT+CIn45ygxAYcK0VSkcYaNEAsxvsVkVKIGcUUHYMsh12AGskPdaUJUU3LBnz/3lfPUt9fVeDub2zYWxFbty7RdF7tOjJPaxzAv6v+mQjOrfkYu2RRA6e5ftIUbESU6JxoSZHUVhO1aA8m81ffkhE2GCjPz6CgyYkIdQ7RTNjGJt95Bjr7QHahXuQEImYlheXLTTBej/DrqF1v8YjPivR7d7T/e1qUfYf/z1cFCNVf2Q7Juv9eBvNdj/M/Hc3FhFAOj5peNIXqxezDMhyYYRPtuJZLcqnf/cii5Ld2c6S3vyE07CuSgN9qgBBavaTrtZpGliFG8mv0J74+qMoaPBM7VjMKG/RRaqSZxQx1J8YWeABRXNaVErQil+zl5mmcmU9a8VVUdEAn0iJ/gNL5y7xz6vWhQ8UDasa59X/DCVDIwT+acGCv7yLVvln5Owrc/82tPr3fmpPa4jHHIXXWmsbWcq1eUZ9F7o0uajqQjfXQWQHZv/ShNoYbY5weSQ+ursdian05+zSKuIf4ZLVPzcdvYLPCrWjIWq8jjuW/dAQatU6POENhyFkfKZU24whAsUbwHClA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(956004)(4326008)(6512007)(26005)(66476007)(83380400001)(6486002)(52116002)(5660300002)(6506007)(36756003)(2616005)(1076003)(107886003)(38100700002)(66556008)(66946007)(2906002)(316002)(8676002)(110136005)(6666004)(38350700002)(103116003)(86362001)(8936002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?21Avb6JW/FXL7ikUNvzLQzXxO1rsAhjgTJBcOeUjz86Ifhka1X5NdcULKD4R?=
 =?us-ascii?Q?m6jqWeI7xMwmANSR0yyUxOPjTgplwS7fKaS4GGol7eSdTLj2Hsqpo96EFGnv?=
 =?us-ascii?Q?BaI7weq6ezP5sT5vCsTJizUKPdWMiU/LNv8IbInynVLklprE7erRbVps2qyt?=
 =?us-ascii?Q?JBh4RncyhgWxlv85UqiGFJF13clz4qvJHWsvcvX376n+geMdowywIU8Elh4/?=
 =?us-ascii?Q?WiS+6K5d3nrYNjcBPEePXxz4G7ye9NkLjENymv8cji/3B+OpN5tiPfM3F7Of?=
 =?us-ascii?Q?w3BMbKT6zWGw4iEeZI+iqaoRjpTEo8fzRBvbEBb8ygsQjGw3uLbcgfIoKW+F?=
 =?us-ascii?Q?a+vEuVuXLxlkSJdfOvhLpO42m+pTymC+RU3SRRXYFabqbkpI0J9dk0hoLWaS?=
 =?us-ascii?Q?6TozMeJbGvavw2Q/Xh4WIFYABHKnK92ovpPdbsVhtfTrgE1rKZdfIcmFAAoX?=
 =?us-ascii?Q?ZE4H1DQNzepZ5OauZ7GZ3zDvsJRCd6CNGzmg405sb9i2YfbBul4PnwwDkAqg?=
 =?us-ascii?Q?WwqLxiLNphE0CGGLHmUDwamYmdDN8iefz51QtdnYDzRtLPsFLfLqQluBA9Uq?=
 =?us-ascii?Q?2/gC4a3Rx/BBDV+D3yiYxTcpPe/lRHj2mV14+1KIj/R7ICfpISVYB5iIdTbw?=
 =?us-ascii?Q?fVJas2tJF15Mx4OG77oczCq81i9iabnsOQjlDmhE5zXLCXTRTkeOG0ZI8XRu?=
 =?us-ascii?Q?MGh3Dkua+P3RXn3Bwj+TuznCsRK8C4ynk2PfVs8JKDPZhqat/UjNuaGxnPea?=
 =?us-ascii?Q?IdI/WzbJa7RBNH0vaRmeirsTEgrG7wISfNJhGr2TC9axPQcVeH8LJtaymDRE?=
 =?us-ascii?Q?XaVlfAw+iiGHOidoGkUmIjARA2K1Q0yjzaJDPOPKFXP33oVNPFR+5fJiIbI0?=
 =?us-ascii?Q?ijEA9cwJdzS23iiHcmGeibQiIwdxG89ahE9/V6HD21Ep68/NSILeasCddKtl?=
 =?us-ascii?Q?/PVgsWFb5RINzBadoyY8ooSiHb1TvSe0XvcVl6VyCD0tIKbHc3J9TNhKANLW?=
 =?us-ascii?Q?6hYg+Nltq2qUEm0qnZuhY0Ff+Vm7ikNGk4Q7G2EPTZumfLgiKUcqannOl5gG?=
 =?us-ascii?Q?HHgM2BcriW3d6zOk9V4ySm24KZJbDA7+BxHf5C6H+xIaScqJ3SAPBOTgQZBJ?=
 =?us-ascii?Q?0d3bMsA6zXzjFdzWf4nC1uldkc3c+jsMJKBzzjuOaHpcRbPbVEfc6NV1+d41?=
 =?us-ascii?Q?ku6r+j4jgprY3nIdl8CyUGFUpQ7cUAFlPOOxMGa4pWR689mvdKqkJGAuGf0u?=
 =?us-ascii?Q?h0ERI6ely29ORxLrwNlEtaWXR0jSetU95+g65v6w8laMoZRoBJdfvMRaAT0s?=
 =?us-ascii?Q?Qe/9NGx5TtoNXqye9AoI6HcDqWc2iG60CLJPknDMSmh1FKojDeLhm1+R6eq9?=
 =?us-ascii?Q?4wzTcilSIFVp7Io2lV5hY2qkaW3feYAsMdce013JuGgwdK75iW8U2g89STCi?=
 =?us-ascii?Q?hiFi0WagmIYInH9MwVrS6cWxaXE7uK5AckWQRma0ijOu/qCvPFOC1s9sblUu?=
 =?us-ascii?Q?9Mmfg+0glTOi7YEbox9OkvDrV0UvJs4htCeBts4JgbboaZUqD9KVS/uGIKGN?=
 =?us-ascii?Q?w0+3P3aV59nMVqLiOLP/nBRqUta8DiYOo+uHEi3uSgTDPHU995Xcmg4a0qsh?=
 =?us-ascii?Q?Z2yitDB2HQuhY+L18+tsSGWmQRqqaRsMeUi4xoXBRtEBZVkDyjoBT4lTglDF?=
 =?us-ascii?Q?axacUQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7565acfb-5ec6-4db0-e2d1-08d999951095
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 21:59:36.2048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IbIUOayYbBrR7DTuAUHPvc/FFuNhUKap3GYqexT70h25HZLahBZNb1SZbqFsadNrIGZYs2OEWAiGCJ9to6gucT3m6RJeXPKecb8A/pAt3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4558
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270121
X-Proofpoint-GUID: ISlozAHXu4Vid5anRfLD_hhna5V1mdO3
X-Proofpoint-ORIG-GUID: ISlozAHXu4Vid5anRfLD_hhna5V1mdO3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_err appears to expect a positive value, a convention that ktls
doesn't always follow and that leads to memory corruption in other code.
For instance,

    [kworker]
    tls_encrypt_done(..., err=<negative error from crypto request>)
      tls_err_abort(.., err)
        sk->sk_err = err;

    [task]
    splice_from_pipe_feed
      ...
        tls_sw_do_sendpage
          if (sk->sk_err) {
            ret = -sk->sk_err;  // ret is positive

    splice_from_pipe_feed (continued)
      ret = actor(...)  // ret is still positive and interpreted as bytes
                        // written, resulting in underflow of buf->len and
                        // sd->len, leading to huge buf->offset and bogus
                        // addresses computed in later calls to actor()

Fix all tls_err_abort() callers to pass a negative error code
consistently and centralize the error-prone sign flip there, throwing in
a warning to catch future misuse and uninlining the function so it
really does only warn once.

Cc: stable@vger.kernel.org
Fixes: c46234ebb4d1e ("tls: RX path for ktls")
Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/net/tls.h |  9 ++-------
 net/tls/tls_sw.c  | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 01d2e3744393..1fffb206f09f 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -358,6 +358,7 @@ int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
 int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 		  unsigned int optlen);
+void tls_err_abort(struct sock *sk, int err);
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
@@ -466,12 +467,6 @@ static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 #endif
 }
 
-static inline void tls_err_abort(struct sock *sk, int err)
-{
-	sk->sk_err = err;
-	sk_error_report(sk);
-}
-
 static inline bool tls_bigint_increment(unsigned char *seq, int len)
 {
 	int i;
@@ -512,7 +507,7 @@ static inline void tls_advance_record_sn(struct sock *sk,
 					 struct cipher_context *ctx)
 {
 	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	if (prot->version != TLS_1_3_VERSION &&
 	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d5d09bd817b7..1644f8baea19 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -35,6 +35,7 @@
  * SOFTWARE.
  */
 
+#include <linux/bug.h>
 #include <linux/sched/signal.h>
 #include <linux/module.h>
 #include <linux/splice.h>
@@ -43,6 +44,14 @@
 #include <net/strparser.h>
 #include <net/tls.h>
 
+noinline void tls_err_abort(struct sock *sk, int err)
+{
+	WARN_ON_ONCE(err >= 0);
+	/* sk->sk_err should contain a positive error code. */
+	sk->sk_err = -err;
+	sk_error_report(sk);
+}
+
 static int __skb_nsg(struct sk_buff *skb, int offset, int len,
                      unsigned int recursion_level)
 {
@@ -419,7 +428,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	return rc;
 }
@@ -763,7 +772,7 @@ static int tls_push_record(struct sock *sk, int flags,
 			       msg_pl->sg.size + prot->tail_size, i);
 	if (rc < 0) {
 		if (rc != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			if (split) {
 				tls_ctx->pending_open_record_frags = true;
 				tls_merge_open_record(sk, rec, tmp, orig_end);
@@ -1827,7 +1836,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
 					 &chunk, &zc, async_capable);
 		if (err < 0 && err != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
 		}
 
@@ -2007,7 +2016,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		}
 
 		if (err < 0) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
 		ctx->decrypted = 1;

base-commit: 6f7c88691191e6c52ef2543d6f1da8d360b27a24
-- 
2.33.0

