Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA5562ECA7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbiKREEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbiKREDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:03:51 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F51DB3;
        Thu, 17 Nov 2022 20:03:43 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id 11so3049937iou.0;
        Thu, 17 Nov 2022 20:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLOjd19Po3ZHEAHRm7KOiL/e/xOfXzMJmiqJ2OprEg0=;
        b=Nc6RCgZ5eooqaOcQ4tuhEuQYxm2wMVrPjpr1JGrfCgvcLHET+PyNxSPl2ERk2Sk0Rd
         RurB4S89459IPs26RK9m3wX7McDR5AeRCK0eKP32hdKvZIx83ZuLbPKTG1W9DjPV2Zgy
         bPMTQHzNuPdr78uxcMW//nuHwghZSmbtOopPTFabedU3HQSz/ot/WmLVUvCkCMkUFnNb
         jSn39to5b74w/HXO4WYLLCTXBOWac5wc69wAQpxqviOFepiy53v5FwlQUGRTBf/cnmiK
         zZzZrOb2jX9n5rMTYba/zh2F9D2JyeeMV/QXvtJLjedRdGGjMApyTDsRujhN4XabA47J
         kf8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLOjd19Po3ZHEAHRm7KOiL/e/xOfXzMJmiqJ2OprEg0=;
        b=T1xRVQcXCVE+/YM2PXzKjM+h2wG+U2fO3nZjajLSixiw8C0Y5Du+Or3TuxzDcq8b1F
         UAtKL+N2OGl8aEzQGqcTGoSzGVM/76okhu+XXK14Abf/3UyvT/2xQmr3E4Q7Yh5ztdLK
         soS7MuPVB+pg0kNjHVJAG39o/SfATR4mTMBF6JTEuhFCi+m/aRuNCYF4Dg53k+4CAF9S
         M9ULIGWX++DDgyaatGeGKtCUQQfPVSAk0tyEcnS7ia+rotKp2HOk/JfvYfhJRkSZOIW/
         fJ6PW4v2XzghzURgrqDqVRc4l0NLM2w1WxL6BVd9TQPaiW+S2seF7sj5jvKDUkVw/E6Q
         +PSQ==
X-Gm-Message-State: ANoB5pkhWkLOPAOT+07mgkI+xAtfdwNRDkYyeYkykijWe5+Irgx2GSrO
        TkDSqM2QAVl+/eU3mnFZL+w=
X-Google-Smtp-Source: AA0mqf5P+Adxf1Pv2yxLl/eHjRKBS3RxhOGj4IQRP43FhHrq0anrdwJCTpkvHXmNYzrzCpvVYJZc7Q==
X-Received: by 2002:a02:93e5:0:b0:375:8bcb:a4e9 with SMTP id z92-20020a0293e5000000b003758bcba4e9mr2406923jah.228.1668744222364;
        Thu, 17 Nov 2022 20:03:42 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id x63-20020a0294c5000000b003753c068a41sm841600jah.115.2022.11.17.20.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 20:03:41 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: [BUG 5 / 6] L2cap: Spec violations
Date:   Thu, 17 Nov 2022 23:03:34 -0500
Message-Id: <20221118040334.631153-1-git@sung-woo.kim>
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

5. BT_DISCONN -> BT_CONFIG by L2CAP_CONN_RSP

btmon log:

Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.240003
= Note: Bluetooth subsystem version 2.22                               0.240035
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 11.525124
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0001} [hci0] 11.546310
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0002} [hci0] 11.546310
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #33 [hci0] 11.540575
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 02 00 00  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 11.543844
        invalid packet size (16 != 2061)
        0c 00 01 00 03 01 08 00 00 00 00 00 00 00 00 00  ................
