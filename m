Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9693B55FD3A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiF2K0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiF2K0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:26:00 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572C632EDA
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:25:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id q6so31544936eji.13
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sBJdrlguIXhimT4JZ53Dob2yg/bXuqOE77iYKfnTPKs=;
        b=eoLLeh5w0sTfWv7/+jqxYAHniRIjcEhuR9jwHAVXrbUFAmUG5gSHLIagiWkFD5K1mx
         9FHdnmwpCCIApEB8vVg01sJEsrrnRjCE+uk39L9GOfsSJXSTtMrN2cPf8t0A1V8CgyBE
         i/dZExpsSe3wwrFFB2wUaqgpcpVWajCCZOlJSgm2GJ6eHphT4uLweGsKqsQnuBc5vV7B
         5jJ5O89xRRLCiSw72RXCYU5C3950QGqPDsaVUG6x+8BQvv8038o9nbpSA542FlJPSNg4
         jQrpYROw01wTMuBy0+YE/Xco5e3KVaqJquJkNaJatSeZT7wvK5kl3U/TLfR7u1DCO07G
         AACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sBJdrlguIXhimT4JZ53Dob2yg/bXuqOE77iYKfnTPKs=;
        b=RjHVo+smiIVXEeiw3rXW2CHuodfOkF84jLorsYNZoxkQkHABOIjOIwfkRzwzaS/cc0
         D4bLn/Zm0V8Hog+8d1dd34O0UN4tLsLCvY+bxvpPDPS0B2AAbHlvHy6tJUapsFKzNF10
         qhy1VG1VA4Krdr/NDs71vfic1wXU08bxB3pmbKW+rlbeouAEJxmfRHoPv8u9gDKjpsu+
         vWGi1F8TmcDXUzSw1tPcUV2Nu1Vo5515Ua3SDYnO2ArEgLwcdvFzAjFYBkCXX1qnRydW
         DBdALjkW+2lTu+3QwW2TA8eUsa9LZjPZgw9xz3KkuIaxqg4iqllAQrxccs++gDRb91zY
         6RDw==
X-Gm-Message-State: AJIora8OGb07rCxjWuGXCJUPQKrVyKdZR4cfduI1bigGLZCJr4E13pnW
        ohBu3Q0Fw01u60qnW/BD2pajgP3rG3lbDNtbRtI=
X-Google-Smtp-Source: AGRyM1v4D5U5sRiwcOhBYscA260PSi2WJ9EINaGy0aZaSfMf0QdKN9m/7IHl8qSWXXn9IqsrmGs/ag==
X-Received: by 2002:a17:906:4fc6:b0:722:e730:2355 with SMTP id i6-20020a1709064fc600b00722e7302355mr2596397ejw.50.1656498350735;
        Wed, 29 Jun 2022 03:25:50 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id jz2-20020a170906bb0200b00726314d0655sm7577368ejb.39.2022.06.29.03.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 03:25:50 -0700 (PDT)
Date:   Wed, 29 Jun 2022 12:25:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <YrworZb5yNdnMFDI@nanopsycho>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <YrnS2tcgyI9Aqe+b@nanopsycho>
 <YrqxHpvSuEkc45uM@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrqxHpvSuEkc45uM@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 28, 2022 at 09:43:26AM CEST, idosch@nvidia.com wrote:
>On Mon, Jun 27, 2022 at 05:55:06PM +0200, Jiri Pirko wrote:
>> Mon, Jun 27, 2022 at 05:41:31PM CEST, idosch@nvidia.com wrote:
>> >On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> This is an attempt to remove use of devlink_mutex. This is a global lock
>> >> taken for every user command. That causes that long operations performed
>> >> on one devlink instance (like flash update) are blocking other
>> >> operations on different instances.
>> >
>> >This patchset is supposed to prevent one devlink instance from blocking
>> >another? Devlink does not enable "parallel_ops", which means that the
>> >generic netlink mutex is serializing all user space operations. AFAICT,
>> >this series does not enable "parallel_ops", so I'm not sure what
>> >difference the removal of the devlink mutex makes.
>> 
>> You are correct, that is missing. For me, as a side effect this patchset
>> resolved the deadlock for LC auxdev you pointed out. That was my
>> motivation for this patchset :)
>
>Given that devlink does not enable "parallel_ops" and that the generic
>netlink mutex is held throughout all callbacks, what prevents you from
>simply dropping the devlink mutex now? IOW, why can't this series be
>patch #1 and another patch that removes the devlink mutex?

Yep, I think you are correct. We are currently working with Moshe on
conversion of commands that does not late devlink->lock (like health
reporters and reload) to take devlink->lock. Once we have that, we can
enable parallel_ops.

>
>> 
>> 
>> >
>> >The devlink mutex (in accordance with the comment above it) serializes
>> >all user space operations and accesses to the devlink devices list. This
>> >resulted in a AA deadlock in the previous submission because we had a
>> >flow where a user space operation (which acquires this mutex) also tries
>> >to register / unregister a nested devlink instance which also tries to
>> >acquire the mutex.
>> >
>> >As long as devlink does not implement "parallel_ops", it seems that the
>> >devlink mutex can be reduced to only serializing accesses to the devlink
>> >devices list, thereby eliminating the deadlock.
>> >
>> >> 
>> >> The first patch makes sure that the xarray that holds devlink pointers
>> >> is possible to be safely iterated.
>> >> 
>> >> The second patch moves the user command mutex to be per-devlink.
>> >> 
>> >> Jiri Pirko (2):
>> >>   net: devlink: make sure that devlink_try_get() works with valid
>> >>     pointer during xarray iteration
>> >>   net: devlink: replace devlink_mutex by per-devlink lock
>> >> 
>> >>  net/core/devlink.c | 256 ++++++++++++++++++++++++++++-----------------
>> >>  1 file changed, 161 insertions(+), 95 deletions(-)
>> >> 
>> >> -- 
>> >> 2.35.3
>> >> 
