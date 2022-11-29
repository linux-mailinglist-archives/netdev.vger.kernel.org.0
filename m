Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5C863C509
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiK2QXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiK2QXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:23:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E3B2936D;
        Tue, 29 Nov 2022 08:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56E5C617F1;
        Tue, 29 Nov 2022 16:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84196C433B5;
        Tue, 29 Nov 2022 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669739012;
        bh=cGjM50Wf3CjbI5CufedpeRJgmUVOB+oAD7sMhicvcvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iGGqHvYp3sWtlvL3jCszoyk0Brtf4U7s5IZ36y4/y1m554vmFunVA5ClffSXnH849
         yt1hdu1rUqoJE7r7VOV3tfT0J2smr71P3tQMbjnIRA8cMt+170myHsgSoVSucd0bYi
         OjMhYsiSqUsyk/SVaonvZnGvOho+Y94h9/yNkGZzPui9wIXrQpviLgKo+/UFhWOxIA
         M/mUJkkdbPaXcqsEf4mq/p9pO0g7uKimEwyyDHDcE4ff7z24vz0ap1DzqqCQyFv6Rh
         zI07kmFsHNsqft+khjFYFwCqfphkmhqIOyLb20egHw818U8HUNGAANKuqd6ofsW2wo
         F6ISh741HsxKg==
Date:   Tue, 29 Nov 2022 08:23:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH net-next v5 2/4] net: devlink: remove
 devlink_info_driver_name_put()
Message-ID: <20221129082329.2a97d67a@kernel.org>
In-Reply-To: <CAMZ6RqJnxkDmMtXSvUF2aondZ_8BGYq4XL35Cg7Vxy9qqsfAeg@mail.gmail.com>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
        <20221129000550.3833570-3-mailhol.vincent@wanadoo.fr>
        <Y4XCCl6F+N2w+ngn@nanopsycho>
        <CAMZ6RqJnxkDmMtXSvUF2aondZ_8BGYq4XL35Cg7Vxy9qqsfAeg@mail.gmail.com>
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

On Tue, 29 Nov 2022 18:37:41 +0900 Vincent MAILHOL wrote:
> > I agree with Jacob that this could be easily squashed to the previous
> > patch. One way or another:  
> 
> OK. Let's have the majority decide: I will squash patches 1 and 2 and send a v6.

FTR I prefer v5, much easier to review the code when driver changes are
separated from core changes. But doesn't matter.
