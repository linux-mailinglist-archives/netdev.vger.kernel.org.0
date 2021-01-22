Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B1D3009B7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbhAVR1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729250AbhAVPsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:50 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45722C061353;
        Fri, 22 Jan 2021 07:47:41 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id p21so3046028lfu.11;
        Fri, 22 Jan 2021 07:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jMSB2XCCWwNKG8wfylQfgVp3ITrC3cpaG+GY+0LO0PU=;
        b=KEEaNXrTQp2zANXAAA8as5TO5XyRPWiakvMFCwTdtB3EFh5rLqR3vEsZ/bh7XpMTko
         pQ+sr6lVjEhub9SWNrACvgQL1ZvQAwoCcwbw92MeLVUjdCg93rGkwi/F3VH02DJsfSh/
         9urOs06JzAEQgCD6vf9MGWdWk6vo0d+2OnbKtMX7nm51NbTg7vL22FA8oujbj+8YfZXy
         VlRvGGWvBCE6yp2JhpI72DXxSgBsiCpYp9zyceYfPgFqz1XQktrnFifU8OTGu7NYmgsj
         hrAiKWXegLDyxt16PK5z0xoe12XHgaIMGW6OezCaHHUCZHoV7tVyr3L92syvhjsCky1F
         kdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jMSB2XCCWwNKG8wfylQfgVp3ITrC3cpaG+GY+0LO0PU=;
        b=nBSQ8EeIKbRQClQIpqma0bP+H8pYrI1sDwwVosL6WEMQ9cRDn10+H11uT0+etxxTKP
         5iBThDSJzdwGP7kIFRKu10Y0YBRIgppsHMbuia5lTjXMq7E/hUknab/diDcOh0vYsTJx
         vp8l93Noh0iC5iTF4TJmYcelj6bY/sn122hDeRsWCE+bQLqS9LuA1LQa8sms67YiMidT
         g8hOdAL0WPqlnYufowqfVhYmjD3gRjqi169LOfB/XVgka13wXn0kfFfMR95WxUXKrj24
         0RXlZxSadBtO+GkWYSdtlff5drlOaa03dsc/uSmuNGY2SKPCX6dAnBnfuYlmcd1WHzkv
         25GA==
X-Gm-Message-State: AOAM531Bt8trJtzxkkaaOxfQBRDFbfOhw3s9JHfJ/Y0MBtNhIJM5Plhl
        sRLk2ZyFNBVPI5/hu85sBo4=
X-Google-Smtp-Source: ABdhPJykkXUMRdMcuwSrXVRYurNf/zOIdp5azOfvUEFE75s28b6RkfCtSV/qDyZ8YfiUGK6eZ8MeBw==
X-Received: by 2002:ac2:5d4f:: with SMTP id w15mr2473867lfd.321.1611330459835;
        Fri, 22 Jan 2021 07:47:39 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:39 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 07/12] selftests/bpf: change type from void * to struct ifaceconfigobj *
Date:   Fri, 22 Jan 2021 16:47:20 +0100
Message-Id: <20210122154725.22140-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Instead of casting from void *, let us use the actual type in
init_iface_config().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 28 ++++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index bea006ad8e17..c2cfc0b6d19e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -981,25 +981,25 @@ static void testapp_sockets(void)
 	print_ksft_result();
 }
 
-static void init_iface_config(void *ifaceconfig)
+static void init_iface_config(struct ifaceconfigobj *ifaceconfig)
 {
 	/*Init interface0 */
 	ifdict[0]->fv.vector = tx;
-	memcpy(ifdict[0]->dst_mac, ((struct ifaceconfigobj *)ifaceconfig)->dst_mac, ETH_ALEN);
-	memcpy(ifdict[0]->src_mac, ((struct ifaceconfigobj *)ifaceconfig)->src_mac, ETH_ALEN);
-	ifdict[0]->dst_ip = ((struct ifaceconfigobj *)ifaceconfig)->dst_ip.s_addr;
-	ifdict[0]->src_ip = ((struct ifaceconfigobj *)ifaceconfig)->src_ip.s_addr;
-	ifdict[0]->dst_port = ((struct ifaceconfigobj *)ifaceconfig)->dst_port;
-	ifdict[0]->src_port = ((struct ifaceconfigobj *)ifaceconfig)->src_port;
+	memcpy(ifdict[0]->dst_mac, ifaceconfig->dst_mac, ETH_ALEN);
+	memcpy(ifdict[0]->src_mac, ifaceconfig->src_mac, ETH_ALEN);
+	ifdict[0]->dst_ip = ifaceconfig->dst_ip.s_addr;
+	ifdict[0]->src_ip = ifaceconfig->src_ip.s_addr;
+	ifdict[0]->dst_port = ifaceconfig->dst_port;
+	ifdict[0]->src_port = ifaceconfig->src_port;
 
 	/*Init interface1 */
 	ifdict[1]->fv.vector = rx;
-	memcpy(ifdict[1]->dst_mac, ((struct ifaceconfigobj *)ifaceconfig)->src_mac, ETH_ALEN);
-	memcpy(ifdict[1]->src_mac, ((struct ifaceconfigobj *)ifaceconfig)->dst_mac, ETH_ALEN);
-	ifdict[1]->dst_ip = ((struct ifaceconfigobj *)ifaceconfig)->src_ip.s_addr;
-	ifdict[1]->src_ip = ((struct ifaceconfigobj *)ifaceconfig)->dst_ip.s_addr;
-	ifdict[1]->dst_port = ((struct ifaceconfigobj *)ifaceconfig)->src_port;
-	ifdict[1]->src_port = ((struct ifaceconfigobj *)ifaceconfig)->dst_port;
+	memcpy(ifdict[1]->dst_mac, ifaceconfig->src_mac, ETH_ALEN);
+	memcpy(ifdict[1]->src_mac, ifaceconfig->dst_mac, ETH_ALEN);
+	ifdict[1]->dst_ip = ifaceconfig->src_ip.s_addr;
+	ifdict[1]->src_ip = ifaceconfig->dst_ip.s_addr;
+	ifdict[1]->dst_port = ifaceconfig->src_port;
+	ifdict[1]->src_port = ifaceconfig->dst_port;
 }
 
 int main(int argc, char **argv)
@@ -1038,7 +1038,7 @@ int main(int argc, char **argv)
 
 	num_frames = ++opt_pkt_count;
 
-	init_iface_config((void *)ifaceconfig);
+	init_iface_config(ifaceconfig);
 
 	pthread_init_mutex();
 
-- 
2.27.0

