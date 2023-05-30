Return-Path: <netdev+bounces-6290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA077158CA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27B672810C0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814D812B67;
	Tue, 30 May 2023 08:39:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771A3125BA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:39:46 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAF9A1;
	Tue, 30 May 2023 01:39:44 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id CBCE1846F0;
	Tue, 30 May 2023 10:39:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685435982;
	bh=cFxoSyVh9Mb73TPtXDZpGE2BFJ/+remD0M2nfSpO+L8=;
	h=From:To:Cc:Subject:Date:From;
	b=KzgrXwPokMo8NOnv4o9r17lhF/bsdsiIZy8hE1YWNHnLyE87qDUMCZX7v9N6kCgbr
	 pfthKu8yyyNlXJ7Q7o1/X+/GysLLSuQEMeggCAntfcaBAFuyrUIcSpgHUM6q8y4JVy
	 YCZ9tvBaIRxbMK+huv2pEdPW6iMk9hlMldXNVmrypZm/CugpuNie7k3g02uJ5YbbI6
	 hmut+ogkagJzzhXO3X+25LWoHr1V9Mdu4432D5jcJznn339q5gm7f/mNirb77ITQmw
	 5UehV4kuGAOGMbiXsK5MnMDftS2hf/RE7pHq/Fd2PpCD6eh82swBpAUjSc5yhkielN
	 L9bvzEmSPdTSA==
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
Subject: [PATCH v8 0/3] dsa: marvell: Add support for mv88e6071 and 6020  switches
Date: Tue, 30 May 2023 10:39:13 +0200
Message-Id: <20230530083916.2139667-1-lukma@denx.de>
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
  net: dsa: Define .set_max_frame_size() callback for mv88e6250 SoC
    family
  net: dsa: mv88e6xxx: add support for MV88E6071 switch

Matthias Schiffer (1):
  net: dsa: mv88e6xxx: add support for MV88E6020 switch

 drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  4 +++-
 drivers/net/dsa/mv88e6xxx/port.h |  2 ++
 3 files changed, 46 insertions(+), 1 deletion(-)

-- 
2.20.1


