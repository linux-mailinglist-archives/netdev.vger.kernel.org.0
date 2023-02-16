Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5ED6998EA
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjBPPb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjBPPb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:31:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9550939CF9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:31:24 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v11so1810263edx.12
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+CNl/S3R6KJWtpTbyt0jY2SM61FBCDUIIPknXFrAHME=;
        b=d84hi1bx4ejbdgDEecEl4avWvn05ZA8pPPdHCM6U3km8ye2YnTUoaKl16/OJJEQEey
         c3Gle+ejtUuqVpTFUuguaX/6crgVIl6+CfqymDyk48dJ1r8IAj53tuj6iJSjrQaA8IUP
         nfA6IYVeJINYwBX+/iR7n3N+mZqLHd4J228TRdnYf8mYjnBvKtsBp2iP76izCXtFlSGb
         AB+/HhVHQjOgaqM6QzFBBu0VUFKPvlCPeqWdAEX/0A0LD+7vxomshfKWyh29qjzKhSVt
         pz4sVPgKLyIaEoLgMcv0UO+rAXpq2x9qYGjqrQZa7aLvaYGo+3OTukIiuQ5r8TVzk6vM
         dVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CNl/S3R6KJWtpTbyt0jY2SM61FBCDUIIPknXFrAHME=;
        b=VNI5Xaegb1zYjTDK7WIhDdkk4vECHhU3ovy/YrCG2DzZ4zJLL6htdjAgXiMWQCDPpU
         ppSwuSd1vCuMXPm0+32zaqPmudJuOSFwDqXEYU3iIjXj1qpbNkL7cF+QKZ4Hu0A6RjXX
         ygPfTdnSjXWuHW8VRWoU2dJlUM3q/RV+mbE0FHBYPuDm4Wiz08EktpL7i5DYVYTlieUD
         HYlHFxDqczs8L3QIfe8gnJMEfM+Nwn4y9q5XkwifdltxGyR0CbvgcVX1WduHEMh9Tz2p
         nDEwjh6puaPCVJ0C/7PzM5DFg++ZugxQeizg3w4emIuu3n54dqaQZFXmktilG8AVMVHH
         R6Tg==
X-Gm-Message-State: AO0yUKUE/bCsWd5n9immFecFFkdcKrJu5rXPa+JXPXzPXAa0EHRSySgi
        6xT6slqskJClW/2RRbYmYfN70euaoPe+wg==
X-Google-Smtp-Source: AK7set/e9DqnKigrnb9UWFDVBZKXBNruZp5hWHSVRIknIN0dif2GnBCY22cqmb5G9Irz+A5h8t8K/g==
X-Received: by 2002:aa7:d603:0:b0:4aa:cb67:2a63 with SMTP id c3-20020aa7d603000000b004aacb672a63mr5639997edr.16.1676561483045;
        Thu, 16 Feb 2023 07:31:23 -0800 (PST)
Received: from skbuf ([188.26.57.8])
        by smtp.gmail.com with ESMTPSA id k25-20020a50ce59000000b0049668426aa6sm1015217edj.24.2023.02.16.07.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:31:22 -0800 (PST)
Date:   Thu, 16 Feb 2023 17:31:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Angelo Dureghello <angelo@kernel-space.org>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230216153120.hzhcfo7t4lk6eae6@skbuf>
References: <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
 <20230216125040.76ynskyrpvjz34op@skbuf>
 <Y+4oqivlA/VcTuO6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+4oqivlA/VcTuO6@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 01:59:22PM +0100, Andrew Lunn wrote:
> On Thu, Feb 16, 2023 at 02:50:40PM +0200, Vladimir Oltean wrote:
> > On Thu, Feb 16, 2023 at 12:20:24PM +0100, Angelo Dureghello wrote:
> > > Still data passes all trough port6, even when i ping from
> > > host PC to port4. I was expecting instead to see port5
> > > statistics increasing.
> > 
> > > # configure the bridge
> > > ip addr add 192.0.2.1/25 dev br0
> > > ip addr add 192.0.2.129/25 dev br1
> > 
> > In this configuration you're supposed to put an IP address on the fec2
> > interface (eth1), not on br1.
> > 
> > br1 will handle offloaded forwarding between port5 and the external
> > ports (port3, port4). It doesn't need an IP address. In fact, if you
> > give it an IP address, you will make the sent packets go through the br1
> > interface, which does dev_queue_xmit() to the bridge ports (port3, port4,
> > port5), ports which are DSA, so they do dev_queue_xmit() through their
> > DSA master - eth0. So the system behaves as instructed.
> 
> Yep. As i said in another email, consider eth1 being connected to an
> external managed switch. br1 is how you manage that switch, but that
> is all you use br1 for. eth1 is where you do networking.

It would have been good to have support for subtractive device tree
overlays, such that when there are multiple CPU ports in the device
tree, the stable device tree has both CPU ports marked with the
"ethernet" phandle, but the user has the option of deleting that
property from one of the CPU ports, turning it into a user port.
Currently for LS1028A I am doing this device tree post-processing
from the U-Boot command line:

=> tftp $fdt_addr_r ls1028/fsl-ls1028a-rdb.dtb
=> fdt addr $fdt_addr_r
=> fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet

but it has the disadvantage that you can only operate with the
configuration that you booted with.

I analyzed the possibility for DSA to dynamically switch a port between
operating as a CPU port or a user port, but it is simply insanely complicated.
