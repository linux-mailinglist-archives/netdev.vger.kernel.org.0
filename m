Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCDE2F330C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbhALOhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbhALOhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 09:37:55 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8ADC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 06:37:14 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id d17so3810470ejy.9
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 06:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=61FjCtpXzvlphj4T6JdOdJ406Vj4ifXYb7l05Ik0pvM=;
        b=qrB+LYVg89WvpS63mfpIF8OwL5kQQEu4sm08RplVN9jqNgkVhKhZrVFT7uWOJoVT3n
         j5uHj2rdQVF/xwz2JWUKQGPtiZaEfRaqwBPoF7npOJ2SUffRQTMNZgNQtoG/DgOOw6Nu
         1YXi5u0r7tk2DLxJnI4pxeMF7++L5aqeOzTQEhKDyRDgYys6Yu7UjxZD0bFDNSwDCaU9
         4LT/9Pnj7HNGuvmkmr31z5XX1+YKEHmUMNciwiuY8Bb9nyQnQoUiNpyu3ZPolghiRyh7
         WL5r1ptXit0xM3h5LhSZP0wDRF11Gtgec+w654PuzO/aT89NsldjvXmG/8JDS4zrHnut
         TDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=61FjCtpXzvlphj4T6JdOdJ406Vj4ifXYb7l05Ik0pvM=;
        b=F1MqMftq9yv7wnzualpPVooxtYwNePNEBTuUdwX9X+wydAgMIRyYag79YblcR03a8u
         lG/IzkM1gJQuebu0RYS7jSi4/5iPUCO3FvTVrnqWweWznRDDwLEMcK18MDbiGE/NdTGd
         9Zh46v11Qtee7Q8LChdgbIt2F1/VIPRnkyqE5U1whReRq6tUxSjCdKVy2hZ8NKjnnkeK
         uw13xkwZtdNh78OiGzWioLCnEyyTUwuIU6DFhSGDo07wJ+tz22ZmBv6rHrcDLGO2VHod
         sKJAFuHRe7I5MTluVmN4nL/Ly80wUMtx3YsQ3lyd7UsYgiXiqiTU8e2dtf+E5nCmdxH7
         RKjA==
X-Gm-Message-State: AOAM531P+AsNE3eykqkHOZXlrDx/NHjjJVbuCJAuVan58waWkNcmAjJV
        sUPBnlPihNgROZ1z5KI/0PLkIEzxvxE=
X-Google-Smtp-Source: ABdhPJzoX8A3PVWauIJZfwtS0zro6Fh09EgrxVeXEPSSh0tfgXp5+QUbOLba6fJuolmBn8Ux2tpWDQ==
X-Received: by 2002:a17:906:1ed6:: with SMTP id m22mr3584956ejj.231.1610462233264;
        Tue, 12 Jan 2021 06:37:13 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm1490255edv.93.2021.01.12.06.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 06:37:11 -0800 (PST)
Date:   Tue, 12 Jan 2021 16:37:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [PATCH v6 net-next 14/15] net: bonding: ensure .ndo_get_stats64
 can sleep
Message-ID: <20210112143710.nxpxnlcojhvqipw7@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
 <20210109172624.2028156-15-olteanv@gmail.com>
 <cbead0479ef0b601bada5ae2ad0f8c28e5b242c9.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbead0479ef0b601bada5ae2ad0f8c28e5b242c9.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 03:38:49PM -0800, Saeed Mahameed wrote:
> GFP_ATOMIC is a little bit aggressive especially when user daemons are
> periodically reading stats. This can be avoided.
>
> You can pre-allocate with GFP_KERNEL an array with an "approximate"
> size.
> then fill the array up with whatever slaves the the bond has at that
> moment, num_of_slaves  can be less, equal or more than the array you
> just allocated but we shouldn't care ..
>
> something like:
> rcu_read_lock()
> nslaves = bond_get_num_slaves();
> rcu_read_unlock()
> sarray = kcalloc(nslaves, sizeof(struct bonding_slave_dev),
> GFP_KERNEL);
> rcu_read_lock();
> bond_fill_slaves_array(bond, sarray); // also do: dev_hold()
> rcu_read_unlock();
>
>
> bond_get_slaves_array_stats(sarray);
>
> bond_put_slaves_array(sarray);

I don't know what to say about acquiring RCU read lock twice and
traversing the list of interfaces three or four times.
On the other hand, what's the worst that can happen if the GFP_ATOMIC
memory allocation fails. It's not like there is any data loss.
User space will retry when there is less memory pressure.
