Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80E330A46
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfEaI2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:28:42 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35792 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfEaI2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:28:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id p1so3715866plo.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 01:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=87b5L0Co8+sXiAP9TcAx7sp6h6rSMWjRoEJw07nHThQ=;
        b=hLXNhyY38I6NFWBdS1qH0G3Gofp9aC9YvEDsXA2jCEZuTDm5U6jZAVkl7aAjpnr+j0
         QN6dKkNO6Too9EDzEHI1Y7P7Vouoigmb77UuTVQCmlgLcTzN22uDT5yisgJDf68ZGYma
         6N/u970UlgS0twn9EPd0iuAnl7cPHSLoOz+H6F5XNyBTaQOdyeKsQp1NBhAG/rCmgi2B
         V6DCIzavrsSGHWZ/RaCG7KyR0uaucuTIhSj0dw4QFMGO856JGd6pojXtM3OwcsZud4aw
         jm2A8xMYH60klySCw9konMiZcSZVTwUMw37CG143zLleJq8u8rXwYFNjku1q6+5vyYsz
         TrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=87b5L0Co8+sXiAP9TcAx7sp6h6rSMWjRoEJw07nHThQ=;
        b=LCwOKJFqVQKTIJj8grBLXijQJXijR8Z1g1wZXy8H3oBKrhrE3qt1jQvFSfyi59UvOv
         sUhsxRVTtjoyXsYa10Y2oPf9gAXRrqbuVwXVboQK8kSMWhDwF1r4Hr2aL2LXzQsuk7dp
         42Dj4V2DwwWScgVVdskYGW0MMfvOygoTz0XsTGQtbR084CBk67bNRKq0ZxTu9oWsY0ez
         Mu9ozpQjg3EzngocKse6nUSJfYi2xIlJuISvmd6faSrDISgiGxN19WnkTNR+Ts0gA7o0
         qaiD0ApEb8Ne5178UBVTw1rU170Ba5U/VylOhRQvqwJSGlpraVNO1y38MBDpSEKddaBu
         2v8A==
X-Gm-Message-State: APjAAAVx3B4T6aOMPQmf7diHlZoOH5EQOI59ozl6GjjdLYDdtftrMSZ/
        rikjCk3A65y5LnRppPqd/+2Q8lbkdT0rqg==
X-Google-Smtp-Source: APXvYqyMC9eygAhqJA4QR8E6wSDswGB2uR19d4utcMbSbh3p1OcckF0Ss80YcOOfoIZWu6fdEjghng==
X-Received: by 2002:a17:902:6f08:: with SMTP id w8mr7798460plk.263.1559291321228;
        Fri, 31 May 2019 01:28:41 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id d4sm4759201pju.19.2019.05.31.01.28.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 01:28:40 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        christian@brauner.io, khlebnikov@yandex-team.ru,
        netdev@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] net/neighbour: fix potential null pointer deference
Date:   Fri, 31 May 2019 16:29:43 +0800
Message-Id: <1559291383-5814-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possible null pointer deference bugs in neigh_fill_info(),
which is similar to the bug which was fixed in commit 6adc5fd6a142
("net/neighbour: fix crash at dumping device-agnostic proxy entries").

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index dfa8710..33c3ff1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2440,7 +2440,7 @@ static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
 	ndm->ndm_pad2    = 0;
 	ndm->ndm_flags	 = neigh->flags;
 	ndm->ndm_type	 = neigh->type;
-	ndm->ndm_ifindex = neigh->dev->ifindex;
+	ndm->ndm_ifindex = neigh->dev ? neigh->dev->ifindex : 0;
 
 	if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
 		goto nla_put_failure;
-- 
2.7.4

