Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FF41C094E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgD3Vcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:32:31 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:40221 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgD3Vcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:32:31 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MuUza-1jCBdY2bPm-00rWvV; Thu, 30 Apr 2020 23:32:02 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@qca.qualcomm.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 04/15] ath10k: fix gcc-10 zero-length-bounds warnings
Date:   Thu, 30 Apr 2020 23:30:46 +0200
Message-Id: <20200430213101.135134-5-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ccN1pTp5mmzG1V/LbfNTrOg5a2/CArUQ2I6vcwgPdfkvayXPXxD
 UcaYf0K7t7QiHPFwXmL0MAjZ8kc646dtFKMnW+OwN9WF6dNvNIuFMoXI5ZUGl5Zd7TJBjmW
 3VoU67At7c8JSqXoWPosMq5jkjGERss8vZA+5lcxJJPByBpE+bTRXi56M546CAW7xSUjDYa
 28T1892LzHqslkkRJVYWA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rCAqcLlN2Qw=:i+uJ1FCvreCnBJCFHWLH0L
 Jae4i0/9E0VTrPezIrTFvhERBWJAoPbnuZN4oa2hTMXo7r+ggwY5tsz86kKuZvRLN4rNk8AXS
 NNulXMo1lYfw2aYJa6ysZg6ZlrrYCvAcGOpOHDBLUx9A8fGn01OzURuffwY7xsJSN5cyyBRKb
 j0KSlMoiyMibqznbXADUfkYaP9IGpBBRtrXE3QZCs90SHSnBca4pi95WM2YVMcwBnWw4B3Bmm
 tBNuNn30vV9JjOxdcKfOURDIOwYYaEXdXM2DE5QrT4T8yvwJ8eBWfwUAeHPNnXZ3YzsSuTdTJ
 m1TkVnqBVNJ+K8XcFsmEGmLl3sPizRlB+gpWvSRQRNWPN/NQdFbLosAanrn12sUvsxAGV43GJ
 6kPsrNYSUvJiGaieBS2UJWyqwo1vjq2Q2itwv6Q/ViyhSlkk9QaB8vcZwZ97EJZp4HaVbNvMr
 5rE0gmlEgsv4+4EsOUFjjkkUYxfolz3C5vxV5VVTFgofEwPrntEymtbfy74KAoRhjL3SPE/7+
 WyJmtQgifvAMe+Ztx0jYMFp5sRjFxZt2+iyaPsSCDvk5kHZz2yjUrHvbPyTn55xS6Mn6vbwiz
 EhCgh9jghUmRIqnpuHOEJ2UzNAJn+KYf4jrvIAF16w7oAPxf+Yg96p2DYFyuSnfamQWLFH/xT
 Mng16ViWcUik3KWL/1+xteRAWAC3irsWeJB1puAKtpYuRXf/B9aNEzYxyTxkSSpYuBrPj0Ptd
 Jf4NES5x/eL5ax1OuDHopXar+O4y51ObCA4hGRAwKwdXSHxkp2+Sz1Xz8O3Ezj+9HmL8YvOOF
 7GAXUSkAxvlSKV96wBb/QZzzBOwiPWzSSdpxnihC5Uj/9xcTlI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 started warning about out-of-bounds access for zero-length
arrays:

In file included from drivers/net/wireless/ath/ath10k/core.h:18,
                 from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
 1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
 1676 |  struct htt_tx_fetch_record records[0];
      |                             ^~~~~~~

The structure was already converted to have a flexible-array member in
the past, but there are two zero-length members in the end and only
one of them can be a flexible-array member.

Swap the two around to avoid the warning, as 'resp_ids' is not accessed
in a way that causes a warning.

Fixes: 3ba225b506a2 ("treewide: Replace zero-length array with flexible-array member")
Fixes: 22e6b3bc5d96 ("ath10k: add new htt definitions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/htt.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index e7096a73c6ca..7621f0a3dc77 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1673,8 +1673,8 @@ struct htt_tx_fetch_ind {
 	__le32 token;
 	__le16 num_resp_ids;
 	__le16 num_records;
-	struct htt_tx_fetch_record records[0];
-	__le32 resp_ids[]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
+	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
+	struct htt_tx_fetch_record records[];
 } __packed;
 
 static inline void *
-- 
2.26.0

