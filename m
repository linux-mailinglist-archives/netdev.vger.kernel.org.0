Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A06882EF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjBBPqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjBBPqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:46:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBA5DBD3;
        Thu,  2 Feb 2023 07:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2hrdjUawOZ654pknRDcMqi38Iq79lM2HX+w3uoAN++M=; b=NJtckHOe4NcrWGeRAmpwTGTE9Q
        eohLPTt570JBScxPsBr46L2zpr3jFLkH95cjfJlR09gz/wnl5v65Iwm7ieJy6DjyVzmfLbU/sLeKi
        DidnbFChGIV2wIqfNf6MZKwzQhSxzi8cepYoynMSsuwnA4yg4B/JvgO128rU9SUCgU1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNbm1-003uR8-QK; Thu, 02 Feb 2023 16:45:17 +0100
Date:   Thu, 2 Feb 2023 16:45:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 08/11] net: dsa: microchip: lan937x: avoid
 mib read for cascaded port
Message-ID: <Y9vajWbCjZrGibHp@lunn.ch>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-9-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-9-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:27PM +0530, Rakesh Sankaranarayanan wrote:
> Cascaded port need not be involved in mib read process. Unlike cpu port,
> mib read function will be called for all other ports. Add check to skip
> function if port is of type DSA_PORT_TYPE_DSA.

I would actually read the statistics. Having debugged D in DSA
systems, it is useful to know if packets are making it from one switch
to the other, etc.

The problem is getting the information out of the kernel. For
mv88e6xxx we have had an out of tree patch which exposes this
information in debugfs.

	Andrew
