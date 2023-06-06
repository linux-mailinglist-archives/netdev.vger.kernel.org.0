Return-Path: <netdev+bounces-8244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDDA6723411
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03DD128147A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA07364;
	Tue,  6 Jun 2023 00:34:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E09B7F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:34:58 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0D4EA;
	Mon,  5 Jun 2023 17:34:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-652699e72f7so2796259b3a.3;
        Mon, 05 Jun 2023 17:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686011697; x=1688603697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qp+N5Z7HA68i2uc1zJ9KQOBMaX5PlDLeZxmtZ6d/RCU=;
        b=Oo96+HWowncsesiFLPxlX0xq6yW4Zk79zzZ7+LX+3HNe0Is7+77laAytG9jp0OfM1h
         +bVnv2adG50bt/DBOP0lD9tiXlYXdMeF/afT/dc5rXq3zNSA4F64JRElPYkpgqjMvkdx
         mjpAWm00hnYHxfi65qjKIy5DiwPy2zsgmm8OEZ/pyjcxv4MPrdEqfdENI+QZefixyO21
         1vU3MWjpou2XtfCs0HjL8UcStJRQv+B6qKVeHzKy0zSeJptzAJR26aMgyM+0WzqbhQVV
         z02OqgbL+LvJRuPEIl2LSVieiF83vAYqgJUskciBNxfLeweFybOcDI0zHctVTY/DWfz6
         pwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686011697; x=1688603697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qp+N5Z7HA68i2uc1zJ9KQOBMaX5PlDLeZxmtZ6d/RCU=;
        b=cyNdV8oz8V+YUNkFP3drEwaU496q6OZH+eXg3hZwBXyOi3OJpWepqrn/AkMIxQNiI5
         Hhch9ZM+VAyZ3GOUXNXmHeRbVkuzvD1TMNmcq7ABWUS7ez44iVqSxJBiH4xts7Z3+tMN
         UMH1NS90cNpxiRcrWN5KUQ2vWEHKfVAfBj3JscCf2epFnXiSyTGPzYBW5H18KaXC5PDg
         FSBcj4W5VQJ3SP6PVEPpr/hbJ0FXMbOmqSRzmIFCLFdu+NqAupNShcW1b/xnw5wg4K8t
         do6hx70SRiDx4CXmKPblW6UrAoiyF1nIMZaD2gfXFSJlifHecsXGC2ZXY7dAp41N+OJ2
         ZRTw==
X-Gm-Message-State: AC+VfDzHBAakYnVusSmprC9zPwfxd1sJei897aeGx0BVVTlVyQYgKRpR
	+yrEQfJACn70p7cBYyEMOz6MIP4JO2E=
X-Google-Smtp-Source: ACHHUZ50Nt6IA+eBcUe1gfUoKw19GjghlBZdZfO5aeU4+bUKkYPMvch6Ee90qkdwq7nhr8kFtIx/zg==
X-Received: by 2002:a05:6a00:b81:b0:643:96e:666b with SMTP id g1-20020a056a000b8100b00643096e666bmr129388pfj.34.1686011696867;
        Mon, 05 Jun 2023 17:34:56 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id j4-20020aa79284000000b0063b8d21be5asm5894499pfa.147.2023.06.05.17.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 17:34:55 -0700 (PDT)
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: davem@davemloft.net,
	kuba@kernel.org
Cc: linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-06-05
Date: Mon,  5 Jun 2023 17:34:54 -0700
Message-Id: <20230606003454.2392552-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following changes since commit fb928170e32ebf4f983db7ea64901b1ea19ceadf:

  Merge branch 'mptcp-addr-adv-fixes' (2023-06-05 15:15:57 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-06-05

for you to fetch changes up to 75767213f3d9b97f63694d02260b6a49a2271876:

  Bluetooth: L2CAP: Add missing checks for invalid DCID (2023-06-05 17:24:14 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fixes to debugfs registration
 - Fix use-after-free in hci_remove_ltk/hci_remove_irk
 - Fixes to ISO channel support
 - Fix missing checks for invalid L2CAP DCID
 - Fix l2cap_disconnect_req deadlock
 - Add lock to protect HCI_UNREGISTER

----------------------------------------------------------------
Johan Hovold (2):
      Bluetooth: fix debugfs registration
      Bluetooth: hci_qca: fix debugfs registration

Luiz Augusto von Dentz (1):
      Bluetooth: Fix use-after-free in hci_remove_ltk/hci_remove_irk

Pauli Virtanen (4):
      Bluetooth: ISO: consider right CIS when removing CIG at cleanup
      Bluetooth: ISO: Fix CIG auto-allocation to select configurable CIG
      Bluetooth: ISO: don't try to remove CIG if there are bound CIS left
      Bluetooth: ISO: use correct CIS order in Set CIG Parameters event

Sungwoo Kim (1):
      Bluetooth: L2CAP: Add missing checks for invalid DCID

Ying Hsu (1):
      Bluetooth: Fix l2cap_disconnect_req deadlock

Zhengping Jiang (1):
      Bluetooth: hci_sync: add lock to protect HCI_UNREGISTER

 drivers/bluetooth/hci_qca.c      |  6 +++++-
 include/net/bluetooth/hci.h      |  1 +
 include/net/bluetooth/hci_core.h |  4 +++-
 net/bluetooth/hci_conn.c         | 22 ++++++++++++--------
 net/bluetooth/hci_core.c         | 10 +++++----
 net/bluetooth/hci_event.c        | 44 ++++++++++++++++++++++++----------------
 net/bluetooth/hci_sync.c         | 23 +++++++++++++++------
 net/bluetooth/l2cap_core.c       | 13 ++++++++++++
 8 files changed, 84 insertions(+), 39 deletions(-)

