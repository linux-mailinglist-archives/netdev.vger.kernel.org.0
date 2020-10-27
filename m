Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8260029AC29
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751302AbgJ0Mdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:33:39 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:32930 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbgJ0Mdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:33:38 -0400
Received: by mail-pl1-f177.google.com with SMTP id b19so688236pld.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=Q3276GBAWfh9Irj4Df5I+nUhtxk9sTEjmw1p4Rf0dk89UuuPjzAjVyhvtOj1CXBCT0
         f+NvB3M/jUEy4g1Hi2TYwQRM4ktUlcDffWH99AH/f8NszSTw9SxUyc8vXr/2OHoYOPLN
         iljnxzcXvu4OHIrRaEaNSJnm+1Vq6GMf0WqGt+ec2dvEDmdHc7pVcIh0GG8yrYc8b0LH
         3s/R5QNDI6fNKwlTIAp9bjxyso6pA5mfjMxgLNWd0N9YTZYOjCEENZT/6fn8eWe7vW/T
         U5azAbQ6sgd18AePcpreNeP1F4+T4PwtmBEVoQnbtXcMtYcaznmSkt6lV/RrpfgbOLuu
         r00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=ODycpp8olqquNKciKLvH9WhOCaqwjr+TmJFOzNTRmvT1jOXEwchzS7Rc9Th0d2Auua
         mMvxi6evULT974Q9Scdtjs8hj6dGjotIkDulWWGzONorhKlmXLfYAESbfiv0QrkF9SNj
         ddpvlOvjmIS5dni7YdMzqnnp+uibGN56r9z7Q9FqDUbadc1gCnu8Al1z3uZk5i4jt3AG
         W2xFm4sISphE1FADoiI2Dv4OqnkICZOEKQM1uKz93dpybmFK2eVz5KytG08lBbTyMWOY
         PVbg76CzcAvTCS4oImxKOm0DGeAJSu8Th0xZWLlRMVV+grsIW2jnErf0Je8ZQm3FSmfo
         XH7g==
X-Gm-Message-State: AOAM5307EXU4Aecw7Fyr5gViP6L5moRRWB3JidreR4gbprfBfIosnNWQ
        XJAZHViSe3fzaGptZZdztq/RjQ7zWopwKVlv
X-Google-Smtp-Source: ABdhPJz0KgeIUv4D8rb9J561MwcOm1ofeCmKMcyUmx3JBGyiWwhUEij1awxYrT5tR5z8pxXOCbw+4w==
X-Received: by 2002:a17:90a:ba8d:: with SMTP id t13mr1813342pjr.38.1603802017945;
        Tue, 27 Oct 2020 05:33:37 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q189sm2251231pfc.94.2020.10.27.05.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:33:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Georg Kohmann <geokohma@cisco.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv6 net 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Tue, 27 Oct 2020 20:33:12 +0800
Message-Id: <20201027123313.3717941-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027123313.3717941-1-liuhangbin@gmail.com>
References: <20201027022833.3697522-1-liuhangbin@gmail.com>
 <20201027123313.3717941-1-liuhangbin@gmail.com>
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

