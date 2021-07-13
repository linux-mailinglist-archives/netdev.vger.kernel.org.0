Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA3C3C6878
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 04:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhGMCYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhGMCYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:24:45 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475FFC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:21:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v7so20263354pgl.2
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NlVPTZqzkr7X/6SxfWdup8v6l5x7x3FOQrlL4P9RfQg=;
        b=ApkQ294WrZDrFMp44CboLatxYl0a2e1eN2N/HgtF8ZMgZxrKHelJMNQpByirmSEAHt
         /VZd8uL/gbvdnMCBGsbWr6euvFrlQbKKUM4OgFSdB6ZCaqfVq2MSNVdF9tHLddSFnNKj
         NZa3XQ4HwSQj/vcSlI6yMUHX/Q4H09d1tqupDQqCAEBgORcOpUZsGSWD1VUFUtbLNqiP
         zqS3S+Ac5eKdwSL8sqnNs3+8vb3fLDTIGp3bpo1Ea+8lH/EUc/3F6n7DaGs0/aCmV0wf
         zCocuPGt3uEOHiWPXzyHmz796Wp+ONQEzPOnQzdsmrMbvezQxqNkTFUtPKGobAeRtsTH
         a4uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NlVPTZqzkr7X/6SxfWdup8v6l5x7x3FOQrlL4P9RfQg=;
        b=Fa3BJ3X3sc3paSyFmYF6AAO0UbkRc9J2BNjw8LtRsQoWpyBsO+TTnUeaVKuVf5+GbX
         wGgXjYn8UkYK9qMmR8KTJyXgkc5sJxaXX2ba9UNMt3tP68uL9Hh/n7GWBPQ/mkg+qfxC
         1bonqEoKAttgdty7vSXtE9Nb5965tTLjxKZ0yTC8P3nYfYD+4pv4jaJMcRT/8F3W1/rj
         WpoNKiHtK+mzV80uO+WoMU0wwOtpjJ2BxS2WsDYKDR6WAdObnwU4Kyhv/EPoAN7PsokX
         o8DUQnoftl46PFmkVHX20z/HZDZO1WtXD9+xjjVgla2e7GQlwrWEXQCp1IF/UcMdq7U0
         mrew==
X-Gm-Message-State: AOAM530VbnozByt7GNmg+UMCDtOjeULSi9suLXW+Xobld0QdOjoNZA5G
        06YKNEKJXQ+PfdkNiTfevjA=
X-Google-Smtp-Source: ABdhPJyYA1T49l5wpTcSySdSWTBvDZquM32w3tTKfIemyz1nNf8hvOADBOTR+1exaI4v7AQhBBmpxQ==
X-Received: by 2002:a62:7c52:0:b029:329:d4c2:8820 with SMTP id x79-20020a627c520000b0290329d4c28820mr2036248pfc.59.1626142914851;
        Mon, 12 Jul 2021 19:21:54 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s123sm17321242pfb.78.2021.07.12.19.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 19:21:54 -0700 (PDT)
Subject: Re: [RFC PATCH v3 net-next 03/24] net: mlxsw: refactor prechangeupper
 sanity checks
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
 <20210712152142.800651-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c4f3a25a-9dba-2710-490e-45e47ef56528@gmail.com>
Date:   Mon, 12 Jul 2021 19:21:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712152142.800651-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2021 8:21 AM, Vladimir Oltean wrote:
> Make more room for extra code in the NETDEV_PRECHANGEUPPER handlers from
> mlxsw by moving the existing sanity checks to 2 new dedicated functions.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
