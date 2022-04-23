Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC1350C8CD
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiDWJvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiDWJvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:51:08 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3EFF5;
        Sat, 23 Apr 2022 02:48:11 -0700 (PDT)
Received: from mail-wm1-f50.google.com ([209.85.128.50]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mdvyi-1oHoND33Ek-00b06H; Sat, 23 Apr 2022 11:48:09 +0200
Received: by mail-wm1-f50.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso9458750wme.5;
        Sat, 23 Apr 2022 02:48:09 -0700 (PDT)
X-Gm-Message-State: AOAM532mkaZkI76BSgwQ1G5OuUdvION8dU+2nNRM6n0FEmBSrtS2IHGw
        FddRzAQcH35evr/ohZ7bJW2E8JZbwNM7dkBQ3Hg=
X-Google-Smtp-Source: ABdhPJzB571QS23ads9/X6bqp8kn5uvfGAj6Ip74WQj7sqmxjMCA85CiNrM4H8Eqf/GMMA0WHQ6q++BsxTECp2b2his=
X-Received: by 2002:a7b:ce15:0:b0:38e:b7b0:79be with SMTP id
 m21-20020a7bce15000000b0038eb7b079bemr7890160wmc.71.1650707289338; Sat, 23
 Apr 2022 02:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220421070440.1282704-1-hch@lst.de>
In-Reply-To: <20220421070440.1282704-1-hch@lst.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 23 Apr 2022 11:47:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2Tw+fdf-dTKfu+aFFv010u50+LhiiVBRRujfSFNrqbEA@mail.gmail.com>
Message-ID: <CAK8P3a2Tw+fdf-dTKfu+aFFv010u50+LhiiVBRRujfSFNrqbEA@mail.gmail.com>
Subject: Re: [PATCH] net: unexport csum_and_copy_{from,to}_user
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Networking <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        alpha <linux-alpha@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:albdKOiXIS0kHHBHYY/wSNMr7J/VHZ4po6jMFPsFdo/ckkLmRZa
 1VoBD2lMusGXaTOwKgePBGAhmIIgg4ksXVIhQxQnCSs95SoLNISfvuy4D40bYKb27RKGdQI
 MBQEYj/TSdoQ2SGoHwx2yo8dSb4WNYFlScICDWv3K4qjj25L1+QaRDujS/YE7nt/ZcjDJv+
 g6zIVbk2QNn3vSaIawtvw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/UwY+B2U1fQ=:/s5taf5kqaEeN/04c0o4ZL
 tOjTQMMUPayGnj3PlwbTCyCZn/kZQNCI1ks8gqpkpaFdbqd9fKfyZr9SCIV2Pd7DiYfXhv9Q0
 SnFnrXvpkZLtZdtm6TR8qKk7Sr3cxJ8SqQALjJlwahu3NxIf7CGHERqQX3wpVyQohoXalcIyj
 L6iPMtQz0yBlEeavOU+sH15UXllHxXH6Ptqumxsqt6gSK6h/LqZCz6feQAHZh8WCSdTJqtXUm
 K9ys7IZRng53Y6cjdZW4dkay1Lp1OjQqqq2ngwhB8BIB4u0GIthybNMCXF7S+etW4yM6hD9Dz
 8RfXJzcgO7MEUhbnzUIUqx77ebsF8XKdErGaXYjCqnAwS1iy7lGLbSlGAngsOve2W1/j+r83o
 1K/jjhU4v7No5EEh9EIuSes2Oga6dE5unUkjz+jiRNV/3KWomV8TQWWTpMMG9rFJAlGlPNo6z
 NAlXy/FGeIrkysBG/Yrxt3CGWmysxKp7MHp1VgyR66GAoNF+5r3YzMEBrEd6Ku0e1219qSp9x
 rFPB9zl+vCXhDthB3+gljgOu5GdF+20eJYGZNIDMIo0Mi7PRDF8G2gqh8e6Vx2hxa4ivt4VlL
 WJV2RVfSzOdOiiBuatQO2FsUweKVq/xAXmqDAXnPo/Au6usY+/I1HuKT42hmG8T3NfruVvZPs
 OtRnxz2+OzWS6UETIsr4Kpx+NqATOeB1qN2CXDC+6iY3a2HvZ1TPw5cJjDWKphxNY4O+z80Dp
 xsUkBWMxsTGebKuCzONT30s16j4s51kZfbiC6rHDxkpQU0P+f/X0ylEy7Vvu/bc7qfEA8HMNX
 nN/hJSWiE1lYASQ6K5955iUCwkiwdFN3ZzayU0/qJ1GI3n4rBM=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 9:04 AM Christoph Hellwig <hch@lst.de> wrote:
>
> csum_and_copy_from_user and csum_and_copy_to_user are exported by
> a few architectures, but not actually used in modular code.  Drop
> the exports.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
