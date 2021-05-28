Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0A393E55
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhE1IDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:03:12 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:42669 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235696AbhE1ICd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 04:02:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622188845; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=0JggiS6q++Z5cme5YrZH2L2alHGJtPHU1nSgNn4bYWk=;
 b=CLKa7hHNEd7HFwXAGK/lhdm+dgElwEUU44f0n5nkZpDfvCdCwr9s0XpaKrA/DW+fcsuCcpSV
 gZqRAleDX2vYIzkxZbp06zp+V8ewgcx7mhz3toH9Jcw84+bmej5+0NW+RMh+4rnJe6xoSsbn
 w3lVcfiL872+Jn7sudGczb5lE60=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60b0a327e27c0cc77fef8363 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 28 May 2021 08:00:39
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3A6D5C433D3; Fri, 28 May 2021 08:00:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C322BC4338A;
        Fri, 28 May 2021 08:00:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 28 May 2021 02:00:36 -0600
From:   subashab@codeaurora.org
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 0/3] net: qualcomm: rmnet: Enable Mapv5
In-Reply-To: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
References: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
Message-ID: <48eb11b2f69fa3b27692038c064daac8@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-27 02:48, Sharath Chandra Vurukala wrote:
> This series introduces the MAPv5 packet format.
> 
>    Patch 0 documents the MAPv4/v5.
>    Patch 1 introduces the MAPv5 and the Inline checksum offload for
> RX/Ingress.
>    Patch 2 introduces the MAPv5 and the Inline checksum offload for
> TX/Egress.
> 
>    A new checksum header format is used as part of MAPv5.For RX 
> checksum
> offload,
>    the checksum is verified by the HW and the validity is marked in the
> checksum
>    header of MAPv5. For TX, the required metadata is filled up so 
> hardware
> can
>    compute the checksum.
> 
>    v1->v2:
>    - Fixed the compilation errors, warnings reported by kernel test 
> robot.
>    - Checksum header definition is expanded to support big, little 
> endian
>            formats as mentioned by Jakub.
> 
>    v2->v3:
>    - Fixed compilation errors reported by kernel bot for big endian
> flavor.
> 
>    v3->v4:
>    - Made changes to use masks instead of C bit-fields as suggested by
> Jakub/Alex.
> 
>    v4->v5:
>    - Corrected checkpatch errors and warnings reported by patchwork.
> 
>    v5->v6:
>    - Corrected the bug identified by Alex and incorporated all his
> comments.
> 
>    v6->v7:
>    - Removed duplicate inclusion of linux/bitfield.h in 
> rmnet_map_data.c
> 
> Sharath Chandra Vurukala (3):
>   docs: networking: Add documentation for MAPv5
>   net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
>   net: ethernet: rmnet: Add support for MAPv5 egress packets
> 
>  .../device_drivers/cellular/qualcomm/rmnet.rst     | 126
> +++++++++++++++--
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  34 +++--
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 151
> +++++++++++++++++++--
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   3 +-
>  include/linux/if_rmnet.h                           |  26 +++-
>  include/uapi/linux/if_link.h                       |   2 +
>  8 files changed, 320 insertions(+), 37 deletions(-)

For the series-

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
