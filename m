Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE68E5D5
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 09:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfHOH6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 03:58:41 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39087 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbfHOH6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 03:58:41 -0400
Received: by mail-lf1-f67.google.com with SMTP id x3so1091558lfn.6
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 00:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZxYIVJXDl0DAiqdp8/QVOF+ggKcEMBtGLnHvtUKRSiU=;
        b=T0OEX7pfHxaxo4aOq3gWAKq/k0OH2V2V+0DlhgiT8Hrugb/ErCNRJlwXiF/Nr/oE/w
         4QYtPLkq3vH5b/AhdCSlkirEHFA5XypmeH9DrVATrPxXf/2iJ1FEHF4KhayWLtKLqt1Z
         okxEUthyOLkUCCJxiDwPdOgsa+jYUm0rwvb15ZWFrcAIW5BY08SehpOBA8iGpKfiYhLj
         qw5PevsY02PaqtX/tnUtCusfkEE2SkxjevazeUKUYxO1kcXuRl3MrRKHfdbMzWdCfycZ
         Nr0oJerFm+zm4wRsJ9JU+889w1msI+zFq7lHEvsyyfHNfdsJJEHWYzqYdY+CFIzD6VUl
         dbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZxYIVJXDl0DAiqdp8/QVOF+ggKcEMBtGLnHvtUKRSiU=;
        b=i+DgHTHpfA2Y2t768xEQNFY/F8i48xRqMsbKe79sro/W4UCSL9YKIBfUZgLtIay/lx
         z3ktdWkYvx2HPyrjka/f7/xy2o3VLA7tY6dNHY7a+fqDsuhHRFZGMF3WfDhvb0oHu/6s
         bG9FJrgDe07yc9XWvIvd91tVpsAA3SUFiCVLsLifZpgmziIx9mcWkPl556m+mh/LlaXr
         AWONIhMd6gdgHUc4PaTBeOQ8xVFP/8AhprExHD3F+iwth832AX4GRGhG1qfKv1ckltTA
         j1sqQ/1lRI38XT49yXosAusPQLGQlLHVnUDxyV1tEJaMtp2ema3ao2ZjTjAkhyzhAE2/
         e1hQ==
X-Gm-Message-State: APjAAAXTNndr6Nn+AA/KyHdE1oBL233pio0+RHMf0IsA2DXQ5vlFSLjL
        rN4fj1scnVjAFXcCTe5JRpoo5g==
X-Google-Smtp-Source: APXvYqxls4X1ddxQTHCuwIDVXDZ78NOkk+luCUq8TVbBFysydFKTl+4JYn40PZg7QDBcqHkKXP/y1A==
X-Received: by 2002:a19:9111:: with SMTP id t17mr1694958lfd.113.1565855918902;
        Thu, 15 Aug 2019 00:58:38 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id w8sm319257lfq.53.2019.08.15.00.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 00:58:38 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     davem@davemloft.net, shuah@kernel.org
Cc:     netdev@vger.kernel.org, tim.bird@sony.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH v2] selftests: net: tcp_fastopen_backup_key.sh: fix shellcheck issue
Date:   Thu, 15 Aug 2019 09:58:26 +0200
Message-Id: <20190815075826.13210-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running tcp_fastopen_backup_key.sh the following issue was seen in
a busybox environment.
./tcp_fastopen_backup_key.sh: line 33: [: -ne: unary operator expected

Shellcheck showed the following issue.
$ shellcheck tools/testing/selftests/net/tcp_fastopen_backup_key.sh

In tools/testing/selftests/net/tcp_fastopen_backup_key.sh line 33:
        if [ $val -ne 0 ]; then
             ^-- SC2086: Double quote to prevent globbing and word splitting.

Rework to do a string comparison instead.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/testing/selftests/net/tcp_fastopen_backup_key.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_fastopen_backup_key.sh b/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
index 41476399e184..f6e65674b83c 100755
--- a/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
+++ b/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
@@ -30,7 +30,7 @@ do_test() {
 	ip netns exec "${NETNS}" ./tcp_fastopen_backup_key "$1"
 	val=$(ip netns exec "${NETNS}" nstat -az | \
 		grep TcpExtTCPFastOpenPassiveFail | awk '{print $2}')
-	if [ $val -ne 0 ]; then
+	if [ "$val" != 0 ]; then
 		echo "FAIL: TcpExtTCPFastOpenPassiveFail non-zero"
 		return 1
 	fi
-- 
2.20.1

