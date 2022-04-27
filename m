Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C02511049
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 06:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357730AbiD0Eu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 00:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357725AbiD0Eu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:50:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF873980C
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 21:47:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id r9so461806pjo.5
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 21:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YdgqxKt9Gi9rR3MxX+vibY44XckmnBGLVJU1aHbVlWo=;
        b=BOhXyZv0SXem27DUXpQXzgNywPPpIgrD6Aps2Tz7fAFU7Wx2QyM23JrEsmis5um2bY
         csTLwYjZ32elSsNpWxvaiZDGiYNESFeCNQCmtlwFG2DG7z/gbVfzwcsKm1Qa/94Q8+Xh
         BUaviqUJG+zBCIVTFkhADFMyyAOwV4yz/+YRML36Ge8zCJsmljWM7w17XN1T97QxaAgD
         HALWL1mvkJ08qAKj1NN/OkygrlbtGmV6YFIKUW8K+WFyAp7Ma8WUvO/K+7dGGAXFrUtf
         YF2r537EMqPxM8UumaFZcAYz9Am7PV4eJ3gD9jfFL9eyDeccP7AvonNTotmPQ3N8YKyz
         GpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YdgqxKt9Gi9rR3MxX+vibY44XckmnBGLVJU1aHbVlWo=;
        b=54iu1to3t7wcSO15vWO8rOKVqX0szFtKcGgPErejjxSQUhqvfw8VV3dB7H5rSnpY/y
         xOdmujvt+KWjmoeylgP5GRiAfkRAq366ELanQOnvqtm8o8uIax58v91ttlJnruquSm5R
         rzFnXGk9oYL4sSOBKcex+jj/xSNUQSk4HO9g8JlqY5CZE7ZLpfQNjqvEwb3iXWmo7Bmo
         YtqjegXDU0+CPz/svuwqD1RUzcB6jAKFjjs8kjLl487HKt1/nWY806qGHWmXCNjG+Hz5
         VrWHb4WV/YNkd90s90Q2CABZBhIAVoYA93n9ntptYiyJNZRvoJPXHIT9vL0rnbIFS0fe
         mlcw==
X-Gm-Message-State: AOAM5311GFh9QgjM+WAnH2vV77pJ3IA/QaV1oOSRac43GJZsM8ijFhF+
        t6hh5Aw2d/3aTaFNOJ1Aop8=
X-Google-Smtp-Source: ABdhPJyzC9wSwDu/lFC6/f/jYGaD/Yf9KZ24gEWDKonFL4OnFcN0VhwBM2iY20z+wfbC8c2UzK/Fyg==
X-Received: by 2002:a17:903:2443:b0:15d:422a:d596 with SMTP id l3-20020a170903244300b0015d422ad596mr4923399pls.160.1651034868241;
        Tue, 26 Apr 2022 21:47:48 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id e15-20020a63ae4f000000b003995a4ce0aasm14427850pgp.22.2022.04.26.21.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 21:47:47 -0700 (PDT)
Date:   Wed, 27 Apr 2022 13:47:45 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 03/28] sfc: Copy shared files needed for Siena
Message-ID: <YmjK8Uq+rM96GRpx@d3>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
 <165063946292.27138.5733728538967332821.stgit@palantir17.mph.net>
 <20220423065007.7a103878@kernel.org>
 <20220425072257.sfsmelc42favw2th@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425072257.sfsmelc42favw2th@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-25 08:22 +0100, Martin Habets wrote:
> On Sat, Apr 23, 2022 at 06:50:07AM -0700, Jakub Kicinski wrote:
> > On Fri, 22 Apr 2022 15:57:43 +0100 Martin Habets wrote:
> > > From: Martin Habets <martinh@xilinx.com>
> > > 
> > > No changes are done, those will be done with subsequent commits.
> > 
> > This ginormous patch does not make it thru the mail systems.
> > I'm guessing there is a (perfectly reasonable) 1MB limit somewhere.
> 
> I think the issue is with mcdi_pcol.h, which is 1.1MB of defines
> generated from the hardware databases. It has grown slowely over the
> years.
> I'll split up this patch and see if I can manually cut down mcdi_pcol.h.
> 

In this case, by using `git format-patch --find-copies-harder [...]` it
greatly reduces the size of patch 03 from 1.9M to 22K and makes the
actual changes easier to spot as well:

[...]
 .../net/ethernet/sfc/{ => siena}/bitfield.h   |   0
 drivers/net/ethernet/sfc/{ => siena}/efx.c    |   0
 drivers/net/ethernet/sfc/{ => siena}/efx.h    |   0
 .../ethernet/sfc/{ => siena}/efx_channels.c   | 148 ++++++++----------
 .../ethernet/sfc/{ => siena}/efx_channels.h   |   0
 .../net/ethernet/sfc/{ => siena}/efx_common.c |   0
 .../net/ethernet/sfc/{ => siena}/efx_common.h |   0

That being said, I don't want to discourage you from doing that rework!
