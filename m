Return-Path: <netdev+bounces-4698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CCEA70DF2A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68EA61C20D30
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E4F1F18C;
	Tue, 23 May 2023 14:29:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5C1EA7E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:29:35 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AD2E9;
	Tue, 23 May 2023 07:29:32 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id F319D852DB;
	Tue, 23 May 2023 16:29:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1684852169;
	bh=6ptexe/u4vS+fQddFLan9T1NLcrbA6NWyhAdTJ0l0nc=;
	h=From:To:Cc:Subject:Date:From;
	b=VJln1mKhUGPqvxddB6Euz8zLAn9rT/oOeWCPltDeweYtsD5gPbzYhylgbwhOPnTE8
	 6lNToyfkv8Rmjffk35gRkOiMyRoXRwDnOud4k9SJCqL5anTbVgmLl4TGm6uCjzUH6j
	 x3S1Lqn0uGkNtPeXtOuJ9WafAojF828/wo/L+nKm51LUYnzL31VOp2fltztFSADhk1
	 xZ8UgHeGiRZwgQLYyyD0lWeKIO2iRrT4gSmj+GLA+3lO46wb8R/baBADAdtQsICYUb
	 uS6ENe8jXSfU18skRYUiVapMyS+f5FL8S6iUZD9qzvLu42YtEtsQ/SjsgQ6nvaz313
	 nz6PvtqfFdpEA==
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukasz Majewski <lukma@denx.de>
Subject: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020  switches
Date: Tue, 23 May 2023 16:29:09 +0200
Message-Id: <20230523142912.2086985-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
"net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290" the
error when mv88e6020 or mv88e6071 is used is not present anymore.

As a result patches for adding max frame size are not required to provide
working setup with aforementioned switches.

Lukasz Majewski (2):
  dsa: marvell: Define .set_max_frame_size() function for mv88e6250 SoC
    family
  net: dsa: mv88e6xxx: add support for MV88E6071 switch

Matthias Schiffer (1):
  net: dsa: mv88e6xxx: add support for MV88E6020 switch

 drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/port.h |  2 ++
 3 files changed, 45 insertions(+)

-- 
2.20.1


