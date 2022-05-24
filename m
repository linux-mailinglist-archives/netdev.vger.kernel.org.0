Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96D0532FFD
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbiEXSBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbiEXSBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:01:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8561F8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 11:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF4A761543
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 18:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD581C34100;
        Tue, 24 May 2022 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653415259;
        bh=7c7/1ncoxVcjNBF/+pP7cEuHfft6IJxw9J1pBxDh6GY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uzt4R2nrl/Y4B5OD1NRdSJGWRPpDJt8gp49K7xAkQ9WvXThTAYxMaYHpLO94YryuI
         Cd7FqoxO+F49MUFXCl87v8hhLvmLrewbCSJ2+mEQrt74uSADHu1uP2ZCjn8cSXWlo1
         uhirF/59G6PqhqpLYU2G0rwYpwTULHa0zbEy8qBdRkG/VL2IXv0CSM/fzjwDVXj7yN
         vp+s0/ZtPXbnx87ldOnIfB56DjNRF3Qk4heQSmCHisNw5f4dSUbiMuoHraswBDkXRm
         X63LZdurnL/u0QRAlZAvoqgR3i5sX1ohSpa8eawBXxQWfFZxAg7Rt455KASaW0QVXz
         MTYjpzzdDJ4cA==
Date:   Tue, 24 May 2022 11:00:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220524110057.38f3ca0d@kernel.org>
In-Reply-To: <YozsUWj8TQPi7OkM@nanopsycho>
References: <20220427071447.69ec3e6f@kernel.org>
        <YmvRRSFeRqufKbO/@nanopsycho>
        <20220429114535.64794e94@kernel.org>
        <Ymw8jBoK3Vx8A/uq@nanopsycho>
        <20220429153845.5d833979@kernel.org>
        <YmzW12YL15hAFZRV@nanopsycho>
        <20220502073933.5699595c@kernel.org>
        <YotW74GJWt0glDnE@nanopsycho>
        <20220523105640.36d1e4b3@kernel.org>
        <Yox/TkxkTUtd0RMM@nanopsycho>
        <YozsUWj8TQPi7OkM@nanopsycho>
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

On Tue, 24 May 2022 16:31:45 +0200 Jiri Pirko wrote:
> >Sure. I considered that. The thing is, even if you put the lc component
> >names to output of "devlink dev info", you would need to provide lc
> >objects as well (somehow) - to contain the versions.
> >
> >But the component name is related to lc object listed in "devlink lc",
> >so "devlink lc info" sounds line the correct place to put it.
> >
> >If you are concern about "devlink dev flash" using component name from
> >"devlink lc info", I would rather introduce "devlink lc flash" so you
> >have a match. But from what I see, I don't really see the necessity for
> >this match. Do you?  
> 
> Okay, we can eventually avoid using component name at all for now,
> considering one flash object per linecard (with possibility to extend by
> component later on). This would look like:
> 
> $ devlink lc info pci/0000:01:00.0 lc 8
> pci/0000:01:00.0:
>   lc 8
>     versions:
>         fixed:
>           hw.revision 0
> 	  fw.psid MT_0000000749
>         running:
>           ini.version 4
>           fw 19.2010.1310
> 
> $ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
> 
> I have to admit I like this.
> We would reuse the existing DEVLINK_CMD_FLASH_UPDATE cmd and when
> DEVLINK_ATTR_LINECARD_INDEX attribute is present, we call the lc-flash
> op. How does this sound?

We talked about this earlier in the thread, I think. If you need both
info and flash per LC just make them a separate devlink instance and
let them have all the objects they need. Then just put the instance
name under lc info.
