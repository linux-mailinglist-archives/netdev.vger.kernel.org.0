Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB86D368769
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhDVTsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVTsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:48:20 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED9DC06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:45 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id h15so12849639qvu.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oN4q7ehwS9vEsynXko5blTFrRBKf7xX+ZKDzmHnaRrQ=;
        b=bEhU7l5NjKfKAZ/HmYZC2Wjwl689G7odbEeZrNOgD/BxWYZAv2a97RDDuyhAKoZusL
         43xyXRBkfxPHvvwZatAEy9wjduh4a4AFWdbIW9xABxiYE0jfv1sqU6JZ5eHiHxuukWWw
         zFjEEh46Lr8iPLoY2N/nnoCBTxxssdaNBOq8rVAjkzYzmv4S/mKiQB+aA+KRwVt/zLaU
         69CuUZJoQ5yu9EgMMKfth49EmHXEV+IURvEtV6CySYPXEopU5TdUqZnPa+cDbBfDB9+s
         lB5aC+GqtxmQOSsr562UHT11XBCpQXyFCN0iWN8DfzhFrPDtjezAAf36Xa+06JGu+0tR
         9lIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oN4q7ehwS9vEsynXko5blTFrRBKf7xX+ZKDzmHnaRrQ=;
        b=YlOO6548PrmiDi/qX/MIZiRnyyzggDcA+7wmYqtP3KEaOAP8FoN6Ci+9CnXqTQL+S8
         +jwSpAHFVu9sMojaCTwJJmaKKifBCciH1iVHhu6Wvnkbjtg0sdWw800wjFJWRZuCSiKT
         VG2vBh/taXp3d1XQOKxl+O1X6OPH32pcbLG+xO4wvEK7D/A5V2eQHfQV6V1AqdE5eWsv
         9B+dIZwc8vvj3Ot/cgUrU7al37pjhaNXBAvv26X/mthcT4QwtNsyxnJyt/Kqz2PkODfK
         YaUi806JNC3YbCBF+YK7idIDdHmBLSmiWMqbUIF/49+hzDzERkG+KhBRzQVVgqLahkCw
         ozxw==
X-Gm-Message-State: AOAM533uS8eGpm1GF/ixrS2eQh1JunAsbDtH48GdXoCVth+VsFvUqUd3
        HqR+rZJhUy810l7dHZikqQ9GVcRVrlk=
X-Google-Smtp-Source: ABdhPJwVRijkQMb9kEU+5DumyM/n3OavNoELz52wBpk/9H8l4PHtye0j8AJeeuPoRAaxpr0Bkiz7mQ==
X-Received: by 2002:ad4:40d0:: with SMTP id x16mr272998qvp.48.1619120864566;
        Thu, 22 Apr 2021 12:47:44 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:e069:ac66:9dd7:6f76])
        by smtp.gmail.com with ESMTPSA id a4sm2821781qta.19.2021.04.22.12.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:47:44 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next 0/3] net: update netdev_rx_csum_fault() print dump only once
Date:   Thu, 22 Apr 2021 15:47:35 -0400
Message-Id: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First two patches implement DO_ONCE_LITE for non-fast-path "do once"
functionality. Third patch uses the feature in netdev_rx_csum_fault to
print dump only once.

Tanner Love (3):
  once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
  once: replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?
  net: update netdev_rx_csum_fault() print dump only once

 fs/xfs/xfs_message.h      | 13 +++----------
 include/asm-generic/bug.h | 37 +++++++------------------------------
 include/linux/once.h      | 16 ++++++++++++++++
 include/linux/printk.h    | 23 +++--------------------
 kernel/trace/trace.h      | 13 +++----------
 net/core/dev.c            | 10 +++++++---
 6 files changed, 39 insertions(+), 73 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

