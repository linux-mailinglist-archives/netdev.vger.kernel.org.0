Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B172B559B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgKQAQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKQAQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 19:16:34 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42711C0613CF;
        Mon, 16 Nov 2020 16:16:34 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w14so15742017pfd.7;
        Mon, 16 Nov 2020 16:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AC3KDm0UUGykHK1SH4WcZPJrqGyzw9aD4RzyKaSqRN8=;
        b=JLd7IGoNJxMF6yOzSfECm77cleusaVqREidZ9OU43Xo3JmPbBqza5FUYRyyFM5kGnA
         h6FJ5A62xUXzyoXgtQwY2HkMzyVmhsC3sHPlMPaVTGjcOI+A3xU5urjuThDDwBWYwApA
         EbOfmrb7mTnfE7+g2KfgEox+mthc4ESpoAMAtHpiQyCLGIbPl64ddH2qPXj7wOSTpn0n
         WolqRqoEXflcfBdhog9MT5dW6CaWTl6L6a8ArbsRue8/Q1mKnOT63sJBWGKrC6ViXrRT
         KVSLwtV44zxi2Yd6AG+eJBOFgU7Ciw52ncygcKGughFcNXOuWaXIlKUdr4WuX3+hbWzi
         hPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AC3KDm0UUGykHK1SH4WcZPJrqGyzw9aD4RzyKaSqRN8=;
        b=UbkiZsuVUHYk98HTETOIyu7J1ok3h7+FROx4hGsAJmuGcpQnXdgegIXGKym3G+HCSh
         6ORoxM+/1l5GiHBjUfj79h2G3/0aAgwDEmEh6R4cfEAriQcPVIss3Zfp4XoEGdAOFKhh
         4HijSgYcsd9P7ErGwzgH3h73SH1103ZbSAQXaPM1vwCy33yA6fLajcJOT+enk1irqwQI
         3YhFH2plrSzcPmCTxZVtM3Uf+ZnQ5/xF+b+1F/5ojtRm9//yctgbr1YAyP8ezAAfZQcE
         92Grlt58/krHFnircKMZf1lwpks0+ryel+GQv7e+EIpBhGCeCfj0jW2ddtUHyEBJvDMD
         pMrw==
X-Gm-Message-State: AOAM533njgxpNBbEuVfm9u4BIYNGbshwPNsaq2WbztuYd3vJVG2mBuWD
        Ji7H2KDNAP4yBigxNdXH6eJ6Hf22Vt8=
X-Google-Smtp-Source: ABdhPJw2no3tAjc4KyQn1XVSLkbkt09wUVvEF8q8T9rjJkYb0HGogxKcAApT7tacfNo+YCYyVlWX+A==
X-Received: by 2002:a62:2c8a:0:b029:160:d7a:d045 with SMTP id s132-20020a622c8a0000b02901600d7ad045mr16480748pfs.65.1605572193348;
        Mon, 16 Nov 2020 16:16:33 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n9sm1049490pjk.1.2020.11.16.16.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 16:16:32 -0800 (PST)
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
 <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
 <20201019211916.j77jptfpryrhau4z@skbuf>
 <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
 <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
 <20201116154710.20627867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116235405.wkyyhqznocit4vj2@skbuf>
 <20201116160449.0cc0ee76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201117001213.3dk6fluycx5fi2h4@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <a625d8ef-4e47-1cfb-2529-9ce1f0d1fe36@gmail.com>
Date:   Mon, 16 Nov 2020 16:16:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201117001213.3dk6fluycx5fi2h4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20 4:12 PM, Vladimir Oltean wrote:
> On Mon, Nov 16, 2020 at 04:04:49PM -0800, Jakub Kicinski wrote:
>> On Tue, 17 Nov 2020 01:54:05 +0200 Vladimir Oltean wrote:
>>> Yeah, I think Florian just wants netconsole to work in stable kernels,
>>> which is a fair point. As for my 16-line patch that I suggested to him
>>> in the initial reply, what do you think, would that be a "stable"
>>> candidate? We would be introducing a fairly user-visible change
>>> (removing one step that is mentioned as necessary in the documentation),
>>> do you think it would benefit the users more to also have that behavior
>>> change backported to all LTS kernels, or just keep it as something new
>>> for v5.11?
>>
>> Yeah, I'd think that's too risky for a backport.
> 
> Ok, I retract my charges then. Florian, depending on how quickly you
> have time to resend, I might be able to double-test your patch tonight
> before I go to sleep.

Please give it a spin, I can resend tomorrow first thing in the morning.
Thanks!
-- 
Florian
