Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6EB31A4FE
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhBLTHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:07:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231317AbhBLTHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613156739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fVz+OdvX5v8pnfHAJCXmX/KhfTaAoDOYzOgXFEHrZes=;
        b=H9IOE8aM2FeKw3nTRL/7Ah/RSoFw0Ed01sUBR3ctaWRg13liNRqZthUjbhnxbFKSwpSzri
        CQ7eDMvYiO6nJ7McjoANECNKiO9QLQsLt7HE7CKJXZkGosPCXNXReIfBA9EmGVuS2H6Rbv
        grMt56SJK/NK3azoP5kpBYVR3wPGiqk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-7RAxJV8ZOWGciAQ5MzLvSg-1; Fri, 12 Feb 2021 14:05:37 -0500
X-MC-Unique: 7RAxJV8ZOWGciAQ5MzLvSg-1
Received: by mail-wm1-f71.google.com with SMTP id t128so359848wmg.4
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:05:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=fVz+OdvX5v8pnfHAJCXmX/KhfTaAoDOYzOgXFEHrZes=;
        b=crnlScONUFv3Q4/2aMyRCUGtxH8yniYxyVZRU41pTji0ytiGimq8xNMUabZ77KNMBi
         O8EZONFkPu1s1vCPmxjg8XZBYbBy/OLhxGqe8bAMJut2RkOkxRCNDMv4lWukODrsLCQ4
         ErJhVfmecw/GnMFaXyOn3KDmidd8wIZXNWTyrprRSOrfI+phFYg/3LcUV3NTpKNMR2QT
         oWXoiXt/hMkt4u6ciGFJ2Yb9B50azI8/grp7nvb2XpAylXy4PoI+/RYnU0ZkscCtXX7A
         Al4EZuMaxdqBkHXgRu52x6Yo+Oi2CAibJXKUDNpot4byQ4yjdXNV5bNMwq/TeRipeB9Q
         rtiA==
X-Gm-Message-State: AOAM530zzHDp0YJ3y+IFZbKXhvN+85aiw2yB519+vwptZHUgq0Ajzq7m
        C2qbgbswBByq7csHQUXO7oGhzWanqsSxLOOT9sNvI5b1H0juHyvFR1Hwqau7T4NL6etWBPaBLux
        DnpSKDioAuUPl2NvY
X-Received: by 2002:a5d:4990:: with SMTP id r16mr5134889wrq.167.1613156736432;
        Fri, 12 Feb 2021 11:05:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJntVDRSwK4pnyc7EbcaoMyaoKzo7CynBhOGDA1BkYUgBDi4aUIvYi/0ToSFvXtZGUezduEg==
X-Received: by 2002:a5d:4990:: with SMTP id r16mr5134881wrq.167.1613156736314;
        Fri, 12 Feb 2021 11:05:36 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id x10sm7944363wmg.6.2021.02.12.11.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 11:05:35 -0800 (PST)
Date:   Fri, 12 Feb 2021 20:05:33 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] selftests: tc: Test tc-flower's MPLS features
Message-ID: <cover.1613155785.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of patches for exercising the MPLS filters of tc-flower.

Patch 1 tests basic MPLS matching features: those that only work on the
first label stack entry (that is, the mpls_label, mpls_tc, mpls_bos and
mpls_ttl options).

Patch 2 tests the more generic "mpls" and "lse" options, which allow
matching MPLS fields beyond the first stack entry.

In both patches, special care is taken to skip these new tests for
incompatible versions of tc.

Guillaume Nault (2):
  selftests: tc: Add basic mpls_* matching support for tc-flower
  selftests: tc: Add generic mpls matching support for tc-flower

 tools/testing/selftests/net/forwarding/config |   1 +
 tools/testing/selftests/net/forwarding/lib.sh |  41 +++
 .../selftests/net/forwarding/tc_flower.sh     | 307 +++++++++++++++++-
 3 files changed, 348 insertions(+), 1 deletion(-)

-- 
2.21.3

