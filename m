Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF90A319536
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhBKVgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:36:51 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:34892 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhBKVgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:36:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613079384; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=kTYGRIJ+gAqKGdcThMfW0DE/isDdfmpXADTavHycvgA=; b=S3o89Ig73FO/pTtOipKZY6rxIUBwkfBBJRFrwV0zo+OaVDS91UAENV6BRJ+c0L7tXJyqWyES
 A+VGh1+sxha+rjAsE4zqStwQtC26+ZACiETCCIJgv1WyHx2ouBJh/y61d58iGywLYdHS4qO+
 B/+dDgMh4/MWkAMzV/9wsFnaHVk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6025a337d5a7a3baae7bb2ac (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 21:35:51
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D1181C43461; Thu, 11 Feb 2021 21:35:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C90F1C433CA;
        Thu, 11 Feb 2021 21:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C90F1C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH 0/3]net:qualcomm:rmnet:Enable Mapv5.
Date:   Fri, 12 Feb 2021 03:05:21 +0530
Message-Id: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces the MAPv5 packet format.

Patch 0 documents the MAPv5.
Patch 1 introduces the Mapv5 and the Inline checksum offload for RX.
Patch 2 introduces the Mapv5 and the Inline checksum offload for TX.

A new checksum header format is used as part of MAPv5.
For RX checksum offload, the checksum is verified by the HW and the validity is marked in the checksum header of MAPv5.
for TX, the required metadata is filled up so hardware can compute the checksum.

Sharath Chandra Vurukala (3):
  docs:networking: Add documentation for MAP v5
  net:ethernet:rmnet:Support for downlink MAPv5 csum offload
  net:ethernet:rmnet: Add support for Mapv5 Uplink packet

 .../device_drivers/cellular/qualcomm/rmnet.rst     |  53 +++++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  36 ++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  36 +++++-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 136 +++++++++++++++++++--
 include/linux/if_rmnet.h                           |  17 ++-
 include/uapi/linux/if_link.h                       |   2 +
 7 files changed, 255 insertions(+), 29 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

