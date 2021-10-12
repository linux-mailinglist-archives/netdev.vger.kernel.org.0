Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E3942AEFF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 23:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhJLVeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhJLVeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 17:34:18 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89952C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:32:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso2855922pjb.4
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UuTzM5CVmArglmE2h+26gQl45Rb2Vv7PxPMd5F22Lts=;
        b=LHXgCTSIEB9VYaOrQ2wW7ep2nZGh2Moy/TMTMEUKNj8da6b7OEnX1akpRE+g5xmMjq
         hE7SReqIRadOS7fT6gZQspw92aS1m5kq+HR17zPV1cCM/hBUVKxRZmrN9TaU29qFoZww
         mAH8MvFhCObhZbPbXrflxTwWRNQrfOOkA7TgdVhhCkFsWHBl9w+AAJqLVdFVVQKKqQN9
         ael+Noy9c9gOHTpFWcJ/hRgtF7xToJUYsjUmEoyxsqeUHZ64IeiJKNBjDIiknHlRvMcB
         CzWw206v7pEPRZqfHhorbhiFToNZ6Q8ODahgcrFSP2wZ+LaYkCECvse+wDjk4fppGR6n
         iWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UuTzM5CVmArglmE2h+26gQl45Rb2Vv7PxPMd5F22Lts=;
        b=ZZKufK8Q51lig/Ebpvyr7xQ3s9j7Wul+Zwzzqq/smpF4ARrroJsFYXsJUMFbgQW5YW
         L2IZW5WNer9EXifxOg34kC9+xwO4WRph9XQXd2GSA3WRwnZYMLEJMzuOHDzpZ1CRn0fd
         3hnrLJbBZEJVmK/dUOT+QvkyTQ5HCr6q1kFDmwGfjLFOAf+pohRK964SYlaUawk4DA1C
         At9PGu1Kkv9QbtB0iKZomQFBzWIqtKNeS+Qio0owNNdaa3E37UkgMOQi6OBdG/1MuNr/
         5wj5KqbJf8G40ZC2b8ABD8DpUTWEECqM3FfDTzM4iMUA+htfbwC0PEXawVJWLGh1p+wA
         nZGQ==
X-Gm-Message-State: AOAM533DX6PRlPYky/cds4pWFcyUysTtjo8Ysrzb9qntmvsQLT1bQRVH
        M53A3R+O4U3ZzbdF0EXTDa8=
X-Google-Smtp-Source: ABdhPJz8N7F6LsUv6fL1m73uNFFwgM57HAwoW8Xr8xRtm9VDtNXimdZtdUjaeHP0Aw+8HU11MY5Q2Q==
X-Received: by 2002:a17:903:32c7:b0:13e:ea76:f8cb with SMTP id i7-20020a17090332c700b0013eea76f8cbmr32151752plr.74.1634074335982;
        Tue, 12 Oct 2021 14:32:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d60sm3604856pjk.49.2021.10.12.14.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 14:32:15 -0700 (PDT)
Subject: Re: [PATCH v2 net 06/10] net: dsa: tag_ocelot: break circular
 dependency with ocelot switch lib driver
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
 <20211012114044.2526146-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <78c1c3cd-f378-ba08-2588-ce982d34479e@gmail.com>
Date:   Tue, 12 Oct 2021 14:32:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012114044.2526146-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:40 AM, Vladimir Oltean wrote:
> As explained here:
> https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
> DSA tagging protocol drivers cannot depend on symbols exported by switch
> drivers, because this creates a circular dependency that breaks module
> autoloading.
> 
> The tag_ocelot.c file depends on the ocelot_ptp_rew_op() function
> exported by the common ocelot switch lib. This function looks at
> OCELOT_SKB_CB(skb) and computes how to populate the REW_OP field of the
> DSA tag, for PTP timestamping (the command: one-step/two-step, and the
> TX timestamp identifier).
> 
> None of that requires deep insight into the driver, it is quite
> stateless, as it only depends upon the skb->cb. So let's make it a
> static inline function and put it in include/linux/dsa/ocelot.h, a
> file that despite its name is used by the ocelot switch driver for
> populating the injection header too - since commit 40d3f295b5fe ("net:
> mscc: ocelot: use common tag parsing code with DSA").
> 
> With that function declared as static inline, its body is expanded
> inside each call site, so the dependency is broken and the DSA tagger
> can be built without the switch library, upon which the felix driver
> depends.
> 
> Fixes: 39e5308b3250 ("net: mscc: ocelot: support PTP Sync one-step timestamping")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
