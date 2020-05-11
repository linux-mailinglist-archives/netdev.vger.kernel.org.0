Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336DD1CE1A4
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgEKRYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgEKRYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:24:43 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63E0C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:24:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id e26so18896158wmk.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r1aEb+RdzYtB4zpJUyox5vluPTFRM8VgtJR55ouT1HU=;
        b=A5UKWCiSfnCc7JSuUAaf1n/TkN5KVOUAL77fa1mfIRGhIk46y+EMuhzmxWvLBiS99R
         dOSYpJujo57WbuPvis5rHzkx/+tcUbG8jRNGvOz9XqPpTQ1vjrXFHCrdOwetyn1w8err
         wodatQU8UIjRfUjp3tZG+BA4LTrtf/RLs2Qdyz4zhZINU56OIxUMAk3MVagLx3QhI1MA
         qmP1hVYkQuBVqrLsl6OFOXKf8bB+TuoIZxDcnkMYXHF2zJqUNFUOZy0sqhO/3voBAO2u
         TJY2hBbrluMKfAiZhAkqe+RS3fgbJ2dLas423eGIPHsc3xxUudsSfOK13uSAv9sAttMi
         PuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r1aEb+RdzYtB4zpJUyox5vluPTFRM8VgtJR55ouT1HU=;
        b=s3XgXdfcXvzPo2oELefZgdzg6TtZruhbkL0xwnxJ7pAqDZWAMveSHcRKTA4rh02pG1
         2LveCIUClx3d4TkY9hNXNfKR0yuXKvBBoOt3jM+1h+XaunaYZS/wH5Hb7MkAQJYQ6eeC
         Ys9MhvxEA6g9viHEk78ci4ofarLuGuOLC58yip1obcK1+ZfUjk3VYrHzAfY11/maaBmd
         nX6IhIsoNX4C0VfzsBa2MMh9HOzOfhi9pQNtTgu85wmHYrNgIygUbvV4XZkj1kWWlYj6
         WN+WvgNECbaysHuiit3eERy6wdq6jpSu2oPJQV/ZpPt9r8+z7/6iimaXfM1o4nU9fX+6
         NnwA==
X-Gm-Message-State: AGi0Pub7ZDGNhnq1JWcvE0ZtefCkTmbT18RDjdUKtt97izu9ORBamZy4
        o+S21nzJqBJ+SJ6d5liKoJTXLA==
X-Google-Smtp-Source: APiQypKXbdRSRQroi87Ee+oR2DjyCE7RKCFEdR3GI4tckE8+gy+tZhsHVzd2Wl3G/LJcH/twDfYrJQ==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr17168430wmk.144.1589217881656;
        Mon, 11 May 2020 10:24:41 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x18sm26345596wmi.29.2020.05.11.10.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 10:24:41 -0700 (PDT)
Date:   Mon, 11 May 2020 19:24:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>, netdev@vger.kernel.org,
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
Message-ID: <20200511172440.GK2245@nanopsycho>
References: <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
 <20200511124245.GA409897@lunn.ch>
 <20200511130252.GE25096@plvision.eu>
 <20200511135359.GB413878@lunn.ch>
 <20200511141117.GF25096@plvision.eu>
 <20200511153243.GJ2245@nanopsycho>
 <20200511164324.GE413878@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511164324.GE413878@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 11, 2020 at 06:43:24PM CEST, andrew@lunn.ch wrote:
>> Though in this case, it is not really a MAC, it is a BASE_MAC...
>> Maybe in DSA world this is usual?
>
>In the DSA world we take the MAC address from the master interface.
>And all slave interfaces have the same MAC address, so it is not
>really a base MAC, it is The MAC. The slaves are however allowed to
>change their MAC address.
>
>Where the master interface gets its MAC address from is somebody elses
>problem.

Understood. So we need to figure out how to handle base MAC here.
In mlxsw, it is queriable from FW.
