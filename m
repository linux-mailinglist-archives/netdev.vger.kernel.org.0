Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE37B1433CE
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgATWSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:18:15 -0500
Received: from mr85p00im-zteg06021901.me.com ([17.58.23.194]:33130 "EHLO
        mr85p00im-zteg06021901.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgATWSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:18:14 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 17:18:14 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1579558292;
        bh=mWwGn9oFUHfGSpvasc5qlO6neOEQFbfRV0nj64h0+f0=;
        h=From:To:Subject:Date:Message-Id;
        b=PI447VsoEmzkPG6VeWC0Q5D0VlmAifo3y+vChTVAz4TBCjdpwE/78NFgKi4m4Pbvj
         BzwjDTQUJ4VpxcPcR8jVo/vRXgLg8gWVutO/hybyqmyvT66/EoW/NWh0UcZ31kmri1
         yqFjtYKB6jd6NvqjfZ30rhEuGDcPH3RAlISb4P6zDxrSttamOUm3vzD1NiKZtzBO6o
         OhXQX8GAN/6smTN0c1SBOsAyQCq1rEUVGhFbJsUD629Kqz9yG6jxyLcLN/BA2sOMsx
         oQaGjSUUHiA1qdNtvCNjA7D55N/P4s3da9x+8pZgG6yc3n0s3FVWRpyL6gmNd6ceno
         1YcuAcXtVWFMQ==
Received: from localhost.localdomain (108-65-79-50.lightspeed.sntcca.sbcglobal.net [108.65.79.50])
        by mr85p00im-zteg06021901.me.com (Postfix) with ESMTPSA id 00D90720A93;
        Mon, 20 Jan 2020 22:11:31 +0000 (UTC)
From:   Theodore Dubois <tblodt@icloud.com>
To:     netdev@vger.kernel.org
Cc:     trivial@kernel.org, edumazet@google.com,
        Theodore Dubois <tblodt@icloud.com>
Subject: [PATCH] tcp: remove redundant assigment to snd_cwnd
Date:   Mon, 20 Jan 2020 14:10:53 -0800
Message-Id: <20200120221053.1001033-1-tblodt@icloud.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-20_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=824 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001200186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not sure how this got in here. git blame says the second assignment was
added in 3a9a57f6, but that commit also removed the first assignment.

Signed-off-by: Theodore Dubois <tblodt@icloud.com>
---
 net/ipv4/tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d885ba868822..04273d6aa36b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2612,11 +2612,10 @@ int tcp_disconnect(struct sock *sk, int flags)
 	if (!seq)
 		seq = 1;
 	WRITE_ONCE(tp->write_seq, seq);
 
 	icsk->icsk_backoff = 0;
-	tp->snd_cwnd = 2;
 	icsk->icsk_probes_out = 0;
 	icsk->icsk_rto = TCP_TIMEOUT_INIT;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd = TCP_INIT_CWND;
 	tp->snd_cwnd_cnt = 0;
-- 
2.25.0

