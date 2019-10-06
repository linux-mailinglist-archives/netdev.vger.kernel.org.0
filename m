Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F42BCD8AE
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 20:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfJFSpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 14:45:22 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39025 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJFSpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 14:45:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so16132183qtb.6;
        Sun, 06 Oct 2019 11:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDtNMGd4vIkTEBG4VnbaIfDNYKUEZ4dNcxWAbUNY7uo=;
        b=MONqvAWV2NArFHCXriHQxTaQbsAXGUnRmgCUu0KX2YD7MqciBZlmnJpiG7T3dpIScw
         Mn6BbVydeTbNOp/4ICc1FILS5izg1W0wvsNf3f9QaRECvWj/fDOjTK6XhWWKutlZp8fv
         w84reqYic+PpIpn6EC7Y2/DufCRjpztwJYeXsy3baD78Jjs+3DfZu7CbAxeTlbG9SuZf
         hz/v2WFpSBkLGavhfZofgYx3ogLuymC43+RKur87RkrIs7QsxFlgSTdCEeRm2FVjkNOp
         Jn9AQDtAA/5QiE8cLZ1cVAlwuu01nU2cmG02pEPNkbxHPAt/sUvbZhDZ0wISfzHNMojq
         Xt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDtNMGd4vIkTEBG4VnbaIfDNYKUEZ4dNcxWAbUNY7uo=;
        b=fu9nHp2cwObLMpbdWjLpuu6geSEIW4SALWx4DwTF/X8PnsV4MbGUO46ax/AgtzOe0r
         JB2oNXB1WMQULsF8GLbkuWik2cEinsD0/CNSNJJV9ffFFxXi8UJV3X88TWIJ2eYBo72U
         CBNhiuI3g5qRa1ZGBBRTcsBGEHQn5cddMxqZgbdfOXZZvfGpuDgoY6cOGGr8vqvPwF3g
         w+rDLAlFrzKuK3L3UjObETnWlwbNrQuzVWNSprtqhyceL710c/ztvbN0dtNp4MrWYUr0
         CTgvRtGFbmRsYXijddtwhW0vpZlXtoxGuVhKwvVXxWIUIsEOxqMgEpDLHT7U2deN4a6y
         j0CA==
X-Gm-Message-State: APjAAAWuivZKwh+5PWNMpG9/skgYkp4vRjOeCV2GDJ5f+2lQzGCo01Po
        e1VGa0xtWZsgkOX0vVVWYRQm1FM/
X-Google-Smtp-Source: APXvYqzTgC0tNHX/1kg7nS97bMQhXuCqAxgVHWRofRl0lCE9xwQis8uTGV52SavGw0YEnwQZvl4PPQ==
X-Received: by 2002:ac8:5243:: with SMTP id y3mr26218021qtn.51.1570387520605;
        Sun, 06 Oct 2019 11:45:20 -0700 (PDT)
Received: from localhost.localdomain ([2804:431:c7cb:21c2:d505:73c7:4df5:8eac])
        by smtp.gmail.com with ESMTPSA id l23sm11275578qta.53.2019.10.06.11.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 11:45:19 -0700 (PDT)
From:   jcfaracco@gmail.com
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dnmendes76@gmail.com
Subject: [PATCH RFC net-next 0/2] drivers: net: virtio_net: Implement 
Date:   Sun,  6 Oct 2019 15:45:13 -0300
Message-Id: <20191006184515.23048-1-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julio Faracco <jcfaracco@gmail.com>

Driver virtio_net is not handling error events for TX provided by 
dev_watchdog. This event is reached when transmission queue is having 
problems to transmit packets. To enable it, driver should have 
.ndo_tx_timeout implemented. This serie has two commits:

In the past, we implemented a function to recover driver state when this
kind of event happens, but the structure was to complex for virtio_net
that moment. Alternativelly, this skeleton should be enough for now.

For further details, see thread:
https://lkml.org/lkml/2015/6/23/691

Patch 1/2:
  Add statistic field for TX timeout events.

Patch 2/2:
  Implement a skeleton function to debug TX timeout events.

Julio Faracco (2):
  drivers: net: virtio_net: Add tx_timeout stats field
  drivers: net: virtio_net: Add tx_timeout function

 drivers/net/virtio_net.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

-- 
2.21.0

