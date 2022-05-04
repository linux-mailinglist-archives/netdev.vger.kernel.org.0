Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C68C51AF15
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378022AbiEDUd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378016AbiEDUd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:33:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1064FC47
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D7C0B828E9
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7EAC385A4;
        Wed,  4 May 2022 20:29:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DAYtuYQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651696185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ouU26g0vG5Sg6wrwnUyUn7i0UQ2fuCmEuY4OblZLbd4=;
        b=DAYtuYQYIRiGKArKyypqW720dDTrYK1Wh7EMOZGi/YQAui6koIw/rRDPyIOoc/gEsctaq5
        YQubBzUkIlSuquY3IbyM5yKfxZC+nkvbnHyDnQuMXkz7wbooFTQTrleJP5WpRJkWqlEkVy
        OqlcCYJ/ihMYYFzfKN8PPox1e4cO638=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c7c940db (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 20:29:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 5/6] wireguard: selftests: bump package deps
Date:   Wed,  4 May 2022 22:29:19 +0200
Message-Id: <20220504202920.72908-6-Jason@zx2c4.com>
In-Reply-To: <20220504202920.72908-1-Jason@zx2c4.com>
References: <20220504202920.72908-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use newer, more reliable package dependencies. These should hopefully
reduce flakes. However, we keep the old iputils package, as it
accumulated bugs after resulting in flakes on slow machines.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 .../testing/selftests/wireguard/qemu/Makefile  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index e121ef3878af..bca07b93eeb0 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -39,13 +39,13 @@ $(DISTFILES_PATH)/$(1): | $(4)
 	flock -x $$@.lock -c '[ -f $$@ ] && exit 0; wget -O $$@.tmp $(MIRROR)$(1) || wget -O $$@.tmp $(2)$(1) || rm -f $$@.tmp; [ -f $$@.tmp ] || exit 1; if ([ -n "$(4)" ] && sed -n "s#^\([a-f0-9]\{64\}\)  \($(1)\)\$$$$#\1  $(DISTFILES_PATH)/\2.tmp#p" "$(4)" || echo "$(3)  $$@.tmp") | sha256sum -c -; then mv $$@.tmp $$@; else rm -f $$@.tmp; exit 71; fi'
 endef
 
