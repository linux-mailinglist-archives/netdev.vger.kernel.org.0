Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2687E51013C
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348318AbiDZPCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242210AbiDZPCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:02:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A645B1A85
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:59:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l18so10006081ejc.7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FC1IQNEXiaRw31394miv9wRG6Rt+GANAPzX8vd3+67Y=;
        b=VjRBMLs3LvoP2+dkH9kM/noMnrLyA73vEbERYtlDzIkGD7hXYqpsfDl4KpCINhTsin
         SI2SvR+fizfwUUwUqXqb3C6SP2PPSD9d/XU038gGhJc+RrzlYg8fOxb1BzxptcKJK1UH
         3TAjjjVGOf0WXthYddHSUNzsLEBs96zC4cYkBgq5xkCjKpwqy2d2PG4LjDyGGI6U9ZJh
         4kvQkptUKXTDAH3LVajHN70tPcapUtq8xvgFdE9Y5Tv7DUVNi8CGTg9l64VUixJ9inYD
         qJ4npXJ5haQBuAhTqMlbJJ+Z6tubXBcn5XcfEW3xXOA4l4Yt0PuhwSnosZ47PFaI9DPl
         v6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FC1IQNEXiaRw31394miv9wRG6Rt+GANAPzX8vd3+67Y=;
        b=4+dDIDLGl6ibId2d+tjMtdRvMPPRRfVnEpjihuSoJjV64qu9k2lcV0OuBMJvSKSKg0
         E2jNipSaSHw3Ei5YcZd5ZKT7Vk0pirk+eYTbY+eA2zI+VDHNR0zVxIgN9Ca0k+N/L1dd
         9TuzEe5bH46hhmNeM3G0WICH4yqINaGn1y4GhzqKEpsVAi6pfLKUrzXY/8t25DS2MVCw
         k7ejkJaF6z/OHtXFLgj0dxGrZsinBy5Ny9VRGdgzk5AbKdO87ViJzN0eTz5jk7d99iAX
         aF4PJo3CrOIVgS/6VI6jEbtbOaxUogvE4+z3BM1UwhK9D53PBvxEdoNjOvavG1j385X0
         k2pw==
X-Gm-Message-State: AOAM533t73VyedCZ56qV8hsEPIdtUlPov5O7SFfLa8iMKE7rJ1uwtStt
        A8SiDe33A5mow3hm2ax/VrbeZWpc4gsQLWK0
X-Google-Smtp-Source: ABdhPJwLH8/+wm3Hqu32M1jNhRtqiRBRCqJk2m2B79dxHcpatLpuMPfj3gm74GlNGG15eiU9sUkNkA==
X-Received: by 2002:a17:906:4408:b0:6da:bec1:2808 with SMTP id x8-20020a170906440800b006dabec12808mr21542045ejo.543.1650985149035;
        Tue, 26 Apr 2022 07:59:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q21-20020a1709066ad500b006f3bd13e352sm367187ejs.8.2022.04.26.07.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:59:08 -0700 (PDT)
Date:   Tue, 26 Apr 2022 16:59:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 e7d6987e09a328d4a949701db40ef63fbb970670
Message-ID: <YmgIu4L6f4WfrIte@nanopsycho>
References: <6267862c.xuehJN2IUHn8WMof%lkp@intel.com>
 <20220426051716.7fc4b9c1@kernel.org>
 <Ymfol/Cf66KCYKA1@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymfol/Cf66KCYKA1@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 02:41:59PM CEST, jiri@resnulli.us wrote:
>Tue, Apr 26, 2022 at 02:17:16PM CEST, kuba@kernel.org wrote:
>>On Tue, 26 Apr 2022 13:42:04 +0800 kernel test robot wrote:
>>> drivers/net/ethernet/mellanox/mlxsw/core_linecards.c:851:8: warning: Use of memory after it is freed [clang-analyzer-unix.Malloc]
>>
>>Hi Ido, Jiri,
>>
>>is this one on your radar?
>
>Will send a fix for this, thanks.

Can't find the line. I don't see
e7d6987e09a328d4a949701db40ef63fbb970670 in linux-next :/

>
