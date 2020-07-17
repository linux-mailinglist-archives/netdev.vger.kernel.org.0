Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BF4223E5B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 16:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgGQOj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 10:39:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbgGQOjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 10:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594996794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=jQ1u8/99K/G1qNvXcgWcYBuy43JIq/zexiQg5fz1KLE=;
        b=eNwdgTsxaWqmxqZdlSts5vFH5hlLNQZVIkLQZm/EITZb5tS6I15pBWD/hG+WSt51XeK9ZX
        IMgA5heSrYUj2LaYOMzuoi0O4Vupo+x6FRMNIw0v8nG08hAOyU1OWv+IHRlsNIVFvjK29m
        9H8BhXwHL5A0oAyRI2khXUY7oJ4OJhs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-otNMfD_TNxmwTsi8BcGCKw-1; Fri, 17 Jul 2020 10:39:50 -0400
X-MC-Unique: otNMfD_TNxmwTsi8BcGCKw-1
Received: by mail-wm1-f70.google.com with SMTP id y204so9173613wmd.2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 07:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=jQ1u8/99K/G1qNvXcgWcYBuy43JIq/zexiQg5fz1KLE=;
        b=WdbZh1Ge1QfbVHi/AuXpHPXUYa/03B+eP4zzC3XrNrU2RuEFPmHtqubPbC1l+h6r+O
         CetkgA7lB5KxpX3+TEPpMeSTnhYtTYPRKuv6NAXSi2qwtepXH7tujMe1UryIZhBC2GZM
         u7JlwtNR3j9HfQD+HUPOIoeIHua0sBmMbhwilxAtxia388E9CBWP/S/HwkIyfo5pjvxm
         EZfqqcOfwogn/O8GQXfeYgNbPR/P+ug7b2P0FW+LZNtDyvJzyCTawqlTOlVZcPjYhBcK
         v97bFVPDcZ2HaHwD4I+jtw/YXCTnTE2XVEHAl9wY+hBYhq8r3DRKvqo+vidz0Es+wFsH
         t8kg==
X-Gm-Message-State: AOAM533VxMvcG7E5EQDxPcxn2zUJCQ0+OsYkfZeSGzp7FRQgDF4Z7QDv
        K+NDXBlqTlsWG3803lnlLMc/ATSJv2unNbZl44i/1FA1hCwZUpjWMkF/IhgQ4gSj/4WxlkG0xi7
        HrbU/Q8zDWEEs4O6y
X-Received: by 2002:a5d:420e:: with SMTP id n14mr11360721wrq.164.1594996789271;
        Fri, 17 Jul 2020 07:39:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6uWks+wjVqhCWhjct4DyaIj5qS+V6EY7W0MT1BPE0LDhsi471XwBLnVY2OdDq1GT2XhKRdQ==
X-Received: by 2002:a5d:420e:: with SMTP id n14mr11360685wrq.164.1594996788881;
        Fri, 17 Jul 2020 07:39:48 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id g195sm14303495wme.38.2020.07.17.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 07:39:48 -0700 (PDT)
Date:   Fri, 17 Jul 2020 16:39:46 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martinvarghesenokia@gmail.com>
Subject: [PATCH iproute2] testsuite: Add tests for bareudp tunnels
Message-ID: <2e407fe6bd0983d7c9d98793273b839f2afe7811.1594996695.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test the plain MPLS (unicast and multicast) and IP (v4 and v6) modes.
Also test the multiproto option for MPLS and for IP.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 testsuite/tests/ip/link/add_type_bareudp.t | 86 ++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100755 testsuite/tests/ip/link/add_type_bareudp.t

