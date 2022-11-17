Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3564162E533
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 20:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiKQTZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 14:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240151AbiKQTZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 14:25:35 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E240D7C03F;
        Thu, 17 Nov 2022 11:25:32 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id t1so2106345wmi.4;
        Thu, 17 Nov 2022 11:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZmg9eU02dztT0bMJhjJcCh58+tIuhR14Ezkf+QZKaA=;
        b=ZB+nDURRcTpbgUf075xI0DrxVcI/+BZ2qTVobfEEouDjkyw/b2kNuWEtFglOgqapmu
         WXRVVf8m5QJK215xoTnKRdqI9Id/G2b8Fb7zQ2zjzmCk+WxxilV12eOcbhM7/84IBPaN
         4u5QQu+6ns8L9M+QIn5owmJpVoUJI9yo3Z9XeMPDh+UCmJTZoS7QyThb1fj2fp3XuZfU
         J+7U2QcsoRpgPhcbVB4YeWMtHOFrKzaWsN7TlN2uLIZOFec9eatBsjZo1FC3EoGd9+Pp
         9TJe0mZgHUmxYVx/PDvjtCT/3twp826Za4Dyso61Ni6NozG7vH7ugrmSolX16DAyxJb0
         Brjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZmg9eU02dztT0bMJhjJcCh58+tIuhR14Ezkf+QZKaA=;
        b=ElTp2lZoon61Z+4Tpk96BRPvlTsZUPRGoBHlUQkPWz0rU7QlBAyt3OqtUB1WHl/bWs
         pp1ZIv7+WBo8NnQEPaADk0CMNoStjjFly5sSm8MmuhHKQUhKV0/3ZGELYSj2ueQCrZaz
         asQxAWXyWofjrSu7eQH37UJqPQR7iHBQH3Cnd3yvm2mEF36HpRQU7OkT0fOOxh6XzLdW
         mjcNgZpdF/7/cRFuNdQZG85aJ/6VoodV/yE/SfVQ0xftf7g/ZqcX83FNRvhh34269cyJ
         k4Ci3qvVGF/ywevcwEOA+uI83xZTbLFYGSaQw+zY+G5z883ecEyXAHoC06AfHYH/LFhi
         zYUg==
X-Gm-Message-State: ANoB5pkiPvP6suzAXL9YUTzshEf3duqX3kDFmkiEn171B83HHENau/XJ
        MP9QRSObKMvxtHxTwMQ6bzA=
X-Google-Smtp-Source: AA0mqf6TptJ8+ZE43/TQ2OnxBdYCBWgOcoAGWgr6kyLYmMlms6k6UnsrpyPDylYuKDAQY7OEZUwBYA==
X-Received: by 2002:a05:600c:3b84:b0:3cf:b73f:c062 with SMTP id n4-20020a05600c3b8400b003cfb73fc062mr6233948wms.204.1668713131290;
        Thu, 17 Nov 2022 11:25:31 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id i14-20020adff30e000000b002368a6deaf8sm1700730wro.57.2022.11.17.11.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:25:30 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 17EC1BE2DE0; Thu, 17 Nov 2022 20:25:29 +0100 (CET)
Date:   Thu, 17 Nov 2022 20:25:29 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: passing
 argument 3 of 'dma_alloc_coherent' from incompatible pointer type
 [-Werror=incompatible-pointer-types]
Message-ID: <Y3aKqZ5E8VVIZ6jh@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,TVD_SPACE_RATIO autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

While preparing 6.1-rc5 for Debian, we noticed that compilation of
drivers/net/wwan/iosm/iosm_ipc_protocol.c fails (with
-Werror=3Dincompatible-pointer-types), on armhf[1]:

   gcc-12 -Wp,-MMD,drivers/net/wwan/iosm/.iosm_ipc_protocol_ops.o.d -nostdi=
