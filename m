Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62863CCEFB
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfJFGaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:30:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44225 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfJFGaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:30:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so11485337wrl.11
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 23:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UygFI4MLdppFKdTSHrxmjK3fsNxuAJsVArnjH4/x1xQ=;
        b=xK3xFa8WKiOeDBf2g0WDhjUdklhVpT/f1yvFXVV/5EQ35q/HzAGtstb4swJMje+hKo
         Jq86N5BvczrrjqBM2IwUFusozHfcE9fhPVXt+W6l3N072cjaTnMceG99XUTOFbdLsWBs
         De6CRz7FPo4y6uHUedJJxefA+gV7aGxv3uO5Y9Ofh9lFkpCx8/SAtgFe5en+Bb3yKEkm
         /GCqUBFpCiG1I94/qZ0vBUlRN1PdnJICMgBsRMjfPBXA13slrhKv/AQQ/eQ2E2AZyRQm
         0yvpIBJaJcK5YKBjCSxabEovi2A44/Et0XX3aSKnGOrINUSHLTaYsx9edlsubewCqdYM
         K38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UygFI4MLdppFKdTSHrxmjK3fsNxuAJsVArnjH4/x1xQ=;
        b=LHZlAw3jmieZp0odbLZ8YiivAyR4znfC7kLFP20f7Vd9hW3G9toQtVGuaU7yILLbLr
         SYM/VAAUZsADGp3mOk/z8iGKkgosmB8uTaP7qKFF/erQThwdeiLclrnCeqmq1QLPB7Xa
         CRcX7iy8Y+elDJSK+QTcVypT6y37I1J+0+k7fXdL4rneNrm9F6l0Xt+VlwNvw69F7zcH
         RAgdJbRGbzIFWG3xPe31C6zWHUKTatm5YSy0TmXd7+6TYaQJiT4XgAy34LF1+DT3yGhQ
         9rn2w/Bi8H1OhqBnBfD3NfF0dZZD0ON7UGY0vJAFtfuRS5ls/y3NX4oQgZQ0gLh269BV
         A61w==
X-Gm-Message-State: APjAAAVsnEHNiQrX39Hls6/tWFBjlOqmClU36v6CE5hz0V3dfW+qna03
        n28SXyCl0gRkU29gt1OW7mnLGckPcmQ=
X-Google-Smtp-Source: APXvYqxyQyS+ioS9PNiIrvbT0qo8uH6vg6GiLRKIIB9idufnsR7WcHbxfy/qqxEAfhu33GSstvy6vg==
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr17158423wrw.316.1570343405837;
        Sat, 05 Oct 2019 23:30:05 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u4sm19648431wmg.41.2019.10.05.23.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 23:30:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next 2/2] selftests: test netdevsim reload forbid and fail
Date:   Sun,  6 Oct 2019 08:30:02 +0200
Message-Id: <20191006063002.28860-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063002.28860-1-jiri@resnulli.us>
References: <20191006063002.28860-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend netdevsim reload test by simulation of failures.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 69af99bd562b..de3174431b8e 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -150,6 +150,30 @@ reload_test()
 	devlink dev reload $DL_HANDLE
 	check_err $? "Failed to reload"
 
+	echo "y"> $DEBUGFS_DIR/fail_reload
+	check_err $? "Failed to setup devlink reload to fail"
+
+	devlink dev reload $DL_HANDLE
+	check_fail $? "Unexpected success of devlink reload"
+
+	echo "n"> $DEBUGFS_DIR/fail_reload
+	check_err $? "Failed to setup devlink reload not to fail"
+
+	devlink dev reload $DL_HANDLE
+	check_err $? "Failed to reload after set not to fail"
+
+	echo "y"> $DEBUGFS_DIR/dont_allow_reload
+	check_err $? "Failed to forbid devlink reload"
+
+	devlink dev reload $DL_HANDLE
+	check_fail $? "Unexpected success of devlink reload"
+
+	echo "n"> $DEBUGFS_DIR/dont_allow_reload
+	check_err $? "Failed to re-enable devlink reload"
+
+	devlink dev reload $DL_HANDLE
+	check_err $? "Failed to reload after re-enable"
+
 	log_test "reload test"
 }
 
-- 
2.21.0

