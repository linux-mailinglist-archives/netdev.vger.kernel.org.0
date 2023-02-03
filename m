Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D124B68918C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjBCIEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBCIDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:03:47 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37414E85
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:02:57 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m2so13079543ejb.8
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nR20600SL7g35fm438V0laRpWELfS254RVEtCaDlTWI=;
        b=GOq88P8N+614+l+UcGLkDVoY6H4UAaFRqI1zfr9wpu7rXaJ7UM562Pht5e+QEYlEpN
         +JGx7q7DnWX0wyB+cVmtvBhNEZbfuzZbk2JfhqCA8dOyRCZyj2ITRs+34hqwHzsyeQ2r
         4muu3ifR+aIjiX2uOG/r8TWcoANREf5Ge6/da90kS2jtFc7RTgajA37gLstI1UFqtY1y
         1vQ2sumOp01Lc/6klXOO6c3cxyltlZ3McMM1W5B4AkgFSuYLtaMMy85PQ3IF8Vxm/eJB
         Gc0Lo8sLFqGdEZEvkGMjSeIH2+gekOqwSjRpCzl79s+vOT8aJU9BRcFD/c5HLdky2mU3
         f/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nR20600SL7g35fm438V0laRpWELfS254RVEtCaDlTWI=;
        b=mmKlx9VhH7rQBt7G4Dyek+XdTOQmOK3rq0x3cY2h4Bpo7Ks1JSv893S34RXm4y1IKk
         WJIdQA4/pvDOcDZYMQlPPQBrZGENgB5zJo4M7VZP580ff32hTERH6mlzGteqtwf1Vz7h
         8dayKZYRCMd/ulreeCyoHztAXlJXPPue8lf6alnQtsao2caBbDn0bmlfIvoqYGbSwZuG
         o8/a/1trgIToSRmNaSO2R80GhdO1xryTs7HEsp/olHyVu3O7jGbitBSXBtbk5bfXQ+E9
         UtScdGz3zaTBLANNjg5149AXPbT3Eoq8PcoHd8/sT1b/wYswL4nvhepLTMj723q6on4E
         t1Jg==
X-Gm-Message-State: AO0yUKWI9qimYPVmjct/pbvv8ExeyiY1Bl9PCz8Bl1lOXopOjayUA7Yv
        +mrDlez8WqjhELcMKXAcJp0Cpg==
X-Google-Smtp-Source: AK7set8HkdTykRTt6XwdlZ2GwJb9SmCOtcLgcSBKli3qD9uHZRhnoHdhb6uPbxsFzhfCOjpx59UXdw==
X-Received: by 2002:a17:906:c2d3:b0:854:6e3:2388 with SMTP id ch19-20020a170906c2d300b0085406e32388mr9530349ejb.12.1675411375276;
        Fri, 03 Feb 2023 00:02:55 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f6-20020a17090660c600b0088ad82a8de4sm1004941ejk.34.2023.02.03.00.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:02:54 -0800 (PST)
Date:   Fri, 3 Feb 2023 09:02:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] devlink: Move devlink dev selftest code to
 dev
Message-ID: <Y9y/rfqIZg3oaBnq@nanopsycho>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
 <1675349226-284034-8-git-send-email-moshe@nvidia.com>
 <20230202101712.15a0169d@kernel.org>
 <52392558-f79e-5980-4f10-47f111d69fc0@nvidia.com>
 <20230202114621.3f32dae1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202114621.3f32dae1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 08:46:21PM CET, kuba@kernel.org wrote:
>On Thu, 2 Feb 2023 21:33:52 +0200 Moshe Shemesh wrote:
>> On 02/02/2023 20:17, Jakub Kicinski wrote:
>> > On Thu, 2 Feb 2023 16:47:06 +0200 Moshe Shemesh wrote:  
>> >> Move devlink dev selftest callbacks and related code from leftover.c to
>> >> file dev.c. No functional change in this patch.  
>> > selftest I'd put in its own file. We don't want every command which
>> > doesn't have a specific sub-object to end up in dev.c, right?
>> > At least that was my initial thinking. I don't see any dependencies
>> > between the selftest code and the rest of the dev code either.
>> > WDYT?  
>> 
>> I thought as it is devlink dev selftest, the sub-object is dev. 
>> Otherwise, what should be the rule here ?
>> 
>> How do we decide if it should get its own file ?
>
>My thinking was that it should be much easier for newcomers to grok
>"what does it take to implement a devlink command" if most of the
>subcommands where in their own files, like in ethtool.
>
>The implementation could have as well made selftest a subobject.
>But I don't feel strongly, if noone agrees we can apply as is and 
>see if dev.c does indeed start to grow out of proportion.

I think that per-object separation is good for now. I see no point of
having per-cmd files of sometimes 50 lines. IDK. No strong opinion.
I would start with per-object.

