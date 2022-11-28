Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE05763B181
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiK1SmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiK1SmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:42:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BFB65FA;
        Mon, 28 Nov 2022 10:42:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0E81B80E9E;
        Mon, 28 Nov 2022 18:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B1DC433D6;
        Mon, 28 Nov 2022 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669660926;
        bh=c/Kya75Gow4UGO+kWaBvGk9V0lZ53wcA1385i+8THwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ggtZa/EXaHIafcJ28igxOSiRe6MpAjEMroyUUXUKor1ZOYtErOk9h4Pg1uPxHTxPJ
         8uAReJ0QZbagmOuMZEltNe1MCOovSlZ6aKjAFkKJBjOktJHPOOcJUdIGoDPi6uUQ20
         MXyNg8MjRmfA8OWJbemROMNNwero5+hww9jG3uqbHEl6XgfqMRA95nQWL2mU4WLE38
         Hta0auaTwNimuhOfvVFOfz8grj/MzLiZ83WQRvmPdQ///4aXS7FjPvsfYQLqXw3cOa
         FzX7m1h0inABUmO0kFCTG9vaaUHpJAcoA7JqFSsdD78EQAPQM+He4ME9C0JSq2ajri
         +/RYwrUokWRUQ==
Date:   Mon, 28 Nov 2022 10:42:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
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
Subject: Re: [PATCH net-next v4 3/3] net: devlink: make the
 devlink_ops::info_get() callback optional
Message-ID: <20221128104203.079ce802@kernel.org>
In-Reply-To: <20221128041545.3170897-4-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
        <20221128041545.3170897-1-mailhol.vincent@wanadoo.fr>
        <20221128041545.3170897-4-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 13:15:45 +0900 Vincent Mailhol wrote:
> Some drivers only reported the driver name in their
> devlink_ops::info_get() callback. Now that the core provides this
> information, the callback became empty. For such drivers, just
> removing the callback would prevent the core from executing
> devlink_nl_info_fill() meaning that "devlink dev info" would not
> return anything.
> 
> Make the callback function optional by executing
> devlink_nl_info_fill() even if devlink_ops::info_get() is NULL.
> 
> Remove all the empty devlink_ops::info_get() functions from the
> drivers.
> 
> N.B.: the drivers with devlink support which previously did not
> implement devlink_ops::info_get() will now also be able to report
> the driver name.

These should be two separate patches, tho.
Please don't post v5 in-reply-to.

Otherwise looks good. Kinda risky but good :)
