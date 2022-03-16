Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA754DB7F2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbiCPSfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbiCPSfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BD0642D;
        Wed, 16 Mar 2022 11:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CFC1618C1;
        Wed, 16 Mar 2022 18:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7159C340E9;
        Wed, 16 Mar 2022 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647455638;
        bh=BBntHNa6ogo6orHLVRJgt98BQRdO7DhrSgNocBna7ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rkY9FEiSlijPlVVyQYZiouLT9kD19CPgbgai+cyCPG8H9rCoDrbBOTk76sZQD8VQD
         aMhCB1vSQytu+6MAwFAlEVA7S1+6mgydTXYYqW+e/KBk7D5XfJu+r3JtVpLMhseIGx
         1QgRUGYN318M/z5FURchqQwx1Si6l/LCQpXkp/GSyQXBgGUi65nKJofD6l2fGm6+Q4
         8zjJmIiCoaIMmIJmHS0Qe1q0GCH/P04MMr78TWan0dbx/zxvQ0EHckwS7di9751Cem
         XP26ivUnjPXd/yLQzjxCjwNywjUx3zjgCUphIPK3bGskBuBqrhKHzoCT+EgCrRkKfP
         ookG3NPK5mmMg==
Date:   Wed, 16 Mar 2022 11:33:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        linux-can <linux-can@vger.kernel.org>
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220316113356.6bee9428@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ec2adb66-2199-2f9d-15ce-6641562c54f2@hartkopp.net>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
        <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
        <20220316074802.b3xazftb7axziue3@pengutronix.de>
        <7445f2f1-4d89-116e-0cf7-fc7338c2901f@hartkopp.net>
        <20220316080111.s2hlj6krlzcroxh6@pengutronix.de>
        <ec2adb66-2199-2f9d-15ce-6641562c54f2@hartkopp.net>
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

On Wed, 16 Mar 2022 09:42:14 +0100 Oliver Hartkopp wrote:
> > Another option is to port the patch to net/master with the hope that
> > back porting is easier.  
> 
> I have a patch here for net/master that also properly applies down to 
> linux-5.10.y
> If requested I could post it instantly.
> 
> > Then talk to Jakub and David about the merge
> > conflict when net/master is merged to net-next/master.  
> 
> Yes. There will be a merge conflict. Therefore I thought bringing that 
> patch for the released 5.17 and the stable trees later would be less 
> effort for Jakub and David.

No strong preference in this particular case, -rc9 is very unlikely 
so won't be much difference between it getting merge to net or net-next.

If you don't have a preference either let's got with the usual process
and send the patch to net, just share the conflict resolution and we
can deal with it.
