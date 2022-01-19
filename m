Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1884935D1
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352177AbiASHxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:53:06 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55264
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239511AbiASHxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:53:06 -0500
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2544C3FFDD
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578785;
        bh=yRTE0dXDieeLqipRcJqUM5emUc5L/qHhnbBmseJ0BJU=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=pd4xDR/8GT3KSmpV4CahRaySN8DSI5/Jt/JRkU1lnTln2ir2E9HaZYk4AlZgOp/jF
         Fo7ut7y1i023txHCLJXGaacm3RdrDKXCS8cTSVPPjGtkmmNnHFy8JrfpP+JI0AMSWz
         VYyy6b+mu0J3+rRj1nmm/m2gjMKUwG7Y4Cc5iBtMX+OOw25V+QoRXgJk0T06o/R4Yu
         RPr4yUqKcUq9kzwzgL/lvGu94j/m8qOrPyMHW1YNh4715hStcz6/pzxQZ1qUkUarKM
         rb8ihSS1E8zqdmnwsUxVGDa7ttaKta1VaYqbgYaInx/SRg1fmWMW34vFUdyMlWo9Lg
         YJ7BWAAM8ehdg==
Received: by mail-ed1-f69.google.com with SMTP id el8-20020a056402360800b00403bbdcef64so1470077edb.14
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:53:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yRTE0dXDieeLqipRcJqUM5emUc5L/qHhnbBmseJ0BJU=;
        b=z8ucV3rAtuK7/+qxEaGofW5B49bq+kv89acoDhaj05bzVbX3m4/Sb68U6PbP7/KsC0
         6jQ2KopEWNUaole57fe2xwAv3xe8mGmG0TB0tYQjwL7GoWAKIAQzKp/URlJ4zyf4P0Qb
         cORswfmPLCEBqyWn0I7o9wSGSTGUG8zgnT941PJTsPCUtOV3PEuFNSyyLbGKAYX+HK2o
         cmy3qlyQifVAJt8h/Fk1O9ZWoMZCfFZPrXygfAr/zpvFmHossOBr125ggQ307udHwU0z
         S6dnsoBFrmmsExMUG/2DGzpzQ9bi7AQ2BeQIzpYVmqWMlpzXcqaHEThNHrTpNgkPOcoR
         Icxw==
X-Gm-Message-State: AOAM533cUtDXmhK1dKlX+m10Lw1/iGYz28+bcF97gn+8W9n1fDFtOj78
        BcmWVf6CEQYu/OcLp6DLJ/fDn6f3cr1YusNriAGY3nWmZ8Ll8isDjXqh1Va5DzcGzFDPR2cV8q6
        k0F3YZkhwPq6vvBOdNRKM9SyZFdc8b8Hexw==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr28981892edb.83.1642578784391;
        Tue, 18 Jan 2022 23:53:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeJ973sell7ijTjlg0/rOOH2O7fjiphhNI7GxRSALdcgF4gRx3wFZOAIWZGt7K+MuWZVX4nA==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr28981884edb.83.1642578784265;
        Tue, 18 Jan 2022 23:53:04 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id w17sm805286edr.68.2022.01.18.23.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:53:03 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] nfc: llcp: few cleanups/improvements
Date:   Wed, 19 Jan 2022 08:52:55 +0100
Message-Id: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

These are improvements, not fixing any experienced issue, just looking correct
to me from the code point of view.

Changes since v1
================
1. Split from the fix.

Testing
=======
Under QEMU only. The NFC/LLCP code was not really tested on a device.

Best regards,
Krzysztof

Krzysztof Kozlowski (6):
  nfc: llcp: nullify llcp_sock->dev on connect() error paths
  nfc: llcp: simplify llcp_sock_connect() error paths
  nfc: llcp: use centralized exiting of bind on errors
  nfc: llcp: use test_bit()
  nfc: llcp: protect nfc_llcp_sock_unlink() calls
  nfc: llcp: Revert "NFC: Keep socket alive until the DISC PDU is
    actually sent"

 net/nfc/llcp.h      |  1 -
 net/nfc/llcp_core.c |  9 +--------
 net/nfc/llcp_sock.c | 49 ++++++++++++++++++++++-----------------------
 3 files changed, 25 insertions(+), 34 deletions(-)

-- 
2.32.0

