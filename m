Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD43E370A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 22:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhHGUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 16:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhHGUpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 16:45:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2793C0613CF;
        Sat,  7 Aug 2021 13:45:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c25so7734923ejb.3;
        Sat, 07 Aug 2021 13:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UX7cugeGwnRCrPEXlPOSjdRgHaxlQWVJIYETVe5lRjg=;
        b=NbJceOX2FnCfDvHVjGl478m+FoutH/jDuyjZE+vxfZQVXZN1yHr6RNaZk/96Zs1br1
         OboR23oVmG4XsrK245TlOJLZp/HhOBVlzHxiX08JBb5p5lUDxIh2pfHqWYT2G617bceW
         kjtUd6FFM4dpzzphXXOxoNC044AvNPYIpR47vfYa6lSS027APQj/6kvXK/LPSFT9l8rd
         cEkhvj78iHKCvfDqfBdmvVtfHMw/FAhDdO+UlM+pwEk3SDQTYXVoDIMET0Zd1IumYp7J
         enK16cTtsiPnlSB797Fa/wH5+7uxgpcqS8qXzZNmPP4FOGV5emVjL6lRl8K4SaNm+Nr3
         9itw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UX7cugeGwnRCrPEXlPOSjdRgHaxlQWVJIYETVe5lRjg=;
        b=o+nxEU0/Pr9AdugMxoBZn309fZH93XhCmBESSy7GIzbCdCp4ihlg9jJQ3fL9zfk1k7
         uMvzjKC+OQuo8OWNeP90uM7hdsY63TQppSFby8te3aFSZx/0bGQpt44/Fv3uJ8usmkD1
         0ag2VCNW9htyFedYNok4VWl+pf4vV+XFC91qMx48aQkuSGLqiKP1/UEeNWQYdsweLeHp
         dzq3qsVXQJzTb/jFkJ+R4/4ew6QEzJdjBNNg8GLRZgFe6Klcbt0jPqepfJBVwqtaHr8a
         S1riYtTAPz8LqTpJSw3xlfIxPuzDYycKnv0W4b5zn0vcAlID+pn25U8M+87QkLEsxJyR
         QP1Q==
X-Gm-Message-State: AOAM533zOCeIg1fRjgAYCELto2u+R6HO8t8XMrmbaj3D4LlDgRehOHZB
        XxWSTY9RKFJZ4wF3VS9COXs=
X-Google-Smtp-Source: ABdhPJxR5VvMDwLu4NEEnt2V7HoUu/i7zbukzf5BDLpAfxn5TnbWAhvCoAY6rnc3V0On2EbwsDAkWw==
X-Received: by 2002:a17:906:c08e:: with SMTP id f14mr15322642ejz.380.1628369125341;
        Sat, 07 Aug 2021 13:45:25 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c8sm398824ejp.124.2021.08.07.13.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 13:45:25 -0700 (PDT)
Date:   Sat, 7 Aug 2021 23:45:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?utf-8?B?QW5kcsOp?= Valentin <avalentin@vmh.kalnet.hooya.de>
Subject: Re: [RFC net-next 1/3] net: dsa: qca8k: offload bridge flags
Message-ID: <20210807204523.iy43swaq2sekgsj6@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807120726.1063225-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 08:07:24PM +0800, DENG Qingfang wrote:
> +static int
> +qca8k_port_bridge_flags(struct dsa_switch *ds, int port,
> +			struct switchdev_brport_flags flags,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	int ret = 0;
> +
> +	if (!ret && flags.mask & BR_LEARNING)
> +		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> +				QCA8K_PORT_LOOKUP_LEARN,
> +				flags.val & BR_LEARNING ?
> +				QCA8K_PORT_LOOKUP_LEARN : 0);

And fast ageing when learning on a port is turned off?

> +
> +	if (!ret && flags.mask & BR_FLOOD)
> +		ret = qca8k_rmw(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
> +				BIT(port + QCA8K_GLOBAL_FW_CTRL1_UC_DP_S),
> +				flags.val & BR_FLOOD ?
> +				BIT(port + QCA8K_GLOBAL_FW_CTRL1_UC_DP_S) : 0);
