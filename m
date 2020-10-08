Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0586287932
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbgJHP6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbgJHP6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969ADC0613D4;
        Thu,  8 Oct 2020 08:58:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x13so1725735pfa.9;
        Thu, 08 Oct 2020 08:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JFzfQel0Em2E0dYcXwtpvySSq1ZQYNyJWWOukr+jm34=;
        b=VFF/TvJk8cAVlFkkMVg+fyFrL7k/Bdlb72VoYGH0yARhiK8h0uoIDHzZxbUZ0lKRxI
         nJvgAhsrCnfL8dz5edycXaKhmbzmgc1tO1IiIDPiTlCnQSGzPQoAI5wG+mJkR59gSyHB
         bmTKz8kQEaD3LoOa9mOO9LMT4r1mMsR3JHFusknbZxFyisQodx0fYloh4XO1GBflEPSf
         a2QN9ST4uEZQ1uto796cwJ7p423SJLbZ7Xj5AZjttSA0YXClMC32AKeO06BU0C4rzRn3
         aB4nh22iJjidmVWkrB1RPYUQy9DczN3psC4NvydA3v5xtPs3YHl9X5NnM1CCWwclVg9I
         dfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JFzfQel0Em2E0dYcXwtpvySSq1ZQYNyJWWOukr+jm34=;
        b=FvebloiHArxDezYywL5fZA94QyshflkMvtuBv1pZSoNu2QYIRamfq4dd42Zfrcs4ba
         U9taCeJvJBgSmE8Jrqa68VE4cZGyljsRg5SzLERVX8d2Ufa8buWLF5Fgau0Znh2Yuyw/
         3Is0M3E2bpIkNoJ6lomGu9DSYpmh4IRSVa2QwK76u+o2stfOvH2SJiNt+xD6D7PKuF85
         4jp8GYFMNuk8rgi8CkbY++bVDsqGYGww96+M45LF/uty5LKJGcrCU/GHMZSiPL3JedWF
         Pd4ioq5yOBEImexHjmQ54YePZ8XwtFQzX6CpHQEm0JMs2vafAXW4zqLyRnIncc/1N2dQ
         QTFw==
X-Gm-Message-State: AOAM530qNxyTNTPNXgESS1iCjcbkidiWbyJuqkhvlcVP6dmuaW1B3Dy4
        IP+NfkqNc3e8LyZLhndcD98=
X-Google-Smtp-Source: ABdhPJyNcWvee6rOYpo1vSrgzPAOcXS5s01/ThIQAqp2gBAZZ9hq/x+IqpXJ94Cf+g4pFjhaxuVepg==
X-Received: by 2002:a17:90a:aa90:: with SMTP id l16mr8937887pjq.0.1602172689170;
        Thu, 08 Oct 2020 08:58:09 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:08 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 112/117] Bluetooth: set DEFINE_QUIRK_ATTRIBUTE.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:04 +0000
Message-Id: <20201008155209.18025-112-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: b55d1abf568c ("Bluetooth: Expose quirks through debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index b8e297e71692..4a26cb544635 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -71,6 +71,7 @@ static const struct file_operations __name ## _fops = {			      \
 	.read		= __name ## _read,				      \
 	.write		= __name ## _write,				      \
 	.llseek		= default_llseek,				      \
+	.owner		= THIS_MODULE,					      \
 }									      \
 
 #define DEFINE_INFO_ATTRIBUTE(__name, __field)				      \
-- 
2.17.1

