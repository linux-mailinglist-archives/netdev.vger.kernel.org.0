Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFD62ECAA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbiKREFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbiKREEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:04:15 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DB97211E;
        Thu, 17 Nov 2022 20:04:04 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id p184so2989249iof.11;
        Thu, 17 Nov 2022 20:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kp+CpBikoq7v7LDCymqAU9BTzEWUsL4lrRHtYTDMf/8=;
        b=jDaf1iUApXLyFakz6vU/1UohPbjS/Hj0mVlItftiqj+QeWpPtIhRH/yiQ/5GJwNJ7w
         g3I953xz3sIBS/76qp9UG2KXRP6biiRHTDS4ojsveXDS63j/QOjAQI8BhTfTkFhPj6fn
         LMad3txbDAJUvmPtWuoqZXzO4tdtKeObHc7OjK/fS3+nvM8sv16jCfkfvT2iRfZMdOYA
         hUoOracaeQLGh8rchGuISe6lpj/AinAW2Wdzh0hYuxhwvqk0IGgXr/me6FSFYk/YndCL
         mGIfNRKriCxEz3CeJDUwHSULbJJYdQayFBp9LKbGUeO/OnF+AR4KKh6nXHd+Z6MTNRXk
         jyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kp+CpBikoq7v7LDCymqAU9BTzEWUsL4lrRHtYTDMf/8=;
        b=m6OxYk1eeNM4+hpi3TnxxD+/jq6oKFZgBz7GSPhhNGsEqjKAeT2OQ5vN2Vsusgth7O
         MnTn12JUaEH3MvTYNTwAhF+p//Isro9HUBh1sqQw4i22OPJ+Wkf6ARLWNG4CFWsR03T0
         fRjd26uEZM1uqXTJt9nk18nS7ZET27Z7VG/x5iC9qvJCGGQ9J1pdOHNH1GrqC5WX0/JO
         6zljs/SEHzu0e9/knaTC3pJRRlhtDG7y7zVVxgNgizxnXr10EJT9K+odvtZj7rHOmrCf
         VRQATITdTXIJbULYsqit2KUrB1xKnEvT+iSLAFdZUIdprGe02pdUsSyC1bx5zBx/CWna
         oqkw==
X-Gm-Message-State: ANoB5pnSKBpfCZi2Ph/5GswjKMKYE9GbX1F9BJqxe6MgLo8Obiw88bOs
        ehYK9drF/sU7TG9x0geCzdbZ61IVVYIqJ5wp
X-Google-Smtp-Source: AA0mqf7oEx7b4s4K4gTpLEbYP42vgEatxvVDspJsVnlisiXvE6khKtj+OgwadYNafHOMqCNIdInBig==
X-Received: by 2002:a5e:9405:0:b0:6a1:48d3:149e with SMTP id q5-20020a5e9405000000b006a148d3149emr2822687ioj.136.1668744244214;
        Thu, 17 Nov 2022 20:04:04 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id w186-20020a022ac3000000b003717c1df569sm847028jaw.165.2022.11.17.20.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 20:04:03 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: [BUG 6 / 6] L2cap: Spec violations
Date:   Thu, 17 Nov 2022 23:03:56 -0500
Message-Id: <20221118040356.631678-1-git@sung-woo.kim>
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

6. BT_DISCONN -> BT_CONNECTED by L2CAP_CONN_RSP

btmon log:

Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.240003
= Note: Bluetooth subsystem version 2.22                               0.240035
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 12.777814
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0001} [hci0] 12.797646
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13       {0x0002} [hci0] 12.797646
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #33 [hci0] 12.778616
        invalid packet size (16 != 2061)
        0c 00 01 00 03 01 08 00 00 00 00 00 00 00 00 00  ................
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 12.778858
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 00 00 01  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 12.778882
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 02 00 00  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #36 [hci0] 12.778905
        invalid packet size (14 != 1547)
        0a 00 01 00 05 01 06 00 40 00 00 00 00 00        ........@.....  
