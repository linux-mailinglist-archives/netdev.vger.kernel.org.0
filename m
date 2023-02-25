Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DA96A2BD6
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBYVMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYVMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:12:18 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F95594
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:12:17 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id r5so3042310qtp.4
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8jwlx4sx4m8JaUQ3fEdfjTqukr1VdMeTCx8COX8p2ko=;
        b=E/6Bi64AAWNu5Xx+LFUlAckBld9nM+e88IFwaf/0kqIito0n/9/wDJfm3MlGytLnBB
         IH19L8EjiRqp9F8EOMrA1F5824T/i/pV7IAVpSjQyNPBJTZLGditP9Tea3SnJvdQSRML
         XpjpXLOmGPPFRAkrx3shloTcdJBOmwJGUTlcOxRzxV9LMnNvVj/15id2bz0yFKypMwcm
         kVpZr2HwJpQn/KeaR8ahckpdDpwL4/QAIj8qXIAHEfI7d4s5HCztXPL6iIKqb35fM3R4
         96o4IeoOB7E6n8isl1ZkWjyRa1aHyt5LCun2bXtVExW0F0v0750XgDJYW3FbdSGgUgKe
         /hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jwlx4sx4m8JaUQ3fEdfjTqukr1VdMeTCx8COX8p2ko=;
        b=H7R0XGkQvCx0zSdb2W8BMDnhDpDdY24qgMjt9RU39hjkztmC+dBWK7izNqcB/DN5Hx
         ksspbq9skiAL6T8KrxdpifzQsheLaDmWjLTq+H9Hbw6htETx3B4boAkUu0yPYprziqcq
         gOZ2l8Ls/ICYz6frTB/f/7nWkbxagFhyjKYPS1dFKQrbqYevzuK4Atpcv9oop6f1JbS/
         cUTCGy/2rkp231zG0QF3t16Q03GBpgmYqK3QpkaEMfNq6+2ptpMH5seK4PQl0xCuVvYZ
         NAle5AJ0sJhMMCsF1eUXzUbEnByZo/Pm6Vo550devXcnTc7hVx0qOC3Qg1FA+h1ziE6g
         2vwA==
X-Gm-Message-State: AO0yUKX7Gm+4KiOJnaDMLIv/iypWVvHdW/yDPqUToe5ifRTwsFIT9348
        ADWX3Zno4u/iC1g/20ndQmQ=
X-Google-Smtp-Source: AK7set8J9VPXm6vOyi1OWqasRoFnnPi9nfn44iybPKmjeAXXvCv8njDWKNZcSvHLg/dmO5tBnbJYwA==
X-Received: by 2002:a05:622a:454:b0:3bf:b820:f16e with SMTP id o20-20020a05622a045400b003bfb820f16emr15144901qtx.54.1677359536822;
        Sat, 25 Feb 2023 13:12:16 -0800 (PST)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id e7-20020ac80107000000b003b9bf862c04sm1839198qtg.55.2023.02.25.13.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 13:12:16 -0800 (PST)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id 1689F2B627;
        Sat, 25 Feb 2023 16:12:16 -0500 (EST)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id 0C196600354; Sat, 25 Feb 2023 16:12:16 -0500 (EST)
Date:   Sat, 25 Feb 2023 16:12:16 -0500
From:   nick black <dankamongmen@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the sysfs export for rx_otherhost_dropped, added
in 794c24e9921f ("rx_otherhost_dropped to core_stats").
All other rtnl_link_stats64 entries are already present
as sysfs nodes; this completes the set.

Signed-off-by: nick black <dankamongmen@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-net-statistics | 8 ++++++++
 net/core/net-sysfs.c                                 | 1 +
 2 files changed, 9 insertions(+)

diff --git Documentation/ABI/testing/sysfs-class-net-statistics Documentation/ABI/testing/sysfs-class-net-statistics
index 55db27815361..97ac76af30a4 100644
--- Documentation/ABI/testing/sysfs-class-net-statistics
+++ Documentation/ABI/testing/sysfs-class-net-statistics
@@ -104,6 +104,14 @@ Description:
 		Indicates the number of received packets that were dropped on
 		an inactive device by the network core.
 
+What:		/sys/class/<iface>/statistics/rx_otherhost_dropped
+Date:		February 2023
+KernelVersion:	6.3
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the number of received packets that were dropped due
+		to mismatch in destination MAC address.
+
 What:		/sys/class/<iface>/statistics/rx_over_errors
 Date:		April 2005
 KernelVersion:	2.6.12
diff --git net/core/net-sysfs.c net/core/net-sysfs.c
index 15e3f4606b5f..fe8012308696 100644
--- net/core/net-sysfs.c
+++ net/core/net-sysfs.c
@@ -713,6 +713,7 @@ NETSTAT_ENTRY(tx_window_errors);
 NETSTAT_ENTRY(rx_compressed);
 NETSTAT_ENTRY(tx_compressed);
 NETSTAT_ENTRY(rx_nohandler);
+NETSTAT_ENTRY(rx_otherhost_dropped);
 
 static struct attribute *netstat_attrs[] __ro_after_init = {
 	&dev_attr_rx_packets.attr,
-- 
2.39.2
