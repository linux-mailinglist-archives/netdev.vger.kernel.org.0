Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3F962ECA1
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbiKRED3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240943AbiKREDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:03:09 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A56C92B4B;
        Thu, 17 Nov 2022 20:03:05 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id l6so1989599ilq.3;
        Thu, 17 Nov 2022 20:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcBCb8p6Ke04G+L5YkAtVxarhoVESQcZzJlU+faln5M=;
        b=XUYZBWnGPluHgdH1liV0yvGANEdHg/aoOHkdxGu6BjgS/4EBKBg1VwlSq8/brYT2SA
         eA4ZeNpM2OVSGY0QMeV+f7Nxz4137yNRC7HN9hXa+FNEi3yENjgu0edDyRmaGFsfCIdX
         TEFWgJenBDiwdgwbRoDo+pmqz45bDiMeCJDwmxbUxtwkUebtfZ6V84ucnRuyc5aWc9Af
         fGuf1ZiWVR065e0wnc4pZkDrAownlsQ2pHkeeprQnfAIpptM+bKasExvx4A2jPjL47iI
         ih/I3YFiUeXcCi2e20JqyeMIXWINLLIQOKWZyaGcfS6WMv9p3K547kbPmr13GOm0Zmye
         YzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcBCb8p6Ke04G+L5YkAtVxarhoVESQcZzJlU+faln5M=;
        b=BUAk0pEiapvE8D41IGfR6VfncEkxP9Rumfi15DFK/OLyCybCknQXq96m3llGExSz01
         xxaka+fhUuXGCesi5DF85WcVpo6/8tCoww/d87gQwzepEQjHf0PTxPy3vDp67GK182+W
         ITYvDRKXrslouDD1VKard7gp8be8wBReyhsnEQQT8KcCT2Bj8Km9ATIBVuieZMEcjXd7
         6hiA0dTvFekp5UZvmafRiamB7PFpUFCr2C4YtFgWbsGSCoSu880GtOSiTCu3g4KaptGR
         adNc55f4r6//JfE3mijbxawq2ZyJ9qppRcb45Qr2gQ5AXaN0JE0R5Ewf25raA6H6+pEV
         8cyw==
X-Gm-Message-State: ANoB5plua6e/bVNbZxntOpBb00LB7TsfEgRUfcvb+j3Jps7y5M6OGcrZ
        iWMD2+6opFcRvOTP4r9HhxNGdh0uwmneJ7/7
X-Google-Smtp-Source: AA0mqf4FQwB3reF3z5ME2qvS47nDC8ttY3S07QpZAgRnrEyMAtIox7BgDLg9D03dNUP/U3k6dEhZWg==
X-Received: by 2002:a92:d842:0:b0:302:a7d8:d7bd with SMTP id h2-20020a92d842000000b00302a7d8d7bdmr645972ilq.5.1668744184396;
        Thu, 17 Nov 2022 20:03:04 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id m14-20020a92710e000000b0030014a5556bsm901741ilc.69.2022.11.17.20.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 20:03:03 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: [BUG 3 / 6] L2cap: Spec violations
Date:   Thu, 17 Nov 2022 23:02:56 -0500
Message-Id: <20221118040256.630441-1-git@sung-woo.kim>
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

3. BT_CONNECT2 -> BT_DISCONN by L2CAP_CONF_RSP

btmon log:

Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.240003
= Note: Bluetooth subsystem version 2.22                               0.240035
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 14.266186
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0001} [hci0] 14.282303
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0002} [hci0] 14.282303
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
= bluetoothd: Failed to obtain handles for "Service Changed" char..   14.362392
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #33 [hci0] 14.283096
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 01 02 00 00  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 14.299480
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 02 00 ff ff  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 14.300143
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 01 00 00 01  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #36 [hci0] 14.300750
        invalid packet size (14 != 1547)
        0a 00 01 00 05 01 06 00 40 00 ff ff 01 00        ........@.....  
