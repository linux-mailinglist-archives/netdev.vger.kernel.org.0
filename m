Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ACE58CF7F
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244028AbiHHVJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiHHVJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:09:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F2DDF56;
        Mon,  8 Aug 2022 14:09:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A43E81FEAE;
        Mon,  8 Aug 2022 21:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659992987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4EKm8CZUskClhI2ZmVw8UVQVjqsShuHhEQWHRMmGpE=;
        b=SaUFl5kO3i6ZSK6KGNznghKuL1zM0JSShyzhijdo6uv4zefohwAEQBvrGUEblLniInaGzt
        fHoNtrDhvkSOZQA5G1XJnXfyBWa+Jq8IsZco5MezQSCrKrtzusFUveo0sWbP4S8ptFU72r
        wOGseieupbVdGk2ccJamWr0EupAsyBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659992987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4EKm8CZUskClhI2ZmVw8UVQVjqsShuHhEQWHRMmGpE=;
        b=JwTACEWFXgiGowGvZUqGHxlgaFPsP/xVprnJ9Ur3yqvMBo+Hjs9L0t01UP4yg2Ex+ThdmT
        jAYukaJkPnXx7pCw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 952722C143;
        Mon,  8 Aug 2022 21:09:46 +0000 (UTC)
Date:   Mon, 8 Aug 2022 23:09:45 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220808210945.GP17705@kitsune.suse.cz>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> Hi Tim,
> 
> On 8/8/22 3:18 PM, Tim Harvey wrote:
> > Greetings,
> > 
> > I'm trying to understand if there is any implication of 'ethernet<n>'
> > aliases in Linux such as:
> >         aliases {
> >                 ethernet0 = &eqos;
> >                 ethernet1 = &fec;
> >                 ethernet2 = &lan1;
> >                 ethernet3 = &lan2;
> >                 ethernet4 = &lan3;
> >                 ethernet5 = &lan4;
> >                 ethernet6 = &lan5;
> >         };
> > 
> > I know U-Boot boards that use device-tree will use these aliases to
> > name the devices in U-Boot such that the device with alias 'ethernet0'
> > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> > appears that the naming of network devices that are embedded (ie SoC)
> > vs enumerated (ie pci/usb) are always based on device registration
> > order which for static drivers depends on Makefile linking order and
> > has nothing to do with device-tree.
> > 
> > Is there currently any way to control network device naming in Linux
> > other than udev?
> 
> You can also use systemd-networkd et al. (but that is the same kind of mechanism)
> 
> > Does Linux use the ethernet<n> aliases for anything at all?
> 
> No :l

Maybe it's a great opportunity for porting biosdevname to DT based
platforms ;-)

Thanks

Michal
