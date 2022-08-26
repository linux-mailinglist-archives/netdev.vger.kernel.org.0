Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF95A22D9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245066AbiHZIVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244988AbiHZIVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:21:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D235208D
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:21:29 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id y3so1784354ejc.1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=6ifOJfE/GgNTxYzZXT/tnQT64Iv5pyc29yhnUHFld+Y=;
        b=rzv36Bc5mmdUyq6BSragIwdXhIiN7VDx+HSv+pf/CEjnijaa9AjJacjHepXmKTNKvY
         0gw+ZJOUKURdhJ4cINgLXFEYfxAZqmV/+gP3ZMkFB9FXqw+ee/6Vh0Tojzqk4OvKbvil
         gGlRSk5hKG1A/EW0f61LMiZZMAhRiM1i3x2B5s7k/XBugYizzcF2lHyZMcePtR59xWSd
         48Ez0OVxreZvv/DRE8F2Yd4cxm5imwumaMHFkypfmkxKPfKi6UOVvZssU/M8gJFVC6EI
         ppa/LhPtYx/kyl5trLklM6eDc888s+fytsGeEYVwIrY1B0FujoKJkEW5zmxYIdfuZ50l
         TnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6ifOJfE/GgNTxYzZXT/tnQT64Iv5pyc29yhnUHFld+Y=;
        b=wLZ0nJo1xjnEYlaO9+HRS3cOBNv2TgyJ9e/+tTx6FUyivQaJx/WcpAmEgPwYZo7RJP
         UG0P8SN+OEoY1Uip6m9aJZOLj7XbPx/xXqwGO5uE+i7SUi+R1ApctgVwxf40n0ciKIhu
         tXV8qLLGeSEB1EhRx2e0bn8Fdy9YbcuS6elqe/1tJLI8+V9IsL0L458HhWBkErC8kONj
         3gXiFtrNgxQSBnJN3A60QxwnXFgOUeyJxV1rZdT2k6oZ2n3qAa3WF+bI24t5Fs0eGCM8
         cSxj13Qn22GddC2w3JaSEF8cE13wCxls6i0FSnfw99E+MKT3EHWzhH7SRohlIDgpIHqb
         foRg==
X-Gm-Message-State: ACgBeo30CyP+qfy5elcejPsbwxPjARWb7NE5eTnWgFwDx970Kwct++Rx
        BmEp+Lefy2jiMJAnHfFnozuE1A==
X-Google-Smtp-Source: AA6agR7QCVkyGwoj9SB25x37JmmXsNEt3s3GVT0Um2vPjcSp3O8ImKlCzW3vfpve++hO+O0Zbh181g==
X-Received: by 2002:a17:907:96a1:b0:73d:75f2:336 with SMTP id hd33-20020a17090796a100b0073d75f20336mr4740525ejc.43.1661502087922;
        Fri, 26 Aug 2022 01:21:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n17-20020aa7c691000000b0044657ecfbb5sm928010edq.13.2022.08.26.01.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 01:21:26 -0700 (PDT)
Date:   Fri, 26 Aug 2022 10:21:25 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: sanitize per-port region
 creation/destruction
Message-ID: <YwiChaPfZKkAK/c4@nanopsycho>
References: <20220825103400.1356995-1-jiri@resnulli.us>
 <20220825150132.5ec89092@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825150132.5ec89092@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 12:01:32AM CEST, kuba@kernel.org wrote:
>On Thu, 25 Aug 2022 12:33:53 +0200 Jiri Pirko wrote:
>> Currently the only user of per-port devlink regions is DSA. All drivers
>> that use regions register them before devlink registration. For DSA,
>> this was not possible as the internals of struct devlink_port needed for
>> region creation are initialized during port registration.
>> 
>> This introduced a mismatch in creation flow of devlink and devlink port
>> regions. As you can see, it causes the DSA driver to make the port
>> init/exit flow a bit cumbersome.
>> 
>> Fix this by introducing port_init/fini() which could be optionally
>> called by drivers like DSA, to prepare struct devlink_port to be used
>> for region creation purposes before devlink port register is called.
>> 
>> Force similar limitation as for devlink params and disallow to create
>> regions after devlink or devlink port are registered. That allows to
>> simplify the devlink region internal API to not to rely on
>> devlink->lock.
>
>The point of exposing the devlink lock was to avoid forcing drivers 
>to order object registration in a specific way. I don't like.

Well for params, we are also forcing them in a specific way. The
regions, with the DSA exception which is not voluntary, don't need to be
created/destroyed during devlink/port being registered.

I try to bring some order to the a bit messy devlink world. The
intention is to make everyone's live happier :)

>
>Please provide some solid motivation here 'cause if it's you like vs 
>I like...
>
>Also the patches don't apply.
