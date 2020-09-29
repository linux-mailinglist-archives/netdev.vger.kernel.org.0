Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3427D812
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgI2U30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:29:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728396AbgI2U3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:29:25 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601411364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpiQHbf0e7iFDIkjmKw/gjRWiP27u8yMbP5WylBiLEA=;
        b=E9HQoeyk+5Ie+Tor2NaXd+jrw2PEkMkMIWBrx9zqC6G3ilrDqzjKRk2RFF6MGJQdRq2QQN
        C5BWqCLrIU+AB7GCZ0AU51kYIMOl9e/nF7zUGq109/ssXR6geGrr5mgxmQeSpKoBq2ZbbL
        W+/T5td+HPcrzexhYUBZdgyfEWdOjhc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-tsLqNxJTNBe6Z97bTF5CpQ-1; Tue, 29 Sep 2020 16:29:21 -0400
X-MC-Unique: tsLqNxJTNBe6Z97bTF5CpQ-1
Received: by mail-ej1-f72.google.com with SMTP id w27so2413186ejb.12
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DpiQHbf0e7iFDIkjmKw/gjRWiP27u8yMbP5WylBiLEA=;
        b=OKnKVafXdVHfMSgEbolvhFmU4qBC01nja7/C6crvybgr03wvpUB+Kn35iMQWBuu+lW
         G6dBd793nMbdKNi8EZ1PdZfw7fuEeJjNmpakNx/mz7ea66PjDTbEkM18ItOOYATS2OLp
         UO8Ubc+a9NpgrKlpvgxTlrDJIaHuiMniLkRvfEIDfcEwdABZh5/x1hNhvRmoGRna1EoM
         OIK4mj+vpX/Jj2hN3xHIgd5V5N1xWpDN7gzvLo6BzXclKxTQX0gO1qTeARC+IigZ3+gL
         xNU0MnwL+xqwR6LkqfTwOqYZLRoe0Crefnz56XhTsOASDD3EE05Ve+/AacP0gjqqGJB5
         ikgg==
X-Gm-Message-State: AOAM5326O2cOc7dFPezXo5qar663RwZCoDh5goU2TUdOQIF917NuBaG0
        CaHBiK56OrAM323Gy7vMCqbZhKdjDSvnF8kjbRqEuNEM+RoKfP3WDde99mDLQ+tuer4usiq9r1a
        vqYG6UFKLeE2gA13N
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr5892504ejp.333.1601411359983;
        Tue, 29 Sep 2020 13:29:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWx79kTJuJPWlPlpZXqdIw0O/DCB/48FQt75Rsu+cZUxxVNtzgXNBvY/t+Y1QS1Tbb/qsTiA==
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr5892497ejp.333.1601411359816;
        Tue, 29 Sep 2020 13:29:19 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id p12sm6162778ejb.42.2020.09.29.13.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 13:29:19 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
From:   Hans de Goede <hdegoede@redhat.com>
To:     Petr Tesarik <ptesarik@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
 <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
 <20200925093037.0fac65b7@ezekiel.suse.cz>
 <20200925105455.50d4d1cc@ezekiel.suse.cz>
 <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
 <20200925115241.3709caf6@ezekiel.suse.cz>
 <20200925145608.66a89e73@ezekiel.suse.cz>
 <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
 <20200929210737.7f4a6da7@ezekiel.suse.cz>
 <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
Message-ID: <fd66b023-2dc3-954f-c55b-b03b51abb08f@redhat.com>
Date:   Tue, 29 Sep 2020 22:29:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

p.s.

On 9/29/20 10:08 PM, Hans de Goede wrote:

<snip>

> So I believe that the proper fix for this is to revert
> commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")

Heiner, assuming you agree that reverting this commit is
the best way to fix this, can you please submit a revert
for this upstream ?

With a:

Fixes: 9f0b54cd167219 ("r8169: move switching optional clock on/off to pll power functions")

Tag in the commit-message so that this gets cherry-picked into
the stable series where necessary.

Regards,

Hans



> As that caused the whole chip's clock to be left off after
> a suspend/resume while the interface is down.
> 
> Also some remarks about this while I'm being a bit grumpy about
> all this anyways (sorry):
> 
> 1. 9f0b54cd167219 ("r8169: move switching optional clock on/off
> to pll power functions") commit's message does not seem to really
> explain why this change was made...
> 
> 2. If a git blame would have been done to find the commit adding
> the clk support: commit c2f6f3ee7f22 ("r8169: Get and enable optional ether_clk clock")
> then you could have known that the clk in question is an external
> clock for the entire chip, the commit message pretty clearly states
> this (although "the entire" part is implied only) :
> 
> "On some boards a platform clock is used as clock for the r8169 chip,
> this commit adds support for getting and enabling this clock (assuming
> it has an "ether_clk" alias set on it).
> 
> This is related to commit d31fd43c0f9a ("clk: x86: Do not gate clocks
> enabled by the firmware") which is a previous attempt to fix this for some
> x86 boards, but this causes all Cherry Trail SoC using boards to not reach
> there lowest power states when suspending.
> 
> This commit (together with an atom-pmc-clk driver commit adding the alias)
> fixes things properly by making the r8169 get the clock and enable it when
> it needs it."
> 
> Regards,
> 
> Hans

