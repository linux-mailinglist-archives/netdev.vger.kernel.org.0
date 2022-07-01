Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B49562E7B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiGAIip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiGAIik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8E712755;
        Fri,  1 Jul 2022 01:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F11B3621BB;
        Fri,  1 Jul 2022 08:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82B4C3411E;
        Fri,  1 Jul 2022 08:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656664713;
        bh=rK44NCzWOqo4I27A6uYsVw7hmEv82qI7qYAMPwc9i4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDeZlJcZlyuirP4fEtdm38/8cVpaRhnnwtqkZonyATd0o1phMXhzCeA8sOyLQAS5w
         Q+zA6RpYehRvzRCOhwtFItE5u15sDrMphNGX9VVxHBsGJbQ4evqTAgadi2uALmNYN6
         I0aMVlfAO2SC59FH3Vnl1SQSniI5duk3FVI7DZAw=
Date:   Fri, 1 Jul 2022 10:38:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Kalesh Singh <kaleshsingh@google.com>, jstultz@google.com,
        paulmck@kernel.org, rostedt@goodmis.org, rafael@kernel.org,
        hch@infradead.org, saravanak@google.com, tjmercier@google.com,
        surenb@google.com, kernel-team@android.com,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] pm/sleep: Add PM_USERSPACE_AUTOSLEEP Kconfig
Message-ID: <Yr6yhnZNkCDgde9z@kroah.com>
References: <20220630191230.235306-1-kaleshsingh@google.com>
 <Yr3+RLhpp3g9A7vb@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr3+RLhpp3g9A7vb@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 09:49:24PM +0200, Jason A. Donenfeld wrote:
> Hi Kalesh,
> 
> On Thu, Jun 30, 2022 at 07:12:29PM +0000, Kalesh Singh wrote:
> > Systems that initiate frequent suspend/resume from userspace
> > can make the kernel aware by enabling PM_USERSPACE_AUTOSLEEP
> > config.
> > 
> > This allows for certain sleep-sensitive code (wireguard/rng) to
> > decide on what preparatory work should be performed (or not) in
> > their pm_notification callbacks.
> > 
> > This patch was prompted by the discussion at [1] which attempts
> > to remove CONFIG_ANDROID that currently guards these code paths.
> > 
> > [1] https://lore.kernel.org/r/20220629150102.1582425-1-hch@lst.de/
> > 
> > Suggested-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> 
> Thanks, looks good to me. Do you have a corresponding Gerrit link to the
> change adding this to the base Android kernel config? If so, have my
> Ack:
> 
>     Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Cool, I'll queue this up and also the CONFIG_ANDROID removal into my
tree now, thanks all for working it out!

greg k-h
