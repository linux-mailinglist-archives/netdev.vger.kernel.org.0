Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBAA4CEC4B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 17:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiCFQyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiCFQyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 11:54:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF8C3EA93
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 08:53:12 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n2so2326506plf.4
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 08:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=81Aog7kzg9rWQPWFOdI/fSz+26Yu/0EbK/uqmA0eSmo=;
        b=cIjjPV5op/Nh1bsv6HUJkkZSKwAhvSRIBkGT2WE42A3jkxk0LQK46YFO7CSrUlZaNo
         J+eC9WR/Qyf7aoncBdfTU3xi7DxA8dM/LBnW3em1PONtcj2Ud9EY2SnVSDAunlAz6n6y
         V2sIKbBeuWa1xqbkFTLey/vqSR5WAPt4XRiAYY336YBZ6OT5arcOGxK/kvoHhhre0yJx
         nR1v14UtuyWaV5MVYbZ7LSLQGvBtMWQfJGFgDf6FvnWsfvRDKQbMqMxc4bxyCCi3fA5W
         bdMD2iE0u1fhPuDvFTy5dKrtSfWkdHsoxIaOZ7n54UQAayV/dumfc30pQsFapjrQ6LpF
         fdkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=81Aog7kzg9rWQPWFOdI/fSz+26Yu/0EbK/uqmA0eSmo=;
        b=cPFrwlZKukP6LGxSYq4GW8zyi+hzIf8dIjhzZwrMMk7Ag9VHuSxPniHLASNURSD+Cv
         UnCDUod0fMVQ/uEsGIRaTXZSbv1PZaJ915h8ZHVzyRqbe3RLmqVbSib2vv70efBpU+Zt
         Nebp2uWZrVbhxu86VC0sKvntnh/2pRbhKdDgcBknL2K897bQD/FLBMaDfjjR7Sov36Se
         sNTGi66vx0odfSzeyOqlwTRj1DFv/3H1QWYprLS0tq7QV2TE7PTyG8wp/JSbOVgSMRff
         nbG83MMSmAm41/mGYqQLIrai2D7ShtVq9WijXMjToVhXrU0NGpHzfCG8k9KglPT0g5Nz
         ZPxw==
X-Gm-Message-State: AOAM533elEvXSZVfBRUqUmwcvAP+NU5ojsOeZdcn6UZ5+5tCt9mdkCrf
        OA7tM7X8HSPIQNELpSK/dEo=
X-Google-Smtp-Source: ABdhPJxJo7bpybqqEY+ZJpKuYAkLrKU2YB23mOK2E4bJhJ9HPfeDEuSMry5kb1STc7iMSAeZwkZjpw==
X-Received: by 2002:a17:90a:408d:b0:1bf:610b:6209 with SMTP id l13-20020a17090a408d00b001bf610b6209mr1640956pjg.194.1646585591545;
        Sun, 06 Mar 2022 08:53:11 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004f38e426e3csm12671314pfw.201.2022.03.06.08.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 08:53:11 -0800 (PST)
Date:   Sun, 6 Mar 2022 08:53:08 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220306165308.GD6290@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306164941.GC6290@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306164941.GC6290@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 08:49:41AM -0800, Richard Cochran wrote:
> On Sun, Mar 06, 2022 at 09:56:52AM +0100, Gerhard Engleder wrote:
> 
> > If hardware would support a free running time additionally to the
> > physical clock, then the physical clock does not need to be forced to
> > free running. Thus, the physical clocks can still be synchronized while
> > vclocks are in use.
> 
> So... the HW must provide frame time stamps using the one clock and
> ancillary operations using the other, right?

Looking at your tsnep driver, the requirement is that the HW provide
each frame with TWO time stamps, one from each clock.
 
Thanks,
Richard
