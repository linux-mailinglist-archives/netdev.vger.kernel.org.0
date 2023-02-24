Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E7D6A1440
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBXATv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBXATu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:19:50 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86544A1EB
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:19:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id ay18so807889pfb.2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677197989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvkFrQLpUssnIWToC6i4nmfTd7XKXy/xow5a9zsYEpM=;
        b=PkcS5ibjc/Zzgqfyx19jF96qgcVuvPMwkiYBMhvIK8drmbeOpYR3+2Qq2Cq2pdgOya
         eg0GOi59yKcmkAPGB9mdDAlR10g/4JeI9/pZsjtIHjqIfzNgPEZUlKFzSwjV0eH+pucd
         xNCS1uWxfzIYKaw6LJYBvB+FVeDyLzKVUdf1QpUfNr2UxBhKb4dATFSQ2HK9laO8QiXG
         SFqFnHDHdevAntfAwZ+z5YRVLm+zvh7G1G9H8Cq//WhyfIw9s3PP4ADq+jDgIxdmnrPN
         xo/0BruccjeLUxZeE9HQIbtlPO1oHiy9Gez+TMAEDaHr4N/wUuKPXIPwW3yL7fKuEf/X
         Lu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677197989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvkFrQLpUssnIWToC6i4nmfTd7XKXy/xow5a9zsYEpM=;
        b=M7L1wYpLGc/0NEx1/5FWxC7IuHIXOP/m6kpIt3+OAVspziM0egtICcZZKe8ugl3IVX
         U5ggKrOG1O3xF40UVCcn2IW/mDT6fFRtSX+L+ZgkRhIK68uxgUu8X7oMAZgSGhmqmlfW
         dRq8zOhOcvZxdcC812NvEOd6zvIfOg49UcHC6d0hHwiXmtrmNqLX+lEXueTH6rSk2tuJ
         ahg+eON4EUaI/PNY0SZC3N3qelgfVe9fcy0HoWB6wbGUsdrC/21q5i54MGrWamNvHuk0
         fpqXbql42vnvz+500LctQoEkPiAsfznMRRN3xO9L0SZaRomVGD+w+84f0LcwqfdNkaf6
         IAcw==
X-Gm-Message-State: AO0yUKXeb6ohT3PsF9tPFzZwJup3wMVoiXod5YMBkPOE5G+gZdssVLiP
        zZNglMAjlKsMpRb2DqfaETA=
X-Google-Smtp-Source: AK7set/QOmqlxjUah+Myd7Skzfmh8+8gcHicOj+1uro3fwnZhcxNclffaWadFqYBgwj7OIK0t3fJ8Q==
X-Received: by 2002:a05:6a00:4006:b0:5d9:f3a6:ef8e with SMTP id by6-20020a056a00400600b005d9f3a6ef8emr5541449pfb.2.1677197989199;
        Thu, 23 Feb 2023 16:19:49 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u1-20020aa78481000000b005a8512c9988sm3875378pfn.93.2023.02.23.16.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 16:19:48 -0800 (PST)
Date:   Thu, 23 Feb 2023 16:19:46 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Matt Corallo <ntp-lists@mattcorallo.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        chrony-dev@chrony.tuxfamily.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Message-ID: <Y/gCottQVlJTKUlg@hoboy.vegasvil.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
 <Y/NGl06m04eR2PII@localhost>
 <Y/OQkNJQ6CP+FaIT@hoboy.vegasvil.org>
 <5bfd4360-2bee-80c1-2b46-84b97f5a039c@bluematt.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bfd4360-2bee-80c1-2b46-84b97f5a039c@bluematt.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 12:56:34PM -0800, Matt Corallo wrote:

> There's two separate questions here - multiple readers receiving the same
> data, and multiple readers receiving data exclusively about one channel.
> 
> I'd imagine the second is (much?) easier to implement, whereas the first is a bunch of complexity.

This second idea would require a new API, so that user could select a
particular channel.

First idea would only change kernel behavior without changing the API.

Thanks,
Richard


