Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1918598332
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244634AbiHRMb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243967AbiHRMbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:31:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC5BABF3E
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nW4WEHolHsX9f/bg1tly8YeUJyyIjO9uNWUW+lDxCe4=; b=Hlr//q3TqXDnZhv/pAOB+utZjT
        O72PM7y+GlCz5TSzsy5vt/G1740+6C467MWvZzhUOvsaSKbgA46OkUrtzAf07FCQcODXzBOAd5bPF
        cVG5XPAX+169Yny/FCafUPtX25SqRI2bTf7e4WUC3/zbilG2TWicqPBhVeLPwlnUNWPI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOegi-00Djxv-9T; Thu, 18 Aug 2022 14:31:52 +0200
Date:   Thu, 18 Aug 2022 14:31:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next PATCH 0/3] net: dsa: mv88e6xxx: Add RMU support
Message-ID: <Yv4xOK0pS8Xjh/Q8@lunn.ch>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102924.287719-1-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:29:21PM +0200, Mattias Forsblad wrote:
> The Marvell SOHO switches have the ability to receive and transmit                                                                                                    
> Remote Management Frames (Frame2Reg) to the CPU through the                                                                                                           
> switch attached network interface.                                                                                                                                    
> These frames is handled by the Remote Management Unit (RMU) in                                                                                                        
> the switch.

Please try to avoid all the additional whitespace your editor/mailer
has added.

> Next step could be to implement single read and writes but we've
> found that the gain to transfer this to RMU is neglible.

I agree that RMON is a good first step. Dumping the ATU and VTU would
also make a lot of sense.

For general register access, did you try combining multiple writes and
one read into an RMU packet? At least during initial setup, i suspect
there are some code flows which follow that pattern with lots of
writes. And a collection of read/modify/write might benefit.

    Andrew
