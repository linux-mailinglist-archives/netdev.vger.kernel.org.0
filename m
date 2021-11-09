Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA35E44AF6E
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbhKIO14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhKIO1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 09:27:55 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E3C061764;
        Tue,  9 Nov 2021 06:25:09 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u1so33300566wru.13;
        Tue, 09 Nov 2021 06:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4a5lwOe61pZqA6tzu1S0/ADcSBRaSBOmvU0WydFkmBI=;
        b=kXwzzoQBxqNAJPu8b5nA/Y9EqzHRlQxlu/yoGIU8QQoEhmcu2v1REYvMxkN6WTdsnD
         Ch+HS64Mn0BxVZqBakvu4IvbBRzfe6Od/nYcwUgO/MDSNf4WaY3tj28RC/beZmIbE/zl
         nT6ykmfO2Dm9o5GbkWew3RHTTD4ME2FEoGO5qewrq/6webFa521/iB8v5x7pMJCA7KOj
         e2gwALyudgGS6ZHFrQ5jxZKWk3fRpvrsLe8+Qynoqnx5QVehqSs2a+hwDZHeSqCrhYAd
         ecdCG469Y6zBhYXq9qwX1iQ+ZoEEGHUP7lrxhRw/UkQ38fydQiYgfl758xKeSAA6V8PZ
         I1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4a5lwOe61pZqA6tzu1S0/ADcSBRaSBOmvU0WydFkmBI=;
        b=nhoOO4y+rMhl8yxQjUPB4gEKRAwy5tOJa5fRYuq9RAbt3xA6st6in/yiEjZaNauqhg
         T78f6PZKpOWQQ2vr4TfPC3gMT43rlSXE7CaD4Dr/G1nmr5JfA0SvN/XwHpDpdJdDB3V8
         iwCAhUozwKDT3a7VxdZnoPVkYgRvARJ2Qvo/s07Mv4q0hDXmsGjnKLTlAtr9uDeEKe/T
         WvVnZQsEz/5jnv2oxJBkd+9p5VTl32IGZDEkGRrAWmKPDo0bbuBurE3vI1AwX95Hbsu9
         ircFVXAEDQ2d1uKp4tZ3a8qBgn7ZfQ05zXy6B1DH00kJw6H8OU49Ex40ouyAaBnDarAU
         8l5A==
X-Gm-Message-State: AOAM530oEyRkYkGsG5acd2/yHZsilBBJijr/jkunM7g554QnmC3+goJb
        fUYogtgJBCnIEPs6ZkWjx3w=
X-Google-Smtp-Source: ABdhPJzf0kSZTCxlr4qOhGWejx5hi0j3WUaEla10F3CM/6jJz/e+h0NbkiPr5xgX1aQxktDHKOgDnQ==
X-Received: by 2002:adf:da44:: with SMTP id r4mr10234640wrl.180.1636467907937;
        Tue, 09 Nov 2021 06:25:07 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id m36sm2914643wms.25.2021.11.09.06.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 06:25:07 -0800 (PST)
Date:   Tue, 9 Nov 2021 15:24:58 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/8] leds: trigger: netdev: drop
 NETDEV_LED_MODE_LINKUP from mode
Message-ID: <YYqEuo8rwJ93AczD@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-4-ansuelsmth@gmail.com>
 <20211109040257.29f42aa1@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109040257.29f42aa1@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 04:02:57AM +0100, Marek Behún wrote:
> On Tue,  9 Nov 2021 03:26:03 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
> > that will be true or false based on the carrier link. No functional
> > change intended.
> 
> The last time I tried this, I did it for all the fields that are now in
> the bitmap, and I was told that the bitmap guarantees atomic access, so
> it should be used...
> 
> But why do you needs this? I guess I will see in another patch.
>

The link_up seems something internal to the netdev trigger and not
something strictly related to the blink modes. Why put a status in the
mode variable?

> Marek

-- 
	Ansuel
