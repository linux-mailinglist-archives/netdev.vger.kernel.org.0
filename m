Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C920E4955CF
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377764AbiATVL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiATVL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:11:57 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F8AC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:11:57 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id l17so66235plg.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rdzWDkOZa1GqEA0mw6fDVxdAuPUcvHNtkFj+O4+6Uhg=;
        b=kYyMbiNA4SiC6nXQz7BMdze9Ry1b9h7q0RAMe9OnbwPEhfyqOxyk6+FhALmTUHZiit
         7FVUJmCNQBmDGByJgljK+E9lL+YU/hyZr1zyxSQdPKUYOP8RuVtDv2Oesp5anzy03zD0
         t9CnUeXbW8+AU/t9FRFWyLz3FqwNnKto8VbBXDfF3+A9/qmzkZjU2FCPe6zccchn9u5U
         hj+KU9o3+7BSHqoYkvQJqvAHpSKbgc2kb9MKkOaPtsgu6a0l9Sjqy/DHb4l+w2063JOn
         naWvmd8tFGt2rVsMvNYrm13sLwuPK7Ydi5zhg/29QaW+4BUs2WXOMMHMY/gRvIKX4wPQ
         BJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rdzWDkOZa1GqEA0mw6fDVxdAuPUcvHNtkFj+O4+6Uhg=;
        b=eIlxUI6Ab41A5aLTw2TOsP/BXxedjqRUK0QKogILhNmkZFg/g2OhKvULi8aO0YtJ/X
         T89++9SqWeGe0TcubiBTsofQXPB1z/oqviZ9ceqQ1zHq+lWm/g7vSRTUCIW42r4XX/QZ
         mUGbl0xohA3wAzqCERbhr+s8bNxjh7qi3WRk07mZfCQVyq5bWIfCUrc7i4pwRSPuua+N
         6pEU1nRH6L4IKUodVyjy62NlVi7KRNejpmLE5uHcKJKLMY3hUartuHXvgivxdzPC8vzY
         FsGL3PifyHPlzEByRMEoHIgJo0XejpocPGLLfwYn2XtV0sblUNsI5k9uF9ZLWSNU/VGi
         TsrA==
X-Gm-Message-State: AOAM533pfDFN8qO7Ikof9uQlrfdjd6R3uykmS+91Nm4/BqOBGpAuX+h2
        eL/rqZXGIL9zUd1cABsOntI8pwkwG7DJ2g==
X-Google-Smtp-Source: ABdhPJyEHZUV7TeAS+ZW3vnjMeRw5Qsv2+n0vchLgisBb9qn0edB/rSlWZSbB3xxHEjHItdujnaO7Q==
X-Received: by 2002:a17:90b:4ac6:: with SMTP id mh6mr1009243pjb.23.1642713116708;
        Thu, 20 Jan 2022 13:11:56 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:11:56 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 00/11] fix clang warnings
Date:   Thu, 20 Jan 2022 13:11:42 -0800
Message-Id: <20220120211153.189476-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes iproute2-next main branch compile without warnings
on Clang 11 (and probably later versions).

v4
  - fix indentation in masked_type with newline (ct action)

Stephen Hemminger (11):
  tc: add format attribute to tc_print_rate
  utils: add format attribute
  netem: fix clang warnings
  flower: fix clang warnings
  tc_util: fix clang warning in print_masked_type
  ipl2tp: fix clang warning
  can: fix clang warning
  tipc: fix clang warning about empty format string
  tunnel: fix clang warning
  libbpf: fix clang warning about format non-literal
  json_print: suppress clang format warning

 include/utils.h  |  4 +++-
 ip/ipl2tp.c      |  5 +++--
 ip/iplink_can.c  |  5 +++--
 ip/tunnel.c      |  9 +--------
 lib/bpf_libbpf.c |  6 ++++--
 lib/json_print.c |  8 ++++++++
 tc/f_flower.c    | 49 ++++++++++++++++++------------------------------
 tc/q_netem.c     | 33 +++++++++++++++++++-------------
 tc/tc_util.c     | 39 ++++++++++++++------------------------
 tipc/link.c      |  2 +-
 10 files changed, 75 insertions(+), 85 deletions(-)

-- 
2.30.2