diff --git a/testsuite/tests/ip/link/add_type_bareudp.t b/testsuite/tests/ip/link/add_type_bareudp.t
new file mode 100755
index 00000000..8a2a1edf
--- /dev/null
+++ b/testsuite/tests/ip/link/add_type_bareudp.t
@@ -0,0 +1,86 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+ts_log "[Testing Add BareUDP interface (unicast MPLS)]"
+NEW_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $NEW_DEV BareUDP interface (unicast MPLS)" link add dev $NEW_DEV type bareudp dstport 6635 ethertype mpls_uc
+
+ts_ip "$0" "Show $NEW_DEV BareUDP interface (unicast MPLS)" -d link show dev $NEW_DEV
+test_on "$NEW_DEV"
+test_on "dstport 6635"
+test_on "ethertype mpls_uc"
+test_on "nomultiproto"
+
+ts_ip "$0" "Del $NEW_DEV BareUDP interface (unicast MPLS)" link del dev $NEW_DEV
+
+
+ts_log "[Testing Add BareUDP interface (multicast MPLS)]"
+NEW_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $NEW_DEV BareUDP interface (multicast MPLS)" link add dev $NEW_DEV type bareudp dstport 6635 ethertype mpls_mc
+
+ts_ip "$0" "Show $NEW_DEV BareUDP interface (multicast MPLS)" -d link show dev $NEW_DEV
+test_on "$NEW_DEV"
+test_on "dstport 6635"
+test_on "ethertype mpls_mc"
+test_on "nomultiproto"
+
+ts_ip "$0" "Del $NEW_DEV BareUDP interface (multicast MPLS)" link del dev $NEW_DEV
+
+
+ts_log "[Testing Add BareUDP interface (unicast and multicast MPLS)]"
+NEW_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $NEW_DEV BareUDP interface (unicast and multicast MPLS)" link add dev $NEW_DEV type bareudp dstport 6635 ethertype mpls_uc multiproto
+
+ts_ip "$0" "Show $NEW_DEV BareUDP interface (unicast and multicast MPLS)" -d link show dev $NEW_DEV
+test_on "$NEW_DEV"
+test_on "dstport 6635"
+test_on "ethertype mpls_uc"
+test_on "multiproto"
+
+ts_ip "$0" "Del $NEW_DEV BareUDP interface (unicast and multicast MPLS)" link del dev $NEW_DEV
+
+
+ts_log "[Testing Add BareUDP interface (IPv4)]"
+NEW_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $NEW_DEV BareUDP interface (IPv4)" link add dev $NEW_DEV type bareudp dstport 6635 ethertype ipv4
+
+ts_ip "$0" "Show $NEW_DEV BareUDP interface (IPv4)" -d link show dev $NEW_DEV
+test_on "$NEW_DEV"
+test_on "dstport 6635"
+test_on "ethertype ip"
+test_on "nomultiproto"
+
+ts_ip "$0" "Del $NEW_DEV BareUDP interface (IPv4)" link del dev $NEW_DEV
+
+
+ts_log "[Testing Add BareUDP interface (IPv6)]"
+NEW_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $NEW_DEV BareUDP interface (IPv6)" link add dev $NEW_DEV type bareudp dstport 6635 ethertype ipv6
+
+ts_ip "$0" "Show $NEW_DEV BareUDP interface (IPv6)" -d link show dev $NEW_DEV
+test_on "$NEW_DEV"
+test_on "dstport 6635"
+test_on "ethertype ipv6"
+test_on "nomultiproto"
+
+ts_ip "$0" "Del $NEW_DEV BareUDP interface (IPv6)" link del dev $NEW_DEV
+
+
+ts_log "[Testing Add BareUDP interface (IPv4 and IPv6)]"
+NEW_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $NEW_DEV BareUDP interface (IPv4 and IPv6)" link add dev $NEW_DEV type bareudp dstport 6635 ethertype ipv4 multiproto
+
+ts_ip "$0" "Show $NEW_DEV BareUDP interface (IPv4 and IPv6)" -d link show dev $NEW_DEV
+test_on "$NEW_DEV"
+test_on "dstport 6635"
+test_on "ethertype ip"
+test_on "multiproto"
+
+ts_ip "$0" "Del $NEW_DEV BareUDP interface (IPv4 and IPv6)" link del dev $NEW_DEV
-- 
2.21.3

