Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAB63EC49A
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhHNSuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbhHNSuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:50:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F19C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:49:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j1so20230345pjv.3
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVTIISucMBWxs2WJrtTjWY7ubr+gY82QjTdDWjm4u84=;
        b=Bn1wukoEsoYZio0TV7eN2YRN8A6Bp+z9xZ66sbBLT6uiJyXCewmILPac97tRLZgxdD
         ScEl2qMmpDfa9CmUppXANSrTfN++BcOitlzGLdFGCbc1iGEy8FGmpGlYpN2GzCJSd9hj
         gpNjKuHvmkSvWGrqMM1mYrqUscp4ivjmAimBp1kI1M1NlHzbxH6g+FOtqpF2pjRIMdOG
         OJ/qkDuhrH3VEWGQSNa1TtfFNA0t8cGf7nPdjpUo6m6cFXiI1oK8RxK4QlXS6mPliVZ2
         xzBA58OL1/nMvZWrV/+ApUW0HK+MKmlZ2PBFenrIq3VLiYXbhhsFzMeM3fr7nZ+iUXM9
         DMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVTIISucMBWxs2WJrtTjWY7ubr+gY82QjTdDWjm4u84=;
        b=AA5U9GU2+N2+CZeFOL/ElY8+hZAb0GuBPm22aPkz75586J+aBala61ueEfXbt4Tvxh
         /a2PlLezGs5kwmr0ic70zbrntz+QHtfzOthrk4iTeMcNsJfSOB3+WFZA+3t8GMyYh6+l
         0a7Vwgq2SR6PWk7CwRDbxYVcizvTTMrAnXD/OSxw+0LGUm8qKRgIC/p14JpzoQm+YhuA
         jA94VbkXrzOqZXXLUjxClZUHY/cT3axMUA/XPghNMYwtSJcESsHpBJKJX64yxF/tP66p
         tEHajtmgnhN4tnhMOi7myE7Pz7Ekud7ytOXskIDE63/aCOtEixiViQ2pdMK//5/2ypDX
         xaVA==
X-Gm-Message-State: AOAM532B9TBewPQcSC5L1rjX9HVb1bc1wpqK9hqL4YvCivlPDLh2QYrC
        tsjTM3iYEr/eq8cwXdqqOwmohND3E4o2ORAE
X-Google-Smtp-Source: ABdhPJztecyOImW9tG0wxvS6lq3JDa2C92c6TcanZ1ujGVgrcS+KRJiblDPPozejVAC2y/tVgTrCKw==
X-Received: by 2002:a17:90a:8b81:: with SMTP id z1mr8367852pjn.82.1628966977216;
        Sat, 14 Aug 2021 11:49:37 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id r16sm5294736pje.10.2021.08.14.11.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:49:36 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next v2 0/3] bridge: fixes regarding the colorized output
Date:   Sun, 15 Aug 2021 00:17:24 +0530
Message-Id: <20210814184727.2405108-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
 - Replace the 2 newly introduced fprintf() func calls with print_string()
   to address Stephen's suggestion.

For the bridge cmd, the "colorize output" cmd line option's usage and the
corresponding output does not seem to be consistent with the usage and the
output of the "ip" cmds.

Example 1: As per the "colorize output" cmd line option documented in the
man pages man/man8/ip.8 & man/man8/bridge.8, using "-c" with "ip" or the
"bridge" should colorize the output. But this is working only with the "ip"
cmd and for the "bridge" cmd, the option "-col" / "-colo" / "-color" needs
to be used instead of just "-c".

Example 2: After fixing the inconsistency mentioned in Example 1,
- Running the cmd "$ ip -c neigh", will give the following output where the
  "172.16.12.250", "bridge0" & "04:d9:f5:c1:0c:74" fields are highlighted
  and not the fixed keywords "dev" & "lladdr".

  172.16.12.250 dev bridge0 lladdr 04:d9:f5:c1:0c:74 REACHABLE

- But running the cmd "$ bridge -c fdb", will give the following output
  where "00:00:00:00:00:00", "dev", "vxlan100", "dst" & "2001:db8:2::1" are
  highlighted, even though "dev" & "dst" keywords are static.

  00:00:00:00:00:00 dev vxlan100 dst 2001:db8:2::1 self permanent

Also fix a typo in man/man8/bridge.8 to change "-c[lor]" into "-c[olor]".

Gokul Sivakumar (3):
  bridge: reorder cmd line arg parsing to let "-c" detected as "color"
    option
  bridge: fdb: don't colorize the "dev" & "dst" keywords in "bridge -c
    fdb"
  man: bridge: fix the typo to change "-c[lor]" into "-c[olor]" in man
    page

 bridge/bridge.c   |  2 +-
 bridge/fdb.c      | 13 ++++++++++---
 man/man8/bridge.8 |  2 +-
 3 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.25.1

