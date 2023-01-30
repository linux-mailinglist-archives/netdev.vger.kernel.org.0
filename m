Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A89C680E5C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbjA3NBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbjA3NB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:01:28 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4C9172B;
        Mon, 30 Jan 2023 05:01:26 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m7so10976646wru.8;
        Mon, 30 Jan 2023 05:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gfP++trWxino2nxmOeW6QjlxbhEmTqO0/dyok6r1CGY=;
        b=c7ta6ATIyd0Tis+q3Wd5KN1qKCmvOiu05/Rg/8GDqFyKZTW3kGfXeqKCWApKiqiYPI
         S3AiNEZXfkFgXeM85xREiIUE5lC5teoYvDaszXlSsZQoHm/MP1AtLmvSzU4n8i8D1jQU
         Im+v0Zm4HghZBwUWW7LpVXaaOEgZx76UkL/525w1ohw/BAJTRBH2DqUCs+v+J9h5MaOG
         BHT/47scVKVM/sA0oGIoL7QBUFIXASDDVk9juaWKRSQ0cH9DBeBGts/XxkUzkJn16gpY
         2A9JrZBEXd2R+UffPLqNsG52W01nZszIgHXVxMcOl2SLD2oTvv9RrpdRCLVEy1jFc4wN
         1f7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gfP++trWxino2nxmOeW6QjlxbhEmTqO0/dyok6r1CGY=;
        b=ghYhl2MIdhTAJIlnCrEHBmUVauNfiLDdyHlJ9gIJTXzls9KTxlMyJ8hPxKcjjiTZa0
         Y2m6VpYqSjxJuJrS7dgCD5Aul6uyjhWoG5Mor2yaQmBGJCPkXCJ+UyAf/sfJmcyvBkla
         s+u66O6J0GuhsQ1COm9U1pT/1J/B0iA9ByI0vwAOw4/Qeb/E70wF3CCZg0I5BYIeMd1t
         Ar8f4TvodrQBHpVGFf14Od4K3i3PwxwhPRx8J3EBNqf2uQKKF+V1mIwzQJBAf517Syb0
         rXxiXP3JGAQBZJcDReajTFMsRKSwy5wjdE5/9jxs5dBczGiUDGQeiDsDm7mHzSTsdcyz
         x4Mw==
X-Gm-Message-State: AFqh2krh4yi0qOfctJLojg0K113v/OKDFarQzxETShHrA0z7FT1Hn1nh
        06XyS/h5bcDCuzXhsK6S1Xlm4egzze4=
X-Google-Smtp-Source: AMrXdXtNRBDl9pgIdy02Hy7R/t7CPIpqPKhjMWIHbMEZPwoJZMzUc6bFWwY7pm1EUbnKnIM91H1sGg==
X-Received: by 2002:a05:6000:1c06:b0:2bf:6f4a:3f66 with SMTP id ba6-20020a0560001c0600b002bf6f4a3f66mr35079299wrb.21.1675083685193;
        Mon, 30 Jan 2023 05:01:25 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id o6-20020adfe806000000b002bdf8dd6a8bsm11659174wrm.80.2023.01.30.05.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 05:01:24 -0800 (PST)
Date:   Mon, 30 Jan 2023 14:00:55 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, lixiaoyan@google.com,
        alexanderduyck@fb.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        iwienand@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] gro: optimise redundant parsing of packets
Message-ID: <20230130130047.GA7913@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the IPv6 extension headers are parsed twice: first in
ipv6_gro_receive, and then again in ipv6_gro_complete.

The field NAPI_GRO_CB(skb)->proto is used by GRO to hold the layer 4
protocol type that comes after the IPv6 layer. I noticed that it is set
in ipv6_gro_receive, but isn't used anywhere. By using this field, and
also storing the size of the network header, we can avoid parsing
extension headers a second time in ipv6_gro_complete.

The first commit frees up space in the GRO CB. The second commit reduces
the redundant parsing during the complete phase, using the freed CB
space.

I've applied this optimisation to all base protocols (IPv6, IPv4,
Ethernet). Then, I benchmarked this patch on my machine, using ftrace to
measure ipv6_gro_complete's performance, and there was an improvement.

Richard Gobert (2):
  gro: decrease size of CB
  gro: optimise redundant parsing of packets

 include/net/gro.h      | 32 +++++++++++++++++++++-----------
 net/core/gro.c         | 18 +++++++++++-------
 net/ethernet/eth.c     | 11 +++++++++--
 net/ipv4/af_inet.c     |  8 +++++++-
 net/ipv6/ip6_offload.c | 15 ++++++++++++---
 5 files changed, 60 insertions(+), 24 deletions(-)

-- 
2.36.1

