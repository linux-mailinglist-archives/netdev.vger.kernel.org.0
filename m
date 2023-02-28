Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F786A59D4
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 14:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjB1NJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 08:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB1NJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 08:09:13 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5158D2A99E
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 05:09:01 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id ay9so10225796qtb.9
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 05:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vat3xeQmZTiFLEDSKZA59+N9HaKxMBir5fZRmbqi8hA=;
        b=BuHwNJofDg+Udck252yy+ba7SqGxhgMPzNX5yBs9KShV6qyQkjVhEGILYp5y9cByOu
         GXrbnhi6JELzZmWF056QxoPguYh/yHok9EYoHpo7TXA2O2y8I0Qb2XC9E79K2jxMYRQl
         Ia9YGTrD9tfM4yPZOCMxmlSAvimeUxwKqpZ53WSrQXJbbdLJCnBRQ/f2i3IAnLa8RjbC
         FpXz3RLCgAYA7QA4ge8ZXLK6iJfDH+CXSW/9OpPEBC/rEwBeT1Z7iLwGCGb+QqBZyu7O
         sL8cOvREpI3tQZ6ZmP0r1KkOEgP0SlkAzfgeNaPHa0SoTIn2oOQpYyhmMcmTos1NGr/q
         K4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vat3xeQmZTiFLEDSKZA59+N9HaKxMBir5fZRmbqi8hA=;
        b=UG9+Nm5vAsvCsvRUptaQ8KNWnLgLUyJmOfaZUH88bR63XSjI64jJM6evXN3T4qQa1h
         yI9Q/89pZB6IJJlvZ7komSQzzad0lHmdZyD+YWmFllY288jFJba3963m15ZZFiVufAc5
         zszDc2Jow3v3o1VdDQqe9DGz9tTRr7Ce4/06HQhNnqF6nTIS5hxwsGKw5yLpSDA+quWx
         vTjwNpH0tzbw1ZC55xUn0hjZ5qWpErm7oReWWvwxYm2X5/sM98zzlwTnBQqSq7qJoN5I
         uUhPCx1e9HvHIN2XMM7PWWRTRlzeQIIO1ceqO+jVlsgD8ljmhkO21XwGkIkWkpSXa+0e
         xWUA==
X-Gm-Message-State: AO0yUKWunbbE71Bk6bRZJRnJV92znneHghAqntdCRhk2L3SZkVz2serD
        4ChUVpgUo3giKWz+8rQVrTU=
X-Google-Smtp-Source: AK7set83HOyGzm+5IgGYMIt3g4B0RQqxlu+QOpSe190KOU9wQwh8I9F+WG2Nxw3bwQg/iKHyVb2ENg==
X-Received: by 2002:ac8:5f08:0:b0:3bc:fc11:b368 with SMTP id x8-20020ac85f08000000b003bcfc11b368mr18640910qta.19.1677589740302;
        Tue, 28 Feb 2023 05:09:00 -0800 (PST)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id w9-20020ac87189000000b003b8484fdfccsm6426832qto.42.2023.02.28.05.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 05:08:59 -0800 (PST)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id 7350D2B5DE;
        Tue, 28 Feb 2023 08:08:59 -0500 (EST)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id 628E260025E; Tue, 28 Feb 2023 08:08:59 -0500 (EST)
Date:   Tue, 28 Feb 2023 08:08:59 -0500
From:   nick black <dankamongmen@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <Y/386wA5az1Yixyp@schwarzgerat.orthanc>
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
 <20230227102339.08ddf3fb@kernel.org>
 <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
 <20230227104054.4a571060@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227104054.4a571060@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not want to export any further stats via sysfs.
Applications ought be using netlink. Note this at the end
of the NETSTAT_ENTRIES.
---
 net/core/net-sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git net/core/net-sysfs.c net/core/net-sysfs.c
index 15e3f4606b5f..c00a0f332a22 100644
--- net/core/net-sysfs.c
+++ net/core/net-sysfs.c
@@ -714,6 +714,10 @@ NETSTAT_ENTRY(rx_compressed);
 NETSTAT_ENTRY(tx_compressed);
 NETSTAT_ENTRY(rx_nohandler);
 
+/* end of old stats -- new stats via rtnetlink only. we do not want
+ * more sysfs entries.
+ */
+
 static struct attribute *netstat_attrs[] __ro_after_init = {
 	&dev_attr_rx_packets.attr,
 	&dev_attr_tx_packets.attr,
-- 
2.39.2

