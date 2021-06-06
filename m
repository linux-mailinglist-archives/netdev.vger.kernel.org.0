Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BABE39CF47
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 15:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFFNMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 09:12:32 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:34559 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhFFNMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 09:12:31 -0400
Received: by mail-wr1-f52.google.com with SMTP id q5so14291654wrm.1;
        Sun, 06 Jun 2021 06:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YHW3j/yUXkD5+ub22MZhxBtOBlDuCGoenhVrhi0GjK4=;
        b=i2sUfEjoyoWAGBwk1wvK1kU4ED84DbnDTDZY64r5vubn4gcouEYNLSudg69l7h5k7P
         HOgKFwpbipduVMjYVvktLZwnrwnUlbqEPQFUOh+M2rNDVbJZ7FukqnVV5N4SiRQY4Jj1
         TOkjRNlnEBiM4ayyzWZeKwTa1dGZjLINpCIcb7YKxksHJ4IdkjO/5/C2mXqsYeDrLwQS
         XOQC6205aGtfxBKgvIfPXj3kmg07vaxJ0Ex1U/dD2eDFZ4y7jCtwYGJqCkiQWh1+QDcp
         Ibu4CBFQnesHHdlQiYlCD6E42+N8V0NpqyRGjzCg4xgyd1U89kmWyANm7J2I2reZtDxL
         4bYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YHW3j/yUXkD5+ub22MZhxBtOBlDuCGoenhVrhi0GjK4=;
        b=iYLr9+NXRPuMDP6V9Z0nTMwSjqILL0r/Nzlz5Ou9nj8jLgd9GmsUJ22xwWKQrqk5+x
         Sid5A8/TVA0Kes90mntTxmRU/GT1VOwdJHGJKQuX9Wtw/RIhp00dxG5c5l4QitFACUs9
         hd+vt9KxZ7TIyVTE+X42hOHjWYTrk+iFYuDYGOLv3peRLVXphUbUUSCG3uupcKH0udKw
         Wp84oxlcykVqie+P+/V8mb2BQ3P0w8eJrs6ejIB+bfPsPcMEyuVJ2FxPrxsU/DIA/Z/e
         UoL2VA7BTDqfxDaVA8IlzbBmYzG5r6cIwbe4ona85UmHzHoUOLVVZxxcGcwMl0EKpGhs
         X2rA==
X-Gm-Message-State: AOAM532UpNMeXBDvdiDdw3QlTAPBBMwsxQpDFubWJY73yo5x2OT8nZY/
        2GL7M6e/wz0zfLj3E1SyQLoZH+XeWev8bw==
X-Google-Smtp-Source: ABdhPJyKmCsnt9eAaouxAkxJtIGRBhAuhSpxWpJAdDMg0JX1QSWGeY3OyTftbAKRbd1T43YzyUGjRQ==
X-Received: by 2002:a5d:5082:: with SMTP id a2mr12867761wrt.199.1622984965562;
        Sun, 06 Jun 2021 06:09:25 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id o22sm13723412wmc.17.2021.06.06.06.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 06:09:25 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch> <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
 <20210606005335.iuqi4yelxr5irmqg@skbuf>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <9f07737c-f80b-6bd1-584a-a81a265d73eb@gmail.com>
Date:   Sun, 6 Jun 2021 14:09:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210606005335.iuqi4yelxr5irmqg@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/06/2021 01:53, Vladimir Oltean wrote:

> It is a bit unconventional for the upstream Broadcom switch, which is a
> DSA master of its own, to insert a VLAN ID of zero out of the blue,
> especially if it operates in standalone mode. Supposedly sw0 and sw1 are
> not under a bridge net device, are they?

sw0 and sw1 are brought up but otherwise left unconfigured. The bridge
consists of the user ports only (wanN and swNpN). A side note here is that
your "net: dsa: don't set skb->offload_fwd_mark when not offloading the
bridge" patch is also in use. Would setting up a bridge for sw0/sw1 not
have implications for receiving unknown frames on one port, that have been
sent from another port of the same switch? Since unknown frames will go to
the CPU, dp->bridge_dev would return the bridge name, setting
offload_fwd_mark=1 thus preventing those frames being sent back out
sw0/sw1 to its other ports.

>
> If I'm not mistaken, this patch should solve your problem?
>
> -----------------------------[ cut here ]-----------------------------
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 3ca6b394dd5f..d6655b516bd8 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1462,6 +1462,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>  	struct b53_device *dev = ds->priv;
>  	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
>  	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	bool really_untagged = false;
>  	struct b53_vlan *vl;
>  	int err;
>  
> @@ -1474,10 +1475,10 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>  	b53_get_vlan_entry(dev, vlan->vid, vl);
>  
>  	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
> -		untagged = true;
> +		really_untagged = true;
>  
>  	vl->members |= BIT(port);
> -	if (untagged && !dsa_is_cpu_port(ds, port))
> +	if (really_untagged || (untagged && !dsa_is_cpu_port(ds, port)))
>  		vl->untag |= BIT(port);
>  	else
>  		vl->untag &= ~BIT(port);
> -----------------------------[ cut here ]-----------------------------
>
This does seem to sort the issue as well in this case. Thanks!

Matthew

