Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA69C2C31
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 05:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbfJADDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 23:03:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41743 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfJADDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 23:03:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so8596601pgv.8
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 20:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=0WPYqV0B/gfwIaCE0d4GANtldUntKnP8s1zzJR/8g3U=;
        b=vFuoSZ+rwBAaZa50s9WeQ9qfk43j1ZURhpPLfYmu2PZbtv6SERvWeYzhDz0GpiILwy
         Mft0PV0oL20pbAK0aYCrXgiPLkqPBxGB+Fc1kZlek+/3NGPEZy/e2ifikyxBqy1JErsH
         9pz/YXYJG5X94mmpGG1tRHo+FlCXl1+ytHyoVt31HuLQ+VSlhznh+QYVy9Y6zqizhmxq
         5xs0f8VLEWGoJgba2AzvGR62d3kdRdOajs8AJ1x8cYo9eECyScO0HL8ZdX6x5iAQouvP
         XybMQHkM7kOlqexgVnn1yKmMKybq/V8cFjMheKi72Vi9KtrB74dq+JjlSeUNnd3D1Q5M
         EWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0WPYqV0B/gfwIaCE0d4GANtldUntKnP8s1zzJR/8g3U=;
        b=WYO/0lz3TkPVQp6sgcAMvvMVSZCRfb8P9C8cYHO+sdd5ZyANRWFCTnJQZufZ+Fkm+K
         kN7++f22cAzTtQ7nmKB31mYPn6qKaMJpim6ICLK+EulpcSuOxqf1Khj0XezNX0ObX3YB
         eXvkBrYEn20VvfCPdi1ALUXTutDd1uTX624q6ajDNgpsRbyyDcdBTs/mnhkTmixNxhe8
         MNTaYwuBjiAnAzUCgStA2LMHT4R/Yl4NtPWtrpyn2RUwoBImcW1+OZreC44b7xLmUNTf
         P0ZVbJGHFaRpMj5vZAVwEYVnHNOVHTS/mvhu+zST/3hCA1Rpm1uncc/3Rn4zVIvj0bAj
         vVLg==
X-Gm-Message-State: APjAAAVtFvyj3S2VxGeO3MiE5fzQnvAaHUe660iN3uYflZZ7AOId5Tmg
        C/hhqN14KMV0S5wPWo6NM5iIwHIcmjdmbA==
X-Google-Smtp-Source: APXvYqyjVNR9Qgg05+QKO70ePeiTaQzSGuwNDu2PiWWJdEETFrZCdy69vQvLnaqpLUWU++PG8Z260w==
X-Received: by 2002:a63:de12:: with SMTP id f18mr28436369pgg.453.1569899015274;
        Mon, 30 Sep 2019 20:03:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id y17sm14831062pfo.171.2019.09.30.20.03.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 20:03:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/5] ionic: driver updates
Date:   Mon, 30 Sep 2019 20:03:21 -0700
Message-Id: <20191001030326.29623-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are a few updates to clean up some code
issues and add an ethtool feature.

v3: drop the Fixes tags as they really aren't fixing bugs
    simplify ionic_lif_quiesce() as no return is necessary

v2: add cover letter
    edit a couple of patch descriptions for clarity
      and add Fixes: tags


Shannon Nelson (5):
  ionic: simplify returns in devlink info
  ionic: use wait_on_bit_lock() rather than open code
  ionic: report users coalesce request
  ionic: implement ethtool set-fec
  ionic: add lif_quiesce to wait for queue activity to stop

 .../ethernet/pensando/ionic/ionic_devlink.c   |   9 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 128 ++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  32 +++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  13 +-
 4 files changed, 119 insertions(+), 63 deletions(-)

-- 
2.17.1

