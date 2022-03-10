Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68524D4D9C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbiCJPwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiCJPwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:52:22 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D50182D89;
        Thu, 10 Mar 2022 07:51:20 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id s25so8345447lji.5;
        Thu, 10 Mar 2022 07:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=fqdAl6g8T5b8CCdXDXU4kRWnVjawXTgSM4gnCS0YVDA=;
        b=ZWEgd7vuurDAY2I1OnulI6eiSL8yCLgaJoxMpVzt5uZhruJGgevRtmuMUMEDF/HrhA
         JCzlSUE7nEOuEstZXK1itDK7t2VNObOx8xyy5uxT9r5FS17kwIYw3Cz0wsxWFFE0ybSb
         YvET/f3syD85/VklUOqtDB0b6zfJ17S2Y/MTUHsRfTcabLGRuStz8HvoQ7AgSTZdc1pT
         Nm3ce8YwJ94fV35BlYmiohPT04whu4tCW5+w4L4kcC7z4LX/1nm8ATMQceEk3Bm/Ea9D
         QWN0GR5dVwT5xUq055j/e4Ld2/PAoL4O/cNV6xu9daYhvQwfRzigDSX8GGgcemWmcc9s
         JaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fqdAl6g8T5b8CCdXDXU4kRWnVjawXTgSM4gnCS0YVDA=;
        b=EIjyVdv0lWh+3JEMbf1FxAEUx3zKWvHxZdJ7ihOtfSyI3H6OvSZQQOh6KK9OUjPO/C
         F5rz4Cr+cgogdz0qorhYTW0WJGW3/aeP0p49/38uxlKiGZ9trsz/OpDgZz2wazcFVUcX
         S8Zbm4rHmxpA+J3wthXYRPyYL08z9lBD7lnSS9OMufrIljMHm8Tfdj8JzNeuVXBZdTdA
         5I1VUcNii7iuGpVmc4BEEe02V2EsTq+LxQfBjYlhIfCnVYbiQDbg4/TUD1nA3bCoiGyP
         sNNfWmflJnvMGsCE3t8AWkrs6+9yK2L1jUP57OPywhjmGE34+Ij7jKnYpkiiutDEwpr3
         azMw==
X-Gm-Message-State: AOAM532bSiCa1EAOpchzy/te1aey4Ys14XgLEsaacXKqDLngO08tJKvv
        EFcQ2M9TSFKSrcEb8JggyYc=
X-Google-Smtp-Source: ABdhPJxA1m2GpjuOi6M2cRVlISGhS+trkh208Chi7ZhCdX+8Dd2aCE0bKm2WTunAi9Vtc2a9O1Bsjw==
X-Received: by 2002:a05:651c:543:b0:247:e3b1:9ac3 with SMTP id q3-20020a05651c054300b00247e3b19ac3mr3439662ljp.438.1646927478958;
        Thu, 10 Mar 2022 07:51:18 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id bq1-20020a056512150100b004481de98e5bsm1039808lfb.305.2022.03.10.07.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:51:18 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220310150717.h7gaxamvzv47e5zc@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf> <865yolg8d7.fsf@gmail.com>
 <20220310150717.h7gaxamvzv47e5zc@skbuf>
Date:   Thu, 10 Mar 2022 16:51:15 +0100
Message-ID: <86sfrpergs.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 10, 2022 at 17:07, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 10, 2022 at 04:00:52PM +0100, Hans Schultz wrote:
>> >> +	brport = dsa_port_to_bridge_port(dp);
>> >
>> > Since this is threaded interrupt context, I suppose it could race with
>> > dsa_port_bridge_leave(). So it is best to check whether "brport" is NULL
>> > or not.
>> >
>> Would something like:
>> if (dsa_is_unused_port(chip->ds, port))
>>         return -ENODATA;
>> 
>> be appropriate and sufficient for that?
>
> static inline
> struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
> {
> 	if (!dp->bridge)
> 		return NULL;
>
> 	if (dp->lag)
> 		return dp->lag->dev;
> 	else if (dp->hsr_dev)
> 		return dp->hsr_dev;
>
> 	return dp->slave;
> }
>
> Notice the "dp->bridge" check. The assignments are in dsa_port_bridge_create()
> and in dsa_port_bridge_destroy(). These functions assume rtnl_mutex protection.
> The question was how do you serialize with that, and why do you assume
> that dsa_port_to_bridge_port() returns non-NULL.
>
> So no, dsa_is_unused_port() would do absolutely nothing to help.

I was thinking in indirect terms (dangerous I know :-).

But wrt the nl lock, I wonder when other threads could pull the carpet
away under this, and so I might have to wait till after the last call
(mv88e6xxx_g1_atu_loadpurge) to free the nl lock?
