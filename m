Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149744810D7
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbhL2IJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 03:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbhL2IJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 03:09:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6881CC061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:09:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso19285328pjb.1
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jKqbX/Xt6Jj7Kk4e+sViTb1yzc/zA0dEA/5iKGxthj0=;
        b=gRxmciOLH9rGlosUqLBHnThxYttf/edZ9iW9Pb3dzf3XJX7mRiNbdFCvezFy5sWwxl
         LoE5RrU97XmlxnQ8QuS7ZcJTpWZlB/WLqUS+KRBuU6uavCPwmKwQjC+rn7io3F/wKqzi
         2g0tAuVG9U/kQW4v3eGaf6kkHitF70F9qjOSnRmbezu8WtR4+aakQT4zFIff2cfLUNSV
         l0TtCHm0YBZ3Oq6WVRHfjaKp0VHe/e9+GyBV1vpxPtu/QHHDqA4aCS6VU5GM8fOmcwr8
         3mRv0vbzQ5eEDuzz3xIqiDnNql5SI1mAS1aztcqWTs1QSHgK9x1AyupEp4fJgBFah+Ax
         0t/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jKqbX/Xt6Jj7Kk4e+sViTb1yzc/zA0dEA/5iKGxthj0=;
        b=eJbIiP8ElQh4on+ru0NysVE+mTXDF4OIeRX96ngvCk3KRZ4TW7KlxeepIQZEUgnKBR
         hDSEWLjjO5qN6Zu09YCGzHCTqRYiXf4FiJn8nnqUCs+pc2svazl5nhGg6MCTahwGOHGt
         7R+/S9mzkGesYvI1I4m4UT79isxH+gb8FQVK4YDkIySkE+ONLVPrOkF/wlUsg/cdsg4D
         FHc3fOdhMxH8DbOPahw8CfwoVZvl/cIKLnu0ne+Y2q21/Ljb8GC4GUdhGS9rygn6fnKK
         bkD2Cbc3EXfq5zSKvmSHPo3utqdTzokAT7f8Sz9MNeXf4hXZI8xiaB585i6yUmuOaw99
         dTig==
X-Gm-Message-State: AOAM531wgMR+19BalkWIhRQzbljhpE5EX3wXfN1IbLhq2+5X5Gq3mTsp
        CPK44ARms0JP8Db8yXqlZsVzwtNoPro=
X-Google-Smtp-Source: ABdhPJws+o5NXmVNnpB7PwKWN+NASSZ3xmNpnfd5ive11/tj3gp+cJF8wlt4KmtAR9sRkQlGr0nBHA==
X-Received: by 2002:a17:90a:5893:: with SMTP id j19mr30885384pji.30.1640765393781;
        Wed, 29 Dec 2021 00:09:53 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z2sm23996709pfe.93.2021.12.29.00.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 00:09:53 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 0/2] net: define new hwtstamp flag and return it to userspace
Date:   Wed, 29 Dec 2021 16:09:36 +0800
Message-Id: <20211229080938.231324-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset defined the new hwtstamp flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
to make userspace program build pass with old kernel header by settting ifdef.

Let's also return the flag when do SIOC[G/S]HWTSTAMP to let userspace know
that it's necessary for a given netdev.

Hangbin Liu (2):
  net_tstamp: define new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
  Bonding: return HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify user space

 drivers/net/bonding/bond_main.c | 42 ++++++++++++++++++++-------------
 include/uapi/linux/net_tstamp.h |  1 +
 2 files changed, 27 insertions(+), 16 deletions(-)

-- 
2.31.1

