Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9B4A4143
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358452AbiAaLDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:03:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358972AbiAaLCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643626938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=iAuAstdSQtJ7rDr/7ExlEzA26vHIXa2hOFJVLDCu4hQ=;
        b=KCXyJa+qpcAts4qyrZKuip+QuMh75Qu1yvwT4glP4R+sPUwmeMfW8JHLZhMXt0aNhumbOL
        Oajpnrqmk2d5WkbTRtaDrWgdT9KhC4EU8lspfwYJA25dGhu78ym2Bk04yKtcnuHgnofzQ3
        +q7A/bLgKoDLnHBZHtEFRUi7nPvZAJk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-sbpBZKTFOli2g7G_6s26Hg-1; Mon, 31 Jan 2022 06:02:16 -0500
X-MC-Unique: sbpBZKTFOli2g7G_6s26Hg-1
Received: by mail-wr1-f69.google.com with SMTP id g17-20020adfa591000000b001da86c91c22so4688073wrc.5
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:02:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=iAuAstdSQtJ7rDr/7ExlEzA26vHIXa2hOFJVLDCu4hQ=;
        b=ty4xrBBqDIWXmH0MNTJSx3mH/AjTOKF0uA3H9EQthWZ85anH+e97f8tz6jvjkS0sYS
         D+cEq1DLCVI76RcSX2l4NUdS+G2Zuzpv6SKkcBDgpcYcNqkcNu1eT3tXifalmMDLKNxc
         u68b0pZEMmX3odjfwbEcr1K3dIusNd3nQq6bbLX6mqbVSEcL/KKz+KtK3ZcSwAxwCYQY
         JfFk9jyqK68cAdsILFlEdzuEkUnILXH1OkXchUdvI8E49ad5PWqAzlLqMz8lR/LXvI00
         aP6Pcj+r1gbgM38mKRDFgeW5A1jLupgSdIM8bABOtbSMfhM3gbssy2bpsAcmvT79R+tl
         9emQ==
X-Gm-Message-State: AOAM533Hvz+ZKajbIQ3B5JpzvZmJJRKEluV8BpnHB9ueboM5b5IrHuiX
        X3dicwgCCwPFlpPoiCACO2gECl7C+8MetfM5Vq/GIDJLNb8exXVya3B9XXhbwkM54BONAGW8oqx
        4OzfF3y4Vi/m7uCr4
X-Received: by 2002:a5d:5887:: with SMTP id n7mr16961928wrf.116.1643626935476;
        Mon, 31 Jan 2022 03:02:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXapK4AidDff0EK7TlxZD1sXrPWs8WX0uZafG4t0Z63g5R3h4Zz7+pgalm3xaYhNnZtmAEPQ==
X-Received: by 2002:a5d:5887:: with SMTP id n7mr16961903wrf.116.1643626935293;
        Mon, 31 Jan 2022 03:02:15 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m14sm14069745wrp.4.2022.01.31.03.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 03:02:14 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:02:13 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH iproute2-next] iprule: Allow option dsfield in 'ip rule show'
Message-ID: <a24fd0ef941c32a14b0802ed98194df826d11e13.1643626866.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the dsfield option was added to ip rule, it only worked for add
and delete operations. For consistency, allow it when dumping rules
too.

Fixes: dec01609dc62 ("iproute2: Add dsfield as alias for tos for ip rules")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/iprule.c                       |  3 ++-
 testsuite/tests/ip/rule/dsfield.t | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100755 testsuite/tests/ip/rule/dsfield.t

diff --git a/ip/iprule.c b/ip/iprule.c
index 4166073c..2d39e01b 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -592,7 +592,8 @@ static int iprule_list_flush_or_save(int argc, char **argv, int action)
 			filter.prefmask = 1;
 		} else if (strcmp(*argv, "not") == 0) {
 			filter.not = 1;
-		} else if (strcmp(*argv, "tos") == 0) {
+		} else if (strcmp(*argv, "tos") == 0 ||
+			   strcmp(*argv, "dsfield") == 0) {
 			__u32 tos;
 
 			NEXT_ARG();
diff --git a/testsuite/tests/ip/rule/dsfield.t b/testsuite/tests/ip/rule/dsfield.t
new file mode 100755
index 00000000..79ad4e2b
--- /dev/null
+++ b/testsuite/tests/ip/rule/dsfield.t
@@ -0,0 +1,29 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+ts_log "[Testing rule with option dsfield/tos]"
+
+ts_ip "$0" "Add IPv4 rule with dsfield 0x10" -4 rule add dsfield 0x10
+ts_ip "$0" "Show IPv4 rule with dsfield 0x10" -4 rule show dsfield 0x10
+test_on "tos 0x10"
+test_lines_count 1
+ts_ip "$0" "Delete IPv4 rule with dsfield 0x10" -4 rule del dsfield 0x10
+
+ts_ip "$0" "Add IPv4 rule with tos 0x10" -4 rule add tos 0x10
+ts_ip "$0" "Show IPv4 rule with tos 0x10" -4 rule show tos 0x10
+test_on "tos 0x10"
+test_lines_count 1
+ts_ip "$0" "Delete IPv4 rule with tos 0x10" -4 rule del tos 0x10
+
+ts_ip "$0" "Add IPv6 rule with dsfield 0x10" -6 rule add dsfield 0x10
+ts_ip "$0" "Show IPv6 rule with dsfield 0x10" -6 rule show dsfield 0x10
+test_on "tos 0x10"
+test_lines_count 1
+ts_ip "$0" "Delete IPv6 rule with dsfield 0x10" -6 rule del dsfield 0x10
+
+ts_ip "$0" "Add IPv6 rule with tos 0x10" -6 rule add tos 0x10
+ts_ip "$0" "Show IPv6 rule with tos 0x10" -6 rule show tos 0x10
+test_on "tos 0x10"
+test_lines_count 1
+ts_ip "$0" "Delete IPv6 rule with tos 0x10" -6 rule del tos 0x10
-- 
2.21.3

