Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7463CDADB
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfJGEKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:00 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33274 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJGEJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:09:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so11401782qkb.0
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nF2jDfppo2d6pvEKAH1G/mg1VyQuIkewZYHBPdBsofs=;
        b=oHP8JsJ6oSqCj1S9XNJP3CvfnVp6LkPp5MOAHrmbB3QwLr0e2LnWU7rnhvsaA8L+xX
         NxaxAkPFhJHch1TBl6rs4NWlmrB4NUfCld45fhAqIj+Mu9TaIgkNOuhaQABMcxP8F1vq
         2+Je8Ff8NHCDX0Y+oujMlzylYwgWgoj0xhM1T2FepLr867vipBVyYLPVDFKDF5T1uYPh
         TASFWmjQCLHiCjALdegXyE/j+T+EoNaHV8dx3LtNaxYFYhjjkZ7bqOlUYnVeSGZmJpfS
         0AJalEctgN/QNUWh6YGUvVKiYfzB3RGwV7rflP479O8zK5P+8YY4HtYDzzFV7oZ3n5j1
         O0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nF2jDfppo2d6pvEKAH1G/mg1VyQuIkewZYHBPdBsofs=;
        b=AmMM/Rgp92CKr+i++zLFoNvObGKSSEzcAPUPorjSSLP5JBttvh0VYq3VptEuiEX22N
         QBvBLU7mroAlxAQvG0kr6FKFKW/pP4eKLR7ZYsHhZbciL0JAdiGkTMPuv6lVfi1FPTJj
         IJtZbyt4pnN2kd0FsqAIFHNKFFFid0q4pcSyKmwSGWrDGiU23ZbCM9jCeGfTlw/6pvZm
         CCm2XEecIOJ/sRgLlmXQ0/CHGeJzyJRsVffUd/wIGXLmJ5Xwfo5UsaK23EPC0KCYy2RP
         N/JaP7Eqc+Jo5zM4RB5ZOLPNn/Xw14i3WTfSIqv8ZTorN2D2z9N/e3fOmvEbUfXkEA/5
         z9ig==
X-Gm-Message-State: APjAAAVeXu1PjXedL4WRAlZT2ev0VIbotpfyyT2TlSNdfoGr+LVlcoXF
        IF+DGf3oXXMcpHdGWDsLQvXHnw==
X-Google-Smtp-Source: APXvYqx0D/wTGKLMhpSnLX+X/v8z7LAN+WCN4ywQZq2cHFo8dpqkoG3mMkDNF7O4MEwVOfzIgqPTFA==
X-Received: by 2002:a37:4d02:: with SMTP id a2mr21894478qkb.63.1570421398890;
        Sun, 06 Oct 2019 21:09:58 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.09.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:09:58 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/6] net/tls: minor micro optimizations
Date:   Sun,  6 Oct 2019 21:09:26 -0700
Message-Id: <20191007040932.26395-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set brings a number of minor code changes from my tree which
don't have a noticeable impact on performance but seem reasonable
nonetheless.

First sk_msg_sg copy array is converted to a bitmap, zeroing that
structure takes a lot of time, hence we should try to keep it
small.

Next two conditions are marked as unlikely, GCC seemed to had
little trouble correctly reasoning about those.

Patch 4 adds parameters to tls_device_decrypted() to avoid
walking structures, as all callers already have the relevant
pointers.

Lastly two boolean members of TLS context structures are
converted to a bitfield.

Jakub Kicinski (6):
  net: sockmap: use bitmap for copy info
  net/tls: mark sk->err being set as unlikely
  net/tls: make allocation failure unlikely
  net/tls: pass context to tls_device_decrypted()
  net/tls: store async_capable on a single bit
  net/tls: store decrypted on a single bit

 include/linux/skmsg.h | 12 ++++++++----
 include/net/tls.h     | 13 ++++++++-----
 net/core/filter.c     |  4 ++--
 net/tls/tls_device.c  | 12 +++++-------
 net/tls/tls_sw.c      | 13 +++++++------
 5 files changed, 30 insertions(+), 24 deletions(-)

-- 
2.21.0

