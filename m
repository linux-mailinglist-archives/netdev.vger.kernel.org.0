Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C672FAD18
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733228AbhARWKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733070AbhARWKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:10:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62EAC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:09:26 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id dj23so16682935edb.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jSpOZRf4F2hJSUmNV52l0alFNh+doyBJ2+jsxRu+2xc=;
        b=a7Xux0AnWPYzwDvJufesKjQIbl4crAaCDaLumPEjeDyVJ5+uFU+A1VfjWRMrnEJMKT
         qGZYe53Fbh0ky4toaaHIxf8+l5G0fp7hzxhANcTmBjmiVizH6c8QgC5+qNvV4mbhyktY
         o61lt+dPa+OuWeEuGCbrIJcV+ifAioQMO7dGl9N4ieaGWW/iYD2a3l1/kNd7jbE+y2dz
         uGDip1hOTVC/RWVXiRmlXDwyD1UiDYtWiJKpEoCSHCBTFz6RDjwCCEGYgqOdopCNFB1n
         bnlupEiYvJGThqz6TDvLNGzDfgUP1ItTTo8Goyak5Y41ZXvSeR6JfalMZ5sAVTbO/p51
         hGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jSpOZRf4F2hJSUmNV52l0alFNh+doyBJ2+jsxRu+2xc=;
        b=fkFQdX9GwZ1p+H10F8zfPETY/0SxMcw8mGnOmlGKOLGNyvKpJCwaK8xgGMvDVD/ghE
         EQdQq0UNqM3ANfMTPvdPy8Lzv0g7M+nQ+RBbNmQr/ZTsfSVmJWlv6X7Dx435t3XsCWD1
         UiZk4h1+8Fu7M1nMwap80lfGRj/hbC8vXA/69K2W9KVNDTeUBasZLGmtjDEU7kKVkJFO
         b4wat7cjwSCZbNCxnApDlw9EqBMaUFgpk1lmmSyO6I95rX9vkCYgQj74GiCuepo2djYz
         ogFZFHVPuXPeNkqM5T5xJs1kaNoS9U/QTcx3m/1VlPSEl7aw3H278vxpPu0bJIDsG2Y4
         Xcpg==
X-Gm-Message-State: AOAM533PlPO8EL/ZzYLGZTZfd++NrSbWy/cTbkvxmOCS28wkf3lWb9dS
        7RY69Nx9zAT0cNjjWDAHXBI=
X-Google-Smtp-Source: ABdhPJwlCpB+CPlVW6A8o8WQQk1K6zAzs9fkaDIMqw3/SuBnpOY/+lfjlwXKMH6L1KFY6qoHHVqgpw==
X-Received: by 2002:a50:9310:: with SMTP id m16mr1175205eda.94.1611007765540;
        Mon, 18 Jan 2021 14:09:25 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i4sm10096698eje.90.2021.01.18.14.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 14:09:25 -0800 (PST)
Date:   Tue, 19 Jan 2021 00:09:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, netdev@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210118220923.7zlmtr3u4o657y7y@skbuf>
References: <20210117193009.io3nungdwuzmo5f7@skbuf>
 <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf>
 <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
 <20210118215009.jegmjjhlrooe2r2h@skbuf>
 <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
 <20210118220616.ql2i3uigyz6tiuhz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118220616.ql2i3uigyz6tiuhz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 12:06:16AM +0200, Vladimir Oltean wrote:
> And these:
> 
> $ ip link add br0 type bridge
> $ ip link set swp3 master br0
> $ ip link set swp2 master br0
> $ ip link set swp1 master br0
> $ ip link set swp0 master br0
> $ bridge fdb | grep permanent
> 00:04:9f:05:de:0a dev swp0 vlan 1 master br0 permanent
> 00:04:9f:05:de:0a dev swp0 master br0 permanent
> 00:04:9f:05:de:0a dev swp3 vlan 1 master br0 permanent
> 00:04:9f:05:de:0a dev swp3 master br0 permanent

Ugh, I messed it up. The entries with swp0 are stray here. The permanent
entries get reported only for swp3 in the second case.
