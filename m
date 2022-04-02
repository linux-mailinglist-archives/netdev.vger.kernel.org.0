Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DBA4F02D0
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 15:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350646AbiDBNpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 09:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiDBNpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 09:45:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47903CB01B;
        Sat,  2 Apr 2022 06:43:14 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p17so4665704plo.9;
        Sat, 02 Apr 2022 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N8etPJfuUrvLrKv9T6LO2m8SvHPCKKB3qu2VSt8v9nA=;
        b=Qp3+sVxlu/4x2lmjo3UD6aZziSa9jal43jqrKm2zfWl/+omelI65Sp70InHvggNa1+
         dGEAUUFAYSJWl4YNTFsF690kPBMgF0ljYslIfFYbuFzkUCtKqBZ13DVeSni8ev2KM45R
         KBQ/QdEE/hnJvi+9Ecy2YihzUtvXtoLiIerIpsoA7MDGIEtjRwX9T7xa4Wh8ulgNKgwD
         VstjGeu3kBWRLzOzoKKCX75uOS7Zlzl/Mz4Wv/Uijy5YP68V6ao1GXRsL9DTwA/meEP/
         yo3kupGKARFrIoPAXsYystH/UCnUlHoguq8wqCBtV/V2GcALzMIxS5ihfP5cDKVjm61b
         DHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N8etPJfuUrvLrKv9T6LO2m8SvHPCKKB3qu2VSt8v9nA=;
        b=D2Yc/8pAR+qqjC2QAk0SmjMHs//KXhKoLrC/2966kZ8K3KyfMNMoa40b28PQp4lDQT
         LfWhvVS25Cxe94U7+GR2Eaewx0NQZSZ6TxjIgsbDNJP2UUhGvETTqgmpeyPY7iFHwOdj
         XVfmLfxj6M2K1WNFs3ktEbQT9Enm4rli0DVofgzhK4xzrk4+51JrSq55VVSHtCvQ1S/x
         ZXmbw06RnaYacRUDvOkGNxWjUKpXYOWyyqu+hqH9GUX1RHXJm/IgIRVxAsryVs1AvZ2h
         78Ey4INpcYwoZEvYOtHN37KCvuO8lr3ot0VdS9h1Ir8sH8B+CoSsZjSHWhn/eVxwkg9A
         Dfrg==
X-Gm-Message-State: AOAM530l55srcXsuJaCpqUZXXtM91/wr5lRot1KH4w0ZEVnB71JIKG8s
        SBediYJ+UjaYEPJfRBRLoMk=
X-Google-Smtp-Source: ABdhPJwvOBfL3ZRn/xSf/hbyHwVlboZe2IeZAwoTcZlIhaFsDkEQ/OYHNBO1xsJqjlDjHs0OZpXsNQ==
X-Received: by 2002:a17:902:bd88:b0:14f:8ddf:e373 with SMTP id q8-20020a170902bd8800b0014f8ddfe373mr15196047pls.89.1648906993722;
        Sat, 02 Apr 2022 06:43:13 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm6610999pfu.202.2022.04.02.06.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 06:43:12 -0700 (PDT)
Date:   Sat, 2 Apr 2022 06:43:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Divya.Koppera@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: micrel: Remove latencies support
 lan8814
Message-ID: <20220402134309.GA19675@hoboy.vegasvil.org>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
 <Ykb2yoXHib6l9gkT@lunn.ch>
 <20220401141120.imsolvsl2xpnnf4q@lx-anielsen>
 <YkcOjlR++GwLWyT5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkcOjlR++GwLWyT5@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 04:39:10PM +0200, Andrew Lunn wrote:

> Are you also saying that ptp4l needs to read the values from the
> driver, calculate the differ from the defaults, and then apply that
> difference to the correction specified in the configuration file it
> will apply in userspace?

Personally I wouldn't bother with that.  At the end of day, users who
care about sub-microsecond performance will need to calibrate their
particular setup.  The output of the calibration will be the system
delay asymmetry correction.  That number will be applied in ONE place,
namely the user space PTP stack.  Breaking it up into little bits is
just extra work for no benefit.

That is why I'm against any of this driver nonsense.  The only purpose
of putting values in to the driver is to unpleasantly surprise the end
users after kernel upgrade.

If this driver defaults + run time query/setting stuff goes mainline,
I'll never use it.

> Does the PTP API enforce mutual exclusion for a device? Can there be
> multiple applications running on an interface, some which assume the
> hardware is configured to perform corrections and some which will
> apply the correction in user space?

There is no mutual exclusion at the kernel API.  The main hindrance is
the SIOCSHWTSTAMP ioctl which is at the device level.  The setting
applies system wide and is a root caps operation.  There is the "Get"
variant that allows co-operation but does not enforce it.

Thanks,
Richard
