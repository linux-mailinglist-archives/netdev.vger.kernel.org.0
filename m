Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81CF49356E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352045AbiASHYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:24:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:35948 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352004AbiASHY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 02:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642577068; x=1674113068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vu0ELTEtpJhWmPKuiI8R3xh/gKCGIqar+M1Hh1oUySM=;
  b=PWF8h1eP4as1wKDv8HpRKcPo3y91fUatqsfMA2PazAxctsJhSnbtoITz
   QNnOPnfDxQ+j93XuTUa1PNTdocy+U6AcWGZG32qtDMBVtfcnaLsb47dlu
   Fb0L75aUUDINwubH3jLGzg+FpKt3D2wxf3w+bkNsfz+CGuzwx/JN9Aqc0
   uvOapg5VXoFWrSZjRRXmWHnsTYT4rCRviEiCsN3dbK26ry8y2vMd0cpsw
   B9mYM0bcFQcQFPGX13z2RW3X3uVHOZSNlA10eBUbFG0qmQLpXgppMKzoz
   NKLEL+E73uu4YCEeQvKnFLnTbYsVtlw2ihCOZDK2uc6Dln2/oFv53MmpF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="244799935"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="244799935"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 23:24:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="530544516"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 23:24:27 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH 3/3] drm: Convert open yes/no strings to yesno()
Date:   Tue, 18 Jan 2022 23:24:50 -0800
Message-Id: <20220119072450.2890107-4-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119072450.2890107-1-lucas.demarchi@intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/string_helpers.h provides a helper to return "yes"/"no"
strings. Replace the open coded versions with yesno(). The places were
identified with the following semantic patch:

	@@
	expression b;
	@@

	- b ? "yes" : "no"
	+ yesno(b)

Then the includes were added, so we include-what-we-use, and parenthesis
adjusted in drivers/gpu/drm/v3d/v3d_debugfs.c. After the conversion we
still see the same binary sizes:

   text    data     bss     dec     hex filename
1442171   60344     800 1503315  16f053 ./drivers/gpu/drm/radeon/radeon.ko
1442171   60344     800 1503315  16f053 ./drivers/gpu/drm/radeon/radeon.ko.old
5985991  324439   33808 6344238  60ce2e ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko
5985991  324439   33808 6344238  60ce2e ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko.old
 411986   10490    6176  428652   68a6c ./drivers/gpu/drm/drm.ko
 411986   10490    6176  428652   68a6c ./drivers/gpu/drm/drm.ko.old
1970292  109515    2352 2082159  1fc56f ./drivers/gpu/drm/nouveau/nouveau.ko
1970292  109515    2352 2082159  1fc56f ./drivers/gpu/drm/nouveau/nouveau.ko.old

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 drivers/gpu/drm/amd/amdgpu/atom.c             |  3 ++-
 drivers/gpu/drm/drm_client_modeset.c          |  3 ++-
 drivers/gpu/drm/drm_dp_helper.c               |  3 ++-
 drivers/gpu/drm/drm_gem.c                     |  3 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c |  4 +++-
 drivers/gpu/drm/radeon/atom.c                 |  3 ++-
 drivers/gpu/drm/v3d/v3d_debugfs.c             | 11 ++++++-----
 drivers/gpu/drm/virtio/virtgpu_debugfs.c      |  3 ++-
 8 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 6fa2229b7229..3d7d0f4cfc05 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/string_helpers.h>
 #include <asm/unaligned.h>
 
 #include <drm/drm_util.h>
@@ -740,7 +741,7 @@ static void atom_op_jump(atom_exec_context *ctx, int *ptr, int arg)
 		break;
 	}
 	if (arg != ATOM_COND_ALWAYS)
-		SDEBUG("   taken: %s\n", execute ? "yes" : "no");
+		SDEBUG("   taken: %s\n", yesno(execute));
 	SDEBUG("   target: 0x%04X\n", target);
 	if (execute) {
 		if (ctx->last_jump == (ctx->start + target)) {
diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index ced09c7c06f9..3c55156a75fa 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string_helpers.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_client.h>
@@ -241,7 +242,7 @@ static void drm_client_connectors_enabled(struct drm_connector **connectors,
 		connector = connectors[i];
 		enabled[i] = drm_connector_enabled(connector, true);
 		DRM_DEBUG_KMS("connector %d enabled? %s\n", connector->base.id,
-			      connector->display_info.non_desktop ? "non desktop" : enabled[i] ? "yes" : "no");
+			      connector->display_info.non_desktop ? "non desktop" : yesno(enabled[i]));
 
 		any_enabled |= enabled[i];
 	}
diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 4d0d1e8e51fa..f600616839f3 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/string_helpers.h>
 
 #include <drm/drm_dp_helper.h>
 #include <drm/drm_print.h>
@@ -1122,7 +1123,7 @@ void drm_dp_downstream_debug(struct seq_file *m,
 	bool branch_device = drm_dp_is_branch(dpcd);
 
 	seq_printf(m, "\tDP branch device present: %s\n",
-		   branch_device ? "yes" : "no");
+		   yesno(branch_device));
 
 	if (!branch_device)
 		return;
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 4dcdec6487bb..6436876341bb 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -39,6 +39,7 @@
 #include <linux/dma-buf-map.h>
 #include <linux/mem_encrypt.h>
 #include <linux/pagevec.h>
+#include <linux/string_helpers.h>
 
 #include <drm/drm.h>
 #include <drm/drm_device.h>
@@ -1145,7 +1146,7 @@ void drm_gem_print_info(struct drm_printer *p, unsigned int indent,
 			  drm_vma_node_start(&obj->vma_node));
 	drm_printf_indent(p, indent, "size=%zu\n", obj->size);
 	drm_printf_indent(p, indent, "imported=%s\n",
-			  obj->import_attach ? "yes" : "no");
+			  yesno(obj->import_attach));
 
 	if (obj->funcs->print_info)
 		obj->funcs->print_info(p, indent, obj);
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
index a11637b0f6cc..d39a9c1a2a6e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
@@ -21,6 +21,8 @@
  *
  * Authors: Ben Skeggs
  */
