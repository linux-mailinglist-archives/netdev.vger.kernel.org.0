Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C060367A85E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjAYB0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjAYB0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:26:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FF947EF2;
        Tue, 24 Jan 2023 17:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B5B60F34;
        Wed, 25 Jan 2023 01:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD69C433D2;
        Wed, 25 Jan 2023 01:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674610007;
        bh=ixdPOObRbqFJCpKGVTczBPFTWiW4EP6m1TWr/li2CKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SRtH3eYvyLWfCnv2TF9+uLcaluPx/CAc4nZgoifGVcHlbsm7/G6Sj6RM6An69Ttet
         la5seuUI3JtEHgx7M9yQw633dIpGEJuft5lYBhCQukx37E3+cKCA+js2rtBPwEuoXT
         oBz3c129eMY+phHvyyC6iWUDBGoXJmoOCwwCLMtdfwOpbxLMTDBcdkqiSgN4W2IBo1
         SjwNP5F90RPvQTmVFfJBB+O5lK7nRdA2ahU4T72NIWy7x2SirJxzWVNt/A6wpN2o4I
         fYnMoCL1PsAM73AhablXriW4K/Xx8LSfetEKFs54ymtm8D8GzZWHDVqtWKKdl2irKL
         7m7bj7xo1cwig==
Date:   Tue, 24 Jan 2023 17:26:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
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
Message-ID: <20230124172645.6afd4f5e@kernel.org>
In-Reply-To: <Y8/W5dMmkqkYFNEb@mail.gmail.com>
References: <Y8hYlYk/7FfGdfy8@mail.gmail.com>
        <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y8qZNhUgsdOMavC4@mail.gmail.com>
        <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y803rePcLc97CGik@mail.gmail.com>
        <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y87onaDuo8NkFNqC@mail.gmail.com>
        <20230123144548.4a2c06ae@kernel.org>
        <Y88Rug7iaC0nOGvu@mail.gmail.com>
        <PH0PR18MB44748DFCCABCDC2806A2DC2CDEC99@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y8/W5dMmkqkYFNEb@mail.gmail.com>
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

On Tue, 24 Jan 2023 15:02:29 +0200 Maxim Mikityanskiy wrote:
> So, basically, in your implementation, entities prioritized by hardware
> are: each HTB class, each VF and PF; you want to keep user-assigned
> priorities for HTB classes, you want to let the user assign a priority
> for unclassified traffic, but the latter must be equal for all VFs and
> PF (for DWRR to work), correct? And that devlink command is only useful
> in the HTB scenario, i.e. it doesn't matter what tl1_rr_prio you set if
> HTB is not used, right?

To me HW this limited does not sound like a match for HTB offload.
