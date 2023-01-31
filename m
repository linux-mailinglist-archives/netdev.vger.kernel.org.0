Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205AC682C39
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjAaMIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAaMIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:08:49 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFDD25E24
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:08:48 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso10419730wmq.5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwPOs0D9R5JfzHvXgP7x4Wh0HJ6QYlBeuJehDce31Bs=;
        b=c/RhGt7eO9bmSkK0FcRn/+w4tCSQZb8yiG1zGrdNiGasw0Hf95guzPuEol2u4oQteD
         eMPEkM43aaCb8vEKyYSOFRD3AX9dusSolmmp8L0lcs6Ec052ixja0mktXMLNPqXDYQhX
         NUv41gtlR7nhnVMPe1wNH9OUF1i1CDGPnUlrloXQh/COsOaRmOpmcLRoe31RUlqIP2JD
         a53q6lFv5WRfLGlXeMaMGnbUzIAJaOM3id8ig3rYR276fMDY4kOHcJyhfj1nMBxfi98U
         ib0TaNmkhzul4+orANM1+hE/8KoctiiNhoXEKRwebwzmJwi5FNwBA6EiKVf29RbnVW3d
         6+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwPOs0D9R5JfzHvXgP7x4Wh0HJ6QYlBeuJehDce31Bs=;
        b=Kt1m613via6pBuFcGDDeZyJVb2HCgHtGeTEP2FCXPGUcDSQ9GGNTyiq9y4rsAccKY3
         HslDstkvM22w5vGFik4rs+Hw9YhoLEZR9IRWiaaqSn8JSysTo0LwmyXwMvBvcVgfeTw+
         zJFKyUWQyZ4gW/qYQb+g/cAR2+pYh4fCPUGpPA4CSfBi18c/vfMrfVU7rnDnY2SdaS7I
         cfR9GCrl3ZfLify5TR26fcCJnxJX57c/zz3Wd8hbtFLDa/HsSzqDGxXt/0RQjcDVzz3a
         RNxRxszhbYyXJahieGlLtszZO36pPWRrrOTHTALNjEf/1IgiKNjroX5ChB5pTr/yfNDg
         0//Q==
X-Gm-Message-State: AO0yUKWSzrXX6WYmq9Kgs42EGr6mdbxJBpLsVCLevEJ+XlsjZWP3GI15
        LjcaG6nK6LCaL9kdI3er0mt22g==
X-Google-Smtp-Source: AK7set9lu+dktlb6wmQtPup96lep5Xpe9f5KIryro9Z0nhh+kGgD5vGZa7e9/tDrbN/QGk9iH4A0fA==
X-Received: by 2002:a1c:f712:0:b0:3d2:813:138a with SMTP id v18-20020a1cf712000000b003d20813138amr3260377wmh.35.1675166926556;
        Tue, 31 Jan 2023 04:08:46 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x9-20020a05600c21c900b003dc434b39c7sm2334538wmj.0.2023.01.31.04.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 04:08:46 -0800 (PST)
Date:   Tue, 31 Jan 2023 13:08:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 2/3] devlink: remove "gen" from struct
 devlink_gen_cmd name
Message-ID: <Y9kEzTm3zAJOBG3c@nanopsycho>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <20230131090613.2131740-3-jiri@resnulli.us>
 <Y9kA01okvtKYLDZ2@unreal>
 <Y9kBbPdGYN8awqVX@nanopsycho>
 <Y9kCRK2NNnwClq+Z@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9kCRK2NNnwClq+Z@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 12:57:56PM CET, leon@kernel.org wrote:
>On Tue, Jan 31, 2023 at 12:54:20PM +0100, Jiri Pirko wrote:
>> Tue, Jan 31, 2023 at 12:51:47PM CET, leon@kernel.org wrote:
>> >On Tue, Jan 31, 2023 at 10:06:12AM +0100, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> No need to have "gen" inside name of the structure for devlink commands.
>> >> Remove it.
>> >
>> >And what about devl_gen_* names? Should they be renamed too?
>> 
>> Yep, see the next patch :)
>
>Ohh, I would organize them differently.

I wanted to rename the variable names once. That's why I have it in the
next patch.


>
>Thanks
