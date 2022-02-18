Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EB14BC302
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 00:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbiBRXqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 18:46:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiBRXp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 18:45:57 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7E822BDC3
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:45:40 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d187so3552377pfa.10
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R9dcpe70j9Trk9rKuKWmAu1MvnVHF87exvDoWtSGUqM=;
        b=izfsjtjHsgBrGj/HgT+90+NGOW2SCpYve/CDRyzzE70F6IiYAYgdiBY9Xw1PDE0KWf
         ArV6JKEbQN0Q3oA4CgY3P/VpkjT9tX0KpoeF3z5Blvi5LIRuoQzzGX7H4goP158WmnGk
         jjSomPs3lUieIujKxjUxu6WammqpqRRnCt07Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R9dcpe70j9Trk9rKuKWmAu1MvnVHF87exvDoWtSGUqM=;
        b=LMYZm8LcxcPktwxu+v0j0ISbM4iHn2uIdaj7xCb4/7Hia1H+D2BZC+8T/WZ4LLes6Y
         xPeI1CzAUAmmuqKb9jzfxuxyZiCofPsAd2SDuXECFg9UlUKqo+gW5uBBF3ZQdmOSyd3j
         IrxXFhcMstbNWW4yHj8JUkDBL1VfD9ln1JoCShSuctGrxCSJ9CPj+F0pIqVhnYPkGZ2r
         X9bLSNVrt67vYdRoYkUB2MrN8tdBttGTh3Fi9BgYCqmdcBghG4e8ljTybL+Qq85XppD1
         rAY0/xoyEATcHAt0eUjEDlPVow6DnEOSfDThwAW7FsLfyA2YjyMJgQ8VEjPY2sDj0a3X
         J7/A==
X-Gm-Message-State: AOAM533PWSXWEhzHfOXwrAr3d30ePa9nvcYCfSDKoQbJxzhtniYckLMW
        3lBBlP1wqZMbUaRjFmxkd8uk9w==
X-Google-Smtp-Source: ABdhPJz4KxX9mxNmepaO9xMZbFoCSrG8byaEdenOFOn0ok+SuAUAeN5YAmCL3GDwMicfMNUldsgRgg==
X-Received: by 2002:a62:1881:0:b0:4e0:1b4c:36f8 with SMTP id 123-20020a621881000000b004e01b4c36f8mr10156028pfy.26.1645227940283;
        Fri, 18 Feb 2022 15:45:40 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id g126sm11723406pgc.31.2022.02.18.15.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:45:39 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH net-next v7 1/8] PCI: Add Fungible Vendor ID to pci_ids.h
Date:   Fri, 18 Feb 2022 15:45:29 -0800
Message-Id: <20220218234536.9810-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220218234536.9810-1-dmichail@fungible.com>
References: <20220218234536.9810-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index aad54c666407..c7e6f2043c7d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2561,6 +2561,8 @@
 
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
+#define PCI_VENDOR_ID_FUNGIBLE		0x1dad
+
 #define PCI_VENDOR_ID_HXT		0x1dbf
 
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
-- 
2.25.1

