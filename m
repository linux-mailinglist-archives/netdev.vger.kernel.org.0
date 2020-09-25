Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3CE277EC2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgIYD5n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Sep 2020 23:57:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51526 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgIYD5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:57:42 -0400
Received: from mail-pf1-f200.google.com ([209.85.210.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kLerb-00078q-Vz
        for netdev@vger.kernel.org; Fri, 25 Sep 2020 03:57:40 +0000
Received: by mail-pf1-f200.google.com with SMTP id h15so1051178pfr.3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 20:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1LdherrVFx5eJRxgEW9+dGdwxO9PmjDU56jtqG1BEPk=;
        b=lm/YXsXv8JXLjqoREzfMBaS5xtyIEzXHnArIn+mx7TG83UxVceGMe1wRZh9gPrDyB4
         vq0B5XRNK17ukywtwCdsDpl2zTtapKjcNyibxeUc6QKlocvqEBEVoAoBZF9OfosJInrr
         1p48ZTSHixUNZkLLtBFT0v25iM9R5LfquId4GJe/dWvSkN9iQMsGYgE83sFCRWx7D75s
         /hSvhxASkT+2yNEJwSCmRosy6Be/LdRvtAUMc7SNKufElLZYbcTnV0Bs/whowxRshkgf
         6ZJxsk9CLyPYbPgQp6xm+PmlZ7sGg/I64h0WpXIdmLBC5Whh8K0kXOdYR0VHAqHmMmJn
         whqg==
X-Gm-Message-State: AOAM532HaZZws6Sj0puQE+kKK7knOmD5MORfJXYZtvFdjFjUzvdnPVhV
        AFHCe2mRdycndjzHSXau8rUnwqBtX0e1h80UAR20ve0Ml8oXQoBLy4GzSkPDsu2UzZwHaee3vBh
        /NC4SsX4JCwEQtvJIzeGhNblMgm0pCX17nQ==
X-Received: by 2002:a17:90a:ec06:: with SMTP id l6mr849222pjy.66.1601006258428;
        Thu, 24 Sep 2020 20:57:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7pLxjFzkzosFKtVxO8GnnwK1Fol9HRjQArB4CvcP1EqjBodisTZUbT0khBqkmqeNntbJ60Q==
X-Received: by 2002:a17:90a:ec06:: with SMTP id l6mr849204pjy.66.1601006258035;
        Thu, 24 Sep 2020 20:57:38 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id gb17sm627128pjb.15.2020.09.24.20.57.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 20:57:37 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3] e1000e: Increase iteration on polling MDIC ready bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200924195719.GF3821492@lunn.ch>
Date:   Fri, 25 Sep 2020 11:57:34 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C35CA226-13B9-4116-92F8-01E1AFDAD821@canonical.com>
References: <20200924150958.18016-1-kai.heng.feng@canonical.com>
 <20200924164542.19906-1-kai.heng.feng@canonical.com>
 <20200924195719.GF3821492@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 25, 2020, at 03:57, Andrew Lunn <andrew@lunn.ch> wrote:
> 
> On Fri, Sep 25, 2020 at 12:45:42AM +0800, Kai-Heng Feng wrote:
>> We are seeing the following error after S3 resume:
>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>> ...
>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>> 
>> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
>> increase polling iteration can resolve the issue.
>> 
>> The root cause is quite likely Intel ME, since it's a blackbox to the
>> kernel so the only approach we can take is to be patient and wait
>> longer.
> 
> Please could you explain how you see Intel ME being responsible for
> this. I'm not convinced.

Some other occurrences:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d17c7868b2f8e329dcee4ecd2f5d16cfc9b26ac8
https://lore.kernel.org/netdev/20200323191639.48826-1-aaron.ma@canonical.com/

Of course we need an ACK from Intel this one is also related to ME.

Kai-Heng

> 
>      Andrew

