Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED18E1CE9F7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgELBGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:06:30 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:38964 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgELBG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 21:06:29 -0400
X-Greylist: delayed 31269 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2020 21:06:29 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 04BGMVQ0059222;
        Mon, 11 May 2020 09:25:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=1ZG4s3fDcoPXmWhQ4DqrXhIr30LxUHWDAneKLNIXyOQ=;
 b=coXqceiFJvyKBI6C+20aHIILzd6bCQpGRLmIDGrA63qTEkQ2T+GAFoHiijsWsM8Dz29D
 nQ9T9UawvWnkCpjCgs8eA5wk09ywnJOeOXrHh1v+L25EgAvMuGsP15lonqP6bTYTbAEw
 p7F9G7SGRtSKhVkjbmU54HmERFCPahOd8lBOVWxvFQSXgtycLl64uPkDSLJmUxgeX6dU
 uOkouKdgqH5sBH9n6cI0MbSgKSFspuU43OrWuvcydYrY0TMemO5d2kpbOxbGts8ffpq0
 dmnRLe1dug+re6PbYIO1+52QsaSu7CXDnRzYk4948V7e40vhjNpzo+hK1eRa2QhCwC0c aw== 
Received: from rn-mailsvcp-mta-lapp03.rno.apple.com (rn-mailsvcp-mta-lapp03.rno.apple.com [10.225.203.151])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 30wugw1jub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 11 May 2020 09:25:13 -0700
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QA600GUUDM1FAH0@rn-mailsvcp-mta-lapp03.rno.apple.com>;
 Mon, 11 May 2020 09:25:13 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QA600800D8I5X00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Mon,
 11 May 2020 09:25:13 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 8c2cfa5ef70d2018b184af5f7ee0603d
X-Va-E-CD: 105d25a3a045a04e9df317536d850bf5
X-Va-R-CD: b3dbecab011b88c2e9ae107a89a0a807
X-Va-CD: 0
X-Va-ID: 7c7b8a87-af11-4426-93fb-ae80d8461010
X-V-A:  
X-V-T-CD: 8c2cfa5ef70d2018b184af5f7ee0603d
X-V-E-CD: 105d25a3a045a04e9df317536d850bf5
X-V-R-CD: b3dbecab011b88c2e9ae107a89a0a807
X-V-CD: 0
X-V-ID: ee58ddc0-149c-441d-836f-4cd0afbfb6a9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_07:2020-05-11,2020-05-11 signatures=0
Received: from localhost ([17.235.13.20])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QA600SU6DLZ5P00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Mon,
 11 May 2020 09:25:11 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net] mptcp: Initialize map_seq upon subflow establishment
Date:   Mon, 11 May 2020 09:24:42 -0700
Message-id: <20200511162442.78382-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_07:2020-05-11,2020-05-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the other MPTCP-peer uses 32-bit data-sequence numbers, we rely on
map_seq to indicate how to expand to a 64-bit data-sequence number in
expand_seq() when receiving data.

For new subflows, this field is not initialized, thus results in an
"invalid" mapping being discarded.

Fix this by initializing map_seq upon subflow establishment time.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e1f23016ed3f..32ea8d35489a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1629,6 +1629,8 @@ bool mptcp_finish_join(struct sock *sk)
 
 	ret = mptcp_pm_allow_new_subflow(msk);
 	if (ret) {
+		subflow->map_seq = msk->ack_seq;
+
 		/* active connections are already on conn_list */
 		spin_lock_bh(&msk->join_list_lock);
 		if (!WARN_ON_ONCE(!list_empty(&subflow->node)))
-- 
2.23.0

