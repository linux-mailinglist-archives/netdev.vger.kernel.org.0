Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705AE24B79
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfEUJ1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:27:35 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39990 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfEUJ1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 05:27:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id q62so5696757ljq.7
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 02:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Xy6KpBMf4VElfSxI8JZgNkIn+5swVz4A7VXhYDp2D4=;
        b=gi0FnqEmcboPROS3aUYX2FmzKmldrXp2Xd53Cs+z0s80NF/1tJ+89FLSOmuykkWh0a
         Bseps+m7BHSnZFk5NVsRLKcGhVs10u9VBXuk7ZFWImQxcj/UfGSJbg6gJGqG3M6Eryu0
         +6VMdvaQODEdkEjm10eVWCg6HQioXvq/vhckhU8CXA37bZxImLyV9zUqEhECALNCOSWj
         Io7qmy3Kwb5wIloKJURrXpWb2PPdq2gW5p7a9/ShaO6loZBFBAo1n7iTGu7RKvdGnRAu
         5KIh2bLGig4OqmPNCI6RFNpRPS27XWQk6PKwqmubBBllN7izvBcvS8lnUx17EQ9e1BYP
         sbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Xy6KpBMf4VElfSxI8JZgNkIn+5swVz4A7VXhYDp2D4=;
        b=Q2TYnjuWLOi695KJDPiBHZzypCJRcHDD/ZwdVWBShLAvs6ge1A+0v2fIxVgLygo54T
         AQOz6ClPYmdlrWK+HRDpKDpxYV/Hyw0lcy1t5FLdg/3mTxjRAy8jXWiTazcZhqHNeSOI
         Skd5I7O9hekCCzA+vjKkgyL/FqDR0vSoC7GRESogWzDABcWikJfbmT6Zko+qHBQ+Pu9b
         vXzj8baIfs5FdSnfbhxsAZxP2Slrz7WgdZ7zmyi22WrwR1vL3EAFdOttQsr0iNPk5iHH
         D7UKZ9wPL5BahKEzvL6Pdx9Msj/wx1kXycvA5MelaIvrmNkeRcFs7FcBXuYLbhelTvkS
         XXCA==
X-Gm-Message-State: APjAAAX96L5SJlAhVhN/AzC86KMo25qA/pYH+kec8txvbyYCPNDDusRD
        a0/qD6AGwq24APTUEvCpw6323A==
X-Google-Smtp-Source: APXvYqz2W9cUR77wBpFQtxU/OEIMqFs1dqOYZh2m5bXIMOiU7pDh+NaARFsIcqKmxsWQZ0msZguFsQ==
X-Received: by 2002:a2e:60a:: with SMTP id 10mr3542802ljg.126.1558430852654;
        Tue, 21 May 2019 02:27:32 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.81.21])
        by smtp.gmail.com with ESMTPSA id u128sm1039382lja.23.2019.05.21.02.27.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 02:27:31 -0700 (PDT)
Subject: Re: [PATCH v5 2/6] net: stmmac: sun8i: force select external PHY when
 no internal one
To:     megous@megous.com, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>
Cc:     Icenowy Zheng <icenowy@aosc.io>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
References: <20190520235009.16734-1-megous@megous.com>
 <20190520235009.16734-3-megous@megous.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <4e031eeb-2819-a97f-73bf-af84b04aa7b2@cogentembedded.com>
Date:   Tue, 21 May 2019 12:27:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520235009.16734-3-megous@megous.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 21.05.2019 2:50, megous@megous.com wrote:

> From: Icenowy Zheng <icenowy@aosc.io>
> 
> The PHY selection bit also exists on SoCs without an internal PHY; if it's
> set to 1 (internal PHY, default value) then the MAC will not make use of
> any PHY such SoCs.
          ^ "on" or "with" missing?

> This problem appears when adapting for H6, which has no real internal PHY
> (the "internal PHY" on H6 is not on-die, but on a co-packaged AC200 chip,
> connected via RMII interface at GPIO bank A).
> 
> Force the PHY selection bit to 0 when the SOC doesn't have an internal PHY,
> to address the problem of a wrong default value.
> 
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
[...]

MBR, Sergei
