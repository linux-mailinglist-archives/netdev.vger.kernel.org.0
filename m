Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876CB4EDDD3
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbiCaPtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbiCaPtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:49:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2921E1115
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:47:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bh17so180735ejb.8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ceL3rrobO62pRqbQJpFz8Xqqz+HKAu2eXCjmko04QLA=;
        b=UlrTumDhGUp7njzi1JJnKgJpPPY52A2V7wjzPGH5LJj0Qk+LTddd8kKvckS2+LuKT3
         UF2BMqVOIcPJUYnogME0NaqmZeL51w7FzyMFy4CKzv94O8fy90wCQ+lUWLaz0hpeLzk8
         s+d9Xf4uaskG6GI26apcW/SjtqyGtuyp2XknKNfde4zXsUhnLm7cOHoz83F9pf6SoxFp
         MGeLqzvKp2ieBXt7Me6LOxJTSPi5JNWsFRWtfJGoCpeV39X+hqWLGYPrhIPAkPJUlkau
         v6PlHZj85n4Npp3pJILZsQk4PWEGsdG50MtTwPKjUnXPt544cc1RBLQOUg8XnZnnzKJS
         yLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ceL3rrobO62pRqbQJpFz8Xqqz+HKAu2eXCjmko04QLA=;
        b=3/snU65h/dhFz08GyoX3P3PLl7h+fGDeg9KYUVAoTlvwxX1IVKbuATRKOpIKYz/yQZ
         zU9oWqm1Z0Loy3jkwzEE65aJP9CpqMVT90ZnVb9SvC2e7Nl5KRWFEJpvscIBVXf+f259
         xNAQ8cd0ROSChMVc7QvFsbCzwHsPhPHfjz6KDjG6zZuaD2YCRcp7iqlkRbUV3qlEhWcT
         RHMuDjnhhJd6BeXkDlipK3CB6R017mv6t9yv8u4RO2sjK3Epa0jip6tROnlDDSpHO8mm
         X8uMt0flN3cef5UUMxSmqxgkTpQvXwZ0PwS90HWYdMT4ytwzGofQNDurghGDw5FJdIB0
         NQkw==
X-Gm-Message-State: AOAM531eQhro7XidbpA7z5RVKBiDW0zc9s5mV8DjnLV7y47aGM/sV/Yj
        6UroVaSEikTi6vsxi/7gmjfqsLPzwPpev3PH1e4=
X-Google-Smtp-Source: ABdhPJztvgd8xmDAyuNAb+NSPbxz2SvRSnHPN+w0mRA6EXQpD2/rQnSHNfieY51j77i7xQXVMWWqMg==
X-Received: by 2002:a17:907:2cc6:b0:6e0:2196:9278 with SMTP id hg6-20020a1709072cc600b006e021969278mr5538499ejc.438.1648741663854;
        Thu, 31 Mar 2022 08:47:43 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id dk21-20020a0564021d9500b0041b501eab8csm4016576edb.57.2022.03.31.08.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:47:43 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, donaldsharp72@gmail.com,
        philippe.guibert@outlook.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org, Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net 0/2] net: ipv4: fix nexthop route delete warning
Date:   Thu, 31 Mar 2022 18:46:13 +0300
Message-Id: <20220331154615.108214-1-razor@blackwall.org>
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

For the fix the alternative would be to do matching on the nexthop's
attributes but I think we shouldn't since it's old-style route deletion
and nexthops are managed through a different interface, so I chose to
don't do any matching if the fib_info is a nexthop route and the user
specified old-style attributes to match on (e.g. device in this case)
which preserves the current behaviour and avoids the warning.

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: ipv4: fix route with nexthop object delete warning
  selftests: net: add delete nexthop route warning test

 net/ipv4/fib_semantics.c                    |  7 ++++++-
 tools/testing/selftests/net/fib_nexthops.sh | 13 +++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.35.1

