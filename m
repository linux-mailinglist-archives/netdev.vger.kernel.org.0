Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B98512AA7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 06:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbiD1Esk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 00:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241924AbiD1Esj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 00:48:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893657DE21;
        Wed, 27 Apr 2022 21:45:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j8so3310314pll.11;
        Wed, 27 Apr 2022 21:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W0qKyAGvf9gyQPMEibcyxeRwNFiO+lmI9EK4ajfFul8=;
        b=q2w0daIMqqVRixDzDizqhwuZ8MYITfO7LEtrVvA0O1vyxR3ulHxlVZbeJN6BwUfP3T
         qeg9azeViJJHUhoJj8sY+UV9rBTdPhHUmoRTDUC1f2bW2orO5bQo1rSx4EXjboKEc+Bo
         Owmyo9wXgHvSKBw6ogQZWpnAt9J96hfdYMtZQ5JqIdo7w1mo5WQ2uqu+SKNrdBolnhAa
         i09XgeSbuE8ZkTP2DriEIB6d314Lbyxy5Uxc/G9Of8WcJtYQavMXImIjEDOBIetA53zZ
         08LmRKSAcJ8/dQ1E0yIhfpswDksPLpzGrmshn2qhTZ9xikZU38WBuBDP8cVbnyGs7bmJ
         EYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W0qKyAGvf9gyQPMEibcyxeRwNFiO+lmI9EK4ajfFul8=;
        b=0vbUlIA52wfPgJ2PAyxE3QrAkxIot/Z5w8sOF9zAKt02cZ9QvAaMguJjuCAEhHcwmF
         eHBD+APmZ0zSRu+8yXbMKFaorh6GF5D+b4aykXKNF9AZAiJi0GM+hnHsBV34fOL9DCjv
         jpMKRwJZsLsIJF24XOEj1s2G5p11rGa9tKsF+wdIfGwTZAwnf8NMTEyeVV/V7vs1GbL+
         B2XNq85Ubtb8nsuRAJUJ4BwtkFlF+vZSJCjqkiSwIRdy0N5PiZFn3n+7BlU1I0CvLkCN
         twOs7e6j5gqfO+yS0Psz3l1sTs9X2VUrykKlnwQ8sf+xHRs0t9viaX8+8zQ2CS0k+Rjy
         qmpg==
X-Gm-Message-State: AOAM531iCjMagMmLCifsgLKemYxYvRMj50EW40LZPgdfG4VQUWkdYec5
        LtfMTCDHfMSTxqNaq64vyOZJj7P2P8k=
X-Google-Smtp-Source: ABdhPJxNwROEirT8zyK5F2Ak2uAhK92O7HQ14vHvL52UStZlHhBJ7MhwHI9wetil8m6KgMZX4ErVNQ==
X-Received: by 2002:a17:903:1d0:b0:15c:f02f:d2d6 with SMTP id e16-20020a17090301d000b0015cf02fd2d6mr24312927plh.77.1651121119856;
        Wed, 27 Apr 2022 21:45:19 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0050d3aa8c904sm14301162pfg.206.2022.04.27.21.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 21:45:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        linux-kselftest@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, lkp-owner@lists.01.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Date:   Thu, 28 Apr 2022 12:45:09 +0800
Message-Id: <20220428044511.227416-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

When generating the selftests to another folder, the fixed tests are
missing as they are not in Makefile. The missing tests are generated
by command:
$ for f in $(ls *.sh); do grep -q $f Makefile || echo $f; done

I think there need a way to notify the developer when they created a new
file in selftests folder. Maybe a bot like bluez.test.bot or kernel
test robot could help do that?

Hangbin Liu (2):
  selftests/net: add missing tests
  selftests/net/forwarding: add missing tests

 tools/testing/selftests/net/Makefile          |  3 +-
 .../testing/selftests/net/forwarding/Makefile | 33 +++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

-- 
2.35.1

