Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD11E3F7F45
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhHZAXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhHZAXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:23:47 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E07C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:23:00 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b6so2046588wrh.10
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KFGTrRCEScVGRu9bAhd1hMEqbGXFI/ZZXNtPcRgXfzM=;
        b=m11w3m/Mki1NRHPb4Q+5dQ+8M48lGEkAKbWII+ZYY8q9nrE0yBJ1x/LLxMcgOGI0RS
         TC/FndlIg2w+qJUz9alKE3A7TIMd82rVv4HvNx19+1Q3TphfpuMzfFZS7MMS3ymQ2YFQ
         U0xY4tVoBbm13GaNHxzPOGyabXLLc3GkEsjYnBHT6pLh49s1M0Z6d2rnJQNfSm9/6sOo
         dNyDKX99UD6xQjsqF0dRCBZzOxaMY5LLL5ccE30/z/bYd/NDwF1J5qbr+i2XrtuHM73f
         kN42sCRqBmCEpHv/3WS+CsvsTmIWOZbpNJMACSFSyZXteZSRR3TtTdaXLPVWr2o3yibs
         ghsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KFGTrRCEScVGRu9bAhd1hMEqbGXFI/ZZXNtPcRgXfzM=;
        b=t9+PbZudGk3ucUoTWUnp/oBGYZ5MsitFIGxnAWe8efe/YJAK3JbLWsPmItjrhqyHv9
         YuVi0AhAK1oMa9vfdLISh95uHGVm2G+hv7oayR8uWSzkIr1TgwDzxd8l9PUFhhHSjhJE
         Yh7HV3HLNaFb+NGojAhSHLLtSny9EIUxt6NJv8ZOGzqKf1UDW5v/gZbMkJnHbzQP39K+
         KMFw4tVumH1TSZBVCnZQb9V5A2eEuyv2OsIVXX7Iqp1NFdQheiOyRfogGIX6x/4jeDcW
         oPtrxc0cBjkaN6m9NF5W5PlIEZ5J5fOOFvsRq/3H2LLHK3fVeiUSld2M/TFfpE8MWaBs
         wpzw==
X-Gm-Message-State: AOAM531TZVu56fc4+3OfefuLM9zdQJXJ8mBFP4K4iKjPbibdYzCodBL3
        AbKatNlQCbWlAW0EuaFFDwM=
X-Google-Smtp-Source: ABdhPJwNAFo6yc7IsQC4iMNsNsDtgDFMVmlxEtc2pajdw0FOlm4z0AgqB3CYaX+6I+rNtEkb6QkjZg==
X-Received: by 2002:adf:f884:: with SMTP id u4mr678444wrp.411.1629937379215;
        Wed, 25 Aug 2021 17:22:59 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id q11sm1319289wrx.85.2021.08.25.17.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 17:22:58 -0700 (PDT)
Date:   Thu, 26 Aug 2021 03:22:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] bnxt: count discards due to memory
 allocation errors
Message-ID: <20210826002257.yffn4cf2dtyr23q3@skbuf>
References: <20210825231830.2748915-1-kuba@kernel.org>
 <20210825231830.2748915-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825231830.2748915-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Aug 25, 2021 at 04:18:30PM -0700, Jakub Kicinski wrote:
> Count packets dropped due to buffer or skb allocation errors.
> Report as part of rx_dropped, and per-queue in ethtool
> (retaining only the former across down/up cycles).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 14 +++++++++++++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  1 +
>  3 files changed, 15 insertions(+), 1 deletion(-)
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 25f1327aedb6..f8a28021389b 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -188,6 +188,7 @@ static const char * const bnxt_rx_sw_stats_str[] = {
>  	"rx_l4_csum_errors",
>  	"rx_resets",
>  	"rx_buf_errors",
> +	"rx_oom_discards",

'Could you consider adding "driver" stats under RTM_GETSTATS,
or a similar new structured interface over ethtool?

Looks like the statistic in question has pretty clear semantics,
and may be more broadly useful.'

https://patchwork.ozlabs.org/project/netdev/patch/20201017213611.2557565-2-vladimir.oltean@nxp.com/

>  };
>  
>  static const char * const bnxt_cmn_sw_stats_str[] = {
> -- 
> 2.31.1
> 

