Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28131678AF5
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbjAWWpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjAWWpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:45:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44612BF3E;
        Mon, 23 Jan 2023 14:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89A2BB80EBB;
        Mon, 23 Jan 2023 22:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF19C433EF;
        Mon, 23 Jan 2023 22:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674513950;
        bh=PFKvsUK0ALiS9A6m2M1DguOsRtNN0OwE/rRnm/K+Rxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eS0pFPZ3B9YzJb2Y5w4hoeoCqwGRTmKNKMUjFTGsVUtjUY9jKVyz7KfBJP6RL/Ct/
         x8k7tINpH7q6bBbB63hJvH1QePavTGtBiNg2wf9zRppGt1wZEGa0OePxzo5T+Akz4i
         qqOnjFYdmY37WsSXVb+86m4W7d8ThZLu+vvmoOOVOrSVjDmbd9CpgYHLKAle9HQvRg
         NpTBIqzmVgmYU12M4/Zo5nSNZUaHQpe0z6E4m1SmHUwcnujUDBMo72qrIo3lgiYr4l
         5WwBjHLnJGuLDT/vZ4fgN4MB6u0/67XcrEtL8K9czQdldZv3EnJzkrW4UStkfTOqBp
         /hvbbTb+yJdhw==
Date:   Mon, 23 Jan 2023 14:45:48 -0800
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
Message-ID: <20230123144548.4a2c06ae@kernel.org>
In-Reply-To: <Y87onaDuo8NkFNqC@mail.gmail.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
        <20230118105107.9516-5-hkelam@marvell.com>
        <Y8hYlYk/7FfGdfy8@mail.gmail.com>
        <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y8qZNhUgsdOMavC4@mail.gmail.com>
        <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y803rePcLc97CGik@mail.gmail.com>
        <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
        <Y87onaDuo8NkFNqC@mail.gmail.com>
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

On Mon, 23 Jan 2023 22:05:58 +0200 Maxim Mikityanskiy wrote:
> OK, I seem to get it now, thanks for the explanation!
> 
> How do you set the priority for HTB, though? You mentioned this command
> to set priority of unclassified traffic:
> 
> devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 6 \
> cmode runtime
> 
> But what is the command to change priority for HTB?
> 
> What bothers me about using devlink to configure HTB priority is:
> 
> 1. Software HTB implementation doesn't have this functionality, and it
> always prioritizes unclassified traffic. As far as I understand, the
> rule for tc stuff is that all features must have a reference
> implementation in software.
> 
> 2. Adding a flag (prefer unclassified vs prefer classified) to HTB
> itself may be not straightforward, because your devlink command has a
> second purpose of setting priorities between PFs/VFs, and it may
> conflict with the HTB flag.

If there is a two-stage hierarchy the lower level should be controlled
by devlink-rate, no?
