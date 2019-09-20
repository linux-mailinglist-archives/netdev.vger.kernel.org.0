Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77276B88F0
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394612AbfITBc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:32:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39148 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391404AbfITBc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 21:32:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id n7so6792755qtb.6
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 18:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4WJMMHDuZxH7H+MD/oT0vES1nWQCHy0CADTJt4JAwSY=;
        b=Nsd2d5oy3zJZ6+4K0fDPrZFEeWRHQCPNIL7xJqrVH5mwFhUoaCE5294BuSftfWTEfW
         FoneG6mhBPB7KrzuKN8pCBZTI9W/vsxR+BgBEGX54AXT27G103KuwXW4il+9makgIXjj
         3xwz5f6iDxN0l2rKNaRxmgLJYgfqAp31oqT7aI32smXSHEhZ1ZXD24s/BkwysXbDvsTq
         wCWzzEehWDoScsgYAlTxX+bC5O9qEn8NxQnCZxcfwaqgcgPFop4SVJxwHV6Gx2jN0XVZ
         0niXrJkhkCeZu/y14Dl0gKMt1i0wxBrVDKa5vCdHqbnMTNHn/mmf92xaRUXCr9NmwnmV
         QNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4WJMMHDuZxH7H+MD/oT0vES1nWQCHy0CADTJt4JAwSY=;
        b=dgkSHNYNuwplPFR6Hdxbvhz8ut0v4wNxnxpzmWm4GKcotWh3YZmyW0j4hwgeYQugod
         +2r57+dokcm/P0N6HPiGzynRdN/oZFy6cp5K1U9exiF7SAPeafmGnFXiGrTNcKgCYJhA
         58sDT9f78xs0tXlEb9wjimMHQq7qkXEw8L9zKbSsJ64w0GLYKQamS4YMr4vh/N8aVQwh
         77MQoxSWrsvrhiULe72ti9LVdzJhjzOOS2O7J7u7mDc0wipiDBpUcJ12jxmUrWOu88h8
         vTgLs3F1jjyrTxqfms72U+TrRzvyguXZVCu/lu1OEbcA4EvFBZhuwkW65UF7cgbJc+1u
         WslQ==
X-Gm-Message-State: APjAAAW7QcCsydk6hvi8kpAdF8xTCiVonKWEd/y0rikwwcXYAl9v4qnu
        C8laUXPjbHLHRPm+kKiekDFS+Q==
X-Google-Smtp-Source: APXvYqzdTUjTpFbUoVoc+ebm0vlKwxHAf0leKDBwPoI+8ipofZyrSm/CRN202t6ONi2mShSkv3jh9w==
X-Received: by 2002:a0c:946f:: with SMTP id i44mr10787876qvi.133.1568943175743;
        Thu, 19 Sep 2019 18:32:55 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 54sm227866qts.75.2019.09.19.18.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 18:32:55 -0700 (PDT)
Date:   Thu, 19 Sep 2019 18:32:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vijay Khemka <vijaykhemka@fb.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        <joel@jms.id.au>, <linux-aspeed@lists.ozlabs.org>, <sdasari@fb.com>
Subject: Re: [PATCH] net/ncsi: Disable global multicast filter
Message-ID: <20190919183252.5cb041b2@cakuba.netronome.com>
In-Reply-To: <20190912190451.2362220-1-vijaykhemka@fb.com>
References: <20190912190451.2362220-1-vijaykhemka@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 12:04:50 -0700, Vijay Khemka wrote:
> Disabling multicast filtering from NCSI if it is supported. As it
> should not filter any multicast packets. In current code, multicast
> filter is enabled and with an exception of optional field supported
> by device are disabled filtering.
> 
> Mainly I see if goal is to disable filtering for IPV6 packets then let
> it disabled for every other types as well. As we are seeing issues with
> LLDP not working with this enabled filtering. And there are other issues
> with IPV6.
> 
> By Disabling this multicast completely, it is working for both IPV6 as
> well as LLDP.
> 
> Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>

> @@ -1033,23 +1030,23 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
>  		} else if (nd->state == ncsi_dev_state_config_ebf) {
>  			nca.type = NCSI_PKT_CMD_EBF;
>  			nca.dwords[0] = nc->caps[NCSI_CAP_BC].cap;
> -			if (ncsi_channel_is_tx(ndp, nc))
> +			/* if multicast global filtering is supported then
> +			 * disable it so that all multicast packet will be
> +			 * forwarded to management controller
> +			 */
> +			if (nc->caps[NCSI_CAP_GENERIC].cap &
> +			     NCSI_CAP_GENERIC_MC)

Applied, looks like an unnecessary space sneaked in here, I removed it.
