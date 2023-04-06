Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF146D9A92
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbjDFOiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238965AbjDFOiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:38:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968D8C67D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 07:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF346451B
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 14:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95309C433D2;
        Thu,  6 Apr 2023 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680791763;
        bh=lR33vhNSVtr/358hKbvDtHFAyEv0PrAdCFfSS/SZLls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VcBSmzzJhscTeNokvnewpnPXSvb12UawOPmR1GaLBdjTaa6y/bnw6N7sxlGuNKJ/m
         zUy7xvENIWNAphpgMXuHaFQuGsxdHQz/3dcxhKgLzrfBMjCTgi/Hht4hF8aQTQZceL
         RmuCh0rCGoTAtcZrJiYilQUrodTa+MoiYhGX2tRQnIrzQ/oXqXs4th0/bx4cDOlrIr
         Ksf0/ZVxtMtZFUBCMv0ZFrxauANIVLyyeRas0kLOhwzC+53nwti78HBKwmvbUIiFRe
         CtoQ95YYj5ZCeLm++tgXVPLOXV8bkyzkaH3aqfq+mc2UHFOKYGbuSdr+61C1Jai0bm
         cjzD3eCAdt28Q==
Date:   Thu, 6 Apr 2023 07:35:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230406073556.7d63df19@kernel.org>
In-Reply-To: <93ae54eb-5287-8d63-5109-973bfacc6b74@gmail.com>
References: <20230406114246.33150-1-vladimir.oltean@nxp.com>
        <93ae54eb-5287-8d63-5109-973bfacc6b74@gmail.com>
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

On Thu, 6 Apr 2023 06:07:45 -0700 Florian Fainelli wrote:
> > There have been objections from Jakub Kicinski that using notifiers in
> > general when they are not absolutely necessary creates complications to
> > the control flow and difficulties to maintainers who look at the code.
> > So there is a desire to not use notifiers.  
> 
> Jakub is there a general desire to move away from notifiers? If so, do 
> you have a list of things that may no longer belong there?

I think they are harder to follow when debugging, so if other options
are available we should prefer them. Built-in code calling modular code,
for example, can be done thru a function pointer, which is the case
here.
