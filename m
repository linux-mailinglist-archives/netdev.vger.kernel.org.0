Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58E04FA069
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 02:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiDIAGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 20:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiDIAGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 20:06:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3151EDA3B;
        Fri,  8 Apr 2022 17:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F168B821FB;
        Sat,  9 Apr 2022 00:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892C8C385A3;
        Sat,  9 Apr 2022 00:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649462665;
        bh=bd8rzBS+vEc4ttPjaHAQjZ7XjvJdbi78cn8u1jcSgnY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AwBP3ICswtwn4xr9uXInDJ4nqqlw/9l7rsH7J5AmSQ38K7fhTXA/NIsNkI3Cku5LF
         UyOlYbhACeeY/VSub9qNl02fo6GS4pMScAhZgzr371jyLskztqeh5z1ZItO+hxfMLV
         /aPzSIUVhfVwrmhDdf/FLz7WbjqYG23kHHCcNWNodIQ4ejDS5PdzQ/dHAtIGLry+hQ
         ir5v8brOrIClr3cwwWDmp3wWYO8brZ/IyRy3D1ItZTpXVEm//sr5Cwr/s/1cBmrtEG
         x7Tt7OnYb+8u5jUHUvv635ozDpZ13jxsnG+j3lNWF2SHpwUVQ3yLXRLZgCTH9fQ3Ku
         rHHyHCSlsR/Ww==
Date:   Fri, 8 Apr 2022 17:04:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Message-ID: <20220408170423.35b379d9@kernel.org>
In-Reply-To: <AAB64C72-5B45-4BA1-BB48-106F08BDFF1B@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
        <20220407102900.3086255-3-jakobkoschel@gmail.com>
        <20220407205426.6a31e4b2@kernel.org>
        <AAB64C72-5B45-4BA1-BB48-106F08BDFF1B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Apr 2022 01:58:29 +0200 Jakob Koschel wrote:
> > This turns a pretty slick piece of code into something ugly :(
> > I'd rather you open coded the iteration here than make it more 
> > complex to satisfy "safe coding guidelines".  
> 
> I'm not entirely sure I understand what you mean with 
> "open coded the iteration". But maybe the solution proposed by Vladimir [1]
> works for you?

Yup, that's what I meant!

> I'm planning to rewrite the cases in that way for the relevant ones.
>
> > Also the list_add() could be converted to list_add_tail().  
> 
> Good point, I wasn't sure if that's considered as something that should be
> done as a separate change. I'm happy to include it in v2.

Ack, separate patch would be better for that. I guess Vladimir may have
used .prev on purpose, since _tail() doesn't intuitively scream _after()
Anyway, not important.
