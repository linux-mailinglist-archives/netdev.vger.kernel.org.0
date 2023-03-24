Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B176C83B8
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjCXRvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXRvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:51:51 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52F91B578;
        Fri, 24 Mar 2023 10:51:39 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id n2so2227523qtp.0;
        Fri, 24 Mar 2023 10:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ObJfsWBwfdyISOqoBrwJanxDZpkj5q/KTkNU2QoZ86U=;
        b=Xhval9kubc80Z+IQp+6r+OCFaTSwYYQPJ2P1VL5eFWRZmCVJtmjfTJU2sD+ALyb3OP
         6Cv+7g79/61SkksLs4OpFczc7uGk7qxYjiO2o6FmUK7P6TP02nAWzct5e4mI944obzQW
         bFhPAmkwzruaU9lcREc/Euv2hOpCMrXo0IuLTF29raDaes9CpNkLQOe0WFS6RKcY0sQG
         V3jZzsu9lFi2VueCSeEK8dxtJvXgdEHwCwIXhFnoBV+KrXujqK9uQDaFtjleel1njPDs
         d8yagcQdnpmdP4DREFscLODtuckyNnDokLeWMbmFEXDGmlLA+Nub7TPdVv2NtGs8Vv3o
         FUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ObJfsWBwfdyISOqoBrwJanxDZpkj5q/KTkNU2QoZ86U=;
        b=YfccQrQ9EBd3ySVTHbHsblqvknvuV2nZqG04m8fHKXOOCaaqMt7WzqC42NSUzX2Ryw
         HtFhy1T/8NwXuhjaul4WvKCvf0We/80KpANCr1DbGOXABAyMy6TUKQZr76/nhIngep8s
         j4Eb2zNSYxmKwgZmwsG2BbHDlpwILeNTXgkOK9vmPotiRXYZXCljOkUWRUbtsndBauHq
         R40PkR728ukCXCjckm5F3FuaHcOsL/3+qF8zoM5lB+jiDkE1alQTq923M2n2ajg5HZHE
         ZWLD5aDCGFRkIxEcR+H0TbS9Wg7qGlYuJxpWGiQh5evrHyXV3ym+8AnBi4xCTrtoggas
         Yu1w==
X-Gm-Message-State: AO0yUKV4WnD1Eo31fXUAvJlKNLnUu10U1WNDcS6n6Vg4zhcHJFXeG69B
        x0esoao003vwmv68gPyfeGM=
X-Google-Smtp-Source: AK7set9e9Z1VFwvskps8gPWHmu5B2v9idw7BvrjAbvcikUPWSS7vRI8fVd2ooGV7s4mdNZdi0xWn+A==
X-Received: by 2002:a05:622a:c6:b0:3b6:3995:2ec2 with SMTP id p6-20020a05622a00c600b003b639952ec2mr6891846qtw.19.1679680298756;
        Fri, 24 Mar 2023 10:51:38 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id 11-20020a37030b000000b00745a55db5a3sm8697645qkd.24.2023.03.24.10.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:38 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
Subject: [PATCH net-next v4 00/10] net: sunhme: Probe/IRQ cleanups
Date:   Fri, 24 Mar 2023 13:51:26 -0400
Message-Id: <20230324175136.321588-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, I've had these patches kicking around in my tree since last October, so I
guess I had better get around to posting them. This series is mainly a
cleanup/consolidation of the probe process, with some interrupt changes as well.
Some of these changes are SBUS- (AKA SPARC-) specific, so this should really get
some testing there as well to ensure nothing breaks. I've CC'd a few SPARC
mailing lists in hopes that someone there can try this out. I also have an SBUS
card I ordered by mistake if anyone has a SPARC computer but lacks this card.

Changes in v4:
- Tweak variable order for yuletide
- Move uninitialized return to its own commit
- Use correct SBUS/PCI accessors
- Rework hme_version to set the default in pci/sbus_probe and override it (if
  necessary) in common_probe

Changes in v3:
- Incorperate a fix from another series into this commit

Changes in v2:
- Move happy_meal_begin_auto_negotiation earlier and remove forward declaration
- Make some more includes common
- Clean up mac address init
- Inline error returns

Sean Anderson (10):
  net: sunhme: Fix uninitialized return code
  net: sunhme: Just restart autonegotiation if we can't bring the link
    up
  net: sunhme: Remove residual polling code
  net: sunhme: Unify IRQ requesting
  net: sunhme: Alphabetize includes
  net: sunhme: Switch SBUS to devres
  net: sunhme: Consolidate mac address initialization
  net: sunhme: Clean up mac address init
  net: sunhme: Inline error returns
  net: sunhme: Consolidate common probe tasks

 drivers/net/ethernet/sun/sunhme.c | 1155 +++++++++++------------------
 drivers/net/ethernet/sun/sunhme.h |    6 +-
 2 files changed, 418 insertions(+), 743 deletions(-)

-- 
2.37.1

