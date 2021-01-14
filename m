Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1E52F5651
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbhANBp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbhANA75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:59:57 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A626C061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:50:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r5so3922183eda.12
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WzM0kW9KIANkrXNxty9Z/6HjCvsomvvMOCUXJPnbuJo=;
        b=HuJ23eoMvdhnYBOSy4v7YrrZQgP9MN6+IsYNDlQGE50btEflE9gy4sz6YmwmLynlC0
         GJ4K57GMPwX9ZBD7DTO0hKaAU7LyqYM3IooY0VU6NZy47BSdRRhi1M0/zAC5tlHZkvmW
         Q5b6CZoZGBZnbCcCIV/zkkbIWDHQHMG4yHbMbrJovDNm+EZhW7DRb7uf8Qj774klaN1q
         mJHLyv8spvq7AFuyUs8X0IGtSWzyOpHN11fZmxv7EDMM2P6wOWxKoe19OdDnhgSsR+ME
         Yl5zUaYVODdrUnPWhEBs2dS988xci+QzpaGWnG67EM46rwKmQQeTeo+PCY6IxtNZtvYP
         zbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WzM0kW9KIANkrXNxty9Z/6HjCvsomvvMOCUXJPnbuJo=;
        b=DEBD9ialB71Xn/yTNMPXCWNXtxAhGF7juqZsATujAkJa1lvCOFNSPrEITnkrBeNXVZ
         RtB8dO8S21bhezk5LZRKa+olkLq6QP91e/dWNmC6rDG5bJa3ovjo/KgniRjmjkuBWP5g
         icQ49TczGrf5ucAHQZT6ZjOZ0hj606nFiLJlLVkaV6Gs2MN/o6snoYlx8RplG/8XHOz3
         rLsBoESyQtiUfimtZX2krs8tGIedyQZq39GFt8d2QsN96gEyWHk+nqIxkhgerGj8fNFf
         2xVw7eIRU+b3ZuppJW2qfEsREYXCS3q40NlRNkIRkT2wO+hmPqXKay2OXuzecJ215Ep+
         6PTQ==
X-Gm-Message-State: AOAM5337byowRg0UsnT11hKzRin31GUVJBzuznZnKWsI2Cv0JRVsIBTA
        hy/PkxYgW5yNyyHVK1mtwRA=
X-Google-Smtp-Source: ABdhPJxc5uobFRcyz5Z+hnVbGD+B8qi1YdoFF8DU0XIcNHWfPlibkfIyq+GLjINpJtIqgcD9uQaf8w==
X-Received: by 2002:a50:f0dc:: with SMTP id a28mr3837994edm.291.1610585417855;
        Wed, 13 Jan 2021 16:50:17 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id g10sm1467354edu.97.2021.01.13.16.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:50:17 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:50:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 4/5] net: dsa: mv88e6xxx: Link aggregation
 support
Message-ID: <20210114005016.2xgdexp2vkp3xmst@skbuf>
References: <20210113084255.22675-1-tobias@waldekranz.com>
 <20210113084255.22675-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113084255.22675-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 09:42:54AM +0100, Tobias Waldekranz wrote:
> Support offloading of LAGs to hardware. LAGs may be attached to a
> bridge in which case VLANs, multicast groups, etc. are also offloaded
> as usual.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
> +				      struct net_device *lag,
> +				      struct netdev_lag_upper_info *info)
> +{
> +	struct dsa_port *dp;
> +	int id, members = 0;
> +
> +	id = dsa_lag_id(ds->dst, lag);
> +	if (id < 0 || id >= ds->num_lag_ids)

This "id >= ds->num_lag_ids" condition is there just in the off chance
that the mv88e6xxx could be bridged in the same DSA tree with another
device that reports a higher ds->num_lag_ids such that dst->lags_len
picks up that larger maximum, but otherwise the two switches have the
same understanding of the LAG ID, and are compatible with one another?
That sounds... plausible?
