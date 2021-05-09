Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49173776A6
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 14:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhEIMwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 08:52:38 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:34079 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229680AbhEIMwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 08:52:34 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([95.244.94.151])
        by smtp-35.iol.local with ESMTPA
        id fim8lvyCKpK9wfimDlntUk; Sun, 09 May 2021 14:43:19 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1620564199; bh=PTNuRnbv91pLESEoI5yyayvQe+fBDHh6NxeX1AWJ8cM=;
        h=From;
        b=OhNQpB6EzLqIhaoSkQdKdLmpdPKGifGoRq7Jfmkircwh/YjuI19ToHW9vhiMqnVZv
         OSLgrd5m5lJS0kKAtAJAnvzrUiy74qRh4mlowPwyYSnQaXCFfceZcE5CGWTYNzVMV6
         vCRLcsAQTS7u9dRbuot/lXtMWRQBohYTt7uhAoyJrefP4RQGnSAFTITeX/01dgwevt
         8Ds9Mc8SFNqDpXNAtnQWy835oj+036nVtw1qpnEp3HPGuWuomYEGwWaMXtlVT5vMSg
         tWxSXgfynO51pyki3idq1+c5TQuRO8yP3qUDw2FROUbMYDu3q2KO0eZr0ZsGqf1xk7
         W9UnD7PQ8yMZA==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=6097d8e7 cx=a_exe
 a=ugxisoNCKEotYwafST++Mw==:117 a=ugxisoNCKEotYwafST++Mw==:17
 a=XuRU2NGKMeDj8PkT77oA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/3] can: c_can: cache frames to operate as a true FIFO
Date:   Sun,  9 May 2021 14:43:06 +0200
Message-Id: <20210509124309.30024-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfLeBA7YIlgML9uS/zWAM3EWuzlbsvrGWpYBRNVYTJ50C8o7V9ZZ4dMUF17CEq4I58qOG2IvRufI7QOXChXGq67RpBO2xJ5Vf2W8ZpxPGd0v7ITpAaZAy
 TW5QKyzIU2+H40Oh/q6I0DAYxee3Q/w12skB+vTgsEJE6lb1btjpENqkjxEk0lWkOlX8GP6FR5cb0Rfkr2QkGRpu8ujJanhZyiOyU6ucJM0QP6ukzaaDxAmB
 sFf0O/Rvidc48dxUI9vSEpzmRirQLR7lJvokQ0xB8yfzGI5f0LXlugn+FWtTH0PmyZdNFEfZbgZgXnThZVCUEdL1jg9EvxeOgFqcBisumVM7275yd0MJ0hw2
 7lYjTlDYO41KyXeKmaKRu4BoBxwG7jAC7TlYluDi+a41NVIm84xRogXMIBKetEf/zb97PA4DqIJJBUwniEms4+Hf2ih5MiWraSyodetOK9riLzoF+8dVcitR
 FgdXDdAjqaxh4NsSQiX6t1PY3PRKR94w9KMrz02fm+KouSwhDScF2d5mJmgCF/4ZuP1CFSGpabu/TgMgDIman2Qq56YpCmnsEfa0uxfeZoL3U4JXivNA61N9
 l1NOu/YFHi/Rjij/Hl5uLayy1fC3ZaXWA1KIqohsFpguwvx2GHgZq2U5keLZ/2G2aFrrU+wqqsdZ2PLCLwVPtHiY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Performance tests of the c_can driver led to the patch that gives the
series its name. We have also added a patch for ethtool support and a
patch to remove a variable that is no longer used.


Dario Binacchi (3):
  can: c_can: remove the rxmasked unused variable
  can: c_can: add ethtool support
  can: c_can: cache frames to operate as a true FIFO

 drivers/net/can/c_can/Makefile                |  3 +
 drivers/net/can/c_can/c_can.h                 |  6 +-
 drivers/net/can/c_can/c_can_ethtool.c         | 46 +++++++++++++
 .../net/can/c_can/{c_can.c => c_can_main.c}   | 65 +++++++++++++++----
 4 files changed, 107 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/can/c_can/c_can_ethtool.c
 rename drivers/net/can/c_can/{c_can.c => c_can_main.c} (95%)

-- 
2.17.1

