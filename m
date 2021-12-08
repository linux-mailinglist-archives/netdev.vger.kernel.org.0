Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7075946D753
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhLHPuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbhLHPuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:50:12 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164C0C061746;
        Wed,  8 Dec 2021 07:46:41 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so3112275otj.7;
        Wed, 08 Dec 2021 07:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bSMFBH3rt0hbmhYjxvYkZRwsbPK5x5Ty6biTXnt/I4U=;
        b=evLjb8G9G31yMKSB6kXk37pZ96PCIOrY1Zl40OsI0UlrCxXtWgq1FMwnN7kU/pEIQ0
         6lgBw855LG21q4PnRfhz5wNQsA5lJiPMhlJPeOwsx2C2mX9j41N9x4xSfg/gygH3ZcSO
         U78LVyBBeVtx70UmuYn65SmDea3oOVMVadwOICurB7aP4/DRTVQm2cC38X3xKlA3YuTY
         BzFplDL/d1vsooW3GlvfFuEeD3BUQL2hLaXR5ttXNJbrVnopOC+muzvCbZLazMxfq245
         uJ39ca8BlNzqlUUXG8hORfBzdOZVeG6I5Z9PXZViw658f6Cg+PPX8hcIusKk7WjYZx0R
         cCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bSMFBH3rt0hbmhYjxvYkZRwsbPK5x5Ty6biTXnt/I4U=;
        b=dJ+Zbt5nW66UhYukYsq+mm1WxofLRoYBveGa5vuOlGNW/BySZ5l3EMR7ErglYpy/DP
         RxL3/14HJKaKcGVNVA9aJewsLKyBYmLZ4DJ9O9Jta3iX4+8DWcJuYag1CVHLpmJx7ZFt
         kDWg8s5a3S+xyaQWVw9yr3qHizPH0kDa6rTOhlto5q0qPlVoBeRdbvf5XwAEmurqrDVY
         LEYFbCxZIrFt99Gca/XvGQsIJ0pfdPSqQsxRnj81Jwo8t7EoE1bipaTV+zT+OCy2osze
         ahlcW/YhuC2iQra/AtYzLJz+JYynzlTtsBgwDmUVHR5D2Huo6IkZzdiWpRBBTgueDoCE
         eQQA==
X-Gm-Message-State: AOAM532ZpFtKm396JJ4aNr8GPmvqLgHebRwYyICndhw8lwrfFnPrJzPR
        8ozLXzd3tHW1ERVr8w2EV4E=
X-Google-Smtp-Source: ABdhPJyHq12QmwUDhxGS7+kIVWpFTLOAMqk06rGpJd8YdaqFJ4lupoTtiKzDS+QrlRJhWP+iBbPspQ==
X-Received: by 2002:a9d:62c2:: with SMTP id z2mr252555otk.163.1638978400493;
        Wed, 08 Dec 2021 07:46:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 184sm689900oih.58.2021.12.08.07.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 07:46:40 -0800 (PST)
Message-ID: <d6cacd7d-732c-4fad-576d-a7e9d9ca9537@gmail.com>
Date:   Wed, 8 Dec 2021 08:46:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Stefano Salsano <stefano.salsano@uniroma2.it>
References: <20211206163447.991402-1-andrea.righi@canonical.com>
 <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
 <20211208012102.844ec898c10339e99a69db5f@uniroma2.it>
 <a20d6c2f-f64f-b432-f214-c1f2b64fdf81@gmail.com>
 <20211208105113.GE30918@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208105113.GE30918@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 3:51 AM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>> On 12/7/21 5:21 PM, Andrea Mayer wrote:
>>> +        IP6CB(skb)->iif = skb->skb_iif;
>>>          [...]
>>>
>>> What do you think?
>>>
>>
>> I like that approach over the need for a fall back in core ipv6 code.
> 
> What if the device is removed after ->iif assignment and before dev lookup?
> 

good point. SR6 should make sure the iif is not cleared, and the
fallback to the skb->dev is still needed in case of delete.
