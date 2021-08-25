Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621C73F712B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 10:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbhHYIj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 04:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhHYIj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 04:39:28 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACADC061757;
        Wed, 25 Aug 2021 01:38:43 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a21so20628628pfh.5;
        Wed, 25 Aug 2021 01:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BpHwxqI/LNSicvwBNy0Qv9b112i5l0eIi9/y2JfjKCA=;
        b=McwVEb5kagSEN63cjSvW5zy94quw6o/zlJizlbvPoSaIMjSUxATKhVdHRiTYvt341q
         JeRJEBRZN/Uep5tGrxflF5br0r/uWZa3PyStRiL0t3RB8VPpwyzV/85V0CAJGNVGqAr7
         YrjX3NjlVovQQF9Lx3GwS7baztpak6SYZ9SFHx1vZ+80XrY+zf3q9dgksLodPW0aLFX8
         0S/UcNcFkqQVdf/wek85vJG5I9iBgw5EbjfhD9yHk0HaTGhUQZcJZajrOs60IKE6LXjV
         LjNAVPb6YvE7hXLUIdffUadB5epjj69R37zam1lcOasCI+OLGfLQWb8tc/HnlRrt6XE8
         3whw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BpHwxqI/LNSicvwBNy0Qv9b112i5l0eIi9/y2JfjKCA=;
        b=Vt6RPj0yKKygpBRJMs2oag8g/Xh8L4HZMw1wzKJi1/wyhOPTyAJqF4BexVCl0Cl++S
         wpBJEMx3SZeVYC9F1vZUxoDdJqKqvBbprl/wLZMGLv0yN8xuEvBLKvpNTHG/yhfBiqeJ
         +GfhyLb95c6FeXonqkwN6Mg4xh2I7MtkGgb4BaLwga5QTMdI6qCNBXGLBob+NEH933zz
         f+8VWf8zpIT/8Rjr22zrE1QbzAc8JpIxWvUpCUmnUGpyeGQ0jZYgkxfKL7331kvr3jcb
         llStZiO9WKqrFNUfWZsxUHrZDPSsTAv+6bh7cKsfWTyj1ylSya9S6S+G/a1nCS/qjJcS
         3voQ==
X-Gm-Message-State: AOAM530GuEzJOl/Iwx7Ad0HYFRuwAhLYLh56XFB1bZPvZhYhWuOpnfX/
        HnpMBPIiCK6Q/4JWs9rTMe8=
X-Google-Smtp-Source: ABdhPJwufn/wD8i8gVcGRxuoTghZYICIl4/Vd1L0dd3zlujKtCAwouwxvyoxPpT7DfJbk8jKsTK5cw==
X-Received: by 2002:a62:ea0f:0:b029:319:8eef:5ff1 with SMTP id t15-20020a62ea0f0000b02903198eef5ff1mr43723266pfh.74.1629880722889;
        Wed, 25 Aug 2021 01:38:42 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id p18sm24872294pgk.28.2021.08.25.01.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 01:38:42 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 0/2] DSA slave with customise netdev features
Date:   Wed, 25 Aug 2021 16:38:29 +0800
Message-Id: <20210825083832.2425886-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some taggers, such as tag_dsa.c, combine VLAN tags with DSA tags, which
currently has a few problems:

1. Unnecessary reallocation on TX:

A central TX reallocation has been used since commit a3b0b6479700
("net: dsa: implement a central TX reallocation procedure"), but for
VLAN-tagged frames, the actual headroom required for DSA taggers which
combine with VLAN tags is smaller.

2. Repeated memmoves:

If a both Marvell EDSA and VLAN tagged frame is received, the current
code will move the (DA,SA) twice: the first in dsa_rcv_ll to convert the
frame to a normal 802.1Q frame, and the second to strip off the 802.1Q
tag. The similar thing happens on TX.

For these tags, it is better to handle DSA and VLAN tags at the same time
in DSA taggers.

This patch set allows taggers to add custom netdev features to DSA
slaves so they can advertise VLAN offload, and converts tag_mtk to use
the TX VLAN offload.

DENG Qingfang (2):
  net: dsa: allow taggers to customise netdev features
  net: dsa: tag_mtk: handle VLAN tag insertion on TX

 include/net/dsa.h |  2 ++
 net/dsa/slave.c   |  3 ++-
 net/dsa/tag_mtk.c | 46 ++++++++++++++++++++++------------------------
 3 files changed, 26 insertions(+), 25 deletions(-)

-- 
2.25.1

