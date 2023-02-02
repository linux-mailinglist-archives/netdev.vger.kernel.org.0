Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B078C6878ED
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjBBJeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjBBJeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:34:03 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0DA24CA9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:33:11 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso1237309pjb.4
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SbvMveejPnNY0dtntPgcfEf+7sqTjGePPLxtPF4gXZI=;
        b=YduFipxFTmlAHpxZW30BY1Z/+xbuscdW+jMpyQIoTO5Wes61YwldcGudWmPnZc5hQC
         oXDEKqC7EUbOShWgQIV8e72qrEzkb7Qzza/0X50BjcHcis2voFWhnLuNHOqLGyBzjqPD
         V0xb20qXsu4TyE4XLEIV6a+ETrgeZ6CwlS1H5vgntybKTokYdri4vqoY2ibSaTwTnm+T
         ePufc82B602pfSFf4urGw6BUrZobl6ES4EEqBwBxGKVVs7ZEBdWk5KnWezmSp8IPvYEK
         sYmkJsK2XBqVtWtPJvnh4gob6ypzf3E/9r9sizvFfOiAOH5j+IIZYIGtbq0erlGMaSRq
         UYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SbvMveejPnNY0dtntPgcfEf+7sqTjGePPLxtPF4gXZI=;
        b=eJEME51et41p3kGehhwkGyaRKcPYET+EPQ2fKLZWek/PhbyZYXkwbGSJ00VVyS9C3O
         8f8nElOZrlXc/err/ipedwaljkH9xJMAtUa3ADLFd8a32Kz+1nK12Nh0rbk6Z3hGU8of
         mf9UmEoAhobRBwqk8/IJrsF3btzGORopkzOiD0+Hn+bhiSMaIjEatoLeBu5rdscMTM8q
         Zdf1hMMqgAgNDBBV5x/Z6gIytAc2JQj6w2/bY6ynnMtZSi58V6Qojep2kLg/JbLkzSb6
         +2LS70mOIZmXihuTsF4x5xpxZLvyVJgT4Sl+IdTMQT4rwZhnp5lmJq6oLlFGGeVP3F7n
         hSwQ==
X-Gm-Message-State: AO0yUKXrkdt7ss+W0rYrsDNhLeVRJH6WJ6sYTfr+YXAYBbpLBdye2dev
        ALmkVU1qa8T4YAow7pvXcy7NyQ==
X-Google-Smtp-Source: AK7set+SYjhqLtHWEWxKvlhuML4XhqmA9D1c+JVtoi+6+bX+9bYjuAvpwXHu3l5witPhmx9ffaFCSg==
X-Received: by 2002:a17:903:243:b0:196:82e2:799a with SMTP id j3-20020a170903024300b0019682e2799amr6960578plh.4.1675330391288;
        Thu, 02 Feb 2023 01:33:11 -0800 (PST)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id c10-20020a170902848a00b0019254c19697sm13153343plo.289.2023.02.02.01.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:33:10 -0800 (PST)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        vireshk@kernel.org, nm@ti.com, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 0/3] some minor fixes of error checking about debugfs_rename()
Date:   Thu,  2 Feb 2023 17:32:53 +0800
Message-Id: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ff9fb72bc077 ("debugfs: return error values, not NULL") changed
return value of debugfs_rename() in error cases from %NULL to %ERR_PTR(-ERROR).
The comments and checks corresponding to debugfs_rename() should also be updated
and fixed.

Qi Zheng (3):
  debugfs: update comment of debugfs_rename()
  bonding: fix error checking in bond_debug_reregister()
  PM/OPP: fix error checking in opp_migrate_dentry()

 drivers/net/bonding/bond_debugfs.c | 2 +-
 drivers/opp/debugfs.c              | 2 +-
 fs/debugfs/inode.c                 | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.20.1

