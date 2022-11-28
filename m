Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC3863B5BF
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiK1XSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiK1XSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:18:07 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8EC25296;
        Mon, 28 Nov 2022 15:18:06 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id v3so11362514pgh.4;
        Mon, 28 Nov 2022 15:18:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BmoOTGFi6JltCrWxfK3yHl/CkpSEbsjve+TtReyPSMk=;
        b=4ThU32Uw7dv6J4aiw90nwLGKd9OZ4BxiKD3/RYpEIWq4yAmdHCl9AxsRbDz6lgi0xy
         VpvZWAEevKeq2x/6+WqmGVCrZkiZ2Ii8cQQG70Id+zjVWwPlTWyjQC6KjAljx7BXuxH2
         r8Qf3J6iP6iDKXu0/TkaKHPpLMrlTPs0EHxnyLlcEuDnP+06mPY8jJZYGh4c6Bd99e9E
         NCyap3qYE+8NUcCyq9UC7T03C+4dWgaXI0wKv05EXyLxTYLorNWxRcsPLH2dstJLv8Bl
         INZkfAKHBvnB5WVuibyFwSXt3tQwOLeMG4hg4Pv/VZ+GQWZ9ZejSoIqKMFX0WPY5yBI/
         Ov3g==
X-Gm-Message-State: ANoB5pkf486jbww4EWvFQM+yxsNjsllCsiBc2eDUapsE7R8m/UcNhz5I
        QLos+OEJqt/Oje4Py+y8VNSUylc40IrpxGOz18s=
X-Google-Smtp-Source: AA0mqf5R7R1rrnT4jxiSzHues/lBn+HzCTojJ7W7ZrVNk/A64ek9pAF1lRKO+w4lzdBlnTI+Cg3h8mBhl8ug38ukLJE=
X-Received: by 2002:a05:6a00:194a:b0:56b:a795:e99c with SMTP id
 s10-20020a056a00194a00b0056ba795e99cmr43585538pfk.14.1669677486025; Mon, 28
 Nov 2022 15:18:06 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4S73jX07uFAwVQv@lunn.ch> <CAMZ6RqKYyLCCxQKSnOxku2u9604Uxmxw3xG9d031-2=9iC_8tw@mail.gmail.com>
 <20221128142723.2f826d20@kernel.org>
In-Reply-To: <20221128142723.2f826d20@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 08:17:55 +0900
Message-ID: <CAMZ6RqJS5X54WyKyPxt+nqMSbiKVWiwZ85o9q860_z_uGfaawQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 29 Nov. 2022 at 07:27, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 28 Nov 2022 23:43:19 +0900 Vincent MAILHOL wrote:
> > On Mon. 28 Nov. 2022 at 22:49, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > devlink does not yet have a name suited for the bootloader and so this
> > > > last piece of information is exposed to the userland for through a
> > > > custom name: "bl".
> > >
> > > Jiri, what do you think about 'bl'? Is it too short, not well known
> > > enough? It could easily be 'bootloader'.
> >
> > For the record, I name it "bl" by analogy with the firmware which is
> > named "fw". My personal preference would have been to name the fields
> > without any abbreviations: "firmware", "bootloader" and
> > "hardware.revision" (for reference ethtool -i uses
> > "firmware-version"). But I tried to put my personal taste aside and
> > try to fit with the devlink trends to abbreviate things. Thus the name
> > "bl".
>
> Agreed, I thought "fw" is sufficiently universally understood to be used
> but "bl" is most definitely not :S  I'd suggest "fw.bootloader". Also
> don't hesitate to add that to the "well known" list in devlink.h,
> I reckon it will be used by others sooner or later.

I like the "fw.bootloader" suggestion. A bootloader is technically
still a firmware. I will send a separate patch to add the entry to
devlink.h and only then send the v5.
