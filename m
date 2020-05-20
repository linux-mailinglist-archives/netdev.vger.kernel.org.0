Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDD1DBB72
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgETR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:28:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36644 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgETR2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=8+Nb5pWCc1PiweMGC4fvcY+3IaqBgMHmVvPOxhCZdXk=;
        b=CedGu80uZf7xFv9ZUpUln6GbysK+8PpLxNT3PylbT0Vel7YuUUaMTrwu28aimVvi/35JHO
        SRLzRCVWOwEsy//wb2xxam4JJ+4I8+Hfsr+CSPvB5QlDgE36xdaHDuCGcvmTe6pzIBR+J2
        56uUB2E2fKuMmXHMzIkDYER2u7+zb30=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-YH_2Y7BTM0ihZf4YYDNfcQ-1; Wed, 20 May 2020 13:28:39 -0400
X-MC-Unique: YH_2Y7BTM0ihZf4YYDNfcQ-1
Received: by mail-wr1-f69.google.com with SMTP id 90so1670973wrg.23
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 10:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8+Nb5pWCc1PiweMGC4fvcY+3IaqBgMHmVvPOxhCZdXk=;
        b=ag1NQ2kLApaw+/vJr/38elP4tly1R98bhyETbBAnwv5v5wyHaebB5XnHpNTdpEy2F6
         bdEtiGPm3/sCJrnGMWsZvDfg8h0sPTlCOeL4q+5a0N9ZRfM3NvxP3l7B+AMdIvQ56vBw
         ur0+6+NEpwjfL/6bgea0as/fSCUI6uONq7W8uqNydf7B2iy5eY5ti5hgv/FjM9zASNW5
         bJIIlhrTwOam3RHzrFovg5FiYcMNufk0dyCnuzynmBsELQcdTjkFzg9MFka9WQna7i+T
         2CFVPrnsurai4EU+H30DbUi5vElariHNbZFaqxhR7S1jh6x7qBamfo3YfwECAHS4yots
         8V6w==
X-Gm-Message-State: AOAM530OvkHLvsEAOB2QmAXnUuNbry96KcvLZfOapj0HDS7fL6MxjfKW
        lwZahKJzHwkmVYPNgMKNDFnVzaqk1SLruudCF3/n/iYvfFw4ti21KTmTX4tvmmspHkdvVaNG8Wx
        dhEMlEnViPEMK5Ji7
X-Received: by 2002:adf:ec09:: with SMTP id x9mr4986001wrn.21.1589995718629;
        Wed, 20 May 2020 10:28:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAuCmJSuZN5YbYAEWmCoUORKHjcxq+3ceW5zMqzsvIReDiR/K9ZjqJmPXVxGGNrcytHI8q3w==
X-Received: by 2002:adf:ec09:: with SMTP id x9mr4985984wrn.21.1589995718431;
        Wed, 20 May 2020 10:28:38 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id g187sm3733746wmf.30.2020.05.20.10.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:28:37 -0700 (PDT)
Date:   Wed, 20 May 2020 19:28:36 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Benjamin LaHaise <benjamin.lahaise@netronome.com>,
        Tom Herbert <tom@herbertland.com>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: [PATCH net-next 0/2] flow_dissector, cls_flower: Add support for
 multiple MPLS Label Stack Entries
Message-ID: <cover.1589993550.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the flow dissector and the Flower classifier can only handle
the first entry of an MPLS label stack. This patch series generalises
the code to allow parsing and matching the labels that follow.

Patch 1 extends the flow dissector to parse MPLS LSEs until the Bottom
Of Stack bit is reached. The number of parsed LSEs is capped at
FLOW_DIS_MPLS_MAX (arbitrarily set to 7).

Patch 2 extends Flower. It defines new netlink attributes, which are
independent from the previous MPLS ones. Mixing the old and the new
attributes in a same filter is not allowed. For backward compatibility,
the old attributes are used when dumping filters that don't require the
new ones.

Guillaume Nault (2):
  flow_dissector: Parse multiple MPLS Label Stack Entries
  cls_flower: Support filtering on multiple MPLS Label Stack Entries

 include/net/flow_dissector.h |  14 +-
 include/uapi/linux/pkt_cls.h |  23 +++
 net/core/flow_dissector.c    |  49 ++++--
 net/sched/cls_flower.c       | 295 +++++++++++++++++++++++++++++++++--
 4 files changed, 347 insertions(+), 34 deletions(-)

-- 
2.21.1

