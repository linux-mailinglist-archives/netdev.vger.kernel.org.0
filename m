Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BFC75F51
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 08:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfGZGw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 02:52:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfGZGw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 02:52:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7130A6053D; Fri, 26 Jul 2019 06:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564123945;
        bh=45rlvmxAk80l2YGJDp8L9VwoMC5Accf2bkvFWQ7rH2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MPo66DQnePBb9HPCqbRq0xL4Hn6M9xqdBGRDDvyWgBC3WS2/QnsH8hUIVhkhH/OOC
         +jhmf4PvUCLKq94Yfd6lZWE0NvcrpaIaa6nafL1Q7UhRUt4F/AgZLiKDdO9kv8XQ66
         c5PEF33x5QVXyeU+aehhWKn6Cxa3rP+UTUu+sCpk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AFF9B606FC;
        Fri, 26 Jul 2019 06:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564123944;
        bh=45rlvmxAk80l2YGJDp8L9VwoMC5Accf2bkvFWQ7rH2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FzKftfZ8E7sWY3QOPlc74YzWQYB/HV00IrG1WdFtk55IbVpwfHa3kMc3edl3ScdVa
         XjoO4Qkc7Ykg+3smYnlk4kIMirrrcl+GY5OS92CM1BJyCFTfyT1JZAMvcdvtA9guRZ
         W5KeMVsiOXisNNjDsgKiid1w4I6UNuD5z5m7qVSY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 26 Jul 2019 12:22:24 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/3] ath10k: Clean up regulator and clock handling
In-Reply-To: <20190725174755.23432-1-bjorn.andersson@linaro.org>
References: <20190725174755.23432-1-bjorn.andersson@linaro.org>
Message-ID: <196fa4aa63fd5135aead736396fe3f8c@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-25 23:17, Bjorn Andersson wrote:
> The first patch in this series removes the regulator_set_voltage() of a 
> fixed
> voltate, as fixed regulator constraints should be specified on a board 
> level
> and on certain boards - such as the Lenovo Yoga C630 - the voltage 
> specified
> for the 3.3V regulator is outside the given range.
> 
> The following two patches cleans up regulator and clock usage by using 
> the bulk
> API provided by the two frameworks.
> 
> Bjorn Andersson (3):
>   ath10k: snoc: skip regulator operations
>   ath10k: Use standard regulator bulk API in snoc
>   ath10k: Use standard bulk clock API in snoc
> 
>  drivers/net/wireless/ath/ath10k/snoc.c | 324 ++++---------------------
>  drivers/net/wireless/ath/ath10k/snoc.h |  26 +-
>  2 files changed, 48 insertions(+), 302 deletions(-)

Tested on 845 MTP and QCS404 platform with normal sanity and driver 
recover cases for proxy votes.

Tested-by: Govind Singh <govinds@codeaurora.org>
Reviewed-by: Govind Singh <govinds@codeaurora.org>

BR,
Govind
