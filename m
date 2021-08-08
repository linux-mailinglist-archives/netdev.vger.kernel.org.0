Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546593E3BC4
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 19:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhHHRAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 13:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhHHRAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 13:00:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19C8C061760;
        Sun,  8 Aug 2021 10:00:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j3so13883242plx.4;
        Sun, 08 Aug 2021 10:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=+2IKb4s8fLaRZamykzK5nK7Y6dvXALlvgfnoRe+HK/Y=;
        b=V7i3FJXi/sN/dE+EzN/zCtN1Ty5SXScTHTYaqSD8NMxo9IGHF4rxb2kjRpQu1WpJjm
         jdNqqrLLQOgojgaMnANSNHJ4S/MVy8H6I8CatnefIBLVU3GPvalJTkZiBxH1aDNNKhIR
         huMpeQiXkxsmqHa9bqg0qi28cT3Nvy8T3NEqt8JwmV5djH6Wkx01iDgfWe1PJunrCbcr
         frwhGcqaJLnb/sTuyxgx4muiXlfSbX76J+Bk20eZ8GkU56qzA/FtSHQiTy91p1RYXkXh
         w2r1zogUW3f3m0K610hXcLajdvE9UAKrmeVLfMkQ6VR47uEALFHU1HVhet67KLZq/7eL
         24Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=+2IKb4s8fLaRZamykzK5nK7Y6dvXALlvgfnoRe+HK/Y=;
        b=beCV3Iwy970jBYU+T08ZkucQSqMSW6YgINE3sdy8W1/aSDuCvYqHifxte1zR9PBqMX
         oDoa+cA34SdIFws7nlf2ptz+NTgOK60Gq1r32+uWtZRcyAfN+J9596VEdMo8XTyo1wbY
         cnxlzFG7PDaXnLiTjrFFD8FhJ1nnO9vXVwdcROWNRFCZ5/8WIEG4z1ljO4O/uwg0GPlD
         Q/fSj4b5zcO0ZlcY/cvAmqF/ZstN83n4g60kg1HZWStrk+QWtrJgJGZfKssxc0wY1Ty+
         bY5DxQrhYajbI0NdLMkup5G3MKXW5NVIE9psmzfiesJvXXE8FSG7uCmD7iYOa9947/Hy
         fixg==
X-Gm-Message-State: AOAM533v/TIjjqLpGSeR413+TF+QHmViTpmjYCSGclosNFU+O7EtQ047
        soARgTd7m3u/9+OVi9kWGc8=
X-Google-Smtp-Source: ABdhPJzI6b4wFZ9s//pHD6eCbcos1ptHiqYy/HRV5zh3u+BW1GPVZvtWLyGfb1QM/JFtvRYk9ArgIg==
X-Received: by 2002:a63:3e05:: with SMTP id l5mr31867pga.403.1628442033404;
        Sun, 08 Aug 2021 10:00:33 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id q5sm15251889pjo.7.2021.08.08.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 10:00:32 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Eric Woudstra <ericwouds@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Date:   Mon,  9 Aug 2021 01:00:24 +0800
Message-Id: <20210808170024.228363-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210716152213.4213-1-ericwouds@gmail.com>
References: <20210716152213.4213-1-ericwouds@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 05:22:11PM +0200, ericwouds@gmail.com wrote:
> From: Eric Woudstra <37153012+ericwoud@users.noreply.github.com>
> 
> According to reference guides mt7530 (mt7620) and mt7531:
> 
> NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to 
> read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0] 
> will be used to read/write the address table.
> 
> Since the function only fills in CVID and no FID, we need to set the
> IVL bit. The existing code does not set it.
> 
> This is a fix for the issue I dropped here earlier:
> 
> http://lists.infradead.org/pipermail/linux-mediatek/2021-June/025697.html
> 
> With this patch, it is now possible to delete the 'self' fdb entry
> manually. However, wifi roaming still has the same issue, the entry
> does not get deleted automatically. Wifi roaming also needs a fix
> somewhere else to function correctly in combination with vlan.

Sorry to bump this up, but I think I identified the issue:

Consider a VLAN-aware bridge br0, with two ports set to different PVIDs:

> bridge vlan
> port         vlan-id
> swp0         1 PVID Egress Untagged
> swp1         2 PVID Egress Untagged

When the bridge core sends a packet to swp1, the packet will be sent to
the CPU port of the switch as untagged because swp1 is set as "Egress
Untagged". However if the switch uses independent VLAN learning, the CPU
port PVID will be used to update the FDB. As we don't change its PVID
(not reasonable to change it anyway), hardware learning may not update
the correct FDB.

A possible solution is always send packets as tagged when serving a
VLAN-aware bridge.

mv88e6xxx has been using hardware learning on CPU port since commit
d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process"),
does it have the same issue?
