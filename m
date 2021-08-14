Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FB73EC1C6
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhHNJzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhHNJzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 05:55:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5939C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j12-20020a17090aeb0c00b00179530520b3so4013079pjz.0
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fQFLK3K/VbSJDw+qpmq8jtUwepTLLVNSYLKsPAzfdM=;
        b=e7GrDJ+XR2g8T1RmxwAgcdLAmZ3FBhSJC4fObY+nsYNNaBS0yc+N34aLQ+zWflb9gz
         SCJSCRDfy+a6Y2J5SeYlgAr11Vq1dW3jmeV/pXpv9aUkMQW9qt81t0nkfUv6hCGVODcb
         01HA4J5D95lfJt5UoMpEv/g3s5MGhqjTTRYmnmq3TNvZ74N8SwBAj8Uuh7Ntibsr5Cdw
         i0hIwP1NmbKPo3MigRC19Eg1qg+GADzXWMbNU1DxcSawaP/FqNQSrgKKRKOODMpHpniL
         Ah40OaoiA84apJ1Yz51+O+/U2rQSvkdF6XIIOD5FN7RoVbX10R+wfJDR37PTkDevpLj5
         t7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fQFLK3K/VbSJDw+qpmq8jtUwepTLLVNSYLKsPAzfdM=;
        b=b+h3XAf/laSv8tVMJm4b0xh6X+7U7kUeUDra4+gXYQAvKmQ+UikbtdWi2em4vSmrsC
         NS69V1no8/wb6WYGGem3qzQR44vYiWzscQVHULQ6gwa6JCeU4ps3UKyzz52LbyWXxek0
         SAKk4pqpEHHr29wBc/RiZgfCGjretKA62O0U8K5bfoOU7lVY4Qtd4W+2Fv+GLPxgCInP
         CI6C7Vv8Ktny6qa9EQPe4rRQlWX7By/r6HX/bfxRP69gBP1ubuBRUoOAIUIrz7phUfo0
         Ss3vZui9RgxRGlBYQMUVqufpn8sqm5uc8i0eIrFqHDhSVNsioQ9aeo7Mh+gxsKowBY33
         Zm7Q==
X-Gm-Message-State: AOAM533DSNebU+AX/Y45tIRqZqbqyedrbvF/p2UgKccUSNqBq9QjqFZf
        AD7OwjDHygg/6I5aJFgN0KVtdkh4fBUqxA==
X-Google-Smtp-Source: ABdhPJxsbH9yTrNlALgnqrbA2GgrxNbo2x9nGifMj7fI4g1huPQgzO7ugy8/cJv8X8B3gPvhWGPaQA==
X-Received: by 2002:a17:902:7fc6:b029:12d:1a3c:a981 with SMTP id t6-20020a1709027fc6b029012d1a3ca981mr5322869plb.46.1628934917943;
        Sat, 14 Aug 2021 02:55:17 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id y7sm5220436pfp.102.2021.08.14.02.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 02:55:17 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next 0/3] bridge: fixes regarding the colorized output
Date:   Sat, 14 Aug 2021 15:24:36 +0530
Message-Id: <20210814095439.1736737-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

