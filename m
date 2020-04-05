Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B86B19EBA0
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgDENuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:50:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39279 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgDENuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:50:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so14176330wrt.6
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=ugj0qStQjxwhlh7AC+m2uRbshDnes64zovKmS8FSbDY=;
        b=o6p7jg4tiwvmGn/xREB4Kuyr4OxthL0AFCMUareESAaTlkuG+L6hcolMFY+8QJOg4E
         n6Xbto22m0zvjxbvbVQ0wVgcZfCzlAPqujdmGn2adoKafBb2Hf5P73eRRXGPaMg7daGl
         pWmKWzDfxICT49MlJajkrUMnJzDfIKKp5NRwMB0fMSa9mVNl8J9WIyPWG4diIMI3IlD7
         UtJOmJmnrWXlUc6z5bfqJIfsduLOYKUkDO3nJwN4q4K11vJ4Hum/MWOqwAaLTdBAZc98
         P1kbNdMt3pP5XzaX3iZE0RYupPlupGatQUVgRunlPcU0fFyup0EXoLYO6ZWxP7qgB/dn
         5Pmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=ugj0qStQjxwhlh7AC+m2uRbshDnes64zovKmS8FSbDY=;
        b=Tu2FHby6oG7BFsr5tvKVaWEUX2JlUl7ASr4MIHOi3FDyIniI7Ovalxz/kem3Rv0Sd2
         Y2aUSfWAha9Txxz1LfpLDsKJnP6DeP+Wxr9W1i861VBPFWEn6cttN+WG/Gp7GiuSkD5y
         U0L6jlX1PPIbxSBVhNxKIy03nXeeRaXxlsfdbDuLR1Z4luTZ1McKhuRG+ytpl5LPdDv2
         O/aqXU5/XVyGCYQAkKwSyE333Ti4gsWUibwcgrOql8WCaSCZjYmpM11F5exrDxqRH6J1
         w3/G/BWQBiATJ+XJfpIOqkSLt6o9eg4VZ/FVVXGaj1llP3UJKmb9tphdVYHMRpXGGIWu
         kpRQ==
X-Gm-Message-State: AGi0PuY+A3FL8F+ldnnXhF6t1BBqz8k/Y5HgBqBLhdwIe2Ls+JYU6Uu3
        wex/WLz8aByCVoqNkntDpA+PsdmF
X-Google-Smtp-Source: APiQypLRjeIvPtIC6uSIAWubz6YGAQtERQLO201GrwqKKt+R7EsaYr6RY9za4NA1FVz6diBIah+n+Q==
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr20624188wrt.149.1586094611188;
        Sun, 05 Apr 2020 06:50:11 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id t67sm20721362wmt.48.2020.04.05.06.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:50:10 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH iproute2 6/6] State of bridge STP port are now case insensitive
Date:   Sun,  5 Apr 2020 15:48:58 +0200
Message-Id: <20200405134859.57232-7-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve use experience

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 bridge/link.c     | 2 +-
 man/man8/bridge.8 | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index 074edf00..3bc7af20 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -378,7 +378,7 @@ static int brlink_modify(int argc, char **argv)
 			state = strtol(*argv, &endptr, 10);
 			if (!(**argv != '\0' && *endptr == '\0')) {
 				for (state = 0; state < nstates; state++)
-					if (strcmp(port_states[state], *argv) == 0)
+					if (strcasecmp(port_states[state], *argv) == 0)
 						break;
 				if (state == nstates) {
 					fprintf(stderr,
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 96ea4827..b7b85d1e 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -293,16 +293,16 @@ droot port selectio algorithms.
 
 .TP
 .BI state " STATE "
-the operation state of the port. Except state 0 (disabled),
+the operation state of the port. Except state 0 (disable STP),
 this is primarily used by user space STP/RSTP
-implementation. One may enter a lowercased port state name, or one of the
+implementation. One may enter port state name (case insensitive), or one of the
 numbers below. Negative inputs are ignored, and unrecognized names return an
 error.
 
 .B 0
-- port is in
+- port is in STP
 .B DISABLED
-state. Make this port completely inactive. This is also called
+state. Make this port completely inactive for STP. This is also called
 BPDU filter and could be used to disable STP on an untrusted port, like
 a leaf virtual devices.
 .sp
-- 
2.25.1

