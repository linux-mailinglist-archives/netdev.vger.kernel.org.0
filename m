Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1FD83E39
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfHGATj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:19:39 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44968 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfHGATi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:19:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so55516685qtg.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 17:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XRsl0hq2sktvUUN9RQLQt4ElBo/nkveeqhoqozaDdMo=;
        b=VHrmh+0FfYFYc6ASAFpV7lz0e8zO3xo2Tq93z3rFxeI4Au+N2uZtex27qAugn+0/cu
         mJCL/LnxBTnXsWILME5J0RoLjLEo4UBTOUDsnenYLXq55xPjcv6vBXhjI9Zq66atPW9h
         2zKmkOIrCV7bJ3lqorVGlSnkAHA5UCUfzbSTEdpL1+bHeMMkrSDN4+pN6/Ta0WjsC1ry
         OhDVg2sSz7HS+7BOTOKqm9I/wPta3XtzYrnfkSCTog0HmC4jdhEzV7u/+o5EFQRNqyno
         6lCzl/bRsL40AcQ35EZAfPbMsHHVZyRhsmbik9RzaTLMNyfjMuhUg90dwKApeFL32ii5
         vNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XRsl0hq2sktvUUN9RQLQt4ElBo/nkveeqhoqozaDdMo=;
        b=MmMLkxZQo0ErR7lunXyMohAoozAdrFvEuyV2oG+WgNuJ/U5dFdjDK6TncH/8wzDd9L
         iyBJwCXB1IKRagjKWFXH7o4waw2ttU/guvVT3cNHmO+lUDseNWeqCA3ECNCYHKPyRoDF
         jSSmOwUZEEuJG/Gl6+ynXOUedW6vY5vd5afk7qhvzMLYnTenH6s/GviycNu5V1XQr7/n
         QZeJ7R5SMgNPR5+Z4mcA61iWSVdmecBfL574H+NgKluurq5lvPr7PFfBcYmplAbCOYgL
         LTtaW0FF0WhUXhCxteGov6xlnMHk1tSE2z6WosIBIGq7RJ9OJuwSPeYrSpX36KnrV9Wx
         WS3w==
X-Gm-Message-State: APjAAAVEfEeTYGochFnCUthQBZLXzVbf9wjeZiZ70UrlaaIt+VTxmBW/
        t/ayQUZ/BOyAC5DYVZgPRG0AxQ==
X-Google-Smtp-Source: APXvYqy+VIxlXwV7g6+hU7VMi8uG8VheY3mhYYyLOi623igKtv3BlH0t3hHGqSYpq1nfGFQKKe71jQ==
X-Received: by 2002:a0c:99e6:: with SMTP id y38mr5717677qve.42.1565137177343;
        Tue, 06 Aug 2019 17:19:37 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i5sm35547554qtp.20.2019.08.06.17.19.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 17:19:36 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Lutomirski <luto@kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 2/2] tools: bpftool: add error message on pin failure
Date:   Tue,  6 Aug 2019 17:19:23 -0700
Message-Id: <20190807001923.19483-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190807001923.19483-1-jakub.kicinski@netronome.com>
References: <20190807001923.19483-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No error message is currently printed if the pin syscall
itself fails. It got lost in the loadall refactoring.

Fixes: 77380998d91d ("bpftool: add loadall command")
Reported-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
CC: luto@kernel.org, sdf@google.com

 tools/bpf/bpftool/common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index c52a6ffb8949..6a71324be628 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -204,7 +204,11 @@ int do_pin_fd(int fd, const char *name)
 	if (err)
 		return err;
 
-	return bpf_obj_pin(fd, name);
+	err = bpf_obj_pin(fd, name);
+	if (err)
+		p_err("can't pin the object (%s): %s", name, strerror(errno));
+
+	return err;
 }
 
 int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32))
-- 
2.21.0

