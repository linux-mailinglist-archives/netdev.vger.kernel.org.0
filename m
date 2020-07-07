Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4321C2167DC
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGGH7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgGGH7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:59:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC3EC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 00:59:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cv18so667465pjb.1
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 00:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3olRL5AOtjYkaaCEnumLovJR2dhQKUs6npZPSM9Nj9c=;
        b=aWrs9WgwWbcEF1thIokLU5gSh21k4m4uXiT2qALtmFmIxFANvGC1ed1FGz2gOp2PSd
         Lii5uwLXsiDPf9qHsu5s7vR2mCkATvP7RoqiER2GP39XdG2pdTTIJq9CuQ0b0bO91bQT
         PEPepz0OjA0kEM1ngU2L3/cal7Dr43J0W/1TbSkue/ZK5F/E4jt15yoifEA6N5tEHKa6
         Y9RnN2eHlAhhU9tgF5zqn758QBRlCZIn7Zq/de+HvPzafRun3bHox/k7kYNH2Vw0j/SQ
         9UeoGoXRQMVmpkwbWvPWBAb5C3xHQYUd8LaMhBnlvWKnoJaehf0DavuPoN2mmTxIW5HE
         wUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3olRL5AOtjYkaaCEnumLovJR2dhQKUs6npZPSM9Nj9c=;
        b=gU5qbZbWnvRfuORAW/sdpwzHJQ4Hi1uWGpoi+NL1A0SKdR4hZxGCK5WIIoZkXkIWUE
         jv7OkhjG05rsf9UhQTQX/jiKFv5lvxOCFXRckUsl4WbJNZacdMURSLoWlqwOFTYRhegR
         8DAB1khDgMD0gHhdMbSAxbX70Gn8/Ir2OR61bpFcO3LRcJw7Qa0vx+ac0IEQY6zz+1gq
         y5xx1lAyfv2szBxi86zGd3QACtkYorEMjufKohziMw7StMw0G3KfpIDDGL0+cjMXl/UY
         udCCwvCtWlOXvnODkmhoNHMBxVrYhVZtuSgwIHFmv3GoSD4zvjaGCdKV6AV5raBdLkzY
         Gn9A==
X-Gm-Message-State: AOAM530sQOEPSTUu8OoVnfTwRc9MN8bI2X35favRWhaAEOGDKwxYKgpc
        tAsr56cPcx/nKGaIKo2ygDyHpSzZ/mI=
X-Google-Smtp-Source: ABdhPJxML/iKkIM+/ww3tNqjcscSjolXtI1Z6un0x7s0k9S/A1mN6z+RlwV/ImfrvqdOj2ZkhkTAuw==
X-Received: by 2002:a17:90a:db8a:: with SMTP id h10mr3114105pjv.197.1594108755171;
        Tue, 07 Jul 2020 00:59:15 -0700 (PDT)
Received: from ubuntu.lan ([2001:470:e92d:10:d902:a0b:7fe5:30e6])
        by smtp.gmail.com with ESMTPSA id j70sm22023271pfd.208.2020.07.07.00.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 00:59:14 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>
Subject: [PATCH iproute2] configure: support ipset version 7 with kernel version 5
Date:   Tue,  7 Jul 2020 00:58:33 -0700
Message-Id: <20200707075833.1698-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The configure script checks for ipset v6 availability but doesn't test
for v7, which is backward compatible and used on kernel v5.x systems.
Update the script to test for both ipset versions. Without this change,
the tc ematch function em_ipset will be disabled.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index f415bf49..307912aa 100755
--- a/configure
+++ b/configure
@@ -208,7 +208,7 @@ typedef unsigned short ip_set_id_t;
 #include <linux/netfilter/xt_set.h>
 
 struct xt_set_info info;
-#if IPSET_PROTOCOL == 6
+#if IPSET_PROTOCOL == 6 || IPSET_PROTOCOL == 7
 int main(void)
 {
 	return IPSET_MAXNAMELEN;
-- 
2.17.1

