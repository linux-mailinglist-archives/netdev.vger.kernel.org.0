Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC81695AAE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjBNHbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 02:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBNHbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:31:50 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F498E
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 23:31:47 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id dr8so37779820ejc.12
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 23:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNqGAhrWhuYOCtiel0BG6Hq4iJL+MAXGvdyikjTvftg=;
        b=pWH/AjP44LimMiewQL+cuI+Pg13X4Mlg2lkRapt8+v2bhmnsk18C6vlrJyhPO3OXJ4
         lcm85WZZ9UZcpwePGkByH0pOffN2P4JmoGgFRCKOa+ezISjvGk8U9t3qx5Orgj5ajYjB
         2GHdM44wfP4DFB3zLqToLFJsaCREtiMh/VIhs8ihPR3Z83OB7sOhvOxCqhwTfX2NhzKs
         zD6QI4eM/bEXYdqGvt6ooHLQUr+j4oBGj6VPyOzz25TY6Zu4FtoGX8dFE/vsrpAvvABL
         LiqjVuw5aHxmFSDhmQ9qOGiHt4k2hm2kyg12zxn4rf0hfhKgF/DXI5w50xKEEFOmd/Qe
         wpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNqGAhrWhuYOCtiel0BG6Hq4iJL+MAXGvdyikjTvftg=;
        b=ygE0o49vzbmMVTpkfNWXkqtgMySaK8u6ikkhtqi9rVae1/6iCNou6e9WnEIjXQvhVk
         lSaATF14GpjeK6q9sTKwQ2vXiz+EfKQ8sTjmei+49vjNqv2kjNkyTWseslFugRiDH49k
         RsrgwENr7ABphfePIZLrnCUIY/NQP4z0w6KJZ2toLW1ie6pgmHegPxE9jjf2gP2/EZNJ
         vKoPy/fhNtmb1OLOILH+VyQml31vYdgSTlbZeRN0Tolg7+OJ8qMudS1aCrKhaCAx+REe
         Z5MyX5r5uGKZdtqijendEU6V11bAlZDpMklXRsZW7NXFWy3vsYmf1oYDv/3bKB0dao52
         Cptg==
X-Gm-Message-State: AO0yUKWWA8cH+ideg6tEOZxjHg8FbTN9g1FzbkJWn/tzHBExnR2khELf
        WfGKoh3DWfpbG0/OcutV70dpNQ==
X-Google-Smtp-Source: AK7set/pZhXC1Vdp2dNbwKUKLNGFIJlFX/t1+SWWLVCvc3FTZKlI/KqgQ5xYkyWe31BIxkwTEmzbug==
X-Received: by 2002:a17:906:1249:b0:88f:5377:1048 with SMTP id u9-20020a170906124900b0088f53771048mr21903014eja.22.1676359905984;
        Mon, 13 Feb 2023 23:31:45 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906c08d00b00878003adeeesm7841336ejz.23.2023.02.13.23.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 23:31:45 -0800 (PST)
Date:   Tue, 14 Feb 2023 08:31:44 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com, moshe@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [patch net-next v2] devlink: don't allow to change net namespace
 for FW_ACTIVATE reload action
Message-ID: <Y+s44M7Qd2Two55y@nanopsycho>
References: <20230213115836.3404039-1-jiri@resnulli.us>
 <20230213221311.43d98ba8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213221311.43d98ba8@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 07:13:11AM CET, kuba@kernel.org wrote:
>On Mon, 13 Feb 2023 12:58:36 +0100 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> The change on network namespace only makes sense during re-init reload
>> action. For FW activation it is not applicable. So check if user passed
>> an ATTR indicating network namespace change request and forbid it.
>> 
>> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>The fixes tag needs to go, too, in that case. Otherwise stable will
>likely suck it in. Which is riskier than putting it into an -rc.
>No need to repost tho, we can drop the tag when applying.

Okay, up to you. Thanks!

>
>Acked-by: Jakub Kicinski <kuba@kernel.org>
