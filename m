Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD826C291F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfI3Vta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:49:30 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:34420 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfI3Vt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:49:29 -0400
Received: by mail-pf1-f175.google.com with SMTP id b128so6365683pfa.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=n0VKoMNEzRBnG9q8if4/Eg4i8Ye8IxcJxktl+EBShRw=;
        b=0BanTGNvkt33nhbrMxbCAXAA9lJYBtyae7NPaGpAI8+yYnuajh7c0ktot6Ml7+zL3V
         mo50k4GnV7OSz+xSIUG1QYlhhN0HZAfpEJ8u7aLNcNNePHhEwEXfKsTDiQZV42Ykg4DB
         PZuwsBKaevWVS9jyMp34ziGrNorVXbFtLRYW9z+gOewVUOa+lvf5JNIYBPMFF/olErZ8
         EQG4Rky+4dL3+cCqL/5DMfgUCIfMAWtP0MTHb7OYkz/WOmA9Wv0bIKD0qSSo/Uyp7qTg
         /tU7/iRGTHKivVmXI/aeu8vcon69YbwdoRaxMk0l/SWKSt2XsDgqbDZNRp0Hkv4Ktaav
         266Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n0VKoMNEzRBnG9q8if4/Eg4i8Ye8IxcJxktl+EBShRw=;
        b=ChKoYPyFlGqf+E7x+hljcir0ZfrzOJstQGBfKNlqlkpFZQzIT9MoJHCWczsoJwwmrI
         lbuFUdBtS2nS/imRaOCEQjKex852oJKAoGOeqQi+JHd8hqEZyyvnTPR9+kKvB4/RoU9t
         Ne5XvNvwTZjiZyYC2L//hssmVpnnlZSDYc1g8rMs8qzAj3daxFWdId1O+9nS9cZD4U03
         cyfmAJPaarNazO3d88AxeczTEGHhEt7763OwgkorQy7NUkaZw9B+QoI+7iycY9XNjT84
         +ZD3Mdabaj3PnRsp9Ve3TXL8uoItX1UdMGCqI02ezA2iolqQ7sOE6Jq96ZtD4cqpnL2I
         cIcQ==
X-Gm-Message-State: APjAAAX9uMO7EeZLRZhmFpR0oFo5ynzsvkY2nXAsJDHzI3cnc44VoiOc
        zAabYEar0CESrVL5k7RXtPN5/63x2x0k9w==
X-Google-Smtp-Source: APXvYqzkJwMEfCqR/ixxau9aOd4cx4eRcBs8CcqLrUY2CzUxAujBDQRJcx5MG7SzfqHILRenJWN2lQ==
X-Received: by 2002:a17:90a:db47:: with SMTP id u7mr1518968pjx.40.1569880168839;
        Mon, 30 Sep 2019 14:49:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm505746pjk.25.2019.09.30.14.49.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:49:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/5] ionic: driver updates
Date:   Mon, 30 Sep 2019 14:49:15 -0700
Message-Id: <20190930214920.18764-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are a few updates to clean up some code
issues and add an ethtool feature.

v2: add cover letter
    edit a couple of patch descriptions for clarity and add Fixes tags

Shannon Nelson (5):
  ionic: simplify returns in devlink info
  ionic: use wait_on_bit_lock() rather than open code
  ionic: report users coalesce request
  ionic: implement ethtool set-fec
  ionic: add lif_quiesce to wait for queue activity to stop

 .../ethernet/pensando/ionic/ionic_devlink.c   |   9 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 128 ++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  40 ++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  13 +-
 4 files changed, 127 insertions(+), 63 deletions(-)

-- 
2.17.1

