Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD8D27BFF3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgI2Ir4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2Ir4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:47:56 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B13C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:47:55 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so3924019wmi.0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=04NOm1CcnqBFH1lFELuJnkJP2M/KCWXwaUl0Wh9OcUc=;
        b=tO+PmyVtTbztmBizvLgCmAX4QG5q377A4oSC57bt1amxOb796KuKCoWdTtewoRDcFF
         xrlMO6QZd6X8lLgT5lrb5eFLu/Ra6uCxW7NKQyYNS/LmWwu5V1WgG32EXm6FaXx+7TAo
         7X1w7o6HRAWI6ZE9lvKdfCledlYDRck0hynQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=04NOm1CcnqBFH1lFELuJnkJP2M/KCWXwaUl0Wh9OcUc=;
        b=jpHeumt1w2evG7OJ+Df40JDImLLsP61b015kDM82n1sroBWP/SFHQLTUrr7dwcKna+
         O+Vi6/3sjJYTCCP3IKxh6+hC3rcvn4ByUxOphjHTW5fFSbycMTV+hXPZoq88ReDsnlq2
         2kOF7x7b89zPFwBZa68hGyJUxnR5TZfHoQo+b4jEUJcMDqHH3yYw3Th3jQEuYD58EbUS
         ypm752LGXEWKgzXIHALm3tTz/R98iZOWd9T1X1k0ECuCYY4LOlnswTHpOSvucH+/gbhm
         9wFm+/0h06C75nGfehp5LQp9tv/OCZYB3uO3jL/Gr5KZnaG2TF4y2LkRnL+CFClWtamQ
         T6eQ==
X-Gm-Message-State: AOAM533pD+YMksHHRbPiTe5gwywFq0UMTzgFW6au3ktrBJuNYYRyyNFe
        COupA6tBwwWZgKM48AYYWilbBw==
X-Google-Smtp-Source: ABdhPJzCaYhOmzZGYjtY3NFO+dcWZjeq7anc17VA56qyI4ndCuaOwSJMJVZxvCxDqgu253DyYg8FFg==
X-Received: by 2002:a1c:f612:: with SMTP id w18mr3235574wmc.47.1601369274642;
        Tue, 29 Sep 2020 01:47:54 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id m3sm5155328wrs.83.2020.09.29.01.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:47:54 -0700 (PDT)
Date:   Tue, 29 Sep 2020 11:47:52 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH] net: usb: rtl8150: prevent
 set_ethernet_addr from setting uninit address
Message-ID: <20200929084752.GA8101@carbon>
Mail-Followup-To: Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200929082028.50540-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929082028.50540-1-anant.thazhemadam@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-29 13:50:28, Anant Thazhemadam wrote:
> When get_registers() fails (which happens when usb_control_msg() fails)
> in set_ethernet_addr(), the uninitialized value of node_id gets copied
> as the address.
> 
> Checking for the return values appropriately, and handling the case
> wherein set_ethernet_addr() fails like this, helps in avoiding the
> mac address being incorrectly set in this manner.
> 
> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> ---
>  drivers/net/usb/rtl8150.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 733f120c852b..e542a9ab2ff8 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -150,7 +150,7 @@ static const char driver_name [] = "rtl8150";
>  **	device related part of the code
>  **
>  */
> -static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
> +static int get_registers(rtl8150_t *dev, u16 indx, u16 size, void *data)
>  {
>  	void *buf;
>  	int ret;
> @@ -274,12 +274,17 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>  		return 1;
>  }
>  
> -static inline void set_ethernet_addr(rtl8150_t * dev)
> +static bool set_ethernet_addr(rtl8150_t *dev)
>  {
>  	u8 node_id[6];
> +	int ret;
>  
> -	get_registers(dev, IDR, sizeof(node_id), node_id);
> -	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
> +	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
> +	if (ret > 0 && ret <= sizeof(node_id)) {

get_registers() was recently modified to use usb_control_msg_recv() which does
not return partial reads.  IOW you'll either get negative value or
sizeof(node_id).  Since it is good to be paranoid i'd convert the above check
to:

	if (ret == sizeof(node_id)) {

and fail in any other case.  Apart from this minor detail the rest of the patch 
looks good to me.

Acked-by: Petko Manolov