+#include <linux/string_helpers.h>
+
 #include "aux.h"
 #include "pad.h"
 
@@ -94,7 +96,7 @@ void
 nvkm_i2c_aux_monitor(struct nvkm_i2c_aux *aux, bool monitor)
 {
 	struct nvkm_i2c_pad *pad = aux->pad;
-	AUX_TRACE(aux, "monitor: %s", monitor ? "yes" : "no");
+	AUX_TRACE(aux, "monitor: %s", yesno(monitor));
 	if (monitor)
 		nvkm_i2c_pad_mode(pad, NVKM_I2C_PAD_AUX);
 	else
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index f15b20da5315..77ef7d136530 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/string_helpers.h>
 
 #include <asm/unaligned.h>
 
@@ -722,7 +723,7 @@ static void atom_op_jump(atom_exec_context *ctx, int *ptr, int arg)
 		break;
 	}
 	if (arg != ATOM_COND_ALWAYS)
-		SDEBUG("   taken: %s\n", execute ? "yes" : "no");
+		SDEBUG("   taken: %s\n", yesno(execute));
 	SDEBUG("   target: 0x%04X\n", target);
 	if (execute) {
 		if (ctx->last_jump == (ctx->start + target)) {
diff --git a/drivers/gpu/drm/v3d/v3d_debugfs.c b/drivers/gpu/drm/v3d/v3d_debugfs.c
index e76b24bb8828..22c23f3a691e 100644
--- a/drivers/gpu/drm/v3d/v3d_debugfs.c
+++ b/drivers/gpu/drm/v3d/v3d_debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/debugfs.h>
 #include <linux/pm_runtime.h>
 #include <linux/seq_file.h>
+#include <linux/string_helpers.h>
 
 #include <drm/drm_debugfs.h>
 
@@ -148,15 +149,15 @@ static int v3d_v3d_debugfs_ident(struct seq_file *m, void *unused)
 		   V3D_GET_FIELD(ident3, V3D_HUB_IDENT3_IPREV),
 		   V3D_GET_FIELD(ident3, V3D_HUB_IDENT3_IPIDX));
 	seq_printf(m, "MMU:        %s\n",
-		   (ident2 & V3D_HUB_IDENT2_WITH_MMU) ? "yes" : "no");
+		   yesno(ident2 & V3D_HUB_IDENT2_WITH_MMU));
 	seq_printf(m, "TFU:        %s\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_TFU) ? "yes" : "no");
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TFU));
 	seq_printf(m, "TSY:        %s\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_TSY) ? "yes" : "no");
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TSY));
 	seq_printf(m, "MSO:        %s\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_MSO) ? "yes" : "no");
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_MSO));
 	seq_printf(m, "L3C:        %s (%dkb)\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_L3C) ? "yes" : "no",
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_L3C),
 		   V3D_GET_FIELD(ident2, V3D_HUB_IDENT2_L3C_NKB));
 
 	for (core = 0; core < cores; core++) {
diff --git a/drivers/gpu/drm/virtio/virtgpu_debugfs.c b/drivers/gpu/drm/virtio/virtgpu_debugfs.c
index b6954e2f75e6..c7f675721840 100644
--- a/drivers/gpu/drm/virtio/virtgpu_debugfs.c
+++ b/drivers/gpu/drm/virtio/virtgpu_debugfs.c
@@ -22,6 +22,7 @@
  * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
+#include <linux/string_helpers.h>
 
 #include <drm/drm_debugfs.h>
 #include <drm/drm_file.h>
@@ -31,7 +32,7 @@
 static void virtio_gpu_add_bool(struct seq_file *m, const char *name,
 				bool value)
 {
-	seq_printf(m, "%-16s : %s\n", name, value ? "yes" : "no");
+	seq_printf(m, "%-16s : %s\n", name, yesno(value));
 }
 
 static void virtio_gpu_add_int(struct seq_file *m, const char *name, int value)
-- 
2.34.1

