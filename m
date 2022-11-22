Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C9D633CDE
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiKVMtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiKVMtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:49:43 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3236069C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:49:41 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o7-20020a05600c510700b003cffc0b3374so11031108wms.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=POPR7qukQ/DjQHMQKLZKpi0Jml0a26N0TL7Y9AV0X3M=;
        b=7AwY2vr3f/zMxmabbdXtSXMQgRq9aMY1Zx/4nrN3nASMdJokFycRoF/xxJcdYBXFhY
         wSgiDzjS1GVYZCrMnpEdxfHt5XUXcBxGFoGyNjbfXzVFWEBHbMcdcCGRCue72pkG881I
         rePukINYwgd1odIxe5UdjmllxHsV0sQP3bJYxdOo9zwLwtO30MB+7SC2WLLd9Tf9NnR2
         JqMkO7kBZB9vCpbJTpFIhl1ESjnCxw9Cf/3q67HKydVzkMBCevV9bPw2KRWHNU0hzfXS
         S+G0hScGeTe6Z7lMKXUd8ifWdZ0J51l4SQE46xd2NggBOeLFXfctwD/93tSfxtZ2zmkN
         XnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POPR7qukQ/DjQHMQKLZKpi0Jml0a26N0TL7Y9AV0X3M=;
        b=g2voVFu0grtEsMC+eU3PP2f6Z3/TOYTjOhPPurG4msImJEDLIMo02SBM8ANspOfoIk
         /R0hQDWPlYcjqHDKHhUx19+LrBCRDh2m9H1HLRsnO8stsifc2t9MoZjGhdEWCCbKomfv
         J3lmBhENNxGvjCdju8dhESADfZJV3KbgBjh4iPS5CY3qBye5vrgL/DjVK7Znd4IOAok0
         4wu3htl+8SghoeYjzpdbqnLenNfGvzh+a0WWVoFSxZeFUGoSJ8jIr2RH3xsNUQIQC7hY
         Qd5yTabF02vaFkzhRYKqueV0RyTzv15kDd/shRCNhnCOY1ZmzTpU6UPdcLisiTYCRHll
         SNuw==
X-Gm-Message-State: ANoB5pnQlrBiy/Rs+967usJvsfLcgIuTg4fHsnVPM2bhhs/NLzMkaOZk
        /v7mgTHt8b6ILPjUhp8kFbe3rw==
X-Google-Smtp-Source: AA0mqf4bBBcCsxdruVgdyBXo6VyPvbq5eHFEN8LH9dhK28gNjhfMfQfraM6ioxNLgOn5DBZKLK1Gww==
X-Received: by 2002:a05:600c:3421:b0:3cf:ac8a:d43e with SMTP id y33-20020a05600c342100b003cfac8ad43emr5141421wmp.65.1669121380068;
        Tue, 22 Nov 2022 04:49:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j39-20020a05600c1c2700b003cf57329221sm23694197wms.14.2022.11.22.04.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 04:49:39 -0800 (PST)
Date:   Tue, 22 Nov 2022 13:49:38 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <Y3zFYh55h7y/TQXB@nanopsycho>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118232639.13743-1-steve.williams@getcruise.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Nov 19, 2022 at 12:26:39AM CET, steve.williams@getcruise.com wrote:
>This is a virtual device that implements support for 802.1cb R-TAGS
>and duplication and deduplication. The hanic nic itself is not a device,
>but enlists ethernet nics to act as parties in a high-availability
>link. Outbound packets are duplicated and tagged with R-TAGs, then
>set out the enlisted links. Inbound packets with R-TAGs have their
>R-TAGs removed, and duplicates are dropped to complete the link. The
>algorithm handles links being completely disconnected, sporadic packet
>loss, and out-of-order arrivals.
>
>To the extent possible, the link is self-configuring: It detects and
>brings up streams as R-TAG'ed packets are detected, and creates streams
>for outbound packets unless explicitly filtered to skip tagging.
>---
> Documentation/networking/hanic.rst |  351 ++++++++++
> Documentation/networking/index.rst |    1 +
> MAINTAINERS                        |    6 +
> drivers/net/Kconfig                |   17 +
> drivers/net/Makefile               |    1 +
> drivers/net/hanic/Makefile         |   15 +
> drivers/net/hanic/hanic_dev.c      | 1006 ++++++++++++++++++++++++++++
> drivers/net/hanic/hanic_filter.c   |  172 +++++
> drivers/net/hanic/hanic_main.c     |  109 +++
> drivers/net/hanic/hanic_netns.c    |   58 ++
> drivers/net/hanic/hanic_priv.h     |  408 +++++++++++
> drivers/net/hanic/hanic_protocol.c |  350 ++++++++++
> drivers/net/hanic/hanic_streams.c  |  161 +++++
> drivers/net/hanic/hanic_sysfs.c    |  672 +++++++++++++++++++
> 14 files changed, 3327 insertions(+)

Leaving aside issues I spotted looking at random parts of the code (like
checking if kernel version is >5 :O), why this has to be another
master-slave device? From the first look, I think this could be
implemented as a bond/team mode. You would save a lot of plumbing code
and ease up the maintainance burden. Did you consider that option?
Any particular arguments against that approach?

Thanks!

