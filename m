Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC80633E7D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiKVOIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiKVOHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:07:45 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB5B6A77E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:06:11 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n20so36168366ejh.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJ+Iu/M8Q5Vbwtp2sXztJirh2XwjE+69oLWtoHeO11E=;
        b=eP7V9j7B46L2SoL1CiuPeW42uQthvSS+jUsqt5Bk+XRd6tpC4HVAndPS6DfxBl5hkx
         pptX/k7zr16v4uFdbHftZK6pZmoUHyJ2fSoWG5knJYNVSj96RrhAN6HLjAzWcDRNPOeO
         f5W0U9EgImGkz6MvYc8vNTFTONE2dHt2uvKmgHtEecx48d8td4xZksyXyRxkMhM1ismW
         ic2+CMZd4OPmSWsCUY2NKrhUWLCNvEI6LLJpWBNobQGf2kAkIL0TFomVLLdY6cXo/bLx
         +PKL8jyhHNHzcpl509cry9M+2vUnrfqE0+7F6THGs/sNZhid+9UnGI675woKCX2uTHfW
         1Weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJ+Iu/M8Q5Vbwtp2sXztJirh2XwjE+69oLWtoHeO11E=;
        b=yi9fsqlIj8zQRQxa7hHY/AJVnWp+bj0pYwTUXbE7ryJ4TC16vdyLZZO8bOvUNnqDvT
         Iyj/oimg8TKTX1H9JQcocuVax8m+9Y+SWWP4mvwYB8HzEZ4FNev9WzbXBGPq1rTQekeB
         dtsfql1vg2bqEGC/6WKZd8hQgRdnK9NOAy1am7CDvHp4NbPAUH+VbrwcI8O4cdhn7jab
         0HMO9nFyUMTZeVtRDemc8ZONBPsqnnZ8wMHMRQ/hkg5Rx+v1LvlsFN3VESidRFFaSBnj
         zEmnT4lyg0V6Rumt09Zw5HKaTvqCzCDeW/RiZIXVnOHbyiVOIdHptrNQ1osjeBqi6W6A
         gKgQ==
X-Gm-Message-State: ANoB5pnW9axATi7SIqQNG2O8qrNNzbWF5e8Jr6h00J8NXc/vQ4einy6m
        MTFV5YlckNp322HO4ZemeCDNfT/1syCQnNmO
X-Google-Smtp-Source: AA0mqf4aq29aCS8FoRfXidJG16PA3VzSZYsn4KLEOzCR9dGRSBRFOfoAVmXAs+IHraNCRf3wmTpsOA==
X-Received: by 2002:a17:906:3a10:b0:7a4:22c4:ade7 with SMTP id z16-20020a1709063a1000b007a422c4ade7mr20289986eje.722.1669125969682;
        Tue, 22 Nov 2022 06:06:09 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c24-20020a056402101800b00458b41d9460sm6317852edu.92.2022.11.22.06.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:06:09 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:06:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Steve Williams <steve.williams@getcruise.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <Y3zXT3SmTEwjQ7y6@nanopsycho>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <Y3zFYh55h7y/TQXB@nanopsycho>
 <20221122135529.u2sq7qsrgrhddz6u@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122135529.u2sq7qsrgrhddz6u@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 22, 2022 at 02:55:29PM CET, olteanv@gmail.com wrote:
>Hi Jiri,
>
>On Tue, Nov 22, 2022 at 01:49:38PM +0100, Jiri Pirko wrote:
>> Sat, Nov 19, 2022 at 12:26:39AM CET, steve.williams@getcruise.com wrote:
>> >This is a virtual device that implements support for 802.1cb R-TAGS
>> >and duplication and deduplication. The hanic nic itself is not a device,
>> >but enlists ethernet nics to act as parties in a high-availability
>> >link. Outbound packets are duplicated and tagged with R-TAGs, then
>> >set out the enlisted links. Inbound packets with R-TAGs have their
>> >R-TAGs removed, and duplicates are dropped to complete the link. The
>> >algorithm handles links being completely disconnected, sporadic packet
>> >loss, and out-of-order arrivals.
>> >
>> >To the extent possible, the link is self-configuring: It detects and
>> >brings up streams as R-TAG'ed packets are detected, and creates streams
>> >for outbound packets unless explicitly filtered to skip tagging.
>> >---
>> > Documentation/networking/hanic.rst |  351 ++++++++++
>> > Documentation/networking/index.rst |    1 +
>> > MAINTAINERS                        |    6 +
>> > drivers/net/Kconfig                |   17 +
>> > drivers/net/Makefile               |    1 +
>> > drivers/net/hanic/Makefile         |   15 +
>> > drivers/net/hanic/hanic_dev.c      | 1006 ++++++++++++++++++++++++++++
>> > drivers/net/hanic/hanic_filter.c   |  172 +++++
>> > drivers/net/hanic/hanic_main.c     |  109 +++
>> > drivers/net/hanic/hanic_netns.c    |   58 ++
>> > drivers/net/hanic/hanic_priv.h     |  408 +++++++++++
>> > drivers/net/hanic/hanic_protocol.c |  350 ++++++++++
>> > drivers/net/hanic/hanic_streams.c  |  161 +++++
>> > drivers/net/hanic/hanic_sysfs.c    |  672 +++++++++++++++++++
>> > 14 files changed, 3327 insertions(+)
>> 
>> Leaving aside issues I spotted looking at random parts of the code (like
>> checking if kernel version is >5 :O), why this has to be another
>> master-slave device? From the first look, I think this could be
>> implemented as a bond/team mode. You would save a lot of plumbing code
>> and ease up the maintainance burden. Did you consider that option?
>> Any particular arguments against that approach?
>
>Neither bond nor team have forwarding between ports built in, right?
>Forwarding is pretty fundamental to 802.1CB (at least to the use cases
>I know of).

I don't see any forwarding in this patch. How is it supposed to be
working, I wonder...

