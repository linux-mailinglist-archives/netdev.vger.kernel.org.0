Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44BC643DBE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLFHoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFHoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:44:21 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FC411160
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 23:44:19 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bx10so22296920wrb.0
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 23:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H7kqvgN+XkPOQvjICrJWbWauAvTbAljV/6ARm+5u3jE=;
        b=dT7tvHBU9Z27TMfg3l1Zq+zgfCEc8xaPLV1XC9hwh0YjFzRcJ8IcDFISm0sb1NMlae
         /HLM7xGGFr5/ssLWpA4iCthcmb0EahN1BYYBR5oku7zGHf8jr9wa4PkZ1YEa9jawp46o
         z0yBEQ3iMbK7P5xcHvaCVS3ljyojCXWQ+5umkBMlYvr2KTdC11SA3lyVh4YgiN9Nniii
         2A4w4X6e72NVOgOgFZuz22l72MspLtO6yidhCVjDkvCE6w5ARfWXBZh98gUcXNJ2/pDb
         CEuD0nwOzyMOGQcVNAFFZ6b3xVhbKHr3ds1wN9bQjLmUxj+VS4oV3/0hOLxsoFLZIYYu
         F07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7kqvgN+XkPOQvjICrJWbWauAvTbAljV/6ARm+5u3jE=;
        b=uvUH9e5WcK/oZulVIZ+hzRcoU0f1xkCfx2BdOarkcsK66MiueDRp3J5c3p41bgV5EV
         AMPsMUGnju/uUvd+SShMGbg+QBTjy+1Tmosf5xBc7RCLQow90L8GeFTMfX6n9VImYdV4
         DKAsxNFcdydL5ZEIBtgAf5HMZr9fbcWZYbO6UjBxFW+hIuRTHHkeo95qtT2BvuH83usd
         VE1MHmsEzPm3GDbEQ4J56VpbtMVY+uiO6kWv6yEi3uG83wjAozRRh1QP4C9a+gGjdQjj
         Gxo8AipLvIjSmeBjA75fDlVFlVkJ0ZS15FppH41+akX2jLA8KCAQf0U2qO5pRxGmXrIx
         c+tw==
X-Gm-Message-State: ANoB5pkYe6ViTNDDNJwBfB2V2YkhiXNYfZi8OS1fHoHYmBeLzXGcMhmv
        U4/j5wE7zC7HeFpb5BdHKp1yFQ==
X-Google-Smtp-Source: AA0mqf5fNBUou/Yh2PmREU5ZXe7EFI7WrOAXNvDhAHNAI720cJboRXejL1GaHY8NznV0Fu104fbZUg==
X-Received: by 2002:adf:efcb:0:b0:242:5ff0:6d8a with SMTP id i11-20020adfefcb000000b002425ff06d8amr5305777wrp.135.1670312658215;
        Mon, 05 Dec 2022 23:44:18 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id dn13-20020a05600c654d00b003c6bd12ac27sm19940513wmb.37.2022.12.05.23.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 23:44:17 -0800 (PST)
Date:   Tue, 6 Dec 2022 08:44:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: Re: [patch net-next 0/8] devlink: make sure devlink port
 registers/unregisters only for registered instance
Message-ID: <Y47y0FZQxPDK3B5X@nanopsycho>
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205170826.17c78e90@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205170826.17c78e90@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 02:08:26AM CET, kuba@kernel.org wrote:
>On Mon,  5 Dec 2022 16:22:49 +0100 Jiri Pirko wrote:
>> Currently, the devlink_register() is called as the last thing during
>> driver init phase. For devlink objects, this is fine as the
>> notifications of objects creations are withheld to be send only after
>> devlink instance is registered. Until devlink is registered it is not
>> visible to userspace.
>> 
>> But if a  netdev is registered before, user gets a notification with
>> a link to devlink, which is not visible to the user yet.
>> This is the event order user sees:
>>  * new netdev event over RT netlink
>>  * new devlink event over devlink netlink
>>  * new devlink_port event over devlink netlink
>> 
>> Also, this is not consistent with devlink port split or devlink reload
>> flows, where user gets notifications in following order:
>>  * new devlink event over devlink netlink
>> and then during port split or reload operation:
>>  * new devlink_port event over devlink netlink
>>  * new netdev event over RT netlink
>> 
>> In this case, devlink port and related netdev are registered on already
>> registered devlink instance.
>> 
>> Purpose of this patchset is to fix the drivers init flow so devlink port
>> gets registered only after devlink instance is registered.
>
>I didn't reply because I don't have much to add beyond what 
>I've already said too many times. I prefer to move to my
>initial full refcounting / full locking design. I haven't posted 
>any patches because I figured it's too low priority and too risky
>to be doing right before the merge window.

I'm missing how what you describe is relevant to this patchset and to
the issue it is trying to solve :/ 


>
>I agree that reordering is a good idea but not as a fix, and hopefully

I don't see other way to fix the netdev/devlink events ordering problem
I described above. Do you?



>without conditional locking in the drivers:
>
>+		if (!reload)
>+			devl_lock(devlink);
>+		err = mlxsw_driver->ports_init(mlxsw_core);
>+		if (!reload)
>+			devl_unlock(devlink);
