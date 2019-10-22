Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C237E0D3E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbfJVUbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:31:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32912 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730635AbfJVUbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:31:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id k11so1209690pgt.0
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YtNLD2+CdUZz2MPvMLxUeWjU8ZEcI7pBfqpXmRfk7AI=;
        b=WtO6+z4azPmuT6GTrK3AmKmJ0YDB+5+DOtSj05BSnNQsGvwlX8i+6/HaTGTWIDRizM
         CoK9S6N+ia1yLGYWNS+fiyA8Vm5W024b5wNg/b//x5VytpH9U3PygErIr8cYoQ2l1XSl
         sB/A7IBm4oqfy5kPskZtfOebpB3CMCxND0iNnnqQ1d6BOAMc97ZJekHa3piYm4M18Fv0
         wJDSlX+XBL0QkFRoEKuBANjVUZBoxHPJo+Nywy+nCYtUQiBcuTe9SC4y+bKtIFzGgtYt
         tqCzqlkxRZHM9kjklFWh9tOvZgpwE0jrybxkORHbgKqjd/hu7AJgC71fDzGmkDtB2CXc
         Am1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YtNLD2+CdUZz2MPvMLxUeWjU8ZEcI7pBfqpXmRfk7AI=;
        b=YhGB6QWnminQ6xFQTXllCqSGwsGS5HMQBEYMelKlo5tNUvmeTAmyTTX+/jGuSgile4
         xy9Z/SCB0m+/gqeaq63niCzWT3+773XJplmP3ziERLes6Jfqm9/hSubbTdapsnuWXljr
         phij6HGsBd9cODveJvYm08K8SnSA//IAP/GuTNd9hOcpKH570Fg3wOS7GsbHMfAV4cSo
         aZVz1NRleD2ymY5jgRmSoAKw7XyVg/eNvRVBVCXqdQzgX+XzlCRRpJxcx0iyeY+qAGYg
         PAaULe6bA/w4OeenDwuihXBVFgLNn0SbaCTsT1IrxAYy5KH2URrbbtLZzVjsCu1U9Cnv
         twTA==
X-Gm-Message-State: APjAAAVPDtE8Us13zTM0HvHNdsM2tY1Is7TW1UHChW5XJa6E3eiwKe1K
        8nX/PoT+/t05P4S0wglpXiDDFN/bgagaQw==
X-Google-Smtp-Source: APXvYqzIFay82GEM018PSdL239D2tL16QWcFx0p1TXYtgSPmLJi1kq+8jFruGGx5e4jpDzj0dBzqMw==
X-Received: by 2002:a65:6811:: with SMTP id l17mr5765108pgt.434.1571776282446;
        Tue, 22 Oct 2019 13:31:22 -0700 (PDT)
Received: from driver-dev1.pensando.io.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q143sm20754530pfq.103.2019.10.22.13.31.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 13:31:21 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/6] ionic updates
Date:   Tue, 22 Oct 2019 13:31:07 -0700
Message-Id: <20191022203113.30015-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few of the driver updates we've been working on internally.
These clean up a few mismatched struct comments, add checking for dead
firmware, fix an initialization bug, and change the Rx buffer management.

These are based on net-next v5.4-rc3-709-g985fd98ab5cc.

Shannon Nelson (6):
  ionic: fix up struct name comments
  ionic: reverse an interrupt coalesce calculation
  ionic: add heartbeat check
  ionic: add a watchdog timer to monitor heartbeat
  ionic: implement support for rx sgl
  ionic: update driver version

 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  60 +++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  12 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 196 ++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  11 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  24 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 289 +++++++++++++-----
 7 files changed, 410 insertions(+), 186 deletions(-)

-- 
2.17.1

