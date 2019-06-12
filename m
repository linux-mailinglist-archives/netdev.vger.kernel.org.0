Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAD242CB6
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409475AbfFLQwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:41 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36884 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405826AbfFLQwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:41 -0400
Received: by mail-pg1-f202.google.com with SMTP id e16so11722227pga.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t6IUIgaHg9CLpaE/qRU6Fzb8UhCksxZiQhmdp0+sKyw=;
        b=tDdqdyyILrM1+lRLckiCo+MyH58sJG3wGlc/W+U0Am/WHxhGZqrM9IR0wSShSu4GcI
         uR2TubwJdH/MtJFDlSYmiCK0qAaKaRFlWpBPI1beFb5x200NDSoD8o1tzxGvqOStwESM
         JFaeUbcMyse034DgrWa48A0Ox/i+mRl7DAz9XZIvWfg9LnHaWb1isdHU99zGOLYxBBsK
         iodIbsIAt6rk4QQgKGq6x3c90NbcBiu3+NuNd2VG7W1msr8Q8jcSvhcmJ9TmFvvhwe+M
         shH/vUhNDWQ8Bnc96XrIqgTbtuGtwqbFi3liAUl/3Sw11HSzTqId4NCp9btXOBJFgFpO
         rFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t6IUIgaHg9CLpaE/qRU6Fzb8UhCksxZiQhmdp0+sKyw=;
        b=IbFjJgdaMQGAusBNimQm/i+CjLMDHNoYzrGimu7c10KdLkR4rb0zqPpJFoft+PeFBj
         AW7SUOKumj1FL3tJmEaosRyEPwkH//gehwuYmhNL+SirmH4qY7IERDLIVKyHOrGGgkwf
         aKnO/21YqOohTKmkDq2c53OTqOxF2YsnJVgys27/UHNFdJJaEY+2OmL5VgGaUFp/n0+d
         NjeMsEamOkc/BqKGrg6nxFUcYI3uz+zj0Hawv/DMgjr9gwnu+XRBTIS7EgqFFuVy6QpU
         FRfgJiiq9k36z5bqFYbwr2MW9gxJlubuA7ATSVcpAIXtes/uRIUR4lTZ4seFrvjQdxWP
         Co1w==
X-Gm-Message-State: APjAAAVj5KNVwH2TJri4pcy4u82uYKyUPEKO11U/Lkgc6LKleBlZZ7xL
        G3d0WkX6ObMplOnFCY1zPmwFxtgPyzRZ2Q==
X-Google-Smtp-Source: APXvYqxsMwPJl/hmsG8uWbc1jEqN/5ZlhRdJWs1COa80jZ3qRDd9Dzw/jXQ5pVyaC6MuxHGB4tg2UShpzCyPIw==
X-Received: by 2002:a63:950d:: with SMTP id p13mr26043001pgd.269.1560358360569;
 Wed, 12 Jun 2019 09:52:40 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:26 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 1/8] net/packet: constify __packet_get_status() argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct packet_sock  is only read.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7fa847dcea30e481b2f291cc6980a7b887629cd7..66fcfd5b51f82a861795e002e91d3cbc69ab545a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -384,7 +384,7 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
 	smp_wmb();
 }
 
-static int __packet_get_status(struct packet_sock *po, void *frame)
+static int __packet_get_status(const struct packet_sock *po, void *frame)
 {
 	union tpacket_uhdr h;
 
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

