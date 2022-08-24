Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E0459F38A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 08:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiHXGRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 02:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiHXGRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 02:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31ADF7269F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 23:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2AF9B822DF
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9466C433C1;
        Wed, 24 Aug 2022 06:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661321859;
        bh=eutFafDQ+Gs3lRxl6F1VcbigtL2eKPKxbxI3Ub9rHUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xqxqGNSmhdC8pDFaznH7+hx/SfN7i9jEi4BvkxbiIoL3fHfU81w7IEUmZhTPH6jTz
         86oceq4T3F7L8+P4F1eLJmkpUxHwXg/CN4a1FeqOpp33uYgWuWTEhR9J8JrmfVbzHU
         hAFa9sXKh3HcJBYJSrpBNx7328KXH+3wVm9mZvww=
Date:   Wed, 24 Aug 2022 08:17:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net: dsa: microchip: make learning configurable
 and keep it off while standalone
Message-ID: <YwXCgC7cP+XHiBuL@kroah.com>
References: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
 <20220823143831.2b98886b@kernel.org>
 <20220823214253.wbzjdxgforuryxqp@skbuf>
 <20220823150113.22616755@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823150113.22616755@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 03:01:13PM -0700, Jakub Kicinski wrote:
> On Wed, 24 Aug 2022 00:42:53 +0300 Vladimir Oltean wrote:
> > On Tue, Aug 23, 2022 at 02:38:31PM -0700, Jakub Kicinski wrote:
> > > > @maintainers: when should I submit the backports to "stable", for older
> > > > trees?  
> > > 
> > > "when" as is how long after Thu PR or "when" as in under what
> > > conditions?  
> > 
> > how long after the "net" pull request, yes.
> > I'm a bit confused as to how patches from "net" reach the stable queue.
> > If they do get there, I'm pretty confident that Greg or Sasha will send
> > out an email about patches failing to apply to this and that stable
> > branch, and I can reply to those with backports.
> 
> Adding Greg, cause I should probably know but I don't. 
> 
> My understanding is that Greg and Sasha scan Linus's tree periodically
> and everything with a Fixes tag is pretty much guaranteed to be
> selected. Whether that's a hard guarantee IDK. Would be neat if it was
> so we don't have to add the CC: stable lines.

Please add cc: stable lines, that's the documented way to get a patch
into the stable kernel tree for the past 17+ years.

Only recently (5+ years?) have we also been triggering off of the
"Fixes:" tags, and we only started doing that for subsystems that never
was adding cc: stable tags :(

And also, the "Fixes:" tags are on the "slow path" to get into the
stable tree, sometimes taking a very long time, and sometimes just being
ignored entirely if we are busy with other work.  The only guaranteed
way is to tag it with cc: stable.

> Also not sure if it's preferred to wait for the failure notification 
> or you should pre-queue the backport as soon as it reaches Linus.
> I vague recall someone saying to wait for the notification...

It's easier for us if you wait for the rejection email, otherwise I have
to know to store it and save it for when I reject it in a few weeks in
the future, which is a pain on my end given the amount of email we have
to handle.

thanks,

greg k-h
