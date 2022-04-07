Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C314F6F0E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 02:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiDGAWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 20:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiDGAWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 20:22:42 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C372D10F6C6;
        Wed,  6 Apr 2022 17:20:44 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q14so5389744ljc.12;
        Wed, 06 Apr 2022 17:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fPL5UsO46k1n35sRE5ciyvqxVhi7l/tWrtW2KEPi9Ro=;
        b=evf4Tgxs70NV/0Vu5ktz/JH7VDY5A1zCNJbnWEYu/V3WqH9cnS5020j2/pRidFQ667
         JCLVRMJq9h1xHP0HmYhxqHGDlQLniBhULdMHezX2LpSlHxbaKJZ9kX65zZUDT2r32uWo
         Zboh/AsyzFJRzUBGibpUd5ZVDYLpkB7q1nK3vfUCAJJdXrPZv5gYfRoB/EMxhrQ9EzcA
         ua6wA6aOYhdNaPtXRhBxFTmxyU/l+/wEkE6T39li/drFuK98NjhIrKcScJcL5TZxExk7
         1o5dS20voS9GnaMfJpYYLO/UI2IU/xnLr5f0mXApjEzqnDOHQdd2c1bJzDurDYEcClQL
         xYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fPL5UsO46k1n35sRE5ciyvqxVhi7l/tWrtW2KEPi9Ro=;
        b=6DjStxod2Y/Mt/VbWda9uv1ihPjA6L9sj00wkZW4iY+xqpbA1yqJSMaxxlnCJ6wuwd
         e5agIFbBqhlbI2u9SmZN5Nr0UEM/h5QhvLiJ39UxYdDkQGEEnH8+ISAXLMeRXJRKt8x3
         RwHA5tEBQ0aHA2oyCKqcKLBkE/imub/o8x0QE4ot0Qh09KRLOeY2nijys0EbkPa07Tu+
         20Loo58WHIrqpYWVImfh5paz4R7QMdoiEtGGS02Hkw+GK27FtRkp4jrPquwTa0k93Zb4
         Nyd/ST97DLIotzGtMsAk+wS2bcz0BXZHC+Lwvj50DI1XPVkW5aBP0gKLs5oqYEFqbzuV
         4v4g==
X-Gm-Message-State: AOAM530PdVSaNjYcIQvVUO5jAvQV3fFYkYsQYXTIa/wnTj2k4hYt6c2d
        J6YWNY+8h2GgobmJL0lMOWQOnWxcUqU=
X-Google-Smtp-Source: ABdhPJxJYBR4czyThyg9Oh8GCRr6XRa2kKxkRg9yvw3OW+kig1X2meb86xLEV+vxsBTyI4YIk075OA==
X-Received: by 2002:a2e:a372:0:b0:249:7108:6778 with SMTP id i18-20020a2ea372000000b0024971086778mr7110626ljn.403.1649290842859;
        Wed, 06 Apr 2022 17:20:42 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id n12-20020a2e86cc000000b0024b121fbb2csm1413879ljj.46.2022.04.06.17.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:20:42 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 0/3] rndis_host: handle bogus MAC addresses in ZTE RNDIS devices
Date:   Thu,  7 Apr 2022 02:19:23 +0200
Message-Id: <20220407001926.11252-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When porting support of ZTE MF286R to OpenWrt [1], it was discovered,
that its built-in LTE modem fails to adjust its target MAC address,
when a random MAC address is assigned to the interface, due to detection of
"locally-administered address" bit. This leads to dropping of ingress
trafficat the host. The modem uses RNDIS as its primary interface,
with some variants exposing both of them simultaneously.

Then it was discovered, that cdc_ether driver contains a fixup for that
exact issue, also appearing on CDC ECM interfaces.
I discussed how to proceed with that with Bjørn Mork at OpenWrt forum [3],
with the first approach would be to trust the locally-administered MAC
again, and add a quirk for the problematic ZTE devices, as suggested by
Kristian Evensen. before [4], but reusing the fixup from cdc_ether looks
like a safer and more generic solution.

Finally, according to Bjørn's suggestion. limit the scope of bogus MAC
addressdetection to ZTE devices, the same way as it is done in cdc_ether,
as this trait wasn't really observed outside of ZTE devices.
Do that for both flavours of RNDIS devices, with interface classes
02/02/ff and e0/01/03, as both types are reported by different modems.

[1] https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=7ac8da00609f42b8aba74b7efc6b0d055b7cef3e
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bfe9b9d2df669a57a95d641ed46eb018e204c6ce
[3] https://forum.openwrt.org/t/problem-with-modem-in-zte-mf286r/120988
[4] https://lore.kernel.org/all/CAKfDRXhDp3heiD75Lat7cr1JmY-kaJ-MS0tt7QXX=s8RFjbpUQ@mail.gmail.com/T/

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>

Lech Perczak (3):
  cdc_ether: export usbnet_cdc_zte_rx_fixup
  rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
  rndis_host: limit scope of bogus MAC address detection to ZTE devices

 drivers/net/usb/cdc_ether.c  |  3 ++-
 drivers/net/usb/rndis_host.c | 39 ++++++++++++++++++++++++++++++++----
 include/linux/usb/usbnet.h   |  1 +
 3 files changed, 38 insertions(+), 5 deletions(-)

-- 
2.30.2

