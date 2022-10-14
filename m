Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCFB5FE820
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 06:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJNEnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 00:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJNEnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 00:43:08 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB67718F246;
        Thu, 13 Oct 2022 21:42:47 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id f14so2605262qvo.3;
        Thu, 13 Oct 2022 21:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xDtHrOYP4APIibnIFGeB3Yw3zgEryhyhvr48A52nfvo=;
        b=Ro7TzmXcPOJdpoVECzcFljxgM8dhXLxteFJY68WpVligO/yeqNeWMB5o+6aRph7B9Q
         dAE6NZx4KGimtxPGnL1kLXCOPIHNmRiyDU4POvLb4mwvAq2zas3X8vQPpH8nWhVfvuOH
         VKOvzSZ4X2MYO6ae/Ll6gSN01EnDLyEwsz8dVJvdGZBALt0abPyLqHfYvX/kVw1NMl+E
         uK0Hydtuk5ORtoODQfl9Q5Jld/FwG725CxnP8+PKX5I+ZSQz96XVzdsmWVuIbuGv1vUE
         1JEXLVsKNOSlk5/9/JWdr5w88V3W35K/zh6crAdTSFhum0DhClXlyHT+sre8H/yIb7rR
         wPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDtHrOYP4APIibnIFGeB3Yw3zgEryhyhvr48A52nfvo=;
        b=7xcVlvcI+9b+yyUMTGFNbPOFy+jWywlTo50KjN8sWeDVNPO2WPpmuuayDiaN8E/cyR
         tI0DBaMPs+2QKdreoDlP/Tu3IjyKbjIGMxC5V+rsDo4cx9RncT7ME7HOpM56a+YeAanw
         HDpdG66jg8/+wPYhXUjx/fRuVLf/CmerOi9E41pRfOcBG4zqxnLwVGS3o4seiitfxKto
         bgubke4ZDZ9ICYpru5YUZVQErcVw1GY3gu11WazY61Aqh7ors81GtLrdLLhnCpythdl+
         xnguuNgRy80arZSdHkv4rsVMdTZyOCZlqY3DCn+XN6GGMlJ6/GiqC64Ca+WMCxlP6LNE
         Ym0Q==
X-Gm-Message-State: ACrzQf0V4/lu+E57xE5oDO6qgjvExHeVfU38n0Zo0MY7U7cx3zdStkvn
        2/m+TPsSby9N4upDplvJRBWFSZAausI=
X-Google-Smtp-Source: AMsMyM6qhS54c16AjFMowoyApUDec+Ds+Np3mRIhBzyLU7P3dUyWXlfLYyYzI3M8wpklAAgbBYkHoA==
X-Received: by 2002:a05:6214:29ee:b0:4b1:c1d2:6635 with SMTP id jv14-20020a05621429ee00b004b1c1d26635mr2821399qvb.82.1665722563289;
        Thu, 13 Oct 2022 21:42:43 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:a669:acbb:c756:5d9a])
        by smtp.gmail.com with ESMTPSA id br15-20020a05620a460f00b006bbb07ebd83sm1498758qkb.108.2022.10.13.21.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 21:42:42 -0700 (PDT)
Date:   Thu, 13 Oct 2022 21:42:41 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     guoren@kernel.org, andriy.shevchenko@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <Y0jowX4zIZMMVc0H@yury-laptop>
References: <20221014030459.3272206-1-guoren@kernel.org>
 <20221014030459.3272206-2-guoren@kernel.org>
 <20221013203544.110a143c@kernel.org>
 <20221013203911.2705eccc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013203911.2705eccc@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 08:39:11PM -0700, Jakub Kicinski wrote:
> On Thu, 13 Oct 2022 20:35:44 -0700 Jakub Kicinski wrote:
> > Can we instead revert 854701ba4c and take the larger rework Yury 
> > has posted a week ago into net-next?
> 
> Oh, it was reposted today:
> 
> https://lore.kernel.org/all/20221013234349.1165689-2-yury.norov@gmail.com/
> 
> But we need a revert of 854701ba4c as well to cover the issue back up
> for 6.1, AFAIU.

The patch 854701ba4c is technically correct. I fixed most of warnings in
advance, but nobody can foresee everything, right? I expected some noise,
and now we have just a few things to fix. This is what for -rc releases
exist, didn't they?

I suggest to keep the patch, because this is the only way to make
cpumask_check()-related issues visible to people. If things will go as
they go now, I expect that -rc3 will be clean from cpumask_check()
warnings.

Thanks,
Yury
