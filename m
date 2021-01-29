Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D0130842E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhA2DUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhA2DUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:20:19 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33D0C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:19:38 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 36so7391829otp.2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EkP+HPPAMJG9srhYOPChtk3JX8CYuqz0Yuy/wHz/r0E=;
        b=QE0IivgPs5NDSCvGEO30A+Dg3FUZY7U9Lw2cgss03mVzouzWEOMi1eULRPrDt9LXmX
         VyQGpobCDwqRZSj7FIqRDKQyAYvzbMibH7pSKxc0ymXboWIDFzfWl/bxIJvMTu2MU787
         vSO8r59b3UFGFxFivSNGgNlMs0NJbxMMn4C+/wyZx8KNK2rAkv7cyQf9rDSebaVUDdpH
         meT7T6MRScK9P2CNePVKi9QU5KIWHO6Bftbe8x7Nab0XZPov68XgZrRFC0ArpvgrTmgK
         p9f91k8cYvLY6Xggxkz0+LqgCYOu2vH7lWcRQY032jU6V0ctexuWtslPcH+7JaKxieqs
         odwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EkP+HPPAMJG9srhYOPChtk3JX8CYuqz0Yuy/wHz/r0E=;
        b=fSHJpFGgXCK+aUgim0UYZ2i7BGDP5nA0tlxduEyInEGtLnY13b5JY/VrSGV59pzjb7
         Pf8Q18wvPpwU3HmT2Jvu2ae0mQbt4L8IDnIgoMmZHS4nRiEzoJ8Hy1O+VV78c5TgIXGX
         BlxdBPJLrzIfDK/RcKTzt9Cl3wu9khY8g7LK7yuHkrjPjnQQO14ksXTlQN3tt9Mhsv0z
         sCLtBpPe8SLktbOqww7BIJi8t3GdNifj6MplslxyQ81TjNiYY8EXYFDAbGID6DiPlrot
         UCELvI8hqXUTAo5TKj40CHqixaUZ5qD+d+S0tUYNye/RHcvu6naxwtCNANzKF+U6X7r3
         N3xQ==
X-Gm-Message-State: AOAM532K+W9cfh2DmcODicJI3dzUKNESYjXfQCwVvZieIeUVlKEREFQU
        gll9bn3yZO1SU8we/qNtwBE=
X-Google-Smtp-Source: ABdhPJwIpXiaGDE09WXocPjVibNNgA8Tf+lAlEPg2Va/IVbuDefooQbpwn4EaIzU6zvFaFFfDAmR2w==
X-Received: by 2002:a9d:19cb:: with SMTP id k69mr1778461otk.75.1611890378358;
        Thu, 28 Jan 2021 19:19:38 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id k65sm1850028oia.19.2021.01.28.19.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:19:37 -0800 (PST)
Subject: Re: [PATCH net-next 10/12] nexthop: Extract a helper for walking the
 next-hop tree
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <2537ad1b469601766024e2eb66c135ee2e82e8d0.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2dc70c38-95d4-4c9e-2a2d-6e4aa82f60e0@gmail.com>
Date:   Thu, 28 Jan 2021 20:19:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2537ad1b469601766024e2eb66c135ee2e82e8d0.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> Extract from rtm_dump_nexthop() a helper to walk the next hop tree. A
> separate function for this will be reusable from the bucket dumper.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 52 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 19 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


