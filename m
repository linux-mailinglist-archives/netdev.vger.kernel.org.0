Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943DD69E07C
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbjBUMeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbjBUMeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:34:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2EB1ABEC
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:34:03 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s26so16528503edw.11
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CBgfU7a+u79RtdIPkCV80+YnjKAPWjyKxwIOdQ5p4/8=;
        b=22JfREWzxahssIhjysUhfxHESmv1d9UzRuGdnNETsamKWRPG5D0bmiycmcD4xaJWPD
         wkhVxv6kKs1SQ539AFNYxMDvkSLYZHvYEQu9UTjA0vc2kIASuKLT/SRkwLP4OkEcKOlh
         pMIF8dAE2ZXo28PZRRV2HRyx5ZLlj+V21sBwB2EB+cQyqzkVCVxi20r9lGJ8T9wixmHA
         xs9+XkY+CxEijgP2obonPGLs6adFlLaVqLe9lzu2Nu14l3IYdTYqmTgPeKkcrfDS4jep
         qAVLhTh8TN3HSLNDJUt8PZ0eVFugHXJeVzh1pOTsqWP21CgzWZawnGKg90YoS29rMP3Z
         kTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CBgfU7a+u79RtdIPkCV80+YnjKAPWjyKxwIOdQ5p4/8=;
        b=jigiIlOSQL/5Nap56LiLY5sfrMOPnA+fGaLD7IQbGqa7GB+GTJE0+VDcwq8EdlwSqS
         LVAu0leE0KmcS0LxkA37aNDiTdcie8F+QIZhU83qeTn72e9kg5ver5PsWArvwqevjy0/
         mVh5hVqT2a8binAiwAi4gdJnLpUhxB1xoluSsyZGgQaRR1LxnwMZR8t3e6us0EvgRnjb
         7WhPbRy3u/RpMtWqe6lPgHe9Xem6oOaAgbMDt05FnhohmmYiRrU6ayGNYq7xS5URWZEF
         nh5ivgy+l2S6K3m/sA98+FLP+MhmjwcYH/NBC2gXLT1myLHBbJr6ptRKmxl6clr+51y+
         Rdcg==
X-Gm-Message-State: AO0yUKViSPz00zxRK+HOEwUpNw5GAtqBV2vEwulelJ4ZO36uazsB3+hz
        5GdUGecz7n7R2DtAE80Zy+VaRg==
X-Google-Smtp-Source: AK7set+75A6m+9w7v5T2CaUXm/CZ42a2/JF9JwJW4yJhgY9dn9hAz2rGpd59uctMQBw7ysf1swIDTg==
X-Received: by 2002:a17:906:3bc4:b0:8b1:7a80:e13c with SMTP id v4-20020a1709063bc400b008b17a80e13cmr15914774ejf.31.1676982841591;
        Tue, 21 Feb 2023 04:34:01 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n10-20020a170906164a00b008d593a3e6desm2322990ejd.100.2023.02.21.04.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 04:34:00 -0800 (PST)
Date:   Tue, 21 Feb 2023 13:33:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
Subject: Re: [PATCH v3 net-next 01/14] devlink: add enable_migration parameter
Message-ID: <Y/S6N6pcbHSFdj11@nanopsycho>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <20230217225558.19837-2-shannon.nelson@amd.com>
 <Y/Mtr6hmSOy9xDGg@nanopsycho>
 <98cd205b-fabe-a2ee-e9c0-51e269b78976@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98cd205b-fabe-a2ee-e9c0-51e269b78976@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 21, 2023 at 12:54:25AM CET, shannon.nelson@amd.com wrote:
>On 2/20/23 12:22 AM, Jiri Pirko wrote:
>> Fri, Feb 17, 2023 at 11:55:45PM CET, shannon.nelson@amd.com wrote:
>> > Add a new device generic parameter to enable/disable support
>> > for live migration in the devlink device.  This is intended
>> > primarily for a core device that supports other ports/VFs/SFs.
>> > Those dependent ports may need their own migratable parameter
>> > for individual enable/disable control.
>> > 
>> > Examples:
>> >   $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
>> >   $ devlink dev param show pci/0000:07:00.0 name enable_migration
>> >   pci/0000:07:00.0:
>> >     name enable_migration type generic
>> >       values:
>> >         cmode runtime value true
>> > 
>> > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> 
>> Could you please elaborate why exactly is this needed?
>> 
>>  From my perspective, the migration capability is something that
>> is related to the actual function (VF/SF).
>> 
>> When instantiating/configuring SF/VF, the admin ask for the particular
>> function to support live migration. We have port function caps now,
>> which is exactly where this makes sense.
>> 
>> See DEVLINK_PORT_FN_CAP_MIGRATABLE.
>
>Hi Jiri,
>
>Thanks for your questions.  My apologies for not getting your name into the
>To: list – a late Friday afternoon miss.
>
>This enable_migration flag is intended to be similar to the enable_vnet,
>enable_rdma, and similar existing parameters that are used by other core
>devices.
>
>Our pds_core device can be used to support several features (currently VFio
>and vDPA), and this gives the user a way to control how many of the features
>are made available in any particular configuration.  This is to be enabled to
>turn on support for our pds_vfio client devices as a whole, not individually
>port-by-port.  I understand FN_CAP_MIGRATABLE to be applied to an individual
>devlink port, which could be used in conjunction with this once the general
>feature is enable in pds_core.

Okay, that sounds legit. Could yout please extend the patch description
with this? Thanks!


>
>Thanks,
>sln
