Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402DF321E32
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 18:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBVRgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 12:36:04 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:63416 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhBVRf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 12:35:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614015330; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=CUo7EnfzV6YKWuuKEeJZrB9rPqt97SlwJjOh49D6+Hs=;
 b=hvFUpQSBKwXAHqKpYYnL/P+ZCJ7RTE8hZmZ+weqnX+lTCVk0qmRW91IrZDCSKrgQMHDbizNx
 aVpdUBWyoGEG9aMGdQV+pwTS64EqSmHIWG4JxofoNI3v24FUwCNaXNwG/uZDcAiUyEtnL+64
 aXYhMGC2KyoERydkCY1amIeL+Is=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6033eb474511108a813cf873 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Feb 2021 17:35:03
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62A17C43461; Mon, 22 Feb 2021 17:35:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B00A8C433C6;
        Mon, 22 Feb 2021 17:35:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 22 Feb 2021 10:35:01 -0700
From:   subashab@codeaurora.org
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: qualcomm: rmnet: Enable Mapv5
In-Reply-To: <1614012946-23506-1-git-send-email-sharathv@codeaurora.org>
References: <1614012946-23506-1-git-send-email-sharathv@codeaurora.org>
Message-ID: <1a93bc111339e4d3c4e4b765945ab150@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-22 09:55, Sharath Chandra Vurukala wrote:
> This series introduces the MAPv5 packet format.
> 
> Patch 0 documents the MAPv5.
> Patch 1 introduces the Mapv5 and the Inline checksum offload for RX.
> Patch 2 introduces the Mapv5 and the Inline checksum offload for TX.
> 
> A new checksum header format is used as part of MAPv5.
> For RX checksum offload, the checksum is verified by the HW and the
> validity is marked in the checksum header of MAPv5.
> for TX, the required metadata is filled up so hardware can compute the
> checksum.
> 
> v1->v2:
> - Fixed the compilation errors, warnings reported by kernel test robot.
> - Checksum header definition is expanded to support big, little endian
> formats as mentioned by Jakub.
> 
> Sharath Chandra Vurukala (3):
>   docs: networking: Add documentation for MAPv5
>   net: ethernet: rmnet: Support for downlink MAPv5 checksum offload
>   net: ethernet: rmnet: Add support for Mapv5 uplink packet
> 
>  .../device_drivers/cellular/qualcomm/rmnet.rst     |  53 ++++++-
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  34 +++--
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  22 ++-
>  .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 153
> ++++++++++++++++++++-
>  include/linux/if_rmnet.h                           |  24 +++-
>  include/uapi/linux/if_link.h                       |   2 +
>  7 files changed, 263 insertions(+), 29 deletions(-)

For the series-

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
