Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76A6CCCFF
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjC1WRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjC1WRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:17:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A6630F6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D50361944
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 22:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7CEC433A7;
        Tue, 28 Mar 2023 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680041821;
        bh=SKa1WtJkpvN0CZudpwfv+UX+IZNLKj5mIJMHyAOCJ5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bSo3ZukxJHmOzIayw+5zK+J27UdnDn7F3Bekk633QOCt6HriVcfVaXVoShixGefYN
         SfiJWcKD3xPtLxB1NxA3xjynJ9XzrXbZD1ZRHbKdgG3hqKzd9kkealH6ap69Hknl2I
         aTkH2BpspQoZPFUX6OV/sEWlk9O0bEmpv2NFy/s4C+yFrvI1Z1iWIZrlrU65fWx42T
         mGKLLebz+gn+F9rpslQPikSt5QX9HGZdSokG5CVLDuw1QMH6Qzq3GY/iC9vHMH/P6k
         J7yZtZ0swSBJ9VPa7c5kiib9Ybego4j0IDXeF/mcBfKTQcLD9TCfrX2mwmdYChpylW
         Z953jQQScqMhw==
Date:   Tue, 28 Mar 2023 15:17:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230328151700.526ea042@kernel.org>
In-Reply-To: <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
        <20230324190243.27722-2-shannon.nelson@amd.com>
        <20230325163952.0eb18d3b@kernel.org>
        <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
        <20230327174347.0246ff3d@kernel.org>
        <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023 23:19:28 -0700 Shannon Nelson wrote:
> > What are you "abstracting away", exactly? Which "later patch"?
> > I'm not going to read the 5k LoC submission to figure out what
> > you're trying to say :(  
> 
> I'm saying that more code is added in later patches around the 
> devlink_register() for the health (patch 4) and parameters (patch 11). 
> This allows me to have a simple line in the main probe logic that does 
> the devlink-register related things, and then have the details collected 
> together off to the side.

It's not supposed to be off to the side, that's my point.
It's a central interface for device control.

> Obviously, when I update the code for using the devl_* interfaces and 
> explicit locking, those two patches will change a little.
