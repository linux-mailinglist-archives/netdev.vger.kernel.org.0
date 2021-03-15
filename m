Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005DF33C76F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhCOUIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhCOUIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:08:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81B1C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 13:08:15 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o19so18852992edc.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 13:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D+lqwLpOT6J3TRqivCuz1wOiCJrOV8LKQHUfp4Edn38=;
        b=uKfoaQHtVKvYQT5G6wn8zQvY8QkS53mh5kg8k7LKvnYLUcjLa9uCD66WWJOv5/3qaL
         KS5MhlX2PWOCsxNlAAn1ZlcCqwM40a9jQWfeFv+CvlwWRJCZHqFOTES7l5bqK2jasOaB
         KkVPnzhw4IvUsPDE7gd8SulgPsa9TgD2R0rGSbwlfqZ1MDqyKGbxz4jdzxoM06ikX12K
         6qvvJWLf5uS2RG9IkIe17hmhB2sAw/n2kI1Ez9B5DBTF/YCS+cXb+R9CjE5wg4Ke9c7d
         l4eWI3dtnJetLMxH2DFTk6o0wR5ahtzOMBhiEve2Wy6oFeEl+Y/AVAGjhDO39a+FS+1z
         G9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D+lqwLpOT6J3TRqivCuz1wOiCJrOV8LKQHUfp4Edn38=;
        b=RAYtDf2DgsNQvx5Aq50iJ5rzTL2DjWjDw0z76NPqHGlDGfYko3/70l+K6zJwRSnWfA
         PzyKMU6Dar6j5oFiYZm4Zr53wqWnfcH63LLVemh8SGo0iMRgPgb/B7KEjdCYIVcHSnzi
         KUIl+OoZ+xjbrXX26irpWMISJZim1eTN7pa+Ax3jpeuw/CcBkq1CdFdsqJ/0GsDQ3Rb8
         SbIwwIv0hj2cb3mo1rB0D155h06LpAWT4yqGz1CAj7n1zziKV751rNH5gotBYIf0J/1m
         Oa/vMrbgHkhQQ2VLBVFRIhKnz9R0txg7A1Vyuwt2VsqwNTmmovWdvDKNt6rop/cKC7mf
         Xe8g==
X-Gm-Message-State: AOAM533olHshCvyDTnqBIb1Xo4O9hxjQ4begOET7txwykP95Quy87tJt
        fDTE5YWigfBP5IkE2EKI5uY=
X-Google-Smtp-Source: ABdhPJww+k9SoCpcXZLfWAB/Ug8a8Of8ckEEjD2NgKaxJK99/OQ/Vz7ir9h0goNB8x69AcofiO8EuQ==
X-Received: by 2002:aa7:c907:: with SMTP id b7mr32552342edt.37.1615838894597;
        Mon, 15 Mar 2021 13:08:14 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bm10sm8843639edb.2.2021.03.15.13.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 13:08:14 -0700 (PDT)
Date:   Mon, 15 Mar 2021 22:08:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Offload bridge port flags
Message-ID: <20210315200813.5ibjembguad2qnk7@skbuf>
References: <20210314125208.17378-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314125208.17378-1-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 01:52:08PM +0100, Kurt Kanzenbach wrote:
> The switch implements unicast and multicast filtering per port.
> Add support for it. By default filtering is disabled.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 129 ++++++++++++++++++++-----
>  1 file changed, 104 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index c1f873a4fbc4..6cba02307bda 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -600,6 +600,83 @@ static void hellcreek_setup_vlan_membership(struct dsa_switch *ds, int port,
>  		hellcreek_unapply_vlan(hellcreek, upstream, vid);
>  }
>  
> +static void hellcreek_port_set_ucast_flood(struct hellcreek *hellcreek,
> +					   int port, bool enable)
> +{
> +	struct hellcreek_port *hellcreek_port;
> +	u16 val;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "%s unicast flooding on port %d\n",
> +		enable ? "Enable" : "Disable", port);
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	hellcreek_select_port(hellcreek, port);
> +	val = hellcreek_port->ptcfg;
> +	if (enable)
> +		val &= ~HR_PTCFG_UUC_FLT;
> +	else
> +		val |= HR_PTCFG_UUC_FLT;

What does 'unknown unicast filtering' mean/do, exactly?
The semantics of BR_FLOOD are on egress: all unicast packets with an
unknown destination that are received on ports from this bridging domain
can be flooded towards port X if that port has flooding enabled.
When I hear "filtering", I imagine an ingress setting, am I wrong?

> +	hellcreek_write(hellcreek, val, HR_PTCFG);
> +	hellcreek_port->ptcfg = val;
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +}
