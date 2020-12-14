Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519BB2D9D67
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408394AbgLNRPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:15:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729635AbgLNRPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 12:15:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607966068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=UfKpb3E8TSvVCtWoozXzHs3/tRbU9bLtB0STQYelAHc=;
        b=dT9rJBbcw110ClGdxILzNLiQGdr2GJvY5M86kJJJFmMmDp/jmaIaO/apG1mlvuvQI47BnR
        MJz+mx9h6w0T25GHmRMCXjK7wSD9ZcEGxmwleqbjzO4OTrvPq6OsvHkOYxZFmKLpAJzNdY
        5dpU0L6cGLBNyrQVyU8t470+nSAJcj4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-K0kx_p99NC-6u2orY-V1Pw-1; Mon, 14 Dec 2020 12:14:26 -0500
X-MC-Unique: K0kx_p99NC-6u2orY-V1Pw-1
Received: by mail-wr1-f70.google.com with SMTP id q18so6894197wrc.20
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=UfKpb3E8TSvVCtWoozXzHs3/tRbU9bLtB0STQYelAHc=;
        b=V12Mqy80/iXvH/SrhMcI1WPYOlHbFCyPj+53tWpzJYszlx6xdv730AqXQdyuxSKlbP
         eIwos8HHLTYFjXsGJbpogm+lpAhFQIs8DUgBUEOW5dxmOnW9sE1hHobQEcnN1t2q6AMM
         T/2St/4ru3XtFWGKr+EOM8zfEgw71sS05o4wQhY7QCwfhBZ4+gtLzGI4EnJILfWIVz7Q
         a7cCHa++1Exk42xHmcwVC20mKJzd4xfXxB6P1MSaaect4blanbx7b2bdCnBNBmEYQMV2
         KMYyi8r05IbXw21jz7CgzVLm1WATCx1cz6pN/WnSQKNlacpJ0YHtTP3tnO5nIqGHEwLd
         j4LQ==
X-Gm-Message-State: AOAM532P7rnV0mfYbdUKOm8y912qaa8pPXFXqEonGIeiZw/u9gUsBb6D
        fdlJCN3Xr1dJs2m2sbTyQlJsfXS9XluRANRvlndAgItT9kgblkzBryraOVwRutzU9bE56MSPHyN
        aJS7LrI4CJLAEE2oz
X-Received: by 2002:adf:aad3:: with SMTP id i19mr29462855wrc.119.1607966065226;
        Mon, 14 Dec 2020 09:14:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVHT7DgC+uh6NDm0E3fm8QzitEZh1CchKoUGf8KHt5oUjCcUohvyBFbinFouIDLB8k07XdTQ==
X-Received: by 2002:adf:aad3:: with SMTP id i19mr29462849wrc.119.1607966065064;
        Mon, 14 Dec 2020 09:14:25 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z22sm29948862wml.1.2020.12.14.09.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 09:14:24 -0800 (PST)
Date:   Mon, 14 Dec 2020 18:14:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] testsuite: Add mpls packet matching tests for tc
 flower
Message-ID: <28af9e38bf7be76d72fcea8ecf277369781b2bab.1607966001.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Match all MPLS fields using smallest and highest possible values.
Test the two ways of specifying MPLS header matching:

  * with the basic mpls_{label,tc,bos,ttl} keywords (match only on the
    first LSE),

  * with the more generic "lse" keyword (allows matching at different
    depth of the MPLS label stack).

This test file allows to find problems like the one fixed by
Linux commit 7fdd375e3830 ("net: sched: Fix dump of MPLS_OPT_LSE_LABEL
attribute in cls_flower").

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 testsuite/tests/tc/flower_mpls.t | 82 ++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100755 testsuite/tests/tc/flower_mpls.t

diff --git a/testsuite/tests/tc/flower_mpls.t b/testsuite/tests/tc/flower_mpls.t
new file mode 100755
index 00000000..430ed13e
--- /dev/null
+++ b/testsuite/tests/tc/flower_mpls.t
@@ -0,0 +1,82 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+DEV="$(rand_dev)"
+ts_ip "$0" "Add $DEV dummy interface" link add dev $DEV up type dummy
+ts_tc "$0" "Add ingress qdisc" qdisc add dev $DEV ingress
+
+reset_qdisc()
+{
+	ts_tc "$0" "Remove ingress qdisc" qdisc del dev $DEV ingress
+	ts_tc "$0" "Add ingress qdisc" qdisc add dev $DEV ingress
+}
+
+ts_tc "$0" "Add MPLS filter matching first LSE with minimal values" \
+	filter add dev $DEV ingress protocol mpls_uc flower         \
+	mpls_label 0 mpls_tc 0 mpls_bos 0 mpls_ttl 0                \
+	action drop
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls_label 0"
+test_on "mpls_tc 0"
+test_on "mpls_bos 0"
+test_on "mpls_ttl 0"
+
+reset_qdisc
+ts_tc "$0" "Add MPLS filter matching first LSE with maximal values" \
+	filter add dev $DEV ingress protocol mpls_uc flower         \
+	mpls_label 1048575 mpls_tc 7 mpls_bos 1 mpls_ttl 255        \
+	action drop
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls_label 1048575"
+test_on "mpls_tc 7"
+test_on "mpls_bos 1"
+test_on "mpls_ttl 255"
+
+reset_qdisc
+ts_tc "$0" "Add MPLS filter matching second LSE with minimal values" \
+	filter add dev $DEV ingress protocol mpls_uc flower          \
+	mpls lse depth 2 label 0 tc 0 bos 0 ttl 0                    \
+	action drop
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "lse"
+test_on "depth 2"
+test_on "label 0"
+test_on "tc 0"
+test_on "bos 0"
+test_on "ttl 0"
+
+reset_qdisc
+ts_tc "$0" "Add MPLS filter matching second LSE with maximal values" \
+	filter add dev $DEV ingress protocol mpls_uc flower          \
+	mpls lse depth 2 label 1048575 tc 7 bos 1 ttl 255            \
+	action drop
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "lse"
+test_on "depth 2"
+test_on "label 1048575"
+test_on "tc 7"
+test_on "bos 1"
+test_on "ttl 255"
+
+reset_qdisc
+ts_tc "$0" "Add MPLS filter matching two LSEs"                   \
+	filter add dev $DEV ingress protocol mpls_uc flower mpls \
+	lse depth 1 label 0 tc 0 bos 0 ttl 0                     \
+	lse depth 2 label 1048575 tc 7 bos 1 ttl 255             \
+	action drop
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "lse"
+test_on "depth 1"
+test_on "label 0"
+test_on "tc 0"
+test_on "bos 0"
+test_on "ttl 0"
+test_on "depth 2"
+test_on "label 1048575"
+test_on "tc 7"
+test_on "bos 1"
+test_on "ttl 255"
-- 
2.21.3

