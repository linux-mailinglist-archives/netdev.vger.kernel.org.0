Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45443FBF1B
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbhH3WrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbhH3WrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:47:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB6CC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:46:28 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n5so24493319wro.12
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6dq09dD0R/0XpeXdIVGlD8j/2iQde7liPNiMyT6016k=;
        b=IHVBwIGQp3o3UeQnPs32F4H1fgibZBvrd4xlabP36yN8rWgb4dgNZw7b8t2eFHjgpU
         OjVqLsbAMf9su+x+gL71OT6kCyTy7R1skejldNkdBPtlm9NmZe737BZxESU6lowNR7X2
         uP0AC431lKftKmR3MCejz6KJ9aUlhWoW9NdsD9DOkH/TAHDZl2iJmpiIVZm8a9xUqv1w
         LZnClyLp6YJ69e5Lon1DYQo9pZk7CygbHatSu5zkAjuC2f0A2Nyv1n3JNYuMwJCTT7n2
         6AauXtD7htYUC26IGmGUxL/zpSWmDfc54bzDZtHfIC4prXW+HUWujFbqh5olyOSTGfO/
         zReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6dq09dD0R/0XpeXdIVGlD8j/2iQde7liPNiMyT6016k=;
        b=Hj4vF9uxeGoeQ8OAf99TwFhbUG2E6LpNwnn5OqVpVqcaoXqNNLboihIAbUyruWCeXI
         7NPCmwsRkNesZpE8xdbcakFmYks8wAClgzt+pWj1St6nR/9AdQZiUaXQdBXgSgjf8D9D
         tljpOC3v1RnPxpVIep3Py9BTuHiAICLUXWN6PlESFDm1ml+T54sLM6NfGRwJzkoMVOJG
         e6eBdvGmchCJOxogvt2jUomvnQzZ10wka9uiDjetnnSo3We7TLzRYXGe0uODTmd0sEQP
         CtU5rQMa1cwVurVAnB9sthjnLBMDHQKmh9wgGltLu1mEgibUPXPb12x17kavcZx6TWi5
         dcrQ==
X-Gm-Message-State: AOAM531ADJDvEWXV5yomyJsEpu3KFXLq8lh4Pt13mqSocigbPcyxebMe
        JfrqQMpxe6Ng+/6fWZi7xw0=
X-Google-Smtp-Source: ABdhPJwoKe0vMLugdj4IoG8+BmL+MztibzyGNP+3fq1LYbp5TYBtR8TDwSbxJhwqrHbzog7qWqOLJw==
X-Received: by 2002:adf:9e48:: with SMTP id v8mr11453510wre.141.1630363587421;
        Mon, 30 Aug 2021 15:46:27 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id k14sm16326779wri.46.2021.08.30.15.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:46:27 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:46:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
Message-ID: <20210830224626.dvtvlizztfaazhlf@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-6-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830214859.403100-6-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:48:59PM +0200, Linus Walleij wrote:
> This implements fast aging per-port using the special "security"
> register, which will flush any L2 LUTs on a port.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - New patch suggested by Vladimir.
> ---
>  drivers/net/dsa/rtl8366rb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 4cb0e336ce6b..548282119cc4 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -1219,6 +1219,19 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static void
> +rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +
> +	/* This will age out any L2 entries */

Clarify "any L2 entries". The fdb flushing process should remove the
dynamically learned FDB entries, it should keep the static ones. Did you
say "any" because rtl8366rb does not implement static FDB entries via
.port_fdb_add, and therefore all entries are dynamic, or does it really
delete static FDB entries?

> +	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
> +			   BIT(port), BIT(port));
> +	/* Restore the normal state of things */
> +	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
> +			   BIT(port), 0);
> +}
> +
>  static int
>  rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
>  			   struct net_device *bridge)
> @@ -1673,6 +1686,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.port_disable = rtl8366rb_port_disable,
>  	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
>  	.port_bridge_flags = rtl8366rb_port_bridge_flags,
> +	.port_fast_age = rtl8366rb_port_fast_age,
>  	.port_change_mtu = rtl8366rb_change_mtu,
>  	.port_max_mtu = rtl8366rb_max_mtu,
>  };
> -- 
> 2.31.1
> 

