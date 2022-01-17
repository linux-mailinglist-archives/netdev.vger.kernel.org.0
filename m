Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC03490FE0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiAQRuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241415AbiAQRuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:23 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E242EC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:22 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g2so11540439pgo.9
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJ7/cW7YDcQlg7xI+8KGBtkJ69SjRNUZ0EL4Qa1MnwU=;
        b=z3CFWGHv8aZxjGHsSqgda44/krnJUzd7C85RspvIYIcVIO50LJ9H5gLaQMMXNLRwb/
         ZJGc9LK859BVets4TdDH5lN/vofmpFsk+28EfGWqodvTV0+DKJx6yb0Nx8UG+meLdpQp
         F+vAl1kwMKoxst/cOhu3WAmMZWgu6n941pRqp3ilPIzP+ugKf6202Mf3gcjhH3uD9Z5L
         czS3e7Maucn5Ujo83SEzezH1f/nuBWTeZxHaYXEymr8OqqQePAuT0Jl62EIzdORnQAGI
         OPNrQctPUPIR8G6G1cxeBIEO3AYgoosATGHYfk1ZWwPfshi1pkFKW/cl01GcsNYNj45c
         PJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJ7/cW7YDcQlg7xI+8KGBtkJ69SjRNUZ0EL4Qa1MnwU=;
        b=nx0HbYm2E/hrV3fEVMEJAlqye38qb0/qCWYx1giwOBwIrLNxnNmXTIgtUnWxQfq4TR
         378IySQlQx65WzNhPajOs9qK5eSqlUpMTxnzk2022W9hzVw/EPpoJP/ZZ5OpnFmY/qWz
         pb460vG52v0UeFwAftfizF7bNw4PLf81Bt09cgiEaOeTnS/eQS5oGk4+VtibEu5Gj+xx
         wyp1tZzrbFuhXZOHMZaUcW/MrNyagnlwyjvBwU4b2xfaTLLkaVVSunHNW0X64rdDWej1
         EmFftMWeFU3OK8P5ZxBGOtAqts9hHzdGuQ8ME0IFa5BccdGEvxzXC/QTHweQ8hV6IHSc
         GMig==
X-Gm-Message-State: AOAM531Xt03o+psYOkblbneTPt0rqWMfjm1DQ7wbP3Tjop5kwQHuloZ7
        i78EkaGSkMYoV/RmD+LrooqFrD4VEo0+qA==
X-Google-Smtp-Source: ABdhPJw5GQ/qrDyUm2IyXS5mMgqBFyHXfPI9nY0SYzCxQsuXO03lXhIxs7XY+yNiy78Y2jWL1uXxyw==
X-Received: by 2002:a65:448a:: with SMTP id l10mr2580160pgq.385.1642441822059;
        Mon, 17 Jan 2022 09:50:22 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:21 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 00/11] fix clang warnings
Date:   Mon, 17 Jan 2022 09:50:08 -0800
Message-Id: <20220117175019.13993-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes iproute2-next main branch compile without warnings
on Clang 11 (and probably later versions).

v3
  - fix indentation in flower
  - simplify print_masked_type

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
 tc/tc_util.c     | 35 ++++++++++------------------------
 tipc/link.c      |  2 +-
 10 files changed, 71 insertions(+), 85 deletions(-)

-- 
2.30.2

