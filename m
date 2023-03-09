Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B276B2D2B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCISwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCISw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:52:29 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3F7FAEE6
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 10:52:08 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id l15-20020a9d7a8f000000b0069447f0db6fso1617256otn.4
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 10:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678387928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S40at39xa/m8hMrk4oLChj/icfF49AiCLaY9tOvryC4=;
        b=INzGYVtb+Oqe7omZZ9jZbgIpnLUKuwvNhFVqYdQv9bZ4BAciMwnXmX+WW8t980nJg/
         FwUIBm5wKP4AcQbg/DOql/tUyetFYQd1utz233L7NdvJiTA6jnvwJwBpWATZYmqYT9tT
         nbMe4jZwz7E77mKPpFEgRIsI6QstpOwYzkn5ko3Bj/OnyOouTxm1qDnRTyDfw2qXpJiH
         2MI60ummswiCwzM/UFVA0IiNWak7FVZLZ2YeqZNa6cR5H2nMTQWgbx69An2Ef6mBh2K+
         /chncE9Sxay6wqEgMU0X9nTpPO3oLAvl8eEPQ3pxzP4Dw7ncldVyelQ5ojn4wuHgt2jZ
         dieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678387928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S40at39xa/m8hMrk4oLChj/icfF49AiCLaY9tOvryC4=;
        b=f+wDXbsNB0hZg1JUCC4+jN3HiptckvE2ngiqX/ik66I3TmnKNZcXhx0TwDQhrHdC+A
         magsSv+o+6tEYx/XUTC2rInEearv6UoBQ0iJHUTejfa2SIIOH4qc9uXeHws18EQf+R64
         WfIR5v0KWUFeuINJMP5A+yitJT1KPPO/3nyLIMmvmi7WcfuTyJpsYqyR9jZ3uKVlyeYD
         b4wbjz8mo67KciMqOyq/mnShoTLeb+H6pj0MNlvl7y1ocxc6wGqHo/2NTcL+HwwkNmwE
         cG/4Zx82EmXchg/cPLa/v+hmQu776nYMB9CSVLYVVQmnGQiqjd7VJJl0dwkr/cnCNc1D
         ZsXg==
X-Gm-Message-State: AO0yUKXnFfxmmkciL/jNKVreCb02jap7wqE1SZEvCPWIGDy46BOGXYBm
        tqq8tooyXn2vLxBH76HiU5PKZeb6wuFM8l/HbUQ=
X-Google-Smtp-Source: AK7set9UZmy1JLTptYWNL49TpmHwgzTbva+tNV5YgDEYEgQr2qQx+tKMCm0Kyagi850Vs8HnwJQpGg==
X-Received: by 2002:a9d:4b8f:0:b0:688:4892:e1d3 with SMTP id k15-20020a9d4b8f000000b006884892e1d3mr2206720otf.8.1678387928058;
        Thu, 09 Mar 2023 10:52:08 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:d22f:e7ce:9ab3:d054])
        by smtp.gmail.com with ESMTPSA id o25-20020a9d7199000000b0068657984c22sm63248otj.32.2023.03.09.10.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 10:52:07 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 0/3] net/sched: act_pedit: minor improvements
Date:   Thu,  9 Mar 2023 15:51:55 -0300
Message-Id: <20230309185158.310994-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to improve the code and usability of act_pedit for
netlink users.

Patch 1 improves error reporting for extended keys parsing with extack.
While at it, do a minor refactor on error handling.

Patch 2 checks the static offsets a priori on create/update. Currently,
this is done at the datapath for both static and runtime offsets.

Patch 3 changes the 'pr_info()' calls in the datapath to rate limited
versions.

Pedro Tammela (3):
  net/sched: act_pedit: use extack in 'ex' parsing errors
  net/sched: act_pedit: check static offsets a priori
  net/sched: act_pedit: rate limit datapath messages

 net/sched/act_pedit.c | 58 ++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

-- 
2.34.1

