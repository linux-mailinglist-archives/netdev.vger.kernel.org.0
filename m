Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5644D6665
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349936AbiCKQei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiCKQeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:34:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8296914A20C
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:33:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8D461CE2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4883AC340E9;
        Fri, 11 Mar 2022 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647016413;
        bh=2Re/CWueULynsr4kXvXb06O5RHgt0hupMEkDYKFFsDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A6gf1mLQ5nbx9hbe6BL+1ctuD1ul+SJn5P0i4W3rCgKPCrtNxtVnvA3vK5bEkXDw3
         kFPjmMCxbOMw+ZRbjA72jNn395sgeT/a6b0g6bYBuERsrhYWPy9WPx4zVE4IbHp90u
         bQE4uTRJVJhSp/0GiMJwz/uwS78PvR8QFMiTlltO82oqXeYkNuXheCrYMJ7N4y7HoB
         HN/xOZ5BfceTgemXAjowW4ImTp1tVAEp0Hr2RQa18PZn02n5FoPKNJnXmGBD0w28sL
         TH+vGCa3O5Eao58ZLaF8e5RJZRxOnf2ThSpuylJNWTJjGMW97BUkV5x0YBv+Ws8WfR
         FcY32ZiV6Kysg==
Date:   Fri, 11 Mar 2022 08:33:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <20220311083332.48c7155a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YisTMpcWif02S1VC@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
        <20220310001632.470337-2-kuba@kernel.org>
        <YinBchYsWd/x8kiu@nanopsycho>
        <20220310120624.4c445129@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YisTMpcWif02S1VC@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 10:15:30 +0100 Jiri Pirko wrote:
>> The goal is for that API to be the main one, we can rename the devlink_
>> to something else at the end. The parts of it which are not completely
>> removed.  
> 
> Okay. So please have it as:
> devl_* - normal
> __devl_* - unlocked

Isn't it fairly awkward for the main intended API to have __ in the
name? __ means unsafe / make sure you know what you're doing.

There's little room for confusion here, we have locking asserts
everywhere.
