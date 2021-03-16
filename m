Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE133CB8D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhCPCis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:38:48 -0400
Received: from m42-2.mailgun.net ([69.72.42.2]:52620 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234672AbhCPCin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 22:38:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615862323; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=H6khojduHEhXARHECePmKhjD97cpSVaxOCAUdHL/+Do=;
 b=v8BL1pj3VAjnQBSD8Ynqf4Pouwa6fY2SnkbYVZsaphMKQ097sRwJlJGcVURcf1gbvAfSkybB
 YLG4fhmDM4SAt1SEgRBpoqsBS8N0u1GR0BpXT05UKzR8xvDUc1d040x7gBArPT8Z4LKxD3gA
 Fkx5uyzLSZIxB/t81v+mPXbTUfM=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60501a221de5dd7b9941696f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 16 Mar 2021 02:38:26
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62C4DC43464; Tue, 16 Mar 2021 02:38:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83A78C433CA;
        Tue, 16 Mar 2021 02:38:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 20:38:24 -0600
From:   subashab@codeaurora.org
To:     Alex Elder <elder@linaro.org>
Cc:     stranche@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@aculab.com, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
References: <20210315215151.3029676-1-elder@linaro.org>
Message-ID: <e74a1c580d56ecb6ba9643a9dc133168@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-15 15:51, Alex Elder wrote:
> Version 6 is the same as version 5, but has been rebased on updated
> net-next/master.  With any luck, the patches I'm sending out this
> time won't contain garbage.
> 
> Version 5 of this series responds to a suggestion made by Alexander
> Duyck, to determine the offset to the checksummed range of a packet
> using skb_network_header_len() on patch 2.  I have added his
> Reviewed-by tag to all (other) patches, and removed Bjorn's from
> patch 2.
> 
> The change required some updates to the subsequent patches, and I
> reordered some assignments in a minor way in the last patch.
> 
> I don't expect any more discussion on this series (but will respond
> if there is any).  So at this point I would really appreciate it
> if KS and/or Sean would offer a review, or at least acknowledge it.
> I presume you two are able to independently test the code as well,
> so I request that, and hope you are willing to do so.
> 
> Version 4 of this series is here:
>   
> https://lore.kernel.org/netdev/20210315133455.1576188-1-elder@linaro.org
> 
> 					-Alex
> 
> 
> Alex Elder (6):
>   net: qualcomm: rmnet: mark trailer field endianness
>   net: qualcomm: rmnet: simplify some byte order logic
>   net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
>   net: qualcomm: rmnet: use masks instead of C bit-fields
>   net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum 
> trailer
>   net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
> 
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 10 +--
>  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
>  .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 56 ++++++----------
>  include/linux/if_rmnet.h                      | 65 +++++++++----------
>  5 files changed, 64 insertions(+), 90 deletions(-)

For the series

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
