Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1451CDF1C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgEKPct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728084AbgEKPcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:32:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8259BC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:32:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j5so11537757wrq.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TnQGqPM75OH1R/2ww4PC64r9FVhjhJ8ve+zfJoXtix0=;
        b=x0DqyzarXC/oHh7MqdC/dJQWxBc/eMk75RVMO7yL8K5N2IvVvCYW45w2iJfp6gE3/b
         +6OT8xysnugXW+7EnwcElNtihbu58gfWLiT4UMxTEzJq+PGz1RGuhku/9e3edVzXm1eV
         vRBFQjEvAQnlizyIE8lIzuf83OquOY0Heyf+emSlmRxDOqNI6M4ccDdjzDEcpyxVzlZy
         fYhd648RrvRD+TqOda5qCWAfpxAWs9GVik4WQnbA4sPe0ouWLWapBLsOFzqZ6oyylKDt
         EOwn/nm4AOnBdaFQZAKJVZTWsC77t2tVn3Vc6ATZhQGjDKsK8cXe+gDOBGYSHJJqvHOs
         4TeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TnQGqPM75OH1R/2ww4PC64r9FVhjhJ8ve+zfJoXtix0=;
        b=M85yNQ4rizfiGlzj5yJdn1xTK5I4dvo1H8lgBF3g/vmXGkoiGihWlpKnmimwU9u04J
         FgesWiw0otuOnggCtlhl9DyCLdvR5pbYDxX+d1bZ+bBwRHhQgeAntzVY3WPK9dTqK6CG
         agod7joporxhDNL/8oEPGvunTHKaoXh88tQe3wvqHrRGduLykcVveyJ8xcrjXQgTtyZn
         O8uensntvca9Gh3yuehXwQHAX40D8w0BZCnSO/1Hskd7NrPj232X0Z7x7FE4wLvOA7pK
         Q5Vcipzb6itQJ+xFdZDKfwJ4rnSmRGsOop9FKjeeHVm2d1ZGXrZ2HLnA5hPfHxUgawbY
         euJg==
X-Gm-Message-State: AGi0PubIhdVY4BMue5bTwDfGPce5oaGEpv2B+9B1e5W2z9UNSeKjBOce
        xcORe1oz9s2ZUICHX5eAm9wCjQ==
X-Google-Smtp-Source: APiQypIZ8KWLR1I15vhXR7cC/leBP8vTtovpzl4Th/w0vdBTUcwAI2+Fy68Ja4DDf7yUfcdQ7ujDyA==
X-Received: by 2002:a05:6000:11c3:: with SMTP id i3mr9002409wrx.219.1589211165326;
        Mon, 11 May 2020 08:32:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f5sm17926259wrp.70.2020.05.11.08.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:32:44 -0700 (PDT)
Date:   Mon, 11 May 2020 17:32:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511153243.GJ2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
 <20200511124245.GA409897@lunn.ch>
 <20200511130252.GE25096@plvision.eu>
 <20200511135359.GB413878@lunn.ch>
 <20200511141117.GF25096@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511141117.GF25096@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 11, 2020 at 04:11:17PM CEST, vadym.kochan@plvision.eu wrote:
>On Mon, May 11, 2020 at 03:53:59PM +0200, Andrew Lunn wrote:
>> > Looks like it might be hard for the board manufacturing? I mean each
>> > board item need to have updated dtb file with base mac address, instead
>> > to have common dtb for the board type.
>> > 
>> > And it sounds that platform data might be the way in case if the vendor
>> > will implement platform device driver which will handle reading base mac
>> > from eeprom (or other storage) depending on the board and put it to the
>> > platform data which will be provided to prestera driver ?
>> 
>> Hi Vadym
>> 
>> This is not a new problem. Go look at the standard solutions to this.
>> 
>> of_get_mac_address(), eth_platform_get_mac_address(),
>> nvmem_get_mac_address(), of_get_mac_addr_nvmem(), etc.
>> 
>>   Andrew
>
>Thank you! I will look on it!

Though in this case, it is not really a MAC, it is a BASE_MAC...
Maybe in DSA world this is usual?
