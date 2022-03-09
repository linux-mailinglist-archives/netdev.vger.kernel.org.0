Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62694D3A43
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbiCITZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiCITY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:59 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE811517CD
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:42 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id r7so5568700lfc.4
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=FzOJ/Ks2HLgaddOH2GWG2z39nsX3lCqCV8359sYnn1o=;
        b=kwcBMrs3QJJ8cXwDXyX9HixGlQDOVYAfSi+FdhE7Cp/I5nBaNti6AyeIogf62w6THy
         Q3rzvz+NZT/iYq5E21GEvrSZUFicFslHcDWHpVm4Y5ur56mVo4Cow4hcDteLI9m5Fvcs
         DilI4gjdEOukdJKgADMfvOvK5jCA3+MA3Zp5idKNUgSJoTtb3wWOIGVhDquCBYvyzdYg
         3WmTh35H5bV8s3T/JTOFUH3LUvKrBAGi0g/gLFqgvkIkCdv1pkC7JLHnEQcHVAE1KfI0
         H1p96bJROGbK/wwdB4tPuwhQFd158TT1V2eS+8/xZqiO3Hj+UNns6yH29hFgI8Ev/EBc
         qyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=FzOJ/Ks2HLgaddOH2GWG2z39nsX3lCqCV8359sYnn1o=;
        b=mTpcsH1/Vh+cSYTgFaKs/o8iEM5R7bFftKxV5lywnBQgSpYG86z7lWCdqxx8qHf4zl
         K/TF1ThIikrYTIQwlTvQV+ohmdF0a4VBSZYvYhkXByZWtk+foShpIfKBtsdLS2rxl6wk
         XPo1W5/7zhFunBaJ8CQ5slnWihNmz4r8o52WffzNiTZTvJumH4/2EFexblY7/Crn/cTl
         R0gHlw2HiQG+x56z+If+ENLSaSKijyl/tRTtwPeddxhj9fem+eWb7ufthj1bEdMONqVh
         9mVdndXirgQjVIzpi+uxfPZlIPFU/ILnPvHGAwMRsJYxlPoQNG13RPUa0O3g/O/d1Qy8
         +E2w==
X-Gm-Message-State: AOAM531gZBVqqIHYM73jfjw6OJxZkw9rMvXjHUHkWh8GIe70OQEePRvw
        5JqxylWY4xaZ4cr4n2ghnkmMCTUb+Ub+lQ==
X-Google-Smtp-Source: ABdhPJxhFsDYvTdI9zU+YmXGVcIcb7XJE95zZ4/kMhPlZEWmpZE5faInRPL/CwtZMfIaq3JZuCFIrw==
X-Received: by 2002:a05:6512:4009:b0:445:89f0:2b44 with SMTP id br9-20020a056512400900b0044589f02b44mr691424lfb.284.1646853820736;
        Wed, 09 Mar 2022 11:23:40 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:39 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 6/7] man: ip-link: mention bridge port's default mcast_flood state
Date:   Wed,  9 Mar 2022 20:23:15 +0100
Message-Id: <20220309192316.2918792-7-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
References: <20220309192316.2918792-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/ip-link.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c0e7f122..1237ff4c 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2458,7 +2458,7 @@ this flag is on.
 
 .BR mcast_flood " { " on " | " off " }"
 - controls whether a given port will flood multicast traffic for which
-  there is no MDB entry.
+  there is no MDB entry. By default this flag is on.
 
 .BR mcast_to_unicast " { " on " | " off " }"
 - controls whether a given port will replicate packets using unicast
-- 
2.25.1

