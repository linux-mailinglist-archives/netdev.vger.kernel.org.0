Return-Path: <netdev+bounces-1804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B256FF302
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2940928180D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6DD1B8F3;
	Thu, 11 May 2023 13:34:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933019E7E
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:33 +0000 (UTC)
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C82A10E48;
	Thu, 11 May 2023 06:34:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-24df6bbf765so7528723a91.0;
        Thu, 11 May 2023 06:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812057; x=1686404057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OrvYsPVkLlCCG9odWfJ2x1pNp/qnkuVA/7FJ1B7EVu4=;
        b=NkZFTrbE7vCJT1esmCFX11skYYhjaSLkGz7AMyWI6mFJHsMt5CWX6IYVMSgjHleRxn
         ttU5m6sHWNutEieWLJEqhcYOqQjr4HM0BzS3ZTeu2vC9PdzIYEi4gZxGR6yIiI5bXq92
         wc+nDIeMuOJSI3t7qYhFDvxfRlYchl837qgVUhnX02JXpzZGN3dMXpE9EGEW5BX0Zocb
         gxcw65MuyAXyvabBCf0592Aug/qbQbyKOdjgritjse/Tqi93V9Riuv7UKtLqwiH80PIG
         xBS4SRQPtIy9GMuLBshASReX3VNMWxqks7JOq0fX0ZKAxEbArMxfNOMUy7gTrPsh1X15
         zIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812057; x=1686404057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OrvYsPVkLlCCG9odWfJ2x1pNp/qnkuVA/7FJ1B7EVu4=;
        b=b3oipXXGvmLku3srpeP1xOpP5FZHyh3wHw0W3QXkaUAmzAPlR/OZ2yrevkuyZboadd
         XvRwQCDboj5nO8Rog0J/L8BVujNxZ1suew1vaTKA/hofdT1oyJ4MjGwtoda7TDRXtw6h
         4k26oIO9sxsWg+Ux1eJDDX09QHFNL9fqYunTLctjV5FbSAyGEJzVHfRvYzSh2FdtEfe/
         gATT37yqSXUXazHkiomsYex/x+jYTrXrob6bggWy5Abl4o1HObPEKGw8VYdtZEpgyi7w
         B3Ao37ZATfzL+YW0zIVyqNd1B9ubIdm8ZVeMVCn2iAEXCKwgKPTwBXby5fNECmMIzyXb
         Eyig==
X-Gm-Message-State: AC+VfDxbvFli4L/SHhzCTbPkb/vYhYUfFKpYpN0f2+Q3XwP10lmZV0LK
	9d9nd0BFGt8ls7P8KQhFolU=
X-Google-Smtp-Source: ACHHUZ7fjYp9VwcPx9+qBb+lSz7MGEuPHEmA//zdilxU7jrGermCKcX+mpzpH1giJHdqIgkaAkdDMw==
X-Received: by 2002:a17:90b:2385:b0:237:40a5:7acf with SMTP id mr5-20020a17090b238500b0023740a57acfmr22201327pjb.33.1683812056934;
        Thu, 11 May 2023 06:34:16 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090a930800b0024e1236f599sm18314860pjo.8.2023.05.11.06.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 178C41067D5; Thu, 11 May 2023 20:34:09 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jan Kara <jack@suse.com>,
	=?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>,
	Archana <craechal@gmail.com>
Subject: [PATCH 00/10] Treewide GPL SPDX conversion (love letter to Didi)
Date: Thu, 11 May 2023 20:33:56 +0700
Message-Id: <20230511133406.78155-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7544; i=bagasdotme@gmail.com; h=from:subject; bh=/yuofc/tOvJfknZ+wKI/sN7nSPM3+b+BthJrqhUt8T0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx7w7u+h3mOFE7a6fNkrLjXxk3+BmLM+QcWLyIaVOot nCY7KsfHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIlckM/8s+5WbLRqnb/27T XOoU8WDVRaaAY3LXLpV9PujDMrOKUZmR4aKX0JotO2QZ8sWdYg5L/Ytp+lN4Oi3skkBBelFlW9d qXgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I trigger this patch series because of Didi's GPL full name fixes
attempt [1], for which all of them had been NAKed. In many cases, the
appropriate correction is to use SPDX license identifier instead.

