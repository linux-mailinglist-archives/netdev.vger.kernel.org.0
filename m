Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9A67400A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjASRfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjASRfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:35:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD87B74EAC;
        Thu, 19 Jan 2023 09:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B23D61CEF;
        Thu, 19 Jan 2023 17:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D9CC433EF;
        Thu, 19 Jan 2023 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674149727;
        bh=bQ1z3Gpo2rQL+7xAUVJanEXxq5N4GITE1gOr28Pvfic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mHKiwqVkTfvMO+B+De2oHTX8RWgYskyVk3wMfD0b89A0/bBj3z4yNJ3sUSGhZaTi+
         HNBzXPOqhX+uBLMKVp/skS/GQm6o4HLZ2Lw+AwqenA/YpAvPfJhQP9RdwBRXg7Rv/l
         FVYWTtrdAzm0e9HVloQQiFxqlk8I8lkKSAHNq/8IUWDxfJ3DRgoXeTICsFKlwTTJRQ
         SOtU2cXpwjb66MtqVvXfsMOIjlSfXZcEvJAgJCgYqAv9rvbj1ubiRARD97qC39/J75
         InHXW2tS8kwg8ThwZPAHADYAqC5Zv/Qc5YtbG35I34/7YO8Gh7HUiN7wq6pFyHufSN
         6vi/DlDatonrQ==
Date:   Thu, 19 Jan 2023 09:35:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rakesh.Sankaranarayanan@microchip.com, olteanv@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, hkallweit1@gmail.com,
        Arun.Ramadoss@microchip.com, Woojung.Huh@microchip.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, edumazet@google.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Message-ID: <20230119093526.40dd03b0@kernel.org>
In-Reply-To: <Y8l9mMpiFSHTt1iU@lunn.ch>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
        <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
        <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
        <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
        <20230116222602.oswnt4ecoucpb2km@skbuf>
        <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
        <Y8l9mMpiFSHTt1iU@lunn.ch>
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

On Thu, 19 Jan 2023 18:27:52 +0100 Andrew Lunn wrote:
> > Thanks for pointing this out. Do you think submitting this patch in
> > net-next is the right way?  
> 
> I would probably go for net-next. That will give it more soak time to
> find the next way it is broken....

Either a fix or not a fix :( Meaning - if we opt for net-next
please drop the Fixes tag.

FWIW Greg promised that if we put some sort of a tag or information 
to delay backporting to stable they will obey it. We should test that
at some point.
