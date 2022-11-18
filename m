Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC3B62ECA4
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiKRED4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240959AbiKRED3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:03:29 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB9191C1C;
        Thu, 17 Nov 2022 20:03:22 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y6so2993996iof.9;
        Thu, 17 Nov 2022 20:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLfrKv8JExwIFtvfSGqCdlDudy44JAqaCgm/PSSNv6A=;
        b=nbIzbnltrfD/sYmRAvakU/iH2muFHCxoWwORs4gjVHc6xUg4YO7NxOAK5cMA1KgnD5
         JHP5DEjutHDvJVLrEz2zu2ARy8v44YQ1GbtlQVw4jfrM5uTpDYGmFF7ZXTjPE6wx1j5r
         uuuevjcAVPBWPEATl3GpValWZ3ywSciVrt/iZai7xyXh/rcdZyDIcgSKCz+Lit5J7OKd
         DFqhfWiv9++vvjr3sdT1eZZze0VsFEWvFOVDCmwDTeh5VLRSbC9odPx9isM5JSXqdpZ9
         zNnomX54Ib900q28LVeArBM5BirbIcsOgz9mvQR+qxnOSpSXGXd2Cw0xTzPsgeHc4APp
         66Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YLfrKv8JExwIFtvfSGqCdlDudy44JAqaCgm/PSSNv6A=;
        b=Ds4P/wcfK64vjNnWRdpaCMxO4Du5t+bzZXeF/QQr77luB3jvsODLW61xMoLIURJbU3
         7VmUFytxX/kR9op/KbEwdE9jEBZL5HVQamT4d5ZTV2ZP1LDSigi3WczeEGdPzd92BzYZ
         ZC1aGOmwOTGngAt8i1n0ExWVkq4KbB7FWdDYU/Lf+5PT6CMbbY2f6zGrLp9s9jURBZzr
         s98gktNLbUoq3c1fetvMrMIrAyJJuLmv8O5gAlCl2O+ZZRzgVsoiCWZiEiJwLw/0QJUX
         wVK6gmJuYlo8pwqxXinNTaRkPbPQAQfhpOUi5SnJ7JNcErpAp7qFqf+/pfsg1pwcQV4G
         I6VQ==
X-Gm-Message-State: ANoB5ploRcOd6a7TemqPl8kkrJRiAYOlbtK8btRVI7djF3U46I0MYX1V
        3zVlSkWvRiapYuYGBH5WHIM=
X-Google-Smtp-Source: AA0mqf7dYNu7l8W+7ECYYLZejEjRkLHGKsPaPsBBqJvBj9g0E3mp3ukvQn4TjUozv9KqtQoapToaew==
X-Received: by 2002:a6b:c990:0:b0:6dd:807d:89a3 with SMTP id z138-20020a6bc990000000b006dd807d89a3mr2880489iof.33.1668744201523;
        Thu, 17 Nov 2022 20:03:21 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id o14-20020a6bcf0e000000b006a4ab3268f3sm962652ioa.42.2022.11.17.20.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 20:03:21 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: [BUG 4 / 6] L2cap: Spec violations
Date:   Thu, 17 Nov 2022 23:03:13 -0500
Message-Id: <20221118040313.630791-1-git@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAJNyHpKpDdps4=QHZ77zu4jfY-NNBcGUrw6UwjuBKfpuSuE__g@mail.gmail.com>
References: <CAJNyHpKpDdps4=QHZ77zu4jfY-NNBcGUrw6UwjuBKfpuSuE__g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

4. BT_CONNECTED -> BT_CONFIG by L2CAP_CONN_RSP

btmon log:

Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.240003
= Note: Bluetooth subsystem version 2.22                               0.240035
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 12.003575
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0001} [hci0] 12.024700
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0002} [hci0] 12.024700
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
= bluetoothd: Failed to obtain handles for "Service Changed" char..   12.049885
> ACL Data RX: Handle 200 flags 0x00 dlen 1804             #33 [hci0] 12.003613
        invalid packet size (15 != 1804)
        0b 00 01 00 04 01 07 00 40 00 00 00 05 01 00     ........@...... 
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 12.004416
        invalid packet size (16 != 2061)
        0c 00 01 00 05 01 08 00 40 00 00 00 01 00 ff 80  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 12.004968
        invalid packet size (16 != 2061)
        0c 00 01 00 03 01 08 00 00 00 00 00 00 00 00 00  ................
