Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137D7645AF7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiLGNcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLGNcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:32:09 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C55759870
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:32:08 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v8so24925897edi.3
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MnMxbTORl3Ht2GdWNTLQiVpNmVZf/Y2cHiB9nizEbNk=;
        b=AEpP6t1Ulo4kTg0Vvb/yTqy93nVxNyfd3W8lH1ERLGZVqzjGr1lLUIXfKeyZl7vZM+
         spkuofqI39Ue/IUv4TtbXNIhmQ/hZTEACZpj9jFYy/Oc5hRsmIDljV0gTr2sICvpRuTK
         XOS5pXko3rJSKNEF7AhJuGaj2itr/QOLGDrNSbYHAsJLS1+ksd5kR6zSlIm02+XUXODw
         ZWwDVzX755GNlwB/XI+ILspv94CzvtUVp0wdhaLkpWzbMqX5ROMEaevAgvZHuoEkRmLK
         S+DhbB9MSiX0VxKo9WclAj//XryZA1/CIG7O9vnOLCgM38ajNwTBbVgb5foffwbWCajR
         f5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnMxbTORl3Ht2GdWNTLQiVpNmVZf/Y2cHiB9nizEbNk=;
        b=WI2H4wQj7Y4cI5ik4O3XwFGn4qIs/Vu0fQoMqn1sH3D+/UyDB0F1/6momfjLfYqdMN
         sBH1TkMIVz4Z1hAJ5s3xAnfuWbyohhqibB32XiAvML15CR6Pt4Pp+tBJiFRJPGZTAJEW
         ecsQU1e3budpvw2vE4ON0aikuz4uazVd86P4ZL8nqw4sxQARnwN8hKDQI2zsydhb2LoV
         Rih6RXoV+BMzg6y2xgYIS94Q7rFdZjE9/PifzK61M/6MS4n3G0IYRqUHhT/bZIGjOwV0
         52ixGBxZhz7hGBHI0c9I9ce7RDxED1rfLMbabRGVFNnL89Yf+vsTsDIZ08ZroyUKnpMa
         IYMQ==
X-Gm-Message-State: ANoB5pm2wEW9rqS9/h+L2AQ3DCXvtHIWCEHMPgSNdFYFUpMT5vk20jrU
        dlfAqbZAfEAbWhV7rycBCtFRPQ==
X-Google-Smtp-Source: AA0mqf6zBDiJHn0os2aKyMfZiK08U4cf9zxHAsGC7+50RhlJtUEeGjyW0czFy3pCbsaZR5F/ltdLcg==
X-Received: by 2002:a05:6402:3789:b0:467:7664:c7f4 with SMTP id et9-20020a056402378900b004677664c7f4mr1776049edb.99.1670419926928;
        Wed, 07 Dec 2022 05:32:06 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v24-20020a056402175800b0046182b3ad46sm2212337edx.20.2022.12.07.05.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:32:06 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:32:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2] devlink: add params FW_BANK and
 ENABLE_MIGRATION
Message-ID: <Y5CV1UUTCboipF7E@nanopsycho>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <Y48EwzdfkwWsw7/q@nanopsycho>
 <b916302e-8654-2e00-0618-0a2cb8fc757c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b916302e-8654-2e00-0618-0a2cb8fc757c@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 07:21:24PM CET, shannon.nelson@amd.com wrote:
>On 12/6/22 1:00 AM, Jiri Pirko wrote:
>> Mon, Dec 05, 2022 at 06:26:25PM CET, shannon.nelson@amd.com wrote:
>> > Some discussions of a recent new driver RFC [1] suggested that these
>> > new parameters would be a good addition to the generic devlink list.
>> > If accepted, they will be used in the next version of the discussed
>> > driver patchset.
>> > 
>> > [1] https://lore.kernel.org/netdev/20221118225656.48309-11-snelson@pensando.io/
>> > 
>> > Shannon Nelson (2):
>> >   devlink: add fw bank select parameter
>> >   devlink: add enable_migration parameter
>> 
>> Where's the user? You need to introduce it alongside in this patchset.
>
>I'll put them at the beginning of the next version of the pds_core patchset.

You need to do it in a single patchset, if possible. Here, I believe it
is possible easily.


>
>
>> 
>> > 
>> > Documentation/networking/devlink/devlink-params.rst |  8 ++++++++
>> > include/net/devlink.h                               |  8 ++++++++
>> > net/core/devlink.c                                  | 10 ++++++++++
>> > 3 files changed, 26 insertions(+)
>> > 
>> > --
>> > 2.17.1
>> > 
