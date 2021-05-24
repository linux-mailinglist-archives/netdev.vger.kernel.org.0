Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4763E38F473
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhEXUgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhEXUgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:36:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BA1C061574;
        Mon, 24 May 2021 13:34:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q6so15547620pjj.2;
        Mon, 24 May 2021 13:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jaMXsgpZYs5Tjh+LVgZv457q1Xd6EWX5UO6dq/AJ44U=;
        b=CTIh/QZkBwD0Uqx2Si7DuPLzezlDpflIzYh+fJFBVUQ54UtjBkh/n7yL1qZAUNIAed
         LO7Y8IDM0QnhKIlJYk7RtczHDHSMHWgDF0l7TCuyjMM2UeHiubRhpVqNYolo2fJrWZFM
         yn40reCd29nCBIxdGkXek1z0MMjVCEQBlYG6lzAJNab1Q/zKtfOImpgNk96xjBaOWdkm
         87iK29fYEb2NoTG70Mhut4HdCR9Z4oEPhApImBJZSLodqiCva+EHUGUPbT7n3fSHsluE
         5EUOGgiGVEv2y6QQZXwWKjeqohQHyobmNyP8tj+/J2d5/DNRTlHFG1DGORXyjXj4TAPW
         wT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jaMXsgpZYs5Tjh+LVgZv457q1Xd6EWX5UO6dq/AJ44U=;
        b=LILXx1FoBarrUJ8kxlAFYvbPoEQ/8JJ1L+kA7ZorK+2UOmuOT/znXea6gcaT6xXzWG
         EltWUK85NG+IQQJn2iQGPqMpXlJSNArBIhJXuUajEl3H6Ic/+3F1+nfap9owkkFLSYlj
         kbX09e4fGXYgyNdxkSLyDxKAT/jNCMd24yy3sI7kHRa89/nElmvHR5XhuCzm/coomfk2
         49Cr40OWT01Ik2eJo2elfWqq2GWkC6+CQEZqz/42u0byFZM5Gqt2BSlZEwRu2Rf8IwQP
         M5QuqwOr65pfI7kwoZcEDbFTKtEQQXwh+oHVMTZJeMal4au4Jmr1JcdOGzXTHXVV4ji7
         tHXw==
X-Gm-Message-State: AOAM5331GKyDFDpWefGiEgvFgfe1Lwls18GN/OBFIXf+93GjTRFvdEHb
        +6vtPrwFCAEBiIxhccYvxdRZg6tnPCg=
X-Google-Smtp-Source: ABdhPJyY87JFvP+0rYq+J+eFZOWfZLOvPFXuHN8FD1+WYzuPJqsdM0PO5I4u4zUNF4aRi1ggX0bq3A==
X-Received: by 2002:a17:90b:14d7:: with SMTP id jz23mr27377456pjb.105.1621888474317;
        Mon, 24 May 2021 13:34:34 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h24sm12034227pfn.180.2021.05.24.13.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 13:34:33 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: microchip: enable phy errata workaround on
 9567
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20210524202953.70379-1-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <256512cf-24e5-ec8c-d128-25df90e6c6e6@gmail.com>
Date:   Mon, 24 May 2021 13:34:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210524202953.70379-1-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/21 1:29 PM, George McCollister wrote:
> Also enable phy errata workaround on 9567 since has the same errata as
> the 9477 according to the manufacture's documentation.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
