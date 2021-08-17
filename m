Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DDB3EF0EB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhHQR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhHQR27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:28:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5411BC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:26 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w6so18633143plg.9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pxTJOpOzYNPA872R6PPYW8Pxi5OeUMadRLyuABZKWBY=;
        b=hrZvlZJXsFtvrdLK+6TjL7Samg6yRji3K3XWzOGCX/mFHggbRxgFrRvL9KWP1mZIUg
         8EestFw+wpgqfEQxloK7Ero6fs2jQrmLvZJTXuo7l3NHYI8a0FN2sOynp8lfydxPNDiR
         MOIsiDTu+jZSP1Vy6Pw1XcM9XMOs7f/5ft4fnA9mbf6wJxPluSkBycgQAWCYdApv/7Pi
         A3HhDBPYu9mz/iNGfUi0gLogVOiC1pTGWiY98gQ+xrtil2ZJTsjyl3/2X8tF8EoNJbUD
         1xK3vDp8n+r5xiNw7ylYfr1Xpx9zhYGsuSoSD597pYrnqsEBxBd1yTNHaNOSJ91H3mrh
         1zHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pxTJOpOzYNPA872R6PPYW8Pxi5OeUMadRLyuABZKWBY=;
        b=cVTGouGgypsr/I/ZCW0KUXKGh4nW7POuwjf+ZWnLh1C677zTZWBC8ru9ryDD9nIMvD
         XWhyYkwAnOdp0NQ/9QQ2V8B6dxOhQkFt1t9fFk7P9q9jl3aaJMCDQer1nE2hpljbMwPD
         7R4Bos4KqmP1D/aECZVhIczMwXt+OQ7MQOMVnRHWkndtXBwmSdrUDLrPLyj5AOqPp0Fj
         p99ttGIQmgqf/2nNzMWNYTz0xbW8ea+E1aNJeCvqG9kQ5U4cpOO4kyPVfvbutdSgXoRF
         iVfAjIwGyOE+peYYlBSpjQtOREE2A0GIjbTpO49mTygFj9jtFIQsw7cpNUfQAxczZOwq
         PrYQ==
X-Gm-Message-State: AOAM5322qk2789FOzb51T97yGVWjB/2e6CnkVkwPVIqd57X6eFSwls5k
        UmQTXUZaZ9TjEz1k2l15jRud4dg5gIW4sYtd
X-Google-Smtp-Source: ABdhPJwjjDOyjFJxXRf7WPZj+v3a7ElifZ0mF9zyImRGe7IQ/E3MB/5gjsLv2ic0cAf0WI58lk5Ayw==
X-Received: by 2002:a05:6a00:140e:b029:38b:c129:9f2f with SMTP id l14-20020a056a00140eb029038bc1299f2fmr4551992pfu.75.1629221305639;
        Tue, 17 Aug 2021 10:28:25 -0700 (PDT)
Received: from lattitude.lan ([49.206.114.79])
        by smtp.googlemail.com with ESMTPSA id y5sm3872096pgs.27.2021.08.17.10.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 10:28:25 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2 v3 0/3] bridge: fixes regarding the colorized output
Date:   Tue, 17 Aug 2021 22:58:04 +0530
Message-Id: <20210817172807.3196427-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
 - Remove the unnecessary is_json_context() condition checks from patch 2/3
   as the print_string() call is used with the argument PRINT_FP.

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
 bridge/fdb.c      | 11 ++++++++---
 man/man8/bridge.8 |  2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.25.1

