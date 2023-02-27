Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A116A47EA
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjB0RaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjB0R37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:29:59 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA0F1CF67
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:29:56 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t15so7054599wrz.7
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lMbMZcHUrrYgIjxQ3ommUoIZSbNpJdzQ8dTTJi4pkT0=;
        b=jiiraGod+mfy/gSH21dqocUcdQ9K+XriznRtZj/Yp8iFBMLEpvs8qu8NIFdlXRXi9/
         Xxd5PTKNIq9x3PlxEHqn63yxlrWm2YgviOTkbH2LmUOhFlfXdqBIH3ad7M0uViIjlTwJ
         1uvKoaLYTjb/h53j5WJ1Wtr+r6zI+Az/OC1HfCjns7iBMNoxWr0JX/0+5uaXMXVyXX6O
         1smTgZpggDCkCVm1/rJb5IwdnevsqL16jJcQxn5PCe3bSUONJM3h/VEmFisrrlWx8E3N
         Qrn5siz951ot0Ku+aCJmlPSPc4PBbC+ImtqD6G5BF0yOsBLNc328C/wC1M6nRYbkhZ7K
         wVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lMbMZcHUrrYgIjxQ3ommUoIZSbNpJdzQ8dTTJi4pkT0=;
        b=YdIZoLGsGZfCBIE1KwMZOZ25EPnDiu+0ywtRB5Al5r7b2oFI64I87mXoskCalL76nq
         ZqM2bXuL4GcylFN0f6Jz0lzYZDEnVec59bWRfkzpyxyL/fjdHxjuKr05d5Er9tlap8x0
         UswzLfV9pLhXBAu1v53DGI5Gi+bcGWlKB1Qvvp/e5+jOd5PrKCHQgMj+OQISiluzh4PS
         LNiEmZc78dQA6p8d5H9ye7/9Zp2AVAdhmPnw7IK1ndply3NXdEzOzAWM8eFL2lfK9hmh
         i9UXqwHSllpGpEmmUQrsg6GCVSOFA3fnBPv0qogLW/8aV/yLBRH5I0dZBuCHuvqkoZIl
         Yt0g==
X-Gm-Message-State: AO0yUKXNBS/xVmhlaul8J/xyoUevAMgMQegFvYq6z7nkanHe0mm6D3fL
        c++LIEJn2gMMJBP6Tzs5QA+3ug==
X-Google-Smtp-Source: AK7set9RL2ni8PZMkaWcgkVMsYYhLc8cLUuhLTJLSFxiQWfMPyjBHe5vgRo+5Mzot049KcV626nCvQ==
X-Received: by 2002:adf:fb8f:0:b0:2c5:6182:5f6b with SMTP id a15-20020adffb8f000000b002c561825f6bmr21630310wrr.18.1677518995376;
        Mon, 27 Feb 2023 09:29:55 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:29:54 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 0/7] mptcp: fixes for 6.3
Date:   Mon, 27 Feb 2023 18:29:23 +0100
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHPo/GMC/z2MQQ7CMAwEv1L5jEVxhYr4CuLgpA71ISGK2wqp6
 t9JOHCc3Z3dwaSoGNy7HYpsavpOFS6nDvzM6SWoU2WgnoaeaMQ121KEIyZZ8J/GvPiMQT9i6P1
 4CwNTuDqC+uPYBF3h5Of2VL1JtqafI2tqi1zkp9b60Xp4HscXOIU5L5oAAAA=
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>,
        Geliang Tang <geliang.tang@suse.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2123;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=Bt1cusZoNgmgHT2JSLsa0gsxCy4BA3wwvkYRFU/ply4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiR/VSGNNE1zEgw63i7JHZ0WBzAWg/eVk+C2
 euxS097MPOJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 c0ZXD/9ci9xPaOkpjJruTQZp3P0oJR9Q2ZHrODLyjX83LIqXB5okUaWTyQ77XBNtghYxrcImBkC
 K0oQ6kY0eLlKlC732AM5vKczlA/vUgYvCHAI7rU7YXHwJGN24gIBm0hWQSqmFb0cm+Ft9/tT+aE
 yj8koskniQKSIql95wXX5o0yD3XVkMknt44vf/rwZUX7SyEoKGhwzsm8lq1QfgVX8zSku+zczmw
 XM+KtHRw8jqk/K2MhXYJ9LRvmcmv+N68wqaY1e0tBKRhf6D/9zTmXDeN9sszFK8t7ygk/xLtJTm
 S0Ms5Kh6y7OaEZd2BsQRRUqQgEeX+U0yq716EP7URHIHA+QSX9OqrUml6BLa40Zk8bDaYj0mdMa
 gxPe9XkJ0MaJ3CUwLlNfL8giGfvX0kludEcGyi0r31WnpOyyRpR6QQSUTlcwTBORv3Z3KTR/elC
 Vb2/dKXV35cUcKYDN8Jj4Wb52tL3HJMmvke+QWgXETiqLucbVJoJYhCeQ5a8QtgH/528TgeRZMm
 keiyutzuEQvdNRWptr3T9Fm5C7kQzsTVKk+dutflMn8NWLnleznPWG7H8GRTWHKuryST6/EcMEr
 CuHvwDboc4tufiPleLrCz2JFH8nS56QEOYWlaJ8eoNo7nW6jzL3RP3Uvg9b+RiCa2mZIhomWmcP
 DHHINGid4/5xENA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes a possible deadlock in subflow_error_report() reported by
lockdep. The report was in fact a false positive but the modification
makes sense and silences lockdep to allow syzkaller to find real issues.
The regression has been introduced in v5.12.

Patch 2 is a refactoring needed to be able to fix the two next issues.
It improves the situation and can be backported up to v6.0.

Patches 3 and 4 fix UaF reported by KASAN. It fixes issues potentially
visible since v5.7 and v5.19 but only reproducible until recently
(v6.0). These two patches depend on patch 2/7.

Patch 5 fixes the order of the printed values: expected vs seen values.
The regression has been introduced recently: present in Linus' tree but
not in a tagged version yet.

Patch 6 adds missing ro_after_init flags. A previous patch added them
for other functions but these two have been missed. This previous patch
has been backported to stable versions (up to v5.12) so probably better
to do the same here.

Patch 7 fixes tcp_set_state() being called twice in a row since v5.10.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Geliang Tang (1):
      mptcp: add ro_after_init for tcp{,v6}_prot_override

Matthieu Baerts (2):
      selftests: mptcp: userspace pm: fix printed values
      mptcp: avoid setting TCP_CLOSE state twice

Paolo Abeni (4):
      mptcp: fix possible deadlock in subflow_error_report
      mptcp: refactor passive socket initialization
      mptcp: use the workqueue to destroy unaccepted sockets
      mptcp: fix UaF in listener shutdown

 net/mptcp/protocol.c                              |  44 +++-----
 net/mptcp/protocol.h                              |   4 +-
 net/mptcp/subflow.c                               | 122 +++++++---------------
 tools/testing/selftests/net/mptcp/userspace_pm.sh |   2 +-
 4 files changed, 59 insertions(+), 113 deletions(-)
---
base-commit: aaa3c08ee0653beaa649d4adfb27ad562641cfd8
change-id: 20230227-upstream-net-20230227-mptcp-fixes-cc78f3a2f5b2

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

