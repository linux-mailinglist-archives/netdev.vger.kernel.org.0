Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831D0357861
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhDGXUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDGXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7E8C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so305257pjb.4
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RDKvXTei1pem1yRM7hSwrZJnufPRKUPJqVbXBGTZUl8=;
        b=LjR7WDEmSLh9gWtsO3+dYNK6a+qS4F6Gj/5UYjUDxLtxLOitzIQAhCa0Ef5LPKLsPd
         qKEE+qIuCNQ5OSNvnM93mlJoKU7Mkhk9jbIJM/EZueBEUCiSL4yG6ZgwbxAJU3YyYOnM
         fvb8zVklWcpo6wNvTZeuKP7zoRjnBPLhLJ5cMnB3tfaioyA1XSSlpNB65/ks/D/r8wfl
         QSkgseeo7hThgEmUD7GeKk+hSEdK5ZQ0O85tTq+/7D1aiVQXVDXVozRAH+Bb7PN3JaNv
         SXLiGiEwKy2Bta2endsMNZs7XNuvd4dyNVT/ETVlQDXULylKUVflGZTRqKOIwwP6MgrK
         ruXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RDKvXTei1pem1yRM7hSwrZJnufPRKUPJqVbXBGTZUl8=;
        b=GjeXiGmydtoA3hoodcyHL0RdeoJPm1LSiVMKzi822xAUeMScsvpZrc+kSZwZi6wAsQ
         orR0ZFyDiE7LiSQiEhBx/ar4vwRZMe8+NVhkGR/7VTkJqZKMgj6pl72ZqlLcK/pz7xTE
         KGkDvN0qd2y+7bsHO/2PE0Mvfu6Vtb/biPaQt+qYzxewnPt16UGvof2fS7yEdagayPrJ
         XfFPVsio4iMgXs5FimYybpbqUAkgAtyFMv+q6DPuRnyxMkclxGvkwsr5H/4IZa7cHgZT
         iXMbqKUzo6l5gSniltSktQHjMPW6c3rgJWCLbohSL9ngIIN4Y9yuqj50IM6DTqsvNNiw
         vv1A==
X-Gm-Message-State: AOAM530UV3IDBoTnqA4Uu5m32lZbXGs55XsSSnxUhIRenVRnXF55lq14
        7xhGoIzuEe4U+FRHXv+RoQnSUQROkvXELg==
X-Google-Smtp-Source: ABdhPJzR+svvxB5AQwNgvy1M83myS8aCSh+62XrUfFWSdtjBoHXfL8nch+kXX6SyUuueBcZq2ODo0g==
X-Received: by 2002:a17:902:b188:b029:e8:bd90:3f99 with SMTP id s8-20020a170902b188b02900e8bd903f99mr5057781plr.6.1617837612020;
        Wed, 07 Apr 2021 16:20:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:11 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/8] ionic: hwstamp tweaks
Date:   Wed,  7 Apr 2021 16:19:53 -0700
Message-Id: <20210407232001.16670-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few little changes after review comments and
additional internal testing.

Shannon Nelson (8):
  ionic: fix up a couple of code style nits
  ionic: remove unnecessary compat ifdef
  ionic: check for valid tx_mode on SKBTX_HW_TSTAMP xmit
  ionic: add SKBTX_IN_PROGRESS
  ionic: re-start ptp after queues up
  ionic: ignore EBUSY on queue start
  ionic: add ts_config replay
  ionic: extend ts_config set locking

 .../net/ethernet/pensando/ionic/ionic_lif.c   |  18 ++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 ++
 .../net/ethernet/pensando/ionic/ionic_phc.c   | 102 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   3 +-
 4 files changed, 79 insertions(+), 50 deletions(-)

-- 
2.17.1

