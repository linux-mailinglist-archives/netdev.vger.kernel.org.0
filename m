Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE29E368E2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfFFA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:56:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726593AbfFFA4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 20:56:32 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 31B639C23D94B21963C8;
        Thu,  6 Jun 2019 08:56:29 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Jun 2019
 08:56:21 +0800
To:     <edumazet@google.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, maowenan <maowenan@huawei.com>,
        <mingfangsen@huawei.com>, "Zhoukang (A)" <zhoukang7@huawei.com>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH net v2] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
Message-ID: <9bb489e8-89f2-6a0c-3996-6a7c992448e7@huawei.com>
Date:   Thu, 6 Jun 2019 08:56:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

small cleanup: "struct request_sock_queue *queue" parameter of reqsk_queue_unlink
func is never used in the func, so we can remove it.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
V1->V2: add partner signatures

 net/ipv4/inet_connection_sock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 6ea523d71947..632855a8abb3 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -653,8 +653,7 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req)
 EXPORT_SYMBOL(inet_rtx_syn_ack);

 /* return true if req was found in the ehash table */
-static bool reqsk_queue_unlink(struct request_sock_queue *queue,
-			       struct request_sock *req)
+static bool reqsk_queue_unlink(struct request_sock *req)
 {
 	struct inet_hashinfo *hashinfo = req_to_sk(req)->sk_prot->h.hashinfo;
 	bool found = false;
@@ -673,7 +672,7 @@ static bool reqsk_queue_unlink(struct request_sock_queue *queue,

 void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
 {
-	if (reqsk_queue_unlink(&inet_csk(sk)->icsk_accept_queue, req)) {
+	if (reqsk_queue_unlink(req)) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		reqsk_put(req);
 	}
-- 

