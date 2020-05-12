Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716DC1CEC16
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 06:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELEdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 00:33:55 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:44719 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgELEdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 00:33:54 -0400
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 04C4XULu017049;
        Tue, 12 May 2020 13:33:30 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 04C4XULu017049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1589258011;
        bh=X8E0BsdNnAH/9f9mif8AeRKsq9/U3UOw8vdDnh73hZY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HRm5iDvRudny47jZEW6nbjZBC8jYyl7bJm3WsIC0Q8L55tqycPTJH1Be/490UFFVG
         WGQuw91fwUYY3X0/2OUBWUU97I3OCedIcI08hUC7N77sCB3EHg6YH1tM2lB1Y0efEn
         dWn370dTKNZk45nC9sGyuxvpVKeg7FysonvvQhRvNtwgXvJCSt6TbfqqimK0mbzA55
         bM/CnBonuloavBRJRDzd8YzPDosfD80LWwhfRbMMEtsDYGcUq0ZNV3B4gPjyzHK5wc
         sdX0aEpL8SmMHjvi7KBmtr9OEufdaZldWuRs0S8SntqUQtc2mgLCeG5pxuvfQOK0zT
         oUEVm1LtQI8gQ==
X-Nifty-SrcIP: [209.85.217.50]
Received: by mail-vs1-f50.google.com with SMTP id u12so7085212vsq.0;
        Mon, 11 May 2020 21:33:30 -0700 (PDT)
X-Gm-Message-State: AGi0PuYIuQ+zjY84paQpNNeXAf1UOWFLBd2RWSnnxPGCum+3hTnxXzd3
        Mv3Dk4UuUOt9i5KRb0h6NjN8uAPIARrsrrbqqdU=
X-Google-Smtp-Source: APiQypJQeAVBO+ffqsKm/b2wDSRazG3qjUmDMskUkK7DV6vGnFqjWmE17wnRfjZnMEcFqpB5W4EIPEmqRnN5imXL0lk=
X-Received: by 2002:a05:6102:3c7:: with SMTP id n7mr13487692vsq.179.1589258009534;
 Mon, 11 May 2020 21:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200509073915.860588-1-masahiroy@kernel.org> <CAADnVQJvJWwziwDj0ZgPc02iHNNk8EJetDqNZ6SoWq045C-gXQ@mail.gmail.com>
In-Reply-To: <CAADnVQJvJWwziwDj0ZgPc02iHNNk8EJetDqNZ6SoWq045C-gXQ@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 12 May 2020 13:32:53 +0900
X-Gmail-Original-Message-ID: <CAK7LNARg96EfyZTHdDDToGqwhaokaG-PQCOyCHL1id14YxY3-A@mail.gmail.com>
Message-ID: <CAK7LNARg96EfyZTHdDDToGqwhaokaG-PQCOyCHL1id14YxY3-A@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: check if $(CC) can static link in Kconfig
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 10:04 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, May 9, 2020 at 12:40 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > On Fedora, linking static libraries requires the glibc-static RPM
> > package, which is not part of the glibc-devel package.
> >
> > CONFIG_CC_CAN_LINK does not check the capability of static linking,
> > so you can enable CONFIG_BPFILTER_UMH, then fail to build.
> >
> >   HOSTLD  net/bpfilter/bpfilter_umh
> > /usr/bin/ld: cannot find -lc
> > collect2: error: ld returned 1 exit status
> >
> > Add CONFIG_CC_CAN_LINK_STATIC, and make CONFIG_BPFILTER_UMH depend
> > on it.
> >
> > Reported-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Thanks!
> Acked-by: Alexei Starovoitov <ast@kernel.org>

Applied to linux-kbuild
with Alexei's Ack.


-- 
Best Regards
Masahiro Yamada
