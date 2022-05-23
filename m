Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B87531840
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiEWS2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245430AbiEWS1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:27:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29929E9F8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA084CE1724
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 17:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C102EC385A9;
        Mon, 23 May 2022 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653328602;
        bh=PTRJE+tiw0z5DzecGRSn+uvQjoPL914rmiQd6Sds9ns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ukwa8WVDlH7mvQZmphhM3f/juP+ivsRVi9nAynxOu4KKUPvXfUrkvcq/pPMOoEp3X
         RGBcnQuRIONxdtgSnIX6tMsNUXJmNItH4xcuTo2k4uSy9C+Tp3/YGnoQQwvH9Up9N6
         8ZIIlMU6RjBw3ZkfXOVOPE+EHVCT67gr783iFOT3AXrvNJAsNVP0Dn79wyFPLmx6Sp
         BMM9YUSIGsB4ivb7jUYOVEWxoHIMwDDZbKjN3zLvZP0oAl0XT6O1DVA3dXl8lz+RR1
         I01WHBi4NLdkLO/THbc9NO9TQ+Hm3ahwcGMbdrqiiHHq0yaS2KjdzKXHhtV7AwidEa
         0HevmfzmnhMoA==
Date:   Mon, 23 May 2022 10:56:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220523105640.36d1e4b3@kernel.org>
In-Reply-To: <YotW74GJWt0glDnE@nanopsycho>
References: <Ymf66h5dMNOLun8k@nanopsycho>
        <20220426075133.53562a2e@kernel.org>
        <YmjyRgYYRU/ZaF9X@nanopsycho>
        <20220427071447.69ec3e6f@kernel.org>
        <YmvRRSFeRqufKbO/@nanopsycho>
        <20220429114535.64794e94@kernel.org>
        <Ymw8jBoK3Vx8A/uq@nanopsycho>
        <20220429153845.5d833979@kernel.org>
        <YmzW12YL15hAFZRV@nanopsycho>
        <20220502073933.5699595c@kernel.org>
        <YotW74GJWt0glDnE@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 11:42:07 +0200 Jiri Pirko wrote:
> Mon, May 02, 2022 at 04:39:33PM CEST, kuba@kernel.org wrote:
> >On Sat, 30 Apr 2022 08:27:35 +0200 Jiri Pirko wrote:  
> >> Now I just want to use this component name to target individual line
> >> cards. I see it is a nice fit. Don't you think?  
> >
> >Still on the fence.  
> 
> Why?

IIRC my concern was mixing objects. We have component name coming from
lc info, but then use it in dev flash.

> >> I see that the manpage is mentioning "the component names from devlink dev info"
> >> which is not actually implemented, but exactly what I proposed.  
> >
> >How do you tie the line card to the component name? lc8_dev0 from 
> >the flashing example is not present in the lc info output.  
> 
> Okay, I will move it there. Makes sense.

FWIW I think I meant my comment as a way to underline that what you
argue for is not what's implemented (assuming your "not actually
implemented" referred to the flashing). I was trying to send you back 
to the drawing board rather than break open a box of band-aides.
