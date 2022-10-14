Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFB55FE6AE
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 03:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiJNBn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 21:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJNBnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 21:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27CD1A2093;
        Thu, 13 Oct 2022 18:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4458B821B6;
        Fri, 14 Oct 2022 01:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83227C43141;
        Fri, 14 Oct 2022 01:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665711825;
        bh=tO5YXbZYX7MkvTGla4xgsWhhc7K+nSXU2rcqtEXJPbM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FfdLanWhbCC6Pwuq8gMpuUCWnmBjwNIVxMFbTWtsP3an75vxD/kkf6BA8d929g1d/
         YguGTJWZlUhhVdsbsbaJTubE6aoUw8vF7ZXRDZI94C/l5U4m4QDT1kIHwLHxP0WgJT
         uQOrHTwvu94+vAQUmj1ptZroi/TOEHygwq/YrJe3KH+rG+63BclaFU7e6DFhHZPkG+
         R4PHqmUlTcCXiTtHmdha+c6RY+etxEvIDuzKvKS2ArNpYH1c5plyVFBozPY45lsrc3
         dKgvwqy81WLiTFXbXD/j3mqhTLQuv8uiKEFvd+YrPFYWEbYIXsMlwfSUNwyEphr1L0
         VvwHrkItIgQtw==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1324e7a1284so4357926fac.10;
        Thu, 13 Oct 2022 18:43:45 -0700 (PDT)
X-Gm-Message-State: ACrzQf3dQUvOAOz6IFITTqBhNMzHM6+IU++qWoWMwGxMsFlQk29O7hPD
        G2QfKgJq/vTrloDkJGA3P/8WvbDAf547F+aMO5o=
X-Google-Smtp-Source: AMsMyM5sinHvVoQirZtjmtwVMnLjGe4szW3+SDH8vYDXaM5Yk7PEKmiMIF4XYFoCxNylcnSnO8AI+9KMRcCa5OlJMdA=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr7258893oah.112.1665711824561; Thu, 13
 Oct 2022 18:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221013163857.3086718-1-guoren@kernel.org> <CAJF2gTSu_SDGEYZxW7nfY8B=k_hkdxKy2TsK7C5v7cqM7qrKRA@mail.gmail.com>
 <CAAH8bW8FArQL=cVex=ZFOFhBC-9JvKNtdwCwjVYexe3qWehLKw@mail.gmail.com>
In-Reply-To: <CAAH8bW8FArQL=cVex=ZFOFhBC-9JvKNtdwCwjVYexe3qWehLKw@mail.gmail.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 09:43:32 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSrxGWDi9zeABWg94-+Xn8GHmqeB_d-KWkdvF-a-aa-5w@mail.gmail.com>
Message-ID: <CAJF2gTSrxGWDi9zeABWg94-+Xn8GHmqeB_d-KWkdvF-a-aa-5w@mail.gmail.com>
Subject: Re: [PATCH] net: Fixup netif_attrmask_next_and warning
To:     Yury Norov <yury.norov@gmail.com>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
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

On Fri, Oct 14, 2022 at 1:57 AM Yury Norov <yury.norov@gmail.com> wrote:
>
> > > Fixes: 944c417daeb6 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")
> >
> > Sorry, the Fixes commit is 854701ba4c39.
>
> 1. it doesn't fix my commit. There's nothing to fix. It fixes net code.
Okay, I would change to:
Fixes: 80d19669ecd3 ("net: Refactor XPS for CPUs and Rx queues")

> 2. https://lore.kernel.org/all/YznDSKbiDI99Om23@yury-laptop/t/#mf3a04206802c50ee7f5900e968aa03abdeb49c68



-- 
Best Regards
 Guo Ren
