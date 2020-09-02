Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA47825AE4B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgIBPFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgIBPFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:05:04 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB46C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 08:05:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a65so4738383wme.5
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y2praCwk2h7D6zX76VPwMVzyC7RXivJ38UC9I3lNXD8=;
        b=N6q5Q0noocmmBhLBuQX52bpQ5S1P+QYwZWXaNhkYS8Rb9/UQKOIN3cFdb6U0S2OO/g
         sH3zCjgLuuSg7CTKHlfEPIZwXYtGcaCGebWgwjFwIUIIO9PJSqnvjmRbHQdMehiZJ9xp
         aDUqRWUHGgQgkf+cfFR2eYkfKFVOipNdl+S3JD6ZKnhxFt/KTm5VZ/VLHEW77G91cmgq
         1yNtrfOD2fNOqhBLJkCZDjmEs7wENlhWw995UREsVtpXY/AEmWoyJ8GgDK9DBUIFGmMz
         AthbB4tKEkcAMhHD5rl4SLI5guK4Dzck7yRxdgHXBNQwkq4YAhlwQEp+4+gSVsigJX47
         hh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y2praCwk2h7D6zX76VPwMVzyC7RXivJ38UC9I3lNXD8=;
        b=pc249z/G7qLDPHgY6wT5vTSpG8LkiZElkl9a0Wg+ExAdcLYd0aLIr7tu6B4I8pHe8r
         NaSWKHeXi/YW7UmYTOtoe5yOato4mm9ERIWiM6sDBvuAVh9jRgHjUJLIcZjLdgq0BPUm
         g1qOfiYWCpSz/UVcsvBvxI4U/i2PcDbndWX5KIbsgp3myGWGcXxv5QgUSweB7+uS3h8s
         9CtW/zGEpabcVIrDjrwjmhYSdWM12xJwy3N7/8Hp1mmElYMP1y4Gboh15M6+OhwO3D4z
         W0EKtH0Jc5fouW2kaWNfEgGAXJgx2LGQ/b652lZVrjNfbUhaP0JSD4cov/J3MZTpXLEs
         kVLQ==
X-Gm-Message-State: AOAM533NwDTlv6RwbzxSoliUTzq5VPqG2T9PXD8eTCAP5Oj14mxcUw8E
        lyYO0GMH/vZwrahAwJWVWWz5UQKPrG8pbw==
X-Google-Smtp-Source: ABdhPJyfI7+In8hAUp3rVkbyWFySXkhqkpgDeAmK6ysm3O3YMUNzQhy+moI/pau9X134R8FVP1bbhg==
X-Received: by 2002:a7b:ce89:: with SMTP id q9mr1091302wmj.65.1599059102932;
        Wed, 02 Sep 2020 08:05:02 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id n4sm7334597wrp.61.2020.09.02.08.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 08:05:02 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] nfp: flower: fix ABI mismatch between driver and firmware
Date:   Wed,  2 Sep 2020 17:04:58 +0200
Message-Id: <20200902150458.10024-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

Fix an issue where the driver wrongly detected ipv6 neighbour updates
from the NFP as corrupt. Add a reserved field on the kernel side so
it is similar to the ipv4 version of the struct and has space for the
extra bytes from the card.

Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 2df3deedf9fd..7248d248f604 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -61,6 +61,7 @@ struct nfp_tun_active_tuns {
  * @flags:		options part of the request
  * @tun_info.ipv6:		dest IPv6 address of active route
  * @tun_info.egress_port:	port the encapsulated packet egressed
+ * @tun_info.extra:		reserved for future use
  * @tun_info:		tunnels that have sent traffic in reported period
  */
 struct nfp_tun_active_tuns_v6 {
@@ -70,6 +71,7 @@ struct nfp_tun_active_tuns_v6 {
 	struct route_ip_info_v6 {
 		struct in6_addr ipv6;
 		__be32 egress_port;
+		__be32 extra[2];
 	} tun_info[];
 };
 
-- 
2.20.1

