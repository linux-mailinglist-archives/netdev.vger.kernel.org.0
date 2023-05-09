Return-Path: <netdev+bounces-1023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F316FBD88
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36D6A1C20AA5
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F2F625;
	Tue,  9 May 2023 03:12:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06A9392
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:12:26 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3DC1BDD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:12:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1aaed87d8bdso37472475ad.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601926; x=1686193926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cHgi4bUh6g+kQGK+cUc0D/SnWeHb0dM+7Fd3s/O1oIg=;
        b=N5WIkr4zPWNhDHvetjeo9478wyYdJBKJHgV0H4u8ASJO+AXq+8sFvbmglWRH80F8+k
         ZXlo+t2GYnRiIFgPB0V5aZU3L0k1cAe5T+PcH8CVH0bspOBtMWxi7Z95VZTdeIE0JkPK
         dQ/JchGD6clQkJ+pJHkg5bmR8QbkIlp9IAKYSmZr5KQDiRQszExxBN9H3kA2CYONNnT+
         VFGNQrhVe9RNU0mmDhpFmOoR0C1BiOs05tFz4NvZQyuwOrNNjiEAJ07Ouz20yK+qYEWQ
         bbb0iHey6Xuq7X+zPUbyzufvuKrnfmjfVIS1Danc0eM6vJd0s3dWBRYuKHwEhbbSJwNW
         pYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601926; x=1686193926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cHgi4bUh6g+kQGK+cUc0D/SnWeHb0dM+7Fd3s/O1oIg=;
        b=bGZfEnQq/jSWqFqLNpSjg9AMsQ6gcggcrKDn+CHGPkMrhKh37PQob7D2dV4KpnM7oS
         AMtiakhWPiCbyiRMe343Yf9EmfarZMzEVnf7qUq2qGnHGpgc8pBGDlyMUsnD5hqsTlc1
         FCBX0Uy867TOp3Y8ocTk1toKeWHQ7dEuTBvyCpdPXgmuJlPPYjspP+OKTrFbhPijWxYS
         3h3gAeQf0rAAJCaYd4eLYCUHOTvurvWT4oRxZocVoAtnJCZ7XNhahbveK3B+oSl0nCqj
         LFAqzHO0HHKYPckpSZcsAqUq+IakK5usxeGMbNxoEYIVWf6slhXphW5e1/1a7cWG5QpK
         Hawg==
X-Gm-Message-State: AC+VfDyxT9rPsMX4z7Z9x/ORkj49dKX0gKhIMrM56lmp0X0PSN2IR5zl
	b/Ua5h9tfPLFd7uKPJY6f80XbTafNaJPq0+e
X-Google-Smtp-Source: ACHHUZ6m2XNLgHmoSNrBQEVj1luA6HwBO5WBh0eK4N901ofaW+SU53ehKCWJSTHcYmiQo+ZHsvq8YQ==
X-Received: by 2002:a17:903:2782:b0:19f:8ad5:4331 with SMTP id jw2-20020a170903278200b0019f8ad54331mr11691711plb.38.1683601926503;
        Mon, 08 May 2023 20:12:06 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b001ab19724f64sm250768plx.38.2023.05.08.20.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:12:05 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Liang Li <liali@redhat.com>,
	Vincent Bernat <vincent@bernat.ch>,
	Simon Horman <simon.horman@corigine.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 0/4] bonding: fix send_peer_notif overflow
Date: Tue,  9 May 2023 11:11:56 +0800
Message-Id: <20230509031200.2152236-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Bonding send_peer_notif was defined as u8. But the value is
num_peer_notif multiplied by peer_notif_delay, which is u8 * u32.
This would cause the send_peer_notif overflow.

Before the fix:
TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
4 garp packets sent on active slave eth1
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [FAIL]
24 garp packets sent on active slave eth1
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [FAIL]

After the fix:
TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [ OK ]

Hangbin Liu (4):
  bonding: fix send_peer_notif overflow
  Documentation: bonding: fix the doc of peer_notif_delay
  selftests: forwarding: lib: add netns support for tc rule handle stats
    get
  kselftest: bonding: add num_grat_arp test

 Documentation/networking/bonding.rst          |  9 ++--
 drivers/net/bonding/bond_netlink.c            |  7 ++-
 drivers/net/bonding/bond_options.c            |  8 ++-
 include/net/bonding.h                         |  2 +-
 .../drivers/net/bonding/bond_options.sh       | 50 +++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     |  2 +
 tools/testing/selftests/net/forwarding/lib.sh |  3 +-
 7 files changed, 73 insertions(+), 8 deletions(-)

-- 
2.38.1


