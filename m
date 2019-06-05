Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF4A35AAD
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfFEKv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 06:51:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726502AbfFEKv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 06:51:26 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D5B5F720BB82724F2207;
        Wed,  5 Jun 2019 18:50:15 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 5 Jun 2019
 18:50:07 +0800
Subject: [PATCH net] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
To:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>
References: <20190604145543.61624-1-maowenan@huawei.com>
 <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
 <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
Message-ID: <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
Date:   Wed, 5 Jun 2019 18:49:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
Content-Type: text/plain; charset="utf-8"
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
---
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

