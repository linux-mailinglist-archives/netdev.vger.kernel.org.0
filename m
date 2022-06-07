Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335B054236E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiFHEGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 00:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiFHEEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 00:04:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4827A3BC3D6
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 14:08:13 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q140so1969716pgq.6
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 14:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qY3ImzQmPyYp4zmTKDa1FVVD2FqPxYiHknCrVUu3peE=;
        b=1fHeTxSFwJ/XeT5fB2gPMsk7nTYPbAOD5KOafPUlw+YVonXY1hEeru5jSVEgyloZSo
         AbYaxyxJMbngsNMju0U/1sD+eTP+81jzPG1FSHuTAg4Iwnow9q8dYIiF5tQw7ghtKNU9
         T2tq9SSw0l20gE9IiFHppPH7Tmi/yGIW9zEbptL441zXWnVKa4wzCw13eQa9UET+K+YN
         u3Djy2CkG6JJvYQ6wP4dPy/LEB4DGfcklcvLp+Hh75Lj0OZwbKALni2p3m5E9dk99Vwq
         2zv9Y5g8j0YQ0t6yHWL6p5zCnArZghLUgX0nnT4nvZnBDOcAwQk/hF6nXvITnKCutLkv
         MZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qY3ImzQmPyYp4zmTKDa1FVVD2FqPxYiHknCrVUu3peE=;
        b=IIXn+zDIK+TrzXg7SFBO2GpUCAExAsMLhUUG79BMkXBmTbicEIRMHlIu6sKb4zoGzm
         5sNri+gCtkNejUDbdJZVzDAhcQqLrd/J4+FsR2hq81YViRcTt0+SPF4JCTMs12b45JQy
         yqG5Iueoq0EYRFTtLI9PZzv/EDCLGLTuOFkajv6T519p/o4x2ACcqw+x7fcRWlgnh0wT
         0MF9IInCH6vQCAWurwkD20jc8+TlaAGbqek7SspwVBVv5YBNoygwj91rqp6TW15skQDO
         i5mg1mvA2nIjm963740W5XfkUYitvFx41XIdmW6ntFuXX1zc++mbHx5N0E3boq/Cg7SD
         l6Tg==
X-Gm-Message-State: AOAM532sKF9/yX/GCa79oicgSofZrDC/XBrEUr/ImCC51ITSPmDUNayq
        AnhqqqgfN13y04tr3nr77R69Bg==
X-Google-Smtp-Source: ABdhPJxSrGveG0peDo9dsRbBs4C9v73b5hqAVfoJM/YgiesGJCsq5OKZZtnHeDiAtu1ALo9mJ1ozTg==
X-Received: by 2002:a65:6a15:0:b0:3f6:13ea:1cfb with SMTP id m21-20020a656a15000000b003f613ea1cfbmr27448127pgu.495.1654636083806;
        Tue, 07 Jun 2022 14:08:03 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z8-20020a17090a1fc800b001e0c5da6a51sm12334312pjz.50.2022.06.07.14.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 14:08:03 -0700 (PDT)
Date:   Tue, 7 Jun 2022 14:08:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>, dsahern@gmail.com,
        netdev@vger.kernel.org, tariqt@nvidia.com
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Message-ID: <20220607140800.5258250d@hermes.local>
In-Reply-To: <20220607103028.15f70be6@kernel.org>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
        <20220601234249.244701-1-kuba@kernel.org>
        <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
        <20220602094428.4464c58a@kernel.org>
        <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
        <20220603085140.26f29d80@kernel.org>
        <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
        <20220606105936.4162fe65@kernel.org>
        <21b34b86-d43b-e86a-57ec-0689a9931824@nvidia.com>
        <20220607103028.15f70be6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 10:30:28 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 7 Jun 2022 13:35:19 +0300 Maxim Mikityanskiy wrote:
> > > That'd be an acceptable compromise. Hopefully sufficiently forewarned
> > > users will mentally remove the zc_ part and still have a meaningful
> > > amount of info about what the flag does.
> > > 
> > > Any reason why we wouldn't reuse the same knob for zc sendmsg()? If we
> > > plan to reuse it we can s/sendfile/send/ to shorten the name, perhaps.    
> > 
> > We can even make it as short as zc_ro_tx in that case.  
> 
> SG
> 
> > Regarding sendmsg, I can't anticipate what knob will be used. There is 
> > MSG_ZEROCOPY which is also a candidate.  
> 
> Right, that's what I'm wondering. MSG_ZEROCOPY already has some
> restrictions on user not touching the data but technically a pure 
> TCP connection will not be broken if the data is modified. I'd lean
> towards requiring the user setting zc_ro_tx, but admittedly I don't
> have a very strong reason.
> 
> > Note that the constant in the header file has "SENDFILE" in its name, so 
> > if you want to reuse it for the future sendmsg zerocopy, we should think 
> > about renaming it in advance, before anyone starts using it. 
> > Alternatively, an alias for this constant can be added in the future.  
> 
> Would be good to rename it to whatever we settle for on the iproute2
> side. Are we going with zc_ro_tx, then?

Works for me
