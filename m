Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29805271CC
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 16:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiENORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiENORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 10:17:17 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B81065E1;
        Sat, 14 May 2022 07:17:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i1so10499195plg.7;
        Sat, 14 May 2022 07:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/B05woazaNTKLTLtPwugar1HdWn2AdCEosSVbjTNf2o=;
        b=b9bJgtPy9jyFU+wts0jpzik1pZ8Ci2U2VLKLHrvLmxk/reqIVCUKfJMceu1FRAacMb
         vggtTXJ0L1fkGn8e/FF6y9g9dWgFPsOK0VmNxCw7x9eJ5lghW87WJyGlKEDCjehSbhtq
         L4Bt0C6+4LgCbZP8p2BItOaxrjh9cvXy1jwzrluq2nAAAnwE3JAYe0cBGMtfz0+c2Yk1
         ruNBaN5b6LUHpSwXAC3G4A0uMQzi72T+WGnQnqIv0zn/+YNggti828nZpLD9DFKVv0X3
         wQ2Dz4BUJP4FXcmMV6TQ+bD29S+qGBnHgAeiZUHfRyqgWrZMInLCJ4nNcbpVG+dRQ/Eo
         TKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=/B05woazaNTKLTLtPwugar1HdWn2AdCEosSVbjTNf2o=;
        b=FP4YGicuHvAYrZxnRDmNSIVF+zvVzFIkEw45VJoA9f4bJwdsVZu+SONeGPLb/CQU7S
         27BGvQoA5La82Wu+Z6SU8iPzeq2KYVBN8dV9Uqe5Ttjm/u5RKSsVqUYdJwAJ6eIFTAd8
         U4W3wZcXatW5TFJzRFYr6+VM88E5+45Ct0PuMEkAuD0IT5L6yuTPVjkNCt83NOx0LsGT
         GUwAzzFzjAapccHrt2/1VrIWKE7SeWM5o57wE+8AeO9pf/V81yP5KWUvN0wAhoxNcwjb
         RgBNnpaFlNFId0t4hWU+9G5t70AanNHR39rAGfaWORqevT5KmzMVSqwSePkk0baY3AHA
         8GeQ==
X-Gm-Message-State: AOAM532godkrorioWUxB4g9npUg8CnQYvXtGR0HnsfqDHpgWN0dMnRnM
        DBoydWdTa0UR6RSP+NyLH0M=
X-Google-Smtp-Source: ABdhPJzzL5kTfwzdJ+0OJLvMilmmExy6UUzD5uUqkMGRPkcfdLBFvaMq8ec3jQmJJGAesGcfq8/pWA==
X-Received: by 2002:a17:90a:930b:b0:1d5:684b:8e13 with SMTP id p11-20020a17090a930b00b001d5684b8e13mr10057408pjo.153.1652537834804;
        Sat, 14 May 2022 07:17:14 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a530800b001cd4989feccsm5298541pjh.24.2022.05.14.07.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:17:14 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/4] can: can_dropped_invalid_skb() and Kbuild changes
Date:   Sat, 14 May 2022 23:16:46 +0900
Message-Id: <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In listen only mode, tx CAN frames can still reach the driver if
injected via the packet socket. This series add a check toward
CAN_CTRLMODE_LISTENONLY in can_dropped_invalid_skb() to discard such
skb.

The fourth and last patch is the actual change. This goal cascaded in
the need to create other patches which will be explained in reverse
order.

The third patch migrates can_dropped_invalid_skb() and
can_skb_headroom_valid() from skb.h to skb.c. This preparation is
needed because skb.h does not include linux/can/dev.h (for struct
can_priv) and uapi/linux/can/netlink.h (for the definition of
CAN_CTRLMODE_LISTEONLY) which we need for this change. The function
being already big, better to de-inline them and move them to a .c
file.

The third patch would not work without some adjustment to Kbuild. VCAN
and VXCAN are users of can_dropped_invalid_skb() but do not depend on
CAN_DEV and thus would not see the symbols from skb.o if
CONFIG_CAN_DEV is not selected. c.f. kernel test robot report on the
v2 of this series [1]. The second patch modifies Kbuild to fix it.

slcan does not depend of can_dropped_invalid_skb() which would make it
the only driver with no dependencies on CAN_DEV. Because I wanted an
excuse to move all the driver under CAN_DEV in the second patch, the
first patch applies can_dropped_invalid_skb() to slcan to make it
dependent.

[1] https://lore.kernel.org/linux-can/202205141221.H0aZXRak-lkp@intel.com/


* Changelog *

v2 -> v3

  * Apply can_dropped_invalid_skb() to slcan.

  * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
    modifying Kbuild.

  * fix small typos.

v1 -> v2

  * move can_dropped_invalid_skb() to skb.c instead of dev.h

  * also move can_skb_headroom_valid() to skb.c

Vincent Mailhol (4):
  can: slcan: use can_dropped_invalid_skb() instead of manual check
  can: Kconfig: change CAN_DEV into a menuconfig
  can: skb:: move can_dropped_invalid_skb and can_skb_headroom_valid to
    skb.c
  can: dev: drop tx skb if in listen only mode

 drivers/net/can/Kconfig   | 33 +++++++++++---------
 drivers/net/can/dev/skb.c | 65 +++++++++++++++++++++++++++++++++++++++
 drivers/net/can/slcan.c   |  4 +--
 include/linux/can/skb.h   | 59 +----------------------------------
 4 files changed, 87 insertions(+), 74 deletions(-)

-- 
2.35.1

