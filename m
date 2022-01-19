Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180C34935CB
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352182AbiASHs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:48:28 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55200
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352174AbiASHsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:48:22 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A458B3FFDD
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578501;
        bh=2jKKtwT8U2ZjS2owoIl90/o2oS9mRK8L4uaYNKpk42E=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=TF8CmseUqaUs2hMGop45/2iakC5MLrWhfALthmTdT85WPXPEE2tmq8EEWqVi584zN
         0O3ivI7lFNlJD7R8UAJN8OV2LhgoYv0KcNU+vHgsJ8IM1aK072TztcZDdk8jGPO+6J
         owyom0Ap1NjBFnoGV2Wjtu7MIUm7lGx4DVFkhrXn4JdALm2kjwviSd/5SahH/rBb8D
         nKc+wtW21L/rSngmhihfqUu/6xr7sbjV+NU50Zx/kgfw60/RToU8+Ec/pg8Z32IfWf
         cJzHMUvfjHrem+rMgPnYnC0PSd248L5Ndy8dewzk3fRCs883QgBgnTiM4fzg3OZSe5
         Rs1UH0Aq3J2jQ==
Received: by mail-ed1-f71.google.com with SMTP id ee53-20020a056402293500b004022f34edcbso1474739edb.11
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:48:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2jKKtwT8U2ZjS2owoIl90/o2oS9mRK8L4uaYNKpk42E=;
        b=qfX2QwIHfQ7lnr7IpnOJxxqa4Xldn8BzGA87g3Ka7QHC7JBrnDgvMiwiOF8HLCRBwu
         xMykxyi/5CaRR4IR5U8M8hXd4oi/XQ4zNnFf3pUDQzJ7u2+KIblPYZpPG2QPQA2na9JI
         5EE+4uWSSpQNkO7sVV1CoADp1blvMbsTK2RypMU34VAdrajkY2eNLmzDrikcpVZeOulC
         3y9tj4h3G066ts61qpVXQnLGEKA4oT3YGB6b03O++5lnjW5yyDp7okAF6eWuGLZSPCZF
         gM9h+eWeflgWRcwaUknb7eibxe1pJ6Mq3sg3EXAEu2fp0HdsdKb6fih1oJ+cKe8UUOgR
         CmGw==
X-Gm-Message-State: AOAM532EdQIeiJ6NjtNe7SORrKG2o7jdwI6VCdmkqQnN6xhQUyEg+12P
        Y9FUEygmtTrWW8ieEkVoQuldut706w7pBYY+KXCsiNhjx2l5Rqw0Tu78IbEuwZJXr7VksUkdwg0
        vo2c5ewGo/irDKurCZmVmsPH+OXflyTUHxA==
X-Received: by 2002:a17:906:6a26:: with SMTP id qw38mr25162757ejc.518.1642578501333;
        Tue, 18 Jan 2022 23:48:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBJJ+D+Tgq9B5aFBleb+XhTnMg8VYuhYEnYb09JDxdkPCu5o0uND7RGdYnhQeIZ0M9harBmQ==
X-Received: by 2002:a17:906:6a26:: with SMTP id qw38mr25162751ejc.518.1642578501194;
        Tue, 18 Jan 2022 23:48:21 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id zo4sm1104996ejb.143.2022.01.18.23.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:48:20 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] nfc: llcp: a fix after syzbot report
Date:   Wed, 19 Jan 2022 08:48:15 +0100
Message-Id: <20220119074816.6505-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Syzbot reported an easily reproducible NULL pointer dereference which I was
struggling to analyze:
https://syzkaller.appspot.com/bug?extid=7f23bcddf626e0593a39

Although direct fix is obvious, I could not actually find the exact race
condition scenario leading to it.  The patch fixes the issue - at least under
my QEMU - however all this code looks racy, so I have a feeling I am plumbing
one leak without fixing root cause.

Therefore I would appreciate some more thoughts on first commit.

Testing
=======
Under QEMU only. The NFC/LLCP code was not really tested on a device.

Best regards,
Krzysztof

Krzysztof Kozlowski (1):
  nfc: llcp: fix NULL error pointer dereference on sendmsg() after
    failed bind()

 net/nfc/llcp_sock.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.32.0

