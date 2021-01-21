Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7417B2FF06A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbhAUQdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732729AbhAUQdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:33:20 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747CC06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:32:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id b5so2345096wrr.10
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+szwTA5G5vkMl7YJyc2szpaFu+bCxb3hBATz7epH70=;
        b=Rm/xU1dp29hLjENfrzG4oHG8uqwT3FpE47SifkSjLmyJHLU0Q/dNJPloZB3+9d9MFO
         TEvLiVWkFOpgI/bDpgnYegI9K1uOpTrJNkX1fW0auOZJGHxChOumdZbGES1U6bwBplcp
         8XvPgjHnqou3C4ONtjQJkRi0d6u+8Hr/xXygRL1Ek2949Q2RiW2Gr0LlLqFlLJYxg4k2
         ZhCJe+UuPZia95Kcxc9KlUJg8tue29BcojewJJqurRDuNhysXDvprZM+D6oczrvhlDBO
         SqOriqKvHm7GPQBZKANhnOohsj7nXOoCcAM4FsWYiiRTMqPAHXdvTJpau3Q5yFD7dirh
         RY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+szwTA5G5vkMl7YJyc2szpaFu+bCxb3hBATz7epH70=;
        b=W3Ibq7mFh2fN4sb6X60dTV5ecFXBcc1DnkA+EFA/QsINEyooIOkl1hBtuWZama2l1H
         LPZa3lRhxc/f11+ELHL4l+Mok6P8KIMLeItNELlLuBRL/aIKfR5ThRAhWVC7qIHvhh9h
         26M3XM6susjKoxEfnGf2GX8L6GfuYmF2unwAvJnnHfR+inOoI7FeIWS+g4Lq8Ov55aWL
         eeZkVZcK+LR6qcyr+zdZdeiSwykltmRGxMtO6PsdYrsHg4MKge/ux4WCR8LXynGRoJ65
         RQZNVYckvbig8VCb1uGMx8DP5mo7p7WvaSuILtLS+Qcojvb/4rlUB8/+S1WsCqTOqlcQ
         5pkA==
X-Gm-Message-State: AOAM531swVOrKELHB/R7vVqEucTBJi1wBPAbhWGJq0lgRDvcoVp8PR7N
        5pWTsYzK8Nl/vQ66IcBdVGs=
X-Google-Smtp-Source: ABdhPJyoBXO3yzaSoQJfrWEhiGjwi4T6/qTEpdhJyXtPHATZhnAMMg+kQX0lAalBDTxPYRnZTbX6zw==
X-Received: by 2002:a5d:4b44:: with SMTP id w4mr259751wrs.155.1611246758387;
        Thu, 21 Jan 2021 08:32:38 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id s13sm9040779wra.53.2021.01.21.08.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 08:32:37 -0800 (PST)
Subject: Re: Observed increased rate of non-linear UDP skb on 5.10 sfc driver
To:     Mark Pashmfouroush <mpashmfouroush@cloudflare.com>,
        netdev@vger.kernel.org
Cc:     habetsm.xilinx@gmail.com, lmb@cloudflare.com
References: <b418fa92-fa1e-b53c-ce19-8e02b05e68f0@cloudflare.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <b2227f5d-5d87-57a6-d01a-4ee078617252@gmail.com>
Date:   Thu, 21 Jan 2021 16:32:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <b418fa92-fa1e-b53c-ce19-8e02b05e68f0@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2021 13:04, Mark Pashmfouroush wrote:
> My question is, what can cause a fragmented/non-linear UDP skb to be> allocated by the sfc driver, and why has this frequency increased since
> transitioning to the in-tree driver?
By default sfc doesn't RX things as linear; we get one or more RX buffers
 from the hardware and then we attach them as frags to an skb; see
 efx_rx_mk_skb().  We then pull 'hdr_len' bytes from the first frag into
 the linear area; if the total packet length happens to be <= hdr_len then
 the resulting skb will be linear.
hdr_len comes from the caller, efx_rx_deliver().  In-tree we pass
 EFX_SKB_HEADERS, #defined as 128; out-of-tree it's a module parameter
 'rx_copybreak' (internally rx_cb_size) which defaults to 192.  That's
 probably what's causing your difference: some of your packets are between
 128 and 192 bytes in length.
You could verify this theory by seeing what happens if you set rx_copybreak
 to 128 on the out-of-tree driver; you should get the same behaviour as
 with in-tree.

-ed
