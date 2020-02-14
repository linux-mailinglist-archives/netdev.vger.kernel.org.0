Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214BE15F8E3
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgBNVp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:45:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36019 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgBNVpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 16:45:25 -0500
Received: by mail-pg1-f194.google.com with SMTP id d9so5597405pgu.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 13:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=X3k++zPE+sJUaSkRsR90u7Z+waK86MTRLdYHtDYo8Qc=;
        b=TGx6y5fUThAzKiGPPrR1HboWlMJPoX8PWImpJR2kFuB1x16oearTlMiGq9UDt+pzef
         cpJ62eFdDnZww/gDwXGJx8uAQ7rHWPRcmgBGdVwwLWLCkbI6cW6rgD8Rid8XMTKfsKu8
         sjAwaKbDNN7PitVT+CfYr7pBMcCIBhvEJLL5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=X3k++zPE+sJUaSkRsR90u7Z+waK86MTRLdYHtDYo8Qc=;
        b=UbTYr6PtUtUYxW90JI55ZsyEkVnddjg7K+YZnYOZVHoTp3BYmao6WMRQCwTaiJNPzs
         udh3Q0H0OQAQY0eCiGDGdNgsDHtE3b6qq/5a4wknN8Zs0sY+tgoPJWMbsc/8haA+OeGk
         A6Zsolw4Rkh12xzfI9NFrmKQOpWmEEA7cS6JjhEfAWrnaqnb7fJUPSbHb/36nAC2IbQM
         E0YFzVi4ArGcMW1jP86uo3u0tbuG+c0bFTXals2w5kxDDxW0vV9mnHNJwPlb+MTeEiwV
         wY2aeJJlq1h4xosRudA7gVc4+/QxmusUtP4wn5iS7Hg0DoUqPsuNmM4HjrR9yPQdmDGa
         o8ww==
X-Gm-Message-State: APjAAAX0KAyDyzExy3zMs7rDVsQ83f6dOgKexwxIU0xPaJ5wJ09jvkle
        uj0m+Ktxvzg9QOKKP0H1DKTmuv9WwyFjJFlL
X-Google-Smtp-Source: APXvYqyzZJJFq1c38QhMNLslqHWYMOZuNFRjjazVVBYOiWk75QGD9U6hjRqAr9JRahny+PHXEzOwww==
X-Received: by 2002:a62:16d0:: with SMTP id 199mr5436500pfw.96.1581716723255;
        Fri, 14 Feb 2020 13:45:23 -0800 (PST)
Received: from [10.136.13.65] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id m128sm8165821pfm.183.2020.02.14.13.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 13:45:22 -0800 (PST)
Subject: Re: [PATCH] net: phy: restore mdio regs in the iproc mdio driver
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20200214194858.8528-1-scott.branden@broadcom.com>
 <20200214203310.GQ31084@lunn.ch>
 <2b0ef4fc-c3a1-9aeb-2e86-31e9de7a19eb@gmail.com>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <5ce01f06-c116-06f1-d60b-549024cc8864@broadcom.com>
Date:   Fri, 14 Feb 2020 13:45:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2b0ef4fc-c3a1-9aeb-2e86-31e9de7a19eb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-02-14 12:37 p.m., Florian Fainelli wrote:
> On 2/14/20 12:33 PM, Andrew Lunn wrote:
>> On Fri, Feb 14, 2020 at 11:48:58AM -0800, Scott Branden wrote:
>>> From: Arun Parameswaran <arun.parameswaran@broadcom.com>
>>>
>>> The mii management register in iproc mdio block
>>> does not have a reention register so it is lost on suspend.
>> reention?
> Retention presumably.
Yes, typo.  Will fix commit message.

