Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4681CC5F5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 03:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgEJBYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 21:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726565AbgEJBYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 21:24:04 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF0C061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 18:24:03 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d7so5823945ioq.5
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 18:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ofofrepbtz2cg9aeJRaQRwdznTFjw3+jge418i84nBQ=;
        b=Ln8nttEnWk7omcFxCTcRU44Zqsw7di0c75vwlHjSbJ1w48QoN9bFSskG3zCTtlhDEZ
         3LCi20wyvSpi5EFmbaDMtpIL616N0d5rnzxDdRDp+QbBR4APSH0RPRKO19DMdw7YhXT5
         /o4flMr9Fv4VAoHuUtpauQ1oTBbpils9MOS5HQAMpaqMbthIJwVrzGSs9ESeEXFjYIyl
         4DYhjC9SqlPtGvLpyj6TnI5HkirPrqUP+dL8sIdKOXa96ZwBoMPjP6dnh7nlyJ7K0H8U
         swpYmu6Uao6ViWwhENAlA6qY3tTptAACHxvdBwhiS2Nru39uFJYDjKEHpwH9QET/QE3P
         3vsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ofofrepbtz2cg9aeJRaQRwdznTFjw3+jge418i84nBQ=;
        b=DOgsk1t0NVCAWHtE6h9lRV+gGxe7uw9kXniCMIClGh3iM5TVGmLiUpiK5uxstDZs1f
         Anr6l6l+kRXtGIbKf7ozJ6WReuTJWHhrxnaUCbTkNC1cbcMrlOwg4eHXKA6GqfXL2fAI
         nv7X1wW2zT1RKdxduT3dXUx3aA+98CQUFT/b5fK3gXK1gzsu45QqM0UaAWMbM+0nHeDK
         YB+E2aOeNBfigwMySl/NSZKCBUGXKNN88DdON/uxHYRaVZh18UfjdnCRPsXAIscufSIf
         8ncXy6jdsqEgN+rB0uzwo4ajVdGi98JnzVaYUOh9/A9v8TzefV8B8oXiift9vr5ZDvzK
         /MiA==
X-Gm-Message-State: AGi0PuY0Pd3Z/mXmod3iWDAeQSZ2UoNmi/oNoeTE9JsK1WccG1KMlY+k
        MXp1HwJE4lvf0Y66/qW1/FVv5N8p
X-Google-Smtp-Source: APiQypJKT7Tap7HCgv/K0G4849rfRGtonfvl9bV31s38OrNj589B+SBeiHqaptuFoN7E9N/lVpbaKg==
X-Received: by 2002:a02:a598:: with SMTP id b24mr3263877jam.104.1589073843061;
        Sat, 09 May 2020 18:24:03 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d4f4:54fc:fab0:ac04? ([2601:282:803:7700:d4f4:54fc:fab0:ac04])
        by smtp.googlemail.com with ESMTPSA id n6sm2628338iom.39.2020.05.09.18.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 18:24:02 -0700 (PDT)
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter>
 <a4fefa7c-8e8a-6975-aa06-b71ba1885f7b@gmail.com>
 <CANP3RGfr0ziZN9Jg175DD4OULhYtB2g2xFncCqeCnQA9vAYpdA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <55a5f7d2-89da-0b6f-3a19-807816574858@gmail.com>
Date:   Sat, 9 May 2020 19:24:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CANP3RGfr0ziZN9Jg175DD4OULhYtB2g2xFncCqeCnQA9vAYpdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 3:35 PM, Maciej Żenczykowski wrote:
> Do we have some sort of beginner's introduction to Linux VRF somewhere?
> What they are? How to use them?

Ido's response gave introductory commands which can also be found here:
    https://www.kernel.org/doc/Documentation/networking/vrf.txt

This should answer most questions about more advanced topics:
    http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf

Lately, I am putting blogs on https://people.kernel.org/dsahern for
recurring questions.

> 
> Currently the concept simply doesn't fit into my mental model of networking...

network namespaces = device level separation and up
VRF = Layer 3 and up separation

> 
> We've actually talked about maybe possibly using VRF's in Android (for
> our multi network support)...
> but no-one on our team has the faintest idea about how they work...
> (and there's rumours that they don't work with ipv6 link local)
> 

Rumors are ugly. If in doubt, ask. LLA with VRF is a primary requirement
from the beginning.

With 5.3 and up, you can have IPv4 routes with IPv6 LLA gateways with
and without VRFs.
