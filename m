Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41E731AEA9
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBNBVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBNBVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:21:34 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168BBC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:20:54 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id l19so4084737oih.6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D9JcxCtQflUVm2rcTJ9dUl0ioUsZ/ciwoE5YWYzQqyg=;
        b=R2Slch3qbeNT7BCcN6TFlN9UjlGlIVCjzkyngE77GXgHuX7BfGo2i2MVAKeKNj85vG
         W5Rd1Y6xqbod0LxlTfSS/wHee58mZHapWjsv5YxRX2Hkh+oDt6ewQBbwhGZGszDTtXAD
         lvZOC1j/obiGF8067HgfDNRE1UBUcQ2jOv7XLRQq4zCGjtVrL1y0SXBR1KyrU4ACB23p
         XvT+m3PW0eGn9SyuSLeipyWqYHfbSKeiEZwmyYUXb7XaboOC35SLv45p2UnPkrY9NXB4
         2HicRk93QvGpvhfzum0GH49npUFDZFFqgb4hlaJuJQ2fBUUP9TI+gE6ozxLET1Zhlxut
         0UVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9JcxCtQflUVm2rcTJ9dUl0ioUsZ/ciwoE5YWYzQqyg=;
        b=mZWvtuVvtvZpRYPLfKVHm3Ur3opTHE2qQEo4qB+n/dLEoDKJ7NAY096GH3XZfH7esJ
         QmVqRc7CBTzaTjLOqqNs03xJRcxJSJHbRCoPzE7E5zWfGeJXVj98JFUZAd88UyO4SMrn
         J0XRUgh1FjP0/sl+Q8kmQM/6raC7V3HG6R6RRHtpbdQiDbRmZkrpcl8yurQ5km33tHPj
         iS1sUGJ4hHfSwnPPNgXGk7HXh/B5xLNfc8MYnBwoHcP55+GvfPaqVTSgpdBK6i0eaDaM
         gJ92P8gaqRX9iYSS7W0sS7vlnBYnvSvFaQ2eryxF2TZDSrewEYdAyQN9R4RxtMxEH1pR
         32dg==
X-Gm-Message-State: AOAM530mFTRc7s12XNK0o0I80X2QcKva7qJUHMc4gu4djdJO2yoeuyIW
        hTDV+DliPqTXOQHUlkfljAo=
X-Google-Smtp-Source: ABdhPJyUYZHGImVldUGwDlFBfUVOiiCQ7OqY85atJOrDKXq3d2rCbt3xwkjpKYI2lIo6G7sVgZU0gg==
X-Received: by 2002:aca:3088:: with SMTP id w130mr4173082oiw.89.1613265653494;
        Sat, 13 Feb 2021 17:20:53 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id x10sm2819622oic.20.2021.02.13.17.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:20:53 -0800 (PST)
Subject: Re: [PATCH v2 net-next 04/12] net: mscc: ocelot: use DIV_ROUND_UP
 helper in ocelot_port_inject_frame
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <51909621-6220-aebe-9130-eaec07c7412f@gmail.com>
Date:   Sat, 13 Feb 2021 17:20:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
