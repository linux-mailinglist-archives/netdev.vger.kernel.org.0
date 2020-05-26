Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BC71E21DA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 14:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbgEZM3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 08:29:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52319 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729592AbgEZM3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 08:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590496148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=MIJShCkiyecCLM7804qLa+GL779mYZFQ74qH5A4zHak=;
        b=ClFzyo/HZynclaj9JBsN4BcxDOgr1ZU2mRq+U3nPT1NnyFNnbw+Zri4gacTmmIBm3LK5/M
        zeL0UhvIhL6aUzPDupkytv0QevX2IPGWhgOi0p/0WxII7NvoFv6iO04WVwBDFypOjnS9s6
        6R4b8wxAa9epacfDbLX7n3OHOH5QQ50=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-eEqou7Q_NQyySYo3HmeGNA-1; Tue, 26 May 2020 08:29:02 -0400
X-MC-Unique: eEqou7Q_NQyySYo3HmeGNA-1
Received: by mail-wr1-f71.google.com with SMTP id h92so5457897wrh.23
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 05:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=MIJShCkiyecCLM7804qLa+GL779mYZFQ74qH5A4zHak=;
        b=jSZS4iM1TEKRQxN3kiZlht7fZFq732qowSV6MK3Gf7ZVIVJk2TxmDpuUMVCmOLVxpB
         uJFem1pDi0nEa7mrV39PlDQ3nbRv1HLHWYcn3HiBJF2omOUTaDjKjxMusZeJ27Itz2ik
         HuSsb4P9RmC3+5S10jPMHRNm4GGFgcSHdm35tVHbP4WDvpZXpnzc7CJauc45ORn4UdnF
         hRa5we6BXKKbdwRWV0pKLOquqckKf8u7UDdWUC7aQUHCHiYyC3qu3Cev4mHltXOBlcwl
         7bFmFPYWidK7R0Jkb06YPKyHS97qyuidr7K4aYDiaocgZn1w08JegKZ//n5dpg7nJny6
         jTwg==
X-Gm-Message-State: AOAM5305rcYa/UlQKG6f3f2Ak1bM4rYQMY6OfzOokb+5uYTVFhy4JcjD
        StyTEOFmNqn2RThW23x8n0EXfmOlamBTIWBvcvfn5ASc6dD6bONAkpoh8DW4KET1PpFOHqrRtc4
        +ihbe1d83LKmibKJ2
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr1162984wmh.87.1590496141347;
        Tue, 26 May 2020 05:29:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw33uvHRI/0ZPr7qBCvd9ME0JHVO8r51o5twk6bd7rRwmpWMXz3iLjs2xZmnikscBy9jHxoCQ==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr1162921wmh.87.1590496140293;
        Tue, 26 May 2020 05:29:00 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id 23sm4733005wmg.10.2020.05.26.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 05:28:59 -0700 (PDT)
Date:   Tue, 26 May 2020 14:28:57 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Tom Herbert <tom@herbertland.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eli Cohen <eli@mellanox.com>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: [PATCH net-next v3 0/2] flow_dissector, cls_flower: Add support for
 multiple MPLS Label Stack Entries
Message-ID: <cover.1590495493.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the flow dissector and the Flower classifier can only handle
the first entry of an MPLS label stack. This patch series generalises
the code to allow parsing and matching the Label Stack Entries that
follow.

Patch 1 extends the flow dissector to parse MPLS LSEs until the Bottom
Of Stack bit is reached. The number of parsed LSEs is capped at
FLOW_DIS_MPLS_MAX (arbitrarily set to 7). Flower and the NFP driver
are updated to take into account the new layout of struct
flow_dissector_key_mpls.

Patch 2 extends Flower. It defines new netlink attributes, which are
independent from the previous MPLS ones. Mixing the old and the new
attributes in a same filter is not allowed. For backward compatibility,
the old attributes are used when dumping filters that don't require the
new ones.

Changes since v2:
  * Fix compilation with the new MLX5 bareudp tunnel code.

Changes since v1:
  * Fix compilation of NFP driver (kbuild test robot).
  * Fix sparse warning with entropy label (kbuild test robot).

Guillaume Nault (2):
  flow_dissector: Parse multiple MPLS Label Stack Entries
  cls_flower: Support filtering on multiple MPLS Label Stack Entries

 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c   |  27 +-
 .../net/ethernet/netronome/nfp/flower/match.c |  42 ++-
 include/net/flow_dissector.h                  |  14 +-
 include/uapi/linux/pkt_cls.h                  |  23 ++
 net/core/flow_dissector.c                     |  49 ++-
 net/sched/cls_flower.c                        | 295 +++++++++++++++++-
 6 files changed, 397 insertions(+), 53 deletions(-)

-- 
2.21.1

Notes:
  * The NFP and MLX5 udpates have been compile-tested only, as I don't
    don't have the required hardware. Reviews from Netronome and
    Mellanox warmly welcome.
  * Compiles with allmodconfig on latest net-next tree, I swear :)

