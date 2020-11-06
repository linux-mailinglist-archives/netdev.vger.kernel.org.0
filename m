Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0872D2A98A7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgKFPka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 10:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgKFPk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 10:40:29 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E880AC0613CF;
        Fri,  6 Nov 2020 07:40:28 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id o23so2509654ejn.11;
        Fri, 06 Nov 2020 07:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bKIJ50PdgwgAwP/V0//eIhaUmG6dnst+EUp5L+hwnTA=;
        b=SeeVVyYdNacRU44UQ1B3hEASTXd8FfRWywCm17l9zMe+Or/BqJi3dnzHPZAlZt0OZK
         2nhuJpOd79difwmfPRDzfH6m0Bgv6AGEyhWnpBia95Er0EgoH6I1Hs+qGnnlqb0FXSN0
         g3e938GrK9h1Zd31YsCCOgs9dhUv1p0CsBecH3sF9scBBxCrRG5ywmFwRIy3taXw7q34
         m5CVYOoz01tNmjsdOaud49k440IuVMx15dwSWIjcSTT0ujP8YPyDByZpNSirJZnwhZ32
         GVaqBpyxyUSiEZqZHKgd5JY5U0L6gTCBmKQG5+2YpXKptOt4G3XtAcp0wtbsYUtyQVVT
         2SJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bKIJ50PdgwgAwP/V0//eIhaUmG6dnst+EUp5L+hwnTA=;
        b=bwBF9PXnds9ry5BudGZqAwxQO7RHz2wnRzzWFrNN6ZcPeqiWkeSmGCgjHBoLIdIvzn
         CcG7v8j02f2vj4dV98UiYcaFKprLl9Yd8EYJuvJtSo13P6Fzm3bt8tGWr16kJFFZi3wo
         ichgfk+Qs+WIB5M8pgnxwnhp7HEE0KDIl2zZ03PSHcXAH1d+a4NJVQXfDZuEWi+2fqgS
         OvcnRl8XDNjWJDwVmKSc/HH4lpYNiMcN7iY2bGrWGhLSL/VUWOEKtTUa6xm4ounmfB9R
         MTIH/PMnUyC05E+l7yEV9LTwows38KRFiFv+ym2M6smI84I0n6U1duGN9AjsJRVA2EOn
         eC+g==
X-Gm-Message-State: AOAM530YVw1vGDqLkJyf8AE8htGcsF2MJ6FX3gUAj36BvbTxDTeUqIF3
        CqDjfzUP52v9hJSsoYrIXWo=
X-Google-Smtp-Source: ABdhPJwGSjY7RtlCT8WKIcdPooMW1LiwS7Fm5EaWsga2Xl8WFPo5pIMB6myzWgsMEkPOxyOTb41pqA==
X-Received: by 2002:a17:906:c8d8:: with SMTP id gc24mr2705955ejb.417.1604677227257;
        Fri, 06 Nov 2020 07:40:27 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id r21sm1206458edp.92.2020.11.06.07.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 07:40:26 -0800 (PST)
Date:   Fri, 6 Nov 2020 17:40:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, Jose.Abreu@synopsys.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: Re: [RFC, net-next 2/3] net: dsa: felix: add preempt queues set
 support for vsc9959
Message-ID: <20201106154025.qx6am5ybknjuwzsn@skbuf>
References: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
 <20201020040458.39794-3-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020040458.39794-3-xiaoliang.yang_1@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 12:04:57PM +0800, Xiaoliang Yang wrote:
> +static int vsc9959_port_get_preempt(struct ocelot *ocelot, int port,
> +				    struct ethtool_fp *fpcmd)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	u32 val;
> +
> +	val = ocelot_port_readl(ocelot_port, DEV_MM_VERIF_CONFIG);
> +	val &= DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS;
> +	fpcmd->enabled = (val ? 0 : 1);
> +
> +	val = ocelot_read(ocelot, QSYS_PREEMPTION_CFG);

You have a bug here. This should be:

	val = ocelot_read_rix(ocelot, QSYS_PREEMPTION_CFG, port);

otherwise you're always retrieving the frame preemption configuration of
port 0, regardless of the port passed as argument.

> +	fpcmd->min_frag_size_mult = QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE_X(val);
> +
> +	return 0;
> +}
