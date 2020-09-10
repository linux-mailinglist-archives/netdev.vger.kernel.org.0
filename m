Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78DD264A78
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgIJQ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgIJQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:57:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C24C0617BD
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id j11so9771083ejk.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cUqEllYJJk8JyJFlHa2X2KV36B1uHGAeek0pjkdahh8=;
        b=lwb3BZAvCYHBfFoTgf4ygLELjBJtieOf65VDFp6l0/ZyKbXTCZihFliA+s6dTxltm3
         NcmuChY5zNScBL+WhiAsSBGz3q3Np+foEEnm4mTjDdsGykB50wi3PfKSZoI5uRmP7mZF
         lf3N1v9XPwOFZQoxjZEjwogXOVq/MPQG+tiadE7qD4mspp9iWVLYGkx0HIvzZfMq3Qm2
         WGDsnhfBEwAB5AjPdNUZEbfBQpfPlavQKHOrx5O2PKhZ4hcJA5Sk9r12Qp4jb2QB9oqi
         V+wscz9FOOKCvUM8frK45uxoPUOKwtIih9Bc7yX+wZowhemP5cdwgtCu5kLsVP5ZGCJG
         g6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cUqEllYJJk8JyJFlHa2X2KV36B1uHGAeek0pjkdahh8=;
        b=I3/Z6ZoXkqT4qzaaLe5irs0EgMIQiL3yimR9SJLJj/pE0COrPDHnqS4F08viRXsOQD
         xH/Il1nJZdIJ7leO5jooZU8tqAjeE7SqxV/QNtZJzf/YkCw/maYrYZ6m5zLeeli4cWqZ
         m0GhOdDsWnwKMQY49W9wAlVXB42NL+3kwMyfr43c7GT5m5z1bGxTBMIU1TJC3ouCSIym
         0NlkUq/vGRcdNIUdAqLIadioPeyw6Tufl+ZPF0OAgxVASwX9JIry1zqp0kJk+TW5czLi
         ZvmoLQIAYeBEzbAdoqT51iYH0bOxzyqdJM7Jrr11MZ95kDe3NAfA5X+qJbPpntAP1eFw
         GhbA==
X-Gm-Message-State: AOAM530j7KfPHllxBWNNPMJo8Pwa5vJb8p/36vCNvDkwVJ6GNS6Q7RL6
        ZIcy8QlQ1gA72clAgrYwVqE=
X-Google-Smtp-Source: ABdhPJxbsFHzYzd2RekeBYlUFppFaHwfEmhHcvN6AEBa2E59kVdP+8e/Fw1F+TPYxWL+AMqVvDuR+A==
X-Received: by 2002:a17:906:d8bc:: with SMTP id qc28mr10165375ejb.490.1599756543051;
        Thu, 10 Sep 2020 09:49:03 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id o93sm8108024edd.75.2020.09.10.09.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:49:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/4] net: dsa: tag_8021q: include missing refcount.h
Date:   Thu, 10 Sep 2020 19:48:54 +0300
Message-Id: <20200910164857.1221202-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910164857.1221202-1-olteanv@gmail.com>
References: <20200910164857.1221202-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The previous assumption was that the caller would already have this
header file included.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/dsa/8021q.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 311aa04e7520..804750122c66 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -5,6 +5,7 @@
 #ifndef _NET_DSA_8021Q_H
 #define _NET_DSA_8021Q_H
 
+#include <linux/refcount.h>
 #include <linux/types.h>
 
 struct dsa_switch;
-- 
2.25.1

