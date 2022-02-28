Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1854C6E62
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbiB1Njq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiB1Nhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:37:52 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1747C168;
        Mon, 28 Feb 2022 05:37:12 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id d23so21341118lfv.13;
        Mon, 28 Feb 2022 05:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=sl3SNWw/iEwHgcBhjPIPKrVhXnVmwmOVqS06iT8fRQs=;
        b=j6vJNGX4m6/chkpMUR5/XAxHBIUz2GXLgRZIhZW2yC1svIDugBWA5H7bYlbP+vcgVf
         a+AvTjEVOlqHNceUKbGSk7BUL8dM50ZPVwYjJ/4mPtimCapkxefC5ZDlH4BkCkm1JshY
         p4/VhI4r+5+V0hUpUOyBN7ZpPFIV+MW8tHv7bD6yfSrSJ6jXbqArYo9uyECa+ySEn97M
         th9Ed1f1Vy1nfhiccE8Q7B+jIB8oHOidVo6wgXLuYU7Ozxe5lvSbEgPuXpbnfqpOM/IZ
         uno8geFTtvQ6NymmCdfFCEOKPs020DWoxGVFufQv7HiwtJlkKahwuCg9hnW1otydosPx
         NBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=sl3SNWw/iEwHgcBhjPIPKrVhXnVmwmOVqS06iT8fRQs=;
        b=hKXkLFzy7erYN+mK4x0HAYCjyVK/nnZSBzYdjHZAadAw6/2StajtsjT2RW8y2YN+h+
         3sYhk/IjMKlXJRu+FAexGGT1cKXJhoiBO+PXtrLoM015uWCcXupaZYZIIBfraH9mIgJ0
         vRhxoqMlRMvu7Mq3OELydEpIjbugcpyxZHzJYV4cI9OMmJltGNM+l5TvpCUd3H6fIc2D
         fjM8HaUPr669gDdeUPvy2Y1rk51d20RhOO1R7N1IOJNLaJso+1pPtXiybTCdz5CeCHXQ
         SzxnEs67fbugydGOESTd6gd92ZU851donSoF0q4E8pt/EPYeT7gALYcSQritIle7YSpd
         oj/Q==
X-Gm-Message-State: AOAM530aY7O0gaH0C7Lay8Vdf4acf7M8wf1TMUfPGVqqCdWd3WdAz9kK
        1KDCtg5LxtoT+sjiqH8MO90=
X-Google-Smtp-Source: ABdhPJy+aqzQxUvFD8+nnFUg7+O0UWXkXjTkI2fIPjK+pUPAq6RzxAzdA2opC7b3eUl5UlwJMx6n9g==
X-Received: by 2002:ac2:5c48:0:b0:442:eada:dc45 with SMTP id s8-20020ac25c48000000b00442eadadc45mr12421182lfp.640.1646055431090;
        Mon, 28 Feb 2022 05:37:11 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i16-20020a2e5410000000b0024647722a4asm1326640ljb.29.2022.02.28.05.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 05:37:10 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next V2 3/4] man8/bridge.8: add locked port feature description and cmd syntax
Date:   Mon, 28 Feb 2022 14:36:49 +0100
Message-Id: <20220228133650.31358-4-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
References: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
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

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 man/man8/bridge.8 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 81ce9e6f..cb0ffc16 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -50,6 +50,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR neigh_suppress " { " on " | " off " } ] [ "
 .BR vlan_tunnel " { " on " | " off " } ] [ "
 .BR isolated " { " on " | " off " } ] [ "
+.BR locked " { " on " | " off " } ] [ "
 .B backup_port
 .IR  DEVICE " ] ["
 .BR nobackup_port " ] [ "
@@ -513,6 +514,16 @@ Controls whether a given port will be isolated, which means it will be
 able to communicate with non-isolated ports only.  By default this
 flag is off.
 
+.TP
+.BR "locked on " or " locked off "
+Controls whether a port will be locked, meaning that hosts behind the
+port will not be able to communicate through the port unless an FDB
+entry with the units MAC address is in the FDB.
+The common use is that hosts are allowed access through authentication
+with the IEEE 802.1X protocol or based on whitelists or like setups.
+By default this flag is off.
+
+
 .TP
 .BI backup_port " DEVICE"
 If the port loses carrier all traffic will be redirected to the
-- 
2.30.2

