Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940FB59F5BA
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiHXIuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 04:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiHXIud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 04:50:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0206CD0B
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:50:32 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id a22so21132132edj.5
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=j13osKCQ/BhPfF4Ua11QjmxAIWsQsUKrViQXYZT2Mr0=;
        b=ggsE9OcZH2kkue5vXJZWOc3R/MbrS10smCKlnQKvpht4jn5yGEkyrO1bA1oEE55If9
         IYrPimcHa/SQx8MZifn33TY4bY+mRA+u7Ny1RjefcYs12M6/gKUXn0WEq4HxwLR03q2A
         2raRG+WsJ2BPProJ3PRviLrrlcXgag1qqNZko6COUhV4T8NXVEUPcb9ucfM2nDq465Uc
         CY5Tssz4xKS6UvCRQSveojqGucefrqykPtw3LXYCmcrEIn6C8IObYyTQnp4MVXRgGW6q
         7guo3PDcJdXsakrVB5TiZRsnAmAHe4AUwhYRsU+67Te9oky6WElIQijaNK9SF7x99aE+
         Kolg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=j13osKCQ/BhPfF4Ua11QjmxAIWsQsUKrViQXYZT2Mr0=;
        b=sMNG3haZZxRaENUqKI9rVXH+PSa1AUZD6w/AJ6niMkKKkyTlp42c23rhfkXIw7i35n
         dKT6MIRE3K6PiEqg2H00zeWmCzcrSDO7OYbMXWlKFL2B871U649VdrnJTyemzdTjhRP8
         4rPXwiUSPZCPzU6ONPCY9QkSy3S3PqC0wyrhNh5cgJ76L2t+JO4h7lew25gMTh+pNLsp
         Zu4CBsxtyj0k6jMGwgTuUTmannNRveiagXUuvCxNh2xJrfgS+p9Eo6UVcv0BsOGD0xvr
         mhWuAU9v1p1tU/jZD7RmI4Oay4nY6sRk4tjtw2FNZzAvy84s+92OKH5Kkuv+keMo4AIo
         uy8Q==
X-Gm-Message-State: ACgBeo04XA+k5ZM9/TeYHBURO0g3xN03emiMhT+vSysJwKJgaUYTkREM
        gnPbX9zP+RlpYuyTaENQp5jf1w==
X-Google-Smtp-Source: AA6agR4q91eiuFN0RxZiMj6+BR1xBHa95+DbvfoCm4KiSYy3Bfl1kVV52XvE5vjNGuh+Zm47t16hDw==
X-Received: by 2002:a05:6402:51ce:b0:43e:74bc:dce with SMTP id r14-20020a05640251ce00b0043e74bc0dcemr7002462edd.225.1661331031123;
        Wed, 24 Aug 2022 01:50:31 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f4-20020a170906084400b0073c82539183sm878842ejd.91.2022.08.24.01.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 01:50:30 -0700 (PDT)
Date:   Wed, 24 Aug 2022 10:50:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 1/4] net: devlink: extend info_get() version
 put to indicate a flash component
Message-ID: <YwXmVTs79zVMdBDJ@nanopsycho>
References: <20220822170247.974743-1-jiri@resnulli.us>
 <20220822170247.974743-2-jiri@resnulli.us>
 <20220822200026.12bdfbf9@kernel.org>
 <YwR1GCPCKuK4WJRA@nanopsycho>
 <20220823123208.61487225@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823123208.61487225@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 23, 2022 at 09:32:08PM CEST, kuba@kernel.org wrote:
>On Tue, 23 Aug 2022 08:35:04 +0200 Jiri Pirko wrote:
>> Tue, Aug 23, 2022 at 05:00:26AM CEST, kuba@kernel.org wrote:
>> >On Mon, 22 Aug 2022 19:02:44 +0200 Jiri Pirko wrote:  
>> >> +int devlink_info_version_running_put_ext(struct devlink_info_req *req,
>> >> +					 const char *version_name,
>> >> +					 const char *version_value,
>> >> +					 enum devlink_info_version_type version_type);  
>> >
>> >Why are we hooking into running, wouldn't stored make more sense?  
>> 
>> I think eventually this should be in both. Netdevsim and mlxsw (which I
>> did this originally for) does not have "stored".
>
>Well, netdevsim is just API dust, and mlxsw is incorrect :/

Okay, will add "stored".
