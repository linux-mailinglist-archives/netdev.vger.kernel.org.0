Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBF563BB72
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiK2IZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiK2IZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:25:02 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F23B56EF1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:25:01 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id vp12so30631262ejc.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gzwrz5/bgJ69VQ8DIOQyNt2ySo14PkY0Tc1TJ/9BxtU=;
        b=C3d56JtyuNmf974ceEZSavZ1C/FjLRkloGMeX8+h55kDGiXpMMFI1DD4u3feCh4QEE
         cHA8xuvglY036UQI7H2YQDycFuUAB+Ib26AaNO9jH79I+9iDbRng+Ef7bpZRqFL7xNvT
         SY8/h8Tq9x1BtXmeT4cenlPJaDiZZKqt7rUqubucGzlpVqsEFbubxrWdx8hjJGh9HFKI
         VWWvLBBFn5NGDr4OxwMmW2GFst9UcAyIQNWpvHjljD1grLS1hBIkQpasnV1Ykn1nRN8G
         mHEkyjZbboo827d2YV+/hiHg/UYb6Oq2UWQS3y69VPrqAzY4s2/UVC3JbUtvZ/MrgXD+
         NTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gzwrz5/bgJ69VQ8DIOQyNt2ySo14PkY0Tc1TJ/9BxtU=;
        b=udELuS2P7gdPYPO6OE/+FKy9b+LZGub8DYZA/s5GU1Og5csuoVINoIlFmLl5BS3Cc1
         FQb5gdvVRSrmErj4m1nYF6xwD2dsolPAhVEM1boiz2HQlo+aogb2AUcROwyLh4Mk/AfV
         TFNu+rlxgT1IRDS4rH90/IHfniDD/tUJdlry3xj3sgY20ys+76H3YARvOFn9mTH7eMuf
         +gR0JL/6Vc64tSh5e0iIWeTcIxc6sKYGRxkeul0vgL2/Lq4g08LwWGw+3m8G3SOMtx8y
         +kavxpdC9aDdsDOc9fDXYNqJKyMFFE7v4q8Lu0If3FeJYofU87De66TfAuVG8wzvbE4s
         YIOg==
X-Gm-Message-State: ANoB5pkZ9nxzniH8cV+qQTorDix2CxBweek6s8XTP0TzUBWE1oz1IYGY
        9LHniYE878dDKtaS1gPdKawdlA==
X-Google-Smtp-Source: AA0mqf5U6UpqaqLYePD0J8IkftyUluGt51ht3yzDWcsXRz6dM4R3R53yD09NYzQvvlp1i1fCn6EMtQ==
X-Received: by 2002:a17:906:2645:b0:781:d0c1:4434 with SMTP id i5-20020a170906264500b00781d0c14434mr46698718ejc.756.1669710300002;
        Tue, 29 Nov 2022 00:25:00 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id sa21-20020a1709076d1500b007aec1b39478sm5874240ejc.188.2022.11.29.00.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:24:59 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:24:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Subject: Re: [PATCH net-next v5 1/4] net: devlink: let the core report the
 driver name instead of the drivers
Message-ID: <Y4XB2iBqceQfFZem@nanopsycho>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129000550.3833570-2-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 01:05:47AM CET, mailhol.vincent@wanadoo.fr wrote:
>The driver name is available in device_driver::name. Right now,
>drivers still have to report this piece of information themselves in
>their devlink_ops::info_get callback function.
>
>In order to factorize code, make devlink_nl_info_fill() add the driver
>name attribute.
>
>nla_put() does not check if an attribute already exists and
>unconditionally reserves new space [1]. To avoid attribute
>duplication, clean-up all the drivers which are currently reporting
>the driver name in their callback.

This para with the link below should be removed, no need for it.

Otherwise, code looks fine.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
