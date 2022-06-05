Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55A453DEAD
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348433AbiFEWkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 18:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiFEWka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 18:40:30 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C509F4A3D3;
        Sun,  5 Jun 2022 15:40:29 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id k6so6760485qkf.4;
        Sun, 05 Jun 2022 15:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oJwvaGKT8SUWFne2GVF30GAVMbGCcCQB/TRP9JaEXXc=;
        b=Er/mgnCYWFqYei8Xap7gF8LCCxEcDbQ4YP9T6p+F7o74YPGLBlHLJEy4ZQ4AV+oW0m
         HO5ME3C5CUaolnar2S/YoK4fpjLucBfumkoBeUR8JXPaRMlwh3P2v4rmVWFXUETT7Th0
         7DGbBghLO13a8m5U3MLe6JnNrcBDJEhvAn8D5DBbfAcUGWkFeqzaD+mNbG8Kyhkg4tR8
         V45no08OXTqF6tToeKsn62qy3OjVHB4ad0Mga/sJVztI74X6pv/K2S6aw1aZb8qcY1Il
         SNPHXoT5BmLhp901EzfvlHAHKcRkFlBnhuA/Ya6+VJ+BvTWfHd8M55IJyAXUaPPCS30v
         24Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJwvaGKT8SUWFne2GVF30GAVMbGCcCQB/TRP9JaEXXc=;
        b=tK+CTXvJzMloruK7auumpfDmNhUh2w+k4kwME8jNJ0muKZ79tMi0zYjrqCEy/yc6fl
         Vn7rlYboJPbhAYsqql2C3rN/kTQIZASRkUk46ZEIcA9gHe1PbfrzFz3BX7bXPdQ/QfsZ
         ssrJif3Jw/NvmEaOFO1K9SeOhODLceDvZJeJZjp5bpoB/9YlA5Q3SUyCsZ0+pN0K/enm
         MjcpX0KuKhLNuSymSytjaXHhemlRHO7DoaJK6eTgoTdhe3M/pkEPqWoPVvJWCQxvnyxJ
         +GAZBNtnvTvTku0Bv2XXouyqB4LSDH23pDO8drZp7eW83RsmM2Q8whkZcGCbZz7xVgkw
         6nDw==
X-Gm-Message-State: AOAM532z6G1Wq3WGtRJWopY9idihjVW7Cb2WYpquECzrFxxEXQvFMDJB
        +dhw4YmMZijDfbhw9KH2B18=
X-Google-Smtp-Source: ABdhPJyWm/hFkdThzopZDwcMz7nAWT8LrdkA/rUdyFXcHuJFjiaGHRgmU/+qt5448wUl0n1pNiWW+A==
X-Received: by 2002:a37:6614:0:b0:6a6:9639:77f3 with SMTP id a20-20020a376614000000b006a6963977f3mr10100125qkc.516.1654468827768;
        Sun, 05 Jun 2022 15:40:27 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:7d8b:f1fe:e4c6:2059])
        by smtp.gmail.com with ESMTPSA id s16-20020ac85ed0000000b00304e1709b1esm4991031qtx.43.2022.06.05.15.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 15:40:27 -0700 (PDT)
Date:   Sun, 5 Jun 2022 15:40:27 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the bluetooth tree
Message-ID: <Yp0w21pH4R6WaC1R@yury-laptop>
References: <20220516175757.6d9f47b3@canb.auug.org.au>
 <20220524082256.3b8033a9@canb.auug.org.au>
 <20220606080631.0c3014f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606080631.0c3014f2@canb.auug.org.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 08:06:31AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 24 May 2022 08:22:56 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Mon, 16 May 2022 17:57:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > After merging the bluetooth tree, today's linux-next build (arm
> > > multi_v7_defconfig) produced this warning:
> > > 
> > > In file included from include/linux/cpumask.h:12,
> > >                  from include/linux/mm_types_task.h:14,
> > >                  from include/linux/mm_types.h:5,
> > >                  from include/linux/buildid.h:5,
> > >                  from include/linux/module.h:14,
> > >                  from net/bluetooth/mgmt.c:27:
> > > In function 'bitmap_copy',
> > >     inlined from 'bitmap_copy_clear_tail' at include/linux/bitmap.h:270:2,
> > >     inlined from 'bitmap_from_u64' at include/linux/bitmap.h:622:2,
> > >     inlined from 'set_device_flags' at net/bluetooth/mgmt.c:4534:4:
> > > include/linux/bitmap.h:261:9: warning: 'memcpy' forming offset [4, 7] is out of the bounds [0, 4] of object 'flags' with type 'long unsigned int[1]' [-Warray-bounds]
> > >   261 |         memcpy(dst, src, len);
> > >       |         ^~~~~~~~~~~~~~~~~~~~~
> > > In file included from include/linux/kasan-checks.h:5,
> > >                  from include/asm-generic/rwonce.h:26,
> > >                  from ./arch/arm/include/generated/asm/rwonce.h:1,
> > >                  from include/linux/compiler.h:248,
> > >                  from include/linux/build_bug.h:5,
> > >                  from include/linux/container_of.h:5,
> > >                  from include/linux/list.h:5,
> > >                  from include/linux/module.h:12,
> > >                  from net/bluetooth/mgmt.c:27:
> > > net/bluetooth/mgmt.c: In function 'set_device_flags':
> > > net/bluetooth/mgmt.c:4532:40: note: 'flags' declared here
> > >  4532 |                         DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
> > >       |                                        ^~~~~
> > > include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITMAP'
> > >    11 |         unsigned long name[BITS_TO_LONGS(bits)]
> > >       |                       ^~~~
> > > 
> > > Introduced by commit
> > > 
> > >   a9a347655d22 ("Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLAG_REMOTE_WAKEUP")
> > > 
> > > Bitmaps consist of unsigned longs (in this case 32 bits) ...
> > > 
> > > (This warning only happens due to chnges in the bitmap tree.)  
> > 
> > I still got this warning yesterday ...
> 
> And today, I get this warning when build Linus' tree :-(

Hi Stephen,

I completely forgot about this bug, and sent a quick fix when this
was spotted by Sudip [1]. Linus proposed another fix [2] that drops
bitmap API in net/bluetooth/mgmt.c.

I would prefer Linus' version, and this is the way I already suggested
to Luiz before in this thread.

Thanks,
Yury

[1] https://lore.kernel.org/lkml/YpyJ9qTNHJzz0FHY@debian/t/
[2] https://lore.kernel.org/lkml/CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com/T/#mcf29754f405443ca7d2a18db863c7a20439bd5a0
