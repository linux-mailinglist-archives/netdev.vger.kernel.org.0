Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E354A62C4
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiBARnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:43:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241629AbiBARnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643737389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3/onK8AnDtL53ai739ibWRR8ijRtGmfoRrTuaxLarqk=;
        b=SF9JG/qozJIozPGG4llfqz9spz84Ixdyg5zfJP4bv1wGLKOFSlrV1VT3ILCrbD9fw+W+0P
        /0U5GBEHL48mNe1iTKowGUJOomkXfF4SMn7TlUvfUI/GwhRcKdGpD3f2Y4EGPIUfRdHVvx
        m4D02imkRyBMMN4PcECEkjZwmbMIuV8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-xMBWWeCaM6SvI3_G3zM43w-1; Tue, 01 Feb 2022 12:43:08 -0500
X-MC-Unique: xMBWWeCaM6SvI3_G3zM43w-1
Received: by mail-qk1-f197.google.com with SMTP id k190-20020a37a1c7000000b0047d8a74b130so12680099qke.10
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 09:43:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3/onK8AnDtL53ai739ibWRR8ijRtGmfoRrTuaxLarqk=;
        b=7nixArZ0ZXZ4wOJqzbhB4S3whREMQsAjU8GTWxt8PxXJ8qnODM5uWYnkfnfWedj7gd
         auzuOeVL9gQelvj4uGaDBxJmx6q0/osa6C+0nNV6+a6M0I/pFknpK6pmVWyROWzgXRSt
         mfyq0eBIYudHhSLamfdlBMdFb2p12n+BtpIMyuqsYzKyK0tkxz8CaHearCrCrN6DhlBd
         I/5DAl8D4odzAZ2XYVBGrlaawjdoh3Ye0HWvFn8MklksVRca6PVSYDgYPpQkD9OElqGN
         +1okyYJU/RcnfGgoXbPzOVF4CEi/UGSAcVB0O0pWcYLqpAI/mTvt1JU5NJfWcNhBqxYD
         eAJQ==
X-Gm-Message-State: AOAM532lznCtp93RjGvGUUkCDoO4MqIQZ+S3g8EQsfzNeIClPsR/KtTn
        78IBwUUxCpkcJdk/r8ZMlhrejvbR0JStjGRZzNvhOYdfilYbU0DwN3YNX0NeNvaz16KBERAJGcd
        sBgOXstRAr/Ax9+5t
X-Received: by 2002:a05:622a:44b:: with SMTP id o11mr10694446qtx.507.1643737387527;
        Tue, 01 Feb 2022 09:43:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyADtOcufdtCgzPuWfrUXmKa/HFQ+qhMTdmjjxzdXxSj8ZJqSx+dyiOnLYrEWaALkPWKiqX+g==
X-Received: by 2002:a05:622a:44b:: with SMTP id o11mr10694429qtx.507.1643737387313;
        Tue, 01 Feb 2022 09:43:07 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id d17sm11962845qkn.84.2022.02.01.09.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 09:43:06 -0800 (PST)
From:   trix@redhat.com
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] Bluetooth: hci_sync: fix undefined return of hci_disconnect_all_sync()
Date:   Tue,  1 Feb 2022 09:42:56 -0800
Message-Id: <20220201174256.1690515-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem
hci_sync.c:4428:2: warning: Undefined or garbage value
  returned to caller
        return err;
        ^~~~~~~~~~

If there are no connections this function is a noop but
err is never set and a false error could be reported.
Return 0 as other hci_* functions do.

Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6e71aa6b6feae..9327737da6003 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4425,7 +4425,7 @@ static int hci_disconnect_all_sync(struct hci_dev *hdev, u8 reason)
 			return err;
 	}
 
-	return err;
+	return 0;
 }
 
 /* This function perform power off HCI command sequence as follows:
-- 
2.26.3

