Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EF93CEDCD
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386893AbhGSTmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384296AbhGSS10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 14:27:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE8AC0613DB;
        Mon, 19 Jul 2021 11:57:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so142826pju.4;
        Mon, 19 Jul 2021 12:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YtTiAwHF5vIY0ChH0MGNNiiSvFI3fYT0+jWxvH0yTvw=;
        b=Z2K3wl6UcSwBX5kgUs9MOGevKI7SmlEzt+VNI0P4R3v6pwL936ujLnJN6p4E7SZzIm
         rvHEjenJWcRVGbKoV6ERxH42EYHl7q3Lf57Py7CSFXfqlOi4T1Lk4O00a6jeBUbV5NSw
         YfqgDa08u3PzarHVpPI1BlY2LJVDMv9AzNInkbibrK62xsM8Pf523ReMRImAb8hWmcX7
         N46eRsjDJP3d0g0Zn155zyTCK/WIH7kh8xStYWKntiXxNkIkosDiFHpBgB3QXY0eUpN7
         Ias99RO5RSaHN+tRRcxnTEeW1CwNYwNrHOr32cntR0bNP45IDA5woPzDGjuUSJkPz+Ov
         AI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YtTiAwHF5vIY0ChH0MGNNiiSvFI3fYT0+jWxvH0yTvw=;
        b=bZF2sIzCgXDMgXtuAplbcwgrcA0YgAOvaeiCPvLgyO0/JeOSraEBmRHsNVXbaXj69y
         7Cn3LBj4hkrBqh5UGFGw3udlvqXzVtLDxsc2EXLSwIDCxnhrrV8aVYnKsw6fq5/KABST
         aGOvkVDOcSA2PTY8nQlk9O8+ZjxBrseM2aIj3TJza4e1Utah2wKUdkaeqXnZVI+q39W4
         w/6mNUkl1LHnhtVImRp1Y44VNZAFvaIF3MnUM8gz92n2RocCspNqbhQsSFxsTkK8g1lo
         zgUEIVlpUu3SVhJC0cfnz4ufpW4Hp9NvhdIyZk0doDOvu110uUUXr6Xm1XhYskDUPf3R
         4TnQ==
X-Gm-Message-State: AOAM533gBWqYLIe+pgeVjQxiKDB/hDk74LS5TuGqIgrMXLlFFP6hqpKH
        V2z8mfadfaOq3ZSBuIz4OyIHQ649Yo49Ag==
X-Google-Smtp-Source: ABdhPJwXwngD/gR/VFbyDXrcCqOXfrfxj5Z7UlprUQ8BagN95RsWB3j5W0DO9dYNxH/QZUXlQlNtyg==
X-Received: by 2002:a17:90b:338d:: with SMTP id ke13mr31762321pjb.151.1626721684950;
        Mon, 19 Jul 2021 12:08:04 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n5sm20878290pfv.29.2021.07.19.12.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 12:08:04 -0700 (PDT)
Subject: Re: [PATCH net] mt7530 mt7530_fdb_write only set ivl bit vid larger
 than 1
To:     ericwouds@gmail.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210719182359.5262-1-ericwouds@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <685001c0-2dfb-686a-126e-d6b2854d372d@gmail.com>
Date:   Mon, 19 Jul 2021 12:08:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719182359.5262-1-ericwouds@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/21 11:23 AM, ericwouds@gmail.com wrote:
> From: Eric Woudstra <ericwouds@gmail.com>
> 
> Fixes my earlier patch which broke vlan unaware bridges.
> 
> The IVL bit now only gets set for vid's larger than 1.
> 
> Fixes: 11d8d98cbeef ("mt7530 fix mt7530_fdb_write vid missing ivl bit")
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
