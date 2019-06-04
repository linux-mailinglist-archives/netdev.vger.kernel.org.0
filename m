Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E21350E2
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfFDUbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:31:18 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:38473 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFDUbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:31:17 -0400
Received: by mail-pf1-f177.google.com with SMTP id a186so12676032pfa.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZsgMFONiVfdPOcu1gytSVjl67JQ44Kfo5GzCrRDGW2s=;
        b=cSo7UgENw5e/CcstkyW/L+mtAIie5U7tNh/Uu5PoREBrhl0VN9Mljk5MiBLEXYkXlZ
         QxqRNZnIR6gLDbb46FZGNhLeFEJRxEe3z1CQZMMQ0/4b/eanC5dup+jmpJJNgVvBrPoZ
         +rsWXtf8+JGDitBZgDZm39rWhbROUjmckdagAisyEw6BxxX7q9YK/gduIqKmvILlgLM9
         soLS8PR2N6+RztKlXqV+b8gXCx71oCDXTas5pR+eznm/sWgaymlyL+QazgU4GS46sL5C
         zHRYTTXIs09L1vCpSCg/QCKePemyyGRINX+8IWhCbJVYQps5PN2oo32rslc5ZUoFxRZf
         Eq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZsgMFONiVfdPOcu1gytSVjl67JQ44Kfo5GzCrRDGW2s=;
        b=XKYUk4F0e9fqD8U3GhrA77+LIaL9TXdutijz75h7eY9nyhVANJreXXj7l+EEbutlbj
         txTO/UNt0wDE2Ts9PTrRLQgq7Arpxe8CSkurk/ozEDivJ4GbymvsG6MMBMN5ssLvu58s
         rUlYBBbTB4CK54tJkxORZc9oVBXeceAFop8tjENPoFOL+BXHBusYtwGDzKv2RbioYPXf
         FIu7qId5XkEHOgZtY8whZ5tACKmLZ6oSzN7jW0LRadQ+9cpUWAFeArtyb6cNXTld9BRH
         B3KlQjzQdrf5gm86G7d/Y7cnBli/bvEah7lNF+oepsZSWT7oqN9IkZcHkGbXRXdXE93d
         Gx0Q==
X-Gm-Message-State: APjAAAXBY1xFOsL4wK5ePUtaye8E82Yeuyng+giUAUzZ4HvU9SV7D0Qv
        Tn5a/igLWvOIOAayoDk8SBQ=
X-Google-Smtp-Source: APXvYqyazo4D/X/Ka6hFWPbws3hlZRipi+VfGS3HpW8mTSHjvqrBLF7q11IDvl9TOVzj7xVHZMwDhg==
X-Received: by 2002:a62:5252:: with SMTP id g79mr4934283pfb.18.1559679949571;
        Tue, 04 Jun 2019 13:25:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id ce3sm7051161pjb.11.2019.06.04.13.25.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:25:48 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Vladimir Oltean <olteanv@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <3a408f0f-418a-918d-bc9a-29085cdf1636@gmail.com>
Date:   Tue, 4 Jun 2019 13:25:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 12:58 PM, Vladimir Oltean wrote:
> Hi,
> 
> I've been wondering what is the correct approach to cut the Ethernet
> link when the user requests it to be administratively down (aka ip link
> set dev eth0 down).
> Most of the Ethernet drivers simply call phy_stop or the phylink
> equivalent. This leaves an Ethernet link between the PHY and its link
> partner.
> The Freescale gianfar driver (authored by Andy Fleming who also authored
> the phylib) does a phy_disconnect here. It may seem a bit overkill, but
> of the extra things it does, it calls phy_suspend where most PHY drivers
> set the BMCR_PDOWN bit. Only this achieves the intended purpose of also
> cutting the link partner's link on 'ip link set dev eth0 down'.
> What is the general consensus here?
> I see the ability to be able to put the PHY link administratively down a
> desirable feat. If it's left to negotiate/receive traffic etc while the
> MAC driver isn't completely set up and ready, in theory a lot of
> processing can happen outside of the operating system's control.

What would seem sensible from my perspective is the following: upon
ndo_stop() the PHY is brought into the lowest power mode available,
unless the device is used for Wake-on-LAN, in which case, an appropriate
low power mode (e.g.: 10Mbps/half receive only) allowing WoL to function
can be selected.
-- 
Florian
