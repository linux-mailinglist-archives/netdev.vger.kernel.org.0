Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9141BE171
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgD2OpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726348AbgD2OpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:45:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E06EC03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:45:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i10so2847359wrv.10
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+j2ha3zdIlGf8FdsoEhERfleB30uc07GQsmR8JMcPk=;
        b=dkVCwhU5wTAwzNSb4JpZByY2vKo5vOE8EGyxzFXX3ovn+2U7LIyNu194rfUmvsfCNj
         DJblGjeY06K9oO1MQaBrSP2GL4HYdoteYAP9xBv+Gm2pTJYn17xOCyxtTo+g9JPp5fg4
         UY6BL/Gts5rp09ZbB7j/xu8WziL3odV3656NQObeukAiJ8SCDQD+Q82eC5ObuKoyglHw
         6i9htyTIo0Qn6qsl+38seWXxuNg1K6zFCMwXL9FU3nJRQiIMcP/IAn0Ag8LomogGItDk
         lilAls11S/7ZiMifxazTzm0uHaZFmCBOifaEqX99sQG2PhlLKiZGHiHnofuYe/GyQXiB
         OvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+j2ha3zdIlGf8FdsoEhERfleB30uc07GQsmR8JMcPk=;
        b=S2yVxOnc5cP3Cb+MXC90d6NkB4/lvtO5XM1SUQrCyWx5iv+M8LqUKRkcZUCm4zl3ZJ
         EIbOntW/qGk2Vp4GjNXoEgLDhi3IcTxBlCYmmHGNtmhGFF2N29NjdVse4r05C1hgxUDW
         2gY9OmZeO+nk8jVFVFRy6cgiiOPmCnJ03ucEWzftxMild5/Nd3unK3Hz2psos3sgLlr0
         ITNZSe3u6BLK7iK9zd+LQUOD7lp3PvMtBxw9uhd+Zi6Tbbn6UK30ymO1xCbANdXoqFu5
         7ZnOwR2YygzQo9HFyj987IngNoBHSRVGr/BqYrDwj9FIJ1aVkyBpz//530a6YMRMvCs4
         W1bA==
X-Gm-Message-State: AGi0PuYVFBEKbKyaKz4TiuD7EGgd987d5952g9x52F9NmZ9PicE9Z1ph
        vlBk6ReTLhzqEKFaqOYzojteiQ==
X-Google-Smtp-Source: APiQypL7tSInNY1Su7Nn/NyckCZwD+5CYoimhXSTaakgEqoNmQibIvXiElos0AIYPJJk65ufwsf+vg==
X-Received: by 2002:a5d:4092:: with SMTP id o18mr39369962wrp.227.1588171509962;
        Wed, 29 Apr 2020 07:45:09 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.38])
        by smtp.gmail.com with ESMTPSA id a10sm20071739wrg.32.2020.04.29.07.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 07:45:09 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH bpf-next v3 0/3] tools: bpftool: probe features for unprivileged users
Date:   Wed, 29 Apr 2020 15:45:03 +0100
Message-Id: <20200429144506.8999-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set allows unprivileged users to probe available features with
bpftool. On Daniel's suggestion, the "unprivileged" keyword must be passed
on the command line to avoid accidentally dumping a subset of the features
supported by the system. When used by root, this keyword makes bpftool drop
the CAP_SYS_ADMIN capability and print the features available to
unprivileged users only.

The first patch makes a variable global in feature.c to avoid piping too
many booleans through the different functions. The second patch introduces
the unprivileged probing, adding a dependency to libcap. Then the third
patch makes this dependency optional, by restoring the initial behaviour
(root only can probe features) if the library is not available.

Cc: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>

v3: Update help message for bpftool feature probe ("unprivileged").

v2: Add "unprivileged" keyword, libcap check (patches 1 and 3 are new).

Quentin Monnet (3):
  tools: bpftool: for "feature probe" define "full_mode" bool as global
  tools: bpftool: allow unprivileged users to probe features
  tools: bpftool: make libcap dependency optional

 .../bpftool/Documentation/bpftool-feature.rst |  12 +-
 tools/bpf/bpftool/Makefile                    |  13 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
 tools/bpf/bpftool/feature.c                   | 143 +++++++++++++++---
 4 files changed, 143 insertions(+), 27 deletions(-)

-- 
2.20.1

