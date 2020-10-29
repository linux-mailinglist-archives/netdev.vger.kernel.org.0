Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2982629E2A8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391197AbgJ2CcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391155AbgJ2CcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:32:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD9DC0613CF;
        Wed, 28 Oct 2020 19:32:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c20so1087279pfr.8;
        Wed, 28 Oct 2020 19:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mqLBMUn804kzq/g2q8eLY4It+1PW5kRUpgSImGvwDbQ=;
        b=eT4NHrkev+V+xGYHye4Cij8mmpP2/V7wArRRmdI0QhdkS1RW9dEFLwnzRbcKmcYpDG
         x9EKST2A3O06uazrbiN0ZI9d1W4HaTEuPy9Q7kJoeWoFjNw7kLCMUxjca8vbecYppDoU
         CkhQRW8TKoeNYVQXSJvyEwdGi3uumSDd2O5Z77ZlZBBI0bdeAq7LHxqwZwMb1ZgepN9X
         j37a0l7zOhKvLXXOSzd1eBhud+n37lejEDYL/iJdcsNADfVGai1WFraQhydBJD7w2yyJ
         J9VczxiMZGHJMLHZOzRlvmleEAf7l34ulFfYAnvjT2t8jUQGaI585dO2gPHRzeNFtsDY
         S/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mqLBMUn804kzq/g2q8eLY4It+1PW5kRUpgSImGvwDbQ=;
        b=W+DNge5Xpoyqn2MDHpeeCxrPKXSHPMKKC/JDSHP0ketU1bZwJd8set4Y9CCQPluNco
         UiygvtMzfRCgxmcwciq6po99z3VWlOXv4VcXKJ3tulU8II8+szYYBH7WxvPG0QhigmKx
         RgjMpieS+lsHwgUTU0wdtsewyqzK+4fSzokjJMiZAu7cfYa8BieUQmNSByr93mXfAwla
         ycyBZkpufh3irAmbTcb77WwO5iG8+gdpq/l353vIZRLpPHezdF2A1wsczB05BTjN074/
         VXoazfAWFu54QQ77KasIWlg54vsl7XyWiT7GoklGQyjdX4rqZSSbwjAXgkkA2jrBnazG
         yA0Q==
X-Gm-Message-State: AOAM530kDx9rtpAa8hIr27WMbluY2KdJtd+ogEoGBOnsXsb0twDhwB90
        grvGY7xBGIxd4fqRpZE13lmqdgppDzc=
X-Google-Smtp-Source: ABdhPJzOewuByF6K0p995vrGgy8d1l9qpq1at7kRn0TD8FIU1sPH9vN3NOLz3aSigEaLBpZejjiZDg==
X-Received: by 2002:a63:e00c:: with SMTP id e12mr2022952pgh.441.1603938724316;
        Wed, 28 Oct 2020 19:32:04 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm924872pfo.11.2020.10.28.19.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:32:03 -0700 (PDT)
Subject: Re: [PATCH net-next 2/5] net: mscc: ocelot: use ether_addr_copy
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b0393a53-0624-069f-3ac1-165149a90906@gmail.com>
Date:   Wed, 28 Oct 2020 19:32:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029022738.722794-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 7:27 PM, Vladimir Oltean wrote:
> Since a helper is available for copying Ethernet addresses, let's use it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
