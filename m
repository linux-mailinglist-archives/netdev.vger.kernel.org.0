Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460FF4F5F6E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiDFNSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiDFNRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:17:15 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D4A610918
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:55:40 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso3301548wma.0
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 02:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gP5E+S0OVvLHVCYowDmq4iA9V2CqyXmy3UTP8YLCsUQ=;
        b=aWgtn74kxNKy9HpEzEjzXwMNsdnkVaxExsUFyJoRf3oRN5do1LxVccwBniu1Cpm2Hl
         W5iZNTQPM7ShvPMkwVJL9MrQmyw37iP54Jihrctsusrzx2DSdOEiqu2p4hRcWHG61TnW
         u2/A/TNjcE4pDR6DYwMEIK/1dvYYrMSxOG+Q1vRb371iKW+Ku2UM5OlXQ8gU5TiudqiZ
         y9y9le1APbJaKQudw2gfhJLpr0LORJYZs6alsg5Hpy6miW1fENrdVVvI9vKTsm8KF1SE
         KCL7tSInLWMW+1L7YMWw+MV4zX+TV73oPCvmYujeTMLqpEYBTg6Rwz2PROIoxup+K3IP
         gN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gP5E+S0OVvLHVCYowDmq4iA9V2CqyXmy3UTP8YLCsUQ=;
        b=psD6IC3YyIiO/mb01aTTrIvL94tGxeXSLDDI4hEBCoKJI+41z7lOpklHl4yD6zp5nO
         FTc6pYzUMfvPyxFQeSJa0bF2/F2t2QVRJj2gL28qHTKoLOxix1QhYR68HSnoNJ1xD6Ks
         Fm+AJMoTIlHvDTZ6ZyHGAUEUA6fnonhl/hFE9FprdApAbdZY0S3qtd2k8zOaBa/huJTc
         Feggv6QaIjRZSfgo1F/5z7HZe/Qx4fuukF8rvgd7VmM52cL36EQT6pmzAQR/A8FO60/j
         wDwRazhiooybt5hAjQNQNqsTO1+TU4hRrCUBXb/iZrdrnb0IiN5OXwwy5gspUjGGF12e
         7TWw==
X-Gm-Message-State: AOAM530w+QSmBBm9qGNb7Qg4zk6rRI05xqsbV56QMfsQBG3OAeDIneE5
        Grt68DOhYMyH8Rq+wHqlgoktcZycNvfP/Q==
X-Google-Smtp-Source: ABdhPJzja+5DtRKA2qMLTVogcaM1f3qK/EOT2bNBO+YXRkTMRbcqErtfSQbdb1JXWGZ5qdHhkv3k0A==
X-Received: by 2002:a05:600c:a08:b0:38c:93c8:36e9 with SMTP id z8-20020a05600c0a0800b0038c93c836e9mr6762147wmp.97.1649238783664;
        Wed, 06 Apr 2022 02:53:03 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d6652000000b001e669ebd528sm13874604wrw.91.2022.04.06.02.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 02:53:03 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2 2/2] ixgbe: fix unexpected VLAN Rx in promisc mode on VF
Date:   Wed,  6 Apr 2022 11:52:52 +0200
Message-Id: <20220406095252.22338-3-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406095252.22338-1-olivier.matz@6wind.com>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the promiscuous mode is enabled on a VF, the IXGBE_VMOLR_VPE
bit (VLAN Promiscuous Enable) is set. This means that the VF will
receive packets whose VLAN is not the same than the VLAN of the VF.

For instance, in this situation:

┌────────┐    ┌────────┐    ┌────────┐
│        │    │        │    │        │
│        │    │        │    │        │
│     VF0├────┤VF1  VF2├────┤VF3     │
│        │    │        │    │        │
└────────┘    └────────┘    └────────┘
   VM1           VM2           VM3

vf 0:  vlan 1000
vf 1:  vlan 1000
vf 2:  vlan 1001
vf 3:  vlan 1001

If we tcpdump on VF3, we see all the packets, even those transmitted
on vlan 1000.

This behavior prevents to bridge VF1 and VF2 in VM2, because it will
create a loop: packets transmitted on VF1 will be received by VF2 and
vice-versa, and bridged again through the software bridge.

This patch remove the activation of VLAN Promiscuous when a VF enables
the promiscuous mode. However, the IXGBE_VMOLR_UPE bit (Unicast
Promiscuous) is kept, so that a VF receives all packets that has the
same VLAN, whatever the destination MAC address.

Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
Cc: stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 8d108a78941b..d4e63f0644c3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1208,9 +1208,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 			return -EPERM;
 		}
 
-		disable = 0;
+		disable = IXGBE_VMOLR_VPE;
 		enable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
-			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
+			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.30.2

