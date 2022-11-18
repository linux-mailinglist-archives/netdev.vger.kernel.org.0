Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B8462EC9E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbiKRECy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiKRECw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:02:52 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E4891C04;
        Thu, 17 Nov 2022 20:02:51 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id d123so3002591iof.7;
        Thu, 17 Nov 2022 20:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRwFjH5ZK5pElfz8avNd+GS81npN/0yLxJtOuth1gt0=;
        b=NWIZzVq0ENHboDbMUDI3jyhpKUqoMSM3tvmB0jFWb5pO752TvNE/lY0OLUZKN/9uyO
         NCmULluNN0uzu7ijxD58GUv8OxP+gpKxJN1/L4N59rnYQkiMuE4S//WANSruGZmpgk1e
         fuDUWA4E9D8t83HFFRJ29ENfe6LAv2iauE2GeYTo5qWqa9YhNg+zFXEQTTifEyxHSWQp
         Q5O7EEt27/1DYSgmGAB3OySltBMURJguWcdC9vocwVOeSM5Gr8F3mUMJeoYannklIGJz
         XXc5dzBMzCzkdM2/LmI/g9M23W4qyuCpXLXtdDqAboKMaTijAqldrLALXCPLrJkiZnQD
         fdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRwFjH5ZK5pElfz8avNd+GS81npN/0yLxJtOuth1gt0=;
        b=pY3Jpht8DRRXCQer+8HJe1bqi894oz2P3ARfgtcalExdUKYE6i4WajJB8l+VUb1qnH
         cAbUJElggsYNHIsVMZ/nNxmN/uX9IZvDlITXCtriAa1IgFV4rHEX1MdUApVNp2VCOZ/c
         jypiN2wdHG63YLRke4JUAAVPj8+RGGej18H+7jKsN1exnfyWVV41CNGHiPq7Skc7R3rT
         serejXgshyyZudlVPlAgsas5F56Ohcaq2muwh09Qg5kCgdKUiAFUiDs5l2ZFNko0cTrW
         WXL1nNtYvHCC9rl+sA6ai4tIbbURw+jLK1FBjWmuk+57mfGTKLK32uU9TjC5+nOhfdVU
         +d7w==
X-Gm-Message-State: ANoB5pkoIgCVt755OKl5DACDROYI0n1U57WJQSz59p5PPJiMBk8khSP/
        hBAHijz3T2DyJhneEsEPBVU=
X-Google-Smtp-Source: AA0mqf62OpNCs5dRXZEeCFiJW3NOBafjP4uyCGfvFfQdcWdQtUNs7SkQ8k4vvBxy4ZGMxq3ptvi2CQ==
X-Received: by 2002:a05:6638:4410:b0:363:aec1:9a04 with SMTP id bp16-20020a056638441000b00363aec19a04mr2475496jab.78.1668744170581;
        Thu, 17 Nov 2022 20:02:50 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id n19-20020a02a193000000b00374da9c6e37sm878966jah.123.2022.11.17.20.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 20:02:49 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: [BUG 2 / 6] L2cap: Spec violations
Date:   Thu, 17 Nov 2022 23:02:41 -0500
Message-Id: <20221118040241.630093-1-git@sung-woo.kim>
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

2. BT_CONNECT2 -> BT_CONNECTED by L2CAP_CONF_RSP

btmon log:

Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.240003
= Note: Bluetooth subsystem version 2.22                               0.240035
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 23.498353
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0001} [hci0] 23.498635
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0002} [hci0] 23.498635
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
= bluetoothd: Failed to obtain handles for "Service Changed" char..   23.555719
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #33 [hci0] 23.527295
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 90 00 07 00  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #34 [hci0] 23.538671
        invalid packet size (14 != 1547)
        0a 00 01 00 05 01 06 00 40 00 00 00 00 00        ........@.....  