nc -I/<<PKGBUILDDIR>>/arch/arm/include -I./arch/arm/include/generated -I/<<=
PKGBUILDDIR>>/include -I./include -I/<<PKGBUILDDIR>>/arch/arm/include/uapi =
-I./arch/ar
m/include/generated/uapi -I/<<PKGBUILDDIR>>/include/uapi -I./include/genera=
ted/uapi -include /<<PKGBUILDDIR>>/include/linux/compiler-version.h -includ=
e /<<PKGBUILDDIR>>/include/linux/kconfig.h -include /<<PKGBUILDDIR>>/includ=
e/linux/compiler_types.h -D__KERNEL__ -mlittle-endian -fmacro-prefix-map=3D=
/<<PKGBUILDDIR>>/=3D -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-trigrap=
hs -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=3Dimplic=
it-function-declaration -Werror=3Dimplicit-int -Werror=3Dreturn-type -Wno-f=
ormat-security -std=3Dgnu11 -fno-dwarf2-cfi-asm -mno-fdpic -fno-ipa-sra -ma=
bi=3Daapcs-linux -mfpu=3Dvfp -funwind-tables -mtp=3Dcp15 -marm -Wa,-mno-war=
n-deprecated -D__LINUX_ARM_ARCH__=3D7 -march=3Darmv7-a -msoft-float -Uarm -=
fno-delete-null-pointer-checks -Wno-frame-address -Wno-format-truncation -W=
no-format-overflow -Wno-address-of-packed-member -O2 -fno-allow-store-data-=
races -Wframe-larger-than=3D1024 -fstack-protector-strong -Wno-main -Wno-un=
used-but-set-variable -Wno-unused-const-variable -Wno-dangling-pointer -ftr=
ivial-auto-var-init=3Dzero -fno-stack-clash-protection -pg -Wdeclaration-af=
ter-statement -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-stringop-tr=
uncation -Wno-stringop-overflow -Wno-restrict -Wno-maybe-uninitialized -Wno=
-array-bounds -Wno-alloc-size-larger-than -Wimplicit-fallthrough=3D5 -fno-s=
trict-overflow -fno-stack-check -fconserve-stack -Werror=3Ddate-time -Werro=
r=3Dincompatible-pointer-types -Werror=3Ddesignated-init -Wno-packed-not-al=
igned -g -fdebug-prefix-map=3D/<<PKGBUILDDIR>>/=3D -mstack-protector-guard=
=3Dtls -mstack-protector-guard-offset=3D1592 -I /<<PKGBUILDDIR>>/drivers/ne=
t/wwan/iosm -I ./drivers/net/wwan/iosm  -DMODULE  -DKBUILD_BASENAME=3D'"ios=
m_ipc_protocol_ops"' -DKBUILD_MODNAME=3D'"iosm"' -D__KBUILD_MODNAME=3Dkmod_=
iosm -c -o drivers/net/wwan/iosm/iosm_ipc_protocol_ops.o /<<PKGBUILDDIR>>/d=
rivers/net/wwan/iosm/iosm_ipc_protocol_ops.c =20
/<<PKGBUILDDIR>>/drivers/net/wwan/iosm/iosm_ipc_protocol.c: In function 'ip=
c_protocol_init':
/<<PKGBUILDDIR>>/drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: p=
assing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-=
Werror=3Dincompatible-pointer-types]
  244 |                                    &ipc_protocol->phy_ap_shm, GFP_K=
ERNEL);
      |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~
      |                                    |
      |                                    phys_addr_t * {aka unsigned int =
*}
In file included from /<<PKGBUILDDIR>>/include/linux/skbuff.h:31,
                 from /<<PKGBUILDDIR>>/drivers/net/wwan/iosm/iosm_ipc_imem.=
h:9,
                 from /<<PKGBUILDDIR>>/drivers/net/wwan/iosm/iosm_ipc_proto=
col.c:6:
/<<PKGBUILDDIR>>/include/linux/dma-mapping.h:421:29: note: expected 'dma_ad=
dr_t *' {aka 'long long unsigned int *'} but argument is of type 'phys_addr=
_t *' {aka 'unsigned int *'}
  421 |                 dma_addr_t *dma_handle, gfp_t gfp)
      |                 ~~~~~~~~~~~~^~~~~~~~~~
cc1: some warnings being treated as errors
make[8]: *** [/<<PKGBUILDDIR>>/scripts/Makefile.build:255: drivers/net/wwan=
/iosm/iosm_ipc_protocol.o] Error 1
make[8]: *** Waiting for unfinished jobs....

Regards,
Salvtore

[1]: https://buildd.debian.org/status/fetch.php?pkg=3Dlinux&arch=3Darmhf&ve=
r=3D6.1%7Erc5-1%7Eexp1&stamp=3D1668648913&raw=3D0
