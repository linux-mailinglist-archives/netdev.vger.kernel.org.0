Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B782FF7AF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbhAUWC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbhAUWCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:02:37 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B489C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:01:55 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id e15so2765394wme.0
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=8NFmJRRR5EkQ1za0L7Z8Qn9Sd9uQNf3Pdj0cuJZFXo4=;
        b=E40ntllRQH18Mm/jwT+opg98rLASg+e1pxl4Nt/o/PFvPb/4Vg77lrtJ7taLZ6FBGD
         fPfxBupbErytu0HG3SJ8971Tdk2nXrtssX7/92loTwSLKkn8Pg9I7Boq90wQ7ypl7hLa
         CL8O/P06xBmB6nX2icA6z2/0UEe338dq1Bq0gZupTDuPR9zLafsyK9WbyVZHg2xp3xZY
         8Fy2Trq5+m79noQXxJPwnlx92OZF48vQUNLXfbUGdyZtvQx9dR21vtLMDaKKu1JzT1ya
         GOnzjNMNRcXYuot9GvFLYYTuKBSXQCHXcqtGnoWmOrWibB2xBUTUydcoYA/bScSGEVtL
         cvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8NFmJRRR5EkQ1za0L7Z8Qn9Sd9uQNf3Pdj0cuJZFXo4=;
        b=WU4TUjdLm4huN6SjwGdffKo7zP/HIqM5UAa5idASnqrt6X22FaEbDr6G+crxLUueZh
         JAt04QROncwfctULkJcsgivf2Zqz+SlucLRsSaTPEn2teXQ+X5A1lDR+wRbDhuYiTpwV
         K3jM7Dwcy+/11OR3rTyBa8ArpcSSYxTRc541iTy5ppUs/9HuO3AJvS/lpmk1ggyNwpnN
         F4HrBrfK0q54XU1+KHM2DoOscVNpIc4x/TMkJ14NgeZy2kFgIQFX4a8/oxN+0gkO8QD1
         Nk2CE1MAQj16PDtlkmUyVK8A3HEwVinrAR4S8OpoiOqQek6uiyV05ir2bVdFg+D9NzSM
         1PVw==
X-Gm-Message-State: AOAM530SSa3PocjfvZu65MMqexg8j6sBdWrq0bYDwu6iCp59Fvhqe9yp
        c6iM/sg5ZQEcUr/LflRRX5Mon38o0Q==
X-Google-Smtp-Source: ABdhPJw+PQS9QaweC1HHEIltrt7sdsXUzTRo002Cl/Tfz6bPgJGsKSNXpn7AOYHMwMD5mmScFLr1eQ==
X-Received: by 2002:a1c:bac1:: with SMTP id k184mr1189797wmf.17.1611266513537;
        Thu, 21 Jan 2021 14:01:53 -0800 (PST)
Received: from localhost.localdomain ([46.53.253.48])
        by smtp.gmail.com with ESMTPSA id k9sm10163530wma.17.2021.01.21.14.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 14:01:52 -0800 (PST)
Date:   Fri, 22 Jan 2021 01:01:50 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH net-next] ibmvnic: workaround QT Creator/libCPlusPlus
 segfault 
Message-ID: <20210121220150.GA1485603@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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

 drivers/net/ethernet/ibm/ibmvnic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5080,6 +5080,8 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 	unsigned long flags;
 	bool done = false;
 
+	/* workaround QT Creator/libCPlusPlus.so segfault with dummy ifdef */
+#ifdef CONFIG_IBMVNIC
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
