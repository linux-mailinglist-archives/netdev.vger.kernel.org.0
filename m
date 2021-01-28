Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A49306979
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhA1BHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhA1BEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:04:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA447C06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:03:27 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q2so2364777plk.4
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eVdiqguGjzF23UdG16xDPKaVQbaWflnNiWUyO8WNtc8=;
        b=GXAFD8EjM7E6LSIHeUjI5ykzhSqB6sfpzMi2pnywhqILVDWKWCzMQfvK14hCWZlXsJ
         VqVVE7aWnZWIDmsKM8brosdMVnUTLsQfjXUSgIwSOWIjHZHkuheoZkcBsS1ONfk0me0t
         RdQkAZFhVYInTQQN+T33wnyp3GmJkfg1Dyyn2ZHWCKB3WjxZ7kbObobvFKorFdceRAMe
         +2Mv5EPiGnGV6K+zadx/kSaN6D9VLh3pBMJEjkoA2a4kunbPdhThSFi0aIcz7sFzIT0H
         BWRpyNKvhSn4qxor2A1dTJ2Adt+qgjDjuZNfcPs10TenOkMEYiDq9WvvAbdkNMw/ZhJV
         ipxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eVdiqguGjzF23UdG16xDPKaVQbaWflnNiWUyO8WNtc8=;
        b=RHue3cJ2v2/4uBqcVzccy9q9NU+OzShqsqkp/334707vvKh3vHskzhxgCPy4T3fXx2
         tjWRgTe7MqXPXCq6DHTZAToCtfQCrMFdHRNV+SUTLvlSg/sqdkxWeFpFn3Woy9OJ6PWi
         5N6WXfnqbzA7eGHKpzztzLxm+yXbHQolY2jKEGVdJGE3p8nA2QPqoVBNamAXgLyFyFwX
         LboywxLmI6Am5C2Fj5v4wJKAudAl91BSARkHRs8iNdSmCiLwDXc7E9sSIBmt73DZMFhj
         YduTuSigjtzyxzEPzD0jyZUZ0R163ARevHJWW/GnbK+mdCPh7C0H3DjlOb224vh9d6i1
         +11A==
X-Gm-Message-State: AOAM530mZArYXM+HzmsgeDzkaZNrD5I87kLqA9dt+6ZLkpXuoEvsfd19
        4FFBIMa5tKmql0a1kgrgWYs=
X-Google-Smtp-Source: ABdhPJy4Gfh7yCdRrQ6c5gCvOKthpAUlRcVKwuAZRUc97/CHu/EQY22gLjazZyR28vp+mg1OV4e8yA==
X-Received: by 2002:a17:902:f686:b029:de:18c7:41f8 with SMTP id l6-20020a170902f686b02900de18c741f8mr13847842plg.65.1611795806292;
        Wed, 27 Jan 2021 17:03:26 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x184sm3885530pfb.199.2021.01.27.17.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:03:25 -0800 (PST)
Subject: Re: [PATCH net-next 0/4] Automatically manage DSA master interface
 state
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210127010028.1619443-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <99d4c608-d821-7f87-48c1-aa1898441194@gmail.com>
Date:   Wed, 27 Jan 2021 17:03:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127010028.1619443-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 5:00 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series adds code that makes DSA open the master interface
> automatically whenever one user interface gets opened, either by the
> user, or by various networking subsystems: netconsole, nfsroot.
> With that in place, we can remove some of the places in the network
> stack where DSA-specific code was sprinkled.
> 
> Vladimir Oltean (4):
>   net: dsa: automatically bring up DSA master when opening user port
>   net: dsa: automatically bring user ports down when master goes down
>   Revert "net: Have netpoll bring-up DSA management interface"
>   Revert "net: ipv4: handle DSA enabled master network devices"

I really like all patches but number #2, though I don't believe there
are existing use cases besides you one you described where it makes
sense to keep a switch in an unmanaged mode being "headless" with its
CPU port down, while the user-facing ports are up.
-- 
Florian
