Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB74434126
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 00:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhJSWFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 18:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhJSWFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 18:05:14 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEE8C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 15:03:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id v8so1153032pfu.11
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 15:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mbku3Tu3eaMUj6nt3PP1KPctVfxFC5AtCqj70/hPjk8=;
        b=OC+/cPPPbDcWnnsL//qHWK8OdJML0Ky1jgKrZg3bkO0q+UriOpN6/AuSFMaLyiGqxv
         AK4veTWkS8wdHIx1w016eJcBe1gDiWAuQR8KWEBieFaGKTqDBMjNWdOSJzpmHVjk6pp9
         9+0LpxOts+c+Z+X+Fe0t0ifNtF5Yez6S17bDcrKGwfCnxSGZNjOf3yfe1brfP1+zmk/C
         eYApQbMnu5aUBj6rDZGwtrx4foOKIj/0Rj1E6iCvJ1bV7G82pYStvStZU1rcNDQt1mVH
         guaQjolTOCSL5qbSIFXKs+BTXhp+AZ3rAWfdw0YP3eE0+uT0YvLCF+HOIuc+9jlT/AX2
         jl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mbku3Tu3eaMUj6nt3PP1KPctVfxFC5AtCqj70/hPjk8=;
        b=R+OB4YCwzyeKxRCyXOTJov+60ehCG81xxQRQJtTRBElh5RRcn3cqvzWUuYbSR1AddA
         rR2fbOX3/k6yofzz1tpbTy7w5dubKfcLqQoYvzgz1CnfJdnHiaaY99VUSVWHENjlsXin
         TevyKP3j2oSoo1oNF3XorhBSSY+kQgwLDSEFYse4+1UA+GagLleMEg3krNYxiMNOjFxV
         /VlH0mWwXAdkug/CLkCTVPmbxQKyVgoId4rFFFDYk4uh4MGDl1loWo8N32WlghHPFVAS
         AMJ+hKosC/fAyqxtnaM0Hwkt1537Y0nXbGekAJLOfjFrS+7nD9WRe4dC/tDfvfAKwQxR
         FUnQ==
X-Gm-Message-State: AOAM5303iamb7dMMgsN6K4xe5ITL8FunqW48pRC6KL39sKTpkoS412Gu
        jtx8t8UGqSIm4dsZp7W6rJ8=
X-Google-Smtp-Source: ABdhPJzv6JYE7C5psS9dr47rTobgw4LPpE1rDA26tlx9+7JiQ+VCtJQClAbJD8+J2ybz8puOq8lA2w==
X-Received: by 2002:a63:e041:: with SMTP id n1mr31117161pgj.211.1634680980364;
        Tue, 19 Oct 2021 15:03:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f33sm3594895pjk.42.2021.10.19.15.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 15:02:59 -0700 (PDT)
Subject: Re: [PATCH net-next 07/12] ethernet: bcmgenet: use eth_hw_addr_set()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
References: <20211015221652.827253-1-kuba@kernel.org>
 <20211015221652.827253-8-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d0463cbc-58f5-a5f0-37b3-686d63dcc8c6@gmail.com>
Date:   Tue, 19 Oct 2021 15:02:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211015221652.827253-8-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 3:16 PM, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Read the address into an array on the stack, then call
> eth_hw_addr_set().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
