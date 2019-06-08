Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3539FB6
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfFHMug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:50:36 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35992 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfFHMue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:50:34 -0400
Received: by mail-wm1-f42.google.com with SMTP id u8so4271954wmm.1
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 05:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hlCih0Ql28i40uIzvi3GAm97kcm7Flw3X0DygvueNwc=;
        b=hJ+yD9fPLSxKHDMcsctX1iowsr3IQXP3a+nRqmkmtrhR18UX/xiI1EgOPxBr3nsNAf
         HZAfpuYvLCUXqxDEqeCSd6TXpBt8pDJrCXxzDdayux60LsHRQGO+bbl/ozrEtbkon0Se
         Rn/yj53SEvr5x6EtJ4SuUWoeqfowqnZliFzBdceU3KBd9wFfctOzYtH/a+AmTylDL4xp
         A2KZP9XRxxHyESQKpeVRNE81ndHeS9rlUUuElQEcYugwl0/J/xNx572qV41QN0rLflBu
         XlAzYDFX2r2Bg5Al0Y+agb5eFN/EZ3zg5qleR6duuBnrEBT9keUQXl45sKdzojD454Oq
         cqXA==
X-Gm-Message-State: APjAAAV/239jEe8neBsMGdSlzRpA5omCPyzWqnK2gfEvQ8zdJaqfmcC8
        4suMc6f83wyABMSMEUJPp/KoS5gNBmk=
X-Google-Smtp-Source: APXvYqzpIby80Tewbtpb2LGh2fqIUOiyhotWBXo6dVznPVGxAbl/PSIblNHC6QHSlLTqyykJn5SDgg==
X-Received: by 2002:a7b:cc0d:: with SMTP id f13mr7694208wmh.1.1559998232908;
        Sat, 08 Jun 2019 05:50:32 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.vodafonedsl.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id d10sm7916279wrh.91.2019.06.08.05.50.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 08 Jun 2019 05:50:31 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        akpm@linux-foundation.org, Randy Dunlap <rdunlap@infradead.org>,
        David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH net] mpls: fix af_mpls dependencies
Date:   Sat,  8 Jun 2019 14:50:19 +0200
Message-Id: <20190608125019.417-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPLS routing code relies on sysctl to work, so let it select PROC_SYSCTL.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/mpls/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/Kconfig b/net/mpls/Kconfig
index d9391beea980..2b802a48d5a6 100644
--- a/net/mpls/Kconfig
+++ b/net/mpls/Kconfig
@@ -26,6 +26,7 @@ config NET_MPLS_GSO
 config MPLS_ROUTING
 	tristate "MPLS: routing support"
 	depends on NET_IP_TUNNEL || NET_IP_TUNNEL=n
+	select PROC_SYSCTL
 	---help---
 	 Add support for forwarding of mpls packets.
 
-- 
2.21.0

