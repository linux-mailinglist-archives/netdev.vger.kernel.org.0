Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B4416F149
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgBYVmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:42:42 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:45351 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYVmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:42:42 -0500
Received: from kiste.fritz.box ([94.134.180.105]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M72wT-1j3fq50v9D-008eZ7; Tue, 25 Feb 2020 22:42:30 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next v2 0/2] net/smc: improve peer ID in CLC decline
Date:   Tue, 25 Feb 2020 22:41:20 +0100
Message-Id: <20200225214122.335292-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ymhbc0+KWA0Wnzu+RSp11z63nFrmCIF7E9hTuWl90FKRPVTM20X
 92Yxwtu6vMvhR9irfeSI75s/midsRhLufpzstLhAobr3Mk37CJ40t3ZC383UL8bKewarV6I
 e73OckbHIpERDP4YBt/yb5INIlzN9lBiwHZo8lU7Ttl65EwfOs8J3xJ7txL4sm6YMu3wKmL
 5F5GLdlmtjCww9+sR2I9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2jWvEeX0pFo=:yoOAkLq7FIV5Yf1JR5hRPS
 SiXknZI/qG3AUTxQ2EfXSdHaVDf+4UnReSMzqgV0jmJibKH1FCVdJ8vHBiP+x63LA81/3xhAV
 I6SElEfD3gu14//cX3Bfsg73F5POjnC5bBDUt4vNFM2ATgGaK0NyIjKMJ0ffjJQuIUPSqGbDZ
 qPgEcbaUdUzFslVJOvcSxQEvqZ+VWOhL6bcRA19Q0L7J3FfjFz37Q3hO7SkUh7CQG0D14Y9xV
 UZON+CIyn14B+UhlwiT0yKeS8AKlTi/5TK2WRsdSFFT46tmZk0wVgq05qDqTkW5msQsPHbCfB
 Z4ngRYPL4HJrV+wRrTCBH4XYGkggqPNG3xOpUEX3dqzuC60wqGwBSGLka/x/YGVsdoSvLpNlw
 diOklK2IgY9zyoiAkpqHGaG0iI9NWvxjtfJOx1RPPlMD2O25XvTrzTy5otif88Xu1upu/Zn1L
 9x0ai9sjIaORSXo9ShYBqBpQcmjNlhBgWw87cCsHsoQ1j7RPkvwHUB6DoTFJFQvnqc+NLvop8
 1YHDClZMuEoghs67KMdbMxSoT5Ko/2pcBuGD5D4ZZ8v/j2yKMt6bnKbn8iVC3PTfVCpF9ZtMo
 SH2VhOnNLoyS84zrcKSRffYMJj/cTh4ObxO3Uo4vCVVPmv7p2PY3dToUvFx9YN4vFC0bW5Hzi
 uNsiFu3Uz4IU7B9G7TEaZnSUpZiP/TPQccRjyrG9s5fI49sBiJONPRSfi8H8odyRvoZcNMjvb
 vyQNF5KfHexGl0g+m/STlHjl1BPBtoLoo9YU6qDPRY1ZZMy5dK3ZhZzpGAuL3DovEI+DGaejX
 z3pRqkWddlLFKCzc71haSpbTgn1hEB/ZEz0fvV8t/pROjeO82wPpl8dCBetzvHewYud0L6Z
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following two patches improve the peer ID in CLC decline messages if
RoCE devices are present in the host but no suitable device is found for
a connection. The first patch reworks the peer ID initialization. The
second patch contains the actual changes of the CLC decline messages.

Changes v1 -> v2:
* make smc_ib_is_valid_local_systemid() static in first patch
* changed if in smc_clc_send_decline() to remove curly braces

Changes RFC -> v1:
* split the patch into two parts
* removed zero assignment to global variable (thanks Leon)

Thanks to Leon Romanovsky and Karsten Graul for the feedback!

Hans Wippel (2):
  net/smc: rework peer ID handling
  net/smc: improve peer ID in CLC decline for SMC-R

 net/smc/smc_clc.c |  3 ++-
 net/smc/smc_ib.c  | 19 ++++++++++++-------
 net/smc/smc_ib.h  |  1 +
 3 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.25.1

