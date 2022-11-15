Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5777629D4C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiKOPZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKOPZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:25:50 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E2F2D769;
        Tue, 15 Nov 2022 07:25:49 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-13b23e29e36so16572086fac.8;
        Tue, 15 Nov 2022 07:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uf8eu5IHbsDfWimmQsuwfxum/RNqHnjNqe3CsnW4ODc=;
        b=ikmF9JxUpBONmpcB4mzORfWBa/U1MTdwn3R1w2i5sutlkkgDz2uf68CziFe1RGek0H
         ymxBrI5njHy6B+kik73RyUlRCgZfD7sIFThovrodiuWz+5+yNab4qwn3Uds5107w5qC2
         mw8RsuqzuKJ5NwUC9kyOGIs8KX7d9S3xfLIaA44i17Fee0LUFnj95K9sC9OzRWD7zsJx
         qGaRROVBmJgg5d5YPjjlhTH0/8mrTgAtmE/L+EnPFypNw6LDMi90wh7u3YHEGOlG0Y65
         hBHByElsZnzLV0chPGnDX18wALjp+3sby4TdwBxbU4gu0SZpGp2v1cAl/84NVr1Y+2Ud
         1faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uf8eu5IHbsDfWimmQsuwfxum/RNqHnjNqe3CsnW4ODc=;
        b=5RraMc2qMETfvytdb5f/iUcZivM8V45TORqocx9VrISBaOMch9lOqjawmU1rE2vjQZ
         eiGDvIVoiNPiyoM3tyOyQ5m5ZpAErtNoDGIzYX4D+MfWcDNdO751U+J3YCuIdVmNwFl5
         cmAG7xRZcm91LrTY/xArnL3HUTl96qD0sUdi0t/Sl47DsE+QKdxVBM9biyeh8Fzt9K1x
         Alx0FHibd40oCk7GvEFejv1DNf0RVtQOTk503SNzYpVkhHe4BCnEBpzYkcouDpBB8o7U
         Pv1NsemI02v8b5uH+7h/ZxY52gfodQDEgvgphtJnaz7nZkVMIBRGqCVydFR4VljZ1+lp
         z8ag==
X-Gm-Message-State: ANoB5pl9ztco3b/UqkodPhNR51k2LgDOh3WFlPOx0W7wf79p71ig/5zs
        9TWZjkRI50WhmlwPkL8RJQMgvX6R1HRx6ujiRc7Xtpt1LU0=
X-Google-Smtp-Source: AA0mqf6axPAl4K74OTmpMsym8LhatuCUAC7ETdoLLJHpfWJjYEZyOp1QCQXXRwmLeNZYB7dInHo7safsXwykqiqyhnY=
X-Received: by 2002:a05:6870:5894:b0:13b:5fff:1d84 with SMTP id
 be20-20020a056870589400b0013b5fff1d84mr631074oab.190.1668525949001; Tue, 15
 Nov 2022 07:25:49 -0800 (PST)
MIME-Version: 1.0
References: <86dfdc49613ca8a8a6a3d7c7cf2e7bd8207338f2.1668357542.git.lucien.xin@gmail.com>
 <202211140427.Bd5Zjdbe-lkp@intel.com> <CADvbK_ezonDWaT5fUdc0w5+y91PEaHc8YveV8KGyBC7sH3fWmw@mail.gmail.com>
 <cf4ba8ec52db5fabf61032a355d2a2b57f9bb0d5.camel@redhat.com>
In-Reply-To: <cf4ba8ec52db5fabf61032a355d2a2b57f9bb0d5.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 15 Nov 2022 10:25:15 -0500
Message-ID: <CADvbK_cvS4vJYb_jW=W20bXTpV0Fu4=eSsPEsO4pM5NLGfmwdA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/7] sctp: add dif and sdif check in asoc and ep lookup
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     kernel test robot <lkp@intel.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 5:19 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-11-14 at 21:38 -0500, Xin Long wrote:
> > On Sun, Nov 13, 2022 at 3:15 PM kernel test robot <lkp@intel.com> wrote:
> > >
> > > Hi Xin,
> > >
> > > Thank you for the patch! Yet something to improve:
> > >
> > > [auto build test ERROR on net-next/master]
> > >
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Xin-Long/sctp-support-vrf-processing/20221114-004540
> > > patch link:    https://lore.kernel.org/r/86dfdc49613ca8a8a6a3d7c7cf2e7bd8207338f2.1668357542.git.lucien.xin%40gmail.com
> > > patch subject: [PATCH net-next 5/7] sctp: add dif and sdif check in asoc and ep lookup
> > > config: arm-randconfig-r034-20221114
> > > compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 463da45892e2d2a262277b91b96f5f8c05dc25d0)
> > > reproduce (this is a W=1 build):
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # install arm cross compiling tool for clang build
> > >         # apt-get install binutils-arm-linux-gnueabi
> > >         # https://github.com/intel-lab-lkp/linux/commit/6129dc2e382c6e2d3198f6c32cc1f750a15a77ab
> > >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> > >         git fetch --no-tags linux-review Xin-Long/sctp-support-vrf-processing/20221114-004540
> > >         git checkout 6129dc2e382c6e2d3198f6c32cc1f750a15a77ab
> > >         # save the config file
> > >         mkdir build_dir && cp config build_dir/.config
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/openvswitch/
> > >
> > > If you fix the issue, kindly add following tag where applicable
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > >    In file included from net/openvswitch/actions.c:26:
> > >    In file included from include/net/sctp/checksum.h:27:
> > > > > include/net/sctp/sctp.h:686:35: error: no member named 'sctp' in 'struct net'
> > >            l3mdev_accept = !!READ_ONCE(net->sctp.l3mdev_accept);
> > >                                        ~~~  ^
> > The build disabled IP_SCTP, while net/sctp/sctp.h is included in other modules.
> > Instead of "net/sctp/sctp.h", "linux/sctp.h" should be included, I
> > will send another patch series to fix them.
> >
> > We do NOT need to change anything in this series.
>
> 'net->sctp' is defined only when CONFIG_SCTP is enabled. AFAICS the new
> helper introduced by this patch is the only function in sctp.h
> accessing 'net->sctp', so prior to this patch including sctp.h with
>
> # CONFIG_SCTP is not set
>
> was apparently safe, while not it breaks the build.
>
> I think the issue should be addressed here.
I just think it's not correct to include "net/sctp/sctp.h" if one doesn't
depend on SCTP module. I'd rather consider "net/sctp/sctp.h" as
part of SCTP module.

I can fix it by simply moving this function to like net/sctp/input.c, it
just doesn't look good. Anyway, maybe I will do it to solve the build
error in the current patch first.

Thanks.

>
> Thanks,
>
> Paolo
>
