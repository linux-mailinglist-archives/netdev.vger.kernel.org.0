Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795F4292A46
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgJSPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:23:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgJSPXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603120981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=UoOZbVKyramBVGxWgdJkweMRLt/aT1VjN8t5l7Vev1Q=;
        b=EhrBu/yK6Xj4+bFghTsFK2amIHDtg/LVxHePK5Ht8GIFHOU1fCBIOO45lKXrMs6CUR65iy
        0hisQR89nH8RfhjJptCfpr0RjOeh6WFfx6NpV4M8rCKuPJlkBG6EPlsmiUe3aaMN8361F/
        hZCPQE0hafgXApVNVaJ+Iw4iIAh6yik=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-r6eZeZXaNgeOXOK2BKBvhA-1; Mon, 19 Oct 2020 11:22:59 -0400
X-MC-Unique: r6eZeZXaNgeOXOK2BKBvhA-1
Received: by mail-wr1-f69.google.com with SMTP id t3so21107wrq.2
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=UoOZbVKyramBVGxWgdJkweMRLt/aT1VjN8t5l7Vev1Q=;
        b=jiyRIh7zLvcLFNdo6oC4ho5TVhnK1DQdVTrYh8JKQVatiXS9dbFagac2v2ITjG0xj/
         WSkm+4pgerixt+cOLsQukt+WYTNUDa92XS+hQII9I58suaaxL92OPGjjSUS1/Dv/jKxL
         4MFmbXMSccFel8OehSX/WuhuDzdVnxxG2eqGoZVguKzH8qk6feIJ9cznhodbd2GDal35
         KrbJW4VEB2v4aJc6DMru45vVa8b79Be0VTMvmHYgqjKUGR6/3JcKrCp7low52OnLnLgx
         kLJQP/tAIFS81zM33m0g2z1+4E7hnGIvdl+0m6lN76+3GF9UJhK5HfuWfb4uZVnEpFwI
         QODQ==
X-Gm-Message-State: AOAM530f3qtzx+9/Tk54p59IYrAKQgZba7SalibFDZyNt5RbpGPuvx7i
        UmA4m45OnJTosQ+NmomyAha+9pV3R5j3NZO3V08atU5sKXCqoCwhWi8xcaQC1fNavCMmv/Sc2ka
        SZvZmmMKgnAvRpWNm
X-Received: by 2002:adf:97da:: with SMTP id t26mr5745wrb.321.1603120977811;
        Mon, 19 Oct 2020 08:22:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLtwdQg51zcZJITvPkzgcjw4joPFall1nP0ez+AIdbHbIz/Rw3CW4O0zfwm0xj43256McgLA==
X-Received: by 2002:adf:97da:: with SMTP id t26mr5730wrb.321.1603120977650;
        Mon, 19 Oct 2020 08:22:57 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id e7sm97944wrm.6.2020.10.19.08.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:22:56 -0700 (PDT)
Date:   Mon, 19 Oct 2020 17:22:55 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: [PATCH v2 iproute2-next 0/2] tc: support for new MPLS L2 VPN actions
Message-ID: <cover.1603120726.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds the possibility for TC to tunnel Ethernet frames
over MPLS.

Patch 1 allows adding or removing the Ethernet header.
Patch 2 allows pushing an MPLS LSE before the MAC header.

By combining these actions, it becomes possible to encapsulate an
entire Ethernet frame into MPLS, then add an outer Ethernet header
and send the resulting frame to the next hop.

v2: trivial coding style fix (line wrap).

Guillaume Nault (2):
  m_vlan: add pop_eth and push_eth actions
  m_mpls: add mac_push action

 lib/ll_proto.c            |  1 +
 man/man8/tc-mpls.8        | 44 ++++++++++++++++++--
 man/man8/tc-vlan.8        | 44 ++++++++++++++++++--
 tc/m_mpls.c               | 43 ++++++++++++++------
 tc/m_vlan.c               | 69 +++++++++++++++++++++++++++++++
 testsuite/tests/tc/mpls.t | 69 +++++++++++++++++++++++++++++++
 testsuite/tests/tc/vlan.t | 86 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 337 insertions(+), 19 deletions(-)
 create mode 100755 testsuite/tests/tc/mpls.t
 create mode 100755 testsuite/tests/tc/vlan.t

-- 
2.21.3

