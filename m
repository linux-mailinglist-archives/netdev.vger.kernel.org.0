Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DAD3E3763
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 00:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhHGW0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHGW0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 18:26:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7E4C061760;
        Sat,  7 Aug 2021 15:25:59 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y7so18662641eda.5;
        Sat, 07 Aug 2021 15:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=92uVuuyqFsma8fvnbHzwvoioEaSC6xwEzGiWs7o3WjU=;
        b=anoCn6EnDubviuX9qUlEUEOV69RdQDgQ4e3RtYMO76cSMroGo73D3BO/7iPPBZdaqE
         nNn/Gd0LrUOKa9XA6toYQWUjhVQ8KS3YU+Epo2Au5Gp4rO43YqqsxBXyh1tQl2E9lxQm
         KAFU0sNfd4GMeZQE7wOOC/ojNKdBZpQPToip5igUwHb6/MqnU5+8nibbz2RQHS0f5ExN
         CdkZqqYhGJDNN5wdlFJHkb1PNqoP50blehUtw23dEMQlpWUCSfM1F4S3bZhi1ZQKcfQr
         WeiI3mv7pz+h9fzCSh6Jv9CIDnDJmL8nflljrQipcBypTzrjUJaZiH8h0TV+laafLw5b
         IBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=92uVuuyqFsma8fvnbHzwvoioEaSC6xwEzGiWs7o3WjU=;
        b=I6eNiv1bleN0unq8j/8So7sW3WVZP1ZoGjGXDRVzk1hcGfHd8dI7vhcNFA7QIHU9R9
         8Cmw3gPEor3jqYNS+G/djlYexmmifklTxt8cZKXOvc1gYCZ63hOl/zkOdnJ5hnR+/SnF
         qUe9Hzg6kirDczzp5JqWLKapBDtTOWoaX0WmpREc8SgStI2ra5xZs8LtFeZFxde0cGFK
         ffaEqe6WZQFYtKZgRHY4doNQPA5qiYXTn/2aV47+paiFyXQ+fi3wA6vCnghuSYeOmjsw
         4yVf51h53nlFFdF64PJGBF7KLqy6qsOWdrOisTxLaGAdFDVjpI0XziVClgZcgMP/FCTF
         9xtA==
X-Gm-Message-State: AOAM531wX5CVNAWi6O2oU2voq9Gv+MN9TdGhgnI+yZQ6D2SWZqEFIloN
        8ibDusrU5Q7976lV3qAWGRs=
X-Google-Smtp-Source: ABdhPJydw2VMkrobwjie5KfHGmvR3YNwbSkT3pQikHhimzS0ny8hzkyMEsPwQvfE4vKDAcCPS85lJQ==
X-Received: by 2002:a05:6402:14e:: with SMTP id s14mr3718654edu.358.1628375157792;
        Sat, 07 Aug 2021 15:25:57 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id b11sm753192eja.104.2021.08.07.15.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 15:25:57 -0700 (PDT)
Date:   Sun, 8 Aug 2021 01:25:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?utf-8?B?QW5kcsOp?= Valentin <avalentin@vmh.kalnet.hooya.de>
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on
 CPU port
Message-ID: <20210807222555.y6r7qxhdyy6d3esx@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807120726.1063225-3-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
> Enable assisted learning on CPU port to fix roaming issues.

'roaming issues' implies to me it suffered from blindness to MAC
addresses learned on foreign interfaces, which appears to not be true
since your previous patch removes hardware learning on the CPU port
(=> hardware learning on the CPU port was supported, so there were no
roaming issues)

> 
> Although hardware learning is available, it won't work well with
> software bridging fallback or multiple CPU ports.

This part is potentially true however, but it would need proof. I am not
familiar enough with the qca8k driver to say for sure that it suffers
from the typical problem with bridging with software LAG uppers (no FDB
isolation for standalone ports => attempt to shortcircuit the forwarding
through the CPU port and go directly towards the bridged port, which
would result in drops), and I also can't say anything about its support
for multiple CPU ports.
