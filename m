Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9854A4D2957
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiCIHSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiCIHSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:34 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636E622C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:32 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id w7so2135988lfd.6
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=m3GPbxAbOk7KXB8pnRLcY0PuiFw2Grw9/bv7yF3L1IA=;
        b=LPuWoooxEY5WSS0UbPaj7Mr95wAOtisle7F1umWq4l952eui6/5/lJMfpuL31yJLEp
         GWmbIAlQIYUXfloosSKNdmQvb/IqiofX5wf49u0T9r7y3XphNLJjTnCmHG+p14k8zXHI
         avWfWmjuyBVHaCMkYK0+h8mO0OangQtMKS9FSy4q+CXCf7r0jfT6W7VU6L01v53FWm35
         066KjbSqRLjXXSRItYdB4euY1bG0jFrVf0XFuzuxTL06MW0NowAs5imDWs4vdrKcd5qi
         C+IMPeaplMj+ZVgGICiR3eDz1cvAFXSIVUEQdL9cqLDsjtXnbttcRJoSWNsd6z0noF92
         asyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=m3GPbxAbOk7KXB8pnRLcY0PuiFw2Grw9/bv7yF3L1IA=;
        b=Wc4VGEPsBbx8Mue+6WOowMQPjqT93+xh0Wx5U6VRYTu8ictYSZtFJLiyLK92xEaFwu
         GnjGnxz4+XiBmPTVmJVRB+iQL94scPDaRWhNKNUf6yrDP6y3sTwjR/7FiMONp9V4FMoo
         Bl1+Bxq6FUH5XeUqG7Sf0NdXBoZie7AZKX9KdvI8WTx7P+NCc0mNPbEat5Rh86BN9ozF
         ZlDRiasfIdhyulWZDxLueQ6en8x5fKO5AiI1k7FaH6E+Qw2jyu/3EjV0yFz8FTK6JHdz
         Md3h0rJ8D6fJqEBusB6XDKohJHehIdrmH/qbuLIOX2qwug4U1Hjg3g3UQWVIKsGNxvk3
         vvoQ==
X-Gm-Message-State: AOAM531YQFcm71l+3MldaOqmHGqnF5lvOZGnX5Wopp2cjQ7v7C9O7Jmo
        f2X32jjVmYkiqqisR+1Tmqmc1uTMTtxNQA==
X-Google-Smtp-Source: ABdhPJz0YX1QPQOLg3fpkkp4b4IXFRgjSVQ6sYyBepIEQ8BVnh7atg3xlep3WqcL/4+s+jAoqrF56g==
X-Received: by 2002:a05:6512:128b:b0:43c:9b6:55f6 with SMTP id u11-20020a056512128b00b0043c09b655f6mr13140610lfs.196.1646810250198;
        Tue, 08 Mar 2022 23:17:30 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:29 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 5/6] man: ip-link: mention bridge port's default mcast_flood state
Date:   Wed,  9 Mar 2022 08:17:15 +0100
Message-Id: <20220309071716.2678952-6-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309071716.2678952-1-troglobit@gmail.com>
References: <20220309071716.2678952-1-troglobit@gmail.com>
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
index 6dd18f7b..11a02331 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2454,7 +2454,7 @@ option above.
 
 .BR mcast_flood " { " on " | " off " }"
 - controls whether a given port will flood multicast traffic for which
-  there is no MDB entry.
+  there is no MDB entry. By default this flag is on.
 
 .BR bcast_flood " { " on " | " off " }"
 - controls flooding of broadcast traffic on the given port. By default
-- 
2.25.1

