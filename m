Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DDA5F029C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiI3CLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiI3CLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E9C128708;
        Thu, 29 Sep 2022 19:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A71BC6221B;
        Fri, 30 Sep 2022 02:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA53C433D6;
        Fri, 30 Sep 2022 02:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664503899;
        bh=610ye87RXM6t7qZy9nt7HbkP7YXAdauTUSXPlb8Dodw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EUrSjzj3zyT68YvK9BjyTzILIqq0TgKB7LwQPSxaTSf1zW0qgW7ZZCtBCe+ek6NKX
         DIzkXHgtLJyMTi1xgk9syPQBgWBoAnASUTwLOsdeDKSxMnPxjmbJ2pgU6uSZFxLFts
         3WewPxS6XcY1aFhyLHf8ItbiHq5nHDYC7LHM0Lt952WWOhVRCswU7yKiveT8pL2xs1
         twPyl0qRNmgpK5IOEVIFmXQv332hsNZ4TNzePi4eeNtBOWBzBF5d7pshFvZ/uG3f/9
         Mtb1TLjnBEU+oMee51I3uNVMiinAcyFtytGKjK555VVkIBcc8jHiJfp/Bg1Obr7Nnc
         ba09djJs0xNKQ==
Date:   Thu, 29 Sep 2022 19:11:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: new warning caused by ("net-sysfs: update the queue counts in
 the unregistration path")
Message-ID: <20220929191137.7393bee4@kernel.org>
In-Reply-To: <YzTWwf/FyzBKGaww@chmeee>
References: <YzOjEqBMtF+Ib72v@chmeee>
        <166435838013.3919.14607521178984182789@kwain>
        <YzTWwf/FyzBKGaww@chmeee>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 16:20:33 -0700 Kevin Mitchell wrote:
> > As you said and looking around queue 0 is somewhat special and used as a
> > fallback. My suggestion would be to 1) check if the above race is
> > expected 2) if yes, a possible solution would be not to warn when
> > real_num_tx_queues == 0 as in such cases selecting queue 0 would be the
> > expected fallback (and you might want to check places like [1]).  
> 
> Yes this is exactly where this is happening and that sounds like a good idea to
> me. As far as I can tell, the message is completely innocuous. If there really
> are no cases where it is useful to have this warning for real_num_tx_queues ==
> 0, I could submit a patch to not emit it in that case.

SGTM, FWIW.
