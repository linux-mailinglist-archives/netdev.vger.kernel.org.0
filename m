Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE4131207E
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBFXaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBFXaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 18:30:15 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4B9C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 15:29:34 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id sa23so18982911ejb.0
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 15:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zgzu/ct6rzmHEiSnwWHAQo+btSqTu5/hVnmg+/EoBTA=;
        b=pHKkZucNvFjHzEW7XFdWdo1YrOcSxamBVz+F2stTLwPA10s6752wF6amVnrC9SfxKc
         QHhFw4ACrU39KsE6jk9CsH58nsysfFdB5LIa+4RuBMc9t2U+8/Rir7QkDRtg4QidfYgJ
         nZrlXc7p107f82/kwUDL88CtAHsUwT1E35j1vJW3CJL84P0/YUTz4BjsDVQr2et017Cn
         UFYnVdPZTMzaSabkuUgpHCkafVrvWVSQRcXq2XRXLOnsInoXttzA4fHZl7zSsyS97vxR
         CyaOULV3Vd10jpNl2eW+ye+iBVkzTS5fVDWJ4rcwDxAlqWRA9jKukwleZgFXdGGS/Qze
         idFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zgzu/ct6rzmHEiSnwWHAQo+btSqTu5/hVnmg+/EoBTA=;
        b=fJ7iMdn1L9cxK6FBrTjPaU5zTT0vsSZ6bDpS8ErBeuOYmRehkzpdGaRWV1AWXZdxzN
         xhYloDN+nFYqaDDlt8OcWAQ71s3XwSnqhYNeF2YmjNToS2CXmYpDUGYXwmXZbB+SsPb7
         Pf8i3As/Jegi0Cz8FtLmd8D8m4TnrLOjGgIT9vXvO6cIcIs7sfUxUN8V2/kNeGHjuhkp
         1GDk1Jx+ko0SD0fb7z+732gAorSS4/fsiUxgKAkBV6BdeYw2FXPoSAxav24rtammXjQv
         VVyytZ3cl4jkftHOjG1AwvSA300e2LJBP8Aif8yJcptoSv4IQlOzvhaI4MDqHoEnScye
         IwJA==
X-Gm-Message-State: AOAM531YiecRwhwthttORTheJ/6PC4wLMRYqMiJtGlL6av7ZCFQxETaZ
        4YA0Vr0pDHFcZihKwJNB4Mk=
X-Google-Smtp-Source: ABdhPJzWelsxpATNzDh7WiN5DmYoUgmszxLAMbXhxJhyRcLs72MX+GhBFmN95SO/LOW8+mAszqzQ4A==
X-Received: by 2002:a17:906:8617:: with SMTP id o23mr10448587ejx.289.1612654173417;
        Sat, 06 Feb 2021 15:29:33 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id gz14sm5869589ejc.105.2021.02.06.15.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 15:29:32 -0800 (PST)
Date:   Sun, 7 Feb 2021 01:29:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
Message-ID: <20210206232931.pbdvtx3gyluw2s4u@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-4-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204215926.64377-4-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 03:59:25PM -0600, George McCollister wrote:
> @@ -1935,6 +1936,19 @@ static int dsa_slave_changeupper(struct net_device *dev,
>  			dsa_port_lag_leave(dp, info->upper_dev);
>  			err = NOTIFY_OK;
>  		}
> +	} else if (is_hsr_master(info->upper_dev)) {
> +		if (info->linking) {
> +			err = dsa_port_hsr_join(dp, info->upper_dev);
> +			if (err == -EOPNOTSUPP) {
> +				NL_SET_ERR_MSG_MOD(info->info.extack,
> +						   "Offloading not supported");
> +				err = 0;
> +			}
> +			err = notifier_from_errno(err);
> +		} else {
> +			dsa_port_hsr_leave(dp, info->upper_dev);
> +			err = NOTIFY_OK;
> +		}
>  	}
[..]
> +static int dsa_switch_hsr_join(struct dsa_switch *ds,
> +			       struct dsa_notifier_hsr_info *info)
> +{
> +	if (ds->index == info->sw_index && ds->ops->port_hsr_join)
> +		return ds->ops->port_hsr_join(ds, info->port, info->hsr);
> +
> +	return 0;
> +}
> +
> +static int dsa_switch_hsr_leave(struct dsa_switch *ds,
> +				struct dsa_notifier_hsr_info *info)
> +{
> +	if (ds->index == info->sw_index && ds->ops->port_hsr_leave)
> +		ds->ops->port_hsr_leave(ds, info->port, info->hsr);
> +
> +	return 0;
> +}
> +

If you return zero, the software fallback is never going to kick in.
