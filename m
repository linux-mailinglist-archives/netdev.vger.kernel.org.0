Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B842969DC
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375343AbgJWGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgJWGoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 02:44:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82629C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:44:05 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j18so413275pfa.0
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=nS9r+oSC2xcgfKoigB2e/S0Y3edgHya6Rvm76Zi65uKx3lCpmgmi1F2hrBKahnvtSv
         JVt4A/yjRFBgr3u5D+ZpRaktchNAgyCi1dOp9ToQJ4JJrY8k5nsG19hwiRNHmoPUnYCD
         jbRNRu9CXUvPCFX8Yl7xMwFrfa90dOliVFgUwVHIyBBVKXMdQ6haL87cHsp+0jJgznbI
         D2iTr83MuYIQqGJb9ECTlVGqhuQkoeaYvouXWNhdkJjtrXzUy8AOcjvmXGlcfqaCxw0B
         Qlt9HGmEK5POOSGY+74zGgMqE9Ke9vbSN0UyFfBD5QiybUDftJFsGSQUIKtDk1Q2MQed
         w/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=pz+a/86wh+Au+8tK+PF4Q1/OHml0nS0XbWFzAdOpQlmBpoztppUMKxhUVSIk5NnJWw
         jRTzhv7gM2fGjPc/K5kAogUrunvFHArPsJ7chfv5sEXm8lD7IRxDVAgx7mD0lT2P2Qrj
         TR2d2tF+oeJDP4TdnOBOoNPJBVF+cZDNusbGtctlLnWtxsrVsWmEaBJqfO7mwl8wBPnu
         9szN5QSY6M+c5c8suFw2DPQleLY3xdt4BkwSm6aOLfxSpe78mluufHkHdX7viuiIHfX/
         KBadL1pB1LwyPvsbeqeKe6kurP/t+PLOdusvyODwop2qJDZLsWJ9xxLHkCzAUT4OAJ3o
         Xvsg==
X-Gm-Message-State: AOAM531NJy3LXastnhstC/x3gvwXSmEW70YE+q98HfwJXxVF2bj9Or5i
        DhFNQ/pQ+AlMAJ0WrH07vPJAqZ9lefUCoyxg
X-Google-Smtp-Source: ABdhPJztDM9A/nIPBX8J5F2UCCprhhcAoN0yhaULyxCDStnq8eps0vxBMWF5IUZftgWr2oesxVczBA==
X-Received: by 2002:a63:4702:: with SMTP id u2mr922819pga.111.1603435444975;
        Thu, 22 Oct 2020 23:44:04 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s23sm716088pgl.47.2020.10.22.23.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 23:44:04 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Fri, 23 Oct 2020 14:43:46 +0800
Message-Id: <20201023064347.206431-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201023064347.206431-1-liuhangbin@gmail.com>
References: <20201021042005.736568-1-liuhangbin@gmail.com>
 <20201023064347.206431-1-liuhangbin@gmail.com>
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

