Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BEC4EE929
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 09:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343898AbiDAHgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 03:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343888AbiDAHgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 03:36:38 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD5A1DEC35
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 00:34:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b15so1937221edn.4
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 00:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=733G+MW1dmhvLTjMVV9ykiGgxnQLVhhzwd5R01Rjcy4=;
        b=YxHXT869B04lw5XGFPEUnWDpLFfp/zQsAAfBGq4u3RPynsUx5vEU+UsBa87rFLPzNa
         lRoiq9SP++FXWzuEPzKArJdTYaHFNS1SSZ/AJL9nZLZCMfeGnX8vsABVY6iZt1wfCn28
         h93/RhW+3FedHUGzCErX0jGootBQe+nl1vhWyOHKpEdq94kDIN101HVV2wMyb8W0kyQQ
         cZZxt7q24NRzFo8SsRwWdCBQ0eYz+HsXS16jGEnbJ3MtJLLMj1klrvo5kMKz6RNwz14H
         4ZajdN7AV2DkofxKi6Y3t0SxtxOS2fJyuXLQH/TbmNcFcshElYS/p/EB+stkzBDRAIVS
         oKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=733G+MW1dmhvLTjMVV9ykiGgxnQLVhhzwd5R01Rjcy4=;
        b=nt2l6mCstGEVgJYPqgoifI9i2GJ9MetOX2aONQALlBfkWUuNCNp0nZ4GXc+PWoOo9O
         6GEPpc//KdrCSymVGcsXsyMib6yb+wFfS/EAdSful41EoKD8QO7OIh2Yaq7kdJh7D1qg
         PISDnJVUYHpsp0hyfyZREix/Zqa4m81SNCYL5TNMprgP9Dn7tc239KXlixDLNl4s8b+8
         NJwE1FkJO9sLEegToH6rFu45zHK7oHLKNeCAFH5HUcacKI4r/MgnwYeH/kmHLO8PkaMf
         umaBC5B4F1fNX5aWHoZUDbOaUzDBFEiagRncb1F15F4lVQNwu4kqWxlUnfRJF1Grk4Y9
         l2aA==
X-Gm-Message-State: AOAM531IwKsQ+dDrwHZR0mlX6nm9SbckOqghaLueCYI2rENqP0zYPul4
        WjR2246ZKkdDzkw+8h2E5XnWeUH+Ut42CYmTnI4=
X-Google-Smtp-Source: ABdhPJyYd/HvkD443Y8DXa3bKg0exiDKSBD5NiDKwdHxYyM2GipZbn5BAW0GShiJcyYbvJC/wwS3JA==
X-Received: by 2002:a05:6402:649:b0:41b:71d8:9594 with SMTP id u9-20020a056402064900b0041b71d89594mr10110239edx.371.1648798483831;
        Fri, 01 Apr 2022 00:34:43 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id b7-20020a509f07000000b00418f85deda9sm816663edf.4.2022.04.01.00.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 00:34:43 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, donaldsharp72@gmail.com,
        philippe.guibert@outlook.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org, Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v2 0/2] net: ipv4: fix nexthop route delete warning
Date:   Fri,  1 Apr 2022 10:33:41 +0300
Message-Id: <20220401073343.277047-1-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
The first patch fixes a warning that can be triggered by deleting a
nexthop route and specifying a device (more info in its commit msg).
And the second patch adds a selftest for that case.

Chose this way to fix it because we should match when deleting without
nh spec and should fail when deleting a nexthop route with old-style nh
spec because nexthop objects are managed separately, e.g.:
$ ip r show 1.2.3.4/32
1.2.3.4 nhid 12 via 192.168.11.2 dev dummy0 

$ ip r del 1.2.3.4/32
$ ip r del 1.2.3.4/32 nhid 12
<both should work>

$ ip r del 1.2.3.4/32 dev dummy0
<should fail with ESRCH>

v2: addded more to patch 01's commit message
    adjusted the test comment in patch 02

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: ipv4: fix route with nexthop object delete warning
  selftests: net: add delete nexthop route warning test

 net/ipv4/fib_semantics.c                    |  7 ++++++-
 tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 
2.35.1

