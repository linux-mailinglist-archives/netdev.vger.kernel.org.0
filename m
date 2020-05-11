Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1731CE905
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgEKXTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKXTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:19:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989FEC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:19:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so8492088pjd.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S29KATHTxUWmSA7tfWs0BRVRkQ8uFZd0Fn2wGoLHaqk=;
        b=ZHvnmFQQCBHZu+zLbb0YdXZMfgdtr3mpME0J56J3a4pcm0J2ThTizdvKCwqjZXqEHp
         8B595dxDuLz+zCp7B1htU6PCiyWtF63YnQRnswKHxRZj5FeRwy+DzhpYY094kam02mwl
         4Evwrp4YkgLo/xa0RX2zZqpeQ3lL2pE81PXcnaZ3A7hUnN9eSEQJgT/Gx3Rck48RhPoY
         e7ooE3ylgNTQA9QIh9sHiI3A+NKylDqQQvafLVRiFcfUruAegSVyA83v1jhKnYUaxWHF
         L17UtlU1f1lVNRFDBe0fh63YMz1zCOe9kI10EpJu0t3u1q+OqKCiNvAFpfMV/u2m374P
         tg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S29KATHTxUWmSA7tfWs0BRVRkQ8uFZd0Fn2wGoLHaqk=;
        b=DmT+BtB6ox5oDX8/9vgmWuVNfMjfk9dGl/nRFbMGX5sr4D35saxqJtQSrJPWKtJlbo
         bfBk7h1lJ5RCinvnBL+4NxDO0sKquTuoQ8NjLUPBIQ+cEGkF+V7P4YwToy2CylWOoBCC
         eOd98tukYY673qpbtGadpiQrIu7ak4pjxbOv2WGUjrHQO77UD7ij5nlCFWHTJNE86tlP
         6dozrPjBydnCjYuvjw9QEXlpmik2o+gjA3W/yBhxQLr2HtxAzBZNXpIChM9R7FYm5Msu
         UGDt2V162aqvxyb8Q/O1MRt814hP/SsCLwA8MMByU6f2zlj7JxWQVozpS5DTVpELTVe3
         2mKQ==
X-Gm-Message-State: AGi0PuZ3DBMlZDpiYNMkT0mtrB6x+INpWfo/mSYck0/QSFe0r25LQGCB
        6WYJp/vcEt37kG0gbMrW4VCLJHzv
X-Google-Smtp-Source: APiQypIsDN0Q0l7lyJks1Zuo8NP7VfRFP0NeOaUm3PdykVyH0dRhO3eJf4/iT2YeiwEgqylO/XRWcg==
X-Received: by 2002:a17:90a:f2ca:: with SMTP id gt10mr26307599pjb.160.1589239162656;
        Mon, 11 May 2020 16:19:22 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q16sm127434pgm.91.2020.05.11.16.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 16:19:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: dsa: allow drivers to request
 promiscuous mode on master
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20200511202046.20515-1-olteanv@gmail.com>
 <20200511202046.20515-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8246ccc4-6ddf-be3c-6391-9a6a75e6c8a8@gmail.com>
Date:   Mon, 11 May 2020 16:19:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511202046.20515-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently DSA assumes that taggers don't mess with the destination MAC
> address of the frames on RX. That is not always the case. Some DSA
> headers are placed before the Ethernet header (ocelot), and others
> simply mangle random bytes from the destination MAC address (sja1105
> with its incl_srcpt option).
> 
> Currently the DSA master goes to promiscuous mode automatically when the
> slave devices go too (such as when enslaved to a bridge), but in
> standalone mode this is a problem that needs to be dealt with.
> 
> So give drivers the possibility to signal that their tagging protocol
> will get randomly dropped otherwise, and let DSA deal with fixing that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
