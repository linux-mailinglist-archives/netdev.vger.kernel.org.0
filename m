Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1302744D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfEWCRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:17:08 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39788 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWCRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:17:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id g9so1973695plm.6
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pe211EJ4KpxI3pFIcKkFWxPfP7zNBXaibLXIwFj9bvA=;
        b=i+f1kLwIzifWgZaB9wfh6vjb32pvYqm458mTnpWmB2/wgp0rFEzbYAHv115uLztmMQ
         4ngK/ErbR3Of5cwVFAhDJXFVMV9o0KL7sqU/94sAh5xyOzdF6rPnRvMyGnZ+pHJw0Oob
         BIk3+dtmtEvXqHqxOuzHuAAMAQpb6QwGEXSxYSyxsT+ZqtBVIWxMOjT8wPV8HugYTinC
         OhDk7No3x5esIAQXn6oRuWlnFak1XwlZ0A1eEhruUMjZvoxVD+UCfc58QSLedb0c2R75
         pgxYG0ym9gFZszz68rWLi3R0Wh5DONh+2UfhILsZQD8B5lV8bQkIDiRXPGOc86g9abdz
         /9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pe211EJ4KpxI3pFIcKkFWxPfP7zNBXaibLXIwFj9bvA=;
        b=qCjfVGlLJBPgQ93O3GuKdWprwYnepeC8eQ/Y12sJ46Ir+XMFMVyO3G6Ta9Jyp1RMII
         eiKHSFktiGuzU2GeuOuYXDMW5uWLqiSU3VpxKEvX7NTHF+ZR0yGE9Sx25RT8nV4Wu7wr
         ZjZJyk7V7bu5MDv1cURESZNgk/aCquK9P7IvZJWK25/R1juEMxHXwz+qH/lWHttrh0Ef
         5IwlO+girIf6FMv1B+UAbyUk9YpxU1ZOKCWHAPwpz18iMbvLLSYtgJbX92Xhzseh83bt
         8n+H7ecSWMdKRJ4/kSbcM1Db/s8AGU3U5cKSXgz0QXnIwQTFIXht4B3hvae5Pn6nre9/
         ukxA==
X-Gm-Message-State: APjAAAVNDrRvKPfIop2XDAOvZJZp2EViS6++ygxoDCmUY9dvn4rpYejZ
        QPJ0t96R624oaAku/SRTVaw=
X-Google-Smtp-Source: APXvYqyFdmJuwA9aqlSg8nucLehEhl9ntxDy7ptb3adXTkR2oD4u1lfd7CCVLS4gFur8zt39Wcv/tA==
X-Received: by 2002:a17:902:e7:: with SMTP id a94mr69354534pla.182.1558577827576;
        Wed, 22 May 2019 19:17:07 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v16sm12171021pfc.26.2019.05.22.19.17.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:17:06 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 8/9] net: dsa: Use PHYLINK for the CPU/DSA
 ports
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-9-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <9c953f4f-af27-d87d-8964-16b7e32ce80f@gmail.com>
Date:   Wed, 22 May 2019 19:17:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-9-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> This completely removes the usage of PHYLIB from DSA, namely for the
> aforementioned switch ports which used to drive a software PHY manually
> using genphy operations.
> 
> For these ports, the newly introduced phylink_create_raw API must be
> used, and the callbacks are received through a notifier block registered
> per dsa_port, but otherwise the implementation is fairly
> straightforward, and the handling of the regular vs raw PHYLINK
> instances is common from the perspective of the driver.
> 
> What changes for drivers:
> 
> The .adjust_link callback is no longer called for the fixed-link CPU/DSA
> ports and drivers must migrate to standard PHYLINK operations (e.g.
> .phylink_mac_config).  The reason why we can't do anything for them is
> because PHYLINK does not wrap the fixed link state behind a phydev
> object, so we cannot wrap .phylink_mac_config into .adjust_link unless
> we fabricate a phy_device structure.

Can't we offer a slightly nicer transition period for DSA switch drivers:

- if adjust_link and phylink_mac_ops are both supported, prefer
phylink_mac_ops
- if phylink_mac_ops is defined alone use it, we're good
- if adjust_link alone is defined, keep using it with the existing code
but print a warning inviting to migrate?

The changes look fine but the transition path needs to be a little more
gentle IMHO.
-- 
Florian
