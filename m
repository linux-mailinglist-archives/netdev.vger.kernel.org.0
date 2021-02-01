Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DEC30A325
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 09:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhBAIR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 03:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBAIRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 03:17:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AFFC061574
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 00:16:44 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 6so15520774wri.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 00:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1QFS3MQ6yzipVrP55TDom1gqcJTlU6RdEkGsOYHHxuQ=;
        b=JYHpUBMxj9QoTY75GibNY0q6a98B60ZrSvunNFe4HD9uk6jKhh6pra0ifwJqLiIHZp
         M4YwvG11GzLaHIfAfobqWWPGGDtKKiIGOAKBz87ma2BcceqeqqipPBY/FbxpM3yHrQ7F
         6cd5HKPm4OZFW2jev0ev4VyAgtqt1mKnqJiPLbWMvERQmFwQ75s13gRTY2mYwoOjeDah
         0neKkgd5cDFoBnnhlNiGE1CAumQ65GJiG+NPJ4HMQ4W5Tsev+ag4ad6wWi62OdPHgrfu
         hu4yIujQUx4tQ7gGU524ALKWVC0LlgQsBPgmZBFVsDr6Am66eN9ns6y8rPoMgx7s6en0
         t0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1QFS3MQ6yzipVrP55TDom1gqcJTlU6RdEkGsOYHHxuQ=;
        b=aa2cq8VjiN+UyCgxnW6IURTf9QmUArY/tt0zAT8w13UKyRqfFTxAbI9fKc1GYQy+9y
         q6lb8rkCT/ulz8yByUbz+xwWmaRQxgMAqTm+/xDoqjYBehTF4Npbm9uGHRFDx03m1fSE
         O/hWQbxE+kjQ62oHOnZa1bE6LTPlrf+zpTpb3cjbwuioXrw/ivvPj+VCs32jVe5AOdJT
         +BOjVIzsoApKk27avNW9USxC8L+S95WmC5osiRy7HGkmj0YEDBD7FNYjNwiFpusOYCXk
         RMngYK3N+wxppTRb6YJtd6Hv/zODZtXEJXd38pzp4iPjy9Ox+TZMyp14c/xabT6VvKHp
         9yWA==
X-Gm-Message-State: AOAM531uQhahPeDg5RX4Xzvn3mGb4rk/wyuwVEZDxcRtNNXezX7eh+M2
        oarDbrsNMVv4GsxL0c1eKbjRDA==
X-Google-Smtp-Source: ABdhPJyRDUIOPtQuYklE5mjXKXJmUK1KHkpVw2h9zad2iQJVNcP8xWjm6J92yUuDYM/P9FfagvrALw==
X-Received: by 2002:adf:a554:: with SMTP id j20mr7985262wrb.148.1612167403645;
        Mon, 01 Feb 2021 00:16:43 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c62sm5698699wme.16.2021.02.01.00.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 00:16:42 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:16:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vadim Pasternak <vadimp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210201081641.GC4652@nanopsycho.orion>
References: <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
 <YBRGj5Shy+qpUUgS@lunn.ch>
 <20210130141952.GB4652@nanopsycho.orion>
 <251d1e12-1d61-0922-31f8-a8313f18f194@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <251d1e12-1d61-0922-31f8-a8313f18f194@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 31, 2021 at 06:09:24PM CET, dsahern@gmail.com wrote:
>On 1/30/21 7:19 AM, Jiri Pirko wrote:
>> Fri, Jan 29, 2021 at 06:31:59PM CET, andrew@lunn.ch wrote:
>>>> Platform line card driver is aware of line card I2C topology, its
>>>> responsibility is to detect line card basic hardware type, create I2C
>>>> topology (mux), connect all the necessary I2C devices, like hotswap
>>>> devices, voltage and power regulators devices, iio/a2d devices and line
>>>> card EEPROMs, creates LED instances for LED located on a line card, exposes
>>>> line card related attributes, like CPLD and FPGA versions, reset causes,
>>>> required powered through line card hwmon interface.
>>>
>>> So this driver, and the switch driver need to talk to each other, so
>>> the switch driver actually knows what, if anything, is in the slot.
>> 
>> Not possible in case the BMC is a different host, which is common
>> scenario.
>> 
>
>User provisions a 4 port card, but a 2 port card is inserted. How is
>this detected and the user told the wrong card is inserted?

The card won't get activated.
The user won't see the type of inserted linecard. Again, it is not
possible for ASIC to access the linecard eeprom. See Vadim's reply.


>
>If it is not detected that's a serious problem, no?

That is how it is, unfortunatelly.


>
>If it is detected why can't the same mechanism be used for auto
>provisioning?

Again, not possible to detect.
