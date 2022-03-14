Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0064D8BE9
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiCNSsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiCNSsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CB0646D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 584ECB80EDC
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA61C340E9;
        Mon, 14 Mar 2022 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647283607;
        bh=irIxivICjg/ccC2nMMtJQLR0whNZZVU70Q1QMTDkkQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fUPqg4NkDbsf5QyhAI+h1hDcIq2iJaB51YyumF0q7QM8wSf0D7xCpj5nKr09sDlab
         f6KbdvXQDUKK2LlD+3hjZ0dTKWiRUsV4R+yCZdWwLDlI2NVrhP85SMHY3ZVtKxYGfO
         NVq/praKOAOZ923txH0Utpua5YWGR4Yv3SdmRBTu9w4JHHsOMoD1tt8dJaMluJSAl/
         j851hu3Yj4jPEFPtmpVfwmj6rf+R43NrBBk1vN865dVFMRx87tfp2ZD03CjBy0pbuB
         EKvQsuSgB4E6gYdhlJPzA7dKGLvKW1xDbmVbezdBSwcjXc/8xex2YS6l8V0qlmiELx
         HNn6kRXKGMAUg==
Date:   Mon, 14 Mar 2022 11:46:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yipp3sQewk9y0RVP@shredder>
References: <20220310001632.470337-1-kuba@kernel.org>
        <Yim9aIeF8oHG59tG@shredder>
        <Yipp3sQewk9y0RVP@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 23:13:02 +0200 Ido Schimmel wrote:
> Went over the patches and they look good to me. Thanks again. Will run a
> full regression with them on Sunday.

Hi Ido, no news?

Do you have a preference for these patches getting merged for 5.18 
or waiting after the merge window? IOW I'm wondering if it's more
beneficial for potential backports / out-of-tree builds to have the
ability to lock the devlink instance in 5.18 already or to do as much
of the conversions as possible in a single release (that'd mean waiting
for 5.19)?

If there's no clear preference I'll go for 5.18.

I have the eswitch mode conversion patches almost ready with the
"almost" being mlx5. I may just give up on that one and unlock/lock
in the handler :S
