Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8612A2FDABB
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbhATUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388371AbhATN5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:57:52 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B94C061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:57:10 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c127so2915186wmf.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uPYHw73Fmba34UBZyndvbBrByJK/4y5p09JPYm1muXA=;
        b=C+zpEqhvLdsNn2ibhFJHfHzhXx2MWo9KXHJSJrEOwakVCegddGKa2WytX9x3E/aI1Y
         e4mJML6vkCwtCKNxsVEnsxgE/6KEWiUODcMfG7FIdWcwSeAnhrMcrSMufFYR+B9tXBNC
         7iVG9hNTOhABm9+k0czfIftxx3VHSYFwA1gsd+IcDec5P/+4P2EYIvmpU4NwC7Up1tJ0
         15jDaf95gyT4jJQRIxS6ypsiaIlsAD7YzvwwTC1F87DME3H4hRkgZBNO2hPMkB/YSm8h
         nSuSys3ERtAXnC4hQc5YzY1ToOdSxluhg5Yg3IxYjwYOENe/g8Mzyk1MgulXaO2+a3ov
         OC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uPYHw73Fmba34UBZyndvbBrByJK/4y5p09JPYm1muXA=;
        b=k0gotoUvXdPO5SggxM4TrpIOMoxP3Q7OwYZh2LGRV9WZM9+zHZyM9DKDQeCrsTGabP
         l3rigdzTwwNTxJJCtGtwHKp+1sibr66VBElbRl9jz7YFZi8EfjnXu5SViTxNNyeTsyd3
         azNSu39MoxLznQoJJvGBz2BoPB/gxjbNXgyf+g1+9lIEZ8QbQwsuq4iH+CRud7dJsOMQ
         BU3i1QF2qCuv+pA1JWXFvJSSxJr06nyNAoL64EbDg1PTMgRG70MQfhsS+BMsJ+RPmcbY
         onsVMXpjLpDdTXbEhLOlmLkeOHF2fjsT5dj1lEYKLQ82sEkR3NPn2ghhbCq7jCEBJ45S
         ZUKA==
X-Gm-Message-State: AOAM532Y/uj9yxcM6kAoQRril3Daf/ujlMDkrFJtxPHl22V7esKFMWL0
        JvWZ8c9ohgKOFBGR2z1ZdYm1oQ==
X-Google-Smtp-Source: ABdhPJw1D3U6yfPln7nxzsNozkutnXrTHvP2HT2freIpiTdXdcmXnumRV1S8/GDFaBEFa2dMJ6GLqQ==
X-Received: by 2002:a1c:790f:: with SMTP id l15mr4560693wme.188.1611151028861;
        Wed, 20 Jan 2021 05:57:08 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:853c:3c08:918b:153? ([2a01:e0a:410:bb00:853c:3c08:918b:153])
        by smtp.gmail.com with ESMTPSA id l20sm4622759wrh.82.2021.01.20.05.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 05:57:08 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 3/3] net: core: Namespace-ify sysctl_rmem_max and
 sysctl_wmem_max
To:     Menglong Dong <menglong8.dong@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, christian.brauner@ubuntu.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <dong.menglong@zte.com.cn>, daniel@iogearbox.net,
        gnault@redhat.com, ast@kernel.org, ap420073@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, jakub@cloudflare.com,
        bjorn.topel@intel.com, Kees Cook <keescook@chromium.org>,
        viro@zeniv.linux.org.uk, rdna@fb.com,
        Mahesh Bandewar <maheshb@google.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210118143932.56069-1-dong.menglong@zte.com.cn>
 <20210118143932.56069-4-dong.menglong@zte.com.cn>
 <20210120104621.GM19605@breakpoint.cc>
 <CADxym3aV9hy3UdnVWnLeLF6BnwqqrJ1MdMKNQiSa4sCWQ2+4ng@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <2e1eaded-f9e0-0da8-4dd9-0d459470cc95@6wind.com>
Date:   Wed, 20 Jan 2021 14:57:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADxym3aV9hy3UdnVWnLeLF6BnwqqrJ1MdMKNQiSa4sCWQ2+4ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 20/01/2021 à 14:28, Menglong Dong a écrit :
[snip]
>>> For that reason, make sysctl_wmem_max and sysctl_rmem_max
>>> per-namespace.
>>
>> I think having those values be restricted by init netns is a desirable
>> property.
> 
> I just thought that having these values per-namespace can be more flexible,
> and users can have more choices. Is there any bad influence that I didn't
> realize?
You can have a look here:
https://lore.kernel.org/netdev/1501495652.1876.17.camel@edumazet-glaptop3.roam.corp.google.com/
https://patchwork.ozlabs.org/project/netdev/patch/20170726170333.24580-1-mcroce@redhat.com/


Regards,
Nicolas
