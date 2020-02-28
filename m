Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A441738C4
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgB1NpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:45:22 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46319 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgB1NpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:45:22 -0500
Received: by mail-qt1-f193.google.com with SMTP id i14so1974045qtv.13
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 05:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rzv670Spk0hNYyQG/ooKntntEH6hH/3Fmmslil28mxY=;
        b=ONhA0pz5RNqC6ajCrhMmnR5avnW2Bs73Jfdzjb8+XyXd6B7x5bcBGbIhaKLHuqMJlP
         TdmAWyqKwOOBVZgfDz5D9/NJaz6Pf0feHBEC+eAH8fxLPTRVnURa8TW8+6UCGiqf0FbA
         695cMK8p1G9V4Nv4Lr9CenFVxXXwUvrntO331foH3EJms/DianIhw11ukTbgONB6/mFb
         mNnp7t4SsiYJQ2ENYdnVQxxV1Tbd/kajTIGtKoMog57Nt/4612RTlCMh1u3vTxgOZ/6N
         jC/JdIdI9dQ/dBfoRbCmK4kUlTbVnM806IUIjFFZ6IJBNq7zyXO6SDcQG5EJCJ3tsdL8
         +npQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rzv670Spk0hNYyQG/ooKntntEH6hH/3Fmmslil28mxY=;
        b=g7ubxtQX+x3DoX0p2TBhj4HQCuJL2Camk367p35cTMiW4N74WlT4LS48EaYeLM/0jT
         M16I6CZH7yApJ6p1Dot2AytZPHIUAvaFtvEX7bsgJ5VoQ8NDVojra5Kji1dPJw62cm+o
         XYSpN0GTV3jTMerWstn3jdFqLMbfTbDBcKuelF4P015NVuCUxi8gmZNRlpcg8N++ZAub
         rH3/cp9SYV1kQezMaPOEVD2WxIbMioQ3CzUea/jCOvt+r+MUG8c/x40dCZ2+3vHje2nR
         igw49FMulqXh6cd4ZVRWrVV7lwANKA/I8bP7tX+w0smcxDt6p7KekChcQxKlDXkqQoVH
         ANpA==
X-Gm-Message-State: APjAAAU0QCizhvuVWsCa1MDlXMNMXQj1QoO9e7Rdkn36ALpYnpV5hNbY
        IgV8TlbVfjvT+zOkAJxSWUo=
X-Google-Smtp-Source: APXvYqw5V392gIQEn/Uf0USj+99RRmMEw7gnzbIXJOp2w3ZMh0/fl5zMCkHVKEeXBL/cN7PrQJUnwA==
X-Received: by 2002:ac8:60d5:: with SMTP id i21mr4321381qtm.341.1582897520416;
        Fri, 28 Feb 2020 05:45:20 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.223])
        by smtp.gmail.com with ESMTPSA id j17sm5276550qth.27.2020.02.28.05.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 05:45:19 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 145E0C4B66; Fri, 28 Feb 2020 10:45:17 -0300 (-03)
Date:   Fri, 28 Feb 2020 10:45:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next 4/6] net/sched: act_ct: Create nf flow table per
 zone
Message-ID: <20200228134517.GA2546@localhost.localdomain>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-5-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582458307-17067-5-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Feb 23, 2020 at 01:45:05PM +0200, Paul Blakey wrote:
> Use the NF flow tables infrastructure for CT offload.
> 
> Create a nf flow table per zone.
> 
> Next patches will add FT entries to this table, and do
> the software offload.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   1 +
>  include/net/tc_act/tc_ct.h                      |   2 +
>  net/sched/Kconfig                               |   2 +-
>  net/sched/act_ct.c                              | 159 +++++++++++++++++++++++-
>  4 files changed, 162 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 70b5fe2..eb16136 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -45,6 +45,7 @@
>  #include <net/tc_act/tc_tunnel_key.h>
>  #include <net/tc_act/tc_pedit.h>
>  #include <net/tc_act/tc_csum.h>
> +#include <net/tc_act/tc_ct.h>
>  #include <net/arp.h>
>  #include <net/ipv6_stubs.h>
>  #include "en.h"

This chunk is not really needed for this patchset, right?
