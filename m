Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADD3772CF
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhEHPxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhEHPx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:53:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB3BC061760;
        Sat,  8 May 2021 08:52:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gx21-20020a17090b1255b02901589d39576eso693020pjb.0;
        Sat, 08 May 2021 08:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IfLRKS9WxhrfJ7ArtUDmOZDluJrvD3dt4wUAIZFo2pU=;
        b=kAdMsz7O2auZAQfmEnd2c4os5ou8Qqtk5ZuRctLXWvXfNCIPtchYlzczN52WzW+pHw
         1/0yjiGYDqz/380JA+isihM/q+5gKbfxe3Z0ej1IsWzXOwPs72x1IjxCDh6tunhRMOxS
         fEfQ9XrpvAOpLl9PZoj/T730R1Vg9dQg3kMIsdBbwJfA7UXYyEheIIZiN/z6d24CYWMb
         9QJktRd+9Ps1t0iWVShoyD4lfZFzg81xu3aYS5hz46ef+Ze4lgB5ZM31J4nQEcNKjOj1
         x6auBc6lwkux4f+/TLG+W7FUZvTEsU6UeGhReIC4Y7pY4D/jMF21os0EWNaAITMTt6Z3
         oqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IfLRKS9WxhrfJ7ArtUDmOZDluJrvD3dt4wUAIZFo2pU=;
        b=C/SKEQ/ym7pqCZRbuLy2ZIoaUbDkVmwZIyh2nTSGLEe6ZVHBnwj5Ib3tft5NlbbFJ8
         kzmlrE5d1kPyBbA2tFpSQnkR7VxuHpyt7js449ZTb7fCGam9IFhvbQ4n3wJosqQg6Pov
         eIMiObQV+xn7ByE0uVtoebU8bawomGfkrTwA8T/avPw7W0JMAqZUzRN3DUSBu93HbFX7
         I3PMG/ctXisEzeRwTDIB1Y1a1YP94AqBdHnfSnf11EAJLYr7RJavm06uxrtX5dwdmxcx
         nsWlE7EmWxFIN13m722ZzzLYslRvGcoKkMQFXl7GCxcKZ6FgVowLZz3FVqo8xQmgFba0
         yv0A==
X-Gm-Message-State: AOAM533jbnKGF8RPJHfiZ+g4zTAhFY7B0RQwqsOt+gINyPUkM9LLd4XW
        oUB7+qk7zjqAER7yX+DhOnGVxg8G8wE=
X-Google-Smtp-Source: ABdhPJx1sSW0kSc7oWp1+s+LoUTkLYqaWhk3j0UNgud/X2hCXnOz7PwN/wUnhSMzsJfqPpJaen9NNg==
X-Received: by 2002:a17:902:ecce:b029:ee:cf77:3b22 with SMTP id a14-20020a170902ecceb02900eecf773b22mr15664202plh.46.1620489131209;
        Sat, 08 May 2021 08:52:11 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p9sm15435698pjb.32.2021.05.08.08.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:52:10 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 26/28] net: dsa: permit driver to provide
 custom phy_mii_mask for slave mdiobus
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-26-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <086f92b8-8c91-f618-f5cb-9df18f890f13@gmail.com>
Date:   Sat, 8 May 2021 08:52:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-26-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> Some switch doesn't have a 1:1 map phy to port. Permit driver to provide
> a custom phy_mii_mask so the internal mdiobus can correctly use the
> provided phy reg as it can differ from the port reg.
> The qca8k driver is provided as a first user of this function.

Why not have qca8k be in charge of allocating its internal MDIO bus like
what mv88e6xxx or bcm_sf2 do? That would allow you to do all sorts of
customization there and you could skip having patches 23 and 24.
-- 
Florian
