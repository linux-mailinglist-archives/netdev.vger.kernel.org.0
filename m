Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1C1B2E37
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgDURWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgDURWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:22:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F70C061A41;
        Tue, 21 Apr 2020 10:22:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e6so1638184pjt.4;
        Tue, 21 Apr 2020 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8hpKp+pJXXfl8SBiWG0TW18VKTy23Dsewpq1B1vdSJY=;
        b=hHejU0rMzhttmHS5vUp5pxh33T4JcOLWAypQy/fUBG1Apb8uDmoT95JSblrteDSZQZ
         xvsW0UucX/Cd9DvlJ3CUWNP1DVwSaKLC57uqNwXjCmxnaLw2h9rb63cY8Qru81Q3xPfp
         qycWLBWyS6iXfsbHVF6QW5kDGmo3eK3kFGUWu8tOw0xELURcixxqT5QqEC0kmsQ8TGJA
         aaQ/7AMUqeztG9Rt3V2WNzfAM13Yq/0JFY48yF+yH9+Ln9AV6t/QuF0PJiAzJj0LTbGp
         gUNQxqexoQzX98bfberRppzngChJQD+1qtFGtayUMb1XaRc7hdJnxJxYpzUZ4OvyhPOi
         ASXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hpKp+pJXXfl8SBiWG0TW18VKTy23Dsewpq1B1vdSJY=;
        b=ioGqQjjJPNOOD+J6/B0/NTYZ7SfhtKFIm7GshmwR7ufBdKailDuCJrVPy9u9Sg9S0d
         f2BjE2ovYfvyC70l/13qMXU0/6KBZNHZbIY+tTn0pHFLzEvt0aWETQ9OCkxmV0v+WjNi
         BvinRr/yeoE7623nuAodGdzw7T9CPtwKQOgJAkE8COK8lVtES+yYKFribbquQxONLoyV
         DnSVTvPS6IJPR/y/4t/s3QyGo59aYN7LkLmnzk92fhK/t2eTRpgGoKa97rjme0nYvpYW
         mw2rqu8LoXotSLpcaMw1j5GPTMJDuLeFQERzK9ii6LcIwgHgR6wUayyookB1E71vQEpa
         KAUw==
X-Gm-Message-State: AGi0PuaVm+izuinO6lsa2d/ztWJE1OYqbfzrNtGkgUhXKi4ycBh8nUjG
        RMH7qytEqRvzR6iprZ3+cXw=
X-Google-Smtp-Source: APiQypKtd8K22hCEJJdMxKo8xuqS7YFQ6JSbezNOUdnFWa3AHXmTV38tSA0y2M/IYGSVG2IKZcHLlQ==
X-Received: by 2002:a17:902:bf09:: with SMTP id bi9mr6325241plb.193.1587489725627;
        Tue, 21 Apr 2020 10:22:05 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k12sm2939328pfp.158.2020.04.21.10.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 10:22:04 -0700 (PDT)
Subject: Re: [PATCH v2 7/7] net: macb: Add WoL interrupt support for MACB type
 of Ethernet controller
To:     nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        sergio.prado@e-labworks.com, antoine.tenart@bootlin.com,
        linux@armlinux.org.uk, andrew@lunn.ch, michal.simek@xilinx.com
References: <cover.1587463802.git.nicolas.ferre@microchip.com>
 <bebb6e87da4be4b000c059351f3a4d82ecffa561.1587463802.git.nicolas.ferre@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <845410b0-f0fb-957b-e8ea-5a7cc2f152ac@gmail.com>
Date:   Tue, 21 Apr 2020 10:22:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <bebb6e87da4be4b000c059351f3a4d82ecffa561.1587463802.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2020 3:41 AM, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Handle the Wake-on-Lan interrupt for the Cadence MACB Ethernet
> controller.
> As we do for the GEM version, we handle of WoL interrupt in a
> specialized interrupt handler for MACB version that is positionned
> just between suspend() and resume() calls.
> 
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
