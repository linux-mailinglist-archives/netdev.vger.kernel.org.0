Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA7617F609
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 12:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgCJLRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 07:17:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36300 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgCJLRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 07:17:37 -0400
Received: by mail-lj1-f196.google.com with SMTP id g12so1336348ljj.3
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 04:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A6dBNnDbZxRBNYTgne41+K6xUdnapo51IRxQjhTVC2o=;
        b=jpbKN5CL3bLZEHPcvzxO79WRslCe6sZrx7vlIcf2IueYJlXx0OWDTNeepSvQ7qyloR
         jt6LK9jn8cmdOgTjRCp0V8XfiPnUpQr+fMjNwK/g2SPVShQRFsa7a1yMOpFQxbA2SZv3
         RmYZOUooncD7PkfqfUIAsT0po2zUpVT4XVlzzXhPU+XE28HIqMXSEOJwOWFW7y0rH+QC
         B37qPKkHV53Jzfjox5bgbHWN9NH051f6GjZNEVWzZm6v8gESiI7x953ouUURFzU6wsTq
         rV+l10FL1Wv7uDhJbFcDkHCfYV6+QPawVT3wN+gkfJ6QOFGOMaHzpkgqxXT/ufR/LHg0
         kBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A6dBNnDbZxRBNYTgne41+K6xUdnapo51IRxQjhTVC2o=;
        b=JZMZmfzjR3Gt8cRAsDa0aYApj8eqqfmOd1ZSdGDP7yBx79xmpKdZOpJ7l3ttFfY7u4
         mAp2xnKGVelXtu2EOnBLlg7HbacKRO9IsJvuZJjyy20lWubV4ZUKgomxY0Nx78NVCb9X
         xfTcPaaoZJW9lFIytieG32OLtrlziNFMn9ZinLBNce7V/p0wBWEJoT8YSCFpC8pCz4hD
         R/rDwOEseNygI5gcaOhr1dGOyxncb9HdlbUFzFNvUAuzcqJw9QwI9MlMuquPsDz83YXX
         U6wWmwCO0DOStHNabFrxEmw7q8nTcZPN9iZ2mFRIbaRMzisvbAU3sgvQJ8zi7IrwnIpy
         RotQ==
X-Gm-Message-State: ANhLgQ2/V0u2p0kwLyqU1j/zCAtc1PP1PigU0kFYskk7txV7FehW243f
        FsAglqXL7szwlkAUXIf4D73Ka1X2
X-Google-Smtp-Source: ADFU+vtfI4BgVInqIU2xbAO0+PF+ULFehiOEElsZRH5LZp3bqeLRKO8Cj7+z/uFe4lMAvbjxElvB8g==
X-Received: by 2002:a2e:9e16:: with SMTP id e22mr12819890ljk.220.1583839055358;
        Tue, 10 Mar 2020 04:17:35 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id y18sm23052696ljm.93.2020.03.10.04.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 04:17:34 -0700 (PDT)
Subject: Re: [PATCHv2 net] ipv6/addrconf: call ipv6_mc_up() for non-Ethernet
 interface
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        John Crispin <john@phrozen.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20200310072044.24313-1-liuhangbin@gmail.com>
 <20200310072737.28031-1-liuhangbin@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <451780c0-d70e-d9aa-5073-9a69455c9e11@gmail.com>
Date:   Tue, 10 Mar 2020 12:17:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310072737.28031-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2020 08:27, Hangbin Liu wrote:
> Rafał found an issue that for non-Ethernet interface, if we down and up
> frequently, the memory will be consumed slowly.
> 
> The reason is we add allnodes/allrouters addressed in multicast list in
> ipv6_add_dev(). When link down, we call ipv6_mc_down(), store all multicast
> addresses via mld_add_delrec(). But when link up, we don't call ipv6_mc_up()
> for non-Ethernet interface to remove the addresses. This makes idev->mc_tomb
> getting bigger and bigger. The call stack looks like:
> 
> addrconf_notify(NETDEV_REGISTER)
> 	ipv6_add_dev
> 		ipv6_dev_mc_inc(ff01::1)
> 		ipv6_dev_mc_inc(ff02::1)
> 		ipv6_dev_mc_inc(ff02::2)
> 
> addrconf_notify(NETDEV_UP)
> 	addrconf_dev_config
> 		/* Alas, we support only Ethernet autoconfiguration. */
> 		return;
> 
> addrconf_notify(NETDEV_DOWN)
> 	addrconf_ifdown
> 		ipv6_mc_down
> 			igmp6_group_dropped(ff02::2)
> 				mld_add_delrec(ff02::2)
> 			igmp6_group_dropped(ff02::1)
> 			igmp6_group_dropped(ff01::1)
> 
> After investigating, I can't found a rule to disable multicast on
> non-Ethernet interface. In RFC2460, the link could be Ethernet, PPP, ATM,
> tunnels, etc. In IPv4, it doesn't check the dev type when calls ip_mc_up()
> in inetdev_event(). Even for IPv6, we don't check the dev type and call
> ipv6_add_dev(), ipv6_dev_mc_inc() after register device.
> 
> So I think it's OK to fix this memory consumer by calling ipv6_mc_up() for
> non-Ethernet interface.
> 
> v2: Also check IFF_MULTICAST flag to make sure the interface supports
>      multicast
> 
> Reported-by: Rafał Miłecki <zajec5@gmail.com>
> Fixes: 74235a25c673 ("[IPV6] addrconf: Fix IPv6 on tuntap tunnels")
> Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

I'm really grateful for all your help. I verified this patch to fix
reported issue. Thank you!
