Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAF942854F
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhJKCt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhJKCtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:49:25 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85DC061570;
        Sun, 10 Oct 2021 19:47:26 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q129so2001015oib.0;
        Sun, 10 Oct 2021 19:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=DCw1o1HzwqOLnesE+cTH99UgRZDwgnM6e7dpFmi41LE=;
        b=TGjVQAeIYVw87t+zBMgjHnzXbgMZcSB36YSVMBKipqcDC89F2BU2nc0h7Hbux/YujH
         vT/Sqd5tOub3qAvs/Y+8SVVaArOAzqpuw3toEbMQiXi2MuV0phhtUgCvobrS5wtRpij7
         xWMeqoK4VC7elQqglNJfBaGG8m4KVi4UVi3ohC4D7leSMGePK05Rkoo/Deo9Er/59L2J
         17gNC1/xOzNIsWhKKik30nwclHGHmX8uyyGIk9X/7OhcwU8LSq171QcOGb8/aPPhEW7s
         wEV5Jd2EwpR5RsIr9lFnNeDrjR55U1VoHHpYFGVXImkOaEPF+9JqSx3EMCVbJq3Bjc6q
         h+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DCw1o1HzwqOLnesE+cTH99UgRZDwgnM6e7dpFmi41LE=;
        b=blKFB6DISAM9hVl9OYCets2wmx3/XbXCOjLY7LjMzK2jZSAdwDc6XinOJ9Tp3j+1xL
         JknNJYnkGbayYpdV3M4anf1DoXgpOgpmpNttV8AxKx09ot2kX/zdg8jWpuI3rjLBz1p6
         cfYbN9I1o+cqhBfYu7GXDzvddLA8WewLNcS/a0Kfvvph+K0n1ud82NrmH8EMMwvYOE2/
         hGWl8CcfNqiAcTf46sZtUyAw2NYN0dKt4aCvFTf4PTY9qD4dYzQV3tcjpHhOAKqtquIA
         /oPdSo76Y094GMdkX42w1i1PU+oFQerOi8puz+4Pw/5KoTwksq3PLmX6d5LK/wykDEyk
         9ojw==
X-Gm-Message-State: AOAM532PMerZYHpDvjIQz6Ac43hc1ILIGQAVzTvhSK/dKk5RvrBGuPhw
        tZ01Enz5KE1aPiPbEmGsK1c=
X-Google-Smtp-Source: ABdhPJwO9iaADpeZwfoEyIjeygLSuhaPD9462Okhb6ftAu9fURIMwUueHCuFA+ZVBCh3HEdNYHHD7g==
X-Received: by 2002:a05:6808:2221:: with SMTP id bd33mr25229466oib.64.1633920445563;
        Sun, 10 Oct 2021 19:47:25 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:3cb6:937e:609b:a590? ([2600:1700:dfe0:49f0:3cb6:937e:609b:a590])
        by smtp.gmail.com with ESMTPSA id 65sm1502644otd.81.2021.10.10.19.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:47:25 -0700 (PDT)
Message-ID: <be4dbb79-2472-04d6-127e-48c83927d344@gmail.com>
Date:   Sun, 10 Oct 2021 19:47:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 14/14] drivers: net: dsa: qca8k: move port
 config to dedicated struct
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-15-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-15-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Move ports related config to dedicated struct to keep things organized.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

I wonder if this should not be done ahead of patches 3 and 5 so you just 
add the new members there directly, up to you really.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
