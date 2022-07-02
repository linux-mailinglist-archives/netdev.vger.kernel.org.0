Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2369563D83
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 03:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiGBBDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 21:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiGBBDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 21:03:38 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4682409E;
        Fri,  1 Jul 2022 18:03:35 -0700 (PDT)
Date:   Fri, 1 Jul 2022 18:03:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656723813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UefsvJWBOCsJEHG/jcpgIGR+KBtUCRUqjXcROu7qjh4=;
        b=oGHlDm4tgr6UzDbC5z/sb7q2WEts5mi8mJ8aiIMXBOzW75BRr4BaIuszRL9hOCzoFfVxku
        tmO6BM7R9GzDDzZbe/MQeyeOEOAx+3VHqH/w/8ecEZ7fImffcNYGlal4Cw/gQ26E9Sym1J
        usYWeNXz8OdB9Vt23HLuxwKOwXbZ7ng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <lkp@intel.com>
Cc:     virtualization@lists.linux-foundation.org,
        usbb2k-api-dev@nongnu.org, tipc-discussion@lists.sourceforge.net,
        target-devel@vger.kernel.org, sound-open-firmware@alsa-project.org,
        samba-technical@lists.samba.org, rds-devel@oss.oracle.com,
        patches@opensource.cirrus.com, osmocom-net-gprs@lists.osmocom.org,
        openipmi-developer@lists.sourceforge.net, nvdimm@lists.linux.dev,
        ntb@lists.linux.dev, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        megaraidlinux.pdl@broadcom.com, linuxppc-dev@lists.ozlabs.org,
        linux1394-devel@lists.sourceforge.net, linux-x25@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-perf-users@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-parport@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-nfc@lists.01.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        legousb-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        keyrings@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        intel-wired-lan@lists.osuosl.org, dri-devel@lists.freedesktop.org,
        dm-devel@redhat.com, devicetree@vger.kernel.org,
        dev@openvswitch.org, dccp@vger.kernel.org, damon@lists.linux.dev,
        coreteam@netfilter.org, cgroups@vger.kernel.org,
        ceph-devel@vger.kernel.org, apparmor@lists.ubuntu.com,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org,
        accessrunner-general@lists.sourceforge.net
Subject: Re: [linux-next:master] BUILD REGRESSION
 6cc11d2a1759275b856e464265823d94aabd5eaf
Message-ID: <Yr+ZTnLb9lJk6fJO@castle>
References: <62be3696.+PAAAVlbtWK6G2hk%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62be3696.+PAAAVlbtWK6G2hk%lkp@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

esOn Fri, Jul 01, 2022 at 07:49:42AM +0800, kbuild test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 6cc11d2a1759275b856e464265823d94aabd5eaf  Add linux-next specific files for 20220630
> 
> Error/Warning reports:
> 
> https://lore.kernel.org/linux-mm/202206301859.UodBCrva-lkp@intel.com
> 
> Error/Warning: (recently discovered and may have been fixed)
> 
> arch/powerpc/kernel/interrupt.c:542:55: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
> arch/powerpc/kernel/interrupt.c:542:55: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
> drivers/pci/endpoint/functions/pci-epf-vntb.c:975:5: warning: no previous prototype for 'pci_read' [-Wmissing-prototypes]
> drivers/pci/endpoint/functions/pci-epf-vntb.c:984:5: warning: no previous prototype for 'pci_write' [-Wmissing-prototypes]
> mm/shrinker_debug.c:143:9: warning: function 'shrinker_debugfs_rename' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> mm/shrinker_debug.c:217:9: warning: function 'shrinker_debugfs_rename' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> mm/vmscan.c:637:9: warning: function 'prealloc_shrinker' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> mm/vmscan.c:642:9: warning: function 'prealloc_shrinker' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> mm/vmscan.c:697:9: warning: function 'register_shrinker' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> mm/vmscan.c:702:9: warning: function 'register_shrinker' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

Shrinker-related warnings should be fixed by the following patch.

Thanks!

--

From c399aff65c7745a209397a531c5b28fd404d83c2 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <roman.gushchin@linux.dev>
Date: Fri, 1 Jul 2022 17:38:31 -0700
Subject: [PATCH] mm:shrinkers: fix build warnings

Add __printf(a, b) attributes to shrinker functions taking shrinker
name as an argument to avoid compiler warnings like:

mm/shrinker_debug.c:143:9: warning: function 'shrinker_debugfs_rename'
  might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
mm/shrinker_debug.c:217:9: warning: function 'shrinker_debugfs_rename'
  might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
mm/vmscan.c:637:9: warning: function 'prealloc_shrinker' might be a
  candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
mm/vmscan.c:642:9: warning: function 'prealloc_shrinker' might be a
  candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
mm/vmscan.c:697:9: warning: function 'register_shrinker' might be a
  candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
mm/vmscan.c:702:9: warning: function 'register_shrinker' might be a
  candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/shrinker.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 64416f3e0a1f..08e6054e061f 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -93,9 +93,11 @@ struct shrinker {
  */
 #define SHRINKER_NONSLAB	(1 << 3)
 
-extern int prealloc_shrinker(struct shrinker *shrinker, const char *fmt, ...);
+extern int __printf(2, 3) prealloc_shrinker(struct shrinker *shrinker,
+					    const char *fmt, ...);
 extern void register_shrinker_prepared(struct shrinker *shrinker);
-extern int register_shrinker(struct shrinker *shrinker, const char *fmt, ...);
+extern int __printf(2, 3) register_shrinker(struct shrinker *shrinker,
+					    const char *fmt, ...);
 extern void unregister_shrinker(struct shrinker *shrinker);
 extern void free_prealloced_shrinker(struct shrinker *shrinker);
 extern void synchronize_shrinkers(void);
@@ -103,8 +105,8 @@ extern void synchronize_shrinkers(void);
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
 extern void shrinker_debugfs_remove(struct shrinker *shrinker);
-extern int shrinker_debugfs_rename(struct shrinker *shrinker,
-				   const char *fmt, ...);
+extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
+						  const char *fmt, ...);
 #else /* CONFIG_SHRINKER_DEBUG */
 static inline int shrinker_debugfs_add(struct shrinker *shrinker)
 {
@@ -113,8 +115,8 @@ static inline int shrinker_debugfs_add(struct shrinker *shrinker)
 static inline void shrinker_debugfs_remove(struct shrinker *shrinker)
 {
 }
-static inline int shrinker_debugfs_rename(struct shrinker *shrinker,
-					  const char *fmt, ...)
+static inline __printf(2, 3)
+int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 {
 	return 0;
 }
-- 
2.36.1