-$(eval $(call tar_download,IPERF,iperf,3.7,.tar.gz,https://downloads.es.net/pub/iperf/,d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c))
-$(eval $(call tar_download,BASH,bash,5.0,.tar.gz,https://ftp.gnu.org/gnu/bash/,b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d))
-$(eval $(call tar_download,IPROUTE2,iproute2,5.6.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,1b5b0e25ce6e23da7526ea1da044e814ad85ba761b10dd29c2b027c056b04692))
-$(eval $(call tar_download,IPTABLES,iptables,1.8.4,.tar.bz2,https://www.netfilter.org/projects/iptables/files/,993a3a5490a544c2cbf2ef15cf7e7ed21af1845baf228318d5c36ef8827e157c))
-$(eval $(call tar_download,NMAP,nmap,7.80,.tar.bz2,https://nmap.org/dist/,fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa))
+$(eval $(call tar_download,IPERF,iperf,3.11,.tar.gz,https://downloads.es.net/pub/iperf/,de8cb409fad61a0574f4cb07eb19ce1159707403ac2dc01b5d175e91240b7e5f))
+$(eval $(call tar_download,BASH,bash,5.1.16,.tar.gz,https://ftp.gnu.org/gnu/bash/,5bac17218d3911834520dad13cd1f85ab944e1c09ae1aba55906be1f8192f558))
+$(eval $(call tar_download,IPROUTE2,iproute2,5.17.0,.tar.gz,https://www.kernel.org/pub/linux/utils/net/iproute2/,bda331d5c4606138892f23a565d78fca18919b4d508a0b7ca8391c2da2db68b9))
+$(eval $(call tar_download,IPTABLES,iptables,1.8.7,.tar.bz2,https://www.netfilter.org/projects/iptables/files/,c109c96bb04998cd44156622d36f8e04b140701ec60531a10668cfdff5e8d8f0))
+$(eval $(call tar_download,NMAP,nmap,7.92,.tgz,https://nmap.org/dist/,064183ea642dc4c12b1ab3b5358ce1cef7d2e7e11ffa2849f16d339f5b717117))
 $(eval $(call tar_download,IPUTILS,iputils,s20190709,.tar.gz,https://github.com/iputils/iputils/archive/s20190709.tar.gz/#,a15720dd741d7538dd2645f9f516d193636ae4300ff7dbc8bfca757bf166490a))
-$(eval $(call tar_download,WIREGUARD_TOOLS,wireguard-tools,1.0.20200206,.tar.xz,https://git.zx2c4.com/wireguard-tools/snapshot/,f5207248c6a3c3e3bfc9ab30b91c1897b00802ed861e1f9faaed873366078c64))
+$(eval $(call tar_download,WIREGUARD_TOOLS,wireguard-tools,1.0.20210914,.tar.xz,https://git.zx2c4.com/wireguard-tools/snapshot/,97ff31489217bb265b7ae850d3d0f335ab07d2652ba1feec88b734bc96bd05ac))
 
 export CFLAGS := -O3 -pipe
 ifeq ($(HOST_ARCH),$(ARCH))
@@ -385,15 +385,15 @@ $(BASH_PATH)/.installed: $(BASH_TAR)
 	touch $@
 
 $(BASH_PATH)/bash: | $(BASH_PATH)/.installed $(USERSPACE_DEPS)
-	cd $(BASH_PATH) && ./configure --prefix=/ $(CROSS_COMPILE_FLAG) --without-bash-malloc --disable-debugger --disable-help-builtin --disable-history --disable-multibyte --disable-progcomp --disable-readline --disable-mem-scramble
+	cd $(BASH_PATH) && ./configure --prefix=/ $(CROSS_COMPILE_FLAG) --without-bash-malloc --disable-debugger --disable-help-builtin --disable-history --disable-progcomp --disable-readline --disable-mem-scramble
 	$(MAKE) -C $(BASH_PATH)
 	$(STRIP) -s $@
 
 $(IPROUTE2_PATH)/.installed: $(IPROUTE2_TAR)
 	mkdir -p $(BUILD_PATH)
 	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
-	printf 'CC:=$(CC)\nPKG_CONFIG:=pkg-config\nTC_CONFIG_XT:=n\nTC_CONFIG_ATM:=n\nTC_CONFIG_IPSET:=n\nIP_CONFIG_SETNS:=y\nHAVE_ELF:=n\nHAVE_MNL:=n\nHAVE_BERKELEY_DB:=n\nHAVE_LATEX:=n\nHAVE_PDFLATEX:=n\nCFLAGS+=-DHAVE_SETNS\n' > $(IPROUTE2_PATH)/config.mk
-	printf 'lib: snapshot\n\t$$(MAKE) -C lib\nip/ip: lib\n\t$$(MAKE) -C ip ip\nmisc/ss: lib\n\t$$(MAKE) -C misc ss\n' >> $(IPROUTE2_PATH)/Makefile
+	printf 'CC:=$(CC)\nPKG_CONFIG:=pkg-config\nTC_CONFIG_XT:=n\nTC_CONFIG_ATM:=n\nTC_CONFIG_IPSET:=n\nIP_CONFIG_SETNS:=y\nHAVE_ELF:=n\nHAVE_MNL:=n\nHAVE_BERKELEY_DB:=n\nHAVE_LATEX:=n\nHAVE_PDFLATEX:=n\nCFLAGS+=-DHAVE_SETNS -DHAVE_HANDLE_AT\n' > $(IPROUTE2_PATH)/config.mk
+	printf 'libutil.a.done:\n\tflock -x $$@.lock $$(MAKE) -C lib\n\ttouch $$@\nip/ip: libutil.a.done\n\t$$(MAKE) -C ip ip\nmisc/ss: libutil.a.done\n\t$$(MAKE) -C misc ss\n' >> $(IPROUTE2_PATH)/Makefile
 	touch $@
 
 $(IPROUTE2_PATH)/ip/ip: | $(IPROUTE2_PATH)/.installed $(USERSPACE_DEPS)
-- 
2.35.1

