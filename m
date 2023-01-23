Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C68A678AF2
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbjAWWov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbjAWWou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:44:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275C138038;
        Mon, 23 Jan 2023 14:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B5AAB80ED5;
        Mon, 23 Jan 2023 22:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBE3C433D2;
        Mon, 23 Jan 2023 22:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674513886;
        bh=b9YwJ5Y/nPq6xuxSvk6SQo5FPC4+mR3kanciqR6bwyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BXJ7GV5nQ4s3MXuV6MvEk3vBxjPgyBETYkIGGu6bj9jSVqi7NKetU8qKW4srTB7Ab
         SU/ypA41JkXnmvx2zCBHV9tQdD/vFkfr6qIKTTvig6NYW6tbyyJ5cQYOFZWRcqEBDC
         wwFMnBijWThZ4YuOcaJg/csVjfcrD1Sy334HMkb3sixDAGfSJz42/yA/Gr9/k7PJjt
         zRjQjFNKJwhNoziXJm4yoXp91N6htL3yc29pOOx47lER+urLt9RCOGJ25UgoSO4H7R
         0WkyV1sbrrNFUWaIZD73k3Xkj+9PNYehcyWKTzxxVcF8eRS5E/PftYTZHbZxynL/gT
         /vMLws1XxB+ZA==
Date:   Mon, 23 Jan 2023 14:44:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <20230123144444.3cac6bd9@kernel.org>
In-Reply-To: <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
        <20230118105107.9516-5-hkelam@marvell.com>
        <Y8hYlYk/7FfGdfy8@mail.gmail.com>
        <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y8qZNhUgsdOMavC4@mail.gmail.com>
        <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y803rePcLc97CGik@mail.gmail.com>
        <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
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

On Mon, 23 Jan 2023 17:03:01 +0000 Hariprasad Kelam wrote:
> So, did I get it right now?

Hariprasad, please fix your email setup.
It's impossible to read your messages :|
There is no marking of quotes and the responses are misaligned.
