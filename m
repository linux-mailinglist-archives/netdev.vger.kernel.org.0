Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C86120C73F
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgF1Jdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 05:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1Jdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 05:33:51 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FE1C061794;
        Sun, 28 Jun 2020 02:33:51 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q90so5999422pjh.3;
        Sun, 28 Jun 2020 02:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LEwMmf/h6lZz81fIQQa2n7X18h/c5NkeCjKyOlWnANI=;
        b=EdDPlzS2qvIUX9+SjPT5OT0T1MGU7FgmxHZQAbtDEB/YDiK12wX032s0cZohPvg0R0
         u+viQpH109w2IcQ7kXVXC5oC2cwH3JhOYCBj/YKNrKZppLw8L2hHby0cKK9pr/aaYXdx
         aZx4QT7x3Ucszak8h16M1alJoVTTdBssMHLrcwh3NKaOsbgPD0dbamS+Bz/li+YEtTk/
         JDr9JoQjZ2Z+bfeKMrGy5sQ3wjO+sDWZS28/2VJnPAx4FFsrRocYZPKkpH/9b/GARG9b
         DKzS4xog2TkJ5sXftYBmTjURlLvynpO+I2erDPPTqQQFsfOFSYDszl89r9vMCDEMHrU2
         RDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LEwMmf/h6lZz81fIQQa2n7X18h/c5NkeCjKyOlWnANI=;
        b=Ci6Bkajm8AxE7jtbh2doZgtSOa+tgpKSVvXBFYhjIkGRQYj79pQSPEIrqiy+MLF1d8
         nqR+osbdXPQ8eF/eCZ2ZPDxXWE3JKHWuzw85SYjiggE4CWOz24elunBfua2KjqdfbUBn
         fgtA5R7D8/CRdiJaOkY5rZW23VgiBz8wFyIw6NEovqKeJncgdxvUZYHb3u5XP4Go/N6q
         droSf+yX6Dgj6I3TCP3r+vSOubqWct7RiAss5hTs981u9WvNENdm+VSC59fRimHNDZzh
         RYySAlky1qlUM7G86AeTm3a1NyZFm9On7hT0yLbOPu26rSMNKjbd75aZNHto3UgtorOn
         /g+g==
X-Gm-Message-State: AOAM530dOm2IYtlgSPJMHhMBq58xUh7BStq7aSWF8BOhX7SlFR5Utvxz
        fqVLVG0zsh3Pykgva7lTouQ=
X-Google-Smtp-Source: ABdhPJygDGz/63sV+KBU7HpjulPDckI6G5d8KlDuhFnjtfhMxwWSendOckHwlWRCg2L6mILwauUepw==
X-Received: by 2002:a17:90a:21c6:: with SMTP id q64mr11765110pjc.172.1593336830705;
        Sun, 28 Jun 2020 02:33:50 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id 27sm15938911pjg.19.2020.06.28.02.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 02:33:50 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] sctp: use list_is_singular in sctp_list_single_entry
Date:   Sun, 28 Jun 2020 17:32:25 +0800
Message-Id: <1ae93f6e86ea0baf9ffb4068caed46d951076d12.1593336592.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use list_is_singular() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 include/net/sctp/sctp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index f8bcb75bb044..e3bd198b00ae 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -412,7 +412,7 @@ static inline void sctp_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 /* Tests if the list has one and only one entry. */
 static inline int sctp_list_single_entry(struct list_head *head)
 {
-	return (head->next != head) && (head->next == head->prev);
+	return list_is_singular(head);
 }
 
 static inline bool sctp_chunk_pending(const struct sctp_chunk *chunk)
-- 
2.17.1

