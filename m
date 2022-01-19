Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656944935D5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352199AbiASHxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:53:09 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55272
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352181AbiASHxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:53:07 -0500
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B7FFC3FFDE
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578785;
        bh=5w/EAxi3BWNa4bEEDcXXXFqwUZVzXL/jpIlNMT11cAw=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=loNBMorjQGultM2jhX+DevSvczJjc9pHvyw7LW99zlDSs4WbZtDdwv0xWDkwupPqN
         kNIVEYM3EXkxniRvQzAQOOjE1F0tBZy/XSDOxJk60+B5y26N0Z92VHGvCMFTg5cK3g
         s3MwhvFFizTLnZyXB1WPb4ABvZ+H08nvW1DP5FRrs5g8OlNmPe8HwU4revuDSpRxLu
         Oj2WHT+fEZzsTag1S4ii5LGCrzFZogKgOMJdQ3Zput2W175jdplFY94zTlfSlKbui+
         J4c3OLMlMczOIeqNT/IMCYgnXlMJGBho9slnZPJTGdkx64rvVrl0ZAof/WfBBelkG5
         qM6b3vdMMriIA==
Received: by mail-ed1-f70.google.com with SMTP id ej6-20020a056402368600b00402b6f12c3fso1501029edb.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:53:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5w/EAxi3BWNa4bEEDcXXXFqwUZVzXL/jpIlNMT11cAw=;
        b=lxbURvPb03A6F0GfkSRsEq39MKRqcCQBfJ9OCOM4YWjb8LSyd7jKvhB76ujuI6UgKB
         p07jtzMfZ/MRWfLSWDuFPnUte9CtlWvt9jjp/QOxU1s7ywLCtUHp79WIV6sUIvkob9Po
         7Yu5jYiKAJCbhSjWvawRKVDscr5kCVrhfcqErUjTz7Lq6qAEFhrOsFXpXXPTSh1DRhVh
         +epBbvP9N7MmlMQ6fZ4BhYPQqDrnwmhQIQLR+4LQhxOkHzKZpgd/knAYYymVDniWscx6
         fhcJLmklNh4Xa7WznCfIdKFnSpLpt723fDx9r0uYIt7EW8DqnNBq6r9BzzPuumOdR13M
         NXyA==
X-Gm-Message-State: AOAM530oT8jPokCAgVuUqtzXwwaMSG60TUWJrGTN0HzTkkJSWLOa7zp1
        fKegID5snKo71VhPZaDVW/sYRijvBr1eDH5PPZQRmBLMx7skhn+j4cCVF8pRSLTl+H4AWUxJRUF
        xayMmzug6yxw3A3sEnvz5lqj/e6FcdGk2ZQ==
X-Received: by 2002:a05:6402:4244:: with SMTP id g4mr6483609edb.271.1642578785493;
        Tue, 18 Jan 2022 23:53:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYUDYe5Iu0UOqAPwEgNesa55/g4cd+jnk3TlZFlICHhPfLFfLvKw8cfJ2BVa1of970eRb/Ng==
X-Received: by 2002:a05:6402:4244:: with SMTP id g4mr6483602edb.271.1642578785369;
        Tue, 18 Jan 2022 23:53:05 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id w17sm805286edr.68.2022.01.18.23.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:53:04 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] nfc: llcp: nullify llcp_sock->dev on connect() error paths
Date:   Wed, 19 Jan 2022 08:52:56 +0100
Message-Id: <20220119075301.7346-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
References: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nullify the llcp_sock->dev on llcp_sock_connect() error paths,
symmetrically to the code llcp_sock_bind().  The non-NULL value of
llcp_sock->dev is used in a few places to check whether the socket is
still valid.

There was no particular issue observed with missing NULL assignment in
connect() error path, however a similar case - in the bind() error path
- was triggereable.  That one was fixed in commit 4ac06a1e013c ("nfc:
fix NULL ptr dereference in llcp_sock_getname() after failed connect"),
so the change here seems logical as well.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 6cfd30fc0798..d951d4f0c87f 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -764,6 +764,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->local = NULL;
 
 put_dev:
+	llcp_sock->dev = NULL;
 	nfc_put_device(dev);
 
 error:
-- 
2.32.0

