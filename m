Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67E02F6EE9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbhANXXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbhANXXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:23:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B93923A6C;
        Thu, 14 Jan 2021 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610666575;
        bh=2Z6wWmNa2CC62nOEhM+nhjLKQF36CZbHTMeaHSytAUw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y0sEPRef6q8t+N7DXyn4nhyZH4510uyPCNnP5vi7XqblVQ8ZO7/nlrey/jcdyINpG
         gzwJ5MUYIOHFGQ9uDOH2X9zjxqkoasMYkKuY5opNTFoGpQSvj3LAcV4V3SYb46UcpE
         QmbKoI4g0DLlBhIk5ekW29mEmlQNwNjseAtoYkgOugQ9sjrgFaB5ddshn/1H9Ii7E3
         8SHR366S7wR3qX1yltQl1WPLqo8q6vPsGYwxSF1xuyTeFAGLZVN5adNyBN7EpDFDjC
         Da1vOVxiK/PjffglpOqN+BAT1m5gHri/TKGNC36W/4GEbZijjaQCul6CrVMsVLCOGJ
         ZjhfefQq8a00Q==
Message-ID: <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI interrupt updates
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jan 2021 15:22:54 -0800
In-Reply-To: <20210113171532.19248-1-elder@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 11:15 -0600, Alex Elder wrote:
> This series implements some updates for the GSI interrupt code,
> buliding on some bug fixes implemented last month.
> 
> The first two are simple changes made to improve readability and
> consistency.  The third replaces all msleep() calls with comparable
> usleep_range() calls.
> 
> The remainder make some more substantive changes to make the code
> align with recommendations from Qualcomm.  The fourth implements a
> much shorter timeout for completion GSI commands, and the fifth
> implements a longer delay between retries of the STOP channel
> command.  Finally, the last implements retries for stopping TX
> channels (in addition to RX channels).
> 
> 					-Alex
> 

A minor thing that bothers me about this series is that it looks like
it is based on magic numbers and some redefined constant values
according to some mysterious sources ;-) .. It would be nice to have
some wording in the commit messages explaining reasoning and maybe
"semi-official" sources behind the changes.

LGMT code style wise :) 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


> Alex Elder (6):
>   net: ipa: a few simple renames
>   net: ipa: introduce some interrupt helpers
>   net: ipa: use usleep_range()
>   net: ipa: change GSI command timeout
>   net: ipa: change stop channel retry delay
>   net: ipa: retry TX channel stop commands
> 
>  drivers/net/ipa/gsi.c          | 140 +++++++++++++++++++----------
> ----
>  drivers/net/ipa/ipa_endpoint.c |   4 +-
>  2 files changed, 83 insertions(+), 61 deletions(-)
> 

