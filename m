Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C66641FDC
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 22:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiLDVaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 16:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLDVax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 16:30:53 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E482E13E05;
        Sun,  4 Dec 2022 13:30:52 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id gu23so23495016ejb.10;
        Sun, 04 Dec 2022 13:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hF6oJVjQzaqdi8lDZeW1Bgv7sJLTmHA998bisnVrQiQ=;
        b=DEqPrzaWmNjsFqVoVtTW6n0kjsZ383G6bN7tyytn+Hih9R0Vn62GZkHQ5UDEeYdQ81
         wgx62Z1vyjeoSR/4B2QCefFayq8GTE+Lf4Sls9UPn31zZYwNYX7/IXImudOWaz5QfttW
         bv20F/1qJieUe8EzjgzeQz9osMwe3W3MkI9Kec6RqcrO9HF748K4Ytul/Rpoo2q1xCYo
         7BxYdQFx6aOZs+mf2Dj5mRLP706QIE77L7UXkfFcKTRmQ1aS9zoIzGiJnjWDnppdTbms
         2uBbKsFe8V+htrIElFed53g4BpsC08Y3VcdAV6wZvNsjZf+eAmiCA0uFM4cxYbnhxXre
         rrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hF6oJVjQzaqdi8lDZeW1Bgv7sJLTmHA998bisnVrQiQ=;
        b=o3sbx61oPnAkdmq3JqCqIOgK6FPQLK7A65AwyU7x8UpCY/75WR3i9cGx+7QopP2bVP
         W51ulYcpQiXc7mEiUBh77GGnn94cSQCw2IBWJwhwtsEMItXbWS8N3HoKqj8l1h0AfNow
         2YZB+I+NRJjUOLzp23utUc5KMT0z3qIHkagDvd3a9bbHsESVKy8Z21vfDfr/F/yihtY3
         cYrW5EV83MZe1/Qibtt1vXWbGzsO51f7jNXPZtt516I5gLPQ6ZqWvWMNNAhHcpAcBoyF
         IeSlYIwQoyfPGjneCx3+kivQjmjs7/iWNb1/RHAaGMo8fmCILHM2itx5In5ivn6Lsjhu
         k24w==
X-Gm-Message-State: ANoB5pkZMN5vMB9EgUrn/8VG8GCROThxJQhaG/fQgUTRH7Y9DlvuO0m4
        GHlwQbxc99NjPMOdvl25/9g=
X-Google-Smtp-Source: AA0mqf7wr8KOhAJiJRT5t2Zp8AH6w98wpfiQsrcLCNqg37TObbVqp6Kc9m1FAY8vCu/9d0TBTtfhxg==
X-Received: by 2002:a17:906:b7c8:b0:7be:1164:2695 with SMTP id fy8-20020a170906b7c800b007be11642695mr33432645ejb.280.1670189451235;
        Sun, 04 Dec 2022 13:30:51 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id n22-20020a05640206d600b0046bada4b121sm5528911edy.54.2022.12.04.13.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 13:30:50 -0800 (PST)
Date:   Sun, 4 Dec 2022 22:30:59 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 1/2] ethtool: update UAPI files
Message-ID: <Y40Rk6iIj6AnwKuY@gvm01>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
 <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
 <Y4zduT5aHd4vxQZL@lunn.ch>
 <Y40OEbeI3AuZ5hH2@gvm01>
 <20221204212521.rjo5hgkmsq3spxzv@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221204212521.rjo5hgkmsq3spxzv@lion.mk-sys.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 10:25:21PM +0100, Michal Kubecek wrote:
> On Sun, Dec 04, 2022 at 10:16:01PM +0100, Piergiorgio Beruto wrote:
> > Hello Michal,
> > I was wondering if you could help me with the issue below.
> > 
> > In short, I'm trying to add a new feature to netlink / ethtool that
> > requires changes to the UAPI headers. I therefore need to update these
> > headers in the ethtool userland program as well.
> > 
> > The problem I'm having is that I don't know the procedure for updating
> > the headers, which is something I need to build my patch to ethtool on.
> > 
> > I understand now this is not a straight copy of the kernel headers to
> > the ethtool repository.
> > 
> > Should I use some script / procedure / else?
> > Or should I just post my patch without the headers? (I wonder how we can
> > verify it though?)
> > 
> > Any help on the matter would be very appreciated.
> 
> See https://www.kernel.org/pub/software/network/ethtool/devel.html for
> guidelines (section "Submitting patches"). What we need are so-called
> sanitized kernel headers, created by "make headers_install". The easiest
> way to update them is using the ethtool-import-uapi script linked from
> that page, usually "master" or "net-next" is the most appropriate
> argument, depending on your target branch.
> 
> Michal
Great, thank you Michal! That is exactly what I was looking for.

Kind Regards,
Piergiorgio
