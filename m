Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45437648458
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLIO5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiLIO5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:57:06 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CCE7E439;
        Fri,  9 Dec 2022 06:56:41 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id m18so12068584eji.5;
        Fri, 09 Dec 2022 06:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=38seMM65FTVG2HrDf+A2e48QjUk8/7Rk1mythBxtZzM=;
        b=jZiDRSNJH45vEpidZG95Qi0B90Y544oJZSeGoGPYzjh0+BoD8Ir2voKoJks/UKi7d8
         XirgTC1iZI7wYxPxpHCsnAbvByEVx3Dk5BoxlIn4KK16MfxUv2eQ7ekNpOjAuTPp4Uzv
         7kbGZM63IFmmnLnpW2iP2vsXWlQdnBLz/O+qbUNUdAk4fnpS0c4DsdgfCMNJjATt35wR
         C5XUurKR70rI/TXtCldutKk8LM6OIOvmHhBriw89p5wkyOlYX0jk2Tu7wdO1wQwyx7Kg
         u7s8JeZ2WhVDW1UuPpOdvqujeLDxN486RTKs7CN0++2M+BAXy2F4QUcreGZDvIribplb
         fDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38seMM65FTVG2HrDf+A2e48QjUk8/7Rk1mythBxtZzM=;
        b=n0rH7ygeKxw4BTpJ87nhEbdfKfL+zLcMGbruYCX2+VuN0VAP9Zwcnhem5vveyNLxnp
         6p6bt7IVWRvnosvSrc9SdJtCiryzEl0M4RiPy0vkXUxIpZqV+J23t8OiAfi8c6vrXya3
         LgB6ovNpmO97iaO96wvOJhcJ3rSohodu27PWhSr6nEJncOBimn3NsprbRiOHUoyzpUJG
         eYfNMKch8TN87moOgB9OyG9gpVm/XfB7MbKMG4P+n5a9PHIWjfI/GeQhnbLQ6fGP/w3H
         Ue+bNZ/HVRTQsXL+mLEYLS1e59GPZYxdYbixjqtieAJAWTepgHhh+kMhIZRltjxxtUJG
         Mqlg==
X-Gm-Message-State: ANoB5pnsYNSRfM0aJHqad2rTMU4hRZZsZGp6nXkPaXJb4wBaFdu9MLZh
        oy7WSo7dfFBrSXPRfOjrXfw=
X-Google-Smtp-Source: AA0mqf67+z8t6p2hbugUD1aLy9UVgh8X/vuQodI8ozIgYtuhnaU1E2Wnmyl+qdU+VHGvbZHKEwJmqA==
X-Received: by 2002:a17:906:8241:b0:7be:1ce1:ce3d with SMTP id f1-20020a170906824100b007be1ce1ce3dmr4689369ejx.66.1670597800295;
        Fri, 09 Dec 2022 06:56:40 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id b1-20020a1709063ca100b007adaca75bd0sm26310ejh.179.2022.12.09.06.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:56:39 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:56:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Michael Walle <michael@walle.cc>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209145637.nr6favnsofmwo45s@skbuf>
References: <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
 <20221209144328.m54ksmoeitmcjo5f@skbuf>
 <20221209145720.ahjmercylzqo5tla@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209145720.ahjmercylzqo5tla@soft-dev3-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 03:57:20PM +0100, Horatiu Vultur wrote:
> The 12/09/2022 16:43, Vladimir Oltean wrote:
> > 
> > On Fri, Dec 09, 2022 at 03:20:58PM +0100, Horatiu Vultur wrote:
> > > On ocelot, the vcap is enabled at port initialization, while on other
> > > platforms(lan966x and sparx5) you have the option to enable or disable.
> > 
> > Even if that wasn't the case, I'd still consider enabling/disabling VCAP
> > lookups privately in the ocelot driver when there are non-tc users of
> > traps, instead of requiring users to do anything with tc.
> 
> I was thinking also about this, such the ptp to enable the VCAP
> privately. But then the issue would be if a user adds entries using tc
> and then start ptp, then suddently the rules that were added using tc
> could be hit. That is the reason why expected the user to enable the
> tcam manually.

I don't understand, tc rules which do what? Why would those rules only
be hit after PTP is enabled and not before?
