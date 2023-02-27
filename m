Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D866A452E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjB0OwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB0OwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:52:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9262199DF;
        Mon, 27 Feb 2023 06:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BEf3+GrVy/Ve5Mra+H11XKmh4RTr6rjhGhJDtl+7Fjk=; b=CbUGOZLK4Cx9tQ0rL/NWMu0Y87
        1JJFkljLbMyH/er35Uc99ineykFQA6zjdYmmLOdT5sZTIhZRJAKadEYBXcjHbaJFyOmzl3bg4vpKm
        hol8DUnU33/C404gRxmcSZ+yu7M7rYMXh+Hv0mI4+Ds97lBOuBdRf3A6sU6pr2uLSSjE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pWerJ-0065MP-Ch; Mon, 27 Feb 2023 15:52:09 +0100
Date:   Mon, 27 Feb 2023 15:52:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Message-ID: <Y/zDmZDPnwvBqAST@lunn.ch>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
 <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
 <20230217164227.mw2cyp22bsnvuh6t@skbuf>
 <47a67799-27d9-094e-11c3-a18efcf281e2@intel.com>
 <20230224215349.umzw46xvzccjdndd@skbuf>
 <ca1f4970-206d-64f2-d210-e4e54b59d301@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca1f4970-206d-64f2-d210-e4e54b59d301@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Easiest way to see a disassembly (also has C code interleaved) would be
> > this:
> > 
> > make drivers/net/dsa/microchip/ksz_ethtool.lst
> 
> Oh, nice! I didn't know Kbuild has capability of listing the assembly
> code built-in. I was adding it manually to Makefiles when needed >_<
> Thanks! :D

You can also do

make drivers/net/dsa/microchip/ksz_ethtool.o
make drivers/net/dsa/microchip/ksz_ethtool.S

etc to get any of the intermediary files from the build process.

Also

make drivers/net/dsa/microchip/

will build everything in that subdirectory and below. That can be much
faster, especially when you have an allmodconf configuration and it
needs to check 1000s of modules before getting around to building the
one module you just changed. FYI: the trailing / is important.

       Andrew
