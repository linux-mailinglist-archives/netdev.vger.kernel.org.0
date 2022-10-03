Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB6E5F337F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJCQZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJCQZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BFE17A92;
        Mon,  3 Oct 2022 09:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86DB96114D;
        Mon,  3 Oct 2022 16:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57122C433C1;
        Mon,  3 Oct 2022 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664814323;
        bh=oYqo9dtnpWHQGl/edPWw7aOzaunWckTN7VWinDA7gW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VJwwOi6mQxjHZhJbT1LuNcYNppcUqxQSIyVS3eSg/k4MMpyqmmn3iyT6XozKymuiU
         tP/DCZ7UKFcFgPdosJm1bmsNUKEBgzmFpfRY0Mh/+wQNheZRsIsrRNrvN7gVMSR0nA
         kVvBXahgWFH26w+SL6Xgd9EYj41wwJU5SBWFSOWoTeznGiiFuDjJ1y/daPyzMW5k8j
         O+ZwLsl5TlagpwjEoHaVP5tFMEZu80ngXjAjnEn+Dzubh6464aa/Kzfs98B2lgf6Qo
         8cLeoosMJ9c88mCHB2Ew4HCZ/FL7sronZ6LnCjytUQsu57xwUIYqq/erW3slPxgquW
         XtOgcUfwUdKkA==
Date:   Mon, 3 Oct 2022 09:25:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Message-ID: <20221003092522.6aaa6d55@kernel.org>
In-Reply-To: <87pmf9xrrd.fsf@nvidia.com>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
        <20220929185207.2183473-2-daniel.machon@microchip.com>
        <87leq1uiyc.fsf@nvidia.com>
        <20220930175452.1937dadd@kernel.org>
        <87pmf9xrrd.fsf@nvidia.com>
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

On Mon, 3 Oct 2022 09:52:59 +0200 Petr Machata wrote:
> I assumed the policy is much more strict with changes like this. If you
> think it's OK, I'm fine with it as well.
> 
> The userspace (lldpad in particular) is doing the opposite thing BTW:
> assuming everything in the nest is a DCB_ATTR_IEEE_APP. When we start
> emitting the new attribute, it will get confused.

Can you add an attribute or a flag to the request which would turn
emitting the new attrs on?
