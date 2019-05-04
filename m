Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6720136DB
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 03:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfEDBSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 21:18:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40663 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfEDBSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 21:18:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so9907703wre.7;
        Fri, 03 May 2019 18:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IIUcmLhElCI93DDESapOvTPyO5IBp1J0kUUxpCHpsLo=;
        b=TAHzkIPowTU1+WIShGaYjfvfNKHN9zgkohUh1z1XDTs2Hu+h5JJ9W1Vy4DY5td/8QR
         0Z2skqtz6lDiBbU7/bF9ccEROLptdRQW3Y+BciEnyyriJJMDCy6VpOg62w/Z1YA7rS+9
         r0NpickGwHYujg8vrNXA2RBaM/6yhIKFHCyuzytMMAAPaLU6JN4Wa5pfNzwhu19TeXrU
         GmYlActx+j/3FhTyz6KXMIi06vg/BD9zyfwOEdrK5gFhRViyXm/uEbe/XQ/peW1+uKs4
         AnSfem0hAPrDtWk9G6kwQYWjvAuuR9EkaQiv7O0XLPa/H6gsssIdWKZDeTe7fcsilMFe
         XS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IIUcmLhElCI93DDESapOvTPyO5IBp1J0kUUxpCHpsLo=;
        b=W/P++xG991eWspZGponKnV/0cHVvZT12yiHw0EPQLWe+jWbaAMFBwGKifWJ3d9DVED
         kStGLNQdWNAWsmTW8dX0LtgssRpanDFa5i2EXk8lQgF/YFFWXd1AfhoFgnJnCR3i/PqZ
         U+qmpBLBDGVpup6zUIJ4DOMNHiY1HnCTsd4qVWgwCYUFHnIip46Nz3yXbYmRrF88E7u1
         5Hr5aotG9aMYz1xqydTfwr3rimM2wcPGl0BmlTahpBVddFUjsiiLz+L4SPFVWq+//ivQ
         Xqh/RDG59Gq/ifWLnm2RLUN5o1uIxMqDdblvuJK20Itrdz0uPiUEd8l7BgGRFgqFFGgA
         rYTw==
X-Gm-Message-State: APjAAAV2SYOaN0TfKxOCIjavc299+egH+8X6Wyh0omI4eKx4oeU3GI4e
        5GiPYRNJdezzH+SUvcyTrDVcvnFgDBc=
X-Google-Smtp-Source: APXvYqzUOCUy2aHxl1msfJ6vU+Qy6gE1WfFArAwklpYsZPABh8pQCWjUOxRFpQDhwPJuyvGnQBvaLA==
X-Received: by 2002:a05:6000:ca:: with SMTP id q10mr1684102wrx.148.1556932725473;
        Fri, 03 May 2019 18:18:45 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id t1sm3937639wro.34.2019.05.03.18.18.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:18:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 6/9] net: dsa: Add a private structure pointer to dsa_port
Date:   Sat,  4 May 2019 04:18:23 +0300
Message-Id: <20190504011826.30477-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504011826.30477-1-olteanv@gmail.com>
References: <20190504011826.30477-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is supposed to share information between the driver and the tagger,
or used by the tagger to keep some state. Its use is optional.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 936d53139865..b9e0ef6c5750 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -207,6 +207,12 @@ struct dsa_port {
 	struct work_struct	xmit_work;
 	struct sk_buff_head	xmit_queue;
 
+	/*
+	 * Give the switch driver somewhere to hang its per-port private data
+	 * structures (accessible from the tagger).
+	 */
+	void *priv;
+
 	/*
 	 * Original copy of the master netdev ethtool_ops
 	 */
-- 
2.17.1

