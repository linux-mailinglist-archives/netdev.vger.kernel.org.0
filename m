Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22463CBE2C
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhGPVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhGPVJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 17:09:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D64C06175F;
        Fri, 16 Jul 2021 14:06:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k4so13498844wrc.8;
        Fri, 16 Jul 2021 14:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4pKHQr/tbhIkbF86KWS5quyjtsLNIoQ9B8exVpj2LvE=;
        b=imAamG32La2GeVnoJxdszWNMiUMaWujFLyvTENQHuWfTNRlb3SNnTdV2TWYAG1R2Iq
         m9X19q9TnKhGwiwjEH98ZQhJwckwrBhte8sRCGV17eJZMnpW2fdtMFrGUfeeoNSaTayd
         LNvkDS8mdvqtmEc5tJlf6wcLsvtMo1o4qYUjrh0PBKA5tzm6OrBhawxNiYgPW1gs0IPp
         vj0V9sc6Zjwq1IuJt4g70TdNSfiurt7XfQniw376QSwYntbenJpbGWiNTYwMWZno0VHp
         U6ArIOb7fhN+HtK0VjCI9PwBEWg2Hu987FF2a1GTl/wrOzQFCcEHcnvoCNdPYPcXTVIO
         2RsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4pKHQr/tbhIkbF86KWS5quyjtsLNIoQ9B8exVpj2LvE=;
        b=sEc0JAVv9k1BBbTGcd55Ydv9iFS3lq7jg8spQAR07IDjo1UhtPxVZ2Mz1BnF4tKREM
         LJOc+CHa2ll7V9fMBiiSNW0/1NrLhWOo1qLdZXokhMCrQzNJ161sHX1uNcOPCB0kYOrK
         1et14W8bTZxNqvtm6FvojmidtDmpesXpnPP5CgVb0kURsaR1pZDH57S/hwYoiyWL61nK
         SvLE2ExwBJeCmVKK95t+Sb3DPEOfutH5cftcrFHQZ0KI9zCXgMhr/VPSn6fmHgXrRr9/
         TA6ZnkRHMilanZgLFqO5ls/FKrtTUuy7D35tEdZS2hQKA71ZxctsH8EBcqnhn8dOtfiF
         nKPQ==
X-Gm-Message-State: AOAM530K4mDPjiY7f9rHRgPXDdnCBxxBQzAT/SzrnyjJlnpoBtrwV9Pt
        6EOk4AZkPD9qhDp7nARzP8I=
X-Google-Smtp-Source: ABdhPJzjA0OaqPdB0BisEA9NQVoLMSvfu5B0rWbk6wjlzGlw9RLplrT5VwiaLaYOwPhAHtcCdcseAQ==
X-Received: by 2002:adf:a287:: with SMTP id s7mr14497864wra.120.1626469617176;
        Fri, 16 Jul 2021 14:06:57 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id d8sm11514867wrv.20.2021.07.16.14.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 14:06:56 -0700 (PDT)
Date:   Sat, 17 Jul 2021 00:06:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     ericwouds@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Message-ID: <20210716210655.i5hxcwau5tdq4zhb@skbuf>
References: <20210716153641.4678-1-ericwouds@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716153641.4678-1-ericwouds@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 05:36:39PM +0200, ericwouds@gmail.com wrote:
> From: Eric Woudstra <ericwouds@gmail.com>
>
> According to reference guides mt7530 (mt7620) and mt7531:
>
> NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to
> read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0]
> will be used to read/write the address table.
>
> Since the function only fills in CVID and no FID, we need to set the
> IVL bit. The existing code does not set it.
>
> This is a fix for the issue I dropped here earlier:
>
> http://lists.infradead.org/pipermail/linux-mediatek/2021-June/025697.html
>
> With this patch, it is now possible to delete the 'self' fdb entry
> manually. However, wifi roaming still has the same issue, the entry
> does not get deleted automatically. Wifi roaming also needs a fix
> somewhere else to function correctly in combination with vlan.
>
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 1 +
>  drivers/net/dsa/mt7530.h | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 93136f7e6..9e4df35f9 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -366,6 +366,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
>  	int i;
>
>  	reg[1] |= vid & CVID_MASK;
> +	reg[1] |= ATA2_IVL;
>  	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
>  	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
>  	/* STATIC_ENT indicate that entry is static wouldn't
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 334d610a5..b19b389ff 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -79,6 +79,7 @@ enum mt753x_bpdu_port_fw {
>  #define  STATIC_EMP			0
>  #define  STATIC_ENT			3
>  #define MT7530_ATA2			0x78
> +#define  ATA2_IVL			BIT(15)
>
>  /* Register for address table write data */
>  #define MT7530_ATWD			0x7c
> --
> 2.25.1
>

Can VLAN-unaware FDB entries still be manipulated successfully after
this patch, since it changes 'fid 0' to be interpreted as 'vid 0'?

What is your problem with roaming exactly? Have you tried to disable
hardware address learning on the CPU port and set
ds->assisted_learning_on_cpu_port = true for mt7530?

Please note that since kernel v5.14, raw 'self' entries can no longer be
managed directly using 'bridge fdb', you need to use 'master static' and
go through the bridge:
https://www.kernel.org/doc/html/latest/networking/dsa/configuration.html#forwarding-database-fdb-management
You will need to update your 'bridgefdbd' program, if it proves to be at
all necessary to achieve what you want.
