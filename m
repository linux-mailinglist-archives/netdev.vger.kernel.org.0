Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FF1ECC29
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfKBAM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:12:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44596 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727966AbfKBAM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 20:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572653548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=24Z5Dmk2W6pqkfE5O4Ag7+iuU/YlK1vTn8paqS2R4cA=;
        b=fJ4QgPWYsLmkBJLqCxu+I7rXRHvVGyIOJ7EihpXPKOFWAZpUpb3IzY416x+buvremjHLbI
        WTyjS3o4S7ZiYdkWL/9mndZmZWl26nO1/6FQv12tOMg5lZT44O3P6ZUTeqHNNWyBGdv1/0
        IYo4kICdt87tzBlh+qQOk7DqMfX49+c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-O5ZseZpOP1-HzwlPXbGNnw-1; Fri, 01 Nov 2019 20:12:26 -0400
Received: by mail-wr1-f70.google.com with SMTP id m17so6455035wrb.20
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 17:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=imZgvp23lfZ+nv681BvgXkR6J3pvu0v66299B/OZGnI=;
        b=AIZYNz7SAOb6uQcvr8A6+moRbJ4yFIpPJT3iFHlqQEEO4jTJJJ3pM2kV0avlUGD1gI
         yHoRADGIiF0mC5FmnpZ4QWMOSEUM0aY5tUfZx8QRbMJMqY8u0JYfWRhwFyvtXpuHvXsl
         D+cMweTUPFOdFoh7ag1SCN42/5Tv22gx7qap9veCh1uwFN3nxtVlGlYfAEPSDbyGgxJU
         KadyNtkgid4Rp8v1PNGi7kdcEGLrRqTG0GXQS0i+zwDkAID5OoPq6AjbCbQ2quUR/O+f
         IrVmwZPpCAG2huJh4U7bAbPCPa6txN/TRE8k8hLRSGSXS98UiWDU3yLm59p9KTsP0Wz8
         UKFw==
X-Gm-Message-State: APjAAAWqIssQ+YsPtfpqD9Ls30PRdfO3Pk9TV8cdvDBP1jyArH+qekgQ
        sm5w2Cukrps5aCzBzD6cOSp4rkqLI0Ob4YNWKj3bVtqvMr05qnJhmvAVKUKvR/GOXUjmlBJqG0w
        7CslJagI5oghMEIoo
X-Received: by 2002:a05:6000:350:: with SMTP id e16mr13725130wre.276.1572653544509;
        Fri, 01 Nov 2019 17:12:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzrrgm+aZgrekUoxbZhWGa28h831L3PmKrlzPbLge7raoNp6P+19vb+UswK4a+j1f1IkqU1Bg==
X-Received: by 2002:a05:6000:350:: with SMTP id e16mr13725109wre.276.1572653544302;
        Fri, 01 Nov 2019 17:12:24 -0700 (PDT)
Received: from raver.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id z189sm13915168wmc.25.2019.11.01.17.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:12:23 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] icmp: add helpers to recognize ICMP error packets
Date:   Sat,  2 Nov 2019 01:12:03 +0100
Message-Id: <20191102001204.83883-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191102001204.83883-1-mcroce@redhat.com>
References: <20191102001204.83883-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: O5ZseZpOP1-HzwlPXbGNnw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two helper functions, one for IPv4 and one for IPv6, to recognize
the ICMP packets which are error responses.
This packets are special because they have as payload the original
header of the packet which generated it (RFC 792 says at least 8 bytes,
but Linux actually includes much more than that).

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/linux/icmp.h   | 15 +++++++++++++++
 include/linux/icmpv6.h | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 2d8aaf7d4b9e..81ca84ce3119 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -20,4 +20,19 @@ static inline struct icmphdr *icmp_hdr(const struct sk_b=
uff *skb)
 {
 =09return (struct icmphdr *)skb_transport_header(skb);
 }
+
+static inline bool icmp_is_err(int type)
+{
+=09switch (type) {
+=09case ICMP_DEST_UNREACH:
+=09case ICMP_SOURCE_QUENCH:
+=09case ICMP_REDIRECT:
+=09case ICMP_TIME_EXCEEDED:
+=09case ICMP_PARAMETERPROB:
+=09=09return true;
+=09}
+
+=09return false;
+}
+
 #endif=09/* _LINUX_ICMP_H */
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index a8f888976137..ef1cbb5f454f 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -46,4 +46,18 @@ extern void=09=09=09=09icmpv6_flow_init(struct sock *sk,
 =09=09=09=09=09=09=09 const struct in6_addr *saddr,
 =09=09=09=09=09=09=09 const struct in6_addr *daddr,
 =09=09=09=09=09=09=09 int oif);
+
+static inline bool icmpv6_is_err(int type)
+{
+=09switch (type) {
+=09case ICMPV6_DEST_UNREACH:
+=09case ICMPV6_PKT_TOOBIG:
+=09case ICMPV6_TIME_EXCEED:
+=09case ICMPV6_PARAMPROB:
+=09=09return true;
+=09}
+
+=09return false;
+}
+
 #endif
--=20
2.23.0

