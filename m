Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE361254AC6
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH0Qhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0Qhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:37:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41B2C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 09:37:34 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q9so3575245wmj.2
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 09:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oe+3UyqdCu4V3yc10MYVh2Ksgt9dcjdR3WigYWc1rHA=;
        b=BUM0QEl01GR+SAQSbR7GIDi5EZDoB6cXSDAgG/VB7Q4q9jvDxjRTuX+abdXYzWssBD
         Kmgy7JHlQ1abz3hqo2E9lmOfgB0bcLGVtSp0M9vGmY1m1RVKOCGQbQxQ+dBCFX5CzZNk
         akc6Va11B91iW+59hQ8pxIdkL1zzQyQvwr9gJcgNVlae6jsEXRprRui9ghhkkHv4op9v
         NnFicJF1Hkb6k4H0fV/VV2RSE0msaBfYSjc0nOZF9HNvTrT0Fzriw7Nte6u5zCBCqk57
         705lgSdLgvOQk14PZ7s8UKVRgZSm7GTsW36STusrAnrmnduiVtDcS0pE56OCq6Rhckwk
         Pebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Oe+3UyqdCu4V3yc10MYVh2Ksgt9dcjdR3WigYWc1rHA=;
        b=D4wDPLGUlETngyX9LK1xuOle0DKmu8Dre47sOc/xS8I+douBiDdEvp0zULOMe/YWhy
         U+B+5T/3JrSisXk5JJcwZEZQt1hidgwIBRLTDxSH0LByadSRkWKSt4f7OXvfDqNyRQ5o
         zg9AHnmAWC1ffSyvhfmn8dsgUDQ/xmAe8+kjg6kaqRXU1Zg8vYQW+RdfCr0Ur0Wsy81V
         pgKOdgmKDtSSXpAzfOyb+PZzFvW4SDyxPKhvKr4v9aok7c2C9M0O+k98XzOS97Wz3VwF
         g3wAH6wzazjYkiCgvEwprxlBnXlr6rkWA6jo4b+DrEQgFCSOHKYAfFj1BI+fJOio+sj0
         aIuA==
X-Gm-Message-State: AOAM530OnGtjsPEUib4dbfupp7Fj2f0Fnv+QVN0YVYoxCL4LFDK1ElzE
        ZpWeGdSXvaVRMtz0rVKrVzwbMg==
X-Google-Smtp-Source: ABdhPJxe7XAUpNnt5vhDFMaEIraGPFCkM03VZz0j1qivtYO3Llqv1pGimF9rSVcWC9JjBpR+BJQ6gw==
X-Received: by 2002:a1c:a746:: with SMTP id q67mr3757889wme.128.1598546253461;
        Thu, 27 Aug 2020 09:37:33 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:590d:8a36:840b:ee6c? ([2a01:e0a:410:bb00:590d:8a36:840b:ee6c])
        by smtp.gmail.com with ESMTPSA id p6sm5753036wmg.0.2020.08.27.09.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 09:37:32 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3] gtp: add notification mechanism
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        gabriel.ganne@6wind.com
References: <20200827090026.GK130874@nataraja>
 <20200827121923.7302-1-nicolas.dichtel@6wind.com>
 <20200827.080514.1573033574724120328.davem@davemloft.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d0c3b1c8-4275-6b5a-3d93-4c9ac198b1a3@6wind.com>
Date:   Thu, 27 Aug 2020 18:37:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827.080514.1573033574724120328.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/08/2020 à 17:05, David Miller a écrit :
> From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date: Thu, 27 Aug 2020 14:19:23 +0200
> 
>> Like all other network functions, let's notify gtp context on creation and
>> deletion.
>>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>
>> Acked-by: Harald Welte <laforge@gnumonks.org>
> 
> Applied, thanks.
> 
I don't see the changes here:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/log/

Some build tests? Or just a missing push? ;-)


Thank you,
Nicolas
