Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7244693
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfFMQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:52:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34319 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730104AbfFMDIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 23:08:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so10864065pfc.1
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 20:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vV5fKqGk+N2mytNHkWC1FMzq50T9li1RdfIOITLo9ow=;
        b=Lr8EbTN+b+BW3Bd/WW4kzCQY9mRRc8jDGhlZWd06l/B0Ai2wku4iP0P8xrTaObjiF/
         zd6evtW7/2UUz1JC9YvrZkrmyk30blPk51EHmh987sfbL4HjJ+iDQTdZ7dMjLKho3L8J
         w0nveA03o9XNeeaZzX9U2MeT+j6YBnStUf+Clz51/g/3E8p7yC+psxN/Z9zlmu3ylGvG
         FhB4El2kUlqTWDHTjUus9w8nE9mAKSBbazVrTBrg3TR1vJZZctKIhslaAfJ/nJPVP+bX
         4pt/KTIs9s2PvDKAojz/00ULP9ZbY/GwuxoCjxrIYEAjYF7+m9QEK0jQwdrP7Oc+4Asz
         jkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vV5fKqGk+N2mytNHkWC1FMzq50T9li1RdfIOITLo9ow=;
        b=R4VD0onQeqg1ZqWs255xceqO7xK9xC98WZcHfkwrk2EWHTHbDftho/sYmzLoxdosy2
         p0SgdjQljChFV8McQStaWg/wYyW3V79vz68h6QiyQigqIbL2YNdv+1bBDSzkTtb2q35l
         bAi8VP0cCi1V9SWJOk1iBdu5DfnL5upeJmWVWG0IKm4Cg/m7MwQFdjqFmK2LFLzdyemi
         5ABZtQXb4Ny7m0+mokT6xJNlYTutAftEZ2ohTZmDacPaDJftA8H0EW06qohvgqqSC7hw
         86MCJ/kVQfFoUATBFpE15VKMQE1yR/oAnUn3pbHFXbCD3wY+VLOXygiCxyboL0aohoWa
         +71Q==
X-Gm-Message-State: APjAAAU5KPEa1GAXB8L7HvFF8SfqG3Ez5JYlan0kzKC+sTCuIvZ0LaG2
        j5aaIj2WNTGN5lec3a85P/Q=
X-Google-Smtp-Source: APXvYqwFjs8J48ryBYp1XENnDtmoNJJGvOuqA7OWPyQ16P+o51cWlqnI9p6ujkQP+2VPs6tizhM8vw==
X-Received: by 2002:a17:90a:dd42:: with SMTP id u2mr2466499pjv.118.1560395322081;
        Wed, 12 Jun 2019 20:08:42 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id t18sm788491pgm.69.2019.06.12.20.08.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 20:08:41 -0700 (PDT)
Subject: Re: [PATCH RFC 09/13] net: phy: marvell: Add cable test support
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com
References: <20190612160534.23533-1-andrew@lunn.ch>
 <20190612160534.23533-10-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <c74f9b02-2e1d-8b85-d7b2-ad379df8601e@gmail.com>
Date:   Wed, 12 Jun 2019 20:08:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612160534.23533-10-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/12/2019 9:05 AM, Andrew Lunn wrote:
> The Marvell PHYs have a couple of different register sets for
> performing cable tests. Page 7 provides the simplest to use. However,
> it does not provide cable length, only length to a fault, when there
> is a fault.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
[snip]

> + 	bmcr = phy_read(phydev, MII_BMCR);
> +	if (bmcr < 0)
> +		return bmcr;
> +
> +	bmsr = phy_read(phydev, MII_BMCR);

Should this second read be for MII_BMSR?
-- 
Florian
