Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B17F3FF916
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 05:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346018AbhICDYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 23:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242941AbhICDY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 23:24:27 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BF9C061575;
        Thu,  2 Sep 2021 20:23:28 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id p4so4541578qki.3;
        Thu, 02 Sep 2021 20:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kmMaDf5XzzZWoGrkUvrMT55kPyBx22fLqCQ3l5BOly4=;
        b=Gbry68x/s33GK0bheQ4NqIwVQxwD6g9YurY5CIGkicUcwOs2K8iMjfBV78fnJbKI2b
         G4b5VNP1omLmgOqA2TwWQZIJ5BsNmjO8RgBd5/Qn7mZ88IRHxFpeQDBDq2j2dD1q2HQo
         86/kDI5TCnVMiiDWTrXsgHQLfU9aIucV4hL5iAf6pzbB2DD03iXIKicNVYCFxXSQvr+V
         bsgIBIVAXFY8aNmzDEGVPJsyFx30+wTNlaKiwA7CFxVbMR3WL6ENYlJyzbTZ9d8BgJEH
         BAaFTtk/2/ZC1ZBnNe+pG2S2vH80378SMZjn3kSbPXEaO2ducbIr0XSFokzHcmGVFI3X
         xFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kmMaDf5XzzZWoGrkUvrMT55kPyBx22fLqCQ3l5BOly4=;
        b=lSyAKt3dSwf3jX5H3m/IPbR1c+AIob5FhHxYznIcscxK617U3/+RS5OSRzZwYD+i8l
         EQJ60KXVIxup0SBNq3X2Fu9jf12oXH17eZpduqKSvpZP2Bxcn0LQ5aDCZXpX0gPIWrA1
         YMj2dJcQlt6Y5NbtcuQd885jRCUhcQ+B8uvOtyLhMDL1wYu/UkHTn/GSbCPeBY1IWnNn
         Y0sxrK2DyBkO4R5LO0qevK3M6UnbwNaPRhhPNevp24lf4BhhbdEJ1AHpZjLbx4SHwX8T
         OCgpXSCTEY9wF4WktkJCYxVJ+1geHnERYNOb45gy4/JXryEpMH3eBxAN+1G3cYJklBjL
         j0Lg==
X-Gm-Message-State: AOAM531IooyWgmFMlYz0rpzl0vPur0fFvs7y70emb5Jwh5EwyUzcp7eF
        XhxCmKB9CJisG+OC7eQu698=
X-Google-Smtp-Source: ABdhPJy5VR1jyOkWg+muVI8YHbH8vEGlrb1vrWc9VtYCwC/VHZSuc/dYGFUB5q/XvUhbCCDsF4fEEg==
X-Received: by 2002:ae9:edd2:: with SMTP id c201mr1424754qkg.495.1630639407731;
        Thu, 02 Sep 2021 20:23:27 -0700 (PDT)
Received: from localhost.localdomain (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id v5sm2984729qkh.39.2021.09.02.20.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 20:23:27 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: [PATCH 0/2] Bluetooth: various SCO fixes
Date:   Thu,  2 Sep 2021 23:13:04 -0400
Message-Id: <20210903031306.78292-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

This patch set contains some of the fixes for SCO following our
discussion on commit ba316be1b6a0 ("Bluetooth: schedule SCO timeouts
with delayed_work") [1].

I believe these patches should go in together with [2] to address the
UAF errors that have been reported by Syzbot following
commit ba316be1b6a0.

Link: https://lore.kernel.org/lkml/20210810041410.142035-2-desmondcheongzx@gmail.com/ [1]
Link: https://lore.kernel.org/lkml/20210831065601.101185-1-desmondcheongzx@gmail.com/ [2]

Best wishes,
Desmond

Desmond Cheong Zhi Xi (2):
  Bluetooth: call sock_hold earlier in sco_conn_del
  Bluetooth: fix init and cleanup of sco_conn.timeout_work

 net/bluetooth/sco.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.25.1

