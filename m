Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257B623FBF0
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 02:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHIA3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 20:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgHIA3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 20:29:50 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B8EC061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 17:29:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 74so3159726pfx.13
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 17:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=43crPNxARtv+xw4IVd9zFfM18QY3CsM/wAh7DxWw0s8=;
        b=JhQKFj0WJl2JIkwXPiuWECOMl0e2/aGoW7tKRev2bi9Odm21BYr5bnM63pw3Oh0P/R
         fQ9tT1ea6Euhh67avcWNYLivdzkWwf4YCI1HFvShINacct7zNwB8UPRlvr5lhQvSvS1G
         x7LbXOVqQkqX128VGrLBH+lbYcp2Y1Yq/oSusZRQerPnPmDn3xZiD2Cgx4MxQ7FOX2p4
         CVOV/BdZedU0rE+90Ftk0ImspChcbqal3wiSyJZ+yCtyssQsvEqKSrGIa1QKG7iPbF8I
         Kuz3LfzM7ccXUWHevP5efo02sY7vt8L3lEBtEW6qJOpTEqZh87gnOHY+EmAwGoX8616o
         0Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=43crPNxARtv+xw4IVd9zFfM18QY3CsM/wAh7DxWw0s8=;
        b=Eac1X3k1ge5/EB5/8eOQqBXdSHMNH9ZxICICaYKXlgxF6efWcgWcewH5LXc+Nn1Ems
         1lSxVuDwtUyEAD/4o7Qg9yW0/KNCYaXq0f3MFBEQ/aP+6rwWbUH1whDm7PYxVnN6MuGQ
         CUjsObeEzURGk7yB2sxP0JeUyxb2icGmwlKwETn6j/f6WXUu8W+XNuncHrOjH0fCzGp6
         ASSlkIfQuqceP3iO9pqWuCdNNVsyCKqQHm32zpP85d8wqnqQDJE7w3a7hz0yRU+9H6/6
         lUhBtxGT+0axYdAKhNl3Flul9kBnKzccVXFMpkZP/j3bB9ZFtU0SjtNQ1g5WBVf4+eu+
         ZCVw==
X-Gm-Message-State: AOAM531cTvCGcgwynJnf3sPcAvpg/xenQMoHkaa8j1z9yJ1SkyMlySN/
        squXt9TWFqxji8Imbqb2x0tDtktP
X-Google-Smtp-Source: ABdhPJwoMcwsyJzEp9MHSfP2kFuwn1p2mCowPN4sOPzV2CCihg3LzbOX76Anr/CeGYWxyvsfLtr1/w==
X-Received: by 2002:aa7:960f:: with SMTP id q15mr20789597pfg.79.1596932989691;
        Sat, 08 Aug 2020 17:29:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y12sm9498013pgi.75.2020.08.08.17.29.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 08 Aug 2020 17:29:49 -0700 (PDT)
Date:   Sat, 8 Aug 2020 17:29:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-net-drivers@solarflare.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 03/11] sfc_ef100: read Design Parameters at
 probe time
Message-ID: <20200809002947.GA92634@roeck-us.net>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
 <827807a1-c4d6-d7de-7e9c-939d927d66cc@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <827807a1-c4d6-d7de-7e9c-939d927d66cc@solarflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 09:33:20PM +0100, Edward Cree wrote:
> Several parts of the EF100 architecture are parameterised (to allow
>  varying capabilities on FPGAs according to resource constraints), and
>  these parameters are exposed to the driver through a TLV-encoded
>  region of the BAR.
> For the most part we either don't care about these values at all or
>  just need to sanity-check them against the driver's assumptions, but
>  there are a number of TSO limits which we record so that we will be
>  able to check against them in the TX path when handling GSO skbs.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/ef100_nic.c | 216 +++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_nic.h |   4 +
>  2 files changed, 220 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index c2bec2bdbc1f..9b5e4b42fe51 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c

[ ... ]

> +		if (EFX_MIN_DMAQ_SIZE % reader->value) {

This is a 64-bit operation (value is 64 bit). Result on 32-bit builds:

ERROR: modpost: "__umoddi3" [drivers/net/ethernet/sfc/sfc.ko] undefined!

Guenter
