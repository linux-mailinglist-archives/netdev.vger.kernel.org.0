Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CE251B1EF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379020AbiEDWeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354265AbiEDWen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD6F2AC44
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD32C61AD7
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF437C385A5;
        Wed,  4 May 2022 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651703465;
        bh=lw5NLHTurCrkFZaqCABWx2I9tsFpFP8xZwRNsbQFqiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wy8klNdOLu7QOO9mUtSjdq+rCKqX4X/XN63ILIoJKnRrtVflhtDGkwMqQK0+3sMy9
         FrUiF92Y9iI4lVfoVDGKxo2PnXmAD6+MgS9b2jqb9gYGf09JrlMjHxkz9jPfVW51fp
         FLYgFynFpWVu1NAiGyhU97GaUsQb2osx4f9ZJIBPcjeBoWkggpXL1RCWjxwj5PInTJ
         D/N2dkVaMkbckAThOpXuq40QML2JbSxsL/Wdd2xazccCg1JIUtBT5EfxGFss8ZuuJv
         s1OL1scTT1Zr4llHwlwVdpz3wjtmBe+VCu/QykF94jF9sLwDmYMHG6eCmpYk2v1iwu
         7vnnk0kwAb2Pw==
Date:   Wed, 4 May 2022 15:31:00 -0700
From:   David Ahern <dsahern@kernel.org>
To:     Magesh M P <magesh@digitizethings.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: gateway field missing in netlink message
Message-ID: <20220504223100.GA2968@u2004-local>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 06:46:05AM +0000, Magesh  M P wrote:
> Hi
> 
> I am trying to configure dual gateways with ip route command.
> 
> Ip route show command shows the dual gateway information.
> 
> I got a vpp stack that is running. The communication of route entries between Linux kernel and vpp stack is through netlink messages.
> 
> On parsing the netlink message for the route entry with dual gateways, we see that the message carries only single gateway. Is this a known bug ? Please suggest a solution to resolve this.
> 

If `ip route show` lists a multipath route, the bug is in your app. Are
you handling RTA_MULTIPATH attribute?
