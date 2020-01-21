Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08412143F26
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAUOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:15:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34447 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgAUOPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:15:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so3415363wrr.1
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEEV8zFbbxZsk/JjmG+fwiTrAbjezaUBr3+ikDSIY3A=;
        b=G9lmy0+iDx14jOHdjUjaELGgY+PoiunjeSvwxEbEi17Pgt7UXh7oTMdfocYcgaNpOz
         hM8jSbumNMAqOcSzgZe+/93r0PVg5brrxNif7rnw042sICq8RUakGGfFgivORCTpKT07
         RGY8iuPiYTBy+TV166Zxal3otH6xx4QOTTxbOLyP4fzzPwcT9+yWeetQl2UDezP98lkq
         suoQGuOzC0HNixuv2NkL3Z78GkOsvj+Bie09PU6hZbZGJNbCXqkHSf8QE4KsYshRJ1O+
         ovrb1u+u0EDXMX6VhbfqiP3+od3z5VX+qW352IKdeIX+wTs1zQQwluCmwjqwfXNrQMFE
         S0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TEEV8zFbbxZsk/JjmG+fwiTrAbjezaUBr3+ikDSIY3A=;
        b=t5BjPNYfKzUC86zFChM8xsQ9SrV6LvapZfZoTu+xDC0MCFI2gdVJr05k34ntl9blgR
         BWtyWhELTPqy5O5Nwgw+gSAmN8MmC1OvB9+ot3AxirAdPB1uARX3otCd7xhrg99Jg1Hi
         nAgLSSXaQNRGV6kMX3rzN8XcKSqw20PthLeUd/ykvx/Bc7NWQFs5GDVf9NyOO6T9tAfZ
         JdY/0Z0SlIhbB0PliLX1AYHj+NwXs9vI06KD+BnyrpHvKS1Zc0tn25eDGaIfR/HJKyda
         Vs2xmHg0pKCpvSY4595U9jtNjvYhg00eA9yHRnEMPYNWIkpyrYyTkN45W17Mr4WbXAcB
         NNww==
X-Gm-Message-State: APjAAAXJUss1SDNmBV1VpIWAiiU/GKFhP1cGusKscO1+MYaTgq9+Gy71
        LQgv7DoWBBT2vpkohiV9suik3Q==
X-Google-Smtp-Source: APXvYqxF+I4Pp1sWUNhcUvITaZj1JEY5R+oh/Gp6ZPdGhiPkfpNqaF0aalI1TBmmGoGQ92y4R9miGg==
X-Received: by 2002:adf:eb48:: with SMTP id u8mr5411690wrn.283.1579616130702;
        Tue, 21 Jan 2020 06:15:30 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:281e:d905:c078:226c? ([2a01:e0a:410:bb00:281e:d905:c078:226c])
        by smtp.gmail.com with ESMTPSA id z124sm4672197wmc.20.2020.01.21.06.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:15:30 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net, ip_tunnel: fix namespaces move
To:     William Dauchy <w.dauchy@criteo.com>
Cc:     NETDEV <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>
References: <20200121123626.35884-1-w.dauchy@criteo.com>
 <45f8682a-1c72-a1e4-7780-d0bb3bc72af8@6wind.com>
 <CAJ75kXaAxNh90Qq_FYCKXmMD_Q3w318pTQG6ZB-0K-K3bL=Oag@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <8f942c9f-206e-fecc-e2ba-8fa0eaa14464@6wind.com>
Date:   Tue, 21 Jan 2020 15:15:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAJ75kXaAxNh90Qq_FYCKXmMD_Q3w318pTQG6ZB-0K-K3bL=Oag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/01/2020 à 14:12, William Dauchy a écrit :
> Hi Nicolas,
> 
> Thank you for your answer.
> 
> On Tue, Jan 21, 2020 at 1:57 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
>> Maybe a proper 'Fixes' tag would be good.
> 
> I agree, should I send v2 for this?
> Fixes: 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.")
Yes please.

> 
> (we probably should have done on the ip6_gre patch as well)
> 
Yes, I noticed it too late.
