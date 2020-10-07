Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969BE28576D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 05:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgJGDzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 23:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGDze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 23:55:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE61C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 20:55:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g9so530623pgh.8
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 20:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=BeRgE0MHCk+2xveRc74QLl7NzHM4lKwY8V6okTRupTI6+0DpjozCkLkDJtvP5HT86B
         uvi75j+H9pYTi6SvuIX7DhgyAQti3/D61Rvt6yNr3EQflJ9CoBVUSANE8FyNgJOMW5mM
         Qks91N0+Zr9oxG+fWCdFqBCf9F7qX0ZIg9LqCllLHgZOEacY0x063GBI/07Ib8FheT+M
         Tb1Vo0gjed5aaGVqp5R5finic7eB1vmMN1Tk4pswskbic74N/sYp4F41TEAXKDyHvo1a
         lc2/ySHtA3cAVSdbEt7Hrnffx4Q8VmJnHr7UoLhm0oLjcuDHqplHFD011w78zAcvmcHe
         keuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=UZFJXsFH0ipeEiuqKrrzBNZN4uD25+vAT4J40WBGU+Oka475plhJHvqmxcY9rMOvmM
         v/74auO/GhaF7MUOiiiNWZEAf9YIJxNu4UlqWzKxai+nMWb/yIb8VHXvl0kSUqSIy7O6
         O5w6Gr7Rs9RuZp6Ip38JtLdDbXYMvXWrHI6/MpiPNlJhtlQU0YyBip7Mw59kRlFnuOEP
         GCC4ZRy7h1TUPKsqo2dM5iW2pfD/tV/imG18ymNgqg3c9RoPsrkDZdjbn0geRH21+LDt
         Ke8bIQRlmCh/czFvbuifXCnyExjHmmp0twnnjYp9Mk3zyWzwEAD5S5bsWt6XnGMgvSNU
         Co2Q==
X-Gm-Message-State: AOAM533CmcMxHISRtCq+AX6vhC2FLtte/RQirPnwLwnYMHssIGitaOEm
        Z3koFLA4VR0r1uplG2vSkRj2pEvonw/whQ==
X-Google-Smtp-Source: ABdhPJx8n3EmVH/J9LXtur1/xcmWSpLtlXTXFBRMnm0/MVOXA7EthykuUoKRk60QoO6kfoZ6p5EahA==
X-Received: by 2002:aa7:94a4:0:b029:151:d786:d5c2 with SMTP id a4-20020aa794a40000b0290151d786d5c2mr1193156pfl.50.1602042934014;
        Tue, 06 Oct 2020 20:55:34 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12sm748246pgd.93.2020.10.06.20.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 20:55:33 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Wed,  7 Oct 2020 11:55:01 +0800
Message-Id: <20201007035502.3928521-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201007035502.3928521-1-liuhangbin@gmail.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
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

