Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA242D069
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhJNCaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhJNCaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:30:39 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32853C061570;
        Wed, 13 Oct 2021 19:28:35 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so6291406otb.10;
        Wed, 13 Oct 2021 19:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BW30mP0T507/r7GxjN7b4u9+pvmHE2rU/MT6A6TfTO0=;
        b=omwbM+xa4r/OANttEoNCeyk1Xk1m9etesKzNwuFuNGeTpZ+tCmMdcbGbgsm6Wzabm0
         /8svdEMHZXKDE7fuJrBLgobi0bioKLtfgNaT/+tP/SvQstV9+7SXGLnzPyuXCZTeY4J1
         /DrfCf5DM41GMR4znAgOQpPH/VwOWeU3Acs8smjp5e3lVOFljGfZFO9KaR5W+WL7oJGD
         MXAd4Jwn271gpOJECTgi5q/N2EjbU25h4eJ/pFq9g2SIKNjpnXPjAm/tfpj1kW8BZ4X6
         wSJ5hx7IIIvh2a4xBORYdKxGSXow8/8F3h25SYwq1nk3WjqSZFpSRdjijw/m5+AtcXhr
         QSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BW30mP0T507/r7GxjN7b4u9+pvmHE2rU/MT6A6TfTO0=;
        b=3eUshSNRe9//ZZrS4uDG3tdJ6yA7n2nMuMxrJD87CtVTNduXe+RDpV41/TQjVvL14l
         ZPl1hG6+GpejGHHsZL6Zx8DtfaBnu47xRMC6tQLlMtqfsgkHq7IFksb77JhE4ndgBKZv
         GtcNLghKBi8lpbgpeWzz3N9of8WtBJNiM2n2HTmf7JVWSlBAyuYsSkZOBrnw5nAsyTxf
         RNKScUEKmWABQiaA12vjbzyWYxDXpyN+5//mxLGDT+uFvsVe+11X+QRIrCy0R2IZIJgH
         rTchsrYfttNYca85ToyNwCO1yIaMKmyvzN28j+ivd9QjgkPE3Zz1Xi30VLixqjJzku2f
         5sGw==
X-Gm-Message-State: AOAM532WCdXSUPv/roxDEcWCwc6bfysCv/PCumXUMI78JlD7UQVdEeOJ
        eDePRy4uici5jkoYRY5F5gw=
X-Google-Smtp-Source: ABdhPJyARNYEqrNKywLryIxdUcPJ2nIadPcUVNTDhWN7eAdkl19f0nV9/YXZdXBu00uAFLQ0WwG3XQ==
X-Received: by 2002:a9d:6f93:: with SMTP id h19mr208637otq.14.1634178514591;
        Wed, 13 Oct 2021 19:28:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c875:f7ef:73a9:7098? ([2600:1700:dfe0:49f0:c875:f7ef:73a9:7098])
        by smtp.gmail.com with ESMTPSA id a1sm302846oti.30.2021.10.13.19.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:28:34 -0700 (PDT)
Message-ID: <eeb489ad-b88e-7ca3-57d8-7ec24db6a8d7@gmail.com>
Date:   Wed, 13 Oct 2021 19:28:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next 7/7] ethernet: replace netdev->dev_addr 16bit
 writes
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, klassert@kernel.org, kda@linux-powerpc.org,
        GR-Linux-NIC-Dev@marvell.com, romieu@fr.zoreil.com,
        venza@brownhat.org, linux-parisc@vger.kernel.org
References: <20211013204435.322561-1-kuba@kernel.org>
 <20211013204435.322561-8-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211013204435.322561-8-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 1:44 PM, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> This patch takes care of drivers which cast netdev->dev_addr to
> a 16bit type, often with an explicit byte order.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: klassert@kernel.org
> CC: kda@linux-powerpc.org
> CC: GR-Linux-NIC-Dev@marvell.com
> CC: f.fainelli@gmail.com
> CC: romieu@fr.zoreil.com
> CC: venza@brownhat.org
> CC: linux-parisc@vger.kernel.org
> ---

>   drivers/net/ethernet/rdc/r6040.c             | 12 ++++++------
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
