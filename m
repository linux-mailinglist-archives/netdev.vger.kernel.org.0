Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED93E796D
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbfJ1Tws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:52:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42202 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731748AbfJ1Twj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:52:39 -0400
Received: by mail-qt1-f194.google.com with SMTP id z17so9805446qts.9;
        Mon, 28 Oct 2019 12:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUTKdFDPrGgk09QGA1Rdd0uffvF6EVOR+F4iTfHOa38=;
        b=lYXYxM8kJNaF+I3CG8mbyHhpWhBhhsOwyhUPhKguiKy7DzVbLGtzqGOcLR7MDDC0O3
         3ux9fqi5a2pmiThlGjamxk+FbnclHC2P5IYs6/s2KaQ5rssFhqSBmSnyLNUDxjwPwlw9
         dKBWomjwczV0T3DdUAqU6EUqvNoFrCKnpBs8O81k2pMa1g8m7p5Ft1MqILmFe/g6kE4d
         rVl9Hdz1viZMknOXX6y+SZZgJEZAYf0dupLgSiyTMfyD6F78+fdufUX3gWz1++aLwEqT
         hrto0Ul1MjXUKc7ru756bpZg27m6+B4tX4weSP4AyLUn3eCO78DlF52GmLwOkN1c6xOx
         i/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUTKdFDPrGgk09QGA1Rdd0uffvF6EVOR+F4iTfHOa38=;
        b=Lgd500Fu+SHkb1jRyNcg6Rgq4bYY9hB12VkAastd1Cw72DbfCKIjPT1u/2GfY+4q5f
         ib6rnvpVIwYFiVQxJHAMLe7e9NCoCsC8AHbr0Lf/bvr9aipqipxhsc9MeX0PqgL18rMI
         9zJgGW4i59Kt5WHq4l7Z7qfSnF29p69ogU0mKuztmrWrwfFYk3JsYSNWgpvKRPrW51vk
         NuKDDiayVhQxr20hogAXpjAWd4KATTzch1pJkJDUHXE0CHs0nuTmQmjhEs7OIv+uoIga
         Sz3wTsuONILQUoAyqUEc6oM2cRQ9wJJwHZYfk66KXMd5NN7AymBPgLAPoPfw+bUHuKMe
         BoHA==
X-Gm-Message-State: APjAAAXI+RYwdtG/rysc9ZZTe9UUdISxEjtuDYIfDMm3b2ExG87QG4Sw
        IF8WUsrFQb0+V1cxPjPSEZM=
X-Google-Smtp-Source: APXvYqzYNbBdcGsqEOj3H9vtNZebRQXYixqnWuote1tYjdzSLfj1nnaMTtERqSypp44oowS7HtQrKw==
X-Received: by 2002:ac8:1975:: with SMTP id g50mr226526qtk.268.1572292358127;
        Mon, 28 Oct 2019 12:52:38 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m186sm52357qkb.51.2019.10.28.12.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:52:37 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 6/7] net: dsa: remove limitation of switch index value
Date:   Mon, 28 Oct 2019 15:52:19 -0400
Message-Id: <20191028195220.2371843-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028195220.2371843-1-vivien.didelot@gmail.com>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because there is no static array describing the links between switches
anymore, we have no reason to force a limitation of the index value
set by the device tree.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 5d030e2d0b7d..4d00a0516cc0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -704,8 +704,6 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 		return sz;
 
 	ds->index = m[1];
-	if (ds->index >= DSA_MAX_SWITCHES)
-		return -EINVAL;
 
 	ds->dst = dsa_tree_touch(m[0]);
 	if (!ds->dst)
-- 
2.23.0

