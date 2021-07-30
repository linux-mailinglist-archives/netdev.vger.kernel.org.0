Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891EA3DB40F
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbhG3G5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:57:08 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:55320
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237767AbhG3G5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:57:04 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id E717F3F228
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627628219;
        bh=VTZKLd4Cikiu9JLg7PgN5ojxKk/zgZVaneS8eoEANNg=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=blv0rcEmGWek80qxxIg+997a1WkFwDwK7d2eVUedS18yUdyUkDpTcSCImUanqfGic
         VB3ny/z1bleHHFMgZMiZtAzsH6juzBjVwOYmnD8TeyXWzUp86Zu3+oSUZ1V6nJhty0
         BOsxvQD4zKGHrYur7YDHvWcJHEgqLfwoymdyGMcUWwRv9tFBjyo8m316mAjd34RhJB
         a/sB7nPRA3yPDgGO5jBtLuHqWmjz++7lxclAEAmnErv/OPR8ogIp6vhyi6YPNTtrLC
         9pbzQwidCYgq+Yp1M5uLbIYampqdsdTSRvgjtsox1rNvRYjrfREe1CZBnuN8cabNbF
         488CCD7OA0oHw==
Received: by mail-ed1-f70.google.com with SMTP id j22-20020a50ed160000b02903ab03a06e86so4131250eds.14
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTZKLd4Cikiu9JLg7PgN5ojxKk/zgZVaneS8eoEANNg=;
        b=Deax0QTv6v1RQR8mG3dThEe9l6lzfvdnvh3MVbytUshBP+ebO+iHeSI3UKJP0Q6jLU
         3RanReZqs0r+TgqxnwGXWOtnMpd6pXAD4rwfR8yyxcHFxqXPPCvcGaUe8szXFD7TYzkw
         yiX2oN0rEL7JtYD6E1ZW70VjE4C8cbIyXT0c+eTSOebxH32KBGltGQz39WE7bMqnWqbJ
         CZfSdFuYWb1xqxEFM7EWfbXG4atBPXucNsG+ouU5a+2fZdpiE8hFQL8sXJptWj6V//Jo
         c9uqPbOMIhEIyPAwLmtgO1cgUfqigkhMVoHME3agz9G8sFfk3yqXSNWQdvJ0SzDBfya5
         EvxA==
X-Gm-Message-State: AOAM5306VXw3GKDFvgm1BconmhwRQsfQcWtK7+PPqyejt0ZAySlwUlab
        ex8FzhCz5NCjOzPxFph5AxRdmp0FieCa5AN357cgChEjOusDE87PBt/XCKOAbi8EZPUVCh+VkBa
        uelroLyfmCSue21ofMd9nwyvQaJkDW/jHLQ==
X-Received: by 2002:a17:906:b0c5:: with SMTP id bk5mr1155705ejb.428.1627628219716;
        Thu, 29 Jul 2021 23:56:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylZ3S3p6DxsgjZ/9cTB22EdT6oJK/+hQyLCw8aJEthyQhQ6wGtvZ2CpjES4B9CXlBatvmOMg==
X-Received: by 2002:a17:906:b0c5:: with SMTP id bk5mr1155697ejb.428.1627628219574;
        Thu, 29 Jul 2021 23:56:59 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id m9sm238518ejn.91.2021.07.29.23.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 23:56:59 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] nfc: hci: annotate nfc_llc_init() as __init
Date:   Fri, 30 Jul 2021 08:56:20 +0200
Message-Id: <20210730065625.34010-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nfc_llc_init() is used only in other __init annotated context.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/hci/llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/hci/llc.c b/net/nfc/hci/llc.c
index fc6b63de3462..2140f6724644 100644
--- a/net/nfc/hci/llc.c
+++ b/net/nfc/hci/llc.c
@@ -11,7 +11,7 @@
 
 static LIST_HEAD(llc_engines);
 
-int nfc_llc_init(void)
+int __init nfc_llc_init(void)
 {
 	int r;
 
-- 
2.27.0

