Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ADB22D3F6
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 04:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGYCzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 22:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYCzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 22:55:01 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A93C0619D3;
        Fri, 24 Jul 2020 19:55:01 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s23so8326593qtq.12;
        Fri, 24 Jul 2020 19:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G92WwVyIjQTZzhrdRj92rlVX2WrAYmqxXL0PpR7SvAI=;
        b=jLeSVeI35h+fhMRzQ0T0wB+EPyqeGKIEYqR2kQRMIyo7yzX6zWQ6nT4hMp+bGnWCt0
         ytlSmete92cZvQ+gisV3gFAmSKsxjEQZ7Fwl/SKcohH7zsLvIb5oL7h55MiFM4rTrgp8
         LX2SPW2n9XOcadLfoL6eMIP+Jp7IHi85b+DaW1pNwsYciduHZk+2kDPirXoFZNlKnnrQ
         sF3GqtThswouT42gpy4Wqf0PgwuT0HlV9LHs3AsPmiLMq50yCsn8TriI7xdmj3Qjuhmb
         gJijGg7BgrBn7pVA53f8Zpd1OP7TyJYCAwpgh/0MQcJDxEskSHovQrsye3/DJJcgjqr7
         Oaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G92WwVyIjQTZzhrdRj92rlVX2WrAYmqxXL0PpR7SvAI=;
        b=uj8opGVOSHsanrvYIz8pIruGdhoh24hOnAzjB89Pi0HrJvUsoSh6zZDRGeANovPIe7
         hbjzhg1weHoE1NU7EblQt/trDbAfthkyjHyGFpxtrfBOLKndACGumZQHHWD3ldJqvrjr
         Te5ukgqC+4unR+DHRS0fcW7VDdW/Wl5vS5mO0CeRxLmdXv24GpoVdJztcP5fnXgGCzYg
         84J9qGfoytPlNhXBeUvLe2yXusZgU58+zotz48TseY2R4GFKw9rWSasZlJH/qDF2+mJf
         OgToYYx+88Beq+/wMTLoHKFEvb5fonlEoQS4oooXq53lZU9vw59DLTqABtfGolC1R3Wk
         KcMQ==
X-Gm-Message-State: AOAM530BDeBtkVHsIJh2zx95jIZl2tMsbolpnnKHji6ODAKNEmDECECi
        C+6/kVZwbEN2rkxorLPUDuM5wHfm
X-Google-Smtp-Source: ABdhPJy0W5UJO64z95Ngo7xeYN8yPR65ezFDq0HloQl9u6KwJ4K1oNFxl21kwnNsMidAz0cLAtIZrQ==
X-Received: by 2002:ac8:1cc:: with SMTP id b12mr12333959qtg.180.1595645700064;
        Fri, 24 Jul 2020 19:55:00 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id x29sm4261875qtx.74.2020.07.24.19.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 19:54:59 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub@cloudflare.com, kuniyu@amazon.co.jp, davem@davemloft.net,
        kuba@kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next] udp: reduce merge conflict on udp[46]_lib_lookup2
Date:   Fri, 24 Jul 2020 22:54:57 -0400
Message-Id: <20200725025457.1004164-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Commit efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")

in net conflicts with

Commit 72f7e9440e9b ("udp: Run SK_LOOKUP BPF program on socket lookup")

in bpf-next.

Commit 4a0e87bb1836 ("udp: Don't discard reuseport selection when group
has connections")

also in bpf-next reduces the conflict.

Further simplify by applying the main change of the first commit to
bpf-next. After this a conflict remains, but the bpf-next side can be
taken as is.

Now unused variable reuseport_result added in net must also be
removed. That applies without a conflict, so is harder to spot.

Link: http://patchwork.ozlabs.org/project/netdev/patch/20200722165227.51046-1-kuniyu@amazon.co.jp/
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/udp.c | 3 ++-
 net/ipv6/udp.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9397690b3737..67f8e880d7f3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -448,7 +448,8 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 				return result;
 
 			badness = score;
-			result = sk;
+			if (!result)
+				result = sk;
 		}
 	}
 	return result;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ed282b0fe8ac..827a01b50b9b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -180,8 +180,9 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 			if (result && !reuseport_has_conns(sk, false))
 				return result;
 
-			result = sk;
 			badness = score;
+			if (!result)
+				result = sk;
 		}
 	}
 	return result;
-- 
2.28.0.rc0.142.g3c755180ce-goog

