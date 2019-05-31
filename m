Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0031039
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfEaObI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:31:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45381 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEaObH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:31:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so4347019qkj.12;
        Fri, 31 May 2019 07:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=cHmYMcyPT4LeGIh0Ry8Hqj+hkM7migYAn5F5J48Ga48=;
        b=Vwf8b76qkCN9sdHahlt1M5OkP+ZT5jyv6XlwBiwK8s8Pgd2tnJ7uH41RZx/SsXJjrB
         /XJf6Xi/P1KlufM3m9WWqkyEOE7dvMnCIWQGcHo/4xx3Oa7C9lSl1mHp7R8bIOzibC3n
         QPUguTrwyxg3NYLYmA2lGE1pCK2R/O/4xFEYYJdEeveIm6nFjz138kvZfwKtM1HaaI7t
         53eFvtu1W9Zum4osgCLnIhjT1An5UndzIyqcmCirMyuoeCtaceOLHv59PRSbocsHO45n
         4RbBW2I+w2HEZ51tii3hOMWfq5FBKFFIy4Fkhir99hIyL2eLZsMpZT78eDolkCH8vGHD
         lW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=cHmYMcyPT4LeGIh0Ry8Hqj+hkM7migYAn5F5J48Ga48=;
        b=M/5M57+40HxIDd8VRRNE45DRp6t0UWUE7yHxEBzIzV1aJR8Q0LiGFUBzUT5VRxXwt/
         iqWs8T4Wm302FMu4ap9KqxSk45Dxx5TKPOV4Xd9FGw3hDpgis77MOqG7eK0X3bFi5BK0
         eQLcodyyK3faLXhusHd/3MGxue4vcmBDqDF3FmNzX25NgInptXDTVxl4AOh/CO/LOl9Q
         92gEXngIuTiT6ccz7AxURWatecDKEw3wx6LzRGkQlQg5Lb2HXNBRLxkET23lrq1Owugg
         Atm4YhIcugBGiboviHy1npsR4o1O3kPTqtBX44ys9yjChGSdZgy1H1n3y73R6fi8WncG
         ePfQ==
X-Gm-Message-State: APjAAAVl+S9ZGSl4e+WqdacatMk84U2ROx4a5HGWcauWcH5jWeLwmRUD
        cIO1SuyIdGdCe6Z6zuu26K49jExsrHQ=
X-Google-Smtp-Source: APXvYqxxRvO/pVcQYwOM3CsHb7jeD6WBgdX0yQ7Hifb7OaiG8XLaTy0pG9FCwDh3Pd12QnOCgxaShw==
X-Received: by 2002:ae9:de81:: with SMTP id s123mr5370333qkf.339.1559313066834;
        Fri, 31 May 2019 07:31:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f67sm3594643qtb.68.2019.05.31.07.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 07:31:06 -0700 (PDT)
Date:   Fri, 31 May 2019 10:31:05 -0400
Message-ID: <20190531103105.GE23464@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
In-Reply-To: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikita,

On Fri, 31 May 2019 10:35:14 +0300, Nikita Yushchenko <nikita.yoush@cogentembedded.com> wrote:
> When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
> message is logged:
> 
> failed to kill vid 0081/0 for device eth_cu_1000_4
> 
> This is caused by call from __vlan_vid_del() with vin set to zero, over
> call chain this results into _mv88e6xxx_port_vlan_del() called with
> vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.
> 
> On symmetric path moving port up, call goes through
> mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
> that returns -EOPNOTSUPP for zero vid.
> 
> This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
> zero vid, then this error code is explicitly cleared in
> dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.
> 
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 28414db979b0..6b77fde5f0e4 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1392,7 +1392,7 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>  	int err;
>  
>  	if (!vid)
> -		return -EINVAL;
> +		return -EOPNOTSUPP;
>  
>  	entry->vid = vid - 1;
>  	entry->valid = false;

I'm not sure that I like the semantic of it, because the driver can actually
support VID 0 per-se, only the kernel does not use VLAN 0. Thus I would avoid
calling the port_vlan_del() ops for VID 0, directly into the upper DSA layer.

Florian, Andrew, wouldn't the following patch be more adequate?

    diff --git a/net/dsa/slave.c b/net/dsa/slave.c
    index 1e2ae9d59b88..80f228258a92 100644
    --- a/net/dsa/slave.c
    +++ b/net/dsa/slave.c
    @@ -1063,6 +1063,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
            struct bridge_vlan_info info;
            int ret;
     
    +       /* VID 0 has a special meaning and is never programmed in hardware */
    +       if (!vid)
    +               return 0;
    +
            /* Check for a possible bridge VLAN entry now since there is no
             * need to emulate the switchdev prepare + commit phase.
             */


Thanks,
Vivien
