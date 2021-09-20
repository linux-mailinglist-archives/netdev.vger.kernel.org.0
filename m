Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AF641188C
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbhITPoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:44:15 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45538
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241975AbhITPoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:44:11 -0400
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7B20740261
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632152563;
        bh=OcpxhdBlzejp2v0C2MQE07mgZm7uaKlgWhogNvtB6Bg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=jYU4h74b7zZgjrw963sCoErSuOmZSuTt+c4340SlhueniovejZ9dM3qYxl2QNeFtm
         GREH3Coih0Fg2Y0bOy0D/6MmQO4hqM9/edDiShqM60eYXraAk1OeV2l9ZbCB/5/8xB
         4EPjU8EPnX8BBCrIeEuXRX2fKiIT14B7BzZ0nlySjLc41Wg51swarqb8uGQm4MOApA
         9AiujQSrJFpUgOEekQcHCrE7jT6M5aDt0/RxCIcE0W5o6sQBcCGvGAPUqWJ+JO9N4D
         Pk25/vSV80laY3XItzNapYNRpucFh5xcxKu4kxCx76ufJikaUY0MshKBT32L4hIY8I
         cxQVScqLXxMvw==
Received: by mail-pj1-f72.google.com with SMTP id 41-20020a17090a0fac00b00195a5a61ab8so183290pjz.3
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OcpxhdBlzejp2v0C2MQE07mgZm7uaKlgWhogNvtB6Bg=;
        b=GzLCsGI7HXXVsHa0fQOJyUGY55fUtbmhFqeZgt3hTlTN5rD9T50Y8nuy8uy0lOzUtK
         JilSMq/nbiz1jkRTopIMZ86dCm1Fyj/XMAtEYxPmgB3gtXho7h5V/4thxc3ZFsO6sC8f
         zEemoCJj4Kn8MFMzcrrPDKZxIIF5wJnwlmW9newaU/Lb4GK2a+W0wswV37W+c+/imPjd
         kZGo1ynPLhW267h5lE827AkP/MRxn948bEDZMKgp0CUS1vRkJXZ+KsERdPntt6CuIXFo
         Utcij0fH0RwB4KTw04p8mhwlr+XOLgT0ecwud/HBZfiErfZaWFHkMyoKXIfzGg9vLi1D
         C8SQ==
X-Gm-Message-State: AOAM5309v+n2/8ZpE5OAqCDh6E/ZgW2KpIHkoj2cYBUm3rUFPEltz7cz
        R/Rmfn6lqcMwKVl97F4yJ98vCZkgehyatjfEVW/IiV9OPCrt3cgdyYeIWSeGggFUx6lGx7njGQd
        s16LpLOu1TZcMvj5sXjYCswKMHwEbDdeH/g==
X-Received: by 2002:a17:90a:7a8b:: with SMTP id q11mr29895645pjf.35.1632152562060;
        Mon, 20 Sep 2021 08:42:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN+ikGFNNGkvQl7+s28E1V/m0S/lNnypEIpSFEkQjJp9P34/1b21IXIFSgIWBwJnHVvmXx7g==
X-Received: by 2002:a17:90a:7a8b:: with SMTP id q11mr29895618pjf.35.1632152561766;
        Mon, 20 Sep 2021 08:42:41 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id h18sm6260556pfr.89.2021.09.20.08.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 08:42:41 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     mptcp@lists.linux.dev
Cc:     tim.gardner@canonical.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH][next] mptcp: Avoid NULL dereference in mptcp_getsockopt_subflow_addrs()
Date:   Mon, 20 Sep 2021 09:42:32 -0600
Message-Id: <20210920154232.15494-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains of a possible NULL dereference in
mptcp_getsockopt_subflow_addrs():

861        } else if (sk->sk_family == AF_INET6) {
    	3. returned_null: inet6_sk returns NULL. [show details]
    	4. var_assigned: Assigning: np = NULL return value from inet6_sk.
 862                const struct ipv6_pinfo *np = inet6_sk(sk);

Fix this by checking for NULL.

Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: mptcp@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

[ I'm not at all sure this is the right thing to do since the final result is to
return garbage to user space in mptcp_getsockopt_subflow_addrs(). Is this one
of those cases where inet6_sk() can't fail ?]
---
 net/mptcp/sockopt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8137cc3a4296..c89f2bedce79 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -861,6 +861,9 @@ static void mptcp_get_sub_addrs(const struct sock *sk, struct mptcp_subflow_addr
 	} else if (sk->sk_family == AF_INET6) {
 		const struct ipv6_pinfo *np = inet6_sk(sk);
 
+		if (!np)
+			return;
+
 		a->sin6_local.sin6_family = AF_INET6;
 		a->sin6_local.sin6_port = inet->inet_sport;
 
-- 
2.33.0

