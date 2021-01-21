Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F6C2FF7BB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbhAUWI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbhAUWIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:08:23 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB26C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:07:43 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a9so3225359wrt.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fx5YszuqKigyLXqQ9KCfecGR4+ZLeAzjfHMRsb7BoC0=;
        b=bPyRoDNx7ru0R57SXSwNmVxAIFas4GK+50bYUIzAUEERZ5p5YnVe0dSihFClF9tPYo
         ac176Gy9AQ9bMfm4ZlEXc+NkoapdXDHXFb+vdrl+/0+h+saUeBtsHEwq+FJCG9tKlGaW
         Ujg+ldd9ByGdQdfp5rEOlENj9A4hrz1L8Qo3uT0c0ZPUJXyXxP/gBU5tfkn5ILUr77ee
         4biND7pw9hTxy5S3GSOrT+Vx8UoBrhDt5wJgWdGjUR9ft/6PKpJ+FzhUAC5cohdtGgP0
         iw4qkSsIxbJU1dv350unju2nm4YDi4lWEz7xAiAR3/bv5EYoQRfmvbNAh1AKOat9xEZk
         OFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fx5YszuqKigyLXqQ9KCfecGR4+ZLeAzjfHMRsb7BoC0=;
        b=KWxzHajCkgU5OFNBeLZ4CZK65TFWVG5N9vbyNrJ+d1D0J72ZPwRUs1CSoG+fWeLroW
         cLoLoUv0ho8Dio3y4blyiMGeDFdVB5Gw5QEtTKSEkzmPOu6iGl4ajzJRNyj64G3+/CH4
         +FRAJ0vcW2fTtFCLF5X5MSQkewIwO8C8su9au4Nd+71sXt6AJHP6Hd3F60rDsBI4kZS/
         7kD8bK1Sn8hb+I5XeHERtQ729vfOwBY8FUUJZ5lZSwDgFADw8Z1aKQcDOKmxE9DpUiFn
         lZWZiD6P0UtdK8AjpULSNSgXN6qgeR7qB2nQKaavf8uAY/QcfRn914zdc80DMu38vtTh
         +gLA==
X-Gm-Message-State: AOAM531E3oMaeJlrwXrbTxRh07Jk2p5mxCQaRkEFS2i8I3lHPycaRcE5
        Yi8PtbhSPF37RJK4DZOpmZOYr6Xj1A==
X-Google-Smtp-Source: ABdhPJwrJJDfaSUvzQjiLz+ejIoIpamCh1HhyhX4cmzcNTqMQQnGImd0fWxgQ1QUCA+8zyTJooaxDg==
X-Received: by 2002:adf:d206:: with SMTP id j6mr1366282wrh.427.1611266861744;
        Thu, 21 Jan 2021 14:07:41 -0800 (PST)
Received: from localhost.localdomain ([46.53.253.48])
        by smtp.gmail.com with ESMTPSA id h23sm9195828wmi.26.2021.01.21.14.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 14:07:41 -0800 (PST)
Date:   Fri, 22 Jan 2021 01:07:39 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH v2 net-next] ibmvnic: workaround QT Creator/libCPlusPlus
 segfault
Message-ID: <20210121220739.GA1486367@localhost.localdomain>
References: <20210121220150.GA1485603@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210121220150.GA1485603@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My name is Alexey and I've tried to use IDE for kernel development.

QT Creator segfaults while parsing ibmvnic.c which is annoying as it
will start parsing after restart only to crash again.

The workaround is to either exclude ibmvnic.c from list of project files
or to apply dummy ifdef to hide the offending code.

https://bugzilla.redhat.com/show_bug.cgi?id=1886548

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

	fix modular case

 drivers/net/ethernet/ibm/ibmvnic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5080,6 +5080,8 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 	unsigned long flags;
 	bool done = false;
 
+	/* workaround QT Creator/libCPlusPlus.so segfault with dummy if */
+#if IS_ENABLED(CONFIG_IBMVNIC)
 	spin_lock_irqsave(&queue->lock, flags);
 	while (!done) {
 		/* Pull all the valid messages off the CRQ */
@@ -5100,6 +5102,7 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 	if (atomic_read(&adapter->running_cap_crqs) != 0)
 		adapter->wait_capability = true;
 	spin_unlock_irqrestore(&queue->lock, flags);
+#endif
 }
 
 static int ibmvnic_reenable_crq_queue(struct ibmvnic_adapter *adapter)
