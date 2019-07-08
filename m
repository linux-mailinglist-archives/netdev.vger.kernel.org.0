Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC83B625E5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388415AbfGHQOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:14:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38979 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbfGHQOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:14:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so17782905wrt.6;
        Mon, 08 Jul 2019 09:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzl7ySO00ACxBfoVjtfqCQyIPbur8JdXCvOsOSkfwVs=;
        b=Eh1ANWy7KSHIGVPL/JqTDcjXii2sbzTOw7liXbRyQZ6f2Oiy/EmB1AqsNVlaIhFhFz
         d5Ysddn9EMdoOSFpYrChGWdqh8q+u5tfB6rhrk/gTVWsv5Rq3NUJ4GpEJeB4Yvgu4OBg
         OB867U6Y7RP1BsxaeKFym0eMgU+5u+8AEwXs1bNObMDO5EXUSMBGYIeHQn6T7fjrOeN3
         J5ZOQbRayBqKFN2kN3avmH8+AS6Qgn3bO/aOO067tHBhoYWqI3kNCKDES+pywUUwAwUt
         jS6+tkxfcYlkE0hpPA+IciIOmAzc/bJA02fr7ABwOQs+DT/qhzGMBLnp1ChQIpAx9hGE
         HlgQ==
X-Gm-Message-State: APjAAAXWRX5BiO5nHJS1yy5/QL9P7bvVq6sTYIv7IYmUcZbgwOaE4PB3
        xpeJUMcenUSPY3NxvO6/MKk=
X-Google-Smtp-Source: APXvYqzhg2ITqrH1Y+C2tesFza97u7BSDJ0IRGUgRDYRcxahn9+uxmwgCGqNa1cn4VfEK26tzypJLA==
X-Received: by 2002:a5d:620d:: with SMTP id y13mr20519604wru.243.1562602474041;
        Mon, 08 Jul 2019 09:14:34 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id 15sm13468wmk.34.2019.07.08.09.14.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:14:33 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>
Cc:     Denis Efremov <efremov@linux.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sunrpc/cache: remove the exporting of cache_seq_next
Date:   Mon,  8 Jul 2019 19:14:23 +0300
Message-Id: <20190708161423.31006-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function cache_seq_next is declared static and marked
EXPORT_SYMBOL_GPL, which is at best an odd combination. Because the
function is not used outside of the net/sunrpc/cache.c file it is
defined in, this commit removes the EXPORT_SYMBOL_GPL() marking.

Fixes: d48cf356a130 ("SUNRPC: Remove non-RCU protected lookup")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 net/sunrpc/cache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 66fbb9d2fba7..6f1528f271ee 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1375,7 +1375,6 @@ static void *cache_seq_next(struct seq_file *m, void *p, loff_t *pos)
 				hlist_first_rcu(&cd->hash_table[hash])),
 				struct cache_head, cache_list);
 }
-EXPORT_SYMBOL_GPL(cache_seq_next);
 
 void *cache_seq_start_rcu(struct seq_file *m, loff_t *pos)
 	__acquires(RCU)
-- 
2.21.0

