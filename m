Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B340A1CE89A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgEKW6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgEKW6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 18:58:11 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2967C061A0C;
        Mon, 11 May 2020 15:58:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w7so13029600wre.13;
        Mon, 11 May 2020 15:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=otPX3uLcjrv350EnvGLQbAsniTxU/sRWin7D1wiXypM=;
        b=KSY998xfjrnqF75kM2EM44JlFodsj223bdmDtG/CSueVqRU6TgaJhW7AFElGtxgOY9
         HmRQzt8UAR0JolBakiR17tGUrk1x4q0fEcank/yOFpHLqmxusTHzIf255E07+uogM2rs
         iUQ6QHn7L6MOEFbh2caYZiIVewEXeHvZy7HMk+6hnNo+ntGiCaUHcrTxHzjptqTkjESR
         XJdx2DIVZ4bKUW1fLrlQxyKhYgdS0WwOESWr4WoYOTcf9VXLUAYe3ukvWxbxrYO7aPz+
         HDoo7g2SyAlSXUQYfqr0tArskZuMZ6r/gYIDuSP/qwOj0uYcyo0pabrZXFJMLA/tjLKR
         d2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=otPX3uLcjrv350EnvGLQbAsniTxU/sRWin7D1wiXypM=;
        b=Cj6bj3BndllxhbgWZOnugBkTlqesRf69fcY4ISuVPkvtjvReHBkGh4HjFGc8uM3dHx
         HWhDDckYncD3jbhtowwFDmWVAa9w0ESafUN86pzoyZLa8GaL4gV0mIz7CMh4KQkB3Fkq
         34zx7r12/qaFFBQL6IrV6BSxREYGmMBpaCVHikWMiFsETU60P+71NCWQvDtY1Gur6fho
         pqai36qj6sQiSODjc4eftiEGu3e+y/2Eg0v+JUMR/EEVsKgV8oo+AwQWcjjhpxDFa2Me
         1DKnIiccv+/j7YsVLIcA3PdUvbER69JyS8kB+kaPtNePikTrbbfrwXRQmdbYemgByyO+
         IxJQ==
X-Gm-Message-State: AGi0PuYTelPuWQD4dNhKMiN1Gzvwz53qP8qRS4a72/tg8HhUxMtE9Zo4
        ElgwmCzLnfuT8Y/zaCJRwh6caw42
X-Google-Smtp-Source: APiQypLRSIbYrzetBnn6HrBWdJgE/7XwfajElAa9sSHZMsURzQ6Qwc1spW1f+pLNo5htm+kD2KCDvQ==
X-Received: by 2002:a5d:6803:: with SMTP id w3mr10930662wru.151.1589237890047;
        Mon, 11 May 2020 15:58:10 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c19sm20743522wrb.89.2020.05.11.15.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 15:58:09 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 01/15] net: dsa: provide an option for drivers
 to always receive bridge VLANs
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0b7da199-847c-f178-a330-3234278b273f@gmail.com>
Date:   Mon, 11 May 2020 15:58:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Provide an option that drivers can set to indicate they want to receive
> vlan configuration even when vlan filtering is disabled. At the very
> least, this is safe for Marvell DSA bridges, which do not look up
> ingress traffic in the VTU if the port is in 8021Q disabled state. It is
> also safe for the Ocelot switch family. Whether this change is suitable
> for all DSA bridges is not known.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

We may want to consolidate these checks in a helper function at some
point, and the name is still not super clear to me (not sure what
disabled refers to unless you read the comments), but this is as good as
it could be:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
