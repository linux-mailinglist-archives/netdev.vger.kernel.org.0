Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5746A2092
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjBXRlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBXRlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:41:35 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E89613DC9;
        Fri, 24 Feb 2023 09:41:34 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id b16so162082iln.3;
        Fri, 24 Feb 2023 09:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D66DXx2We227H4fmDckhvZM7P6i8ZzxMoVouVh6j/zs=;
        b=WKuBl3B7cvk6c+mpL8SghVIeqliBMuw99ef1CXm0FRE8+yXqfFtxreRxRGbNkDWCt7
         TeiGnT5Y8noUXfCqv49uym2q2Ja1/zvCoYrfsE6/o+uarq8ehbCZtVMiotpHPZAPEcn7
         CqgGIgJzNzgx/VI31W+CmY1foUBaA8wtclqUL2pFCtUZ/01OjgK17XYIOU+k5lPO0YKp
         7h+fTvGdJN1CfdoQ31ujfs3VHb+vasZz2DLZXWH9vc0l59zZ8g3og5Zn7uxFMUa5lu7/
         R6ifS84lt4THD5UHSagidgyUK8KGGT1dlEa/1XZQpQTGBAeakCwGVtVg3xJgikpd1+fR
         hUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D66DXx2We227H4fmDckhvZM7P6i8ZzxMoVouVh6j/zs=;
        b=RLBqjiw9f9nKglF9gK7CU+j0ZrZkh8BmIqtfLuZ35C747mf0yqx/SW3Hm9cqzIFvnd
         aHyO2ROHnHOhCL/N+Bf30AxJlNE7araUeroMwYq5xU9LT8Fh3eL+IY1Y2BXKWio6dwNP
         39xx5MFGRSzq18jTWyxNbvyP0kfvA6MTYKZv053os9M5nrmfT/ee2qK9OP8YqR178zdv
         AOVWre1WtcM0WjpQIwvJHr2MOzyaUEHYaKV1fzI+bSMrCUDrOEuAzeSopbT6IefJKDAL
         IkAz9cRT7Q17Xi6ZTTDUXsa17As83aNCFgtXtybjkp+fn5LfGMOlE635xi/rlCbl2fKH
         vgjg==
X-Gm-Message-State: AO0yUKU5idaZBJgmSGkKD+InFO4x53g9P7ZUGq4OY+0eL7YwGza7mIIJ
        Ij7goP1KGwzywgLYmr0azgc=
X-Google-Smtp-Source: AK7set/76uAPLM3Jq05MtwuSbnutaSq49QvOWlmMu/SYeg6voONhTGyoyANUspbRb3x4XZqp9MnFbQ==
X-Received: by 2002:a05:6e02:1c25:b0:316:ecbf:5573 with SMTP id m5-20020a056e021c2500b00316ecbf5573mr8771146ilh.12.1677260493797;
        Fri, 24 Feb 2023 09:41:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w4-20020a056e0213e400b00315972e90a2sm4156279ilj.64.2023.02.24.09.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:41:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Feb 2023 09:41:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        kernel@pengutronix.de, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <20230224174132.GA1224969@roeck-us.net>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
 <20230224165213.GO19238@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224165213.GO19238@pengutronix.de>
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

On Fri, Feb 24, 2023 at 05:52:13PM +0100, Oleksij Rempel wrote:
> On Fri, Feb 24, 2023 at 08:00:57AM -0800, Guenter Roeck wrote:
> > On 2/23/23 20:53, Oleksij Rempel wrote:
> > > Hallo Guenter,
> > > 
> > > On Thu, Feb 23, 2023 at 08:16:04PM -0800, Guenter Roeck wrote:
> > > > On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
> > > > > On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
> > > > > > Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
> > > > > > 
> > > > > > It should work as before except write operation to the EEE adv registers
> > > > > > will be done only if some EEE abilities was detected.
> > > > > > 
> > > > > > If some driver will have a regression, related driver should provide own
> > > > > > .get_features callback. See micrel.c:ksz9477_get_features() as example.
> > > > > > 
> > > > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > > > 
> > > > > This patch causes network interface failures with all my xtensa qemu
> > > > > emulations. Reverting it fixes the problem. Bisect log is attached
> > > > > for reference.
> > > > > 
> > > > 
> > > > Also affected are arm:cubieboard emulations, with same symptom.
> > > > arm:bletchley-bmc emulations crash. In both cases, reverting this patch
> > > > fixes the problem.
> > > 
> > > Please test this fixes:
> > > https://lore.kernel.org/all/167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org/
> > > 
> > 
> > Applied and tested
> > 
> > 77c39beb5efa (HEAD -> master) net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
> > 068a35a8d62c net: phy: do not force EEE support
> > 66d358a5fac6 net: phy: c45: add genphy_c45_an_config_eee_aneg() function
> > ecea1bf8b04c net: phy: c45: use "supported_eee" instead of supported for access validation
> > 
> > on top of
> > 
> > d2980d8d8265 (upstream/master, origin/master, origin/HEAD, local/master) Merge tag 'mm-nonmm-stable-2023-02-20-15-29' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > No change for xtensa and arm:cubieboard; network interfaces still fail.
> 
> Huh, interesting.
> 
> can you please send me the kernel logs.
> 
There is nothing useful there, or at least I don't see anything useful.
The Ethernet interfaces (sun4i-emac for cubieboard and ethoc for xtensa)
just don't come up.

Sample logs:

cubieboard:

https://kerneltests.org/builders/qemu-arm-v7-master/builds/531/steps/qemubuildcommand/logs/stdio

xtensa:

https://kerneltests.org/builders/qemu-xtensa-master/builds/2177/steps/qemubuildcommand/logs/stdio

and, for completeness, bletchley-bmc:

https://kerneltests.org/builders/qemu-arm-aspeed-master/builds/531/steps/qemubuildcommand/logs/stdio

Those logs are without the above set of patches, but I don't see a
difference with the patches applied for cubieboard and xtensa. I
started a complete test run (for all emulations) with the patches
applied; that should take about an hour to complete. 
I could also add some debug logging, but you'd have to give me
some hints about what to add and where.

> > On the plus side, the failures with arm:bletchley-bmc (warnings, crash)
> > are longer seen.
> 
> s/longer/no longer/ ?

Yes, sorry.

Thanks,
Guenter
