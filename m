Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A0C68E77F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjBHF30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBHF3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:29:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768041A48E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 21:29:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3CE2B81B3B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B95C433D2;
        Wed,  8 Feb 2023 05:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675834161;
        bh=30e8mHKhzEDU9csgdsuvYqoR+bLghpv3e3pExeKhaas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iF9v8KZfEcOVPgj5TuABznxpfFD64GkpIe0xQ3qHlxHcn8sfhZFCst/DfbGRCsH63
         XfAmtdrbeO2D8JUIbi8zAY+uDQe/2COYOPx5ASvSWqo918vbkiE+gbfIdYYNmmGhml
         j+ZLE9ffOoraaN0eCXUN6XAL/il3fpjRNqDrzW+X7rJcVkE4FRcpPS08U0ggEzHaC6
         J55cBQluVv6yaN2nCP+s8Me34pph7Y71lj3O1nNyiiLM4iWthievVPCok9QYQwci5q
         jqU0HWOtIz9Rev/JKFdaOz/SOPXwtb+ZyGrDci2FqYUT20ygPW9mg178jSUjKf6XT/
         D81axe5nDGHjg==
Date:   Tue, 7 Feb 2023 21:29:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, "Jiri Pirko" <jiri@nvidia.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 0/9] add support for per action hw stats
Message-ID: <20230207212920.4cb83475@kernel.org>
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Feb 2023 15:54:33 +0200 Oz Shlomo wrote:
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array, as elaborated below.

Mercelo would you like to review this one as well or it's of lesser
interest?
