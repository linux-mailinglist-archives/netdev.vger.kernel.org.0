Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC14D3A4C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbiCITZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbiCITY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:58 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9F846653
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:36 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id q5so4633230ljb.11
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=9JNCb1ZpVOQ+OkEvOrNdVp/HgSslvTIVnuphfIJytNo=;
        b=epRhEZXRgH8Nx0nPfK28gEw6qqRydjWON2UrpjZWtT1SoTGRkr4YYXA1lpKXCsdA8Z
         k1R9IqoXU66BAXCKzPs/YVfAJABPlnw0PZf+cL/sxfScLiNHmXmfjGQ1Pbeixc5Uoc1U
         tFtDqiAvzqQYe26CO/VR16XU1o14Imm98Oc9esYLPWcjvUFY2FMjJ+v9OSsNVweZbHN/
         dmEGyTm4rgWfBmdcW7PlKyXYqPajNOh3c17ZuaIsxa8Mj1fm5SoQIm/guTjzo3u8ZeBN
         tAfIHAPeNCYH6isCap+4cf+Lzxq+rXBeinCUPCVrpQVeHakr3Xq8BpYAspjASMXQbEbP
         AAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=9JNCb1ZpVOQ+OkEvOrNdVp/HgSslvTIVnuphfIJytNo=;
        b=JSlzCTEmmU4jpUnGatpJL4g4VhS84cIkiD2OlP/QZK4XxXlKCfe1CMpwxmtiwJdl0i
         eDtFsRxW9Rpc/5uifWaLMBdvDV0vyGKepXtjmbWzu4VKXdhLZ4GBJwhd6Wp7LVtDWf0X
         RQMdYctv2qqOxyXiaXZUnKmwto5439HdqFXHBuvr4Oy2tVA7GbiSmcb0ppT9l80NQ+ZP
         mGK93ekQTh6YNfA65WtPrn/MLbjhz2Z77iAbVH3HWiiKKrD15KkuiZsOa+FnRE6iMS6P
         HHruPXGki/BzYSF26u7OLpxvbKys2h5n+9UE1nou3bVYNEypmr25TE6A9L7bEY8lJ8dW
         VbtA==
X-Gm-Message-State: AOAM533kPQ3R0JNA0r+LfEFGcjEhAy+qnCK9R0o2HTC0ludj1x21R1qV
        1EFZ8LMFn1xjqC0OQ/DfHnB+qOk3KFuXXQ==
X-Google-Smtp-Source: ABdhPJzwxlAIMram/GV5sdTNQFXM0dPzCkDI6Ing4eS6/XzHB4fwoDWjKAuk6DCVplYI/CCt9MxHBw==
X-Received: by 2002:a05:651c:12c5:b0:23e:1f55:35b4 with SMTP id 5-20020a05651c12c500b0023e1f5535b4mr671259lje.58.1646853814293;
        Wed, 09 Mar 2022 11:23:34 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:33 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 2/7] man: bridge: document new bcast_flood flag for bridge ports
Date:   Wed,  9 Mar 2022 20:23:11 +0100
Message-Id: <20220309192316.2918792-3-troglobit@gmail.com>
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

The bridge link options are not alphabetically sorted, so placing
bcast_flood right before mcast_flood for now.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/bridge.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 81ce9e6f..a5ac3ee2 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -45,6 +45,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR learning_sync " { " on " | " off " } ] [ "
 .BR flood " { " on " | " off " } ] [ "
 .BR hwmode " { " vepa " | " veb " } ] [ "
+.BR bcast_flood " { " on " | " off " } ] [ "
 .BR mcast_flood " { " on " | " off " } ] [ "
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
 .BR neigh_suppress " { " on " | " off " } ] [ "
@@ -461,6 +462,11 @@ switch.
 .B veb
 - bridging happens in hardware.
 
+.TP
+.BR "bcast_flood on " or " bcast_flood off "
+Controls flooding of broadcast traffic on the given port.
+By default this flag is on.
+
 .TP
 .BR "mcast_flood on " or " mcast_flood off "
 Controls whether multicast traffic for which there is no MDB entry will be
-- 
2.25.1

