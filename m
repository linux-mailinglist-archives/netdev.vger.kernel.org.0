Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A56371CF
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 06:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiKXFeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 00:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXFeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 00:34:11 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57643A658C;
        Wed, 23 Nov 2022 21:34:10 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so673840pjj.4;
        Wed, 23 Nov 2022 21:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uspQkG6ObcV5KxUA/GAC67CunaYZcH72ZKB+ZacXY/4=;
        b=ZCPOFW8MZAjLFsjvterIBNBMd3QZOn+hba83TAaK9eqZycCN8+s6Z0dpbaUEs06hXC
         jNmH8G4GdAshgvH2zfotf/QT65raUBUmKUDa2FiBF7ivJjlYUvYeJvl4XXHXBqq0mJsE
         gOaFobyFGTnQjNZj4HCXGx6PxhJL8j5BV30WfXBTe/nbrmfSrIL0DvilSKsHscAy/Miv
         iKxu9pza99PzgIMUzOqCTAI0MbAG08UFY9VyF1/D4Hut7lWN+VBhafaGcbYcaj7LpkSc
         RnlPMdes0J5hKXTzGXOv7cSqNO9KDK4ZCyIhHihUB3Lp8o4bUaFShK2c0VxnmgW6BCm3
         /2aQ==
X-Gm-Message-State: ANoB5pmoqVweUFBt8yLhojXpC0ANFw1BH36/RTrRmUPuFyU2CLl+FRqA
        Snd2iSVCGSmbn4eKfT485JCwwT3tZkhG891oSVYGJCY6SDM=
X-Google-Smtp-Source: AA0mqf6dcIiK0Hy34ulV8p1xzfbO1Z3JK/hZUP2x8fXcnFQsA4+KGDxOdx10tDT8HlIGDTRGe6d0tmxTu1+1uwOk/wc=
X-Received: by 2002:a17:90a:a60c:b0:213:2e97:5ea4 with SMTP id
 c12-20020a17090aa60c00b002132e975ea4mr39874574pjq.92.1669268049736; Wed, 23
 Nov 2022 21:34:09 -0800 (PST)
MIME-Version: 1.0
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221122201246.0276680f@kernel.org> <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
 <20221123190649.6c35b93d@kernel.org>
In-Reply-To: <20221123190649.6c35b93d@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 24 Nov 2022 14:33:58 +0900
Message-ID: <CAMZ6RqJ_rjbbwAfKzA3g2547D5vMke2KBnWCgBVmQqLcev1keg@mail.gmail.com>
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default information
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 24 Nov. 2022 at 12:06, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 23 Nov 2022 18:42:41 +0900 Vincent MAILHOL wrote:
> > I see three solutions:
> >
> > 1/ Do it in the core, clean up all drivers using
> > devlink_info_driver_name_put() and make the function static (i.e.
> > forbid the drivers to set the driver name themselves).
> > N.B. This first solution does not work for
> > devlink_info_serial_number_put() because the core will not always be
> > able to provide a default value (e.g. my code only covers USB
> > devices).
> >
> > 2/ Keep track of which attribute is already set (as you suggested).
> >
> > 3/ Do a function devlink_nl_info_fill_default() and let the drivers
> > choose to either call that function or set the attributes themselves.
> >
> > I would tend to go with a mix of 1/ and 2/.
>
> I think 2/ is best because it will generalize to serial numbers while
> 1/ will likely not. 3/ is a smaller gain.
>
> Jiri already plumbed thru the struct devlink_info_req which is on the
> stack of the caller, per request, so we can add the bool / bitmap for
> already reported items there quite easily.

Sorry, let me clarify the next actions. Are you meaning that Jiri is
already working on the bitmap implementation and should I wait for his
patches first? Or do you expect me to do it?
