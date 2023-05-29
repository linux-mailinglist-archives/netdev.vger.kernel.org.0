Return-Path: <netdev+bounces-6005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EBA714579
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E0ED1C20967
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700A4ECB;
	Mon, 29 May 2023 07:28:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634F22102
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:28:20 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F4AAD;
	Mon, 29 May 2023 00:28:18 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2af2451b3f1so30811921fa.2;
        Mon, 29 May 2023 00:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685345297; x=1687937297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pf4+1Iwu9vGygJo1X8C8/omiMMYvUuiv7Xu9BAspAOo=;
        b=noQYYPR5OLpTz67+derlxgYugG8q6CoOqE+qaM1z4ytstzOmfjKtDqygKby6xpEVZ/
         IBJNv5hP9WbZ+cLQBs8vC5ed8CGeS0CW5R0CWHeB4uN00UcwTeRg0dS4HS9T34hzC44S
         0repHUz8wvkrRm9OlIYAdpRJVnwqqZB8TkaqNq4Kh6mhgSDjmVlcd1NVPuoYYFC2qOYp
         TyfXzn2L3GlQBATK/wsVLBOAVBO31qWB4MNP5SMcnbUIC29apjGhyGSnlNV7a2xYxYPC
         QT522EmiRRS2Z0ztfqe2fzBqfeXZRWE9t07eVjJ1bPNhmnoREeCcyyBxJ6LFWvPpuH4o
         Pibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685345297; x=1687937297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pf4+1Iwu9vGygJo1X8C8/omiMMYvUuiv7Xu9BAspAOo=;
        b=KJaua8VUxEhO9hFKMfjvkG9wFbp+SoNv+MeAKRZ/OhaLz8bZz5Y2o5qxxoFdoN+98M
         QRNuCpoKqv9rVYAeHDnYkz+oeJcMgHKOnZXRq5NI2J5DOkYE7rgk65ddD/bB/94zbxRs
         OqW2HX2Lse0jwJ/QXmU8VlMyQg5xJAI/nQy+JRwNu3CkNws8eoE86KZjb+Xc4836z9MU
         Q9sj9ZkP4QhFW+e57ZOysDGSgZk22M9cgt0M9KLWBs391IRRS+DU9NsyHz47CYFYMioI
         4iik6ldGOo2IBhahVSr/qs9o+684SVvumpdODsRrcAYDKoKnp4YldDapWlo197YBWMKE
         sNSQ==
X-Gm-Message-State: AC+VfDyYxZIDdRiYjV1TRAjAUq1AIjwiJMOYk0K8Vba1THi0mQE1rKZN
	1pMcw1UyohfNGMQU8g/qsM16Rj4dx8GQWUBKA9Q=
X-Google-Smtp-Source: ACHHUZ4NJPrBbzGRi2yeX0XLSDCJVY0qYpIUysxYUiTQv/oUtl2JS5BF724ts8ybo0i6AelWPdtd2oetH/M81Nigecw=
X-Received: by 2002:a2e:9108:0:b0:2af:1eee:84af with SMTP id
 m8-20020a2e9108000000b002af1eee84afmr3458498ljg.26.1685345296774; Mon, 29 May
 2023 00:28:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-2-liangchen.linux@gmail.com>
 <202305262334.GiFQ3wpG-lkp@intel.com> <20230528022658-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230528022658-mutt-send-email-mst@kernel.org>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Mon, 29 May 2023 15:28:04 +0800
Message-ID: <CAKhg4t+xof9LiFbd2bJX03X=RL0uVZAxYbM5FQb106HgqWVYFA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kernel test robot <lkp@intel.com>, jasowang@redhat.com, oe-kbuild-all@lists.linux.dev, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com, kuba@kernel.org, 
	edumazet@google.com, davem@davemloft.net, pabeni@redhat.com, 
	alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 2:27=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Sat, May 27, 2023 at 12:11:25AM +0800, kernel test robot wrote:
> > Hi Liang,
> >
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on net-next/main]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Liang-Chen/virti=
o_net-Add-page_pool-support-to-improve-performance/20230526-135805
> > base:   net-next/main
> > patch link:    https://lore.kernel.org/r/20230526054621.18371-2-liangch=
en.linux%40gmail.com
> > patch subject: [PATCH net-next 2/5] virtio_net: Add page_pool support t=
o improve performance
> > config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230=
526/202305262334.GiFQ3wpG-lkp@intel.com/config)
> > compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
> > reproduce (this is a W=3D1 build):
> >         # https://github.com/intel-lab-lkp/linux/commit/bfba563f43bba37=
181d8502cb2e566c32f96ec9e
> >         git remote add linux-review https://github.com/intel-lab-lkp/li=
nux
> >         git fetch --no-tags linux-review Liang-Chen/virtio_net-Add-page=
_pool-support-to-improve-performance/20230526-135805
> >         git checkout bfba563f43bba37181d8502cb2e566c32f96ec9e
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         make W=3D1 O=3Dbuild_dir ARCH=3Dx86_64 olddefconfig
> >         make W=3D1 O=3Dbuild_dir ARCH=3Dx86_64 SHELL=3D/bin/bash
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202305262334.GiFQ3wpG-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >    ld: vmlinux.o: in function `virtnet_find_vqs':
> > >> virtio_net.c:(.text+0x901fb5): undefined reference to `page_pool_cre=
ate'
> >    ld: vmlinux.o: in function `add_recvbuf_mergeable.isra.0':
> > >> virtio_net.c:(.text+0x905618): undefined reference to `page_pool_all=
oc_pages'
> >    ld: vmlinux.o: in function `xdp_linearize_page':
> >    virtio_net.c:(.text+0x906b6b): undefined reference to `page_pool_all=
oc_pages'
> >    ld: vmlinux.o: in function `mergeable_xdp_get_buf.isra.0':
> >    virtio_net.c:(.text+0x90728f): undefined reference to `page_pool_all=
oc_pages'
>
>
> you need to tweak Kconfig to select PAGE_POOL I think.
>

Sure, thanks!


> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
>

