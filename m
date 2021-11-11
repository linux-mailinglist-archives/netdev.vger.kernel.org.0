Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F244D3F1
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhKKJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhKKJXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:23:41 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4866FC061766;
        Thu, 11 Nov 2021 01:20:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so5332705plf.3;
        Thu, 11 Nov 2021 01:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnOyeMNKPldF7kPwhg+7Exr0iFKBol4gkNNHNe4nQZM=;
        b=pb1ul8icuSncNizX3EYFhiCICsQb5w1pUzk+9VBzrBABsHd0dGs05dIhHZPN8ViFHP
         Le0c6fFq0KC0PW3hz69TGnCsaqKUAR7a5xr+6FJK/eic0lFYjvQfXGNmjEhlHr2s+dKz
         cf5dg/55mYtZNtSN4gyrrWi2pCQ2g//YMkzLLiKuYnuFRUrnYeIGgkGJxgMcyjh68SdI
         TqZMsVocXWbbTRAAETLRHZUz+2IHpNESyta5RBsclRHwr3lAsX4p/F9ZvV3FXl9smW/+
         bT+RyiAUjkUEYJ8cMycWFhXNMgGRy1q+fxGY4QLH0jY2kadDSSSnqg7pKyWu+BXEgwHy
         3j1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnOyeMNKPldF7kPwhg+7Exr0iFKBol4gkNNHNe4nQZM=;
        b=6iZa1h3uB5/Rcakccgg4ZKsWbcINU3W0oHWh6NATPqwGpeg5RWf+Giywq3SMqwE4Ki
         YjkhaTtjUDjQKywTijF0XzK9d4RbRk4PZ3yEMjR/8sbn9TyPG8IQlB0FBbgcT8ZJK2jw
         logKMjgbaibNQX/84qf+aeOwoO3Kjfm9gAtvZ5d9YtS34CRXYsQlIGZ/riOrjPdl8u0A
         X4KTd2tM38673xMZK60IptBR4YIiQIwJ8xw2APfpx/phiS8EslSVd0l/lP3qJ2oX41k6
         G+3lzXXiPo4qgVEUi0Jh1KNhMxr7Injsrxvs5Jr4Mu8pq+my1ZXLBwx1Ojr6ukA+cXqO
         15qQ==
X-Gm-Message-State: AOAM533jODzfQu7LVrHeuCIHPmYmUTVP9YCxN1hOqIwYep8Nhx3EZPag
        Vhs8Oodj90aX6VarBlxZVXk=
X-Google-Smtp-Source: ABdhPJzjNRWc+ZeFgxicwE+iBJ5D9GkbyyX2CSdkBGZInvjpnAogM7szWJbtJ7OnVysMgJNg8qheQQ==
X-Received: by 2002:a17:902:c947:b0:141:e7f6:d688 with SMTP id i7-20020a170902c94700b00141e7f6d688mr6008602pla.56.1636622452823;
        Thu, 11 Nov 2021 01:20:52 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id r8sm1559546pgs.50.2021.11.11.01.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 01:20:52 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ipv4: Remove duplicate assignments
Date:   Thu, 11 Nov 2021 09:20:47 +0000
Message-Id: <20211111092047.159905-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

there is a same action when the variable is initialized

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ipv4/ip_output.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57e..57c1d84 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -672,7 +672,6 @@ struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
 	struct sk_buff *skb2;
 	struct iphdr *iph;
 
-	len = state->left;
 	/* IF: it doesn't fit, use 'mtu' - the data space left */
 	if (len > state->mtu)
 		len = state->mtu;
-- 
2.15.2


