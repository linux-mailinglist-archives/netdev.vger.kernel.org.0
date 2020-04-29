Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0CC1BE655
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgD2Shs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Shs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:37:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F65C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:37:48 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q124so1408841pgq.13
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=tOV4CwzBafgHV1LXQERoJbKn6moIlI3hdP7BkNbTSas=;
        b=orLLkVKNGuzi6w0UQaYAjiyy5oqjZmVHp7GfjS6k6dchfJCMUa/DzKoDfp3q6hLlFm
         PXunFoScGD3T7ubAUZTVEJ4RrTmx4zYge2UvQthRyi+q2OvjqigjLx9WBiDcHoBWHTBl
         qLsAb/StCBxquBm3CsIlxHP7EDkbwVLdIUcJeqHRhLZVvLcIMjqAI4DzsngKsA4vDrtw
         YygbFFae/SIqkfUjlIvXfLR8y8NDw41fcrZZCzSBou85e7d5aph5kA/+zgQh67zsmyVs
         pQ73bjC88M8il6DhHnQbFi5c8BXVLdrMaxbgfZ+bQyPxOrRjTWmigIEGmOWAXJunM4QO
         LJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tOV4CwzBafgHV1LXQERoJbKn6moIlI3hdP7BkNbTSas=;
        b=U+ahssQnxb1NWKqfTFq7FUuolEa7z/JsyTUKuZ4NAhiXuEzTStZitAS7Zgx8CNw/Pc
         b4JDDsVtLd+F8clXng13Wxly3lVPZ3WT37y5UQx0UAAGS5N9r4JvjJAfGqXW2MRMsTe6
         hdsY7cmma66bhJtDE9fSObeIKP84/ldPbntvA7GWqGgPLKZS48vXoJ94PW3XN3iCR8YQ
         r6ABoeAwHgtdg1sH03i4UVEHtGHhOOgtcC2zgUb60ctta6WfMJZNZ3ihc2g+zQAlXz56
         i4dr3Iow0i5N0sMpC9YbmQ1nSCrRxT5swSyo1M7Lz7VZfd9mZbOoJwk2LSCQ0n/4pKup
         qq6g==
X-Gm-Message-State: AGi0PuZ8/vOIafqrGQrS7DVIUk6eFbCiW8SuuklXtVrSrS6c7e1RXwd4
        Z9YBgZQkl9X5YezM+VVEsKe5ZW4cXDw=
X-Google-Smtp-Source: APiQypKFsdXI7PG6XEU7Rg0iu6/YGQPCBdkgGn6aVvnesdPSR2sobjGpfmwjc81ubfEEYOdtCuvwoA==
X-Received: by 2002:a63:5a5d:: with SMTP id k29mr15137817pgm.176.1588185467451;
        Wed, 29 Apr 2020 11:37:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g27sm1511190pgn.52.2020.04.29.11.37.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 11:37:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/2] ionic: fw upgrade bug fixes
Date:   Wed, 29 Apr 2020 11:37:37 -0700
Message-Id: <20200429183739.56540-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches address a couple of issues found in additional
fw-upgrade testing.

Shannon Nelson (2):
  ionic: add LIF_READY state to close probe-open race
  ionic: refresh devinfo after fw-upgrade

 drivers/net/ethernet/pensando/ionic/ionic_lif.c |  7 +++++++
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 11 +++++++++++
 2 files changed, 18 insertions(+)

-- 
2.17.1

