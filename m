Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57D2294737
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440139AbgJUEUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411910AbgJUEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 00:20:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC594C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 21:20:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so697429pfa.10
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 21:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=IaIvvfiocblReIvzb7QeizBSDLZezoSmu3dplj7wAoqxmUWc1VJf4BDutu/Avb+owy
         80Yl79KrP+3Lnk8qgQ9yDvw/ubB+bhoKzydxHvhuWcMO+TFgHODzxsKhBSWtpX6Nw7C7
         9t+5y9xyK0kg+WuNyMaoF2/3tAF7vXtgTTXbHTRBSTmw+DbGmNthk9eqOlvz0UjrkQs4
         /fIzkZJAeGWqE/vEpzw2jGrdVQN7++hWv+BQ5tQ0qO7BlvCBkUo1f9RA6y8w3rrr2FyS
         fpcdtORdIoqyeHJHOZ9116RH8yYkGz/FRSX3H/UpO9ysEZH+kjeSqv8yqY4JHgOpLSe+
         ImSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=S8bDBQgyZaLPm+0VWcliRekGCWsWt+wgexqvfjgQah1CJvXuWZlu7KfkHu8H++hAJ3
         kMZJhXrBG8vH8bZcH+CRrgioMe/kEtxM6ti1emxXDr43oL/dqnBSqbwfHTuY1rJurv7i
         KtVjOkHNa+H5wm/bvn12vibmBn6EqHzuhOiEU6+VpWYgqbYkEnnMqn0WW98hlTWbVrWL
         2dTJUrqJvrWP9iU1P/6yp0VmuEexwdzxVVkrQlbqr60m/xh48ZwMdffZ9WqgOz8liIFo
         +byVt+aS1ccLgFHps4daKQ9bza/FiUwzu8KaMeJq2Hs8ONfbo3jAm0O79+Ezjd8pjRDZ
         uDDg==
X-Gm-Message-State: AOAM533mg6mlmwdsywNhuVOZZFINnJL6naBLeZfNEnY30kFgImGXdI3n
        TLmb8pHj167iG/rtQ16AIxxKjW4m71uBzqfY
X-Google-Smtp-Source: ABdhPJxmLrmmDASJstRo/2KCDKvMBQHVy0057bKkTT092vW8BuOFIGmFiggTqBFdqjJhYV5p1hjv+w==
X-Received: by 2002:a63:ab45:: with SMTP id k5mr1468664pgp.240.1603254021167;
        Tue, 20 Oct 2020 21:20:21 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm545796pfl.22.2020.10.20.21.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 21:20:20 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Wed, 21 Oct 2020 12:20:04 +0800
Message-Id: <20201021042005.736568-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201021042005.736568-1-liuhangbin@gmail.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201021042005.736568-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on RFC7112, Section 6:

   IANA has added the following "Type 4 - Parameter Problem" message to
   the "Internet Control Message Protocol version 6 (ICMPv6) Parameters"
   registry:

      CODE     NAME/DESCRIPTION
       3       IPv6 First Fragment has incomplete IPv6 Header Chain

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/icmpv6.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index c1661febc2dc..0564fd7ccde4 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -138,6 +138,7 @@ struct icmp6hdr {
 #define ICMPV6_HDR_FIELD		0
 #define ICMPV6_UNK_NEXTHDR		1
 #define ICMPV6_UNK_OPTION		2
+#define ICMPV6_HDR_INCOMP		3
 
 /*
  *	constants for (set|get)sockopt
-- 
2.25.4

