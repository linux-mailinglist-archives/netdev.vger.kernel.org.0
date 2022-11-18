Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F7B62EC92
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbiKRD4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiKRD40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:56:26 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A623991C0C;
        Thu, 17 Nov 2022 19:56:21 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id y6so2985523iof.9;
        Thu, 17 Nov 2022 19:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fR4mX56J+mx+m1BPxm/dozuQXvrdfsWxHFr0CD5+z9o=;
        b=mC61TnyX4uEh1UcVFalGgp1QVmRCPIL3h+KGbB8Lfibt5IKISvzGQEH5pcr7TKXaKn
         5YO1yZwm2XNgvrU8ayDLP8UNnAGXXotblpLFfWUDCXU+LVgnf7UI8H9tuRU5AJAsb1HZ
         tCmQ/8E2bgX2F/lrDITHUkDwqJit/wZomJ6vxBPfhBJEGyFjvCX6fONejRgO2JCwuRHg
         Rc/LbOtfSDuXDL4KGtlML4rE/+FzmHeiVU4Korbtvzawgh41tqkKCYcOaBJbnUgaLkJ1
         FuIey3C8Z7orxAulqSUb1GSZr6m28o/fAqPnixfdMblw/3mWs5wASOUZOoXdfFchIZUS
         GV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fR4mX56J+mx+m1BPxm/dozuQXvrdfsWxHFr0CD5+z9o=;
        b=czn+YasBkXE8SKo4xEEk+FwIpDDNphzGRh+5MUDGKjm+gIdqY260dAwYVoTS4AK30c
         9qG3tKZkmQNTJK+T72C3er65ENMFnuVRb4vSjRQNUVttCspZpft4sxmMHMMqifQJZien
         V8pTat+MrcISNy4XihyON4mUve7j2oveUWX/UWSl5tIl1tCyE0lj9EH7fXvK/zamI96c
         wn/8ZkEH7miJmJEsFfSK0nfSVrebM/ZIXxzOTXOduW47a5V8AsLyc7zbqboSUlYJ1wac
         COOGlWK+Il3Pp6vXzrFtmpwFvYURLVLCNvubk9u25dPUsyWyDMI3ud53hZpsA/GW65sL
         TTfg==
X-Gm-Message-State: ANoB5pkHBPN812vLDlnAYo9TiTuJNHorsDXG75GjVvBaB62jlR8tDsu3
        cE0A6K13jAc2eG1DAUd0mZfcqLkX/qH2QV7R
X-Google-Smtp-Source: AA0mqf4WPcfAxMj7jT7EAVP3dM6vNOC9c3reYDUxz3zo0RnAn6J6GNoWJsccyAYN4JO/8UmiwQNZ7Q==
X-Received: by 2002:a05:6638:224:b0:363:a3ca:acb6 with SMTP id f4-20020a056638022400b00363a3caacb6mr2382493jaq.265.1668743781027;
        Thu, 17 Nov 2022 19:56:21 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id m11-20020a0566022e8b00b0068869b84b02sm983702iow.21.2022.11.17.19.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 19:56:20 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: [BUG 1 / 6] L2cap: Spec violations
Date:   Thu, 17 Nov 2022 22:55:58 -0500
Message-Id: <20221118035558.621680-1-git@sung-woo.kim>
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

1. BT_CONNECT2 -> BT_CONFIG by L2CAP_CONN_RSP
btmon log:

Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.240003
= Note: Bluetooth subsystem version 2.22                               0.240035
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 15.924193
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0001} [hci0] 15.935617
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0002} [hci0] 15.935617
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #33 [hci0] 15.942943
        invalid packet size (16 != 2061)
        0c 00 01 00 03 01 08 00 00 00 00 00 00 00 00 00  ................
