Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DA84716B1
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 22:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhLKVUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 16:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhLKVUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 16:20:33 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9695C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 13:20:32 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id i63so18508962lji.3
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 13:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=JaocXw0bybBaCqH0a5hMGxGgJ0VOh2c2IXv8RX/Z9ek=;
        b=qs8/6TDXCiYtGvrQR7vnkMLhbkOnlGysLhX/Wk1QY8618rzUf4r+HO8QseZ/TGPD9x
         IpKz8E084ywqR4t/SPIMWNZkHhAK1QewM+xOsDGjrvnpua1e0kMLpt6XYftcKEQnoO1O
         WJa5pork/gOYdtRkw4ZDiA05t5DH1zCV/q7ERhM2LnkW3a6sl7T7VmvhOsx8LITyicfy
         tmmFpW8jPbf3pN2orA/lYGcs/HHHw20gLpDCzp4VAOxAR3t61O9A4ERK8y8zKtY9WOFW
         Glwh2qk+b6rtP2IfeOfmdNIB4pTi1X8bAjrVeeX/mmBFREsaOUT/+i4FtIEA41M0NriE
         6eKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JaocXw0bybBaCqH0a5hMGxGgJ0VOh2c2IXv8RX/Z9ek=;
        b=aEffF6PfcQSyXZboxZk3a0rj1+7Ts52kBAipGQNx+jrVLtIH8PyaAHqShnuQUPi+50
         cj4l03MW/IFfJxCy9AqqO7MaO6wbRnVXjhyaXxQ7XRjT5RQOlX6krLKPwBo3jqyoDHgD
         40LroGnFZBrYDoNHEIzeESKPiMvssugX2t219kYe7E7foVRLa+bZxxRG8g4rSJWfuote
         RFOuKdFzHv6zDHam7+1VTXTv6DyDQPh3a3r587PeDQaVldc0nycSo5cDJeYqlAn+dk5r
         pLocerr0AoqHjcfjaTUp7Cjqrt0yKkkC81PfZjvujMLp3GwEUjzTVZ5joHmFle8PYgUF
         EYDg==
X-Gm-Message-State: AOAM530k76h8DIeaW1SyiIVPiz494SCeNn7zWLXtFHkwRu7KWQYlmIJ0
        40B0T+zwP5M5McjOkHdrgPvGIX74sDoEbQ==
X-Google-Smtp-Source: ABdhPJz2zm7zi9utaKTYC3AHSGiov8IuNBVYUYOBMw8AWuHzkV0Y3TgwYr70DEoRxOlw42zNmJ/GqA==
X-Received: by 2002:a2e:6e15:: with SMTP id j21mr20584431ljc.195.1639257630640;
        Sat, 11 Dec 2021 13:20:30 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id x199sm761821lff.284.2021.12.11.13.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 13:20:30 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on
 intermediate devices
In-Reply-To: <20211210211851.6b8773e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211209222424.124791-1-tobias@waldekranz.com>
 <20211210211851.6b8773e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 11 Dec 2021 22:20:28 +0100
Message-ID: <87v8zu2603.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 21:18, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  9 Dec 2021 23:24:24 +0100 Tobias Waldekranz wrote:
>> In a typical mv88e6xxx switch tree like this:
>> 
>>   CPU
>>    |    .----.
>> .--0--. | .--0--.
>> | sw0 | | | sw1 |
>> '-1-2-' | '-1-2-'
>>     '---'
>> 
>> If sw1p{1,2} are added to a bridge that sw0p1 is not a part of, sw0
>> still needs to add a crosschip PVT entry for the virtual DSA device
>> assigned to represent the bridge.
>> 
>> Fixes: ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT")
>
> Hm, should this go to net? The commit above is in 5.15 it seems.

Since there was no cover letter for this patch I put that motivation
after the commit message cutoff:

    Though this is a bugfix, it still targets net-next as it depends on
    the recent work done by Vladimir here:

    https://lore.kernel.org/netdev/20211206165758.1553882-1-vladimir.oltean@nxp.com/

I have patches for 5.15 but the implementation is completely
different. Given that (1) multichip devices are pretty uncommon to begin
with and (2) that this configuration is also rare, I thought it might be
more trouble than it was worth.

Let me know if you want me to send that too - but independent of that, I
think this should go in on net-next.
