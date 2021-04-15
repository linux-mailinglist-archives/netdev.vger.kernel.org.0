Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5F436022C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhDOGKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhDOGKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:10:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C06C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:09:39 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id y20-20020a1c4b140000b029011f294095d3so13879333wma.3
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FtyXHQ/bk62IgwhZ+SgI7kcl217Zf9K8vV67N9Vs5Kk=;
        b=CLEAKJ7GqOc/8zuswOix4EAKXRoWWpGg1FferOF0dV5GV4aNhf0a9W7aRCrkSETCGw
         fhRhgr+xsM+jt0F3Mj3Ywd+9UxUj+/DQ6XvRILN39Hpqj6EK7VhVZYo8zVroHiEdnkye
         ECWWt/zTkENNrviPhCszlRWgoWztwFJjbE/leKtynEMDOvJjc3EG5dPpEBS34SmZc4fv
         zyiRtsDK/HCxmcbu1iJK6RTRuN0g8igcKaN4+9xNHZ355wHEg515ueMMiiVSd+8lMLRX
         h8mxCqRcsMROplO5rrZPEg09RX1t9CI3wbmQJtVlHhkfPsYIKMcEr+ZngsFBxm2nEbv7
         OCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FtyXHQ/bk62IgwhZ+SgI7kcl217Zf9K8vV67N9Vs5Kk=;
        b=gNn1mXY5+sQfVvim5NcIS0mKcKH+YRB0TRyHaywgsBmnD0U+xdrWzXFZKsoIEAL7eA
         O5XVtuOYmE4+Iufe4VqSO+3rjUmm7zoVwhYvE0C5A+IYiInokjc3JU7BbepcA4rI89ZJ
         7npU4kFSJqHuS0EeQZeJAsz3jUOOKHUjEuaVSHdHdWpwSVLF+hEWG8fGmi4H8JZR2E0V
         DAaEWJ4bVAaGlD9GjWWeKqZglBV/KzH6e76mH5pXl3V4mFc4dvO0zbwOR3TOHrp8sJcW
         y4rnqXDIBh9lFyeS9NNdMskuoBGDamaRJlrWi7jqbkGj/z3kYj3Nfi8sLZV2pkAFbZWq
         w5Ew==
X-Gm-Message-State: AOAM533pBKZAHGZMZ3brT10aDgWz6Y85ZC0Q3xKZNIS/LzobkCVa0jv/
        420Htgn+itpYVY6ScxfmPc0zYXRmC1fe7g==
X-Google-Smtp-Source: ABdhPJyGDNAn6BC5Ws3ANavzX0m26lKXvjfNQdRIoJp13+h68JTwsyJWDoPqHajcUI7hZD+fGrjSog==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr1400564wmg.40.1618466977816;
        Wed, 14 Apr 2021 23:09:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:a8a1:99e1:b713:6999? (p200300ea8f384600a8a199e1b7136999.dip0.t-ipconnect.de. [2003:ea:8f38:4600:a8a1:99e1:b713:6999])
        by smtp.googlemail.com with ESMTPSA id v2sm1516138wrr.26.2021.04.14.23.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 23:09:37 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0e0f42d5-d67e-52bb-20d2-d35c0866338a@gmail.com>
 <20210414161211.2b897c69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] r8169: add support for pause ethtool ops
Message-ID: <b4a5ed86-c51e-f370-ba79-35c9c127e85b@gmail.com>
Date:   Thu, 15 Apr 2021 08:09:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414161211.2b897c69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2021 01:12, Jakub Kicinski wrote:
> On Wed, 14 Apr 2021 08:23:15 +0200 Heiner Kallweit wrote:
>> This adds support for the [g|s]et_pauseparam ethtool ops. It considers
>> that the chip doesn't support pause frame use in jumbo mode.
> 
> what happens if the MTU is changed afterwards?
> 

This patch is complemented by 453a77894efa ("r8169: don't advertise pause
in jumbo mode") that went via net. Changing MTU triggers rtl_jumbo_config()
that aligns the pause parameters with the new MTU.
