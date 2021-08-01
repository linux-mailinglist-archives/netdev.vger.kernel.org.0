Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310F13DCB33
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhHAKfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhHAKfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:35:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11432C06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 03:35:33 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u15so8665637wmj.1
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3PYkNkvsqsb8yO6kdKoH/De6spp/mrAfPl1YFQlB2bA=;
        b=oxTsHCplaLjK3ResDy4YfeUA5+qyCEHPij33tgmcx63EKQQHOyAAs9w8sIdLSUrX0q
         e0oWftbuF4s23fzKpHUUkDKAQENJ5XbsgPwaUxtXBHY2UYA4l5qjfg2SuXmhbR7xiM5Y
         exuW9Dx+6sJMHeux8d2Tp9H+7UzzUWrCAMNMDNk7YGIjt3piu/JU8lqNMJ40eXwj2gV9
         ccjcYZbe4fWX70R0KXSNvtROCq2NPazSUlRRhpsF2ypFFmzAAW9ad+viZrpvv6bXH0rr
         PAmRjE7hpVS6K3aor4+LI8qZHqg2fSC9sW1Nr6bDaBI1abc5LCqG7lhcReSG6f26choN
         ZhYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3PYkNkvsqsb8yO6kdKoH/De6spp/mrAfPl1YFQlB2bA=;
        b=bhTfBdFdlicsMmBaOjY2SkvdFij9NCFUu0d5jeRfVhQvv25Rpbde52ulBjjkNROLIC
         NoNI7DInpRosvgfpsH2zY2GvZqo6tyEnyVa3oE+GOny3CR9rbTy3m3aioU7PU+dUVhop
         gyxbEGnZQbt8xIZNzbWkG1Ypmp4uLwtFLEOEaMRa/VEe9H6IQUyZCG64gyxRSa68+3Fv
         ol6PZ9DG+MB7qLPPcdjxnf5KFEIxzdeCnU0PXHgzRaEkRTTSuAARPrBHibTWwfubbnTi
         GeOC2H8cx3leIiIlsOxrdpl59TGxL/AwLVt/rNjekQbebhEmCBFKwvTrNuYzaY773z0s
         3MSg==
X-Gm-Message-State: AOAM531KCPv/6kE/Y91ttKmv65kWetUyvoOGE8Bvte2lHeV7T1dAkBd1
        PEw/LPdzEIEWS2mSF4u8sCq5snOBVwWXmg==
X-Google-Smtp-Source: ABdhPJz7p9XaRgj+laGPLCZeZQhJHAch9+/1csjykB2UlplqcxPlnQXvc+yYkI7u5HUjHpkQISr0qQ==
X-Received: by 2002:a05:600c:1906:: with SMTP id j6mr11436096wmq.108.1627814131402;
        Sun, 01 Aug 2021 03:35:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id b15sm7814154wrx.73.2021.08.01.03.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 03:35:31 -0700 (PDT)
Subject: Re: [net,v7] net: stmmac: fix 'ethtool -P' return -EBUSY
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hao Chen <chenhaoa@uniontech.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210731050928.32242-1-chenhaoa@uniontech.com>
 <8d1b5896-da9f-954f-6d43-061b75863961@gmail.com>
 <20210731092309.487bc793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e22fed83-a4fe-52a9-7ab8-e3033b1b8142@gmail.com>
Date:   Sun, 1 Aug 2021 12:22:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210731092309.487bc793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.07.2021 18:23, Jakub Kicinski wrote:
> On Sat, 31 Jul 2021 11:35:58 +0200 Heiner Kallweit wrote:
>> If there's an agreement that this makes sense in general then we may add
>> this to core code, by e.g. runtime-resuming netdev->dev.parent (and maybe
>> netdev->dev if netdev has no parent).
> 
> Sounds very tempting to me.
> 
I'll submit a proposal.
