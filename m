Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5656292E9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiKOIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiKOIGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:06:01 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173531CFD7;
        Tue, 15 Nov 2022 00:06:00 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id o4so22724927wrq.6;
        Tue, 15 Nov 2022 00:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i9EZg8Jiv9rKfr7s9BpOwll/AuJrv9tdRcS5ZOl+XCc=;
        b=bQTGOrrkGNQIkS0an+MhZLqN08lPc7JhpJxCWd6EVMEoiHEOqLuDbjn3L2Ad1VIlHw
         +ap4n+RXSk3+LY/coDo6Xq4JEaDmSo/EvnVnX0NFeLx9lqxWUR8NXDZG3MJK3i5I4B5b
         SbzRm7wdS5ytOSm7qizBOF8MWhnM9PvLenLujExmWQrjZr1oFSy39N1Ve2qyzrxzBTE7
         QULEi4jkZRCfYp8MIvIK6wKY2RCKC6jNnP1yQWVnsdm/O9D2+ZixVZJH3Ozpt9vp1dle
         06Hm/Vy/+vgV+sW/ur7qSSqjAMJcqJrFCJjR5IY1he4I6h4/WqWhHIciFU8gXgb6TxW2
         9Qhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9EZg8Jiv9rKfr7s9BpOwll/AuJrv9tdRcS5ZOl+XCc=;
        b=LBt2CcCym2ubybkUOPwM5NfCnTdfy1zpN4b/D0XY9yI3vrZ0OOQl0Ic65t1ujAULel
         OxifZwxOPD9KBr9sA4Bb+A1bkye0679JZlWnbqgrK3RKr9w2i8FN7OHIzK94GCqixEBu
         HcAtU0AqRjSu31nDj8Tx7MGhxyZjKUfeobwgl4JA4ONEBiqFUKEqKc/jEEZEkFmlwXbi
         cIApMHHWbA2wCkbXSdJSlPbrQ4n2F7z2c+ByNOF2l0xF1CVAoH8IqhgowRW5K0ZBl8Cc
         lNX64dgRnVocFT90ovkQSNVK4r3+6t1hcmudrVrCR4U62hHUqmMwXukujFA0A/rh4Dt6
         6iEg==
X-Gm-Message-State: ANoB5pl1buGxxKsQtUR+nMpkQF814bYjCUHuPr1nJ43D1qXXSg92AP44
        DYbYfopNJizDc55OrHGyJqE=
X-Google-Smtp-Source: AA0mqf4EBBxufQXwUCMpc651LVg7YuxykUQT2fR+29kEm2HQEaACeJmdijWSN2KiLC7qP9F8R8/puA==
X-Received: by 2002:adf:f2ca:0:b0:22c:d453:2bc2 with SMTP id d10-20020adff2ca000000b0022cd4532bc2mr9345808wrp.349.1668499558488;
        Tue, 15 Nov 2022 00:05:58 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id cy6-20020a056000400600b002416ecb8c33sm11464190wrb.105.2022.11.15.00.05.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 00:05:57 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf 0/3] selftests/xsk: three small fixes
Date:   Tue, 15 Nov 2022 09:05:35 +0100
Message-Id: <20221115080538.18503-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This patch set contains three small fixes for bugs discovered while
implementing some new tests that will be sent to bpf-next. These are
minor fixes to the xsk test framework that IMHO should not be
backported to any of the stable kernels as no one using them would
care. The tests work fine without these fixes, but when developing new
code and some test fails (or the framework fails), these bugs in the
code are irritating.

Thanks: Magnus

Magnus Karlsson (3):
  selftests/xsk: print correct payload for packet dump
  selftests/xsk: do not close unused file descriptors
  selftests/xsk: print correct error codes when exiting

 tools/testing/selftests/bpf/xsk.c        | 13 +++++++++++--
 tools/testing/selftests/bpf/xskxceiver.c | 24 ++++++++++++------------
 2 files changed, 23 insertions(+), 14 deletions(-)


base-commit: 5fd2a60aecf3a42b14fa371c55b3dbb18b229230
--
2.34.1
