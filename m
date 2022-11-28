Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CFC639F06
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 02:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiK1Bmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 20:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiK1Bmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 20:42:36 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3303DE02;
        Sun, 27 Nov 2022 17:42:35 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so7673570pjo.3;
        Sun, 27 Nov 2022 17:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vugqIFRxCyknBbu9V+wKU89OOIphCVzqPgtGWbeU2e0=;
        b=3TT8s7sdFoeIYzo3znoz3PAZN7oTBTJbe1Pzw287AalQyi3//jd0miT3JTuvTfhk+1
         zwESm+LfCKndgueY38VzdG/BXxCpCTlrfdSa1i4JVWEd3VoY0K5pDmNxgyJOv3DWhSiv
         pjlCD/JdgdhF0lONyp4sK/ZZMxGmUi5irvXNYbN1VRNrhNZJP0aLSjBVextE+dPvwai3
         ARDCnKYX1j5rzG4G8KJhZ3OanhB5rihieMTHYA/Dl5XDfPrmKfwPEOYOXOJQsBfgY/r1
         SyKlemaojdwERPw/V35+Gy8Xbh1DnRC29RJLc1/k/3Mu5pU64EXgIYi4S45fCkgcGEXB
         NR5Q==
X-Gm-Message-State: ANoB5pliEMC+FMs1dFvW6CnM+WfqNAD5U+TQo1rKnk7mnT2TP51lteyn
        eKk4qoYySY2rCee0wYXzniWTMfH6t3TqR4bc+aY=
X-Google-Smtp-Source: AA0mqf5fJFd4OI/wqCAiSyik0VLVFVoFMfzJ9mryfA/1K6FyI90QwUxChWz0UdSQwVRwuYvQMcWJhOKG5dmt/m6SpnU=
X-Received: by 2002:a17:90a:77cc:b0:219:1747:f19c with SMTP id
 e12-20020a17090a77cc00b002191747f19cmr11037058pjs.222.1669599754664; Sun, 27
 Nov 2022 17:42:34 -0800 (PST)
MIME-Version: 1.0
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127130919.638324-1-mailhol.vincent@wanadoo.fr> <20221127130919.638324-3-mailhol.vincent@wanadoo.fr>
 <Y4ONgD4dAj8yU2/+@shredder>
In-Reply-To: <Y4ONgD4dAj8yU2/+@shredder>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 28 Nov 2022 10:42:23 +0900
Message-ID: <CAMZ6RqKfED-ABYPboF09FUZjcKQSb0ALYjY2hiffP7fXZRb2mQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/5] mlxsw: core: fix mlxsw_devlink_info_get()
 to correctly report driver name
To:     Ido Schimmel <idosch@nvidia.com>
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
        Shijith Thotton <sthotton@marvell.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 28 Nov. 2022 at 01:17, Ido Schimmel <idosch@nvidia.com> wrote:
> On Sun, Nov 27, 2022 at 10:09:16PM +0900, Vincent Mailhol wrote:
> > Currently, mlxsw_devlink_info_get() reports the device_kind. The
> > device_kind is not necessarily the same as the device_name. For
> > example, the mlxsw_i2c implementation sets up the device_kind as
> > ic2_client::name in [1] which indicates the type of the device
>
> s/ic2/i2c/
>
> > (e.g. chip name).
> >
> > Fix it so that it correctly reports the driver name.
> >
> > [1] mlxsw_i2c_probe() from drivers/net/ethernet/mellanox/mlxsw/i2c.c
> > Link: https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714
>
> Same comment as before.
>
> Before the series:
>
> # devlink dev info i2c/2-0048 | grep driver
>   driver mlxsw_minimal
>
> After the series:
>
> # devlink dev info i2c/2-0048 | grep driver
>   driver mlxsw_minimal

ACK. I was overall confused by the device_kind. Thank you for your
confirmation. I will drop the first two patches from this series.


Yours sincerely,
Vincent Mailhol
