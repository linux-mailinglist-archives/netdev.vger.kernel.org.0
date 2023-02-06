Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D4768BB54
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjBFLXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjBFLW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:22:58 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B41CDDB;
        Mon,  6 Feb 2023 03:22:51 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u21so11296820edv.3;
        Mon, 06 Feb 2023 03:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=89mzhfpMwGo7PKR1/PatOl9b0MredJgLBcvqmQuIsos=;
        b=R5l/rFg2hfJN4Wj1DzLjLgoSorhZnIBqmzAV9UiZxx+rMkTjYaVz/1AX9knJh5zwYT
         ARwxxRWjIb+olbuhgXbYCeqCwY+s8oiNOUobOrzkX+q9FeiqnM/wAxNoUtQDbz0fHxVh
         sbjZ5UFROAbisgEgy7CDHzx63jWdViVBkux1dCtjas9py/jgu78UieuRkLzj6QxwzAQL
         x1cLWPJ6Bq77/oBpS3IsF4+9xX1s+Ih+a7p+6nSO18p5Ev7La0SVer3Mgtj0UxVWp2F6
         nzecJrWXBf/YlkZkxqHDpgjFSCNX/ZUz0CmpE9MnK3baz3pEM+5NmxxpVnAxhqKCPRwJ
         f1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89mzhfpMwGo7PKR1/PatOl9b0MredJgLBcvqmQuIsos=;
        b=OFifHS3MbvGVnPcO2b9gEehtGLoGuws6R4z2wIWq3993E0PJlmYzZTEaPt0LvDQPG+
         k/1nMrsYWPP4ItT/NJxYKib1zyS9ePGoF8Zib0kGvXZj6xns/KVC2xHWCStVVVvbiVts
         Cr31veNELinpjtKldgspy5DCeEIn8zKHS7v5aPK6/ZD/NKGYdnFUMm24N0zE/xiUhF+q
         WYaM7D9enj89RH0o+gSaBjvnXniBHXPVcy38vhNVmVBEwb2IymsX+16oH2fFf9Wlxvax
         UjL5zrjdX3P3xHiDndO8CLWmom4Zidfvu7w3FtK95+mMtuj5iTvt2FKxU80hJDqb0fC8
         a3QA==
X-Gm-Message-State: AO0yUKUzdVfayNHiyh9RMIVsPqzjhshsneqf6nawn5P67pUFtpNHtiQe
        WCzjVnJSClQMt5NN1OFk4WA=
X-Google-Smtp-Source: AK7set/3xMzW3G37FoGcKu9LIx1OTFzcgWrglooE72i3J92ka2tGMb31EwYb7vBfBeh6Db60p2vG7A==
X-Received: by 2002:a50:c050:0:b0:4aa:b20b:c132 with SMTP id u16-20020a50c050000000b004aab20bc132mr4561406edd.5.1675682569735;
        Mon, 06 Feb 2023 03:22:49 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id g20-20020aa7c854000000b004a24b8b58cbsm4894984edt.16.2023.02.06.03.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 03:22:49 -0800 (PST)
Date:   Mon, 6 Feb 2023 13:22:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <20230206112246.pazwn7r75oru5iq3@skbuf>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-3-o.rempel@pengutronix.de>
 <20230204005418.7ryb4ihuzxlbs2nl@skbuf>
 <20230206104955.GE12366@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206104955.GE12366@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 11:49:55AM +0100, Oleksij Rempel wrote:
> > Why stop at 10GBase-KR? Register 3.20 defines EEE abilities up to 100G
> > (for speeds >10G, there seem to be 2 modes, "deep sleep" or "fast wake",
> > with "deep sleep" being essentially equivalent to the only mode
> > available for <=10G modes).
> 
> Hm,
> 
> If i take only deep sleep, missing modes are:
> 3.20.13 100GBASE-R deep sleep
>        family of Physical Layer devices using 100GBASE-R encoding:
>        100000baseCR4_Full
>        100000baseKR4_Full
>        100000baseCR10_Full (missing)
>        100000baseSR4_Full
>        100000baseSR10_Full (missing)
>        100000baseLR4_ER4_Full
> 
> 3.20.11 25GBASE-R deep sleep
>        family of Physical Layer devices using 25GBASE-R encoding:
>        25000baseCR_Full
>        25000baseER_Full (missing)
>        25000baseKR_Full
>        25000baseLR_Full (missing)
>        25000baseSR_Full
> 
> 3.20.9 40GBASE-R deep sleep
>        family of Physical Layer devices using 40GBASE-R encoding:
>        40000baseKR4_Full
>        40000baseCR4_Full
>        40000baseSR4_Full
>        40000baseLR4_Full
> 
> 3.20.7 40GBASE-T
>        40000baseT_Full (missing)
> 
> I have no experience with modes > 1Gbit. Do all of them correct? What
> should we do with missing modes? Or may be it make sense to implement >
> 10G modes separately?

Given the fact that UAPI needs an extension to cover supported/advertisement
bits > 31, I think it makes sense to add these separately. I had not
realized this when I commented on this patch. I don't think we want the
kernel to advertise EEE for some link modes without user space seeing it.