Often, when replacing license notice boilerplates with their equivalent
SPDX identifier, the notice doesn't mention explicit GPL version. Greg
[2] replied this question by falling back to GPL 1.0 (more precisely
GPL 1.0+ in order to be compatible with GPL 2.0 used by Linux kernel),
although there are exceptions (mostly resolved by inferring from
older patches covering similar situation).

Happy reviewing!

[1]: https://lore.kernel.org/all/?q=f%3A%22didi.debian%40cknow.org%22+AND+s%3A%22GPL%22+AND+NOT+s%3A%22Re%3A%22
[2]: https://lore.kernel.org/all/20181028112728.GD8826@kroah.com/ 

Bagas Sanjaya (10):
  agp/amd64: Remove GPL distribution notice
  mISDN: Replace GPL notice boilerplate with SPDX identifier
  net: bonding: Add SPDX identifier to remaining files
  net: ethernet: 8390: Replace GPL boilerplate with SPDX identifier
  net: ethernet: i825xx: Replace GPL boilerplate with SPDX identifier
  pcmcia: Add SPDX identifier
  drivers: staging: wlan-ng: Remove GPL/MPL boilerplate
  drivers: watchdog: Replace GPL license notice with SPDX identifier
  udf: Replace license notice with SPDX identifier
  include: synclink: Replace GPL license notice with SPDX identifier

 drivers/char/agp/amd64-agp.c               |  1 -
 drivers/isdn/mISDN/dsp_audio.c             |  4 +---
 drivers/isdn/mISDN/dsp_blowfish.c          |  4 +---
 drivers/isdn/mISDN/dsp_cmx.c               |  4 +---
 drivers/isdn/mISDN/dsp_core.c              |  3 +--
 drivers/isdn/mISDN/dsp_dtmf.c              |  4 +---
 drivers/isdn/mISDN/dsp_tones.c             |  4 +---
 drivers/net/bonding/bond_main.c            |  1 +
 drivers/net/bonding/bonding_priv.h         |  4 +---
 drivers/net/ethernet/8390/8390.h           |  2 ++
 drivers/net/ethernet/8390/apne.c           |  7 +------
 drivers/net/ethernet/8390/axnet_cs.c       |  6 +++---
 drivers/net/ethernet/8390/hydra.c          |  6 ++----
 drivers/net/ethernet/8390/lib8390.c        |  5 ++---
 drivers/net/ethernet/8390/mac8390.c        |  6 ++----
 drivers/net/ethernet/8390/mcf8390.c        |  4 +---
 drivers/net/ethernet/8390/ne.c             |  4 +---
 drivers/net/ethernet/8390/ne2k-pci.c       |  8 +-------
 drivers/net/ethernet/8390/pcnet_cs.c       |  5 ++---
 drivers/net/ethernet/8390/smc-ultra.c      |  4 +---
 drivers/net/ethernet/8390/stnic.c          |  5 +----
 drivers/net/ethernet/8390/wd.c             |  4 +---
 drivers/net/ethernet/8390/zorro8390.c      |  7 +------
 drivers/net/ethernet/i825xx/82596.c        |  5 ++---
 drivers/net/ethernet/i825xx/lasi_82596.c   |  5 ++---
 drivers/net/ethernet/i825xx/lib82596.c     |  5 ++---
 drivers/net/ethernet/i825xx/sun3_82586.c   |  4 +---
 drivers/net/ethernet/i825xx/sun3_82586.h   |  4 +---
 drivers/pcmcia/bcm63xx_pcmcia.c            |  5 +----
 drivers/pcmcia/cirrus.h                    | 21 +------------------
 drivers/pcmcia/i82365.c                    | 22 +-------------------
 drivers/pcmcia/i82365.h                    | 21 +------------------
 drivers/pcmcia/o2micro.h                   | 21 +------------------
 drivers/pcmcia/pd6729.c                    |  3 +--
 drivers/pcmcia/pxa2xx_base.h               |  1 +
 drivers/pcmcia/ricoh.h                     | 21 +------------------
 drivers/pcmcia/sa1100_generic.c            | 22 +-------------------
 drivers/pcmcia/sa11xx_base.c               | 22 +-------------------
 drivers/pcmcia/sa11xx_base.h               | 22 +-------------------
 drivers/pcmcia/soc_common.c                | 22 +-------------------
 drivers/pcmcia/tcic.c                      | 22 +-------------------
 drivers/pcmcia/tcic.h                      | 21 +------------------
 drivers/pcmcia/ti113x.h                    | 21 +------------------
 drivers/pcmcia/topic.h                     | 23 +--------------------
 drivers/pcmcia/vg468.h                     | 21 +------------------
 drivers/staging/wlan-ng/hfa384x.h          | 21 -------------------
 drivers/staging/wlan-ng/hfa384x_usb.c      | 21 -------------------
 drivers/staging/wlan-ng/p80211conv.c       | 21 -------------------
 drivers/staging/wlan-ng/p80211conv.h       | 21 -------------------
 drivers/staging/wlan-ng/p80211hdr.h        | 21 -------------------
 drivers/staging/wlan-ng/p80211ioctl.h      | 21 -------------------
 drivers/staging/wlan-ng/p80211metadef.h    | 21 -------------------
 drivers/staging/wlan-ng/p80211metastruct.h | 21 -------------------
 drivers/staging/wlan-ng/p80211mgmt.h       | 21 -------------------
 drivers/staging/wlan-ng/p80211msg.h        | 21 -------------------
 drivers/staging/wlan-ng/p80211netdev.c     | 21 -------------------
 drivers/staging/wlan-ng/p80211netdev.h     | 21 -------------------
 drivers/staging/wlan-ng/p80211req.c        | 21 -------------------
 drivers/staging/wlan-ng/p80211req.h        | 21 -------------------
 drivers/staging/wlan-ng/p80211types.h      | 21 -------------------
 drivers/staging/wlan-ng/p80211wep.c        | 21 -------------------
 drivers/staging/wlan-ng/prism2fw.c         | 21 -------------------
 drivers/staging/wlan-ng/prism2mgmt.c       | 21 -------------------
 drivers/staging/wlan-ng/prism2mgmt.h       | 21 -------------------
 drivers/staging/wlan-ng/prism2mib.c        | 21 -------------------
 drivers/staging/wlan-ng/prism2sta.c        | 21 -------------------
 drivers/watchdog/ep93xx_wdt.c              |  5 +----
 drivers/watchdog/ibmasr.c                  |  3 +--
 drivers/watchdog/m54xx_wdt.c               |  4 +---
 drivers/watchdog/max63xx_wdt.c             |  5 +----
 drivers/watchdog/moxart_wdt.c              |  4 +---
 drivers/watchdog/octeon-wdt-nmi.S          |  5 +----
 drivers/watchdog/orion_wdt.c               |  4 +---
 drivers/watchdog/rtd119x_wdt.c             |  2 +-
 drivers/watchdog/sb_wdog.c                 |  5 +----
 drivers/watchdog/sbc_fitpc2_wdt.c          |  4 +---
 drivers/watchdog/ts4800_wdt.c              |  4 +---
 drivers/watchdog/ts72xx_wdt.c              |  4 +---
 fs/udf/balloc.c                            |  6 +-----
 fs/udf/dir.c                               |  6 +-----
 fs/udf/directory.c                         |  6 +-----
 fs/udf/ecma_167.h                          | 24 +---------------------
 fs/udf/file.c                              |  6 +-----
 fs/udf/ialloc.c                            |  6 +-----
 fs/udf/inode.c                             |  6 +-----
 fs/udf/lowlevel.c                          |  6 +-----
 fs/udf/misc.c                              |  6 +-----
 fs/udf/namei.c                             |  6 +-----
 fs/udf/osta_udf.h                          | 24 +---------------------
 fs/udf/partition.c                         |  6 +-----
 fs/udf/super.c                             |  6 +-----
 fs/udf/symlink.c                           |  6 +-----
 fs/udf/truncate.c                          |  6 +-----
 fs/udf/udftime.c                           | 19 +----------------
 fs/udf/unicode.c                           |  6 +-----
 include/linux/synclink.h                   |  3 +--
 include/net/bonding.h                      |  4 +---
 97 files changed, 85 insertions(+), 999 deletions(-)


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
An old man doll... just what I always wanted! - Clara


