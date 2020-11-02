Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D222A35CA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgKBVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgKBVJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 16:09:55 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F696C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 13:09:55 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id z3so5865798pfz.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 13:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VCZTqWjJ5NET14swin0nL6Yyc/xQCz/v3r824UpBkZg=;
        b=igMt19Zkl7IOOSmF1jSsbAv8j9bvcLknAExD7x+MPU/YC4L2VjFVMgPJZIall1R/Kb
         b5wfwFS7A1BEBfC1ru06rB3LLot7AArBOB36geU8xTCV32WUwkMJVaJxpWfhtwgBDGwR
         eNfyHAxCPjsK1J272WKDLhBbUaPEBvYF0OA9RAyW/rk6i/Y4DSd2mr22zY4HXYQLFpKn
         ek6WDoyz2WA0sKhUqg0enJXFKDuuv8rm5pxZ+5FhNJJjvVdAn9GbaBUvvNmmRVKvPLns
         E+1J09dgoOMllrVXpn48c+EGAjeryaDV1jNGwskQfs9YpnQVPWwTExDyWv7Pv0qcfJOX
         3+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VCZTqWjJ5NET14swin0nL6Yyc/xQCz/v3r824UpBkZg=;
        b=O0Oz8GU22In6pu6uyLtxpeRSEA4k1WUlvgfEN5QHIwoy36WKFi4YtJFa48A/ulqVmf
         DJIG2X2I3KnUh7IodafwxGYbOqZQHh2FBqCS8fHqxS5eEeUCtflo0JhZtexIZebAD2vF
         UJhZsI8cSgBBCmmlwOMB+wcd0jTK3A5ffi9+0v4pIobzpktJg1YhjQuMARSExMIqaNds
         fn0JvmQ9HvxhG6ZakUj2eEfPtJ8ZMmHbCLTv/p43c83PYlprlfN5kcv2SGPmcqJdrwHF
         EzOx2J5TaXNiG4fobm5msz+yILb/R6Gjj0qSlI4799lZK8LjYg8Jxzg5QLClsIwSfdAp
         Lb/Q==
X-Gm-Message-State: AOAM532txncDa8+zIuIb4w81AKcDDKiU44QzDhWVPh3Y8FSHN1pBZjH6
        3ExKiCNAOqfNcDJtH9QI8X/GcB+0hXs=
X-Google-Smtp-Source: ABdhPJwtoNcD0h1fhg2HzvvdgdSWUSnYIU/OP/IY+QRdvdoMF2aUbkzeh3XXhXhIFadRWR5Pgz0F1w==
X-Received: by 2002:a17:90a:6901:: with SMTP id r1mr87804pjj.178.1604351394795;
        Mon, 02 Nov 2020 13:09:54 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm14771764pfp.195.2020.11.02.13.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 13:09:53 -0800 (PST)
Subject: Re: [PATCH net-next 2/5] net: make ip_tunnel_get_stats64 an alias for
 dev_get_tstats64
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
 <944fa7d0-9b0e-5ae2-d4f8-9c609f1a7c20@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9dec93b0-7831-df91-87c4-d8bfde2ef13c@gmail.com>
Date:   Mon, 2 Nov 2020 13:09:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <944fa7d0-9b0e-5ae2-d4f8-9c609f1a7c20@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 4:35 AM, Heiner Kallweit wrote:
> ip_tunnel_get_stats64() now is a duplicate of dev_get_tstats64().
> Make it an alias so that we don't have to change all users of
> ip_tunnel_get_stats64().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  include/net/ip_tunnels.h  | 4 ++--
>  net/ipv4/ip_tunnel_core.c | 9 ---------
>  2 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 02ccd3254..500943ba8 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -274,8 +274,8 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
>  int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict);
>  int ip_tunnel_change_mtu(struct net_device *dev, int new_mtu);
>  
> -void ip_tunnel_get_stats64(struct net_device *dev,
> -			   struct rtnl_link_stats64 *tot);
> +#define ip_tunnel_get_stats64 dev_get_tstats64

A static inline might have worked too, up to you, really.
-- 
Florian
