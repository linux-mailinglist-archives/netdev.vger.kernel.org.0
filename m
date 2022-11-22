Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D162633E34
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiKVNzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiKVNzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:55:36 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9853B67100
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:55:33 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id m22so35888293eji.10
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=znEYND3R8gRjt5grUY0ed5IUooGRYzQrLxP38EycadY=;
        b=Zsy0iIcw+5xXgIIv+cuYllqwetduB0TXXRBek5uTr/vtDQa8EXpJ2Tu+399FUR35++
         1hJTb4Hr5SJyxicG1WSK97cSPQEjIBQPodUXGfRWSFNrwiPlPy7+5QECyJ/cxhlmH0PB
         iEY2SOUcKjcAUf8Hc2qQNXrGRAErN6OrZ27iKykoxNKaayVjrfKAKGSnm7rLx9VnQFcC
         GAlMhG69OC9Ll27lpLFfjZmi0bv3sBsxgUsQQJAjhE12eKWnd9y8OVK1ZOyZRQ7Fzh9h
         8aYM8UjM2DXut5/6f1H6dA8M84Mkz0/DhF3qEgRLnEYltN7MVoJtkIquAfdEMZG10/0F
         AU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znEYND3R8gRjt5grUY0ed5IUooGRYzQrLxP38EycadY=;
        b=F2Y3arbun/ZmmZG9S3N6mVzKW69+8QJp3+kapumEDagZFmNIR+GDuvWNMpfDduTsvU
         4YwTkxgtsIRWlLAsArhYluiJ2l8xtfKoUh3yKVRC9HLYqJYeP6MOvsNFdjcZtGzYRlrr
         1RNVXiuXCUuecX6pcpYifCxWnx4SjkWL2wmYrtRVc/xRIQKWrKilf74NeLBCo5r+mc3m
         sZcEV64OCOLsTWtTF2YK4VhTYtlZlKqiX2ZYGqz8am/rJkK9y6cKPleWaxJo78/vcajd
         vTGNI/beJxxOs8JnMTwhVNF2WSnTZ5CP5Ij5zr0T6403C73xyMb8LdFALngKpisfK6L4
         trGQ==
X-Gm-Message-State: ANoB5pkddHMTRn/zLEqc3SsS3m0zuE+U4/30Jfgwy1qwhtNdXBjZJqJb
        9A1ldc3giXXLiMaTqLmr0gM=
X-Google-Smtp-Source: AA0mqf679G6XRrT6Z9h3bVHnIage3/YfZWNq6qikdc7880sSvhLu+Id9MdkCjc0NPZAqgNMcjVwHyg==
X-Received: by 2002:a17:906:b04:b0:7ad:e1d6:280b with SMTP id u4-20020a1709060b0400b007ade1d6280bmr19445225ejg.512.1669125331992;
        Tue, 22 Nov 2022 05:55:31 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id s9-20020a1709064d8900b007ad9c826d75sm6094480eju.61.2022.11.22.05.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 05:55:31 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:55:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Steve Williams <steve.williams@getcruise.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <20221122135529.u2sq7qsrgrhddz6u@skbuf>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <Y3zFYh55h7y/TQXB@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3zFYh55h7y/TQXB@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Tue, Nov 22, 2022 at 01:49:38PM +0100, Jiri Pirko wrote:
> Sat, Nov 19, 2022 at 12:26:39AM CET, steve.williams@getcruise.com wrote:
> >This is a virtual device that implements support for 802.1cb R-TAGS
> >and duplication and deduplication. The hanic nic itself is not a device,
> >but enlists ethernet nics to act as parties in a high-availability
> >link. Outbound packets are duplicated and tagged with R-TAGs, then
> >set out the enlisted links. Inbound packets with R-TAGs have their
> >R-TAGs removed, and duplicates are dropped to complete the link. The
> >algorithm handles links being completely disconnected, sporadic packet
> >loss, and out-of-order arrivals.
> >
> >To the extent possible, the link is self-configuring: It detects and
> >brings up streams as R-TAG'ed packets are detected, and creates streams
> >for outbound packets unless explicitly filtered to skip tagging.
> >---
> > Documentation/networking/hanic.rst |  351 ++++++++++
> > Documentation/networking/index.rst |    1 +
> > MAINTAINERS                        |    6 +
> > drivers/net/Kconfig                |   17 +
> > drivers/net/Makefile               |    1 +
> > drivers/net/hanic/Makefile         |   15 +
> > drivers/net/hanic/hanic_dev.c      | 1006 ++++++++++++++++++++++++++++
> > drivers/net/hanic/hanic_filter.c   |  172 +++++
> > drivers/net/hanic/hanic_main.c     |  109 +++
> > drivers/net/hanic/hanic_netns.c    |   58 ++
> > drivers/net/hanic/hanic_priv.h     |  408 +++++++++++
> > drivers/net/hanic/hanic_protocol.c |  350 ++++++++++
> > drivers/net/hanic/hanic_streams.c  |  161 +++++
> > drivers/net/hanic/hanic_sysfs.c    |  672 +++++++++++++++++++
> > 14 files changed, 3327 insertions(+)
> 
> Leaving aside issues I spotted looking at random parts of the code (like
> checking if kernel version is >5 :O), why this has to be another
> master-slave device? From the first look, I think this could be
> implemented as a bond/team mode. You would save a lot of plumbing code
> and ease up the maintainance burden. Did you consider that option?
> Any particular arguments against that approach?

Neither bond nor team have forwarding between ports built in, right?
Forwarding is pretty fundamental to 802.1CB (at least to the use cases
I know of).
