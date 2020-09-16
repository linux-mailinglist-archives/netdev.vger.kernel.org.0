Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67B526CF30
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgIPW7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIPW7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:59:16 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C642C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:59:16 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x18so55579pll.6
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vSVidPoWsHTaL3++CNt2hGN6ubsxTuUK5PKF8pad3EM=;
        b=prlq5cpaDgbPv0WvfjafiepOoK001zAy4o4Y3p/LZrrNGkDgrFPMtG3TBStN5bIOqf
         KWTh6baD7k2MXwnQlTjitzyoxTwXYJ/bTkc2+RjcRYDd7vitQxGrReUmD9QIe2SCdx//
         k8zFmkes2eExZYpOX2yW2D7SbVfhJXVFEizX5rgH0EV0W5NdG9khr0+HNaOJzT7BxZ8T
         iUJTJMyFlISozk5zCMGKL3GhgdxgUpc6ufE6GtwTGCQyHsoT5ipqCX5JNBHJhYzQY/ht
         TbCe5honU1blrFmqJ9ekXvNNCkRUSNjL6JTi7kD2w2YsIuy5unwDjCAYwBVCx48DKpvu
         KrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vSVidPoWsHTaL3++CNt2hGN6ubsxTuUK5PKF8pad3EM=;
        b=YIvpQ+DPqmpDk6J0btvj/DAjJ1qCULoh4C0MfRlDBQKRzc66uNRkxK2qqzTMk+rg6M
         q/WrRu5khFepvYX+z4IljYY0MLLrbu0lyvs8G7gC8DJ7jyrAkx8Sc4Dax0ZxzKM8f5oi
         wGQ3g4faUAFDg21LYssaNM29PEzSR2owtkNMHzlgsIv3hUwPUvC7HuzRCVMyV1ZKrvp7
         8PiT0fPt8iXL3KJZuhe9BADXg21pv4aDfGmSLkyYU4CdWXHjhCUf6hnK5ZkL6kgtKwBW
         wS3luIeDPyoJGmLzoxtWXvrk8CsgcAremZDBTwS07s09L1+r2zcX1usYI07gbnctEP1H
         IZAA==
X-Gm-Message-State: AOAM531VMNKhnwuPP1Jp2MXI3h0hSIz0SQdnjZkcoMptiCen+1sR5of8
        krch+AqTCZ06BEkU23XjChmOO8wfitfBRg==
X-Google-Smtp-Source: ABdhPJzzCGy8hV9/DGLfcXwL9QALBZcJsmLIbrBVoT3tFNlaGpKcbqqgrblRBn60R2ia7MGIwQy6Gw==
X-Received: by 2002:a17:902:784d:b029:d1:e7cf:83e6 with SMTP id e13-20020a170902784db02900d1e7cf83e6mr6815429pln.63.1600297155043;
        Wed, 16 Sep 2020 15:59:15 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b203sm18278191pfb.205.2020.09.16.15.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 15:59:14 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, kuba@kernel.org,
        davem@davemloft.net
References: <20200916204415.1831417-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ecb04eba-dd43-4f46-0f19-8c7ae0abb04a@gmail.com>
Date:   Wed, 16 Sep 2020 15:59:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200916204415.1831417-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/2020 1:44 PM, Florian Fainelli wrote:
> Hi all,
> 
> This patch series is intended to address the very specific case of the
> Broadcom STB internal Gigabit PHY devices that require both a dummy read
> because of a hardware issue with their MDIO interface. We also need to
> turn on their internal digital PHY otherwise they will not be responding
> to any MDIO read or write. If they do not respond we would not be able
> to identify their OUI and associate them with an appropriate PHY driver.

Scratch this, looks like we can solve this entirely and in a better way 
using the Ethernet PHY driver only and using the appropriate compatible 
string for Ethernet PHYs in the form of "ethernet-phyidAAAA.BBBB".

Please discard this for now.
-- 
Florian
