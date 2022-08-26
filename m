Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCC5A2345
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiHZIkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245239AbiHZIj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:39:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2277D6305
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:38:58 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id tl26so1100805ejc.9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=R71pwovWKW2n+2d6b0m1mgjy0dLnYi4JvtwlQD06gkA=;
        b=HOYhgdUFdplD2/K5nkpukqq6uv07hu/JT8XDpoArdztp2I4032fFuMUGt3qDx/Z2aN
         G81QFtnRocphML9ByFf3YBnAsnTgYXseUp46UBefnFeLQ/RAdYwH0ND7MHrrrVv/g81D
         FLNcCXc1h1kM0geWX62XIGz+V1biKkGWZiVA91kN68Iug1cUEE4lrL5gzMBu5u30tYHj
         BgQVn9bplMsF7NKZHd+1WQyE0BOUT/lzmRYSqzHxODCibb8F75rLqxgnobNQjUSJ0DzA
         Biij0ShT3EOMaCOLt8e0yZ3zasIjt6JwGL4YezsWpET4KXZ0DSIrPbY4vs41IWhXLiyS
         9WJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=R71pwovWKW2n+2d6b0m1mgjy0dLnYi4JvtwlQD06gkA=;
        b=J2ngosSIjHkfhDW5++5C95JTm7g0Sw3Sl+v4T9g1tzkUlu9kHxISuanhIH8OB1RERY
         qhXDr1yyR9WMWBp0ZGHeos6lIxFTW+bB5hFyON4D6uZDIfF5k14te1GyNpNT8whcvU6C
         cHyjZhMC9xELHRg94VeUkw+1ozHXUCgs2syYacu6YDCakNCQKKNzSbNzbf/4bSVo3xS0
         p9EMqQc9lPN2Iz7nnEStIdheMbV5z+puDGnIOY08KrkGumbNGA21heDHYgUZR11hvH5R
         STiGEz/zNCjMlCp5vU3zXzTrjHUt7bWiHLfUUoJCe5I1n/d37VUWhFrHqmBXYVNqIVpL
         NGaQ==
X-Gm-Message-State: ACgBeo0KdPKC9ZwXC6agDwf7qcG+WwRoK/PfY1r9ZHywV/NvGTirevAd
        qwje9Ii/pCwSCVA2CbqXxB374Q==
X-Google-Smtp-Source: AA6agR7xZ/f2/7JcXvjG+baYgsb4aGLjnb/LeMzknsCulmovamHT43pUaI8v/g1EIwOCnTvvdm+aNQ==
X-Received: by 2002:a17:907:9710:b0:731:67b1:dc3b with SMTP id jg16-20020a170907971000b0073167b1dc3bmr4825640ejc.709.1661503136627;
        Fri, 26 Aug 2022 01:38:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n17-20020aa7c691000000b0044657ecfbb5sm948867edq.13.2022.08.26.01.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 01:38:55 -0700 (PDT)
Date:   Fri, 26 Aug 2022 10:38:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [iproute2-next v3 2/3] mnlg: add function to get
 CTRL_ATTR_MAXATTR value
Message-ID: <YwiGnm3gj9z9FOmP@nanopsycho>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
 <20220725205650.4018731-3-jacob.e.keller@intel.com>
 <Yt+b3XGbAixaf124@nanopsycho>
 <CO1PR11MB50890D5A3470D9921711A91AD6759@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB50890D5A3470D9921711A91AD6759@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 02:40:20AM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Tuesday, July 26, 2022 12:47 AM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; Jiri Pirko
>> <jiri@nvidia.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
>> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
>> David Ahern <dsahern@kernel.org>; Stephen Hemminger
>> <stephen@networkplumber.org>; linux-doc@vger.kernel.org
>> Subject: Re: [iproute2-next v3 2/3] mnlg: add function to get
>> CTRL_ATTR_MAXATTR value
>> 
>> Mon, Jul 25, 2022 at 10:56:49PM CEST, jacob.e.keller@intel.com wrote:
>> >Add a new function to extract the CTRL_ATTR_MAXATTR attribute of the
>> >CTRL_CMD_GETFAMILY request. This will be used to allow reading the
>> >maximum supported devlink attribute of the running kernel in an upcoming
>> >change.
>> >
>> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> 
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>
>I had a new approach which just extracted maxattr and stored it hwnever we call CTRL_CMD_GETFAMILY, which I think is a preferable approach to this. That was part of the series I sent recently to support policy checking. I think I'd prefer that route now over this patch.

Send it :)

>
>Thanks,
>Jake
