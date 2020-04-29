Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91B21BEA1D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD2VnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgD2VnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 17:43:08 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD22C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 14:43:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so1729828pfn.5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 14:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=T67WNgTMzvTt3GJ7PDxrbZ1QVsxyhsx9C1KNCU8HR0g=;
        b=TZ7H3X35392CG5iVj2iZDRmAkkm9C+BtrdLL9Ct7rtEPz26YtIvVA4hxRASYE8upaP
         FDgqJyZgj+BfbgWjxwQ93bCzA53MZELE0dIx/3SICd07OPdLFqvw4W5HmkslXzRuOnDU
         hcXid73pDGEQzuw1TFgw4Iyce+wFJwpBfmpKrf3pALmVfH5AAdyAS0n6mmAZL/+nxxIb
         ypno0T8BicKDu9tJz64lQHVyeevshdMfEVVKvhXMKdCZ1Y0G/dsLDjaP69kWvZwZCoaT
         DMxDo1I6QvFi86B45OGhDkn+kyGI548SflJ37Uf9QPzINsRI+2O0AoWRpx0b9gb4I6c9
         MoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=T67WNgTMzvTt3GJ7PDxrbZ1QVsxyhsx9C1KNCU8HR0g=;
        b=Pww7MXdrFisgy8eebIhoBcuOByxIuFk8QuiBXWBQH44L64P7l9uPLPJ2FXVr2RU7Li
         9iRscV/rc21zQFTpyGvlci0kGqUw2/eDxHt+Xdtr0Rq37DxzAJg/rrTlsDOk6dHZjIQL
         0HsAf/XyhlW7XDlX27ydqNgRLvkXP/1PbNWQ9IBrqYsIGljwnXy7uLIBoQIv+N8eayhp
         RMAHGvwMci+XBz3xeAWlXGl/Don9bEZFze6cE2FineZHN1hJHmXG8I0HPzae6SnZubmh
         dkv7bFSEu1HYbgZuI9CMcaaMYKa4tYPNalZwrj8zlPj1JmUaimD8fpo6Ap9QuOiKkqeA
         C0vg==
X-Gm-Message-State: AGi0PuZ2/gUjbMaFmUk1yyoOgkokHpYHgO9+B4mf3BXo4EVZBJWp2NUL
        20BL+44ewR5b4/5UZ7YQE2BpIjDpEd0=
X-Google-Smtp-Source: APiQypLe+XxPgMFqenOtPxh7+bOl/SzU5eV/wTevVpuNoiZ8mTzh2QkhZ2tXF+gPlIclRD76dYC1Pg==
X-Received: by 2002:a63:6847:: with SMTP id d68mr250785pgc.56.1588196586153;
        Wed, 29 Apr 2020 14:43:06 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id n19sm1700506pgd.19.2020.04.29.14.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 14:43:05 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ionic: add LIF_READY state to close probe-open
 race
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200429183739.56540-1-snelson@pensando.io>
 <20200429183739.56540-2-snelson@pensando.io>
 <20200429.123858.1029931066495916083.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f1ed7632-618f-bd7a-0dcc-eecb1c0b9b55@pensando.io>
Date:   Wed, 29 Apr 2020 14:43:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429.123858.1029931066495916083.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 12:38 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Wed, 29 Apr 2020 11:37:38 -0700
>
>> Add a bit of state to the lif to signify when the queues are
>> ready to be used.  This closes an ionic_probe()/ionic_open()
>> race condition where the driver has registered the netdev
>> and signaled Link Up while running under ionic_probe(),
>> which NetworkManager or other user processes can see and then
>> try to bring up the device before the initial pass through
>> ionic_link_status_check() has finished.  NetworkManager's
>> thread can get into __dev_open() and set __LINK_STATE_START
>> in dev->state before the ionic_probe() thread makes it to the
>> netif_running() check, which results in the ionic_probe() thread
>> trying to start the queues before the queues have completed
>> their initialization.
>>
>> Adding a LIF_QREADY flag allows us to prevent this condition by
>> signaling whether the Tx/Rx queues are initialized and ready.
>>
>> Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> I would rather you fix this by adjusting the visibility.
>
> You should only call register_netdevice() when all of the device
> setup and software state initialization is complete.
>
> This improper ordering is the true cause of this bug and adding
> this new boolean state is simply papering over the core issue.
>
> Thanks.

It seems my impatience to see the Link Up message is a problem.  It 
looka as if I push the link check out of the probe thread and let the 
watchdog discover it later, all is much better.  I'll followup with a v2.

sln

