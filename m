Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B8E44B2BB
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241768AbhKIScf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhKISce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:32:34 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6162DC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 10:29:48 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x64so146695pfd.6
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 10:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6keW1cwJ1gZeH5/F+rrzBzRoyC4dgM8zBqcm8dATQxI=;
        b=P5t/q6LuSQAPCaHvQO5BJfbqHRLy5QyRtNEEXFdXD4DWOOxMOT5RH3rrhmMqP8aL9n
         yDFiOQ0qijxSoX6zg6hXLVpKabYJgWzX1L6KFxgr+IuGaGSLWJVSrZCnUhhrBFJtdVXf
         psBEQEOfxaL7m5m1orZDzJKmO7LYvq26aEOK9+0yB0PWwS9X1/W3Y3b5FhUJehZ0+zZ6
         NotADDLvPyGqzrgEUCGwhsCm5xuutWr7T07p5k4OQIgywsMNV/KPUR96v5iREoO7MI3s
         GVdQTDxHxNWG9TVqEJvVNxVnS+ML54xri1iYxftAiTqsgv2dpTXO74oIgsHmM647ndjr
         Dntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6keW1cwJ1gZeH5/F+rrzBzRoyC4dgM8zBqcm8dATQxI=;
        b=Bcm8ig9GUignLurAV98yTZzPCHAOVaS4wyRy0/p8NYKSAJOWAr9RbMqNUE53me1TCA
         IgRPEsL+OXKSveWUR8oFyv7jkhtPP1fsJ3UiCwToZ3vKUqgwMmMRpWnd8MIaa651b24p
         ksCcJgcTsSmG6HQPsIo8XyQQkP4X/H5BEXWsIxVTPfLbmY7WloOtPoTgn7dWZmuPKaXW
         ogM/x/NSjsHeOHdlG2oRXVkZBUHR00juCV65ylMFiS93LjZ5AEQcMgS0m3SqKBCtEKU9
         zR7CjCPzc+H1/WoTwz7+dJ1gM2QnuQFQjXPuUrelZyg7bnlmrM4cedizRqqrSAY6+gTY
         LACg==
X-Gm-Message-State: AOAM533+yCKrniwRakxK12uxLpUkmNtQuCM4aebdnGLN+XUGBrVeLaxA
        NS8ShBU7wC7nlZW5dE9qf2YDFuf4gVQ=
X-Google-Smtp-Source: ABdhPJy6IqS7gOshU8Qr5KBFqpS51PGbHJ+nYnl6KfyYfJbg5JCF5wKRQYI7xby+MaV2xuRMPyG2eA==
X-Received: by 2002:a63:81c8:: with SMTP id t191mr7618894pgd.192.1636482587370;
        Tue, 09 Nov 2021 10:29:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oj11sm124195pjb.46.2021.11.09.10.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:29:46 -0800 (PST)
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
To:     Benedikt Spranger <b.spranger@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Bastian Germann <bage@linutronix.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, netdev@vger.kernel.org
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk> <20211108160653.3d6127df@mitra>
 <YYlLvhE6/wjv8g3z@lunn.ch>
 <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
 <YYlk8Rv85h0Ia/LT@lunn.ch> <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
 <20211108200257.78864d69@mitra>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1d589921-996e-d6b9-49f8-97e8a0b7fbd2@gmail.com>
Date:   Tue, 9 Nov 2021 10:29:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211108200257.78864d69@mitra>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 11:02 AM, Benedikt Spranger wrote:
> On Mon, 8 Nov 2021 19:01:23 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> If we would like to support PHY's that don't support all MDI modes
>> then supposedly this would require to add ETHTOOL_LINK_MODE bits for
>> the MDI modes. Then we could use the generic mechanism to check the
>> bits in the "supported" bitmap.
> 
> The things are even worse:
> The chip supports only auto-MDIX at Gigabit and force MDI and
> auto-MDIX in 10/100 modes. No force MDIX at all.

Yes that appears to be correct from my reading of the 53125 datasheet.
Force MDI-X is optional anyway AFAICT
--
Florian
