Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6C258F200
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiHJR6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiHJR6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF53642C5;
        Wed, 10 Aug 2022 10:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2908461359;
        Wed, 10 Aug 2022 17:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8542C433D7;
        Wed, 10 Aug 2022 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660154292;
        bh=xrnvXvsN6JJpjJ1ongLGsCqRkrCfXBIT3fG/GR+LTMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MW3OBIG1ULi6loJyXfTVjtOf14dvFe0Os/NqOGogPM6bg/YKmAxvhwSv0o0Ur/Ivh
         e0L072ACVBaGE9lfTS/UoVC5xGFMfQdZDkb6+RFpzDnJOdG/IbMMUbj6XZE5CD5b+7
         pE6qYNrEAgzYPMfCibQcgTPo2wkNhHIaI/uPTJgiqN9wgp0XjmKStuZ3P6ixNBqPe9
         bpAtyPxCIKAF8V3kZqjLfpompiLeBtMb7RGH+w68t6hvMyd1+/YD+kEW4TL3UQVtVx
         nF3lMSxyOLibViUEFOn4m/kzuIi3Obk+0W8UEnls0wgrwxYfrFSOm9IjxqP1fiBHk0
         IBRYSdCwj+RCA==
Date:   Wed, 10 Aug 2022 10:58:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     ecree@xilinx.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-net-drivers@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Message-ID: <20220810105811.6423f188@kernel.org>
In-Reply-To: <572c50b0-2f10-50d5-76fc-dfa409350dbe@gmail.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
        <20220805184359.5c55ca0d@kernel.org>
        <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
        <20220808204135.040a4516@kernel.org>
        <572c50b0-2f10-50d5-76fc-dfa409350dbe@gmail.com>
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

On Wed, 10 Aug 2022 17:02:33 +0100 Edward Cree wrote:
> On 09/08/2022 04:41, Jakub Kicinski wrote:
> >> Maybe a bad word choice.  I'm referring to whichever PF (which likely
> >>  also has an ordinary netdevice) has administrative rights over the NIC /
> >>  internal switch at a firmware level.  Other names I've seen tossed
> >>  around include "primary PF", "admin PF".  
> > 
> > I believe someone (mellanox?) used the term eswitch manager.
> > I'd use "host PF", somehow that makes most sense to me.  
> 
> Not sure about that, I've seen "host" used as antonym of "SoC", so
>  if the device is configured with the SoC as the admin this could
>  confuse people.

In the literal definition of the word "host" it is the entity which
"owns the place".

> I think whatever term we settle on, this document might need to
>  have a 'Definitions' section to make it clear :S

Ack, to perhaps clarify my concern further, I've seen the term
"management PF" refer to a PF which is not a netdev PF, it only
performs management functions. Which I don't believe is what we
are describing here. So a perfect term would describe the privilege
not the function (as the primary function of such PF should still
networking).

> >> Yes, that's where I got this terminology from.
> >> "the" PCIe controller here is the one on which the mgmt PF lives.  For
> >>  instance you might have a NIC where you run OVS on a SoC inside the
> >>  chip, that has its own PCIe controller including a PF it uses to drive
> >>  the hardware v-switch (so it can offload OVS rules), in addition to
> >>  the PCIe controller that exposes PFs & VFs to the host you plug it
> >>  into through the physical PCIe socket / edge connector.
> >> In that case this bullet would refer to any additional PFs the SoC has
> >>  besides the management one...  
> > 
> > IMO the model where there's a overall controller for the entire device
> > is also a mellanox limitation, due to lack of support for nested
> > switches  
> Instead of "the PCIe controller" I should probably say "the local PCIe
>  controller", since that's the wording the devlink-port doc uses.

SG!

> > "TX queue attached to" made me think of a netdev Tx queue with a qdisc
> > rather than just a HW queue. No better ideas tho.  
> 
> Would adding the word "hardware" before "TX queue" help?  Have to
>  admit the netdev-queue interpretation hadn't occurred to me.

It would!

> >> (And it looks like the core uses `c<N>` for my `if<N>` that you were
> >>  so horrified by.  Devlink-port documentation doesn't make it super
> >>  clear whether controller 0 is "the controller that's in charge" or
> >>  "the controller from which we're viewing things", though I think in
> >>  practice it comes to the same thing.)  
> > 
> > I think we had a bit. Perhaps @external? The controller which doesn't
> > have @external == true should be the local one IIRC. And by extension
> > presumably in charge.  
> 
> Yes, and that should work fine per se.  It's just not reflected in the
>  phys_port_name string in any way, so legacy userland that relies on
>  that won't have that piece of info (but it never did) and probably
>  assumes that c0 is local.

Ack, we could check the archive but I think that's indeed the case.
