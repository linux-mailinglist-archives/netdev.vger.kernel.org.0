Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF3B1B038
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfEMGWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 02:22:31 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:39680 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfEMGWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 02:22:30 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x4D6MKMD031944;
        Mon, 13 May 2019 15:22:21 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x4D6MKMD031944
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1557728542;
        bh=swEZk/Cz28om8/f0Dg5Vc4B35GQqTxoFUbP1b15szx0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ukcj8KGPL9n5eGX37YX+59e9VBeS2YQuC2ctkglb/oRV9CSvYxQ46LPf030QpAX1n
         FiBvQlvVtcYFSAYmziyEYqZTTJflZmchyBGt8wMfisMRFXsZfz5r5/P+3zx5IY6esv
         eK1Ut+jP6Jmu4AvAZFOuIqXe4pCF0xMrI4C+uhLppzqYDbv5OZpF9b/YdISs+URE1c
         QU1x/JlipyxnSVOsoFS6ZGlED+EOufNSh662uQPRRfz85fM143fhiXd43ZN9bYof/n
         +4/86QmaRcOoFujKqBrgT6/4Ro0iBauFyDyyKmuXaaC6c46sVv5ts1rG6tffPFLPQ3
         Ei0/PevcXe2Dg==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/4] kbuild: remove 'addtree' and 'flags' magic
Date:   Mon, 13 May 2019 15:22:13 +0900
Message-Id: <20190513062217.20750-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'addtree' and 'flags' are longstanding PITA.

When we discussed this in kbuild ML,
(https://patchwork.kernel.org/patch/9632347/)
we agreed to get rid of this hack.

This required lots of efforts to send many fixups
to each subsystem.

I did it, all the per-subsystem fixups were merged
except media subsystem.

I will apply all the remaining fixups,
and delete 'addtree' and 'flags' magic.

I have tested this series for a long time,
and addressed all the reported issues.



Masahiro Yamada (4):
  media: remove unneeded header search paths
  media: prefix header search paths with $(srctree)/
  treewide: prefix header search paths with $(srctree)/
  kbuild: remove 'addtree' and 'flags' magic for header search paths

 arch/mips/pnx833x/Platform                    |  2 +-
 arch/powerpc/Makefile                         |  2 +-
 arch/sh/Makefile                              |  4 +--
 arch/x86/kernel/Makefile                      |  2 +-
 arch/x86/mm/Makefile                          |  2 +-
 arch/xtensa/boot/lib/Makefile                 |  2 +-
 drivers/hid/intel-ish-hid/Makefile            |  2 +-
 drivers/media/common/b2c2/Makefile            |  4 +--
 drivers/media/dvb-frontends/cxd2880/Makefile  |  2 --
 drivers/media/i2c/smiapp/Makefile             |  2 +-
 drivers/media/mmc/siano/Makefile              |  3 +--
 drivers/media/pci/b2c2/Makefile               |  2 +-
 drivers/media/pci/bt8xx/Makefile              |  5 ++--
 drivers/media/pci/cx18/Makefile               |  4 +--
 drivers/media/pci/cx23885/Makefile            |  4 +--
 drivers/media/pci/cx88/Makefile               |  4 +--
 drivers/media/pci/ddbridge/Makefile           |  4 +--
 drivers/media/pci/dm1105/Makefile             |  2 +-
 drivers/media/pci/mantis/Makefile             |  2 +-
 drivers/media/pci/netup_unidvb/Makefile       |  2 +-
 drivers/media/pci/ngene/Makefile              |  4 +--
 drivers/media/pci/pluto2/Makefile             |  2 +-
 drivers/media/pci/pt1/Makefile                |  4 +--
 drivers/media/pci/pt3/Makefile                |  4 +--
 drivers/media/pci/smipcie/Makefile            |  5 ++--
 drivers/media/pci/ttpci/Makefile              |  4 +--
 drivers/media/platform/sti/c8sectpfe/Makefile |  5 ++--
 drivers/media/radio/Makefile                  |  2 --
 drivers/media/spi/Makefile                    |  4 +--
 drivers/media/usb/as102/Makefile              |  2 +-
 drivers/media/usb/au0828/Makefile             |  4 +--
 drivers/media/usb/b2c2/Makefile               |  2 +-
 drivers/media/usb/cx231xx/Makefile            |  5 ++--
 drivers/media/usb/em28xx/Makefile             |  4 +--
 drivers/media/usb/go7007/Makefile             |  2 +-
 drivers/media/usb/pvrusb2/Makefile            |  4 +--
 drivers/media/usb/siano/Makefile              |  2 +-
 drivers/media/usb/tm6000/Makefile             |  4 +--
 drivers/media/usb/ttusb-budget/Makefile       |  2 +-
 drivers/media/usb/usbvision/Makefile          |  2 --
 drivers/net/ethernet/chelsio/libcxgb/Makefile |  2 +-
 drivers/target/iscsi/cxgbit/Makefile          |  6 ++---
 drivers/usb/storage/Makefile                  |  2 +-
 fs/ocfs2/dlm/Makefile                         |  3 +--
 fs/ocfs2/dlmfs/Makefile                       |  2 +-
 fs/xfs/Makefile                               |  4 +--
 net/bpfilter/Makefile                         |  2 +-
 scripts/Kbuild.include                        |  8 ------
 scripts/Makefile.host                         | 12 ++++-----
 scripts/Makefile.lib                          | 26 ++++++-------------
 scripts/dtc/Makefile                          |  6 ++---
 scripts/genksyms/Makefile                     |  4 +--
 scripts/kconfig/Makefile                      |  4 +--
 53 files changed, 85 insertions(+), 119 deletions(-)

-- 
2.17.1

