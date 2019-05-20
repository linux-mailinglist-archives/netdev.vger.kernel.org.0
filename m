Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F377E2307F
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 11:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbfETJg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 05:36:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35113 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731261AbfETJg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 05:36:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id h11so10442767ljb.2
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 02:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SVmG+KgAS/L8zReuTwf2tG62bM9a7Io4idy5Ia1ZZIw=;
        b=CItiLuntAhzOMGH2VJ//VLpv/1cTB8FN7h7gueSZp7+ondzT4GAkchg89CIMQlKFCH
         +PTP10KnFd3DEk6wgkzuQkb6WmUByoW1S17NW/sqSFxs/pJAl0n1/KOiI5NwUo53VuN/
         3WhWE0Fo0J0Aw6fOq1nQ8XXjwhj9eeTaEnllHzRAz3S2QVQ8NX0gp02/99F/FWQnHm2o
         qk7JJ1qPEtuOeMjLcCwP+/Ht+TvyGGm6x5OONe8RshUFKQIwvWXfR4rJ/+NbLE5fz4qO
         59F+Ga0fmI6oNS5NlIUbmYUQ9/00bX0wh08LL65062trdQZW43TGqsruRXx6pgzJ0AQx
         IKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SVmG+KgAS/L8zReuTwf2tG62bM9a7Io4idy5Ia1ZZIw=;
        b=gMl8B1B5Sm5FS0b/el82uNlwffAPIFZ984BDRIPdag+UlWJGn/wR5/aF8mCtY1fYtR
         12r8M8uPMG4Ja54logMG8FOZ+yOKiS+Uv/pbGiwMiQoo/W/xQWR/X3UM143WHGA680uR
         8C0oIVtK9/ctZ8twOH0khkJdLrFryN8Lo+6E8nBzeASxAdBue6oH2tDdufMOcMwbFOfI
         /chthSYweC2NxuPYaMbLQZM9WUjHXqr9cYkccAyNDA2l85nsAKY6KSPUn2txt9yQbHke
         MGd4oJZHneK0LDEzN/DJsUybcZ/h0D+TE7HYZGTVcg8ALQv+bPccpP+S77wI73h/gb5n
         XfkQ==
X-Gm-Message-State: APjAAAVs6R5y0KNvLnkcwwDBpw+EtyZlftoSOwMMSaW7BBEoZyd7DpLt
        vPOcsv1iHXeIZnQxDP3+L1/KDg==
X-Google-Smtp-Source: APXvYqwaXw2NIta4ydW0the9uuNpiHIG2CIaAvFEtua7oAjOr+r4sGkRe1H8tyT2JKQhRZXwIrjRmg==
X-Received: by 2002:a2e:9410:: with SMTP id i16mr7604284ljh.152.1558345016801;
        Mon, 20 May 2019 02:36:56 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.81.27])
        by smtp.gmail.com with ESMTPSA id h25sm3594162ljb.80.2019.05.20.02.36.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 02:36:56 -0700 (PDT)
Subject: Re: [PATCH] of_net: fix of_get_mac_address retval if compiled without
 CONFIG_OF
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1558268324-5596-1-git-send-email-ynezz@true.cz>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <421e4a76-dbd7-73ac-d8cd-af0bcd789a03@cogentembedded.com>
Date:   Mon, 20 May 2019 12:36:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558268324-5596-1-git-send-email-ynezz@true.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 19.05.2019 15:18, Petr Štetiar wrote:

> of_get_mac_address prior to commit d01f449c008a ("of_net: add NVMEM
> support to of_get_mac_address") could return only valid pointer or NULL,
> after this change it could return only valid pointer or ERR_PTR encoded
> error value, but I've forget to change the return value of

    It's either "I've forgotten" or just "I forgot".

> of_get_mac_address in case where the kernel is compiled without
> CONFIG_OF, so I'm doing so now.

    Well, better late... :-)

> Cc: Mirko Lindner <mlindner@marvell.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Reported-by: Octavio Alvarez <octallk1@alvarezp.org>
> Signed-off-by: Petr Štetiar <ynezz@true.cz>
[...]

MBR, Sergei
