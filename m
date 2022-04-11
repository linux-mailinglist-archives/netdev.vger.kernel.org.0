Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1786B4FC3AB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348994AbiDKRvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349006AbiDKRvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:51:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DFE2252F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F851B817F4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 17:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7007C385A3;
        Mon, 11 Apr 2022 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649699377;
        bh=AjBQW9fprB8dVWUpKiTVVJDrqm0ZuzJ43ydS5LfRTZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZtjamyI+daqBwTr2h12nmRPYdisVYnMkJkmslgrho13dUwK1cZg7oi7dUUlzyLh98
         R0RJdqHEhGFSw9RGAvtnpYW9ycf6UejjRZsvK8MW7q26d0gWhbiI45OeugYEy26N5f
         cpH206iSF+WMOz6chVVGJG2sSMCK557TDbXpvV/8M5LMpelCn70gs3dzTiITT8Y9E6
         Puh9/e+Dwr3eOd1S6VL+eAAVaOtwU9sK4HwZyMJPs0l94E6YmgjXapZYkh8IV2IvKG
         ttYBYKWaDHc0gjXrVzW9YAnerOtfvt4QkZOHp3WJviBY9X36///B9B1cyJdYia8SvY
         qK3+HJs8skJLQ==
Date:   Mon, 11 Apr 2022 10:49:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
        jiri@nvidia.com, ariela@nvidia.com, maorg@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <20220411104934.029409a6@kernel.org>
In-Reply-To: <YlQC2NW5JrnvuN10@nanopsycho>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
        <20220407201638.46e109d1@kernel.org>
        <YlQC2NW5JrnvuN10@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 12:28:40 +0200 Jiri Pirko wrote:
> >> The approach of adding object-attached statistics is already supported for trap
> >> with traffic statistics and for the dev object with reload statistics.  
> >
> >That's an entirely false comparison.  
> 
> The trap stats are there already, why do you thing it is a "false
> comparison" to that?
> 
> They use DEVLINK_ATTR_STATS attribute to carry the stats nest and then:
>         DEVLINK_ATTR_STATS_RX_PACKETS,          /* u64 */
>         DEVLINK_ATTR_STATS_RX_BYTES,            /* u64 */
>         DEVLINK_ATTR_STATS_RX_DROPPED,          /* u64 */
> I think that the semantics of these are quite clear.

Exactly, (1) the semantics of statistics on traps and health are clearly
dictated by the object, there is no ambiguity what rx packets for a trap
means; (2) the statistics are enumerated by the core...

> >> For the port object, this will allow the device driver to expose and dynamicly
> >> control a set of metrics related to the port.

..this is like saying "it was 14C in Prague and San Francisco today, so
the weather was the same. It was sunny in Prague and raining in SF".
