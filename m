Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD4298767
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 08:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769483AbgJZH3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 03:29:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34818 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769479AbgJZH3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 03:29:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id b3so2380423pfo.2
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 00:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=mDJ4hOA+W37wmIgLOMi6iutU3qfSC+w35VImgKLkW33nnEO2LqgUvDMsQ6tw6wEo7h
         QtVksyzltmeH1tGIl/RfzS4qapZgOrsfYg/Wn3Kfr9UYBnvOvlPRxNQhgQp7tOX0JoCT
         r/1QWQG1qJgWjV5NBr6WrDMLBOhi/Lx+aVI9Ro3Pc07wIc1hcbZlhDsI+3im/JVRMZw7
         ysDlkrAtl4fnZo3zFVMn7MHTBr8kRVdWcsh/ZnHTp0Ot6VI572jaX7E+oVaIKbiY7t9C
         SUEfmaB7qHknDa9BinqXXAmKUju4DVF8j/ewzvvbqC7Ap7A3V4q/bq8YhtAWWkXbJ1d7
         Y3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=VLeYHgb3SdeFu+wipgbfx8Hz2EkfQT0X2oPsf9pak8UMjz5X9GW/lwz9X8SX1NG6zy
         LCdufpVuogvqiigOo9U2FMecfSH2glv9JqZQup/SaDW5ecqMU70laslG5T6vVRiNRjXF
         bo0jJop6Af1OzeXej8hT6FQ33nmq2FIxPhVJOs3oYcad2+w93t2SSw6wwwcensygfTV6
         03fpg/WrZTK5zT7hxyjp5robe1JFZOS+UDxoIuOdHtwb270OKT/AsPNRgzj31TqTt8dC
         G5DN8cbzUZV3cj2SherHTg0EX5Kx9D669xlVSgsbbQXEAuVR3PDIVhLCZ3qJofSZabR7
         T76A==
X-Gm-Message-State: AOAM533ZJQ2T8ipBDQxzVd8ivzmX61A+K/dX3zvq7QgCHsAN5utVFTbS
        /00nSx5xTwsjpKcvviIU+wPbDjL99+oFjT2w
X-Google-Smtp-Source: ABdhPJwiaQLkrtVHEF3qrZiIDoJbwAvTVzB9Nqq+KPF253DtZQuk7KVJyRJlnGCuWJGY1SJ+I7MA8Q==
X-Received: by 2002:a63:190e:: with SMTP id z14mr12367359pgl.272.1603697388525;
        Mon, 26 Oct 2020 00:29:48 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v24sm9766547pgi.91.2020.10.26.00.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 00:29:47 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Mon, 26 Oct 2020 15:29:25 +0800
Message-Id: <20201026072926.3663480-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201026072926.3663480-1-liuhangbin@gmail.com>
References: <20201023064347.206431-1-liuhangbin@gmail.com>
 <20201026072926.3663480-1-liuhangbin@gmail.com>
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

