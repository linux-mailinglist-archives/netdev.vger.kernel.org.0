Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1D12E70F
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 15:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgABOHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 09:07:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728288AbgABOHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 09:07:02 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E4515439ADF421E9329E;
        Thu,  2 Jan 2020 22:06:58 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Thu, 2 Jan 2020 22:06:53 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] tcp: use REXMIT_NEW instead of magic number
Date:   Thu, 2 Jan 2020 22:02:27 +0800
Message-ID: <20200102140227.77780-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

REXMIT_NEW is a macro for "FRTO-style
transmit of unsent/new packets", this patch
makes it more readable.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88b987ca9ebb..1d1e3493965f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3550,7 +3550,7 @@ static void tcp_xmit_recovery(struct sock *sk, int rexmit)
 	if (rexmit == REXMIT_NONE || sk->sk_state == TCP_SYN_SENT)
 		return;
 
-	if (unlikely(rexmit == 2)) {
+	if (unlikely(rexmit == REXMIT_NEW)) {
 		__tcp_push_pending_frames(sk, tcp_current_mss(sk),
 					  TCP_NAGLE_OFF);
 		if (after(tp->snd_nxt, tp->high_seq))
-- 
2.20.1

