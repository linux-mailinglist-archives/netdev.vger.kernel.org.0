Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8E1FB4A7
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgFPOlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgFPOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:41:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98D7C061573;
        Tue, 16 Jun 2020 07:41:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g1so14441965edv.6;
        Tue, 16 Jun 2020 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4Zz5WMksNaBBzQHKfDm7bJwscvEi3U1et2P+ZKimX8=;
        b=KcFoLD1+8TsmdC5BLHkTuO2dsNyVpbxMHMwZ2P0XhDoFPVk1lhDKBk2+Yexo/Ctvn9
         AqvrZwQJipf+261/rW/DlVzFuUEABEiKxtb57SVgCJ4KrFZSZRTqb2FjcPsz962auRPK
         GkfRgZ0JF3aloLz1aGHsXphOtZinC91AkxYONTiOpRTAQHlzS4q+0fLQj62fYL74evS5
         gJS7eqBu9bIEuy2WAPfs9s2zd8QN6IRqeH4p2OlC5weUDzs2Me8L+eYlLYDCX9t7XLXr
         yN0CqRN8QcS7PVZclpe8mJsJBxBTmgAx6SL/KQuXMOyGDJlEDT+evlQA7bG0I8Wu65AQ
         ljdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4Zz5WMksNaBBzQHKfDm7bJwscvEi3U1et2P+ZKimX8=;
        b=RrWJF+m+TRQu3qt21eScqC2q+DGA2zdcAAJ8qLe8wDwpYWtdmbpgVMwOrk3H/rjYs+
         2znTk9JhRfyNUYx5rrXj4Z5giOdvtSnQAehwVq9pdY3hcEWh5UudUg/XolVy4SxZI4EX
         Pmzn2wunSBNoPmP+9XRf2l37WKMKoXMQvT8ZDz8TEOyvB3vVXTrUnO2P+Tja/w8VA9Ea
         qj758yIzIl3nZnEUnNCLmXae/4azeoDnQb9+fGxuGstrHxwyMBlRB77eav66cJSBXeFM
         JJGAooqE4dPhKfaPRts4MxJ2CLowOP6Lc4uwiaLBS2UOugJNQbfAR6rCfQMaCMowntZ3
         QH2w==
X-Gm-Message-State: AOAM533nVAywTsVrJiIEqUR7Y12y3pH30kF9cW3hWQD2ENLD+zY7E6qY
        lCxYRf5uOsOFOUNfmK9rWXw=
X-Google-Smtp-Source: ABdhPJxMhk7Z4GrzrmwCOy25ig1nJSizyIe1Cv+hBp3Wu2T1XIkUcYcxIMUxy7YKQsLjtIKx1p/4/w==
X-Received: by 2002:a05:6402:206e:: with SMTP id bd14mr2918141edb.105.1592318483672;
        Tue, 16 Jun 2020 07:41:23 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id c17sm11264964eja.42.2020.06.16.07.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 07:41:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] Reapply DSA fix for dpaa-eth with proper Fixes: tag
Date:   Tue, 16 Jun 2020 17:41:16 +0300
Message-Id: <20200616144118.3902244-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Joakim notified me that this breaks stable trees.
It turns out that my assessment about who-broke-who was wrong.
The real Fixes: tag should have been:

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")

which changes the device on which SET_NETDEV_DEV is made.

git describe --tags 060ad66f97954
v5.4-rc3-783-g060ad66f9795

Which means that it shouldn't have been backported to 4.19 and below.
This series reverts the commit with the misleading commit message, and
reapplies it with a corrected one. The resulting code is exactly the
same, but now, the revert should make it to the stable trees (along with
the bad fix), and the new fix should only make it down to v5.4.y.

Vladimir Oltean (2):
  Revert "dpaa_eth: fix usage as DSA master, try 3"
  dpaa_eth: fix usage as DSA master, try 4


-- 
2.25.1

