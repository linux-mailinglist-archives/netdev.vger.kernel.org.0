Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C2F56A936
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiGGRPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbiGGRPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:15:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82923205B;
        Thu,  7 Jul 2022 10:15:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a9so3837206ejf.6;
        Thu, 07 Jul 2022 10:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2EAyZ1stZAv+WE/Oe5lCBYtB4ekQDXz6Nn8Oghg9kCU=;
        b=aHVDuq46twN+OtT8574CNtiZ3p3tEfhUL8u6sOlYI9+fP7FO7ykbEZNFUFC3BHekRu
         xA/j1QpdOWmeCE2rtNbFo99qRlvmizsJQzwB5/hvHJkCUajqEXEPuhEguALh8eiqbQQF
         mluxjRV3D7ng9QMNi4SXpjB18hEG+BUkvsUcTiFsUZ+UbD5xTOixnN3f7cmh4wWAu6d5
         dK26p1VfUwXSecDuHXzgSG2LnDTjDwpd44q7pD0LHcJDGeO/4EGNkWhUlmwpQGGNsom5
         wQcoHZMbkPLxSb5mTE+070/irIWuvf3WM7qheHctOiYTf5zXv0Yr2yW4DHSUgN19X1p1
         4VJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2EAyZ1stZAv+WE/Oe5lCBYtB4ekQDXz6Nn8Oghg9kCU=;
        b=F4ENIQY4yKx3PVWMc2V8pW+I/vmWpz0nCB5Meiv5KmqplYopJsngtgIESAiafpS+SZ
         CAISDKAUhcwKpTV+bAs2oIvvaCly1TagZGPPVLp2udR2HkjaR01xrDgZKMDgVWbJbtkJ
         4bFhOUMxXRgWmZMyP8j6rUb9k/VMO2Kt4oJOTtbrWEsGA81Rc5MsFM2kRbNspEWOER5V
         DfYaum1TtSDONkv7S15m7yux04n2UEbTtw8o5jC7MEr6g1Tu6kD98+r1XAr74FoionPW
         36SKIRBm5TE4gLwp//ySdjwb762Li5vTGsFGM/9+8H4NGs8X2AqnHVZtplg0HavzRWqN
         0Nxw==
X-Gm-Message-State: AJIora8zWHg5t9SBVx54+m8O4fPP2nbvrOF12HVrohS/M6UnfNTnqgNP
        Gly3yPZ63OJfpGNsFP3JtvbMchILkwOVRQ==
X-Google-Smtp-Source: AGRyM1uLWPRbP8pYZcxH3kWV00K38gQ+djC3RPPA+1wJF6qnwbshXFtWrHXkUNUVdrli+VcgV7M8xg==
X-Received: by 2002:a17:906:8a59:b0:72a:4249:e998 with SMTP id gx25-20020a1709068a5900b0072a4249e998mr45039843ejc.731.1657214111468;
        Thu, 07 Jul 2022 10:15:11 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id ku2-20020a170907788200b0072afb9fe3f3sm2479954ejc.110.2022.07.07.10.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 10:15:08 -0700 (PDT)
Date:   Thu, 7 Jul 2022 20:15:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <20220707171507.pojkwqhwqk5u6mmn@skbuf>
References: <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
 <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
 <86v8tu7za3.fsf@gmail.com>
 <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org>
 <20220706181316.r5l5rzjysxow2j7l@skbuf>
 <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org>
 <20220706202130.ehzxnnqnduaq3rmt@skbuf>
 <fe456fb0-4f68-f93e-d4a9-66e3bc56d547@blackwall.org>
 <37d59561-6ce8-6c5f-5d31-5c37a0a3d231@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37d59561-6ce8-6c5f-5d31-5c37a0a3d231@blackwall.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Thu, Jul 07, 2022 at 05:08:15PM +0300, Nikolay Aleksandrov wrote:
> On 07/07/2022 00:01, Nikolay Aleksandrov wrote:
> > On 06/07/2022 23:21, Vladimir Oltean wrote:
> >> On Wed, Jul 06, 2022 at 10:38:04PM +0300, Nikolay Aleksandrov wrote:
> [snip]
> > I already said it's ok to add hard configurable limits if they're done properly performance-wise.
> > Any distribution can choose to set some default limits after the option exists.
> > 
> 
> Just fyi, and to avoid duplicate efforts, I already have patches for global and per-port software
> fdb limits that I'll polish and submit soon (depending on time availability, of course). If I find
> more time I might add per-vlan limits as well to the set. They use embedded netlink attributes
> to config and dump, so we can easily extend them later (e.g. different action on limit hit, limit
> statistics etc).

So again, to repeat myself, it's nice to have limits on FDB size, but
those won't fix the software bridges that are now out in the open and
can't have their configuration scripts changed.

I haven't had the time to expand on this in a proper change yet, but I
was thinking more along the lines of adding an OOM handler with
register_oom_notifier() in br_fdb_init(), and on OOM, do something, like
flush the FDB from all bridges. There are going to be complications, it
will schedule switchdev, switchdev is going to allocate memory which
we're low on, the workqueues aren't created with WQ_MEM_RECLAIM, so this
isn't necessarily going to be a silver bullet either. But this is what
concerns me the most, the unconfigured bridge killing the kernel so
easily. As you can see, with an OOM handler I'm not so much trying to
impose a fixed limit on FDB size, but do something sensible such that
the bridge doesn't contribute to the kernel dying.
