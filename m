Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B029AA07
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420919AbgJ0Kv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:51:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45908 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420772AbgJ0Kv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:51:57 -0400
Received: by mail-lj1-f194.google.com with SMTP id t13so1053077ljk.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 03:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=C3jYDgP/Qw8k4BCRb4Q8W76vaW0l52+hQa3NbtQNWoU=;
        b=eUypqGLnCq/MNsGxeYzhMRgo9sbF+FhWESg6XGogKs3bg9FHivViv01HLFNail7oN6
         Kirs6IyUNF8Qltkn8+nDoxeE1XacIju26SmOhflDuwcYAIdEhINm85MUt+5gvzFhlo39
         k97xDqdVYOfmAAHtAZFRWJfUA/QRez2hGOhwj3k5tvLZZ3PBDttpypHAS819DSJu70lN
         q7GpqbcZvL75W8AyKhy+99bNq+PthrB+uL42xsrGGUL3hUqigJ9VfFSPr52F3SZm0PRp
         kAkqJv71gHEXpBmQW+zyUPgY5ei7OTKSNdZOiGlewkPiYvsGcW+1+OET9Wq6Bt9so3Dd
         gbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=C3jYDgP/Qw8k4BCRb4Q8W76vaW0l52+hQa3NbtQNWoU=;
        b=GYDAdvqza3MmxdRL7dqFFI98Xs8DUIaBKt38IvModL3oWRFKQZ2mqaMSO447YxV/9g
         keu9zWl73Js3REh4cqweOd6V5md1DFVotssY01IfOGMNIMxrf9tyMq+2et6qM/U1yygQ
         gCsSRKF3QEzR1TLBHgfGES9wZbOijARoSrK/0A5k17yAwLEEoNWGFN/GLJWsTa4rb9Ha
         m5T8GQsDCY5fGRZZcwkB2qv3Nr2DJ+d6Dd/EQ+wMSF/yMWZeG/DdzVx0nr5t7u8SE2Ks
         UFhJ2rywmEtZhsEWwCaqaQvDLA2KGg/CnmL4Ndj5JDyNP5V7EdLhk6E7kXKSb7tPoP1j
         Ufsg==
X-Gm-Message-State: AOAM5310lATIfyJ7wGls1UFc9ID796r8kagBfHPgE16HiUrpaJ56UzCU
        1vqSoCcZqpieyKFRatxucjqhsiw3IdeCWnaZ
X-Google-Smtp-Source: ABdhPJxOktM8kBYeTTQT+rDgYqwnjv3WWJZx6RnmyZClPT6pdObge7+wUDlXjC77jBwA/yQ3hTHAqg==
X-Received: by 2002:a2e:8184:: with SMTP id e4mr868650ljg.383.1603795913968;
        Tue, 27 Oct 2020 03:51:53 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s19sm134385lfb.224.2020.10.27.03.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 03:51:53 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 1/4] net: dsa: mv88e6xxx: use ethertyped dsa for 6390/6390X
Date:   Tue, 27 Oct 2020 11:51:14 +0100
Message-Id: <20201027105117.23052-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The policy is to use ethertyped DSA for all devices that are capable
of doing so, which the Peridot is.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bd297ae7cf9e..536ee6cff779 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5100,7 +5100,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.tag_protocol = DSA_TAG_PROTO_EDSA,
 		.ptp_support = true,
 		.ops = &mv88e6390_ops,
 	},
@@ -5124,7 +5124,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.tag_protocol = DSA_TAG_PROTO_EDSA,
 		.ptp_support = true,
 		.ops = &mv88e6390x_ops,
 	},
-- 
2.17.1

