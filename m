Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFCF69C68C
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjBTIYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjBTIYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:24:00 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6110B86AC
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:23:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id j2-20020a05600c1c0200b003e1e754657aso342315wms.2
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MtS1Kgx1BZ0xN3W8BXsdVowRexI5K5iT/b0cJz7Hp9k=;
        b=5TddKPCr6IjrvgRKVu6moIIx2ikxCi3c222PCLduqtXfeIJEXAwsdMvuWzMNNPAQW8
         ZMEkJZn4aKw8DhPKKa0qMwzEe4QOqSCAwX/iMKL5ZpZA+RU+YG9ataFpdX016SRUYn3k
         YqbRdinPJlByMit7d3jx9MJTcLAsOKoZ0C8Ow/wPU2WLsxp4ewkUy+eKrsEyDpMiBvhX
         BLA7ub+k391lgUBXS5CfGBvyIMKjnhM8mjsyycqV7vbMzGgbELk8mHOcJqShkLPMQe0k
         7qM1GhA0eQOQlp2yWZSusUGsMA5XrhENlJPwSjZRbSO0xage2NIrAYrpU55dqf/Pvp+V
         7pJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MtS1Kgx1BZ0xN3W8BXsdVowRexI5K5iT/b0cJz7Hp9k=;
        b=JVJW99fLmU4J17A9iKBt1TPT63SM5C+cPNMK31yBwyJDnnVMnmCrcdSwDQBuBd7P1h
         JTPV4VhZcbleyHK4FgeNGkktznGb0In73D0U9pVKltguvjyeXcPzPaPjLCgK8ILrtuW4
         8OAsQQNTanvXjkNIwGt9r3oBnyZ4YWyRjivn4Uz5nTSEU3Gx/c+J+Kc+L9fPP84k7HpL
         nFWemB01BsypaYfSqbC98ntc+KdeTwoVuwuzMRMZsDz4WP+7DcUUThLwXDgBPVqBvhto
         XGSoDep5qx+VgCZK/fA0cwE4eSwi5w6977zdvui1e9C0TCY1hktGp2ooV77+2dtmoNq5
         Ks1g==
X-Gm-Message-State: AO0yUKVG9IgxEzueG+/XRypK+st2V9SKBtlbw9zlFttX6zqYDs5IkHyW
        +0mxllfi0MHCCHBMiYSmCscw0Q==
X-Google-Smtp-Source: AK7set+T6doJskCreSNm9FbNogu7TyjxiLA+kgaYDZIRPBzQFMx35Kp0e/v/6wo7lQEd9EMd/6+99A==
X-Received: by 2002:a05:600c:2b46:b0:3df:fd8c:8f2f with SMTP id e6-20020a05600c2b4600b003dffd8c8f2fmr217548wmf.40.1676881429778;
        Mon, 20 Feb 2023 00:23:49 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t15-20020a7bc3cf000000b003e1f6e18c95sm7906283wmj.21.2023.02.20.00.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 00:23:49 -0800 (PST)
Date:   Mon, 20 Feb 2023 09:23:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
Subject: Re: [PATCH v3 net-next 01/14] devlink: add enable_migration parameter
Message-ID: <Y/MuFN59Apu4eDwN@nanopsycho>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <20230217225558.19837-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217225558.19837-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 17, 2023 at 11:55:45PM CET, shannon.nelson@amd.com wrote:
>Add a new device generic parameter to enable/disable support
>for live migration in the devlink device.  This is intended
>primarily for a core device that supports other ports/VFs/SFs.
>Those dependent ports may need their own migratable parameter
>for individual enable/disable control.
>
>Examples:
>  $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
>  $ devlink dev param show pci/0000:07:00.0 name enable_migration
>  pci/0000:07:00.0:
>    name enable_migration type generic
>      values:
>        cmode runtime value true
>
>Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>---
> Documentation/networking/devlink/devlink-params.rst | 3 +++
> include/net/devlink.h                               | 4 ++++
> net/devlink/leftover.c                              | 5 +++++

Why you didn't use get_maintainers.pl script for the cc list?
