Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850A369399B
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 20:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBLTN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 14:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBLTN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 14:13:26 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E81BC14C
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 11:13:24 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w3so3311976edc.2
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 11:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=iTLtKOMUGyn362t2wor8zApRNxkt89Zb8Mo59QFVVq0=;
        b=kWi9EYth2X8quXhSnmy6+hBNy0SENQWtL2MA4hv3ZJ04LKOVcp29Pc598izFxJakWB
         qHGlx+A7ii2j6/0SEgGHjaMdHb0Pjuij8zi8cRxUHuGzvXm5Ia1FDHfkbASXlKywnY9N
         HBL0Hh1pVZm5i0sPIoZrErwU/oB6HtXcnstNXgHO5cYfUdMCmRs+iRmfN+tlyTN0/E3m
         8Oq3+6ncmm4VaPBxj3qBSXrnEmIakjJSjbnZ252ieq44WjZ3uHHGQ0GMJ3XS6/qF+o1b
         +KpUqvOv/9pLIT2LfLBSTOnFuvkJ5CBmuj5SrrijrcmmVyawz+MDM8Vep1rODgNVLeRp
         OiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTLtKOMUGyn362t2wor8zApRNxkt89Zb8Mo59QFVVq0=;
        b=jEH1rlMtybBPZFFhb5bJqL2w2D70qLJK/71LZDT0egh/RPSakfJRwBbiDF5AzcwX4y
         USqXObqjh5HfbyB0IowSd3wlz2wok3y5z+wlyTFjz4YkrTkdMUw3T2P0IvLJrTMcb3nt
         T5c690k/jpzAmN3F27XOTKMYRbxkrOYUYhU9lclxJw1sYsjfi8OADTZh35GCqzNw0NtL
         uwqMtKkiqADp9Cnyuvo2+k6aRykDTC2KF/0lgJru5R0oYresSElIVllzEIOGRhiBOfbL
         m1+3O2Gt27Fvjm1XrCGal5N+DDSx3kCp2vw7M/xAVlPRPqYIML8dL6x4C5I66EcLwzcC
         NpUw==
X-Gm-Message-State: AO0yUKXAwnnYta9gueD02BA52zbqQmmLBimPTNAG1jtALJXhlTswjW3C
        rgFmHdP3gbcOdn/gGMIHwsU=
X-Google-Smtp-Source: AK7set8dUdCxcUMg66HRhkvAIc5RvEblnYyOnqEV8kKUDCatrw/ZibgC+glSvgWh6uMWqfACFn6KQg==
X-Received: by 2002:a50:cd11:0:b0:4aa:ca81:a528 with SMTP id z17-20020a50cd11000000b004aaca81a528mr20757728edi.40.1676229202921;
        Sun, 12 Feb 2023 11:13:22 -0800 (PST)
Received: from zbpt9gl1 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id n13-20020a50cc4d000000b004a0afea4c9csm5467390edi.18.2023.02.12.11.13.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Feb 2023 11:13:22 -0800 (PST)
From:   <piergiorgio.beruto@gmail.com>
To:     "'Vladimir Oltean'" <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>
Cc:     "'Michal Kubecek'" <mkubecek@suse.cz>,
        "'Pranavi Somisetty'" <pranavi.somisetty@amd.com>
References: <20230210213311.218456-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230210213311.218456-1-vladimir.oltean@nxp.com>
Subject: RE: [PATCH v3 ethtool 0/4] MAC Merge layer support
Date:   Sun, 12 Feb 2023 20:13:21 +0100
Message-ID: <003c01d93f16$12d54f20$387fed60$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI04I1LbQsCC0o+aMcBbD//AdXOX64UaoTA
Content-Language: en-us
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
From my perspective, it would be better to merge it on top of 
"[v5,ethtool-next,1/1] add support for IEEE 802.3cg-2019 Clause 148".

Thanks,
Piergiorgio

-----Original Message-----
From: Vladimir Oltean <vladimir.oltean@nxp.com> 
Sent: 10 February, 2023 22:33
To: netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>; Pranavi Somisetty
<pranavi.somisetty@amd.com>; Piergiorgio Beruto
<piergiorgio.beruto@gmail.com>
Subject: [PATCH v3 ethtool 0/4] MAC Merge layer support

Add support for the following 2 new commands:

$ ethtool [ --include-statistics ] --show-mm <eth> $ ethtool --set-mm <eth>
[ ... ]

as well as for:

$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool -S <eth> --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

and some modest amount of documentation (the bulk of it is already
distributed with the kernel's ethtool netlink rst).

This patch set applies on top of "[v5,ethtool-next,1/1] add support for IEEE
802.3cg-2019 Clause 148", because otherwise it would conflict with it:
https://patchwork.kernel.org/project/netdevbpf/patch/d51013e0bc617651c0e6d29
8f47cc6b82c0ffa88.1675327734.git.piergiorgio.beruto@gmail.com/
I believe Michal hasn't gotten to it yet, but I'm putting Piergiorgio on CC
too, in case there are other reasons why I shouldn't wait for his patch to
be merged first.

Vladimir Oltean (4):
  netlink: add support for MAC Merge layer
  netlink: pass the source of statistics for pause stats
  netlink: pass the source of statistics for port stats
  ethtool.8: update documentation with MAC Merge related bits

 Makefile.am      |   2 +-
 ethtool.8.in     | 107 +++++++++++++++++++
 ethtool.c        |  16 +++
 netlink/extapi.h |   4 +
 netlink/mm.c     | 270 +++++++++++++++++++++++++++++++++++++++++++++++
 netlink/pause.c  |  33 +++++-
 netlink/stats.c  |  14 +++
 7 files changed, 440 insertions(+), 6 deletions(-)  create mode 100644
netlink/mm.c

--
2.34.1


