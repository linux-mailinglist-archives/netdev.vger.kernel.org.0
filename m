Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55D88B56B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfHMKXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:23:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35644 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbfHMKXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:23:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id l14so11103250lje.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 03:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+vEsZUSwAdb3YjNql7rDM4PtC51lwjYe4ypkHR8meNg=;
        b=Oz80OPwmh9X4xSAJ07288MD1guPoiHr5QzEzTKNgbbW0yOVRUE+9R2dtHoUBEsUqOh
         jfyncogTYoy1qjVIr3i7veHJPy5PAhWPX4InfS2/fcPCxjXha0LkuDHcKVMFu/h35tBF
         7OvwwIzhLUNCmRZq/09ERQQedSeX9zk0DwXKJqoVegM8JC2G32PctQ3IReLpRJ+mKVDp
         HiwFTs8BXBnbAWsMmIx81qOWKhLfmDGGrY8SLnzwyu36w01+Ny16cUGqE8QmnsU/i0X2
         R5hxQLuB3m6D1bKOaEPLUABe02nOxqEFSg8c9rBfkb0AJAgNkW5LPsYVtb/aWMtMnCFx
         +XsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+vEsZUSwAdb3YjNql7rDM4PtC51lwjYe4ypkHR8meNg=;
        b=W6as7wsIjJPmoCD2yoEo/Kv64xTd7F1qBxedqlQ7Fd3lWmekbZVm06L0HnpPgWn4z2
         0QErONA+6e3rMud3afL9g9ur5Ee87bKCwtw0iJ3QjooW3D6iaiPTwhhpv2S1dXI4/XQS
         Z8TJqiTxp7Dp/ohfNgmMNi8Uwa/9WstZQynOB8lzR1bmGovFJwyVrOTjeODHqZtrWR/c
         tE3hQ7gknHS8L0LU2pQ0MOAZ4sT1SNPvfQgIqjN95gfpBlN8aPTTHy7yWmzHgx7KKpvb
         K6nrymYDuN/VcEv2+YrqZAPM3J1RhbRzfPV5uV754AeUW1tZS4Z8D2mn8eoktbucmtKv
         Hunw==
X-Gm-Message-State: APjAAAWWZNxrEZdi3c23cHNL3a8Wq42eRFnpTdi8Io1RNjPGnHsdvzkr
        827lEtvIFCn3doTubsYZ2eu+JA==
X-Google-Smtp-Source: APXvYqxfBIXDeO0fClkXCBT9GDNG7S0f2BKB42eF07OqmwBW8EB8GoIyGDNisQVq/AUlsE7V5UoY4g==
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr21649917ljj.34.1565691827242;
        Tue, 13 Aug 2019 03:23:47 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id e87sm24796942ljf.54.2019.08.13.03.23.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 03:23:46 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc:     davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get __NR_mmap2
Date:   Tue, 13 Aug 2019 13:23:16 +0300
Message-Id: <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's needed to get __NR_mmap2 when mmap2 syscall is used.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5007b5d4fd2c..f2fc40f9804c 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <asm/unistd.h>
 #include <arpa/inet.h>
 #include <asm/barrier.h>
 #include <linux/compiler.h>
-- 
2.17.1

