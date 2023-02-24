Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10646A15C7
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 05:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBXEQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 23:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBXEQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 23:16:08 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F84A54548;
        Thu, 23 Feb 2023 20:16:07 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id l2so1697711ilg.7;
        Thu, 23 Feb 2023 20:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lqH7N7uaBkOCzr1hnwZ19qUyYAeJpV9ahTDpqeJHd+g=;
        b=fVIB2hhqmWhf9RXMqATrsA/BSwTEse/PqfkjmYPy5j+67+nB9BtVr/117YTSqgEbYB
         I9WQ7jBX96IckIWE78BXbw2EQz1ZHQckUFMaDqi900lFwH2Y+8et6wOlCjuk+rcAFlGU
         34nyGBUpmliNWtyCzjrSVm20sqwFB0XEoXm8EIF7j9EbUZGMVlF6fz0/jfPxFjaV72pg
         AhP4KXbOVu39HJXdE2BF7/Hy1ZrmPDKopERVmKv75u4YFTB77Sv9/93tHOedkEdEZsCN
         qiA/yym84BvbStGzemRJ1NYdI0kYlCTcdKKnsJNsGyX+ypPGdh1xsy+LEUst5kz9ieog
         0c5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lqH7N7uaBkOCzr1hnwZ19qUyYAeJpV9ahTDpqeJHd+g=;
        b=HGK6AX8/U0d0wmOWiR/r7Uz9o8knwQ5FO52viNsjD1fOGzSwhKLhx+hxg2Oj6fxbfW
         xC9XaRXhfGQd8mhzBnNwowdhBym2RgBOj90vm3SfvhAX46x/BmusxgRmr/qvH5x/Slwu
         nGhqi5r79Y6jMGoZ0vGs+KfsBd7dukATJVmoRmug3cYMBpv8lV3SyuXnoltKRb5yJfeM
         4L7m3FI4Lq2qychDcOLTVZoN9PE7ceyqM5Ug7L9NnqeSPpnqMOfGc8iDCXxrNUbmkwsh
         Y+fPXxGhQWnmoQEbiOWpMsBUhydRkuX2PX6o6FY9q34Bd5A5kk3woHTvLx0x0NQeKcCk
         TqRw==
X-Gm-Message-State: AO0yUKWQpTdFmDAkktN9xgsxA4ExjDaEG+3/nk9rvhxhMj5lqhlopFIZ
        XFvzcw0dann7ktN3VAaxev8=
X-Google-Smtp-Source: AK7set8KmX2GXue/WAKm1TalipiACk5vFlQuSnXwrGz6mr8anfKnHXXZ+kJ/AAxXpx5+3DLqaxahpA==
X-Received: by 2002:a05:6e02:1c89:b0:315:9937:600a with SMTP id w9-20020a056e021c8900b003159937600amr14879503ill.26.1677212166731;
        Thu, 23 Feb 2023 20:16:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l20-20020a02ccf4000000b003a4419ba0c2sm2155388jaq.139.2023.02.23.20.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:16:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 20:16:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <20230224041604.GA1353778@roeck-us.net>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224035553.GA1089605@roeck-us.net>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
> On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
> > Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
> > 
> > It should work as before except write operation to the EEE adv registers
> > will be done only if some EEE abilities was detected.
> > 
> > If some driver will have a regression, related driver should provide own
> > .get_features callback. See micrel.c:ksz9477_get_features() as example.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> This patch causes network interface failures with all my xtensa qemu
> emulations. Reverting it fixes the problem. Bisect log is attached
> for reference.
> 

Also affected are arm:cubieboard emulations, with same symptom.
arm:bletchley-bmc emulations crash. In both cases, reverting this patch
fixes the problem.

Guenter
