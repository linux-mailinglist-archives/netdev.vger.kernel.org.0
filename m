Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA92744A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfEWCNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:13:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41528 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWCNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:13:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id f12so1958926plt.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ZHlWro+R7vJaaVo2VdfVIHxxdcC0403PrTMRwaSXwU=;
        b=uDnHZ9pZq6iu8GgGizEJpEveHjYEBvkYNIVYEgfeXyXyK+tgb56zsyAfyIl9Pmxtp5
         VPsMDphVRorj5RZWsMIrIAf16zi7LvDeP9lHDCEU8P5za3XqbZ+EL5/42uRlgpSUUAFM
         NqDr10w225TbrR7Zwkpq5XEEdkT+rqeqaB+zi39wRca54pIihpu8wEMqFP+Pur7x4/tP
         VsQutjDgdvqgB6sJ5eIu7xKmoBjiTDJ7ju5Zp6lQke2hz1hCy7kuxZtvaeJEtVUQaWfW
         V/7bemFIq+peDOrvq69V1ErFLaxVsF0uqly3fZAbg7jyrjaCkg+oMzWbdauSTqR/oTsp
         08OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ZHlWro+R7vJaaVo2VdfVIHxxdcC0403PrTMRwaSXwU=;
        b=j3ZZmSOLQ97p+G4vaLarrdSYbbWnxja7b+NEFbw9EX7gHwgcLribDcd+BQxrAF27Xh
         97x2pT7IdF0IsRCS5QbETCrsWNrkfEXXSgSBAqo359WCch6F8nhnFHOfpCoqt/UT7Oe3
         Fqlv2eeUTNXw5CBzeyZ5TOZvT3f+Bx6LkIRHPZA5IEuphAa7bPZHSv+z3ZGgx6FhuWq2
         Du5GdxADXF8PZO8ukv01kWy3L2hDPuTkfBc+Y2QndyVIj9io9IJcj2MgLSfVELO5rAx+
         gD3uts8M4v/vhOH8DWoiNEvAo7xyjJ+0JRhiy3+u8Y9sS67Rd0InbyiW39U6LHRuFzSm
         ULVQ==
X-Gm-Message-State: APjAAAWYCITwb3FpGbmrZ3MD9oQuYdniWB2aJuBfdcYbZ1o17/DtEL8t
        GP/tx0DAJDYSS3U9W9bttn21AzV4
X-Google-Smtp-Source: APXvYqwua1LTcmNQAusdCQQnTi+7WTyz74/z+n3VXXOO8vQYikRW7/v2kX/+mT8nPDK28DqEz6K9Mw==
X-Received: by 2002:a17:902:8ec3:: with SMTP id x3mr39017004plo.340.1558577589048;
        Wed, 22 May 2019 19:13:09 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g71sm32437923pgc.41.2019.05.22.19.13.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:13:08 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: Move the phylink driver calls
 into port.c
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-8-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <cef9c200-4bbd-db3e-1e28-f7cf16df0faf@gmail.com>
Date:   Wed, 22 May 2019 19:13:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-8-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> In order to have a common handling of PHYLINK for the slave and non-user
> ports, the DSA core glue logic (between PHYLINK and the driver) must use
> an API that does not rely on a struct net_device.
> 
> These will also be called by the CPU-port-handling code in a further
> patch.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---

[snip]

> +void dsa_port_phylink_validate(struct dsa_port *dp,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->phylink_validate)
> +		return;
> +
> +	ds->ops->phylink_validate(ds, dp->index, supported, state);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_validate);

Those exports should probably be _GPL to follow the PHYLINK exports but
other than that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
