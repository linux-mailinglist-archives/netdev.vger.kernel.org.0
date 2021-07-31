Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3F03DC2DB
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 05:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhGaDI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 23:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhGaDI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 23:08:58 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D89C06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 20:08:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q2so13254467plr.11
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 20:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1JZ26KqQk+o6r3TSFsiDOhOM+G9b244CRrd+fTUFRWs=;
        b=OVc6jlbUCX5yntvyKSuxpsTi44Ls6qUCF7XQsKFtdegjmSLxbESj3h40J4aiNbrLSq
         pJjW7UqWRm2USa4x9xOGLXG7CGY3ei/gRCyKxcJkKOiy/+2aaDezMpBXVJmfV6Ebh4o4
         YLHiX9lcRg455UUtHRZOqs8Bhh+9wReN6s4b9s4zZzrHJQQDQ+6xniuRY222j6IzIBfB
         cs/YHNYAL8WZ/uXaUUQStPxOWm482ZbkTVb2DroYJZ55bRozRrMtJP82UmpL9mClAcNr
         XXIlLbsnGV7CRVSZaKaufpZvabPhAfjZf0zPAJ9OyxZUKCdbIVyY5cKJalhCXcKXMAik
         q5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1JZ26KqQk+o6r3TSFsiDOhOM+G9b244CRrd+fTUFRWs=;
        b=XCYnKGlCa0r7MOh52fN7+OH1m3DUgA7CitYh0B+3JEYKMltj9qP55GwjczoOnr9Fvm
         6vYA1UoOGudD7ePtsoM/WgQZWQJKce6L8X5Jlk03gn8exfyYpOd4U9/6ZkUeZk3a9jem
         gb5vAfOE13/I5uN0WTVh2wVzifEjqjzDEjR69BW7p6nA+oCuc4Il/IfsDjZ++rHbyNjd
         9JYA+wDvFlt6f1iiLz8IicS8sFJ72OQs0bPHLNw4TXxx+s+IelwotLg9oX7bAg+jtphp
         /sROpOy4ZIs6jW9sxNPzxtLitmjoUU7/dvBkoAm8PyDa+mDPTsIpqld4apzKjPoiP2L4
         u9lQ==
X-Gm-Message-State: AOAM5308fVsnOSU6sje8DuwPoiROPZcZlvWt2T1/iAJjoUVz3UGHuaqd
        wYoRbCV6jljcgstTl04YVjc=
X-Google-Smtp-Source: ABdhPJzwAdyqG+R/fCsUBgA/gyoKtfnR+Xp9raejel1pv26DrYEQRaPmbOOMApgb+SEQ2BY0Ag8sgw==
X-Received: by 2002:a63:5f87:: with SMTP id t129mr2822273pgb.85.1627700932070;
        Fri, 30 Jul 2021 20:08:52 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l10sm3488371pjg.11.2021.07.30.20.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 20:08:51 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: drop paranoid checks in
 .get_tag_protocol()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc8e24d2-9fed-872f-4f0a-92a6892dfd5e@gmail.com>
Date:   Fri, 30 Jul 2021 20:08:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2021 3:57 PM, Vladimir Oltean wrote:
> It is desirable to reduce the surface of DSA_TAG_PROTO_NONE as much as
> we can, because we now have options for switches without hardware
> support for DSA tagging, and the occurrence in the mt7530 driver is in
> fact quite gratuitout and easy to remove. Since ds->ops->get_tag_protocol()
> is only called for CPU ports, the checks for a CPU port in
> mtk_get_tag_protocol() are redundant and can be removed.

The point of the check was in case the designated CPU port from device 
tree/platform data would not match what the Mediatek driver supports, 
similar to what b53 does in the same vein. I am fine with removing that 
check for mt7530 as it does not look like there is an use case where the 
CPU port is not actually MT7530_CPU_PORT.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
