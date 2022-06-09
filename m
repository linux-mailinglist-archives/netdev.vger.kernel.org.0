Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4AB5440FC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 03:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiFIBUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 21:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiFIBUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 21:20:18 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 18:20:16 PDT
Received: from rpt-glb-asav6.external.tpg.com.au (rpt-glb-asav6.external.tpg.com.au [60.241.0.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E9CC27B39
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:20:15 -0700 (PDT)
IronPort-SDR: kF5J1R+jFDteTNT2ybK3W6ruPx2bgpPlVt3Wux6VJllNs8TlLq8H1Hte/4Sq+fQIh/Uh/f3wWY
 yQ/3trKOo52cGJ+M1k1MWBaXxarBhQmYWTUevEgCtzAU/AokBPG/4FK/QbMKHPa/6aSX+tRVYU
 3AiDbj9sqL+wMRKoT2J1kVXs1PhsmEr4G2hAvDYGkc6IW1jUDzYj5iZguN5ZNTpHbIMhfiHVUo
 JQwuRWVl1jDvoblUQ8yiDvwPp8eQVMQKQt7n1XYaqdqQ3bNo35llUzm/efhiYbIkxQoooifNiY
 iTE=
X-Ironport-Abuse: host=210-185-107-108.tpgi.com.au, ip=210.185.107.108, date=06/09/22 11:19:12
X-SMTP-MATCH: 0
X-IPAS-Result: =?us-ascii?q?A2FxAwDQSaFi/2xrudJaHgENLwwOCxKBRoR8lV2DAhSHa?=
 =?us-ascii?q?C8CkTuBfAsBAwEBAQEBSwQBATwBhEVRBYR0JjQJDgECBAEBAQEDAgMBAQEBB?=
 =?us-ascii?q?QEBAQUBAQEBAQEGAwEBAQKBGIUvRoI1IoN3KwsBKR0mXAIiK4J9gmUBAzCte?=
 =?us-ascii?q?BYFF4EBhloKGSgNZwOBYoE9hE6BSoM0giiFRYEVg2iBBQGBGoJxhW4EjUaKG?=
 =?us-ascii?q?AQFChoDAwIPFAMJBAcFUQICAQELAgYGBAYDAQEGAwkCBAISAgIEBxgKEggUA?=
 =?us-ascii?q?wIFAQIgBQEHBQEEAxIGDBEBCAYGAQQCCgECAgUFDAMBEQEEAgYCBAQEGBQEA?=
 =?us-ascii?q?gQHBgIJCQcFFgsECgIWAQoSAgYMCAICAgICBBUHAQ0FAgIEAQ4CBwYDCwIDB?=
 =?us-ascii?q?QcDAwQHAgoDAwwOAQMBBwEEBQMNBAEBBgIBCgMFCgIBAgIBDAEBAQYCAggBA?=
 =?us-ascii?q?QICAQMGAgEEAgcBAgUDAgMIAwIDAwICAQEECQgCAwQDBAIDAQUBAQUDAgUBA?=
 =?us-ascii?q?wMCAQMDAwIBBAMGCQoECAEEBAEBARECBwcCBgMDAgICAgUBAg0BAgECBAMIB?=
 =?us-ascii?q?gIDFAECBAEKAQUCAwkCBwMBAQIHBQoCBwUCBwICBAEFAw0BAwUCAwEBAwMCB?=
 =?us-ascii?q?AECAQMDCQEDAgMDAgICAgUCAwICAgkDBgEHAwIBAQQFAQQDAQIKBAQDBAIEA?=
 =?us-ascii?q?gcCBwIEBwIBBAYDBwYEAgEHAQEECgQDAwMBAQcBAgUCAgMCBhIGBwIEAQMEB?=
 =?us-ascii?q?AoCAgwCAQYBAQIBAQEBAgMCBwUOAQEBAwIDBgIFAgIBAQMICAMCAQQBBQMBB?=
 =?us-ascii?q?AUDBwIBBQkCCQMDCQMBAQUBAwEJAwMDAgkDAQICAgsEAwgDAwIDBAICAgIBA?=
 =?us-ascii?q?wIHBQgEAQQKAgEBAgECAgYCAQMaAQIDBQICCQwBBAICAwEDAQECCAQJBAIDB?=
 =?us-ascii?q?AIBAQMCAQICAQUCAw0GAQEBAQIDAwECAwEBBgcCCAIXHBMBAwMCAQICAgUCA?=
 =?us-ascii?q?gECAwICDQEBAQQCAQIBAgYBAwECAgMBAwECAgYCDAMIAgcBBQMDAgIDAQEFD?=
 =?us-ascii?q?wUCAQQCAQIGBQIBAQEEAQMEBAgCAgEDAwIOAgQBBAECAQEjAwQCAwEDFwECA?=
 =?us-ascii?q?QIDAwMEBgcGAgECEwECAQEBBQECAQEEAgQEAQYKAwICAgEFAwMFAQECAwIBA?=
 =?us-ascii?q?QEHDAICAhMCBAoJAwEGAQMHBQEGARQDAgQCAgECAgIKAgEBAgIBAwIJAgECA?=
 =?us-ascii?q?QUIARsDAQEPJAEBAgIBAgIDBAcCAQQGAw0CAgEBAQUGDQMCAwgMAgkDAgIDB?=
 =?us-ascii?q?QMCAgQBAgQMCgECAgECAgQFBQIBAgEIAwEFCgMFCQUCBAECAgEDCAEEAwsGA?=
 =?us-ascii?q?gYCAQIDBQMDAgEGBAUCAwECAQEDAQQBAwQGAQECAwICAQgCAgEBAwMEAQIBA?=
 =?us-ascii?q?gQCAgIIAgMCAQQCAQIDAQEBBAICAgICBAMIAwIBCAcFAQIEAQIBBAMCAgECB?=
 =?us-ascii?q?wECAgEJAgEDAwUDBAEDBwMPAwUDAQMDAgUHAgoDAQYEBAECAgECAgICBAICC?=
 =?us-ascii?q?QIEBQIFBgYGIQEGF02YdxIBDy9PgUQrDoF8AQGNfQmGR6ppQCEJAQYCWIFKd?=
 =?us-ascii?q?BUlmhUGhV0aMahbLZY8kQeREU2FA4EsghZNI4EBbYFKURkPjjeOS2M7AgYLA?=
 =?us-ascii?q?QEDCY8EAQE?=
IronPort-PHdr: A9a23:sR1g/xJrcIaFzsA4TNmcuLxhWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCFvrM01A+CAd+TwskHotKei7rnV20E7MTJm1E5W7sIaSU4j94LlRcrGs+PBB6zBvfraysnA
 JYKDwc9rDm0PkdPBcnxeUDZrGGs4j4OABX/Mhd+KvjoFoLIgMm7ye6/94fObwlUhzexbrx/I
 AurpgjNq8cahpdvJLwswRXTuHtIfOpWxWJsJV2Nmhv3+9m98p1+/SlOovwt78FPX7n0cKQ+V
 rxYES8pM3sp683xtBnMVhWA630BWWgLiBVIAgzF7BbnXpfttybxq+Rw1DWGMcDwULs5Xymp4
 aV2Rx/ykCoJNyA3/X/KhMJ+j6xVpx2uqRNkzoLIY4yYLuZyc7nBcd8GQ2dKQ8ZfVzZGAoO5d
 4YBC+0BPeBFpIf6vVQPohW/CheoBOPr1zRFgX323agg3OUuHwDJwgggH9YAvXnWt9j1O6ISX
 vq0zKnM1znMc/RW2TLk5YXObxsuru2CU6hqfsrN1UkgCRnFjlOIpIHlPz2Y2PkAvmuV4eRgW
 u+iiXArpg5srzSx2MohjonEi5wJx13E+ih3z5s5K9K5RUJnfNKpHpReuS6bOoV5Qc4vRXxjt
 iUiyrAep5K3YTQGxI46yxPca/GLaZWE7g7hWeqLPDt0mHFodbSijBio60eg0PfzVsys3VZPq
 SpKj8fDu2gW1xzW9siHUvx9/lq92TqX1wDc9OVEIUcsmKrZLp4u2LExl5QNvkTHGi/6gln5j
 KiTdkk8++io7froYqn+q5OCKoN4lhvyPrktl8G/G+g0LxQCUmqB9eihyLHu/lX1QLBQgf03l
 qnZvoraJcMepqOhAQ9V15ws6hmxDji41NQYmXcKIVBedRKIiojmIVDOIPTiAfijhFSslS9nx
 /bdMbL5GJXCMmDDkKv9fbZ680NRyxI/zcpD6JJMFrEBPPXzV1f3tNPGEh82LhK7w/j8BdVj2
 YMRR3iPDrWaMKzMq1+I4PwgI+2WaI8Sojb9JOAp5+Tygn8hhV8dYa6p0IMKZ3+iAPRpPUCZb
 GHxjdgbD2cFoA8+TOjtiF2MTT5ffXCyULwg5j0jEoKpEZ/DRpyxgLyGxCq0AIBZZn1DCl+WE
 HbnaZmEVuwDaCKVJc9hnTgEWqa7R4A90hGusRf2y6B7IerM5i0YqZXj2cB25+3Ojh497yd5D
 8eD3GGXSWF7gGcISyUx3KBlrkxx0k2D3rRgg/xECdxT4OtEUh8gOpHH0eN6DdHyVxnbftiXV
 VmmQs+pAS0rQt0txN8OZl5xG8++gRDbwyqqH7gVmqSRC5wo7K3c2WL+J9xhy3vd16kukUMmQ
 s1ROm2inKJ/8BLTB4HRn0WDi6mqbbgc3DLK9Gqb0WWOoV1YXxRwUKXBWnAffFLarczk5kzZV
 LKvCa4oMgtGyc6FMKdFdtrpjVBeSPf5JNvee36xm3u3BRuQxLOMaZDlemoT3SrDDEgElw4e8
 HSdOAgxAyeuuWPeDDh0GV3zZEPs9Lo2lHTuSEIowwyUR1Nu2qDz+RMPg/GYDfQJ0eEqoiAk/
 hdzGh6Y1sLJBt6E715jeaxMft455AwY/W3cvg15eJenKvYx1RYlbw1rsha2hF1MAYJanJ1yx
 E4=
IronPort-Data: A9a23:EJFRqah2mzzB49zWu/w/B5TgX161VBEKZh0ujC45NGQN5FlHY01je
 htvWG6PMvmNMzTzeNojaIi0oUMAu5PTy9M2SAFppX82ECgW8JqUDtmwEBz9bniYRiHhoOOLz
 Cm8hv3odp1coqr0/0/1WlTZQPoVOZigHtIQMsadUsxKbVIiGX5JZS5LwbZj2NY22YjhWGthh
 PuryyHhEA/9s9JLGj9Mg06zgEsHUCPa4W5wUvQWPJinjXeG/5UnJMt3yZKZdhMUdrJp8tuSH
 I4v+l0bElTxpH/BAvv9+lryWhFRGOaKZWBigFIOM0SpqkAqSiDfTs/XnRfTAKtao2zhojx/9
 DlCnc2SRBUHJ4Tmo8U2VjtSQzBTFIpB4LCSdBBTseTLp6HHW3npyuVxAUUye4Yf/46bA0kUr
 KRecWBQKEnb2KTvmOLTpupE36zPKOHpOYoPpXxkyWqGJfkjSJHHBa7N4Le02R9p3Z4fQK+AO
 5RxhTxHUhL/RQVdBXgtObk4u+y6ijrAYzYBgQfAzUYwyy2JpOBr65DrPcbZd8KiW8pYhACbq
 3jA8mC/BQsVXPSTwCSI91qgj/HCmCf8Vp5UErCkntZnjECWz34eFDUZUly0pfT/gUm7M/pcN
 kYd0ikjt64/8AqsVNaVdwWxqnOCvzYGVtZQGvF84waIooLd/wufD3IYZj1MctorsIkxXzNC/
 lSUg9r4ATt19aWIQ1qM/7eTqnW5Pi19BW0HbD8bQA8BuIbLr4Q6jxaJRdFmeJNZlfWvQGm1m
 mDX6XFm2PBK1Z5Ny720/BbMhDfqr4WhohMJ2zg7l1mNtmtRDLNJraT0gbQHxZ6s57p1grVMU
 LboViReAC0z4UmxqRGw
IronPort-HdrOrdr: A9a23:ijeQkKCrXalNpvnlHem155DYdb4zR+YMi2TDGXoddfUzSL36qy
 nAppsmPHPP4wr5O0tBpTn/Ase9qBrnnPZICOIqUYtKMjONhILRFuBf0bc=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.91,287,1647262800"; 
   d="scan'208";a="136951646"
Received: from 210-185-107-108.tpgi.com.au (HELO jmaxwell.com) ([210.185.107.108])
  by rpt-glb-asav6.external.tpg.com.au with ESMTP; 09 Jun 2022 11:19:12 +1000
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        Jon Maxwell <jmaxwell37@gmail.com>
Subject: [PATCH net] net: bpf: fix request_sock leak in filter.c
Date:   Thu,  9 Jun 2022 11:18:44 +1000
Message-Id: <20220609011844.404011-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A customer reported a request_socket leak in a Calico cloud environment. We 
found that a BPF program was doing a socket lookup with takes a refcnt on 
the socket and that it was finding the request_socket but returning the parent 
LISTEN socket via sk_to_full_sk() without decrementing the child request socket 
1st, resulting in request_sock slab object leak. This patch retains the 
existing behaviour of returning full socks to the caller but it also decrements
the child request_socket if one is present before doing so to prevent the leak.

Thanks to Curtis Taylor for all the help in diagnosing and testing this. And 
thanks to Antoine Tenart for the reproducer and patch input.

Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
Co-developed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by:: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 net/core/filter.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..e3c04ae7381f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 {
 	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
 					   ifindex, proto, netns_id, flags);
+	struct sock *sk1 = sk;
 
 	if (sk) {
 		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
-			sock_gen_put(sk);
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk1))
+			sock_gen_put(sk1);
+		if (!sk_fullsock(sk))
 			return NULL;
-		}
 	}
 
 	return sk;
@@ -6239,13 +6243,17 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 {
 	struct sock *sk = bpf_skc_lookup(skb, tuple, len, proto, netns_id,
 					 flags);
+	struct sock *sk1 = sk;
 
 	if (sk) {
 		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
-			sock_gen_put(sk);
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk1))
+			sock_gen_put(sk1);
+		if (!sk_fullsock(sk))
 			return NULL;
-		}
 	}
 
 	return sk;
-- 
2.31.1

