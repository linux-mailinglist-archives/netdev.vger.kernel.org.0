Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0AB3393B1
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhCLQjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbhCLQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:39:08 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D899C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:39:08 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id n6-20020a4ac7060000b02901b50acc169fso1671421ooq.12
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1LbaPYIrGTEqy7YWkkcKHcitaEFTMWEyocZYWrmXi9M=;
        b=mu80Nnr7TDpas2rtHLzOCExgIQXfcFjgiGzlcM55ExLPqHUGrDv9dqjnoC6MjHQumE
         Nojo0q2dbdrTAF7LOaWt/oKp4ewE8gdj2Y8Sex/jfQBTT4JYL4wqWo7siesizX/QE+8b
         B7LCMmM149UPSqELKr6V67iU82SeeNDePOtUyW/k0PbyHefMrlJabcggYgYFwDVuBaXq
         /SThfjXyQHy5fHbZygL52OLinNRXHpcSvzxIrZdzI6Jkp60CFyu155tS2lioeTdGyMAz
         Z+Xkmo8b59NTNx9h7iLvVsUPc03iQQcJKyySa7jE4x8CwIiOmC34Vo5+Mc1afvuiOp7P
         N3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LbaPYIrGTEqy7YWkkcKHcitaEFTMWEyocZYWrmXi9M=;
        b=c1HvFQo/TD1s9aNTL8jh6dYx2UcPxNstx8a/VU3WHd4sCvNXzrTooydU6w7PwyMYhU
         HMWpKaoZccGYI//r6EGWakfuh2TkO8twJBOa883MwomqmQz/F2V8eNhTYgjnuwPHt8dr
         yMiAgChs5raA3c7ZXZ5k6XeNRYU7mF3uYUAwE7vgHYMgN6fREg5dgGIYD9cuiwrIdmcb
         E1dqvZT5dokpqXhjCHZfMfQn+WFqZvVwLmgRLJ0fGYcnsM8ent0oMTqmr/3/83uA7Q0z
         g9Qx12x/i/tlM44WXAbkr2Sp2XgkWwBviSVyFouVmdMq/qwBzAQJXfiJN4rEmI/CYOfp
         QLyQ==
X-Gm-Message-State: AOAM532wd4tMdhjfPGeHN80l5K42/Ny5wEVwZbh/ieH2LAGu+YSercu5
        jRz58zrZd/mQGfPKN1GVq/wALBjOXB0=
X-Google-Smtp-Source: ABdhPJxM3Cot2d6j/qq2shADk4wvq18pu8nmv1CxwWvBrdLvZWAgaGXAahORqA7HHdAMAkeNnczgqA==
X-Received: by 2002:a4a:b302:: with SMTP id m2mr3799545ooo.59.1615567147326;
        Fri, 12 Mar 2021 08:39:07 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a30sm1427828oiy.42.2021.03.12.08.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 08:39:06 -0800 (PST)
Subject: Re: VRF leaking doesn't work
To:     Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
 <5b2595ed-bf5b-2775-405c-bb5031fd2095@gmail.com>
 <CADbyt66Ujtn5D+asPndkgBEDBWJiMScqicGVoNBVpNyR3iQ6PQ@mail.gmail.com>
 <CADbyt64HpzGf6A_=wrouL+vT73DBndww34gMPSH9jDOiGEysvQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5f673241-9cb1-eb36-be9a-a82b0174bd9c@gmail.com>
Date:   Fri, 12 Mar 2021 09:39:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CADbyt64HpzGf6A_=wrouL+vT73DBndww34gMPSH9jDOiGEysvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 1:34 AM, Greesha Mikhalkin wrote:
> I see. When i do `ping -I vrf2` to address that was leaked from vrf1
> it selects source address that's set as local in vrf1 routing table.
> Is this expected behavior? I guess, forwarding packets from vrf1 to
> vrf2 local address won't help here.
> 

That's the way the source address selection works -- it takes the fib
lookup result and finds the best source address match for it.

Try adding 'src a.b.c.d' to the leaked route. e.g.,
    ip ro add 172.16.1.0/24 dev red vrf blue src 172.16.2.1

where red and blue are VRFs, 172.16.2.1 is a valid source address in VRF
blue and VRF red has the reverse route installed.
