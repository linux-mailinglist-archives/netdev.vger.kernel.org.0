Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954892FEEF4
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbhAUPfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732988AbhAUPew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:34:52 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E395C061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:34:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id n6so2961226edt.10
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UmB06eKVmfH4bF0RD8GKCaRpK/ZwEQcpExnJ1iySDzY=;
        b=RpsuUazUyWI8SeQfZ1EKIQ+sRlnAJdUyxhG5nix7U7xYV8ljWpIS88qDpYetAv2HTm
         Ie5dwCnULQi6SUQJgAw4S9fFagfZiy0XMKi6Ca1R6bnz59JsniwA7cqckeu6FqYrCJuX
         /7jp8VyJz5jvZeVLQ6wJlfeVA1EeV3HfOtQsKNQIS+C/3qnJAn6PoEk4kNh5wncZ+us0
         K7JXjsumHyqcTfttqzVMfKgzMVHWyUhvBB7e9jgViNpe+MYPdmOBZZtiW4Aj+3D46G7t
         kdRdMQEcBD5phn2fcQia2wOuhRLjgkICsWHzTDpLXsQwK/Bzl3ZfbIQs/g+URz6wy56j
         q76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UmB06eKVmfH4bF0RD8GKCaRpK/ZwEQcpExnJ1iySDzY=;
        b=O6+RQVO+He4i2J10SkXLZGjIak/AokY4JRuYtTNbUyDhns5cSCenq0ryZH7gh/YINt
         39wLrxbFV5w0K0PqO+HkSKtHf62EZTpb6asHAB6b33tyNhBXs99r8U5cd8DVLcd6v9EM
         K/wT4tcc0t88nav87nQy/Lw97HTz4pmRn22HNgXPnIzVSVHGXl6GGrr2I1daOvNi2e9c
         ZpijBV+1lzI+dOUrB6vylAhrGXH7j8pRh8r3s7qjwHWiQ1KcKHzv0PPazy1g7Ap4xxby
         JMhyC3FDjTTiwiiUOfoMOEVWDn5BWL8KcDcsBZMP2IfNJ5b+UepOmbEenGRxyIaV6dd4
         MNlw==
X-Gm-Message-State: AOAM532b/X6jksFMsSBqfhBowIuDvKsN35d3VA0qjibNQORVogkwcbjk
        kdST0+uy0FCeOM5F9OlOAjY/rQ==
X-Google-Smtp-Source: ABdhPJzUkJ3AT/lTXffznzhX+vYrbtqqbyMxt7nsjPd46zcxjuEV3v1HdhAqA4mHNrjF2mJymEKVFw==
X-Received: by 2002:a05:6402:60a:: with SMTP id n10mr11360519edv.230.1611243251360;
        Thu, 21 Jan 2021 07:34:11 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u23sm2893164edt.78.2021.01.21.07.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 07:34:10 -0800 (PST)
Date:   Thu, 21 Jan 2021 16:34:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210121153410.GF3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YAjEUdYnGSPjZSy5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAjEUdYnGSPjZSy5@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 21, 2021 at 01:01:21AM CET, andrew@lunn.ch wrote:
>On Wed, Jan 20, 2021 at 03:41:58PM -0800, Jakub Kicinski wrote:
>> On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
>> > > No, the FW does not know. The ASIC is not physically able to get the
>> > > linecard type. Yes, it is odd, I agree. The linecard type is known to
>> > > the driver which operates on i2c. This driver takes care of power
>> > > management of the linecard, among other tasks.  
>> > 
>> > So what does activated actually mean for your hardware? It seems to
>> > mean something like: Some random card has been plugged in, we have no
>> > idea what, but it has power, and we have enabled the MACs as
>> > provisioned, which if you are lucky might match the hardware?
>> > 
>> > The foundations of this feature seems dubious.
>> 
>> But Jiri also says "The linecard type is known to the driver which
>> operates on i2c." which sounds like there is some i2c driver (in user
>> space?) which talks to the card and _does_ have the info? Maybe I'm
>> misreading it. What's the i2c driver?
>
>Hi Jakub
>
>A complete guess, but i think it will be the BMC, not the ASIC. There
>have been patches from Mellanox in the past for a BMC, i think sent to
>arm-soc, for the ASPEED devices often used as BMCs. And the BMC is
>often the device doing power management. So what might be missing is
>an interface between the driver and the BMC. But that then makes the
>driver system specific. A OEM who buys ASICs and makes their own board
>could have their own BMC running there own BMC firmware.
>
>All speculation...

Basically all correct.

The thing is mlxsw and the i2c driver cannot talk to each other:
1) It would be ugly
2) They may likely be on a different host


>
>      Andrew
