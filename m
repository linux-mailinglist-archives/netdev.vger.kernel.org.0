Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52123436D42
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhJUWMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhJUWL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 18:11:59 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6FEC061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:09:43 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id o4so2653340oia.10
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WvhwLq6u8eOAaxDh4ySdjyIq/ABtVjvBZtSXL6Ehhmk=;
        b=g/6tKSL2/FcurbeNV0qemZzC4xKEjQCjj5K03ZiCK6cJVVGF/rk3J76954wowuZ5lc
         NiXphU/notOT2fyV1Knhin1nah8btrtOXGAenzM3+J7td2RREEm2TxDpC8i34uQHwumH
         4kAbABLsUgEGp/paRiKe4iRUFNOWo9Gs2d4mHsr1rNNHHCBsAwvnI/ZVMr8vrSUTGlKZ
         I3b/Aj6FrtNXkAY0lgN4BxMO8bDSTPhuvulClbWNA74z2Q4DiBMX0KLTRJHIN2qmeJfy
         xgkr3PRVgl+1E4gmQBdUcsky9+F/IPpvJJscVW+lyXpIiXqTq2wE4yJaJQ6bz5gTWhpj
         TiYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WvhwLq6u8eOAaxDh4ySdjyIq/ABtVjvBZtSXL6Ehhmk=;
        b=Y8PgwW6L4xbKLa/mHoeVn4sh0VZUVYV0B1zWL9aH2lTuhKj5YSKo/JWEwxbFSTRwNk
         uuZyYtjNUqy+ZotlKds0wfmZzNiIqOrvZHXf/gA7rdtiTCEBNfZG8bez16lOmgyU4cS4
         PLwsw+iqHROl1/qiD8BVWenOmZvmeqId/LhMM3xlEsZ3FGBmHUwIXwJlOcebo3zqPZgS
         6p2O/Paz49D7CdhO5CFzk2mPHK7/lDFZEZmdcUEO4GP4U79oMGjnK0dINAvo328PITgD
         StbHZb/5uiK/cxu+rbDxcQmyymAelpKnVJBa2H7xpSssn3Xmilwju7d/GFQi2fX61f79
         g1tw==
X-Gm-Message-State: AOAM533193/xfzETdyik57TJZTb66bEKoNgdZmpvdO51w/tHh2IvQqGF
        IbRkqLFHLIdKz0OJHrFl98g=
X-Google-Smtp-Source: ABdhPJxN9utloIzkbcW1CuMdQ/001gE08DjPXX1sWBeO0HwPGsntfJ0fBeqxXCcv8K4erXF8TpPSpg==
X-Received: by 2002:aca:3446:: with SMTP id b67mr6930054oia.84.1634854183040;
        Thu, 21 Oct 2021 15:09:43 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id p14sm1121975oov.0.2021.10.21.15.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 15:09:42 -0700 (PDT)
Message-ID: <944f6c2e-bb84-0dfd-b411-1ddefeddb78e@gmail.com>
Date:   Thu, 21 Oct 2021 16:09:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v5 0/2] Make neighbor eviction controllable by userspace
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
References: <20211021003212.878786-1-prestwoj@gmail.com>
 <a33c3f84-7333-294a-9e78-580cbdac6ec1@gmail.com>
 <1903d7cb20ac31d95e2440424a00190522facb47.camel@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <1903d7cb20ac31d95e2440424a00190522facb47.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/21 3:59 PM, James Prestwood wrote:
> So the test itself is pretty simple. The part I'm unsure about is how
> you actually set the carrier state from userspace. I see "ip link set
> <dev> carrier {on,off}" but this reports not supported for veths,
> wlans, and eth interfaces I have tried. AFAIK the driver controls the
> carrier state. Maybe some drivers do support this?
> 
> Is there a way to set the carrier state that you, or anyone is aware
> of?

with veth pairs, if you set one down the other goes into no-carrier mode

make veth0 the one you are validating and put veth1 in a namespace
called testing. Then 'ip -netns testing li set veth1 down' put veth0 in
NO_CARRIER
