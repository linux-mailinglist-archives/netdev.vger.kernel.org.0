Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854F9643F38
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiLFJA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiLFJA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:00:57 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6411DA43
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:00:54 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id y16so22499418wrm.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E4wu4hLzjWhTRNoglcWD5BHc2rsLuhO7teWAdBr4HlA=;
        b=GyHGpzlAeb3ZPpxWOTpYKRSaSBUDjuKqqBlKhnF5gZaigAh3gMT/HZmclVgNWcJ/AX
         RxQ4hSmeubd09l+p+aYAGVtN4pC6MLtGFqv/mMJRJ6gzzQwL9eygy+kZb6+pQGvJavh6
         GbwQSLD87KwW/hd8xWb2iZlU4+GAK613MrrSDOU4VDkrmDuK8exHrCO2HUZ8tn8oBkZv
         okkI+QfiCLjV9EJ6oib19yFWCpfVvE8R+TjzvwBFbg5VwC4TO+rNbvwuYorejtOaaDvU
         ZCpEIR4rL94NFZaWy2SzngwbE2Ivg63iKVPP3TXt9a3ZZ7ad+75MW3vQnrjU3crR1vcy
         ImvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4wu4hLzjWhTRNoglcWD5BHc2rsLuhO7teWAdBr4HlA=;
        b=AwKzOBs1z1W/IAunwAXbiC2S/wCP42l1CAOyckZS3p8LsLJQVQP/AxaLOcpWNnViXY
         PHpTKCnX5LhLfn220uvx61DWpHPgLlMKp4AznB5H2u+GRm0ME29FApU0V/MfmXt3FDu9
         bQrU/1sQ6capr28EGohET4UM2E8l9FRnUWEoRmRl6dpuo9PVHsBWOMgI5KRnmUz0m9Dn
         WZjJmhpVZcp/95ND5W0keVYLyPh7GKKSf3jl0sH+eBw9k038xYUvEWr6HBECLjtR5Zbo
         Ruau4u1bJ4mlYywvLA0mSLzbKbf2MuajMM8ALHDZtAE1uoHiEhTbCFojs67TAaJnQGFg
         Dhgw==
X-Gm-Message-State: ANoB5pkstwZeNqj3moCdBN5Ab+5dyWItILnErlUeuBiChTy1HYSNQYzk
        g0Fs4v6Qk9Pwn9C2LM/PnFOZ3g==
X-Google-Smtp-Source: AA0mqf59WCvg7mUihe/M0guxd4AaQu60YpkeCRMq1K1r9DLbSm0LIHG2Y5ZZ3RvaDX+8vQH2FL4C2A==
X-Received: by 2002:adf:b346:0:b0:242:2748:be7a with SMTP id k6-20020adfb346000000b002422748be7amr18875234wrd.116.1670317252888;
        Tue, 06 Dec 2022 01:00:52 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u14-20020a05600c19ce00b003cfd42821dasm22230246wmq.3.2022.12.06.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:00:52 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:00:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2] devlink: add params FW_BANK and
 ENABLE_MIGRATION
Message-ID: <Y48EwzdfkwWsw7/q@nanopsycho>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205172627.44943-1-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 06:26:25PM CET, shannon.nelson@amd.com wrote:
>Some discussions of a recent new driver RFC [1] suggested that these
>new parameters would be a good addition to the generic devlink list.
>If accepted, they will be used in the next version of the discussed
>driver patchset.
>
>[1] https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/
>
>Shannon Nelson (2):
>  devlink: add fw bank select parameter
>  devlink: add enable_migration parameter

Where's the user? You need to introduce it alongside in this patchset.

>
> Documentation/networking/devlink/devlink-params.rst |  8 ++++++++
> include/net/devlink.h                               |  8 ++++++++
> net/core/devlink.c                                  | 10 ++++++++++
> 3 files changed, 26 insertions(+)
>
>-- 
>2.17.1
>
