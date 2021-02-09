Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D017315771
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhBIUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbhBITq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:46:58 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA508C061221
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 11:20:32 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e12so10317059pls.4
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svuB3J0qyDEvLP/pBhIZ5q1DZJvHJU3Hx0s6tZ8JwEg=;
        b=kFSMJDkDN4mYpLuxLZHdd7FMvIoCSJl2GQcmBRvZeVAqac8EnMCaqQqG306hIQWmNC
         uZVJbK1ElvGV4Qrrf483SV0dEPx13F4Bc3QQYP/5bevJQH0fjHdf26eY7jGuKPu68wzX
         DW9wT9toN3GEb04/2zFg0Xd5Vrw2L2K1P2ahUQvvZFUP8BtZy2kRCUqB8C7oyMOS6ilC
         RhdScG2tBM8QPaOT7RZV+rjBN/BJ1vDvKra73UgVMifhLEpMK7MYhWATwc5mNWA8SC/U
         SCme4zOlnp4oJyYR4wzbytEZEQ5BPBOQXMBfaPi8IwmafUAbj/Ru5j646nL78jjkbhe1
         ivZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svuB3J0qyDEvLP/pBhIZ5q1DZJvHJU3Hx0s6tZ8JwEg=;
        b=TuLmSWzLT7i3CKqPFnEffdog5mscWNYWHumfRlskdmHIX3n8ayGCCPyNCfzSAIKGwR
         Kvf/wrZjz5DSzS33Mo0R2urExn5OeGfppKnUn07Gv/CFathUPhmgyGrLdFNVAtgnjzn/
         YDb3hOxHsdM/xS+Pl9tYHuLwA0DPkgYtG9wmTaxNRxqn+l5xo+H9SdGVKhR8TJyVNW6V
         /ZE5yRZTWg+rb9m2yg8I5Y9NkvitVr5ssSwNvHBO15eJ4vLhJ+Q31BBZMKYpAHrFtqVl
         8+gV2s6cwy8mahsFn5junhrWhpqW5/P71a2V4yKyDgtEu1uMxmvcU+JV84G0vH9A+pa1
         Saxw==
X-Gm-Message-State: AOAM530S68jhfnvZkgpmauwtj7l/3FnJg7l0Nr90R3GILdef+G1S8mrz
        z+sbFWqrmF63Q+vdXuSLlN0=
X-Google-Smtp-Source: ABdhPJx4akDTdJvXLF4HsHR3twmUTdfeQzj0wnsYQbhBA3ZVsunX3+/DVTqfgQkos79A3SOdgEcexA==
X-Received: by 2002:a17:902:d691:b029:e1:561e:f8af with SMTP id v17-20020a170902d691b02900e1561ef8afmr22018753ply.23.1612898432472;
        Tue, 09 Feb 2021 11:20:32 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3965:c391:f1c0:1de0])
        by smtp.gmail.com with ESMTPSA id p12sm3252390pju.35.2021.02.09.11.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:20:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] tcp: RFC 6056 induced changes
Date:   Tue,  9 Feb 2021 11:20:26 -0800
Message-Id: <20210209192028.3350290-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This is based on a report from David Dworken.

First patch implements RFC 6056 3.3.4 proposal.

Second patch is adding a little bit of noise to make
attacker life a bit harder.

Eric Dumazet (2):
  tcp: change source port randomizarion at connect() time
  tcp: add some entropy in __inet_hash_connect()

 net/ipv4/inet_hashtables.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

