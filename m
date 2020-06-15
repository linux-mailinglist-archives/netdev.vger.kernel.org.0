Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C11F91A3
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgFOIgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbgFOIgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:36:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0DCC061A0E;
        Mon, 15 Jun 2020 01:36:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so7516035pfn.3;
        Mon, 15 Jun 2020 01:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AjIM9F1YD0eAghWW7pMVSiUA+YlC9IghbUbcMANQW/0=;
        b=CLGeR2FghoElL6R9Z2Bi2Yc5VrXUneQKgPEEdLL5cd2SYNibiDR7XLtCr186JA5PZa
         SJAD8dGgN62hOWYcXD3CqmrwNovDbLGKM4RqTpf6fgq1WtLuuPSV8BRxAaURmKp8h59g
         MM8Eisp5mkQXQBpjuRJYC9jhL1LxU9pA8DByK43F0zYuaZnccWbHeaPjqtYcq4rzmG6W
         5i+oMlGV7Ck25vjXEFF0WlG7ytL3KJyviRZnmj3oxZlTkpaBr778OcE0sEvSgwRw8O97
         C0gnF1Y2gQwPfmEWs452TBVzA2j3kGYzKqi4vgUQhBxu+Fi+E87lyDWVEU7/bRoxHEM2
         2gaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AjIM9F1YD0eAghWW7pMVSiUA+YlC9IghbUbcMANQW/0=;
        b=BLwa2hwpjuYfYn5fdTg7II5bPNwLUFpQdPO45AbTwfMGoaiTVB4XWZmjxkDhUW3q08
         1QYgqD6X+/Nmg6+otGiB54yz94qBwl6HC6mXPYeD/EMYullWucmmF/PN8S8UHyXvI4jR
         TyQNQQh1VvUG/mUuFBsj+eHljz6hiboqmO+dMMdFjOPEceemr+S5A729tWTZpO/we0ym
         z752c1kT6xky6Efw0ChaDgIqINl/cIHnNeYRDHuSGRnNzPrc9+F3gGFLP9xsbbdWi+pK
         dgrNQcfudfPgjGSvdYizcV7hR0oRvKin7i1l5PJPspdvAnckXPWM0/R+lzdz57qf3850
         yu5g==
X-Gm-Message-State: AOAM533ZurEFVS6XcCgM3GFSJG6I2vnFb44hmMKXNTEe6wjPtIhjQO/9
        AAeMwPAN2sIfglRqY39DdHI=
X-Google-Smtp-Source: ABdhPJzLH7mZO6kEiWcWMGU6S/x10QPmiLfRXXFbYPCqwGr9bT15E1iyvq1yTuxedDzoprcOo9IRXA==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr14889002pgd.40.1592210203981;
        Mon, 15 Jun 2020 01:36:43 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id x1sm11954844pju.3.2020.06.15.01.36.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 01:36:43 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] mptcp: use list_first_entry_or_null
Date:   Mon, 15 Jun 2020 16:34:28 +0800
Message-Id: <6cf9b609f1d77b389165448b9a9b38f6bee48f87.1592209896.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use list_first_entry_or_null to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 Changes in v2:
  - Add "net-next" tag in Subject.
---
 net/mptcp/protocol.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 70ed698bd206..db56535dfc29 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -232,10 +232,7 @@ static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (list_empty(&msk->rtx_queue))
-		return NULL;
-
-	return list_first_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
+	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
 struct mptcp_subflow_request_sock {
-- 
2.17.1

