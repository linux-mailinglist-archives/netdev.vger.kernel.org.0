Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14602098BA
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 05:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389678AbgFYDHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 23:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389589AbgFYDHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 23:07:15 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E6DC061573;
        Wed, 24 Jun 2020 20:07:14 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b5so2333817pfp.9;
        Wed, 24 Jun 2020 20:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RszMRaJs4GLOaKBq8crvVGuarUh11RKxbLVteBe4oMg=;
        b=AYsVPOT/fkPaB6gQZ+Jy3TJpARKqqLTQbaDNIs10JYf8AoA+nH8BeUEpSh8rkJGaRV
         6YY3qNRS6u2GKHXF9TLID0Qca8979HtsAY07D6QKUF8fnaYWlbOG4hfvGOKiFMZOvRUF
         h9VEm3vGk+JK83R/zujpn5jdtMg1iOvfz8BQ1W6IKeW1jO+Z82XAx+TTahKobDJYJljF
         KjPV4OuE5hDq0zwoyqXkdpkXCv/qL9nJavPNdzOlL2/2K1sapPkQHSFNaDEJb1G0g0+G
         Bptg2ZLrJXBCPUSjMEd/qRUjgeNKLCme9jHaQMKOJl6qhJPishchMh8h8BNXQvQgKMaA
         9twQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RszMRaJs4GLOaKBq8crvVGuarUh11RKxbLVteBe4oMg=;
        b=tPZ3uu77UVsw8yGMr6CpWSfMVx8VGNs/fiZ5vmWNwGxcM2BOjvV9tkN+UQ1THCckPF
         kXrhowmX/bsDKQ/wlJf4oyOo65OMui7DBGIIDQSuWXBcOGCZeeGeQ0GKCf0JUNqEOgC/
         UzbgTbjGUgguCqZlNagwONd6PPdkqiSIzJxCO9lZi2p9f3EUOuv5ybhZKxd1Po9EVxgc
         e5ScYceT3gInBaDacZK38lBu5QrCHxYhtDA75NRy7jzQiJBO8XF4chffpD1NJV4pwo6W
         ldzHyqNQpZn7Ahx/LvU0y7WroJGV1zAbuPAWFItVjoqaddn2vMYYwxBHprbVUJNXCJ8s
         qtag==
X-Gm-Message-State: AOAM53306PLRGOj2ldly0/CXEdhsOvyunZYD0CyKjS97HisGGNn/4F4B
        PuKfeJTXoMlYhDx6vWqPcxdO+/9I
X-Google-Smtp-Source: ABdhPJzN99QbMJ2D/D5A3j79AQ5i6FOqbqp2jEmn68sCGzWTqtoyhEVFfSh6X6eaYLa2G/h9i4lw4Q==
X-Received: by 2002:a62:140f:: with SMTP id 15mr4987963pfu.50.1593054433674;
        Wed, 24 Jun 2020 20:07:13 -0700 (PDT)
Received: from [10.230.189.192] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k28sm2173921pfp.82.2020.06.24.20.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 20:07:12 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
To:     David Miller <davem@davemloft.net>
Cc:     Jisheng.Zhang@synaptics.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200624112516.7fcd6677@xhacker.debian>
 <20200624.144309.110827193136110443.davem@davemloft.net>
 <7a71ba71-b6cf-653d-967d-b74f930a69c5@gmail.com>
 <20200624.163437.878978558101234300.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8555bfc0-7882-95c6-4cfd-e9d879a96d38@gmail.com>
Date:   Wed, 24 Jun 2020 20:07:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624.163437.878978558101234300.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 4:34 PM, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Wed, 24 Jun 2020 15:10:51 -0700
> 
>> Did you mean that you applied v4? It does not look like you pushed your
>> local changes to net-next yet, so I cannot tell for sure.
> 
> I ended up applying v4, yes.
> 

OK, just making sure :) thanks!
-- 
Florian
