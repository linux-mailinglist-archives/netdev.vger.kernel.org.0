Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D69065CFEE
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjADJuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbjADJuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:50:37 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8273D1A23D
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 01:50:35 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l26so23549197wme.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 01:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ACrww/DRQoA9Q0aUdkjpN0p71+J8Onq6ldpSij5PhFw=;
        b=G33Z7ibKG5Fi1MsF0+2pCmKnmGUS7JK9Nw2yckRJSUG3oE9y1+GvP/EZoF90rV0hq2
         0XOjOpPd/L1lmN0u/2r1Iri9cwNcjLKeO5NHZjNU5iJ/bfXICdkBQ8qFZAMFwBRc6OPt
         2eaTEKvX7n5m65Ag58K6utCA9WFfNwqyYg/SXJApc1xJmI5nqkqw9RyUzAuGJy2XvnUe
         QFJH3v1SwMKmCmO3F+sGwh5X+EFY/Gb6pwVi1s25p6LTc8VbwZcZoWIxdgXVHbzF8tPE
         NjJDHh3DNAxDjgfBcc+j8TYFGw3UwGR/shKJHvVPgQ2y81FauF5kLGoWfIQ3yndXYGIM
         b0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACrww/DRQoA9Q0aUdkjpN0p71+J8Onq6ldpSij5PhFw=;
        b=MQHldF8v3OgpK1yErJF8qmWnH4/paG1VPSCvzLZ37QLOYCiY3cgt7vmB0owYUmoXoE
         60tSHL592CbAusuEQvKBEI1dWxLEB9PobJnKZhPJ+s5FFd6WyI7COiubYI60lLBQ2CKr
         YuPf4Nl5fMUZcZXBCHBjL2ruy6orGUPkvTvTJ3Wglom1ncRM1PmZzhqH+kOVJr+NebvL
         C+FP+QtAyPxh8CzwO57vdFv88iRTnQCvkSiOc26Aa8hre6RpCYoSxJMzLynBdfqgezDE
         rn1iHX9m9g/bjqixW/85EZS58ZFQFX4u6IRHnXfm5YbQt/LWEK5CSM1Sh2k8lYinyLSo
         JFQQ==
X-Gm-Message-State: AFqh2koHHSi5zNa4EU+3QGcIyYJjip8sIy/bpYSE+MlvQ3D8Xj5GCqr4
        ivD1qehqQvGl75/kJHDB1hgYgA==
X-Google-Smtp-Source: AMrXdXuP3mrhM+K90L/Vv6W+mWnZDKL1w+jj/swDZ2yfEMotxxkj05z2XcVFURqFQk80o8ENVFy6CA==
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr34441583wmr.33.1672825834028;
        Wed, 04 Jan 2023 01:50:34 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d22-20020a1c7316000000b003d9862ec435sm31745950wmb.20.2023.01.04.01.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 01:50:33 -0800 (PST)
Date:   Wed, 4 Jan 2023 10:50:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 02/14] devlink: split out core code
Message-ID: <Y7VL6P0hfCEvBFzV@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-3-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:24AM CET, kuba@kernel.org wrote:
>Move core code into a separate file. It's spread around the main
>file which makes refactoring and figuring out how devlink works
>harder.
>
>Move the xarray, all the most core devlink instance code out like
>locking, ref counting, alloc, register, etc. Leave port stuff in
>basic.c, if we want to move port code it'd probably be to its own file.

leftover.c

>
>Rename devlink_netdevice_event() to make it clear that it only touches
>ports (that's the only change which isn't a pure code move).

Did you do any other changes on the move? I believe that for patches
like this that move a lot of code it is beneficial to move the code "as
is". The changes could be done in a separate patches, for the ease of
review purposes. Could you please?

