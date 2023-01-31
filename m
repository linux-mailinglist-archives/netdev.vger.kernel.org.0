Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94541682BE5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjAaLy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjAaLyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:54:25 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C072E1C5BC
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:54:23 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id lu11so3501936ejb.3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T1FocFPe5U0fTDarFKxD4I1YWUICiPz5kpCaFFhmTyo=;
        b=xilEfuv7wgS77BSVUACuwx0VCIOlY3Ttd06+XiykV1vkpN3JvwWTSYUcG+s0tjYqNd
         dmnkKJsxiL1yxcRLnBBx3Gz6yK6ey1TavKnatOzcbsfTr7HJ9T6HVbW/1dkjaAcOUaik
         olPYLnKwL1GA/kXj6kLJuycD/HUi1p4XB6/Dd1sVUm4nqLOnD/6nXaFXqH5ZGgnnSTU0
         NFZcXTad5RtJEobfn0DoH5aLQsVC1Tww81FIMi31wTqiq6/sm0+ZkWKDEqzddYbKykuU
         ea1hRJVLtQ2y2WYrp3+f4J8FMF/lm/6MfTC36FM3YWBb+t6ykxmASECGwaVByoCFfF80
         A1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1FocFPe5U0fTDarFKxD4I1YWUICiPz5kpCaFFhmTyo=;
        b=uyt5+UetJjaqSY9Z+KQnGD55MXoX3mW594O2wlTyvQpVhRzzNQlTDT5KXS7XcKKR1A
         /YvqiqkZ44uut4FtqWL+4CA2gB7NluEPhJ93y84IHD8L0lE37HLJxAUAr/QBuvTAnA9X
         K+9Q9hAf3Yi7vESqFHWy+FGD/Tti9d+a4v4JnwVM8biIW0pdYH4txXcoT6GiFWWmuclG
         ePPjASpeDTIdm115KsrhOrXYNu1z1KoSFyjE4w11Nchd1FOXHvq+PV2TWwelRWvOtI9T
         wCBe2zi1/S1SmOCKd6ZNgxzEKRW9XVBAXO7qSN5gvFjWDgwMJscmeDzuZc0m+SwNbUG7
         7Fbw==
X-Gm-Message-State: AO0yUKVR8wZxFwqx5DvWHyktFhIHwKZtPctm+TyrOzk95h8LNA7pnqEP
        sDunHL1CTNya+CCBMlrkmeb1Aw==
X-Google-Smtp-Source: AK7set9rI6GafO5ZaY+mdewhMWaJNAxVv3CByp97aXi2WMUT2PY6bJjgi+37sGCi14BKBpbZPSsBYA==
X-Received: by 2002:a17:906:375a:b0:885:9902:3aee with SMTP id e26-20020a170906375a00b0088599023aeemr3339996ejc.25.1675166062300;
        Tue, 31 Jan 2023 03:54:22 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ss2-20020a170907c00200b0084d381d0528sm8206021ejc.180.2023.01.31.03.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:54:21 -0800 (PST)
Date:   Tue, 31 Jan 2023 12:54:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 2/3] devlink: remove "gen" from struct
 devlink_gen_cmd name
Message-ID: <Y9kBbPdGYN8awqVX@nanopsycho>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <20230131090613.2131740-3-jiri@resnulli.us>
 <Y9kA01okvtKYLDZ2@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9kA01okvtKYLDZ2@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 12:51:47PM CET, leon@kernel.org wrote:
>On Tue, Jan 31, 2023 at 10:06:12AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> No need to have "gen" inside name of the structure for devlink commands.
>> Remove it.
>
>And what about devl_gen_* names? Should they be renamed too?

Yep, see the next patch :)
