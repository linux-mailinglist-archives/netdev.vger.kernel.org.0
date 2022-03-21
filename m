Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0711D4E2E1D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351295AbiCUQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351279AbiCUQdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:33:46 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FE41877E1
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:32:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r22so10911561ejs.11
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=RpaJWnAf2rDUakFbrGje6X31hkHThFND4YL7s3N2H5Q=;
        b=RcaksR3otle+Gsg9Y4CUR8nW8LGymVRd7KbTwzCjs7zAxopSDIGWnPxjQEJ0ghRWU0
         NVHTgGp9UXDL2zmuJMS+JF+h8EE5j0rxvCJN4kljOKbtcuOlwT1CtCne9du9IN7YH0ec
         Twy7Q552Kz4k0hzQIOt0p9xMOG4bwlbLZhWbq7VMZrnR14s1S78SIzgOYJcYGAL620hW
         T/w1MSBALLICG4CUni0Med+UahdLlwjCzW6lVdZzUMwwCT12D0nPvKnWYCdhzbUBkCth
         tOEftQ8VrsI8Fu09gm2yZXabjY2jWPXgcD4ZfQMqun86ajCU0DXLJLiIrvHhC3qljD7L
         /KbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RpaJWnAf2rDUakFbrGje6X31hkHThFND4YL7s3N2H5Q=;
        b=kes1oCr76rOVMvCLfaKv7cVyuH7/G12nZp3noWUn2fHTWp/EFH+CtkG/qzzmryAqf5
         Nj8Nqbd9Cg7asq/sOeRAedoMaYQ2qSOvFcg+vfATBzQJVkbDY66WmcF0QL2lP+wOy5Ye
         XXBxzX57OBPrOWwttuAmMT0TV8E+41HO5MKSgtUuVNwvROuuuFEv759g9+C6g6Ljq5LK
         xbtCtx1dCTgMcYh6+OcrrlVUM+qQMGg095aDUt3abDMJXySR3LEii0fngTcUXYWTF3Mc
         IIaBVHmtSj+tUuU4cU3zECyyWXa6wg+Mgn2Y/atz00b24B6YKXzzMXNIwGRfPOCkyotb
         oqaA==
X-Gm-Message-State: AOAM5331AGpJ//QDu9+xTwaSRj5ni+1OmuW2Bae+k/wZKiO95MamI6Dq
        qWWqj2+auos1fxlWbe8aky0=
X-Google-Smtp-Source: ABdhPJy7JcJeCQy0OXCsbl9MRsmzEYrQCs/L1pIPU0FyORmeUVS51hykRlCMBeJB63Yj/ScbomRDKg==
X-Received: by 2002:a17:907:3f12:b0:6df:e7c1:9afb with SMTP id hq18-20020a1709073f1200b006dfe7c19afbmr9784062ejc.84.1647880335533;
        Mon, 21 Mar 2022 09:32:15 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id v2-20020a509d02000000b00412d53177a6sm8179653ede.20.2022.03.21.09.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 09:32:15 -0700 (PDT)
Date:   Mon, 21 Mar 2022 18:32:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Possible to use both dev_mc_sync and __dev_mc_sync?
Message-ID: <20220321163213.lrn5sk7m6grighbl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Despite the similar names, the 2 functions above serve quite different
purposes, and as it happens, DSA needs to use both of them, each for its
own purpose.

static void dsa_slave_set_rx_mode(struct net_device *dev)
{
	struct net_device *master = dsa_slave_to_master(dev);
	struct dsa_port *dp = dsa_slave_to_port(dev);
	struct dsa_switch *ds = dp->ds;

	dev_mc_sync(master, dev); // DSA is a stacked device
	dev_uc_sync(master, dev);
	if (dsa_switch_supports_mc_filtering(ds))
		__dev_mc_sync(dev, dsa_slave_sync_mc, dsa_slave_unsync_mc); // DSA is also a hardware device
	if (dsa_switch_supports_uc_filtering(ds))
		__dev_uc_sync(dev, dsa_slave_sync_uc, dsa_slave_unsync_uc);
}

What I'm noticing is that some addresses, for example 33:33:00:00:00:01
(added by addrconf.c as in6addr_linklocal_allnodes) are synced to the
master via dev_mc_sync(), but not to hardware by __dev_mc_sync().

Superficially, this is because dev_mc_sync() -> __hw_addr_sync_one()
will increase ha->sync_cnt to a non-zero value. Then, when __dev_mc_sync()
-> __hw_addr_sync_dev() checks ha->sync_cnt, it sees that it has been
"already synced" (not really), so it doesn't call the "sync" method
(dsa_slave_sync_mc) for this ha.

However I don't understand the deep reasons and I am confused by the
members of struct netdev_hw_addr (synced vs sync_cnt vs refcount).
I can't tell if this was supposed to work, given that "sync address to
another device" is conceptually a different kind of sync than "sync
address to hardware", so I'm a bit surprised that they share the same
variables.

Any ideas?
