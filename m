Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DBE29A2B0
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409425AbgJ0C3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:29:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37265 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgJ0C3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:29:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id b12so3330310plr.4
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 19:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=Fvk1+RopT4bt9psNDCRLQkVIPcgAzMnBEsXEUBiWC3WZnTXBrnP0jG+rz4ILPNwOg4
         mB/d5TSVq5P1D9mkCP8FL0cPm6svfmU8DLMpvQN6WR5tpWG1xdzDzNp3kU6AtI1/B8Pk
         vQ2OsRngpWhw+gL5aWxFGoLtoNzPh1IerCN4UrqK2Tjo1WmbWpMHxeaxLZ/pUfj2Mwjr
         bMRLKntQhrSa4k68viEFvfA6xzLdB3YgCGIRkNYYFfl+Rm/IULt8CZZlSua8hnl5elwC
         KBrGFw7ic70RvVId+IHyerax0S3+K3H64v6WxbDjgGji/zX7jpQTVgOB61JY+aXxPGrs
         7BQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxGRlL5LeTHpC2PaGOKhYJ+cD81YRHfTwaT5dBtJdNc=;
        b=lTgjs0HfPOHCuvsLBL8xbhlhtFT+jXwXnb4L7EXvAU6S2yg788sbZnAQisiD7IYGi6
         WLTRBGfZYG0s39RVolgZRc1hQi3D8uIkxkL70Ap4SGeIvanQ9BP3yL+NL9rnByYxw3dF
         cKyFB8jx1NZHMaGKp2Io1+ID67L5Jl+cfBMsOiA4Mxe2bzD/c86vpy3N0pwMFvdrMNdT
         JPHBvUgMFwAYoIn2q+MxLkJqi78XqaaoKcBOa6br9w/KaDJCUgVyf0T/urd2n/8ULTzH
         XSDgiaL7z1PVKDP/azvv/JIYwH+RFk2wY3aam3IknmTsLJWKiwKbgvOuO7q0JSnqPJJV
         PLHA==
X-Gm-Message-State: AOAM531SQYEVHf5tqccDowWraELoFFR/Xv9mo7rQ51JmP5uQcFYPpdtc
        D8+ZD7WevSM1pxv3122oL/CPEvs7nGHXCiZ8
X-Google-Smtp-Source: ABdhPJyOI/kgscYYGtYpa3ja3ucYcBdnlUfs7RJK50KOpqTYd8kWSxCOlMUmYIVsZLZGMLAi+qRzvg==
X-Received: by 2002:a17:902:a50a:b029:d4:da2d:c9a1 with SMTP id s10-20020a170902a50ab02900d4da2dc9a1mr212425plq.6.1603765743659;
        Mon, 26 Oct 2020 19:29:03 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o10sm5066131pgp.16.2020.10.26.19.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:29:03 -0700 (PDT)
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
Subject: [PATCHv5 net 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Tue, 27 Oct 2020 10:28:32 +0800
Message-Id: <20201027022833.3697522-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027022833.3697522-1-liuhangbin@gmail.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com>
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

