Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECA33691E1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242336AbhDWMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:20:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32499 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242273AbhDWMUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:20:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619180386; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=HRl2HJ6Mzs+qrwG0tuqG3rdsIjcIKPhvFjafeky9jsk=; b=k7vOmESoYIDbYIEM+QbGlVaBDlwGKt27TQB6i+NIalQx6CQAA150+bkhdzrWc50G8w+szzjp
 O9j6vs8P9mAbovXfhks03fN4VOBvn1FlKuJ4+GPc+WRf8ARI/s4ctKo2LJ6m/xHBCqkwyagQ
 gVME33t4u/R7fZdDDeKTfxBf/DM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6082bb4987ce1fbb564b5b52 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Apr 2021 12:19:21
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5BB17C43460; Fri, 23 Apr 2021 12:19:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE20CC433D3;
        Fri, 23 Apr 2021 12:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BE20CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v5 0/3] net: qualcomm: rmnet: Enable Mapv5
Date:   Fri, 23 Apr 2021 17:49:00 +0530
Message-Id: <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <stranche@codeaurora.org linux-doc@vger.kernel.org corbet@lwn.net>
References: <stranche@codeaurora.org linux-doc@vger.kernel.org corbet@lwn.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces the MAPv5 packet format.

  Patch 0 documents the MAPv4/v5.
  Patch 1 introduces the MAPv5 and the Inline checksum offload for RX/Ingress.
  Patch 2 introduces the MAPv5 and the Inline checksum offload for TX/Egress.

  A new checksum header format is used as part of MAPv5.For RX checksum offload,
  the checksum is verified by the HW and the validity is marked in the checksum
  header of MAPv5. For TX, the required metadata is filled up so hardware can
  compute the checksum.

  v1->v2:
  - Fixed the compilation errors, warnings reported by kernel test robot.
  - Checksum header definition is expanded to support big, little endian
          formats as mentioned by Jakub.

  v2->v3:
  - Fixed compilation errors reported by kernel bot for big endian flavor.

  v3->v4:
  - Made changes to use masks instead of C bit-fields as suggested by Jakub/Alex.
 
  v4->v5:
  - Corrected checkpatch errors and warnings reported by patchwork.


Sharath Chandra Vurukala (3):
  docs: networking: Add documentation for MAPv5
  net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
  net: ethernet: rmnet: Add support for MAPv5 egress packets

 .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  31 +++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 151 ++++++++++++++++++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   3 +-
 include/linux/if_rmnet.h                           |  27 +++-
 include/uapi/linux/if_link.h                       |   2 +
 8 files changed, 320 insertions(+), 35 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

