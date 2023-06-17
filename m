Return-Path: <netdev+bounces-11677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 687A4733EA7
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 507311C20A8A
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4448646B2;
	Sat, 17 Jun 2023 06:27:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B3046AB
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:27:02 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C4CE66;
	Fri, 16 Jun 2023 23:27:00 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51a3e7a9127so2399545a12.1;
        Fri, 16 Jun 2023 23:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686983219; x=1689575219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vETI5TQvq1SPOYV8EBJJoDmGtq15U8VQP1o1n/huufs=;
        b=X1dgpGhhxlqnzRaky3bchjnOrqH0OtZ1IpBnDOL+gOL6y/eFrN8swpP1AbhExG1sdk
         n2MTdNfcPGWX+tMQ9RVjkHcA1Ol1FA0GgFs2gJSQhKvO6LRp4eiiL5InXpBfWUNrBrEk
         7+o7pDdw4S/dgwrvMdLKF4z/EiWXBjOItpNXcFIXEHiBrVYYKMvOV3Hlj46LGdc9kVN/
         liq9x7SAxu/0BCV+V4QdXvHNE5p557h2UKjwEq4tdE7S79y/d7qdeiBzAEe6RgY2hCww
         IhncM7oxAHYUAKovYqfd8BtasV+7nkLs6dYdg5XG9XKa+YV9o0UpUApsnXYXIdLRzRG3
         zE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686983219; x=1689575219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vETI5TQvq1SPOYV8EBJJoDmGtq15U8VQP1o1n/huufs=;
        b=Le/vMVth1rNqqPEgMulDJNNvvUtIegOBYsFLkx4XIPn9r314wfPEj4l12wzgXwFfx4
         aY8kvf6Qy8fdZ9g/bvmRfp+BJKgDKvU6enprjepTl7rYpHQaXLHRkaaxeHiX0911LT7y
         kLphpu9iBYE6ZwZ7BRvaAD4VP7l4XSJyLm3KeetRrpY0hFjUW0pJ65/ustTe5/MJq6tt
         ulygWMxTUEXq9f8UPoRklKd+BQGLaByFChtk1OLM5D4iZBjEGNhY8NTkzutEx3evoKgF
         UFrH83vtpSEKnEAQO+jVwZWiAVIPJqxy6y/fMEDnJVMzE3/U5Q6sfDfH9S69qMbT1oqF
         A29A==
X-Gm-Message-State: AC+VfDzFYWyyOWnorXbI+g5gx/WMh4YK3JiHdGcG6egZG/VWzOdBFAkQ
	EQ3D7RTuUdTVXtlGQGgipSU=
X-Google-Smtp-Source: ACHHUZ6hdV8TrJbD/tkY32AmFYy/lDFrFyiM6FgO5/qja6NVTAccT/wZ+SRYemLvC8KhX1SnjBTORQ==
X-Received: by 2002:a05:6402:322:b0:51a:3fdc:5bb0 with SMTP id q2-20020a056402032200b0051a3fdc5bb0mr3008125edw.15.1686983218664;
        Fri, 16 Jun 2023 23:26:58 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n6-20020a056402514600b0051a313a66e8sm1799638edd.45.2023.06.16.23.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 23:26:57 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Landen Chao <landen.chao@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net v6 0/6] net: dsa: mt7530: fix multiple CPU ports, BPDU and LLDP handling
Date: Sat, 17 Jun 2023 09:26:43 +0300
Message-Id: <20230617062649.28444-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi.

This patch series fixes all non-theoretical issues regarding multiple CPU
ports and the handling of LLDP frames and BPDUs.

I am adding me as a maintainer, I've got some code improvements on the way.
I will keep an eye on this driver and the patches submitted for it in the
future.

Arınç

v6:
- Change a small portion of the comment in the diff on "net: dsa: mt7530:
  set all CPU ports in MT7531_CPU_PMAP" with Russell's suggestion.
- Change the patch log of "net: dsa: mt7530: fix trapping frames on
  non-MT7621 SoC MT7530 switch" with Vladimir's suggestion.
- Group the code for trapping frames into a common function and call that.
- Add Vladimir and Russell's reviewed-by tags to where they're given.

v5:
- Change the comment in the diff on the first patch with Russell's words.
- Change the patch log of the first patch to state that the patch is just
  preparatory work for change "net: dsa: introduce
  preferred_default_local_cpu_port and use on MT7530" and not a fix to an
  existing problem on the code base.
- Remove the "net: dsa: mt7530: fix trapping frames with multiple CPU ports
  on MT7530" patch. It fixes a theoretical issue, therefore it is net-next
  material.
- Remove unnecessary information from the patch logs. Remove the enum
  renaming change.
- Strengthen the point of the "net: dsa: introduce
  preferred_default_local_cpu_port and use on MT7530" patch.

v4: Make the patch logs and my comments in the code easier to understand.
v3: Fix the from header on the patches. Write a cover letter.
v2: Add patches to fix the handling of LLDP frames and BPDUs.

Arınç ÜNAL (6):
  net: dsa: mt7530: set all CPU ports in MT7531_CPU_PMAP
  net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
  net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
  net: dsa: mt7530: fix handling of LLDP frames
  net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
  MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER

 MAINTAINERS              |  5 +++--
 drivers/net/dsa/mt7530.c | 48 ++++++++++++++++++++++++++++++++++---------
 drivers/net/dsa/mt7530.h |  6 ++++++
 include/net/dsa.h        |  8 ++++++++
 net/dsa/dsa.c            | 24 +++++++++++++++++++++-
 5 files changed, 78 insertions(+), 13 deletions(-)



