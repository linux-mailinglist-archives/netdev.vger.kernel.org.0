Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD96355FB
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfFEE1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:27:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41999 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEE1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:27:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so3853002pff.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 21:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i3O5ZnqEZQUqtT7DnCw8dRXN8dbdHsftN82p97LdIPo=;
        b=b46ofCHhgxws6XUwPN3lwYceoj4W9/rHQUuQBqAU3Zm64Hs84soeYOopqz9b9A8bZB
         mZ+Jd6qzJ1yaraiKr8rAOv4okZB16IIm9h5y/Mnauxupt4qIO2SiktGYv0yZeQu4pcvT
         bwrDkuGDZ6z644KXnPZDvANej20l0dNQG/2xMfFfT6hm0JBsddVasjsF92x1BKZEJwFB
         vwQr3oDTX/rKfk6Nf0c8y3Hcg13/01UU02BOdSkLmdqI41/hMIISRLlE9wbGz6qL2Ji3
         w68VSsn8E0wPKjwPuUJXjmc71TAdAqYKj+i8fr/5t6imKVSubRk8tqbyrvw+RGFgv70e
         XTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i3O5ZnqEZQUqtT7DnCw8dRXN8dbdHsftN82p97LdIPo=;
        b=GUtbk6BF1mkSLeTFroCbkuTQP58khZbc0YQqEzfeM5MrNLkvolhVUjlTQ5FCi0q+fT
         lVN6i9pZvouRqVTX1g/8C7BAAhJYZprYJ88wWV7uffVuO88TEFHRvvB8nSMlCmpRwXEm
         t3/7xHMZDLZCvaMz/SjgXvq0FJu5gxYWhmoWAzK7YYmPUSEHdJ28VRRjrEE+s5CqH9wx
         p/SIycSwFcYwQ7BLIN6HK03H39inmfYpwot+aKPQlsIimnPkbY5/C/O90dhRnOmliWUf
         b2iHiUOFxIZ0Y0XP9tlM6q4A+k420ZnhNV5SCfuaXAeG9kYojpoxDrmQSf56A61lig/b
         7MAA==
X-Gm-Message-State: APjAAAXfiks2B6HUReFR7XLcv0vhVCNpKQFuUX6g6p13pwVbj2klgio5
        CyrsBIbnJG9hfM5F2WvwY0nBfdYsHdTqmsA7
X-Google-Smtp-Source: APXvYqziajXq/+DTVRp0Rt2GLpeevz6GBuOSzK7N8FzgHVG+KEkLGrCrH6H0sICYfihTnqJiwxWufg==
X-Received: by 2002:aa7:8c0f:: with SMTP id c15mr16581278pfd.113.1559708858522;
        Tue, 04 Jun 2019 21:27:38 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c16sm31513603pfd.99.2019.06.04.21.27.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 21:27:38 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        zenczykowski@gmail.com, Lorenzo Colitti <lorenzo@google.com>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsa@cumulusnetworks.com>,
        Thomas Haller <thaller@redhat.com>,
        Yaro Slav <yaro330@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] Revert "fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied"
Date:   Wed,  5 Jun 2019 12:27:14 +0800
Message-Id: <20190605042714.28532-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit e9919a24d3022f72bcadc407e73a6ef17093a849.

Nathan reported the new behaviour breaks Android, as Android just add
new rules and delete old ones.

If we return 0 without adding dup rules, Android will remove the new
added rules and causing system to soft-reboot.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Fixes: e9919a24d302 ("fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/fib_rules.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 43f0115cce9c..18f8dd8329ed 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -757,9 +757,9 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		goto errout;
 
-	if (rule_exists(ops, frh, tb, rule)) {
-		if (nlh->nlmsg_flags & NLM_F_EXCL)
-			err = -EEXIST;
+	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
+	    rule_exists(ops, frh, tb, rule)) {
+		err = -EEXIST;
 		goto errout_free;
 	}
 
-- 
2.19.2

