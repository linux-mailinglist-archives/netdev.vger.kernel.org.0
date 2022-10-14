Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669735FE906
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJNGmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJNGml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:42:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABB11946EB;
        Thu, 13 Oct 2022 23:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3413FB82218;
        Fri, 14 Oct 2022 06:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9891C433B5;
        Fri, 14 Oct 2022 06:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665729756;
        bh=eW2HUck35u1qifMCTu3OfQoHmFkJZtQcrSUIJ/PJ4hA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hWbN1sm0QIwlff2tnplfIkJy+t70pfa9ted2ZMRnpcjQ7hcGYzGnQ9aRb/4BUxa6i
         7H+VP+nfm8yektekF1YHpqNuomGRUXvGVwYeG0ezwFA05O9YaM0818nqynh6P6khqQ
         7PKdLI+0iAieMc0K+7hp035CPURlKXbjVrAB4yo3RRHzrfM45GME/3ggSpkEV30uWn
         AVv1jB2dK9YRWm5tAM/D0IShvT50zZwOLFim9LxcW+uzsBCUgFJlmKbx1kd4MIdQ6z
         F6SfJ/hMTJ4EGwpKFBMnyK9WBESAdaAWlmEP3xI+MJJBINApl8qZ0tBDJF0KSaBjag
         W30bFcRpNiDlQ==
Received: by mail-oi1-f182.google.com with SMTP id w196so4131790oiw.8;
        Thu, 13 Oct 2022 23:42:36 -0700 (PDT)
X-Gm-Message-State: ACrzQf0aTldYF5FzKTyZjVU5aIV0VfUjXp/cj69yG+fTPXjwfsUuIA5T
        kHimie3uz0b5/NuQagzfbgDJMLQCac3COCNL0eI=
X-Google-Smtp-Source: AMsMyM666LQOO+rKhPSl0IyxA5zLp4Y0JaqfwQSUvyyUCZnEvSpPaTAz+nEGLq7ZXtTLJFnaSmS32QySgegFg+9FZQ4=
X-Received: by 2002:a05:6808:10c3:b0:354:db1e:c4a8 with SMTP id
 s3-20020a05680810c300b00354db1ec4a8mr5884742ois.112.1665729756010; Thu, 13
 Oct 2022 23:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-2-guoren@kernel.org>
 <20221013203544.110a143c@kernel.org> <20221013203911.2705eccc@kernel.org> <Y0jowX4zIZMMVc0H@yury-laptop>
In-Reply-To: <Y0jowX4zIZMMVc0H@yury-laptop>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 14:42:24 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR6BJMvoz+QhVDbG3Ho1xvMAwNLkmTCOByZxpymZfZJnQ@mail.gmail.com>
Message-ID: <CAJF2gTR6BJMvoz+QhVDbG3Ho1xvMAwNLkmTCOByZxpymZfZJnQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 12:42 PM Yury Norov <yury.norov@gmail.com> wrote:
>
> On Thu, Oct 13, 2022 at 08:39:11PM -0700, Jakub Kicinski wrote:
> > On Thu, 13 Oct 2022 20:35:44 -0700 Jakub Kicinski wrote:
> > > Can we instead revert 854701ba4c and take the larger rework Yury
> > > has posted a week ago into net-next?
> >
> > Oh, it was reposted today:
> >
> > https://lore.kernel.org/all/20221013234349.1165689-2-yury.norov@gmail.com/
> >
> > But we need a revert of 854701ba4c as well to cover the issue back up
> > for 6.1, AFAIU.
>
> The patch 854701ba4c is technically correct. I fixed most of warnings in
> advance, but nobody can foresee everything, right? I expected some noise,
> and now we have just a few things to fix. This is what for -rc releases
> exist, didn't they?
Your job is great, I just want to help with some fixes. Fixes them in
-rc would be a good point.

>
> I suggest to keep the patch, because this is the only way to make
> cpumask_check()-related issues visible to people. If things will go as
> they go now, I expect that -rc3 will be clean from cpumask_check()
> warnings.
>
> Thanks,
> Yury



-- 
Best Regards
 Guo Ren
