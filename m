Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901913050E3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbhA0E3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392027AbhA0B0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:26:30 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E745C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:25:49 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bl23so371490ejb.5
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=15IydQiA9hpQhLDME5GNggltgsMDgWF0wfBWZ7OOfrU=;
        b=jE/jdMx0DTI3e4B/uY7oxauZB+D7+gm4tJkSsTUhjcJD722evlE2sVvPiISS3butFw
         DTuYECjBYIUqeinkmcu0B2AOW+DXKkTG0YwNU/fv6PUzII9ZOgJuCHBwjT8lHoXFA7ei
         mGKuovY790cubPfX3UyIpwU7yEthITyryjIrpb7mmCq70N7Zp3G3fM/t7JiQaIwDqm73
         /EGfOiLT4/JCJazhuoanROHmO8u/Kr0brlL9rGJmVL6vS8+qvaTQCRAwqDn94eKvGHVI
         dKLtv6Q5g1nyC5Dc7ArzhNKPegqdwXE8fXLSvLbfWSrwlPGdI0dMlDrAbVd/IhOiBRDQ
         8nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=15IydQiA9hpQhLDME5GNggltgsMDgWF0wfBWZ7OOfrU=;
        b=O0eAhX0qhYMfMY75WnT8QnTPEwwjRu/5kH+LKoh4U62M8gH3+Dcj2DWqS4xHCL4hm4
         pXP/Sbm2Arn5rD6hOAKzk6xIOABU4uv3rkV6d0fmwK1AWrtr6OasOI5ZD3vcE3b4VPjs
         jsVaQZ4sIkXmV6G4rwR35gKk3s5y8UqcFcwpZEKRmfaICC2GDHLP0R8+f3YiIZuOv26l
         lfLFtOJK2dgbLBGZsQlT8jOICoZFO5bX8ACtjYg9V+K/CILKi1jjwjaDIHsnnqloxDJF
         auUSL4j7uqTGisrx60ADLUeUu7oe2x1WXW4l1C31ulrJ+ufF2+v45jy1KqL2pS9HCK6g
         mCzw==
X-Gm-Message-State: AOAM532I79cPd0mOWOWxfr9dRkpeLQVQWww2UWbin75MqTf+QYLTPQHw
        XrzCl7v9623lzy40E+eOVCY=
X-Google-Smtp-Source: ABdhPJzeRcGWnBGtIB9C1/qyNTNUyR+Q3X0YBVwfG+aBJa+McoAkyMXZYVTaNu8U25fqvYzWyZUTOQ==
X-Received: by 2002:a17:906:690:: with SMTP id u16mr5242222ejb.186.1611710748256;
        Tue, 26 Jan 2021 17:25:48 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id o17sm290462edr.17.2021.01.26.17.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:25:47 -0800 (PST)
Date:   Wed, 27 Jan 2021 03:25:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/4] Automatically manage DSA master interface
 state
Message-ID: <20210127012546.bdad5fmu7vg2ki7t@skbuf>
References: <20210127010028.1619443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127010028.1619443-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 03:00:24AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series adds code that makes DSA open the master interface
> automatically whenever one user interface gets opened, either by the
> user, or by various networking subsystems: netconsole, nfsroot.
> With that in place, we can remove some of the places in the network
> stack where DSA-specific code was sprinkled.
> 
> Vladimir Oltean (4):
>   net: dsa: automatically bring up DSA master when opening user port
>   net: dsa: automatically bring user ports down when master goes down
>   Revert "net: Have netpoll bring-up DSA management interface"
>   Revert "net: ipv4: handle DSA enabled master network devices"
> 
>  Documentation/networking/dsa/dsa.rst |  4 ---
>  net/core/netpoll.c                   | 22 +++------------
>  net/dsa/slave.c                      | 40 ++++++++++++++++++++++++++--
>  net/ipv4/ipconfig.c                  | 21 ++++++++++++---
>  4 files changed, 59 insertions(+), 28 deletions(-)

Please treat this as RFC. There's still some debugging I need to do with
nfsroot.
