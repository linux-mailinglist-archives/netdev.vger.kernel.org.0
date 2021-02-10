Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A24316C47
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhBJRPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhBJROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:14:18 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE6CC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 09:13:38 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cv23so1466690pjb.5
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 09:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6MST5FWPMAq4NFCdC3zKgU6DUUvChp9OyJPx+q+eF7I=;
        b=tPNYJ7vYCtwsDWLUGRxHAJ4rkbf2O8h06kA11dmUvCPf8uyrgUxJUVCw18JnjUOT0B
         U0mAT5cPAUPzguYrVQhyb+HjOhuAJ8Rrv1e+2kYB/877jlzWF47IKN1Rxdfp4xgOlctc
         OR5i3IqLVO72ad1J7lArTDcLG/ML/nMCabBbMvKclY5Mgcq/EP6mURKWoYUXzY6JGMoj
         ywgbYAwhZUaewq5y0U/9fmiwHYincbsgYI/cdQCLwIbFrKO1QExlxDAYIi6nhy9tR9O1
         P77L4Vm7j0HZXn4S20ZpkqquzrZzHxhK3Ee+pGfq2U8yfgkRG3p9IAcg5FcWapih4PmR
         diqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6MST5FWPMAq4NFCdC3zKgU6DUUvChp9OyJPx+q+eF7I=;
        b=KnCUdETGeMvLOZBNdhuMm1Jgq+zjkC6lzOO8FgOwzpPQvfuIKB2JmD9/12k2xWWJE5
         1uO92QvZFuP61gjMm3HFHVlCk8aTulXAmyw6tB5D8olALpbkH9yhLpk5wkFuer7WUAqp
         /xLtifDNaKmhnQiabbYbkcTkR/yo3HlhxCZSEa6tJZF+gy8rl/85mgtMmXrlU6pTPs9E
         VhTFccbHjlAswLUJgb9Wg9Aim6tg4oZUSTxoHbAj0GJeznedbAxjqWC9BjpeJf0rYWYC
         oMXXYUgYj58GMuk6PIOkkoFCj0ZXX0mXwuR2VF6xcgauzHhO+k+jgIZlI11Q4wqxHwq8
         F2Uw==
X-Gm-Message-State: AOAM533fB6b0SNEYiIABeMh/03FGAaNZsD6F2+i4hFmqUzyKlhQwtTFM
        5OPg3a9MkifysUkFPSoIBTk=
X-Google-Smtp-Source: ABdhPJw8Ob5S400OAiMT/SK1UPzMBuzm/8yfibFb8nsbfNVZMLsTiQfojswcSqx9u4JUE9Bt1py/jQ==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr3957493pji.151.1612977218177;
        Wed, 10 Feb 2021 09:13:38 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:48d8:4083:5be:90d7])
        by smtp.gmail.com with ESMTPSA id d124sm2469291pfa.149.2021.02.10.09.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 09:13:37 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Zhibin Liu <zhibinliu@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: [PATCH net] tcp: fix tcp_rmem documentation
Date:   Wed, 10 Feb 2021 09:13:33 -0800
Message-Id: <20210210171333.81355-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_rmem[1] has been changed to 131072, we should update the documentation
to reflect this.

Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Zhibin Liu <zhibinliu@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
---
 Documentation/networking/ip-sysctl.rst | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 83ff5158005af523f7b7464313a1c7f1f3b3ae05..0b9f19f1b6b5c4985201ede4661b644ec1ef98d7 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -651,16 +651,15 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 
 	default: initial size of receive buffer used by TCP sockets.
 	This value overrides net.core.rmem_default used by other protocols.
-	Default: 87380 bytes. This value results in window of 65535 with
-	default setting of tcp_adv_win_scale and tcp_app_win:0 and a bit
-	less for default tcp_app_win. See below about these variables.
+	Default: 131072 bytes.
+	This value results in initial window of 65535.
 
 	max: maximal size of receive buffer allowed for automatically
 	selected receiver buffers for TCP socket. This value does not override
 	net.core.rmem_max.  Calling setsockopt() with SO_RCVBUF disables
 	automatic tuning of that socket's receive buffer size, in which
 	case this value is ignored.
-	Default: between 87380B and 6MB, depending on RAM size.
+	Default: between 131072 and 6MB, depending on RAM size.
 
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).
-- 
2.30.0.478.g8a0d178c01-goog

