Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245FE1C4C9D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEEDSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbgEEDSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:18:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B022C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:18:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so403088pgb.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TzMeq4y87PqFi2c+amULC4eWXiD8MVZ6p0wJ+ywOgdY=;
        b=Rg1HuNAfClBNvFJBno3xrJVoQIaqr5pXPz/zZOS8Khn8K+JHf6x8+SldpZCUKjPa/C
         wVu8sCRdfHhW3fuENY8sPqjl2fc/siKhrNSDahhQ4wz316V5jy6JJU25fkSNLzO4BuWC
         GHK4Zk4qqMdrm8SLYzWHYlKs5sRwO58ua+e7t6yfm0zNPIbNjI1hYksP0/xmbSxBNXC/
         hpx7d4+dga7S41un7pzsOh96FKVfG/lEYyIvAA3YX4fqpxekHL6BbNz2JH8f4nubMo+b
         u4Ae8dSZdV2HbZJ99ig6zUVO8gEsGG4QjmTHFzwWBnCx3kJ3C257d1ZE9OBJEnMjUWO5
         KekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TzMeq4y87PqFi2c+amULC4eWXiD8MVZ6p0wJ+ywOgdY=;
        b=ES7CclIYGeSUl6hl9O9Vy/0pGGt6Ie47Oh7HI7WRXjNfCNXW5GhbC2NaEmHiQWGFQB
         eqNqAl69brxeHtOqA+vrYcpBGu+EeVFuWp77PgFKH2sAFhPxlS2/dCY2O5SCRnA9Zvzg
         GnmOS3vZ/X2ot93SDwjvD/3o9WSRska2fqCnKFvzuT+GV/xBMosikdNtFx4c1bmn23r+
         ihv4BRWMJU/ZPRGXM0olZu++ceuejOmLeVKdnx99TJ6QVXTmh030wUp1c07RF6oEzgJO
         qsJIxGXTQRD/ctdlnSR1rXPFshUNJjDIefOAyb7MzGK/ax+GYh4Wyk9s+13+0RZiua23
         BcgA==
X-Gm-Message-State: AGi0PuamdbhwHcwBC/dV1ThaVlwITS0RGza2EETv6GpmUrG2W0SbrEkP
        SzEUGpno+J4OGsYGFtzQV7M=
X-Google-Smtp-Source: APiQypKG8/Kh0mrC3bbejihKc1VJOzVNvVnlI48PolK4hJWANwKVuVP3zXhOR9nuZGxqroc3+8dK+g==
X-Received: by 2002:a62:a10c:: with SMTP id b12mr1218138pff.14.1588648732625;
        Mon, 04 May 2020 20:18:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 23sm372005pjb.11.2020.05.04.20.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:18:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 03/10] net: ethtool: netlink: Add support for
 triggering a cable test
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f2fa915b-d202-6ca5-a341-9ee96300c07b@gmail.com>
Date:   Mon, 4 May 2020 20:18:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Add new ethtool netlink calls to trigger the starting of a PHY cable
> test.
> 
> Add Kconfig'ury to ETHTOOL_NETLINK so that PHYLIB is not a module when
> ETHTOOL_NETLINK is builtin, which would result in kernel linking errors.
> 
> v2:
> Remove unwanted white space change
> Remove ethnl_cable_test_act_ops and use doit handler
> Rename cable_test_set_policy cable_test_act_policy
> Remove ETHTOOL_MSG_CABLE_TEST_ACT_REPLY
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
