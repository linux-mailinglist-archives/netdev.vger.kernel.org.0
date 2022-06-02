Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F3353BD93
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiFBRwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 13:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiFBRwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 13:52:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EDF3389D;
        Thu,  2 Jun 2022 10:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D8C2B82043;
        Thu,  2 Jun 2022 17:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4AEC34114;
        Thu,  2 Jun 2022 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654192337;
        bh=Cnx6ZRsHRRm8nyeac1ScMo+3eEGhTR4HEHn7fR/rOUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ngWLHIXAOvLHqjZq8kU6vZYJsVdaeCaBYi+/rlBUPi1ADrFfA6cOXwRnNpTvDyfiw
         bs09egutmQdNbp16y2BlIgcQ+3sqDrieOp13AsbFKQXCSwTaXFPRTq9azPKbaJV4eg
         EbbqtSmY9lpJ6+Xm5kLHxhEtynIHPdez2gtrP6cva1MilxRYesH+t6xzbz/Izir5dI
         OcBjIZCVU1/7LU7MaRYL2rpkgK/I5Abnisre8s4XqPeNmgv/GkPLDwc4CrZPS7LPXS
         f3zGLuyY9ITiM13vFPWUwntnV1yPzoDsRIN/85ZDigfTrdBfQ6ecHzr03kpYt1D9Vn
         +vfu0uHi/FV0g==
Date:   Thu, 2 Jun 2022 10:52:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <20220602105215.12aff895@kernel.org>
In-Reply-To: <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
        <20220601180147.40a6e8ea@kernel.org>
        <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
        <20220602085645.5ecff73f@hermes.local>
        <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
        <20220602095756.764471e8@kernel.org>
        <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jun 2022 17:15:13 +0000 Joakim Tjernlund wrote:
> > What is "our HW", what kernel driver does it use and why can't the
> > kernel driver take care of making sure the device is not accessed
> > when it'd crash the system?  
> 
> It is a custom asic with some homegrown controller. The full config path is too complex for kernel too
> know and depends on user input.

We have a long standing tradition of not caring about user space
drivers in netdev land. I see no reason to merge this patch upstream.

> > > Maybe so but it seems to me that this limitation was put in place without much thought.  
> > 
> > Don't make unnecessary disparaging statements about someone else's work.
> > Whoever that person was.  
> 
> That was not meant the way you read it, sorry for being unclear.
> The commit from 2012 simply says:
> net: allow to change carrier via sysfs
>     
>     Make carrier writable

Yeah, IIUC the interface was created for software devices.
