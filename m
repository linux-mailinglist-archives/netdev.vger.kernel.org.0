Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41E218EC32
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCVUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:40:37 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:35390 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVUkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 16:40:37 -0400
Received: by mail-pg1-f175.google.com with SMTP id 7so6088094pgr.2
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 13:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=CWuzFcqJV8Ls6188bHkyUnbjA6dvrGLM0dQLoMTDzjg=;
        b=gtyxbFyZaPs/2mmOSlwUdUWbdbgv/4swbIqgh+HN2QA0yBNbo2V3v8ruu1tMSbx7/q
         3aQpdZSM9xUIcMeMNp7i0NU41epTzIn3N7J+99BmqWue4KAZn3Fyk76VrPJBYKkcWLYl
         1/zvH/Qd/KxOrbG5GDHhpSExgOwhe6xAcUIik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CWuzFcqJV8Ls6188bHkyUnbjA6dvrGLM0dQLoMTDzjg=;
        b=efN1oZ0r/ihpJuzEYAh6cm78tLHFlYjfvxYOkww/27PMcEYwtCR9IeMWcCxxGVDQa5
         QAwRXWcErJu0VwN1lKL9XghyxMYgGenTni7faSwjrFn8+A0keswtLUlJm0iCW1EqbJ58
         3L9CjbQ9Qrj0JYRgoa4BQgtjkXYZl2K9yLKC2fl3ygPdeh8I1IzQTV8FpBcJoGk7ow0z
         zMAoILTwuVTQ9OfHlD4LU9MHHs4JtXVqRyfpQPCU/0Ajml530NjcxMk6GNCfglyX5J2R
         6qSbWOd84VP1Ltz3ase7cNOg4PY2/9FovNu4IqpsMtXtPpgYLmdgkRprgVMTgsUu4E2S
         lGwg==
X-Gm-Message-State: ANhLgQ2heB6EV4Jij7dEzR/NxyqtAtEQUsIhh+o+AUjwJAb7gGtTLC0e
        dlLtKdsj3Mih/v3nY3q/gUfjVbXWQ7A=
X-Google-Smtp-Source: ADFU+vuXj7kDUtZ8hfjAYQJ6wSo5AWoihbIAh21TdpCggiSUQ33pXk/d3oZ/uQgq/ePh8axf2729YQ==
X-Received: by 2002:a63:d143:: with SMTP id c3mr18323851pgj.171.1584909635695;
        Sun, 22 Mar 2020 13:40:35 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y131sm11575843pfb.78.2020.03.22.13.40.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:40:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/5] bnxt_en: Bug fixes.
Date:   Sun, 22 Mar 2020 16:40:00 -0400
Message-Id: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5 bug fix patches covering an indexing bug for priority counters, memory
leak when retrieving DCB ETS settings, error path return code, proper
disabling of PCI before freeing context memory, and proper ring accounting
in error path.

Please also apply these to -stable.  Thanks.

Edwin Peer (1):
  bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Michael Chan (3):
  bnxt_en: Fix Priority Bytes and Packets counters in ethtool -S.
  bnxt_en: Return error if bnxt_alloc_ctx_mem() fails.
  bnxt_en: Free context memory after disabling PCI in probe error path.

Vasundhara Volam (1):
  bnxt_en: Reset rings if ring reservation fails during open()

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 28 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     | 15 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  8 +++----
 4 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.5.1

