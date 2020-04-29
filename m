Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C681BD252
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 04:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgD2Cj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 22:39:27 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:38533 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD2Cj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 22:39:26 -0400
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 03T2cw95003502;
        Wed, 29 Apr 2020 11:38:59 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 03T2cw95003502
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1588127939;
        bh=kIACvKnbNQjmmvD9XNnXXeDcJn3YI4tRb66fZvzH6o0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1cVlTgtdT4Ze4na5pj7IAc2NYgNk2ylZxPHOfpt61kpTZIbSilpO7JhIq30479+FY
         nlw6qbetxb6UzLkfMk0q39EBaAFGpppH1WTvlZJNZ/R7R8U/IqkB82fno6HNhEQjeA
         DVGKsjqI9rBAU75zCuBhh1Ys0FhcNJeWx/PRIH4lrlEgG+M8Sdaf9ZMSClBXtommLX
         8kkCtxlK3KB7/1CEpnheJblngxDGCUckcUhCapePv+/kAz8/ihRy85BB15osC2Fp3Y
         HWz6lQAfDrhWJsQXaFyfheRKbUp8t8WJCiHZc+o83HKnNRR5ujg+zI8mRPlVFPkdqk
         rgF5kTwNhPASw==
X-Nifty-SrcIP: [209.85.217.42]
Received: by mail-vs1-f42.google.com with SMTP id s11so357926vsm.3;
        Tue, 28 Apr 2020 19:38:59 -0700 (PDT)
X-Gm-Message-State: AGi0Pua2LuB2zvD8DI0EYTyDVh3qUAIx/Cs4x3I0+0BAZjoJIOJmJEDA
        mrji9wueqgWUrUgmk/k9pGfUjRyrSal38HhULFo=
X-Google-Smtp-Source: APiQypL9CzoFbaf4j03sWX7eNvmAC6tL/Lcuadex+fAZ5CS6CzTX3uUDunisReRWfuw07vnycbUbrt1H7bvxqgJy6Zg=
X-Received: by 2002:a67:e94d:: with SMTP id p13mr23892835vso.215.1588127938122;
 Tue, 28 Apr 2020 19:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200423073929.127521-1-masahiroy@kernel.org> <20200425115303.GA10048@ravnborg.org>
In-Reply-To: <20200425115303.GA10048@ravnborg.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 29 Apr 2020 11:38:22 +0900
X-Gmail-Original-Message-ID: <CAK7LNARRxS6nnbBAa495Bh4nCdDAixinpMG1Tn6SV_w38uOzdg@mail.gmail.com>
Message-ID: <CAK7LNARRxS6nnbBAa495Bh4nCdDAixinpMG1Tn6SV_w38uOzdg@mail.gmail.com>
Subject: Re: [PATCH 00/16] kbuild: support 'userprogs' syntax
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Yonghong Song <yhs@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sam,

On Sat, Apr 25, 2020 at 8:53 PM Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Hi Masahiro
>
> On Thu, Apr 23, 2020 at 04:39:13PM +0900, Masahiro Yamada wrote:
> >
> > Several Makefiles use 'hostprogs' for building the code for
> > the host architecture is not appropriate.
> >
> > This is just because Kbuild does not provide the syntax to do it.
> >
> > This series introduce 'userprogs' syntax and use it from
> > sample and bpf Makefiles.
> >
> > Sam worked on this in 2014.
> > https://lkml.org/lkml/2014/7/13/154
>
> I wonder how you managed to dig that up, but thanks for the reference.


I just remembered your work back in 2014.

I did not remember the patch title exactly,
but I searched for 'From: Sam Ravnborg' and
'To: linux-kbuild@vger.kernel.org' in my mail box.




-- 
Best Regards
Masahiro Yamada
