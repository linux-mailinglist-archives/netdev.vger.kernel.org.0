Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5E2FFD62
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbhAVH3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbhAVH25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:28:57 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2339CC061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:28:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id l9so6276798ejx.3
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iA8HpgeNBFfwu6VsHIUD4ZW0ond4LJ90nVhAoHSVhfw=;
        b=uCfJ0+YiP35X3FKfoRnWKjUuCAgdvzQ7+oyHnBT4gvWdn12IGAVTdEnjdMnEGg7pGa
         yggb8jVa5rrJU+pB3RzVwx9cg+WK+TtL8LuJWDJ9A7KJMqwKOTX7ZP88zUaDEu127ZuZ
         ZD+rV3w5UEBwS/T+hUBDcb+q9F+9HRhfN+bA5umdW/HK2mTHZRx5LZDzo1+gVqN9Mi99
         21/D3IzkGjpRaI98pQEE9x3yRZ7IRn3GBhszIxyDN5XzXSc/0Vz+c5X2ovj8G6PCbwR5
         D8SnZ+oenVWJU1EcEiEU3sUwReWdeMQFIAyMndcXlpzB9YTrPQz0Ra4+B1OUKhz3ohg6
         85iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iA8HpgeNBFfwu6VsHIUD4ZW0ond4LJ90nVhAoHSVhfw=;
        b=pYLAWUjyTpKs+pgQZFeU6CdBxyTsL9Rr9LbNGeXnClR6XGfCW/zNfXZ/veC3c5G9NS
         p91qKWCiEBsaosP4tX+vLI4M06PwD4OOkrx5C77Vv04MEQpzAHV1FTAtS0Rs5LoQZLpo
         Un0TpOgClvIX84Y6TvONkOvIzfXRX9M0ojk/epA83HFi05gzIpLbeQA/Z3oOZT6Pk4XW
         FAA/6K/oy1ZA8LHUneKoojK4crQcfdd5J7z9SZUp8/IpvEKD2cu0mPPcyoOP2REv0D8z
         TOwMcxugNVvuYOpKDITfHqchuIfcplsVFrZUOQSFBwm6f61SVkPcj0jLJfadgMRPPMOm
         ZNww==
X-Gm-Message-State: AOAM531NcJNpQ1MBH48WCbR/ksZEjNe+9cF9CNZj6whoIcGplT+yOkvW
        duDDbm6BA1iaBLjOJSvFA8gkgw==
X-Google-Smtp-Source: ABdhPJynEdXVZnCS3MSwHI4FyTM3BHQrJ3C5AkSIa1jyr2ndkp51H9MgtJgpvfQ0/S49pliZhJVX1g==
X-Received: by 2002:a17:907:3d86:: with SMTP id he6mr1007649ejc.174.1611300495843;
        Thu, 21 Jan 2021 23:28:15 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f17sm4486953edu.25.2021.01.21.23.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 23:28:15 -0800 (PST)
Date:   Fri, 22 Jan 2021 08:28:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210122072814.GG3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 21, 2021 at 05:38:40PM CET, dsahern@gmail.com wrote:
>On 1/21/21 8:32 AM, Jiri Pirko wrote:
>> Thu, Jan 21, 2021 at 12:41:58AM CET, kuba@kernel.org wrote:
>>> On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
>>>>> No, the FW does not know. The ASIC is not physically able to get the
>>>>> linecard type. Yes, it is odd, I agree. The linecard type is known to
>>>>> the driver which operates on i2c. This driver takes care of power
>>>>> management of the linecard, among other tasks.  
>>>>
>>>> So what does activated actually mean for your hardware? It seems to
>>>> mean something like: Some random card has been plugged in, we have no
>>>> idea what, but it has power, and we have enabled the MACs as
>>>> provisioned, which if you are lucky might match the hardware?
>>>>
>>>> The foundations of this feature seems dubious.
>>>
>>> But Jiri also says "The linecard type is known to the driver which
>>> operates on i2c." which sounds like there is some i2c driver (in user
>>> space?) which talks to the card and _does_ have the info? Maybe I'm
>>> misreading it. What's the i2c driver?
>> 
>> That is Vadim's i2c kernel driver, this is going to upstream.
>> 
>
>This pre-provisioning concept makes a fragile design to work around h/w
>shortcomings. You really need a way for the management card to know
>exactly what was plugged in to a slot so the control plane S/W can
>respond accordingly. Surely there is a way for processes on the LC to
>communicate with a process on the management card - even if it is inband
>packets with special headers.

I don't see any way. The userspace is the one who can get the info, from
the i2c driver. The mlxsw driver has no means to get that info itself.

